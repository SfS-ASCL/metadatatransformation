<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cmd="http://www.clarin.eu/cmd/"
                exclude-result-prefixes="">

  <xsl:output method="html" indent="yes"/>
  
  <xsl:template name="ExperimentContextAsTable" match="*[local-name() = 'ExperimentContext']">
    <table>
      <!-- TODO: table header? -->
      <tbody>
        <tr>
          <xsl:for-each
              select="./*[local-name() = 'ExperimentalStudy']/*[local-name() = 'Experiment']">
            <tr>
              <td>
                <b>Name:</b>
              </td>
              <td>
                <xsl:value-of select="./*[local-name() = 'ExperimentName']"/>
              </td>
            </tr>
            <tr>
              <td>
                <b>Title:</b>
              </td>
              <td>
                <xsl:value-of select="./*[local-name() = 'ExperimentTitle']"/>
              </td>
            </tr>
            <tr>
              <td>
                <b>Paradigm:</b>
              </td>
              <td>
                <xsl:value-of select="./*[local-name() = 'ExperimentalParadigm']"/>
              </td>
            </tr>
            <tr>
              <td>
                <b>Description:</b>
              </td>
              <td>

                <xsl:apply-templates select="*[local-name() = 'Descriptions']"/> 
                <!--<xsl:value-of
                    select="./*[local-name() = 'Descriptions']/*[local-name() = 'Description']"/> -->
              </td>
            </tr>
            <!-- more here -->
            <tr>
              <td>
                <b>Experimental Quality:</b>
              </td>
              <td>
                <xsl:value-of
                    select="./*[local-name() = 'ExperimentalQuality']/*[local-name() = 'QualityCriteria']"
                    />
              </td>
            </tr>
            <tr>
              <td>
                <b>Subject Language(s):</b>
              </td>
              <td>
                <xsl:value-of
                    select="./*[local-name() = 'SubjectLanguages']/*[local-name() = 'SubjectLanguage']/*[local-name() = 'Language']/*[local-name() = 'LanguageName']"
                    />
              </td>
            </tr>
            <tr>
              <td>
                <b>Material(s):</b>
              </td>
              <td>
                <ul>
                  <xsl:for-each
                      select="./*[local-name() = 'Materials']/*[local-name() = 'Material']">
                    <li>
                      <xsl:value-of select="./*[local-name() = 'Domain']"/>
                      <xsl:if
                          test="./*[local-name() = 'Descriptions']/*[local-name() = 'Description'] != ''">
                        <xsl:text>
			  : 
			</xsl:text>
                        <xsl:apply-templates select="*[local-name() = 'Descriptions']"/> 
                        <!-- <xsl:value-of
			     select="./*[local-name() = 'Descriptions']/*[local-name() = 'Description']" /> -->
                      </xsl:if>
                    </li>
                  </xsl:for-each>
                </ul>
              </td>
            </tr>
            <tr>
              <td>
                <b>Hypotheses:</b>
              </td>
              <td>
                <xsl:value-of
                    select="./*[local-name() = 'Hypotheses']/*[local-name() = 'Hypothesis']/*[local-name() = 'Descriptions']/*[local-name() = 'Description']"
                    />
              </td>
            </tr>
            <!-- much more here -->
            <tr>
              <td>
                <b>Method(s):</b>
              </td>
              <td>
                <table border="3" cellpadding="10" cellspacing="10">
                  <tr>
                    <td>
                      <b>Experiment type:</b>
                    </td>
                    <td>
                      <xsl:value-of
                          select="./*[local-name() = 'Method']/*[local-name() = 'Elicitation']//*[local-name() = 'ExperimentType']"
                          />
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <b>Elicitation instrument:</b>
                    </td>
                    <td>
                      <xsl:value-of
                          select="./*[local-name() = 'Method']/*[local-name() = 'Elicitation']//*[local-name() = 'ElicitationInstrument']"
                          />
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <b>Elicitation software:</b>
                    </td>
                    <td>
                      <xsl:value-of
                          select="./*[local-name() = 'Method']/*[local-name() = 'Elicitation']//*[local-name() = 'ElicitationSoftware']"
                          />
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <b>Variable(s)</b>
                    </td>
                    <td>
                      <ul>
                        <xsl:for-each
                            select="./*[local-name() = 'Method']/*[local-name() = 'Elicitation']/*[local-name() = 'Variables']/*[local-name() = 'Variable']">
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
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <b>Participant(s)</b>
                    </td>
                    <td>
                      <table border="3" cellpadding="10" cellspacing="10">
                        <tr>
                          <td>
                            <b>Anonymization flag:</b>
                          </td>
                          <td>
                            <xsl:value-of
                                select="./*[local-name() = 'Method']/*[local-name() = 'Participants']/*[local-name() = 'AnonymizationFlag']"
                                />
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <b>Sampling method:</b>
                          </td>
                          <td>
                            <xsl:value-of
                                select="./*[local-name() = 'Method']/*[local-name() = 'Participants']/*[local-name() = 'SamplingMethod']"
                                />
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <b>Sampling size:</b>
                          </td>
                          <td>
                            <xsl:value-of
                                select="./*[local-name() = 'Method']/*[local-name() = 'Participants']/*[local-name() = 'SampleSize']/*[local-name() = 'Size']"/>
                            <xsl:if
                                test="./*[local-name() = 'Method']/*[local-name() = 'Participants']/*[local-name() = 'SampleSize']/*[local-name() = 'SizeUnit'] != ''">
                              <xsl:text> </xsl:text>
                              <xsl:value-of
                                  select="./*[local-name() = 'Method']/*[local-name() = 'Participants']/*[local-name() = 'SampleSize']/*[local-name() = 'SizeUnit']"
                                  />
                            </xsl:if>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <b>Sex distribution:</b>
                          </td>
                          <td>
                            <ul>
                              <xsl:for-each
                                  select="./*[local-name() = 'Method']/*[local-name() = 'Participants']/*[local-name() = 'SexDistribution']/*[local-name() = 'SexDistributionInfo']">
                                <li>
                                  <xsl:value-of select="./*[local-name() = 'ParticipantSex']"
                                                />:<xsl:value-of select="./*[local-name() = 'Size']"/>
                                </li>
                              </xsl:for-each>
                            </ul>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <b>Age distribution:</b>
                          </td>
                          <td>
                            <xsl:value-of
                                select="./*[local-name() = 'Method']/*[local-name() = 'Participants']//*[local-name() = 'ParticipantMeanAge']"
                                />
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <b>Language variety:</b>
                          </td>
                          <td>
                            <xsl:value-of
                                select="./*[local-name() = 'Method']/*[local-name() = 'Participants']//*[local-name() = 'VarietyName']"
                                />:<xsl:value-of
                                select="./*[local-name() = 'Method']/*[local-name() = 'Participants']//*[local-name() = 'NoParticipants']"
                                />
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr>
              <td>
                <b>Results:</b>
              </td>
              <td>
                <xsl:value-of
                    select="./*[local-name() = 'Results']/*[local-name() = 'Descriptions']/*[local-name() = 'Description']"
                    />
              </td>
            </tr>
            <tr>
              <td>
                <b>Analysis Tool Info:</b>
              </td>
              <td>
                <xsl:value-of
                    select="./*[local-name() = 'AnalysisToolInfo']/*[local-name() = 'AnalysisTool']"/>
                <xsl:if
                    test="./*[local-name() = 'AnalysisToolInfo']/*[local-name() = 'ToolType'] != ''"
                    > (<xsl:value-of
                    select="./*[local-name() = 'AnalysisToolInfo']/*[local-name() = 'ToolType']"
                    />) </xsl:if>
                <xsl:if
                    test="./*[local-name() = 'AnalysisToolInfo']/*[local-name() = 'Version'] != ''">
                  , Version: <xsl:value-of
                  select="./*[local-name() = 'AnalysisToolInfo']/*[local-name() = 'Version']"/>.
                </xsl:if>
              </td>
            </tr>
            <tr>
              <td>
                <b>Type-specific Size info: </b>
              </td>
              <td>
                <xsl:value-of
                    select="./*[local-name() = 'TypeSpecificSizeInfo']/*[local-name() = 'TypeSpecificSize']/*[local-name() = 'Size']"
                    />
              </td>
            </tr>
            <hr/>
          </xsl:for-each>
        </tr>
      </tbody>
    </table>
  </xsl:template>



  <!-- New approach starts here: -->
  <xsl:template name="ExperimentContextAsSection" match="*[local-name() = 'ExperimentContext']">
    <section>
      <!-- TODO: move this to main.css once finished -->
      <style> 
        div.experiment { border-top: 1px solid grey; }
        dt { font-weight: bold; }
        dd { padding-left: 1em; }
      </style>
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
      <xsl:apply-templates select="./*[local-name() = 'ExperimentalStudy']"/>
    </section>
    
  </xsl:template>

  <xsl:template name="ExperimentalStudySection" match="*[local-name() = 'ExperimentalStudy']">
    <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
    <xsl:apply-templates select="./*[local-name() = 'Experiment']"/>
  </xsl:template>

  <xsl:template name="ExperimentSection" match="*[local-name() = 'Experiment']">
    <div class="experiment">
      <xsl:call-template name="ExperimentInfoAsDefList"/>
      <xsl:apply-templates select="*[local-name() = 'Descriptions']"/> 

      <details>
        <summary>Methods</summary>
        <xsl:call-template name="MethodAsDefList"/>
      </details>

      <details>
        <summary>Results</summary>
        <xsl:apply-templates select="./*[local-name() = 'Results']/*[local-name() = 'Descriptions']"/>
      </details>

      <details>
        <summary>Materials</summary>
        <xsl:apply-templates select="./*[local-name() = 'Materials']/*[local-name() = 'Descriptions']"/> 
        <xsl:call-template name="MaterialsAsList"/>
      </details>
    </div>
  </xsl:template>
 
  <xsl:template name="ExperimentInfoAsDefList">
    <dl>
      <dt>Name</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'ExperimentName']"/>
      </dd>
      <dt>Title</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'ExperimentTitle']"/>
      </dd>
      <dt>Paradigm</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'ExperimentalParadigm']"/>
      </dd>
    </dl>
  </xsl:template>

  <xsl:template name="MethodAsDefList" match="*[local-name() = 'Method']">
    <dl>
      <dt>
        Experiment type:
      </dt>
      <dd>
        <xsl:value-of
            select="./*[local-name() = 'Method']/*[local-name() = 'Elicitation']//*[local-name() = 'ExperimentType']"
            />
      </dd>
      <dt>
        Elicitation instrument:
      </dt>
      <dd>
        <xsl:value-of
            select="./*[local-name() = 'Method']/*[local-name() = 'Elicitation']//*[local-name() = 'ElicitationInstrument']"
            />
      </dd>
      <dt>
        Elicitation software:
      </dt>
      <dd>
        <xsl:value-of
            select="./*[local-name() = 'Method']/*[local-name() = 'Elicitation']//*[local-name() = 'ElicitationSoftware']"
            />
      </dd>
      <dt>
        Variable(s)
      </dt>
      <dd>
        <ul>
          <xsl:for-each
              select="./*[local-name() = 'Method']/*[local-name() = 'Elicitation']/*[local-name() = 'Variables']/*[local-name() = 'Variable']">
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
      <dt>
        Participant(s)
      </dt>
      <dd>
        <dl>
          
          <dt>
            Anonymization flag:
          </dt>
          <dd>
            <xsl:value-of
                select="./*[local-name() = 'Method']/*[local-name() = 'Participants']/*[local-name() = 'AnonymizationFlag']"
                />
          </dd>
          
          
          <dt>
            Sampling method:
          </dt>
          <dd>
            <xsl:value-of
                select="./*[local-name() = 'Method']/*[local-name() = 'Participants']/*[local-name() = 'SamplingMethod']"
                />
          </dd>
          
          
          <dt>
            Sampling size:
          </dt>
          <dd>
            <xsl:value-of
                select="./*[local-name() = 'Method']/*[local-name() = 'Participants']/*[local-name() = 'SampleSize']/*[local-name() = 'Size']"/>
            <xsl:if
                test="./*[local-name() = 'Method']/*[local-name() = 'Participants']/*[local-name() = 'SampleSize']/*[local-name() = 'SizeUnit'] != ''">
              <xsl:text> </xsl:text>
              <xsl:value-of
                  select="./*[local-name() = 'Method']/*[local-name() = 'Participants']/*[local-name() = 'SampleSize']/*[local-name() = 'SizeUnit']"
                  />
            </xsl:if>
            <xsl:apply-templates
                select="./*[local-name() = 'Method']/*[local-name() = 'Participants']/*[local-name() = 'SampleSize']/*[local-name() = 'Descriptions']" />
          </dd>
          
          
          <dt>
            Sex distribution:
          </dt>
          <dd>
            <xsl:apply-templates select="./*[local-name() = 'Method']/*[local-name() = 'Participants']/*[local-name() = 'SexDistribution']"/>
          </dd>
          
          
          <dt>
            Age distribution:
          </dt>
          <dd>
            <xsl:apply-templates select="./*[local-name() = 'Method']/*[local-name() = 'Participants']/*[local-name() = 'AgeDistribution']"/>
          </dd>
          
          <dt>
            Language variety:
          </dt>
          <dd>
            <xsl:value-of
                select="./*[local-name() = 'Method']/*[local-name() = 'Participants']//*[local-name() = 'VarietyName']"
                />:<xsl:value-of
                select="./*[local-name() = 'Method']/*[local-name() = 'Participants']//*[local-name() = 'NoParticipants']"
                />
          </dd>
          
        </dl>
      </dd>
    </dl>
  </xsl:template>

  <xsl:template name="MaterialsAsList">
    <ul>
      <xsl:for-each
          select="./*[local-name() = 'Materials']/*[local-name() = 'Material']">
        <li>
          <xsl:value-of select="./*[local-name() = 'Domain']"/>
          <xsl:if
              test="./*[local-name() = 'Descriptions']/*[local-name() = 'Description']">
            <xsl:text>
	      : 
	    </xsl:text>
            <!-- TODO: this selection doesn't appear to work right -->
            <xsl:apply-templates select="*[local-name() = 'Descriptions']"/> 
          </xsl:if>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template name="SexDistributionAsTable" match="*[local-name() = 'SexDistribution']">
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
  
  <xsl:template name="AgeDistributionAsTable" match="*[local-name() = 'AgeDistribution']">
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
  
</xsl:stylesheet>
