<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="">

  <xsl:output method="html" indent="yes"/>

  <xsl:template name="TextCorpusContextAsSection">
    <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
    <xsl:apply-templates select="." mode="def-list"/> 
    <xsl:apply-templates select="./*[local-name() = 'SubjectLanguages']" mode="details"/>
  </xsl:template>
  
  <xsl:template match="*[local-name() = 'TextCorpusContext']" mode="def-list">

      <dl>
          <dt>Corpus type</dt>
          <dd>
            <xsl:value-of select="./*[local-name() = 'CorpusType']"/>
          </dd>
        
          <dt>Temporal classification</dt>
          <dd>
            <xsl:value-of select="./*[local-name() = 'TemporalClassification']"/>
          </dd>
        
          <dt>Validation</dt>
          <dd>
	    <!-- TODO: validation type? mode? level? -->
            <xsl:apply-templates select="./*[local-name() = 'ValidationGrp']/*[local-name() = 'Descriptions']"/>
          </dd>

          <dt>Size information</dt>
          <dd>
            <xsl:apply-templates select="./*[local-name() = 'TypeSpecificSizeInfo']" mode="list"/>
          </dd>
      </dl>
    
  </xsl:template>
</xsl:stylesheet>
