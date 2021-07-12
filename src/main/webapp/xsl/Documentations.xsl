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
        <xsl:apply-templates select="./*[local-name() = 'Url']" mode="link-to-url">
          <xsl:with-param name="link-text">
            <xsl:apply-templates select="./*[local-name() = 'DocumentationType']" mode="comma-separated-text"/>
          </xsl:with-param>
        </xsl:apply-templates>

        <xsl:if test=".//*[local-name() = 'LanguageName']">
          <br/>
          <xsl:text>In: </xsl:text>
          <xsl:apply-templates select=".//*[local-name() = 'LanguageName']" mode="comma-separated-text"/>
        </xsl:if>
        <xsl:if test="./*[local-name() = 'FileName']/text()">
          <br/>
          <xsl:text>Files: </xsl:text>
          <xsl:apply-templates select="./*[local-name() = 'FileName']" mode="comma-separated-text"/>
        </xsl:if>
    </li>
  </xsl:template>

</xsl:stylesheet>
