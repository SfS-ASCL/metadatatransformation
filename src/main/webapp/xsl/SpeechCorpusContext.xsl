<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="">

  <xsl:output method="html" indent="yes"/>

  <xsl:template name="SpeechCorpusContextAsSection">
    <!-- Speech corpus -->
    <xsl:apply-templates select="./*[local-name() = 'SpeechCorpus']" mode="def-list"/> 
    <!-- Subject languages -->
    <xsl:apply-templates select="./*[local-name() = 'SubjectLanguages']" mode="details"/> 
    <!-- AnnotationTypes -->
    <xsl:apply-templates select="./*[local-name() = 'AnnotationTypes']" mode="details"/> 
    <!-- TypeSpecificSizeInfo: put in CommonComponents? use also in Experiment -->
  </xsl:template>

  <xsl:template match="*[local-name() = 'SpeechCorpus']" mode="def-list">
    <dl>
      <dt>Duration (effective speech)</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'DurationOfEffectiveSpeech']" />
      </dd>

      <dt>Duration (full database)</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'DurationOfFullDatabase']" />
      </dd>

      <dt>Number of speakers</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'NumberOfSpeakers']" />
      </dd>

      <dt>Recording Environment</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'RecordingEnvironment']" />
      </dd>

      <dt>Speaker demographics</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'SpeakerDemographics']" />
      </dd>

      <dt>Quality</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'Quality']"/>
      </dd>

      <dt>Recording Platform (hardware)</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'RecordingPlatformHardware']" />
      </dd>
      
      <dt>Recording Platform (software)</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'RecordingPlatformSoftware']" />
      </dd>

      <dt>Multilingual</dt>
      <dd>
        <xsl:value-of select="../*[local-name() = 'Multilinguality']/*[local-name() = 'Multilinguality']" />
      </dd>

      <!-- TODO: expand this -->
      <dt>Speech-technical metadata</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'SpeechTechnicalMetadata']" />
      </dd>
    </dl>
  </xsl:template>

  <xsl:template match="*[local-name() = 'AnnotationTypes']" mode="details">
    <details>
      <summary>Annotation</summary>
      <xsl:choose>
        <xsl:when test="./*[local-name() = 'AnnotationType']">
          <ul>
            <xsl:apply-templates select="./*[local-name() = 'AnnotationType']" mode="list-item"/> 
          </ul>
        </xsl:when>
      </xsl:choose>
    </details>
  </xsl:template>

  <xsl:template match="*[local-name() = 'AnnotationType']" mode="list-item">
    <!-- TODO: is this really a completely different element as in Creation?? -->
    <li>
      <p>
        <xsl:apply-templates select="./*[local-name() = 'AnnotationType']" mode="comma-separated-text"/>
      </p>
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']" />
    </li>

  </xsl:template>

</xsl:stylesheet>
