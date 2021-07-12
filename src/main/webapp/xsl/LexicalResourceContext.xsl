<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="">

  <xsl:output method="html" indent="yes"/>
  <xsl:template name="LexicalResourceContextAsSection">
    <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
    <xsl:apply-templates select="." mode="def-list" />  
    <xsl:apply-templates select="./*[local-name() = 'SubjectLanguages']" mode="details"/>
    <xsl:apply-templates select="./*[local-name() = 'AuxiliaryLanguages']" mode="details"/>  
    <details>
      <summary>Size information</summary>
        <xsl:apply-templates select="./*[local-name() = 'TypeSpecificSizeInfo']" mode="list"></xsl:apply-templates>
    </details>
  </xsl:template>

  <xsl:template match="*[local-name() = 'LexicalResourceContext']" mode="def-list">
    <dl>
      <dt>Lexicon type(s)</dt>
      <dd>
        <xsl:apply-templates select="./*[local-name() = 'LexiconType']"
                             mode="comma-separated-text"/>
      </dd>
     
      <dt>Headword type(s)</dt>
      <dd>
        <xsl:apply-templates select="./*[local-name() = 'HeadwordType']/*[local-name() = 'LexicalUnit']" 
                             mode="comma-separated-text"/>
        <xsl:apply-templates select="./*[local-name() = 'HeadwordType']/*[local-name() = 'Descriptions']"/>
      </dd>
      
    </dl>
  </xsl:template>
  
  <xsl:template match="*[local-name() = 'AuxiliaryLanguages']" mode="details">
    <details>
      <summary>Auxiliary languages</summary>
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
      <ul>
        <xsl:apply-templates select="./*[local-name() = 'Language']" mode="list-item"/>
      </ul>
    </details>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Language']" mode="list-item">
    <li>
        <xsl:value-of select="./*[local-name() = 'LanguageName']"/>
    </li>
  </xsl:template>
</xsl:stylesheet>
