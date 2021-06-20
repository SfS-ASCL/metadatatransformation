<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="">
  
  <xsl:output method="html" indent="yes"/>
  
  <xsl:template name="ExperimentContextAsSection" match="*[local-name() = 'ExperimentContext']">
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
      <xsl:apply-templates select="./*[local-name() = 'ExperimentalStudy']" mode="section"/>
  </xsl:template>

  <xsl:template match="*[local-name() = 'ExperimentalStudy']" mode="section">
    <section class="study">
    <!-- TODO: do we have any examples where an ExperimentContext
         contains more than one ExperimentalStudy? If so, perhaps we
         need another heading here  -->
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
      <xsl:apply-templates select="./*[local-name() = 'Experiment']" mode="section"/>
    </section>
  </xsl:template>

  <xsl:template name="ExperimentSection" match="*[local-name() = 'Experiment']" mode="section">
    <section class="experiment">
      <xsl:call-template name="ExperimentInfoAsHeading"/>
      <!-- TODO: ExperimentalParadigm? -->
      <xsl:apply-templates select="*[local-name() = 'Descriptions']"/> 

      <xsl:apply-templates select="./*[local-name() = 'Hypotheses']" mode="details" />
      <xsl:apply-templates select="./*[local-name() = 'Method']" mode="details" />
      <xsl:apply-templates select="./*[local-name() = 'Results']" mode="details" />
      <xsl:apply-templates select="./*[local-name() = 'Materials']" mode="details"/> 
      <xsl:apply-templates select="./*[local-name() = 'SubjectLanguages']" mode="details"/> 
      <xsl:apply-templates select="./*[local-name() = 'AnalysisToolInfo']" mode="details"/> 
      <!-- TODO: ExperimentalQuality? TypeSpecificSizeInfo? -->
    </section>
  </xsl:template>
  
  <xsl:template name="ExperimentInfoAsHeading">
    <h3>
      <xsl:choose>
        <xsl:when test="./*[local-name() = 'ExperimentTitle']/text()">
          Experiment: <xsl:value-of select="./*[local-name() = 'ExperimentTitle']"/>
          <xsl:if test="./*[local-name() = 'ExperimentName']">
            (<xsl:value-of select="./*[local-name() = 'ExperimentName']"/>)
          </xsl:if>
        </xsl:when>
        <xsl:when test="./*[local-name() = 'ExperimentName']/text()">
          Experiment: <xsl:value-of select="./*[local-name() = 'ExperimentName']"/>
        </xsl:when>
        <xsl:otherwise>
          Experiment <xsl:value-of select="position()"/>
        </xsl:otherwise>
      </xsl:choose>
    </h3>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Hypotheses']" mode="details">
    <details>
      <summary>Hypotheses</summary>
      <xsl:choose>
        <xsl:when test=".//*[local-name() = 'Description' and text()]">
          <ol>
            <xsl:apply-templates select="./*[local-name() = 'Hypothesis']" mode="list-item" />
          </ol>
        </xsl:when>
        <xsl:otherwise>
          <p>No hypothesis information is available for this experiment.</p>
        </xsl:otherwise>
      </xsl:choose>
    </details>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Hypothesis']" mode="list-item">
    <li>
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']" />
    </li>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Results']" mode="details">
    <details>
      <summary>Results</summary>
      <xsl:choose>
        <xsl:when test=".//*[local-name() = 'Description' and text()]">
          <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
        </xsl:when>
        <xsl:otherwise>
          <p>No results information is available for this experiment.</p>
        </xsl:otherwise>
      </xsl:choose>
    </details>
  </xsl:template>
 
  <xsl:template match="*[local-name() = 'Method']" mode="details">
    <details>
      <summary>Methods</summary>
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']" />
      <dl>

        <dt>Research approach</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'Elicitation']/*[local-name() = 'ResearchApproach']"
                               mode="comma-separated-text"/>
        </dd>

        <dt>Research design</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'Elicitation']/*[local-name() = 'ResearchDesign']"
                               mode="comma-separated-text"/>
        </dd>

        <dt>Study model</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'Elicitation']/*[local-name() = 'ElicitationModel']"
                               mode="comma-separated-text"/>
        </dd>

        <dt>Timeframe</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'Elicitation']/*[local-name() = 'ElicitationTimeframe']"
                               mode="comma-separated-text"/>
        </dd>


        <dt>Procedure</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'Procedure']/*[local-name() = 'Descriptions']" />
        </dd>

        <dt>Experiment type</dt>
        <dd>
          <xsl:apply-templates
              select="./*[local-name() = 'Elicitation']//*[local-name() = 'ExperimentType' or
                                                           local-name() = 'SurveyType' or
                                                           local-name() = 'TestType']"
              mode="comma-separated-text" />
        </dd>

        <dt>Neuroimaging technique</dt>
        <dd>
          <xsl:value-of
              select="./*[local-name() = 'Elicitation']//*[local-name() = 'NeuroimagingTechnique']"
              />
        </dd>

        <dt>Elicitation instrument</dt>
        <dd>
          <xsl:apply-templates
              select="./*[local-name() = 'Elicitation']//*[local-name() = 'ElicitationInstrument']"
              mode="comma-separated-text" />
        </dd>

        <dt>Elicitation software</dt>
        <dd>
          <xsl:apply-templates
              select="./*[local-name() = 'Elicitation']//*[local-name() = 'ElicitationSoftware']"
              mode="comma-separated-text" />
        </dd>

        <dt>Variables</dt>
        <dd>
          <xsl:if test="./*[local-name() = 'Elicitation']/*[local-name() = 'Variables']/*[local-name() = 'Variable']">
            <ul>
              <xsl:for-each
                  select="./*[local-name() = 'Elicitation']/*[local-name() = 'Variables']/*[local-name() = 'Variable']">
                <li>
                  <xsl:value-of select="./*[local-name() = 'VariableName']"/>
                  <xsl:if test="./*[local-name() = 'VariableType'] != ''">
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="./*[local-name() = 'VariableType']"/>
                    <xsl:text>)</xsl:text>
                  </xsl:if>
                </li>
              </xsl:for-each>
            </ul>
          </xsl:if>
        </dd>

        <dt>Participant data</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'Participants']" mode="def-list"/>
        </dd>
      </dl>
      
        
    </details>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Participants']" mode="def-list">
      <dl>   

        <dt>Populations</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'Population']" mode="comma-separated-text" />
        </dd>

        <dt>Data rejections</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'DataRejection']" mode="comma-separated-text" />
        </dd>

        <dt>Anonymization flags</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'AnonymizationFlag']" mode="comma-separated-text" />
        </dd>

        <dt>Sampling methods</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'SamplingMethod']" mode="comma-separated-text" />
        </dd>
        
        <dt>Sample sizes</dt>
        <dd>
          <ul>
            <xsl:apply-templates select="./*[local-name() = 'SampleSize']" mode="list-item" />
          </ul>
        </dd>
        
        <dt>Sex distribution</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'SexDistribution']" mode="table"/>
        </dd>
        
        <dt>Age distribution</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'AgeDistribution']" mode="table"/>
        </dd>
        
        <dt>Language varieties</dt>
        <dd>
          <xsl:if test="./*[local-name() = 'LanguageVariety']/*[local-name() = 'VarietyGrp']"> 
            <ul>
              <xsl:apply-templates select="./*[local-name() = 'LanguageVariety']/*[local-name() = 'VarietyGrp']" mode="list-item"/>
            </ul>
          </xsl:if>
        </dd>

        <dt>Participant profession</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'ParticipantProfession']" mode="comma-separated-text" />
        </dd>

        <dt>Recruitment</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'ParticipantRecruitment']/*[local-name() = 'Descriptions']"/> 
        </dd>

      </dl>
  </xsl:template>

  <xsl:template match="*[local-name() = 'SexDistribution']" mode="table">
    <table>
      <tbody>
        <xsl:for-each select="./*[local-name() = 'SexDistributionInfo']">
          <tr>
            <td><xsl:value-of select="./*[local-name() = 'ParticipantSex']"/></td>
            <td><xsl:value-of select="./*[local-name() = 'Size']"/></td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>
  
  <xsl:template match="*[local-name() = 'AgeDistribution']" mode="table">
    <table>
      <tbody>
        <xsl:if test="./*[local-name() = 'ParticipantMeanAge']">
          <tr>
            <td>Mean age</td>
            <td>
              <xsl:value-of select="./*[local-name() = 'ParticipantMeanAge']"/>
              <xsl:if test="./*[local-name() = 'ParticipantMeanAgeSTD']">
                (std = <xsl:value-of select="./*[local-name() = 'ParticipantMeanAgeSTD']"/>)
              </xsl:if>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="./*[local-name() = 'ParticipantAgeRange']">
          <tr>
            <td>Youngest</td>
            <td><xsl:value-of select="./*[local-name() = 'ParticipantAgeRange']/*[local-name() = 'Youngest']"/></td>
          </tr>
          <tr>
            <td>Oldest</td>
            <td><xsl:value-of select="./*[local-name() = 'ParticipantAgeRange']/*[local-name() = 'Oldest']"/></td>
          </tr>
        </xsl:if>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="*[local-name() = 'SampleSize']" mode="list-item">
    <li>
      <xsl:value-of select="./*[local-name() = 'Size']"/>
      <xsl:if test="./*[local-name() = 'SizeUnit' and text()]">
        <xsl:text> </xsl:text>
        <xsl:value-of select="./*[local-name() = 'SizeUnit']" />
      </xsl:if>

      <xsl:apply-templates select="./*[local-name() = 'Descriptions']" />
    </li>
  </xsl:template>

  <xsl:template match="*[local-name() = 'VarietyGrp']" mode="list-item">
    <li>
      <xsl:apply-templates select="./*[local-name() = 'VarietyName']" mode="comma-separated-text" />
      <xsl:if test="./*[local-name() = 'NoParticipants']"> 
        <xsl:text>: </xsl:text>
        <xsl:value-of select=".//*[local-name() = 'NoParticipants']" /> participants
      </xsl:if>
    </li>
  </xsl:template>
  
  <xsl:template match="*[local-name() = 'Materials']" mode="details">
    <details>
      <summary>Materials</summary>
      <xsl:apply-templates select="*[local-name() = 'Descriptions']"/>
      <ul>
        <xsl:for-each select="./*[local-name() = 'Material']">
          <li>
            <xsl:value-of select="./*[local-name() = 'Domain']"/>
            <xsl:if test="./*[local-name() = 'Descriptions']/*[local-name() = 'Description' and text()]">
              <xsl:text>: </xsl:text>
              <xsl:apply-templates select="*[local-name() = 'Descriptions']"/> 
            </xsl:if>
          </li>
        </xsl:for-each>
      </ul>
    </details>
  </xsl:template>

  <xsl:template match="*[local-name() = 'SubjectLanguages']" mode="details">
    <details>
      <summary>Subject languages</summary>
      <xsl:apply-templates select="*[local-name() = 'Descriptions']"/>
      <!-- TODO: would it be useful to display more than just language names? e.g. source/target information?-->
      <ul>
        <xsl:for-each select=".//*[local-name() = 'LanguageName']">
          <li><xsl:value-of select="."/></li>
        </xsl:for-each>
      </ul>
    </details>
  </xsl:template>

  <xsl:template match="*[local-name() = 'AnalysisToolInfo']" mode="details">
    <details>
      <summary>Analysis Tool</summary>

      <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/> 

      <dl>

        <dt>Name</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'AnalysisTool']" />
        </dd>

        <dt>Type</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'ToolType']" />
        </dd>

        <dt>Version</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'Version']" />
        </dd>

        <dt>Link</dt>
        <dd>
          <xsl:if test="./*[local-name() = 'Url' and text()]">
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="./*[local-name() = 'Url']" />
              </xsl:attribute>
              <xsl:value-of select="./*[local-name() = 'Url']" />
            </xsl:element>
          </xsl:if>
        </dd>
      </dl>

    </details>
  </xsl:template>

</xsl:stylesheet>
