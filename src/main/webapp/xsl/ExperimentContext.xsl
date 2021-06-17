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
</xsl:stylesheet>
