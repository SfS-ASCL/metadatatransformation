<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="">

  <xsl:output method="html" indent="yes"/>

  <xsl:template match="*[local-name() = 'GeneralInfo']" mode="def-list">
    <xsl:apply-templates select="*[local-name() = 'Descriptions']"/>
    <dl>
      <dt>Resource Name</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'ResourceName']"/>
      </dd>

      <dt>Resource Title</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'ResourceTitle']"/>
      </dd>

      <xsl:if test="//*[local-name() = 'IsPartOfList']/*[local-name() = 'IsPartOf']/text()">
        <dt>Part of Collection</dt>
        <dd>
          <ul>
            <xsl:for-each select="//*[local-name() = 'IsPartOfList']/*[local-name() = 'IsPartOf']">
              <li>
                <xsl:apply-templates select="." mode="link-to-url"/>
              </li>
            </xsl:for-each>
          </ul>
        </dd>
      </xsl:if>

      <dt>Resource Class</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'ResourceClass']"/>
      </dd>

      <dt>Version</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'Version']"/>
      </dd>

      <dt>Life Cycle Status</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'LifeCycleStatus']"/>
      </dd>

      <dt>Start Year</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'StartYear']"/>
      </dd>

      <dt>Completion Year</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'CompletionYear']"/>
      </dd>

      <dt>Publication Date</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'PublicationDate']"/>
      </dd>

      <dt>Last Update</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'LastUpdate']"/>
      </dd>

      <dt>Time Coverage</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'TimeCoverage']"/>
      </dd>

      <dt>Legal Owner</dt>
      <dd>
        <xsl:choose>
          <xsl:when test="./*[local-name() = 'LegalOwner']/text()">
            <xsl:value-of select="./*[local-name() = 'LegalOwner']"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Not specified</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </dd>

      <dt>Genre</dt>
      <dd>
        <xsl:apply-templates select="./*[local-name() = 'Genre']" mode="comma-separated-text"/>
      </dd>

      <dt>Field of Research</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'FieldOfResearch']"/>
      </dd>

      <dt>Location</dt>
      <dd>
        <xsl:value-of
          select="./*[local-name() = 'Location']/*[local-name() = 'Country']/*[local-name() = 'CountryName']"
        />
      </dd>

      <dt>Tags</dt>
      <dd>
        <xsl:apply-templates select="*[local-name() = 'tags']/*[local-name() = 'tag']" mode="comma-separated-text"/>
      </dd>

      <dt>Modality Info</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'ModalityInfo']//*[local-name() = 'Modalities']"/>
        <xsl:apply-templates select="./*[local-name() = 'ModalityInfo']/*[local-name() = 'Descriptions']" />
      </dd>
    </dl>
  </xsl:template>

</xsl:stylesheet>
