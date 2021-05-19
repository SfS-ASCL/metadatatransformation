<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="xs xd functx">

  <!-- Utils.xsl: General utility templates -->

  <xsl:output method="html" indent="yes"/>

  <!-- This is called from many different templates: -->
  <xsl:template name="DescriptionsByLangAsP" match="*[local-name() = 'Descriptions']">
    <xsl:for-each select="*[local-name() = 'Description']">
      <xsl:choose>
        <xsl:when test="@xml:lang='en'">
	  <p><span class="langkeyword">English: </span> <xsl:value-of select="."/> </p>
        </xsl:when>
        <xsl:when test="@xml:lang='de'">
	  <p><span class="langkeyword">Deutsch: </span> <xsl:value-of select="."/> </p>
        </xsl:when>	
        <xsl:otherwise>
          <p>
            <xsl:value-of select="."/>
          </p>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
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
