<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="">

  <xsl:output method="html" indent="yes"/>

  <xsl:template name="SpeechCorpusContextAsTable" match="*[local-name() = 'SpeechCorpusContext']">
    <table>
      <!-- TODO: table header? -->
      <tbody> 
        <tr>
          <td>
            <b>Modalities: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'Modalities']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Mediatype: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'Mediatype']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Speech Corpus: </b>
          </td>
          <td>
            <table border="3" cellpadding="10" cellspacing="10">
              <tr>
                <td>
                  <b>Duration (effective speech):</b>
                </td>
                <td>
                  <xsl:value-of
                      select="./*[local-name() = 'SpeechCorpus']/*[local-name() = 'DurationOfEffectiveSpeech']"
                      />
                </td>
              </tr>
              <tr>
                <td>
                  <b>Duration (full database):</b>
                </td>
                <td>
                  <xsl:value-of
                      select="./*[local-name() = 'SpeechCorpus']/*[local-name() = 'DurationOfFullDatabase']"
                      />
                </td>
              </tr>
              <tr>
                <td>
                  <b>Number of speakers:</b>
                </td>
                <td>
                  <xsl:value-of
                      select="./*[local-name() = 'SpeechCorpus']/*[local-name() = 'NumberOfSpeakers']"
                      />
                </td>
              </tr>
              <tr>
                <td>
                  <b>Recording Environment:</b>
                </td>
                <td>
                  <xsl:value-of
                      select="./*[local-name() = 'SpeechCorpus']/*[local-name() = 'RecordingEnvironment']"
                      />
                </td>
              </tr>
              <tr>
                <td>
                  <b>Speaker demographics:</b>
                </td>
                <td>
                  <xsl:value-of
                      select="./*[local-name() = 'SpeechCorpus']/*[local-name() = 'SpeakerDemographics']"
                      />
                </td>
              </tr>
              <tr>
                <td>
                  <b>Quality:</b>
                </td>
                <td>
                  <xsl:value-of
                      select="./*[local-name() = 'SpeechCorpus']/*[local-name() = 'Quality']"/>
                </td>
              </tr>
              <tr>
                <td>
                  <b>Recording Platform (hardware):</b>
                </td>
                <td>
                  <xsl:value-of
                      select="./*[local-name() = 'SpeechCorpus']/*[local-name() = 'RecordingPlatformHardware']"
                      />
                </td>
              </tr>
              <tr>
                <td>
                  <b>Recording Platform (software):</b>
                </td>
                <td>
                  <xsl:value-of
                      select="./*[local-name() = 'SpeechCorpus']/*[local-name() = 'RecordingPlatformSoftware']"
                      />
                </td>
              </tr>
              <tr>
                <td>
                  <b>Speech-technical metadata:</b>
                </td>
                <td>
                  <xsl:value-of
                      select="./*[local-name() = 'SpeechCorpus']/*[local-name() = 'SpeechTechnicalMetadata']"
                      />
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>
            <b>Multilinguality: </b>
          </td>
          <td>
            <xsl:value-of
                select="./*[local-name() = 'Multilinguality']/*[local-name() = 'Multilinguality']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Annotation Type(s): </b>
          </td>
          <td>
            <xsl:value-of select=".//*[local-name() = 'AnnotationType']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Subject Language(s): </b>
          </td>
          <td>
            <xsl:value-of select=".//*[local-name() = 'LanguageName']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Type-specific Size info: </b>
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
