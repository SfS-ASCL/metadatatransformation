<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/" exclude-result-prefixes="">

  <xsl:output method="html" indent="yes"/>
  <xsl:template match="*[local-name() = 'Project']" mode="def-list">
    <xsl:apply-templates select="*[local-name() = 'Descriptions']"/>
    <dl>
      <dt>Project Name</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'ProjectName']"/>
      </dd>

      <dt>Project Title</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'ProjectTitle']"/>
      </dd>

      <dt>Project ID</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'ProjectID']"/>
      </dd>

      <dt>Url</dt>
      <dd>
        <xsl:apply-templates select="./*[local-name() = 'Url']" mode="link-to-url"/>
      </dd>

      <dt>Funder</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'Funder']/*[local-name() = 'fundingAgency']"/>
        <xsl:if test="./*[local-name() = 'Funder']/*[local-name() = 'fundingReferenceNumber'] != ''">
          <xsl:text>, with reference: </xsl:text>
          <xsl:value-of select="./*[local-name() = 'Funder']/*[local-name() = 'fundingReferenceNumber']"/>
        </xsl:if>
      </dd>

      <dt>Institution</dt>
      <dd>
        <xsl:apply-templates select="*[local-name() = 'Institution']"/>
      </dd>

      <dt>Cooperations</dt>
      <dd>
        <!-- omitted Cooperation dept., organisation, url, and descriptions -->
        <xsl:apply-templates select="./*[local-name() = 'Cooperation']/*[local-name() = 'CooperationPartner']"
                             mode="comma-separated-text"/>
      </dd>

      <!-- TODO: abstract template that does this for Project, Creators, etc. -->
      <dt>Person(s)</dt>
      <dd>
        <xsl:if test="./*[local-name() = 'Person']">
          <ul>
            <xsl:apply-templates select="./*[local-name() = 'Person']" mode="list-item-with-role"/>
          </ul>
        </xsl:if>
      </dd>

      <dt>Duration</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'Duration']/*[local-name() = 'StartYear']"/>
        <xsl:if test="./*[local-name() = 'Duration']/*[local-name() = 'CompletionYear'] != ''">
          <xsl:text> -- </xsl:text>
          <xsl:value-of select="./*[local-name() = 'Duration']/*[local-name() = 'CompletionYear']"/>
        </xsl:if>
      </dd>

    </dl>

  </xsl:template>

  <xsl:template name="InstitutionAsString" match="*[local-name() = 'Institution']">
    <xsl:if test="*[local-name() = 'Department'] != ''">
      <xsl:value-of select="*[local-name() = 'Department']"/>
    </xsl:if>

    <xsl:for-each select="./*[local-name() = 'Organisation']">
      <xsl:if
        test="./*[local-name() = 'AuthoritativeIDs']/*[local-name() = 'AuthoritativeID']/*[local-name() = 'id']">
        <xsl:for-each
          select="./*[local-name() = 'AuthoritativeIDs']/*[local-name() = 'AuthoritativeID']">
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

  <xsl:template match="*[local-name() = 'name']">
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
