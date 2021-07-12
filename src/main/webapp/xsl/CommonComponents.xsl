<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/" exclude-result-prefixes="">

  <!-- CommonComponents.xsl: Templates for rendering components that
       show up in different places -->

  <xsl:output method="html" indent="yes"/>

  <!-- Turns a <Descriptions> into a series of <p>s, preserving the
       xml:lang attribute if present. Default mode is used because
       this is the common case. -->
  <xsl:template match="*[local-name() = 'Descriptions']">
    <xsl:for-each select="*[local-name() = 'Description']">
      <xsl:if test="./text()">
        <xsl:element name="p">
          <xsl:if test="@xml:lang != ''">
            <xsl:attribute name="lang">
              <xsl:value-of select="@xml:lang"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>


  <!-- There are many different kinds of <*ToolInfo> components with the
       same structure. This turns any of them into an <li> containing
       whatever information is provided about the tool. -->
  <xsl:template match="
      *[local-name() = 'CreationToolInfo' or
      local-name() = 'AnalysisToolInfo' or
      local-name() = 'AnnotationToolInfo' or
      local-name() = 'DeploymentToolInfo' or
      local-name() = 'DerivationToolInfo']" mode="list-item">

    <!-- first child (CreationTool, AnnotationTool, etc.) contains name:-->
    <xsl:variable name="toolName" select="./*[1]/text()"/>
    <xsl:if test="$toolName">
      <li>
        <p>
          <xsl:choose>
            <xsl:when test="./*[local-name() = 'Url']/text()">
              <xsl:apply-templates select="./*[local-name() = 'Url']" mode="link-to-url">
                <xsl:with-param name="link-text" select="$toolName"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$toolName"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="./*[local-name() = 'ToolType']/text()">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="normalize-space(./*[local-name() = 'ToolType'])"/>
            <xsl:text>)</xsl:text>
          </xsl:if>
          <xsl:if test="./*[local-name() = 'Version']/text()">
            <xsl:text>, version </xsl:text>
            <xsl:value-of select="normalize-space(./*[local-name() = 'Version'])"/>
          </xsl:if>
        </p>
        <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
      </li>
    </xsl:if>
  </xsl:template>


  <!-- Turns an AuthoritativeIDs component into <link ...> tags for
       each of the contained IDs. Use this to express the relation to
       these ID URLs without having them show up in the displayed HTML. -->
  <xsl:template match="*[local-name() = 'AuthoritativeIDs']" mode="link-tags">
    <xsl:apply-templates
      select="./*[local-name() = 'AuthoritativeID']/*[local-name() = 'id' and text()]"
      mode="link-tag"/>
  </xsl:template>

  <xsl:template match="*[local-name() = 'id']" mode="link-tag">
    <xsl:element name="link">
      <xsl:attribute name="itemprop">sameAs</xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="./text()"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <!-- Turns an AuthoritativeIDs component into comma-separated <a ...> tags for
       each of the contained IDs. Use this to allow users to actually
       visit the pages corresponding to these IDs.
  -->
  <xsl:template match="*[local-name() = 'AuthoritativeID']" mode="link-with-comma">
    <xsl:if test="./*[local-name() = 'id']/text()">
      <xsl:apply-templates select="./*[local-name() = 'id']" mode="link-to-url">
        <xsl:with-param name="link-text" select="./*[local-name() = 'issuingAuthority']"/>
        <xsl:with-param name="same-as" select="true()"/>
      </xsl:apply-templates>
      <xsl:if test="last() > 1 and position() != last()">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:template>


  <!-- Turns a <Person> into an <li> with their name, role, and links
       to any URLs that identify them -->
  <xsl:template match="*[local-name() = 'Person']" mode="list-item-with-role">
    <xsl:variable name="fullName">
      <xsl:value-of select="./*[local-name() = 'firstName']"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="./*[local-name() = 'lastName']"/>
    </xsl:variable>

    <li itemscope="" itemtype="https://schema.org/Person">
      <span itemprop="name">
        <xsl:value-of select="$fullName"/>
      </span>
      <xsl:if test="./*[local-name() = 'role'] != ''">
        <xsl:text>, </xsl:text>
        <xsl:value-of select="./*[local-name() = 'role']"/>
      </xsl:if>

      <xsl:if test="./*[local-name() = 'AuthoritativeIDs']/*[local-name() = 'AuthoritativeID']">
        <xsl:text>: </xsl:text>
        <xsl:apply-templates
          select="./*[local-name() = 'AuthoritativeIDs']/*[local-name() = 'AuthoritativeID']"
          mode="link-with-comma"/>
      </xsl:if>
    </li>
  </xsl:template>

  <!-- TODO: variants for Person, Author that use last name, first initial-->
  <!-- format, spans instead of <li>, etc. -->

  <!-- Turns a <SubjectLanguages> into a <details> component
       containing a list describing each language -->
  <xsl:template match="*[local-name() = 'SubjectLanguages']" mode="details">
    <details>
      <summary>Subject languages</summary>
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
      <ul>
        <xsl:apply-templates select="./*[local-name() = 'SubjectLanguage']" mode="list-item"/>
      </ul>
    </details>
  </xsl:template>

  <!-- Turns a <SubjectLanguage> into a list item with details about
       the languages role and any association description -->
  <xsl:template match="*[local-name() = 'SubjectLanguage']" mode="list-item">
    <li>
      <p>
        <xsl:value-of select=".//*[local-name() = 'LanguageName']"/>
        <xsl:apply-templates select="." mode="language-roles"/>
      </p>
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
    </li>
  </xsl:template>

  <!-- Turns a <SubjectLanguage> into parenthetical text describing the language's
       role, e.g. "(Dominant language, Source language)" -->
  <xsl:template match="*[local-name() = 'SubjectLanguage']" mode="language-roles">
    <xsl:if test="
        ./*[local-name() = 'DominantLanguage' or
        local-name() = 'SourceLanguage' or
        local-name() = 'TargetLanguage']">

      <xsl:text> (</xsl:text>
      <xsl:for-each select="
          ./*[(local-name() = 'DominantLanguage' or
          local-name() = 'SourceLanguage' or
          local-name() = 'TargetLanguage')
          and text() = 'true']">

        <xsl:value-of select="
            concat(substring-before(local-name(), 'Language'),
            ' language')"/>
        <xsl:if test="last() > position()">
          <xsl:text>, </xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- Turns a <TypeSpecificSizeInfo> into a list describing the sizes
       with units. -->
  <xsl:template match="*[local-name() = 'TypeSpecificSizeInfo']" mode="list">
    <xsl:variable name="referenceid">
      <xsl:value-of select="@*[local-name() = 'ref']"/>
    </xsl:variable>
    <xsl:variable name="title">
      <xsl:value-of select="../../../..//*[local-name() = 'ResourceProxyListInfo']/*[local-name() = 'ResourceProxyInfo'][@*[local-name()='ref']=$referenceid]/*[local-name() = 'ResProxItemName']"/>
    </xsl:variable>

    <xsl:if test=".//*[local-name() = 'Size' and text()]">
      <xsl:if test="$title != ''">
        <h4><xsl:value-of select="$title"/></h4>
      </xsl:if>
      <ul>
        <xsl:apply-templates select="./*[local-name() = 'TypeSpecificSize']" mode="list-item"/>
      </ul>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*[local-name() = 'TypeSpecificSize']" mode="list-item">
    <li>
      <xsl:value-of select="./*[local-name() = 'Size']"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="./*[local-name() = 'SizeUnit']"/>
    </li>
  </xsl:template>

</xsl:stylesheet>
