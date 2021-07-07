<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="">

  <xsl:output method="html" indent="yes"/>

  <xsl:template match="*[local-name() = 'Documentations']" mode="list">
    <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
    <ol>
        <xsl:for-each select="./*[local-name() = 'Documentation']">
          <li>
            <dl>
                <dt>
                  Documentation Type(s)
                </dt>
                <dd>
                  <xsl:for-each select="./*[local-name() = 'DocumentationType']">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">, </xsl:if>
                  </xsl:for-each>
                </dd>
              
              
                <dt>
                  File Name(s)
                </dt>
                <dd>
                  <xsl:for-each select="./*[local-name() = 'FileName']">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">, </xsl:if>
                  </xsl:for-each>
                </dd>
              
              
                <dt>
                  URL
                </dt>
                <dd>
                  <xsl:for-each select="./*[local-name() = 'Url']">
                    <xsl:element name="a">
                      <xsl:attribute name="href">
                        <xsl:value-of select="."/>
                      </xsl:attribute>
                      <xsl:value-of select="."/>
                    </xsl:element>
                    <xsl:if test="position() != last()">, </xsl:if>
                  </xsl:for-each>
                  
                </dd>
              
              
                <dt>
                  Documentation Language(s)
                </dt>
                <dd>
                  <!-- omitted ISO639 code -->
                  <xsl:for-each select="./*[local-name() = 'DocumentationLanguages']">
                    <xsl:value-of
                        select="./*[local-name() = 'DocumentationLanguage']/*[local-name() = 'Language']//*[local-name() = 'LanguageName']"/>
                    <xsl:if test="position() != last()">, </xsl:if>
                  </xsl:for-each>
                </dd>
            </dl>
          </li>
        </xsl:for-each>
      
    </ol>
  </xsl:template>

</xsl:stylesheet>
