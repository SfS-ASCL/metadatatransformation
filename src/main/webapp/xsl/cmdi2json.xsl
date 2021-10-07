<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" encoding="utf-8"/>

    <xsl:variable name="Filename" select="replace(//*:MdProfile, ':', '')"/>
    <xsl:variable name="CMDIProfile" select="document(string-join(('./MetaDataTransformer_CMDI_Profiles/', $Filename, '.xml')))"/>
    <!-- <xsl:variable name="CMDIProfile" select="document('./clarin.eucr1p_1527668176122.xml')"/>-->


    <xsl:template match="/*[node()]" name="toJson">
        <xsl:param name="rootNode" select="/rootNode"/>
        <!-- <xsl:text>{</xsl:text>-->
        <xsl:apply-templates select="$rootNode/*" mode="detect"/>
        <!--<xsl:text>}</xsl:text>-->
    </xsl:template>

    <xsl:template match="*" mode="detect">
        <xsl:if test="*[normalize-space()] != '' or string-length(normalize-space()) != 0">
            <xsl:choose>
                <!-- check whether to close list -->
                <xsl:when test="name(preceding-sibling::*[1]) = name(current()) and name(following-sibling::*[1]) != name(current())">
                    <xsl:apply-templates select="." mode="obj-content2"/>
                    <xsl:text>]</xsl:text>
                    <xsl:if test="following-sibling::node()/normalize-space() != '' and count(following-sibling::*[name() != name(current())]) &gt; 0"
                        >, </xsl:if>
                </xsl:when>
                <xsl:when test="name(preceding-sibling::*[1]) = name(current()) and preceding-sibling::*[1]/normalize-space() != ''">
                    <xsl:apply-templates select="." mode="obj-content2"/>
                    <xsl:if test="following-sibling::*/name() = name(current())">, </xsl:if>
                </xsl:when>
                <!-- start list -->
                <xsl:when test="following-sibling::*[1][name() = name(current())] and following-sibling::*[1]/normalize-space() != ''">
                    <xsl:text>"</xsl:text>
                    <xsl:value-of select="replace(replace(name(), 'か', ':'), 'あ', '/')"/>
                    <xsl:text>" : [</xsl:text>
                    <xsl:apply-templates select="." mode="obj-content2"/>
                    <xsl:text>, </xsl:text>
                </xsl:when>
                <!-- Nodes with Children (Concepts) or Attributes -->
                <xsl:when test="count(./child::*) > 0 or count(@*) > 0">
                    <xsl:text>"</xsl:text><xsl:value-of select="replace(replace(name(), 'か', ':'), 'あ', '/')"/>" : <xsl:apply-templates select="."
                        mode="obj-content2"/>
                    <xsl:if test="following-sibling::node()/normalize-space() != ''">, </xsl:if>
                </xsl:when>
                <!-- Nodes without Children (Elements) -->
                <xsl:when test="count(./child::*) = 0">
                    <xsl:text>"</xsl:text><xsl:value-of select="replace(replace(name(), 'か', ':'), 'あ', '/')"/>" : "<xsl:apply-templates select="."
                        mode="removeBreaks"/><xsl:text>"</xsl:text>
                    <xsl:if test="following-sibling::node()/normalize-space() != ''">, </xsl:if>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*" mode="obj-content2">
        <xsl:text>{</xsl:text>
        <xsl:if test="not(@lang) and count(child::*) > 0">
            <xsl:text>"@type": "Component",</xsl:text>
        </xsl:if>

        <xsl:apply-templates select="@lang" mode="attr"/>
        <xsl:if test="count(@*[local-name() = 'lang']) &gt; 0 and (count(child::*) &gt; 0 or text())">, </xsl:if>
        <xsl:apply-templates select="./*" mode="detect"/>
        <xsl:if test="count(child::*) = 0 and text() and not(@*)">
            <xsl:text>"</xsl:text>
            <xsl:value-of select="replace(replace(name(), 'か', ':'), 'あ', '/')"/>
            <xsl:text>" : "</xsl:text>
            <xsl:value-of select="normalize-space(replace(replace(text(), '&#xA;', ''), '&quot;', '\\&quot;'))"/>
            <xsl:text>"</xsl:text>
        </xsl:if>
        <xsl:if test="count(child::*) = 0 and text() and @*">
            <xsl:text>"@value" : "</xsl:text>
            <xsl:value-of select="normalize-space(replace(replace(replace(., '&#xA;', ''), '\\', '\\\\'), '&quot;', '\\&quot;'))"/>
            <xsl:text>"</xsl:text>
        </xsl:if>
        <xsl:text>}</xsl:text>
        <xsl:if test="position() &lt; last()">, </xsl:if>
    </xsl:template>

    <!-- add language/value pair -->
    <xsl:template match="@lang" mode="attr">
        <xsl:text>"@language" : "</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>"</xsl:text>
    </xsl:template>

    <xsl:template match="node/@TEXT | text()" name="removeBreaks" mode="removeBreaks">
        <xsl:param name="pText" select="normalize-space(.)"/>
        <xsl:value-of select="normalize-space(replace(replace(replace($pText, '&#xA;', ''), '\\', '\\\\'), '&quot;', '\\&quot;'))"/>
    </xsl:template>

</xsl:stylesheet>
