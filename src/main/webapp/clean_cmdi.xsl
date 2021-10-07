<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="Filename" select="replace(//*:MdProfile, ':', '')"/>
    <xsl:variable name="CMDIProfile" select="document(string-join(('./CMDI_Profiles/', $Filename, '.xml')))"/>
    <!-- <xsl:variable name="CMDIProfile" select="document('./clarin.eucr1p_1527668176122.xml')"/> -->

    <xsl:template match="*" name="Cleaning">
        <xsl:element name="rootNode">
            <xsl:apply-templates select="*" mode="xml"/>
        </xsl:element>

    </xsl:template>
    <!-- remove comments and replace element names with their unique ID from the CMDI's XML Schema -->
    <xsl:template match="*" mode="xml">
        <xsl:if test="*[normalize-space()] != '' or string-length(normalize-space()) != 0">
            <xsl:variable name="URI"
                select="($CMDIProfile//*[@name = current()/local-name()]/@*[name() = 'ConceptLink' or name() = 'ComponentRef'])[1]"/>
            <xsl:choose>
                <xsl:when test="count($CMDIProfile//*[@name = current()/local-name()]/@*[name() = 'ConceptLink' or name() = 'ComponentRef']) = 0">
                    <xsl:apply-templates select="./*[not(local-name() = 'candidateAuthoritativeID')]" mode="xml"/>
                </xsl:when>
                <xsl:when test="$URI != ''">
                    <xsl:element name="{replace(replace($URI, ':', 'か'), '/', 'あ')}">
                        <xsl:apply-templates select="@*"/>

                        <xsl:choose>
                            <xsl:when test="count(child::*) > 0">
                                <xsl:apply-templates select="./*" mode="xml"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="text()"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="./*" mode="xml"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:attribute name="{local-name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="comment()"/>

</xsl:stylesheet>
