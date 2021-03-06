<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="">

  <!-- Utils.xsl: General utility templates -->

  <xsl:output method="html" indent="yes"/>

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
  <!-- TODO: support the case where link-text is provided but URL is
       empty: output link text alone. -->
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
