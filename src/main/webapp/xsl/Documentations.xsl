<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="">

  <xsl:output method="html" indent="yes"/>

  <xsl:template name="DocumentationsAsTable" match="*[local-name() = 'Documentations']">
    <table>
      <tbody>
        <xsl:for-each select="./*[local-name() = 'Documentation']">
          <tr>
            <table>
              <tr>
                <td>
                  <b>Documentation Type(s): </b>
                </td>
                <td>
                  <xsl:for-each select="./*[local-name() = 'DocumentationType']">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">, </xsl:if>
                  </xsl:for-each>
                </td>
              </tr>
              <tr>
                <td>
                  <b>File Name(s): </b>
                </td>
                <td>
                  <xsl:for-each select="./*[local-name() = 'FileName']">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">, </xsl:if>
                  </xsl:for-each>
                </td>
              </tr>
              <tr>
                <td>
                  <b>URL: </b>
                </td>
                <td>
                  <xsl:for-each select="./*[local-name() = 'Url']">
                    <xsl:element name="a">
                      <xsl:attribute name="href">
                        <xsl:value-of select="."/>
                      </xsl:attribute>
                      <xsl:value-of select="."/>
                    </xsl:element>
                    <xsl:if test="position() != last()">, </xsl:if>
                  </xsl:for-each>
                  
                </td>
              </tr>
              <tr>
                <td>
                  <b>Documentation Language(s): </b>
                </td>
                <td>
                  <!-- omitted ISO639 code -->
                  <xsl:for-each select="./*[local-name() = 'DocumentationLanguages']">
                    <xsl:value-of
                        select="./*[local-name() = 'DocumentationLanguage']/*[local-name() = 'Language']//*[local-name() = 'LanguageName']"/>
                    <xsl:if test="position() != last()">, </xsl:if>
                  </xsl:for-each>
                </td>
              </tr>
              <tr>
                <td>
                  <b>Descriptions(s): </b>
                </td>
                <td>
                  <xsl:for-each select="./*[local-name() = 'Description']">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">, </xsl:if>
                  </xsl:for-each>
                </td>
              </tr>
            </table>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>

</xsl:stylesheet>
