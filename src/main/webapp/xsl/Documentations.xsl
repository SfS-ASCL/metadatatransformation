<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="">

  <xsl:output method="html" indent="yes"/>

  <xsl:template match="*[local-name() = 'Documentations']" mode="list">
    <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
    <xsl:choose>
      <xsl:when test="./*[local-name() = 'Documentation']/*/text()">
        <ol>
          <xsl:apply-templates select="./*[local-name() = 'Documentation']" mode="list-item"/>
        </ol>
      </xsl:when>
      <xsl:otherwise>
        <p>No information about documentation is available for this resource.</p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Documentation']" mode="list-item">
    <li>
        <xsl:if test="./*[local-name() = 'DocumentationType']">
          <xsl:apply-templates select="./*[local-name() = 'DocumentationType']" mode="comma-separated-text"/>
          <xsl:text> </xsl:text>
        </xsl:if>

        <xsl:apply-templates select="./[local-name() = 'URL']" mode="link-to-url"/>

        <xsl:if test=".//*[local-name() = 'LanguageName']">
          <br/>
          <xsl:text>In: </xsl:text>
          <xsl:apply-templates select=".//*[local-name() = 'LanguageName']" mode="comma-separated-text"/>
        </xsl:if>
        <xsl:if test=".//*[local-name() = 'FileName']">
          <br/>
          <xsl:text>Files: </xsl:text>
          <xsl:apply-templates select="./*[local-name() = 'FileName']" mode="comma-separated-text"/>
        </xsl:if>
    </li>
  </xsl:template>

</xsl:stylesheet>
