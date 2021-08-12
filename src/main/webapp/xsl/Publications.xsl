<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="">

  <xsl:output method="html" indent="yes"/>

  <xsl:template match="*[local-name() = 'Publications']">
    <xsl:apply-templates select="./*[local-name() = 'Descriptions']" />
    <xsl:choose>
      <xsl:when test=".//*[local-name() = 'PublicationTitle' and text()]">
        <ol>
          <xsl:apply-templates select="./*[local-name() = 'Publication']" mode="list-item" />
        </ol>
      </xsl:when>
      <xsl:otherwise>
        <p>No information is available about publications related to this resource.</p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Publication']" mode="list-item">
    <li itemscope="" itemtype="https://schema.org/ScholarlyArticle">
      <p>
        <!-- authors -->
        <xsl:apply-templates select="./*[local-name() = 'Author']"
                             mode="name-with-links-in-list" />
        <!-- title -->
        <cite>
          <xsl:value-of select="./*[local-name() = 'PublicationTitle']"/>
        </cite>
        <xsl:text>. </xsl:text>
        <!-- link -->
        <xsl:apply-templates select="./*[local-name() = 'resolvablePID']" mode="link-to-url">
          <xsl:with-param name="same-as" select="true()"/>
        </xsl:apply-templates>
      </p>
      <xsl:if test=".//*[local-name() = 'Description' and text()]">
        <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/> 
      </xsl:if>
    </li>
  </xsl:template>

  <!-- TODO: merge into CommonComponents -->
  <xsl:template match="*[local-name() = 'Author']" mode="name-with-links-in-list">
    <xsl:variable name="authorName">
      <xsl:value-of select="./*[local-name() = 'firstName']"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="./*[local-name() = 'lastName']"/>
    </xsl:variable>

    <xsl:if test="$authorName != ' '">
      <!-- the name and links: -->
      <span itemscope="" itemprop="author" itemtype="https://schema.org/Person">
        <xsl:apply-templates select="./*[local-name() = 'AuthoritativeIDs']" mode="link-tags"/>
        <!-- name comes *after* <link>s because they introduce phantom space in rendered HTML:-->
        <xsl:value-of select="$authorName"/>
      </span>
      <!-- following punctuation in the list: -->
      <xsl:choose>
        <xsl:when test="position() = last() - 1">
          <xsl:text> and </xsl:text>
        </xsl:when>
        <xsl:when test="last() > position()">
          <xsl:text>, </xsl:text>
        </xsl:when>
        <xsl:when test="last() = position() and last() > 0">
          <!-- only generate a period at the end of nonempty lists -->
          <xsl:text>. </xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
