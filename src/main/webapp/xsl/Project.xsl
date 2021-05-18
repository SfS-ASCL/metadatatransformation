<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="xs xd functx">

  <xsl:output method="html" indent="yes"/>
  <xsl:template name="ProjectAsTable" match="*[local-name() = 'Project']">
    <table>
      <!-- TODO: table header? -->
      <!-- TODO: xml:lang selection for description, other fields  -->
      <tbody>
        <tr>
          <td>
            <b>Project Name: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'ProjectName']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Project Title: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'ProjectTitle']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Project ID: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'ProjectID']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Url: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'Url']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Funder: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'Funder']/*[local-name() = 'fundingAgency']"/>
            <xsl:if
                test="./*[local-name() = 'Funder']/*[local-name() = 'fundingReferenceNumber'] != ''">
              <xsl:text>, with reference: 
	      </xsl:text>
            </xsl:if>
            <xsl:value-of
                select="./*[local-name() = 'Funder']/*[local-name() = 'fundingReferenceNumber']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Institution: </b>
          </td>
          <td>
            <xsl:apply-templates select="*[local-name()='Institution']"></xsl:apply-templates>
          </td>
        </tr>
        <tr>
          <td>
            <b>Cooperations: </b>
          </td>
          <td>
            <!-- omitted Cooperation dept., organisation, url, and descriptions -->
            <xsl:for-each select="./*[local-name() = 'Cooperation']">
              <xsl:value-of select="./*[local-name() = 'CooperationPartner']"/>
              <xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
          </td>
        </tr>
        <tr>
          <td>
            <b>Person(s): </b>
          </td>
          <td>
            <xsl:for-each select="./*[local-name() = 'Person']">
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
              <xsl:if test="./*[local-name() = 'Role'] != ''">
                <xsl:text> (</xsl:text>
                <xsl:value-of select="./*[local-name() = 'Role']"/>
                <xsl:text>)</xsl:text>
              </xsl:if>
              <xsl:if test="position() != last()">, </xsl:if>
            </xsl:for-each>
          </td>
        </tr>
        <tr>
          <td>
            <b>Descriptions: </b>
          </td>
          <td>
            <xsl:apply-templates select="*[local-name() = 'Descriptions']"/> 
	    <!-- <xsl:value-of
		 select="./*[local-name() = 'Descriptions']/*[local-name() = 'Description']"/> -->
          </td>
        </tr>
        <tr>
          <td>
            <b>Duration: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'Duration']/*[local-name() = 'StartYear']"/>
            <xsl:if test="./*[local-name() = 'Duration']/*[local-name() = 'CompletionYear'] != ''">
              <xsl:text>

	        --
	      </xsl:text>
            </xsl:if>
            <xsl:value-of
                select="./*[local-name() = 'Duration']/*[local-name() = 'CompletionYear']"/>
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template name="InstitutionAsString"
                match="*[local-name() = 'Institution']">
    <xsl:if test="*[local-name() = 'Department'] != ''">
      <xsl:value-of select="*[local-name() = 'Department']"/>
    </xsl:if>

    <xsl:for-each select="./*[local-name() = 'Organisation']">
      <xsl:if test="./*[local-name() = 'AuthoritativeIDs']/*[local-name() = 'AuthoritativeID']/*[local-name() = 'id']">
        <xsl:for-each select="./*[local-name() = 'AuthoritativeIDs']/*[local-name() = 'AuthoritativeID']">
          <xsl:if test="./*[local-name() = 'issuingAuthority'] = 'VIAF'">
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="./*[local-name() = 'id']"/>
              </xsl:attribute>
              <xsl:apply-templates select="../../*[local-name() = 'name']"/>
            </xsl:element>
          </xsl:if>
          <xsl:if test="not(/*[local-name() = 'AuthoritativeIDs'])">
            <xsl:apply-templates select="*[local-name() = 'name']"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:if>
      <br/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="*[local-name()='name']">
    <xsl:if test="./@xml:lang">
      <xsl:if test="./@xml:lang = 'nl'"> Dutch: <xsl:value-of select="."/><br/>
      </xsl:if>
      <xsl:if test="./@xml:lang = 'en'"> English: <xsl:value-of select="."/><br/>
      </xsl:if>
      <xsl:if test="./@xml:lang = 'de'"> German: <xsl:value-of select="."/><br/>
      </xsl:if>
    </xsl:if>
    <xsl:if test="not(./@xml:lang = 'en' or ./@xml:lang = 'de' or ./@xml:lang = 'nl')"> Other:
        <xsl:value-of select="."/><br/>
    </xsl:if>
  </xsl:template>


</xsl:stylesheet>
