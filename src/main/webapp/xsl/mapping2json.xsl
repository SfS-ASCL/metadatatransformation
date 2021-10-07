<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    version="3.0">
    <!-- <xsl:output method="text" encoding="utf-8"/> -->

    <xsl:variable name="Filename" select="replace(//*:MdProfile, ':', '')"/>
    <xsl:variable name="CMDIProfile" select="document(string-join(('./MetaDataTransformer_CMDI_Profiles/', $Filename, '.xml')))"/>
    <!--<xsl:variable name="CMDIProfile" select="document('./clarin.eucr1p_1527668176122.xml')"/>-->
    <xsl:variable name="Mappings" select="document('/usr/local/tomcat/webapps/metadtrans-1.0/mapping.xml')"/>
    <xsl:variable name="root" select="/"/>

    <!-- set context -->
    <xsl:template match="/*[node()]" name="Mapping2JSON">
        <xsl:variable name="Profile" select="//*[local-name() = 'MdProfile']"/>
        <!--<xsl:text>{</xsl:text>-->

        <xsl:variable name="ProfileMapping"
            select="$Mappings//Profiles/child::node()[text() = $Profile]/../.. | ($Mappings//DataSet[1])[not($Mappings//Profiles/child::node()[text() = $Profile]/../..)]"/>

        <xsl:value-of select="$ProfileMapping/Context/text()"/>
        <xsl:text>, "@type": ["</xsl:text>
        <xsl:value-of select="$ProfileMapping/name()"/>
        <xsl:text>", "</xsl:text>
        <xsl:value-of select="$Profile"/>
        <xsl:text>"] </xsl:text>
        <xsl:apply-templates select="$ProfileMapping/Mapping/*" mode="mapping"/>
        <!--<xsl:text>}</xsl:text>-->
    </xsl:template>

    <!-- set JSON Object key, as well as deciding what needs to follow (list, object, text) -->
    <xsl:template match="*" mode="mapping" name="mapping">
        <xsl:param name="contextNode" select="$root"/>

        <xsl:variable name="objectKey">
            <xsl:if test="name() != 'expandPattern'">
                <xsl:text>"</xsl:text>
                <xsl:if test="name() = 'id'">
                    <xsl:text>@</xsl:text>
                </xsl:if>
                <xsl:value-of select="name()"/>
                <xsl:text>": </xsl:text>
            </xsl:if>
        </xsl:variable>

        <xsl:variable name="object">
            <xsl:choose>
                <xsl:when test="@*">
                    <!-- set object value -->
                    <xsl:variable name="objectValue">
                        <xsl:call-template name="obj-content">
                            <xsl:with-param name="contextNodeP" select="$contextNode"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:if test="$objectValue != ''">
                        <xsl:call-template name="setComma"/>
                        <xsl:value-of select="$objectKey"/>
                        <xsl:value-of select="$objectValue"/>
                    </xsl:if>
                </xsl:when>
                <!-- set object value for expandPattern cases -->
                <xsl:when test="name() = 'expandPattern'">
                    <xsl:variable name="objectValue">
                        <xsl:call-template name="expansion">
                            <xsl:with-param name="contextNodeP" select="$contextNode"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:if test="$objectValue != ''">
                        <xsl:call-template name="setComma"/>
                        <xsl:value-of select="$objectKey"/>
                        <xsl:value-of select="$objectValue"/>
                    </xsl:if>
                </xsl:when>
                <!-- get object value (actual text) -->
                <xsl:otherwise>
                    <!-- set object value for <concept> nodes (if not blacklisted) -->
                    <xsl:variable name="objectValueConcept">
                        <xsl:if test="not(.//blacklistProfile[contains(., $root//*:MdProfile/text())])">
                            <xsl:text>[</xsl:text>
                            <xsl:for-each select=".//concept">
                                <xsl:variable name="URIName" select="($CMDIProfile//*[@ConceptLink = current()/text()]/@name)[1]"/>
                                <xsl:variable name="values" select="$root//*[local-name() = $URIName and text() != '' and not(child::*)]"/>
                                <xsl:call-template name="text">
                                    <xsl:with-param name="CMDIElement" select="$values"/>
                                </xsl:call-template>
                                <xsl:if test="position() &lt; last() and $values != ''">, </xsl:if>
                            </xsl:for-each>
                            <xsl:text>]</xsl:text>
                        </xsl:if>
                    </xsl:variable>

                    <xsl:if test="$objectValueConcept != '[]' and $objectValueConcept != ''">
                        <xsl:call-template name="setComma"/>
                        <xsl:value-of select="$objectKey"/>
                        <xsl:value-of select="$objectValueConcept"/>
                    </xsl:if>

                    <!-- if no concept in CMDI, search for applicable <pattern> -->
                    <xsl:if test="$objectValueConcept = '[]' or $objectValueConcept = ''">
                        <xsl:variable name="objectValue">
                            <xsl:for-each select=".//pattern">
                                <xsl:variable name="CMDIElement" as="item()*">
                                    <xsl:evaluate xpath="text()" context-item="$contextNode"/>
                                </xsl:variable>
                                <!-- merge to list if XPath returned more than one item (e.g. multiple descriptions) -->
                                <xsl:if test="count($CMDIElement[normalize-space() != '']) > 1">
                                    <xsl:text>[</xsl:text>
                                </xsl:if>
                                <xsl:call-template name="text">
                                    <xsl:with-param name="CMDIElement" select="$CMDIElement"/>
                                </xsl:call-template>
                                <xsl:if test="count($CMDIElement[normalize-space() != '']) > 1">
                                    <xsl:text>]</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:variable>

                        <xsl:if test="$objectValue != ''">
                            <xsl:call-template name="setComma"/>
                            <xsl:value-of select="$objectKey"/>
                            <xsl:value-of select="$objectValue"/>
                        </xsl:if>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$object"/>
    </xsl:template>

    <!-- decide, whether ',' necessary in JSON object -->
    <xsl:template name="setComma">
        <xsl:if
            test="count(preceding-sibling::*) > 0 and preceding-sibling::*/name() != 'expandPattern' or position() = 1 and parent::*/name() = 'Mapping'">
            <xsl:text>,</xsl:text>
        </xsl:if>

    </xsl:template>

    <!-- set JSON object content -->
    <xsl:template match="*" name="obj-content">
        <xsl:param name="contextNodeP" select="$root"/>
        <xsl:choose>
            <xsl:when test="@type and name() != 'expand'">
                <xsl:variable name="value">
                    <xsl:for-each select="./*">
                        <xsl:call-template name="mapping"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:if test="$value != ''">
                    <xsl:text>{</xsl:text>
                    <xsl:text>"@type": "</xsl:text>
                    <xsl:value-of select="@type"/>
                    <xsl:text>",</xsl:text>
                    <xsl:value-of select="$value"/>
                    <xsl:text>}</xsl:text>
                </xsl:if>
            </xsl:when>
            <!-- special case, expand attribute -->
            <xsl:when test="@expand">
                <xsl:variable name="value">
                    <xsl:for-each select="./*/expandPattern">
                        <xsl:variable name="content">
                            <xsl:call-template name="mapping">
                                <xsl:with-param name="contextNode" select="$contextNodeP"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="$content"/>
                        <xsl:if test="position() != last() and $content != ''">
                            <xsl:text>,</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:if test="replace($value, ',', '') != ''">
                    <xsl:text>[</xsl:text>
                    <xsl:choose>
                        <xsl:when test="substring($value, string-length($value), 1) = ','">
                            <xsl:value-of select="substring($value, 1, string-length($value) - 1)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$value"/>
                        </xsl:otherwise>
                    </xsl:choose>

                    <xsl:text>]</xsl:text>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- object content for an expanded object -->
    <xsl:template match="*" mode="expansion" name="expansion">
        <xsl:param name="contextNodeP" select="$root"/>

        <xsl:variable name="contextNode" as="item()*">
            <xsl:evaluate xpath="text()" context-item="$contextNodeP"/>
        </xsl:variable>
        <xsl:variable name="curNode" select="."/>


        <xsl:for-each select="$contextNode[text() != '']">
            <xsl:variable name="value">
                <xsl:apply-templates select="$curNode/following-sibling::*" mode="mapping">
                    <xsl:with-param name="contextNode" select="."/>
                </xsl:apply-templates>
            </xsl:variable>
            <xsl:if test="$value != ''">
                <xsl:text>{</xsl:text>
                <xsl:text>"@type": "</xsl:text>
                <xsl:value-of select="$curNode/../@type"/>
                <xsl:text>",</xsl:text>
                <xsl:value-of select="$value"/>
                <xsl:text>}</xsl:text>
                <xsl:if test="position() &lt; last()">, </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!-- create text of an object -->
    <xsl:template match="*" mode="text" name="text">
        <xsl:param name="CMDIElement"/>
        <xsl:for-each select="$CMDIElement[normalize-space() != '']">
            <!-- try/catch, should the XPath not return a node object (thus, failing at looking for attributes) -->
            <xsl:try>
                <!-- add language/value pair, if available -->
                <xsl:if test="@*[local-name() = 'lang']">
                    <xsl:text>{ "@language": "</xsl:text>
                    <xsl:value-of select="@*[local-name() = 'lang']"/>
                    <xsl:text>",</xsl:text>
                    <xsl:text>"@value": </xsl:text>
                </xsl:if>

                <xsl:text>"</xsl:text>
                <xsl:value-of select="normalize-space(replace(replace(replace(., '&#xA;', ''), '\\', '\\\\'), '&quot;', '\\&quot;'))"/>
                <xsl:text>"</xsl:text>

                <xsl:if test="@*[local-name() = 'lang']">
                    <xsl:text>}</xsl:text>
                </xsl:if>

                <xsl:catch>
                    <xsl:text>"</xsl:text>
                    <xsl:value-of select="replace(., '&#xA;', '')"/>
                    <xsl:text>"</xsl:text>
                </xsl:catch>
            </xsl:try>
            <xsl:if test="position() &lt; last() and $CMDIElement != ''">, </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>