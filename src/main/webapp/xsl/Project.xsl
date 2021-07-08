<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/" exclude-result-prefixes="">

  <xsl:output method="html" indent="yes"/>
  <xsl:template match="*[local-name() = 'Project']" mode="def-list">
    <xsl:call-template name="ProjectTitleAsHeadline"/>
    <xsl:apply-templates select="*[local-name() = 'Descriptions']"/>
    <xsl:if test="./*[local-name() = 'Person']">
      <h3>Project members</h3>
      <ul>
        <xsl:apply-templates select="./*[local-name() = 'Person']" mode="list-item-with-role"/>
      </ul>
    </xsl:if>

    <xsl:apply-templates select="./*[local-name() = 'Cooperations']" mode="list"/>

    <h3>Institutional details</h3>
    <dl>
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
          <xsl:value-of
            select="./*[local-name() = 'Funder']/*[local-name() = 'fundingReferenceNumber']"/>
        </xsl:if>
      </dd>

      <dt>Institution</dt>
      <dd>
        <xsl:apply-templates select="*[local-name() = 'Institution']"/>
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

  <xsl:template name="ProjectTitleAsHeadline">
    <h3>
      <xsl:value-of select="./*[local-name() = 'ProjectTitle']"/>
      <xsl:text> (</xsl:text>
      <xsl:apply-templates select="./*[local-name() = 'Url']" mode="link-to-url">
        <xsl:with-param name="link-text">
          <xsl:value-of select="./*[local-name() = 'ProjectName']"/>
        </xsl:with-param>
      </xsl:apply-templates>
      <xsl:text>)</xsl:text>
    </h3>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Cooperations']" mode="list">
    <h3>Cooperation</h3>
    <xsl:apply-templates select="*[local-name() = 'Descriptions']"/>
    <xsl:if test="./*[local-name() = 'Cooperation']">
      <ul>
        <xsl:apply-templates select="./*[local-name() = 'Cooperation']" mode="list-item"/>
      </ul>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Cooperation']" mode="list-item">
    <li>
      <p>
        <xsl:choose>
          <xsl:when test="./*[local-name() = 'Url']/text()">
            <xsl:apply-templates select="./*[local-name() = 'Url']" mode="link-to-url">
              <xsl:with-param name="link-text">
                <xsl:value-of select="./*[local-name() = 'CooperationPartner']"/>
              </xsl:with-param>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="./*[local-name() = 'CooperationPartner']"/>
          </xsl:otherwise>
        </xsl:choose>
        <br/>
        <xsl:if test="./*[local-name() = 'Department']/text()">
          <xsl:value-of select="./*[local-name() = 'Department']"/>
          <xsl:text>, </xsl:text>  
        </xsl:if>
        <xsl:value-of select="./*[local-name() = 'Organisation']"/>
      </p>
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
    </li>
  </xsl:template>
</xsl:stylesheet>
