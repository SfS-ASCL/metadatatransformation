<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="xs xd functx">

  <!-- TODO: split out Annotation, Source, and Derivations into detail sections-->
  <xsl:output method="html" indent="yes"/>
  <xsl:template name="CreationAsTable" match="*[local-name() = 'Creation']">
    <table>
      <!-- TODO: table header? -->
      <tbody>
        <tr>
          <td>
            <b>Topic:</b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'Topic']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Creator(s): </b>
          </td>
          <td>
            <xsl:for-each select="./*[local-name() = 'Creators']/*[local-name() = 'Person']">
              <xsl:choose>
                <xsl:when
                    test="./*[local-name() = 'AuthoritativeIDs']/*[local-name() = 'AuthoritativeID']/*[local-name() = 'id'] != ''">
                  <xsl:element name="a">
                    <xsl:attribute name="href">
                      <xsl:value-of
                          select=".//*[local-name() = 'AuthoritativeID'][1]/*[local-name() = 'id']"
                          />
                    </xsl:attribute>
                    <xsl:value-of select="./*[local-name() = 'firstName']"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="./*[local-name() = 'lastName']"/>
                  </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="./*[local-name() = 'firstName']"/>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="./*[local-name() = 'lastName']"/>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:if test="./*[local-name() = 'role'] != ''"> (<xsl:value-of
              select="./*[local-name() = 'role']"/>) </xsl:if>
              <xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
          </td>
        </tr>
        <xsl:for-each select="./*[local-name() = 'CreationToolInfo']">
          <tr>
            <td>
              <b>Creation Tool</b>
            </td>
            <td>
              <xsl:value-of select="./*[local-name() = 'CreationTool']"/>
              <xsl:if test="./*[local-name() = 'ToolType'] != ''">
                <xsl:text> (</xsl:text>
                <xsl:value-of select="./*[local-name() = 'ToolType']"/>
                <xsl:text>)</xsl:text>
              </xsl:if>
            </td>
          </tr>
        </xsl:for-each>
        <xsl:if test="//*[local-name() = 'AnnotationMode']">
          <tr>
            <td>
              <b>Annotation:</b>
            </td>
            <td>
              <table border="3" cellpadding="10" cellspacing="10">
                <tr>
                  <td>
                    <b>Annotation Mode:</b>
                  </td>
                  <td>
                    <xsl:value-of select=".//*[local-name() = 'AnnotationMode']"/>
                  </td>
                </tr>
                <tr>
                  <td>
                    <b>Annotation Standoff:</b>
                  </td>
                  <td>
                    <xsl:value-of select=".//*[local-name() = 'AnnotationStandoff']"/>
                  </td>
                </tr>
                <tr>
                  <td>
                    <b>Interannotator Agreement:</b>
                  </td>
                  <td>
                    <xsl:value-of select=".//*[local-name() = 'InterannotatorAgreement']"/>
                  </td>
                </tr>
                <tr>
                  <td>
                    <b>Annotation Format:</b>
                  </td>
                  <td>
                    <xsl:value-of select=".//*[local-name() = 'AnnotationFormat']"/>
                  </td>
                </tr>
                <tr>
                  <td>
                    <b>Segmentation Units:</b>
                  </td>
                  <td>
                    <xsl:value-of select=".//*[local-name() = 'SegmentationUnits']"/>
                  </td>
                </tr>
                <xsl:for-each select=".//*[local-name() = 'AnnotationType']">
                  <tr>
                    <td>
                      <b>Annotation Type:</b>
                    </td>
                    <td>
                      <table>
                        <tr>
                          <td>
                            <b>Annotation Level Type(s): </b>
                          </td>
                          <td>
                            <xsl:for-each select="./*[local-name() = 'AnnotationLevelType']">
                              <xsl:value-of select="."/>
                              <xsl:if test="position() != last()">, </xsl:if>
                            </xsl:for-each>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <b>Annotation Mode(s): </b>
                          </td>
                          <td>
                            <xsl:for-each select="./*[local-name() = 'AnnotationMode']">
                              <xsl:value-of select="."/>
                              <xsl:if test="position() != last()">, </xsl:if>
                            </xsl:for-each>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <b>Tagset(s): </b>
                          </td>
                          <td>
                            <xsl:for-each select="./*[local-name() = 'TagsetInfo']">
                              <xsl:value-of select="./*[local-name() = 'Tagset']"/>
                              <xsl:if test="position() != last()">, </xsl:if>
                            </xsl:for-each>
                          </td>
                        </tr>

                        <tr>
                          <td>
                            <b>Descriptions(s): </b>
                          </td>
                          <td>
                            <xsl:value-of select=".//*[local-name() = 'Description']"/>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </xsl:for-each>
                <xsl:for-each select=".//*[local-name() = 'AnnotationToolInfo']">
                  <tr>
                    <td>
                      <b>Annotation Tool Info:</b>
                    </td>
                    <td>
                      <table>
                        <tr>
                          <td>
                            <b>Annotation Tool(s): </b>
                          </td>
                          <td>
                            <xsl:for-each select="./*[local-name() = 'AnnotationTool']">
                              <xsl:value-of select="."/>
                              <xsl:if test="position() != last()">, </xsl:if>
                            </xsl:for-each>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <b>Tool Type(s): </b>
                          </td>
                          <td>
                            <xsl:for-each select="./*[local-name() = 'ToolType']">
                              <xsl:value-of select="."/>
                              <xsl:if test="position() != last()">, </xsl:if>
                            </xsl:for-each>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <b>Versions(s): </b>
                          </td>
                          <td>
                            <xsl:for-each select="./*[local-name() = 'Version']">
                              <xsl:value-of select="."/>
                              <xsl:if test="position() != last()">, </xsl:if>
                            </xsl:for-each>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <b>Url(s): </b>
                          </td>
                          <td>
                            <xsl:for-each select="./*[local-name() = 'Url']">
                              <xsl:value-of select="."/>
                              <xsl:if test="position() != last()">, </xsl:if>
                            </xsl:for-each>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <b>Description(s):</b>
                          </td>
                          <td>
                            <xsl:value-of select=".//*[local-name() = 'Description']"/>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </xsl:for-each>
                <tr>
                  <td>
                    <b>Annotation Descriptions:</b>
                  </td>
                  <td>
                    <xsl:value-of select=".//*[local-name() = 'Description']"/>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </xsl:if>
        <xsl:for-each select="./*[local-name() = 'Source']">
          <tr>
            <td>
              <b>Source:</b>
            </td>
            <td>
              <table border="3" cellpadding="10" cellspacing="10">
                <tr>
                  <td>
                    <b>Original Source</b>
                  </td>
                  <td>
                    <xsl:value-of select="./*[local-name() = 'OriginalSource']"/>
                    <xsl:if test="./*[local-name() = 'SourceType'] != ''">
                      <xsl:text> (</xsl:text>
                      <xsl:value-of select="./*[local-name() = 'SourceType']"/>
                      <xsl:text>)</xsl:text>
                    </xsl:if>
                  </td>
                </tr>
                <tr>
                  <xsl:for-each select="./*[local-name() = 'MediaFiles']">
                    <tr>
                      <td>
                        <b>Catalogue Link:</b>
                      </td>
                      <td>
                        <xsl:value-of select="./*[local-name() = 'CatalogueLink']"/>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <b>Type:</b>
                      </td>
                      <td>
                        <xsl:value-of select="./*[local-name() = 'Type']"/>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <b>Format:</b>
                      </td>
                      <td>
                        <xsl:value-of select="./*[local-name() = 'Format']"/>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <b>Size:</b>
                      </td>
                      <td>
                        <xsl:value-of select="./*[local-name() = 'Size']"/>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <b>Quality:</b>
                      </td>
                      <td>
                        <xsl:value-of select="./*[local-name() = 'Quality']"/>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <b>Description:</b>
                      </td>
                      <td>
                        <xsl:value-of select="./*[local-name() = 'Description']"/>
                      </td>
                    </tr>
                  </xsl:for-each>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td>
              <b>Derivation:</b>
            </td>
            <td>
              <table border="3" cellpadding="10" cellspacing="10">
                <tr>
                  <td>
                    <b>Organisation(s)</b>
                  </td>
                  <td>
                    <xsl:for-each select=".//*[local-name() = 'Organisation']">
                      <xsl:value-of select="."/>
                      <xsl:if test="position() != last()">, </xsl:if>
                    </xsl:for-each>
                  </td>
                </tr>
                <tr>
                  <td>
                    <b>Derivation Date</b>
                  </td>
                  <td>
                    <xsl:value-of select=".//*[local-name() = 'DerivationDate']"/>
                  </td>
                </tr>
                <tr>
                  <td>
                    <b>Derivation Mode(s)</b>
                  </td>
                  <td>
                    <xsl:for-each select=".//*[local-name() = 'DerivationMode']">
                      <xsl:value-of select="."/>
                      <xsl:if test="position() != last()">, </xsl:if>
                    </xsl:for-each>
                  </td>
                </tr>
                <tr>
                  <td>
                    <b>Derivation Type(s)</b>
                  </td>
                  <td>
                    <xsl:for-each select=".//*[local-name() = 'DerivationType']">
                      <xsl:value-of select="."/>
                      <xsl:if test="position() != last()">, </xsl:if>
                    </xsl:for-each>
                  </td>
                </tr>
                <tr>
                  <td>
                    <b>Derivation Workflow(s)</b>
                  </td>
                  <td>
                    <xsl:for-each select=".//*[local-name() = 'DerivationWorkflow']">
                      <xsl:value-of select="."/>
                      <xsl:if test="position() != last()">, </xsl:if>
                    </xsl:for-each>
                  </td>
                </tr>
                <tr>
                  <td>
                    <b>Derivation Tool Info</b>
                  </td>
                  <td>
                    <xsl:for-each select=".//*[local-name() = 'DerivationToolInfo']">
                      <xsl:value-of select="."/>
                      <xsl:if test="position() != last()">, </xsl:if>
                    </xsl:for-each>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template name="CitationExamples">
    <!-- Provides the contents of the "Cite data set" tab -->
    <p>Please cite the data set itself as follows:</p>
    <p>
      <xsl:call-template name="DatasetCitation"/>
    </p>
    <xsl:if test="count(//*[local-name() = 'ResourceRef']) > 1">
      <p>
        Individual items in the data set may be cited using their
        persistent identifiers (see Data Files). For example:
      </p>
      <p>
        <xsl:call-template name="InDatasetCitation"/>
      </p>  
    </xsl:if>
  </xsl:template>

  <xsl:template name="DatasetCitation">
    <!-- Provides a citation for the whole dataset -->
      <xsl:call-template name="CreatorsAsCommaSeparatedText" />
      <xsl:call-template name="CreationDatesAsText" />
      <xsl:call-template name="TitleAsCite" />
      Data set in Tübingen Archive of Language Resources. 
      <br/>Persistent identifier: <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="//*[local-name() = 'MdSelfLink']"/>
      </xsl:attribute>
      <xsl:value-of select="//*[local-name() = 'MdSelfLink']"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="InDatasetCitation">
    <!-- Provides an example citation of an individual item in the
         collection, using the second ResourceRef element in the document.
         (We use the second because the first might be the landing page and have the same 
         PID as the data set itself.
    -->
      <xsl:call-template name="CreatorsAsCommaSeparatedText" />
      <xsl:call-template name="CreationDatesAsText" />
      <xsl:value-of select="substring-after((//*[local-name() = 'ResourceRef'])[2], '@')" />
      <xsl:text>. </xsl:text>
      In: <xsl:call-template name="TitleAsCite" />
      Data set in Tübingen Archive of Language Resources. 
      <br/>Persistent identifier: <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="(//*[local-name() = 'ResourceRef'])[2]"/>
        </xsl:attribute>
        <xsl:value-of select="(//*[local-name() = 'ResourceRef'])[2]"/>
      </xsl:element>
  </xsl:template>

  <xsl:template name="CreatorsAsCommaSeparatedText">
    <!-- Get the list of creators, last name followed by initial, comma separated -->
    <xsl:for-each select="//*[local-name() = 'Creators']/*[local-name() = 'Person']/.">
      <xsl:choose>
        <!-- when ID is available, markup the creator's name as an author -->
        <!-- See: https://html.spec.whatwg.org/multipage/links.html#link-type-author -->
        <xsl:when
            test="./*[local-name() = 'AuthoritativeIDs']/*[local-name() = 'AuthoritativeID']/*[local-name() = 'id'] != ''">
          <xsl:element name="a">
            <xsl:attribute name="author">
              <xsl:value-of select=".//*[local-name() = 'AuthoritativeID'][1]/*[local-name() = 'id']" />
            </xsl:attribute>
            <xsl:value-of select="*[local-name() = 'lastName']"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="substring(*[local-name() = 'firstName'], 1, 1)"/>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="*[local-name() = 'lastName']"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="substring(*[local-name() = 'firstName'], 1, 1)"/>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="position() = last()">
          <xsl:text>.</xsl:text>
        </xsl:when>
        <xsl:when test="position() = last() - 1">
          <xsl:text>. &amp; </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>., </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="CreationDatesAsText">
      <!-- Provides publication date and last update like (YYYY): or (YYYY-YYYY): --> 
      <!-- Assumes the first 4 characters in PublicationDate and LastUpdate refer to the year -->
      <xsl:text> (</xsl:text>
      <xsl:value-of select="substring-before(//*[local-name() = 'PublicationDate'], '-')"/>
      <xsl:if test="//*[local-name() = 'LastUpdate'] !=''">
	<xsl:text> - </xsl:text>
	<xsl:value-of select="substring-before(//*[local-name() = 'LastUpdate'], '-')"/>
      </xsl:if>            
      <xsl:text>): </xsl:text>

  </xsl:template>

  <xsl:template name="TitleAsCite">
    <cite>
      <xsl:choose>
        <xsl:when test="//*[local-name() = 'ResourceTitle']">
          <xsl:choose>
            <!-- If the title is available in English, display it -->
            <xsl:when test="//*[local-name() = 'ResourceTitle']/@xml:lang = 'en'">
              <xsl:value-of select="//*[local-name() = 'ResourceTitle'][@xml:lang = 'en']"/>
            </xsl:when>
            <!-- If not, display the title in available language (might still be English but not specified as such) -->
            <xsl:otherwise>
              <xsl:value-of select="//*[local-name() = 'ResourceTitle']"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="//*[local-name() = 'ResourceName']"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="//*[local-name() = 'Version']/text()">
        <xsl:text>, version </xsl:text>
        <xsl:value-of select="//*[local-name() = 'Version']/text()" />
      </xsl:if>
    </cite>
    <xsl:text>. </xsl:text>
  </xsl:template>

</xsl:stylesheet>
