<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="xs xd functx">

  <xsl:output method="html" indent="yes"/>
  <xsl:template name="LexicalResourceContextAsTable" match="*[local-name() = 'LexicalResourceContext']">
    <table>
      <!-- TODO: table header? -->
      <tbody>
        <tr>
          <td>
            <b>Lexicon Type: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'LexiconType']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Subject Language(s): </b>
          </td>
          <td>
            <xsl:value-of
                select="./*[local-name() = 'SubjectLanguages']/*[local-name() = 'SubjectLanguage']/*[local-name() = 'Language']/*[local-name() = 'LanguageName']"
                />
          </td>
        </tr>
        <tr>
          <td>
            <b>Auxiliary Language(s): </b>
          </td>
          <td>
            <xsl:value-of
                select="./*[local-name() = 'AuxiliaryLanguages']/*[local-name() = 'Language']/*[local-name() = 'LanguageName']"
                />
          </td>
        </tr>
        <tr>
          <td>
            <b>Headword Type: </b>
          </td>
          <td>
            <xsl:value-of
                select="./*[local-name() = 'HeadwordType']/*[local-name() = 'LexicalUnit']"/>
            <xsl:if
                test="./*[local-name() = 'HeadwordType']/*[local-name() = 'Descriptions']/*[local-name() = 'Description'] != ''"
                > (<xsl:value-of
                select="./*[local-name() = 'HeadwordType']/*[local-name() = 'Descriptions']/*[local-name() = 'Description']"
                />) </xsl:if>
          </td>
        </tr>
        <tr>
          <td>
            <b>Type-specific Size Info(s): </b>
          </td>
          <td>
            <xsl:apply-templates select="*[local-name() = 'TypeSpecificSizeInfo']"></xsl:apply-templates>
            <!-- <xsl:value-of
                 select="./*[local-name() =
                 'TypeSpecificSizeInfo']/*[local-name() = 'TypeSpecificSize']/*[local-name() = 'Size']" /> -->
          </td>
        </tr>
        <tr>
          <td>
            <b>Description: </b>
          </td>
          <td>
            <xsl:apply-templates select="*[local-name() = 'Descriptions']"/> 
            <!-- <xsl:value-of
                 select="./*[local-name() = 'Descriptions']/*[local-name() = 'Description']"/> -->
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template>
</xsl:stylesheet>
