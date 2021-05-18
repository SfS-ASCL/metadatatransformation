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

</xsl:stylesheet>
