<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="">

  <xsl:output method="html" indent="yes"/>

  <xsl:template match="*[local-name() = 'Publications']">
    <xsl:apply-templates select="./*[local-name() = 'Descriptions']" />
    <xsl:if test=".//*[local-name() = 'PublicationTitle' and text()]">
      <ol>
        <xsl:apply-templates select="./*[local-name() = 'Publication']" mode="list-item" />
      </ol>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Publication']" mode="list-item">
    <li>
      <p>
        <!-- authors -->
        <xsl:apply-templates select="./*[local-name() = 'Author']"
                             mode="name-with-link-in-list" />
        <xsl:text>. </xsl:text>
        <!-- title -->
        <cite>
          <xsl:value-of select="./*[local-name() = 'PublicationTitle']"/>
        </cite>
        <xsl:text>. </xsl:text>
        <!-- link -->
        <xsl:apply-templates select="./*[local-name() = 'resolvablePID']"
                             mode="link-to-url" />
      </p>
      <xsl:if test=".//*[local-name() = 'Description' and text()]">
        <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/> 
      </xsl:if>
    </li>
   
  </xsl:template>

  <xsl:template match="*[local-name() = 'Author']" mode="name-with-link-in-list">
    <xsl:variable name="authorUrl"
                  select="./*[local-name() = 'AuthoritativeIDs']/*[local-name() = 'AuthoritativeID']/*[local-name() = 'id']"/>
    <xsl:variable name="authorName">
      <xsl:value-of select="./*[local-name() = 'firstName']"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="./*[local-name() = 'lastName']"/>
    </xsl:variable>

    <xsl:if test="$authorName != ' '">
      <!-- the name and link: -->
      <xsl:choose>
        <xsl:when test="$authorUrl != ''">
          <xsl:apply-templates select="$authorUrl" mode="link-to-url">
            <xsl:with-param name="link-text" select="$authorName"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$authorName"/>
        </xsl:otherwise>
      </xsl:choose>

      <!-- following punctuation in the list: -->
      <xsl:choose>
        <xsl:when test="position() = last() - 1">
          <xsl:text> and </xsl:text>
        </xsl:when>
        <xsl:when test="last() > position()">
          <xsl:text>, </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <!-- last item; do nothing, because period is added in calling template  -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
