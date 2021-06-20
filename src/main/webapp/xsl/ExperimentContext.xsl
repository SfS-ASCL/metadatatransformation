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
      <xsl:apply-templates select="*[local-name() = 'Descriptions']"/> 

      <xsl:apply-templates select="./*[local-name() = 'Hypotheses']" mode="details" />
      <xsl:apply-templates select="./*[local-name() = 'Method']" mode="details" />
      <xsl:apply-templates select="./*[local-name() = 'Results']" mode="details" />
      <xsl:apply-templates select="./*[local-name() = 'Materials']" mode="details"/> 
      <xsl:apply-templates select="./*[local-name() = 'SubjectLanguages']" mode="details"/> 
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
        <dt>Experiment type</dt>
        <dd>
          <xsl:value-of
              select="./*[local-name() = 'Elicitation']//*[local-name() = 'ExperimentType']"
              />
        </dd>

        <dt>Elicitation instrument</dt>
        <dd>
          <xsl:value-of
              select="./*[local-name() = 'Elicitation']//*[local-name() = 'ElicitationInstrument']"
              />
        </dd>

        <dt>Elicitation software</dt>
        <dd>
          <xsl:value-of
              select="./*[local-name() = 'Elicitation']//*[local-name() = 'ElicitationSoftware']"
              />
        </dd>

        <dt>Variable(s)</dt>
        <dd>
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
        </dd>
      </dl>
      
      <xsl:apply-templates select="./*[local-name() = 'Participants']" mode="details"/>
        
    </details>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Participants']" mode="details">
    <details>
      <summary>Participant data</summary>
      <dl>   

        <dt>Anonymization flag</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'AnonymizationFlag']" />
        </dd>

        <dt>Sampling method</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'SamplingMethod']" />
        </dd>
        
        <dt>Sample size</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'SampleSize']/*[local-name() = 'Size']"/>
          <xsl:if test="./*[local-name() = 'SampleSize']/*[local-name() = 'SizeUnit'] != ''">
            <xsl:text> </xsl:text>
            <xsl:value-of select="./*[local-name() = 'SizeUnit']" />
          </xsl:if>
          <xsl:apply-templates select="./*[local-name() = 'SampleSize']/*[local-name() = 'Descriptions']" />
        </dd>
        
        
        <dt>Sex distribution</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'SexDistribution']" mode="table"/>
        </dd>
        
        <dt>Age distribution</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'AgeDistribution']" mode="table"/>
        </dd>
        
        <dt>Language variety</dt>
        <dd>
          <xsl:value-of select=".//*[local-name() = 'VarietyName']" />
          <xsl:text>: </xsl:text>
          <xsl:value-of select=".//*[local-name() = 'NoParticipants']" />
        </dd>

        <dt>Recruitment</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'ParticipantRecruitment']/*[local-name() = 'Descriptions']"/> 
        </dd>

      </dl>
    </details>
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
  
  <xsl:template match="*[local-name() = 'Materials']" mode="details">
    <details>
      <summary>Materials</summary>
      <xsl:apply-templates select="*[local-name() = 'Descriptions']"/>
      <ul>
        <xsl:for-each select="./*[local-name() = 'Material']">
          <li>
            <xsl:value-of select="./*[local-name() = 'Domain']"/>
            <xsl:if test="./*[local-name() = 'Descriptions']/*[local-name() = 'Description']">
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
</xsl:stylesheet>
