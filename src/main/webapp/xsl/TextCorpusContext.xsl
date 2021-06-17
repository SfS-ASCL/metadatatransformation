<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="">

  <xsl:output method="html" indent="yes"/>

  <xsl:template name="TextCorpusContextAsTable" match="*[local-name() = 'TextCorpusContext']">
    <table>
      <!-- TODO: table header? -->
      <tbody>
        <tr>
          <td>
            <b>Corpus Type: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'CorpusType']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Temporal Classification: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'TemporalClassification']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Description(s): </b>
          </td>
          <td>
            <xsl:value-of select=".//*[local-name() = 'Description']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Validation: </b>
          </td>
          <td>
            <xsl:value-of
                select="./*[local-name() = 'ValidationGrp']//*[local-name() = 'Description']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Subject Language(s): </b>
          </td>
          <td>
            <xsl:value-of
                select="./*[local-name() = 'SubjectLanguages']//*[local-name() = 'LanguageName']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Type-specific Size Info: </b>
          </td>
          <td>
            <xsl:value-of
                select="./*[local-name() = 'TypeSpecificSizeInfo']//*[local-name() = 'Size']"/>
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template>
</xsl:stylesheet>
