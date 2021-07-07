<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="">

  <xsl:output method="html" indent="yes"/>

  <xsl:template match="*[local-name() = 'Access']" mode="deflist">
    <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
    <dl>
        <dt>Availability</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'Availability']"/>
        </dd>
        
        <dt>Distribution Medium</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'DistributionMedium']"/>
        </dd>
        
        <dt>Catalogue Link</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'CatalogueLink']" mode="link-to-url"/>
        </dd>
        
        <dt>Price</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'Price']"/>
        </dd>
        
        <dt>Licence</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'Licence']" mode="name-with-link"/>
        </dd>
        
        <dt>Contact</dt>
        <dd itemscope="" itemtype="https://schema.org/Person">
          <xsl:apply-templates select="./*[local-name() = 'Contact']" mode="contact-data"/>
        </dd>
        
        <dt>Deployment Tool Info</dt>
        <dd>
          <xsl:if test="./*[local-name() = 'DeploymentToolInfo']">
            <ul>
              <xsl:apply-templates select="./*[local-name() = 'DeploymentToolInfo']" mode="list-item" />
            </ul>
          </xsl:if>
        </dd>
    </dl>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Contact']" mode="contact-data">
    <span itemprop="name">
      <xsl:value-of select="./*[local-name() = 'firstname']"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="./*[local-name() = 'lastname']"/>
    </span>
    <xsl:if test="./*[local-name() = 'role'] != ''">
      <xsl:text>, </xsl:text>
      <xsl:value-of select="./*[local-name() = 'role']"/>
    </xsl:if>
    <xsl:if test="./*[local-name() = 'email'] != ''">
      <br/>
      <xsl:element name="a">
        <xsl:attribute name="href">mailto:<xsl:value-of select="./*[local-name() = 'email']"/></xsl:attribute>
        <xsl:attribute name="itemprop">email</xsl:attribute>
        <xsl:value-of select="./*[local-name() = 'email']"/>
      </xsl:element>
    </xsl:if>
    <xsl:if test="./*[local-name() = 'telephoneNumber'] != ''">
      <br/>
      <span itemprop="telephone">
        <xsl:value-of select="./*[local-name() = 'telephoneNumber']"/>
      </span>
    </xsl:if>
    <xsl:if test="./*[local-name() = 'Address']">
      <br/>
      <xsl:apply-templates select="./*[local-name() = 'Address']" mode="address-data"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Address']" mode="address-data">
    <span itemprop="address">
      <xsl:value-of select="./*[local-name() = 'street']"/>
      <br/>
      <xsl:value-of select="./*[local-name() = 'ZIPCode']"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="./*[local-name() = 'city']"/>
    </span>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Licence']" mode="name-with-link">
    <xsl:variable name="licenseName" select="./text()"/>
    <xsl:choose>
      <xsl:when test="./@*[local-name() = 'src']">
        <xsl:apply-templates select="./@*[local-name() = 'src']" mode="link-to-url">
          <xsl:with-param name="link-text" select="$licenseName"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$licenseName"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
