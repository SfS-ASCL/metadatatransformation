<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="">

  <!-- Utils.xsl: General utility templates -->

  <xsl:output method="html" indent="yes"/>

  <!-- This is called from many different templates: -->
  <xsl:template name="DescriptionsByLangAsP" match="*[local-name() = 'Descriptions']">
    <xsl:for-each select="*[local-name() = 'Description']">
      <xsl:if test="./text()">
        <xsl:element name="p">
          <xsl:if test="@xml:lang != ''" >
            <xsl:attribute name="lang">
              <xsl:value-of select="@xml:lang" />
            </xsl:attribute>
          </xsl:if>
        <xsl:value-of select="."/>
      </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- Turns a node collection of nodes with text values into comma-separated text -->
  <xsl:template match="*" mode="comma-separated-text">
    <xsl:if test="text()">
      <xsl:value-of select="text()"/>
      <xsl:if test="last() > 1 and position() != last()">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- Turns any node whose text() value is a URL into a link to that URL -->
  <!-- The value of the link-text param, if supplied, will be used for
       the link text; by default, the URL itself is used. -->
  <!-- If the same-as param is true, the link will have
       itemprop="sameAs", a way of specifying that the URL points to
       an identifying resource -->
  <xsl:template match="*" mode="link-to-url">
    <xsl:param name="link-text" select="./text()"/>
    <xsl:param name="same-as" select="false()"/>
    <xsl:element name="a">
      <xsl:if test="$same-as">
        <xsl:attribute name="itemprop">sameAs</xsl:attribute>
      </xsl:if>
      <xsl:attribute name="href">
        <xsl:value-of select="./text()"/>
      </xsl:attribute>
      <xsl:value-of select="$link-text"/>
    </xsl:element>
  </xsl:template>

  <!-- This is a variant of the above that can be applied to attribute
       nodes to generate a link when the attribute contains the URL,
       and its parent element's text() contains the link text. e.g.
       <Licence src="...">CC-BY</Licence> -->
  <!-- TODO: other attribute names? -->
  <xsl:template match="@*[local-name() = 'src']" mode="link-to-url">
    <xsl:param name="link-text" select="../text()"/>
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="."/>
      </xsl:attribute>
      <xsl:value-of select="$link-text"/>
    </xsl:element>
  </xsl:template>

  <!-- This is called from the resource-specific templates: -->
  <xsl:template name="TypeSpecificSizeInfoAsDefList"
                match="*[local-name() ='TypeSpecificSizeInfo']">
    <dl>
      <dt>
	<xsl:variable name="referenceid">
	  <xsl:value-of select="@*[local-name()='ref']"></xsl:value-of>
	</xsl:variable>
	
	<!-- <xsl:value-of select="../../../*:ResourceProxyListInfo/*:ResourceProxyInfo"/> -->
	
	<xsl:value-of select="../../../..//*[local-name() = 'ResourceProxyListInfo']/*[local-name() = 'ResourceProxyInfo'][@*[local-name()='ref']=$referenceid]/*[local-name() = 'ResProxItemName']"/>
	
	<!--	<xsl:value-of select="../../../..//*[local-name() = 'ResourceProxyListInfo']/*[local-name() = 'ResourceProxyInfo'][@ref=$referenceid]/*[local-name() = 'ResProxItemName']"></xsl:value-of>
	-->
      </dt>
      <dd>
	<xsl:for-each select="./*[local-name() = 'TypeSpecificSize']">
	  <li><xsl:value-of select="*[local-name() = 'Size']"/> <xsl:text> </xsl:text><xsl:value-of select="*[local-name() = 'SizeUnit']"/> </li>
	</xsl:for-each>
      </dd>
    </dl>	
  </xsl:template>

  <!-- There are many different kinds of *ToolInfo components with the same structure.-->
  <xsl:template match="*[local-name() = 'CreationToolInfo' or
                         local-name() = 'AnalysisToolInfo' or
                         local-name() = 'AnnotationToolInfo' or
                         local-name() = 'DeploymentToolInfo' or
                         local-name() = 'DerivationToolInfo']" mode="list-item">

    <!-- first child (CreationTool, AnnotationTool, etc.) contains name:-->
    <xsl:variable name="toolName" select="./*[1]/text()" />
    <xsl:if test="$toolName">
      <li>
        <p>
          <xsl:choose>
            <xsl:when test="./*[local-name() = 'Url']/text()"> 
              <xsl:apply-templates select="./*[local-name() = 'Url']" mode="link-to-url">
                <xsl:with-param name="link-text" select="$toolName"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$toolName"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="./*[local-name() = 'ToolType']/text()"> 
            <xsl:text> (</xsl:text>
            <xsl:value-of select="normalize-space(./*[local-name() = 'ToolType'])" />
            <xsl:text>)</xsl:text>
          </xsl:if>
          <xsl:if test="./*[local-name() = 'Version']/text()"> 
            <xsl:text>, version </xsl:text>
            <xsl:value-of select="normalize-space(./*[local-name() = 'Version'])" />
          </xsl:if>
        </p>
        <xsl:apply-templates select="./*[local-name() = 'Descriptions']" />
      </li>
    </xsl:if>
  </xsl:template>

  <xsl:template name="replace-string">
    <xsl:param name="text"/>
    <xsl:param name="replace"/>
    <xsl:param name="with"/>
    <xsl:choose>
      <xsl:when test="contains($text,$replace)">
	<xsl:value-of select="substring-before($text,$replace)"/>
	<xsl:value-of select="$with"/>
	<xsl:call-template name="replace-string">
	  <xsl:with-param name="text"
			  select="substring-after($text,$replace)"/>
	  <xsl:with-param name="replace" select="$replace"/>
	  <xsl:with-param name="with" select="$with"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
