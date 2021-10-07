<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    <xsl:import href="xsl/mapping2json.xsl"/>
    <xsl:import href="clean_cmdi.xsl"/>
    <xsl:import href="xsl/cmdi2json.xsl"/>
    <xsl:output method="text"/>
        
    <xsl:template match="/*">      
        <xsl:variable name="JsonLDFromMapping">
            <xsl:call-template name="Mapping2JSON"/>
        </xsl:variable>   
        <xsl:variable name="cleanedXML">
            <xsl:call-template name="Cleaning"/>
        </xsl:variable>  
        <xsl:variable name="CMDI2JSON">
            <xsl:call-template name="toJson" >
            <xsl:with-param name="rootNode" select="$cleanedXML/rootNode"/>
        </xsl:call-template>
        </xsl:variable>
        
        <xsl:text>{</xsl:text>
        <!-- remove potenial trailing comma/too many comma from mapping2json -->
        <xsl:value-of select="normalize-space(replace(replace(replace($JsonLDFromMapping, ',,+', ','), ', ]', ']', 'q'), '[,', '[', 'q'))"/>  
        <xsl:if test="$CMDI2JSON != ''">
            <xsl:text>,</xsl:text>
        </xsl:if>   
        <xsl:value-of select="normalize-space($CMDI2JSON)"/>
        <xsl:text>}</xsl:text>
        
    </xsl:template>   
</xsl:stylesheet>