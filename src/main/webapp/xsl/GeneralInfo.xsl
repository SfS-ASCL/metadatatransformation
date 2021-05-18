<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="xs xd functx">

  <xsl:output method="html" indent="yes"/>


  <!-- GeneralInfo -->
  <!-- Things that could be improved here:-->
  <!-- 1) Don't display rows for missing fields -->
  <!-- 3) Map data provided in various languages to the language of the browser -->
  <xsl:template name="GeneralInfoAsTable" match="*[local-name() = 'GeneralInfo']">
    <table>
      <!-- TODO: in-table header? -->
      <tbody>
        <tr>
          <td>
            <b>Resource Name: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'ResourceName']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Resource Title: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'ResourceTitle']"/>
          </td>
        </tr>
        
        <!-- TODO: is this needed? IsPartOfList doesn't seem to be part
             of the GeneralInfo component as it's listed in the registry -->
        <xsl:if test="//*[local-name() = 'IsPartOfList']/*[local-name() = 'IsPartOf']/text()">
          <tr>
            
            <td>
              <b>Part of Collection:</b>
              
            </td>
            <td><!-- <a href="{./*:IsPartOf}"><xsl:value-of select="./*:IsPartOf"/></a> -->
              
              <xsl:for-each select="//*[local-name() = 'IsPartOfList']/*[local-name() = 'IsPartOf']">
                <table>
                  
                  <tr>
                    <td>
                      <xsl:element name="a">
                        <xsl:attribute name="href">
                          <xsl:value-of select="."/>
                        </xsl:attribute>
                        <xsl:value-of select="."/>
                      </xsl:element>
                    </td>
                  </tr>
                </table>
                
                
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>
        
        <tr>
          <td>
            <b>Resource Class: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'ResourceClass']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Version: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'Version']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Life Cycle Status: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'LifeCycleStatus']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Start Year: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'StartYear']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Completion Year: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'CompletionYear']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Publication Date: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'PublicationDate']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Last Update: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'LastUpdate']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Time Coverage: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'TimeCoverage']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Legal Owner: </b>
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="./*[local-name() = 'LegalOwner']/text()">
                <xsl:value-of select="./*[local-name() = 'LegalOwner']"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>Not specified</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td>
            <b>Genre: </b>
          </td>
          <td>
	    <xsl:apply-templates select="./*[local-name() = 'Genre']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Field of Research: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'FieldOfResearch']"/>
          </td>
        </tr>
        <!-- TODO: select by xml:lang -->
        <tr>
          <td>
            <b>Location: </b>
          </td>
          <td>
            <xsl:value-of
                select="./*[local-name() = 'Location']/*[local-name() = 'Country']/*[local-name() = 'CountryName']"
                />
          </td>
        </tr>
        <tr>
          <td>
            <b>Description: </b>
          </td>
          <td>
            <xsl:apply-templates select="*[local-name() = 'Descriptions']"/> 
            <!-- <xsl:value-of
                    select="./*[local-name() = 'Descriptions']/*[local-name() = 'Description']"/> -->
          </td>
        </tr>
        <tr>
          <td>
            <b>Tags: </b>
          </td>
          <td>
            <xsl:apply-templates select="*[local-name() = 'tags']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Modality Info: </b>
          </td>
          <td>
            <xsl:value-of
                select="./*[local-name() = 'ModalityInfo']//*[local-name() = 'Modalities']"/>
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template name="TagsAsCommaSeparated" match="*[local-name() = 'tags']">
    <xsl:for-each select="./*[local-name() = 'tag'][not(position() = last())]">
      <xsl:value-of select="."/>
      <xsl:text>, </xsl:text>
    </xsl:for-each>
    <xsl:for-each select="./*[local-name() = 'tag'][position() = last()]">
      <xsl:value-of select="."/>
    </xsl:for-each>
  </xsl:template>
 
  <xsl:template match="*[local-name()='Genre']">
    <xsl:choose>
      <xsl:when test="following-sibling::*[local-name()='Genre']">
        <xsl:value-of select="."/>
        <xsl:text>, </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
