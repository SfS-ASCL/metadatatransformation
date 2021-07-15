<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/" exclude-result-prefixes="">

  <xsl:output method="html" indent="yes"/>

  <xsl:template name="ResourceProxyListSection" match="*[local-name() = 'ResourceProxyList']">
    <!-- TODO: the language here is really esoteric. Can we change
         "data object" to "resource", "data stream" to "file", etc.?  -->

    <p>Persistent Identifier (PID) of this resource: <xsl:apply-templates
        select="//*[local-name() = 'MdSelfLink']" mode="link-to-url"/>
    </p>

    <p>Landing page for this resource: <xsl:for-each select="./*">
        <xsl:if test="./*[local-name() = 'ResourceType'] = 'LandingPage'">
          <xsl:apply-templates select="./*[local-name() = 'ResourceRef']" mode="link-to-url"/>
        </xsl:if>
      </xsl:for-each>
    </p>

    <h3>Subordinate resources</h3>

    <xsl:choose>
      <xsl:when
        test="count(./*[local-name() = 'ResourceProxy']/*[local-name() = 'ResourceType' and text() = 'Metadata']) > 0">
        <p>This data set contains the following subordinate resources:</p>
        <ul>
          <xsl:apply-templates
            select="./*[local-name() = 'ResourceProxy']/*[local-name() = 'ResourceType' and text() = 'Metadata']"
            mode="list-item"/>
        </ul>

      </xsl:when>
      <xsl:otherwise>
        <p>This data set contains no subordinate resources.</p>
      </xsl:otherwise>
    </xsl:choose>

    <h3>Files</h3>
    <xsl:choose>
      <xsl:when test="count(./*[local-name() = 'ResourceProxy']/*[local-name() = 'ResourceType' and text() = 'Resource']) > 0">
        <p>This data set contains the following files: </p>
        <xsl:apply-templates select="./*[local-name() = 'ResourceProxy']"/>
      </xsl:when>
      <xsl:otherwise>
        <p>There are no files in this data set.</p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ResourceProxyAsDetails" match="*[local-name() = 'ResourceProxy']">
    <!-- Renders each ResourceProxy with ResourceType 'Resource' as a <details> element -->

    <xsl:if test="./*[local-name() = 'ResourceType']/text() = 'Resource'">

      <!-- id holds the current ResourceProxy's id=... attribute value: -->
      <xsl:variable name="id" select="./*[local-name() = 'ResourceType']/../@id"/>
      <!-- infoNode holds the corresponding ResourceProxyInfo node,
           i.e., the one whose ref=... value matches the current ResourceProxy's id=... value: -->
      <xsl:variable name="infoNode"
        select="//*[local-name() = 'ResourceProxyInfo'][@*[local-name() = 'ref' and . = $id]]"/>

      <details>
        <summary>
          <xsl:apply-templates select="./*[local-name() = 'ResourceRef']" mode="link-to-url">
            <xsl:with-param name="link-text"
              select="normalize-space($infoNode/*[local-name() = 'ResProxFileName'])"/>
          </xsl:apply-templates>
          <xsl:text> </xsl:text> (<xsl:value-of
            select="./*[local-name() = 'ResourceType']/@*[local-name() = 'mimetype']"/>,
            <xsl:apply-templates select="$infoNode/*[local-name() = 'SizeInfo']"/>) </summary>

        <dl>
          <!-- TODO: display ResourceType here? or is it basically always just "Resource"? -->
          <xsl:if test="$infoNode/*[local-name() = 'ResProxItemName']/text()">
            <dt>Item name</dt>
            <dd>
              <xsl:value-of select="$infoNode/*[local-name() = 'ResProxItemName']/text()"/>
            </dd>
          </xsl:if>
          <xsl:if test="$infoNode/*[local-name() = 'ResProxFileName']/text()">
            <dt>Original file name</dt>
            <dd>
              <xsl:value-of select="$infoNode/*[local-name() = 'ResProxFileName']/text()"/>
            </dd>
          </xsl:if>

          <dt>Persistent identifier</dt>
          <dd>
            <xsl:apply-templates select="./*[local-name() = 'ResourceRef']" mode="link-to-url"/>
          </dd>

          <xsl:if test="./*[local-name() = 'ResourceType']/@*[local-name() = 'mimetype']">
            <dt>MIME Type</dt>
            <dd>
              <xsl:value-of
                select="./*[local-name() = 'ResourceType']/@*[local-name() = 'mimetype']"/>
            </dd>
          </xsl:if>
          <dt>File size</dt>
          <dd>
            <xsl:apply-templates select="$infoNode/*[local-name() = 'SizeInfo']"/>
          </dd>

          <xsl:apply-templates select="$infoNode/*[local-name() = 'Checksums']"/>
          <!-- TODO: other info potentially in $infoNode:-->
          <!-- LanguageScripts? LanguagesScriptGrp? Descriptions?-->
        </dl>
      </details>
    </xsl:if>
  </xsl:template>

  <xsl:template name="SizeAsHumanText" match="*[local-name() = 'SizeInfo']">
    <!-- returns value of SizeInfo node with units of KB, MB, etc. -->
    <!-- TODO: check SizeUnit. For now we just assume unit is bytes... -->
    <xsl:variable name="size"
      select="number(./*[local-name() = 'TotalSize']/*[local-name() = 'Size'])"/>
    <xsl:choose>
      <xsl:when test="$size &lt; 1024">
        <xsl:value-of select="$size"/> B</xsl:when>
      <xsl:when test="$size &lt; 1024 * 1024">
        <xsl:value-of select="format-number($size div 1024, '#.#')"/> KB</xsl:when>
      <xsl:when test="$size &lt; 1024 * 1024 * 1024">
        <xsl:value-of select="format-number($size div (1024 * 1024), '#.#')"/> MB</xsl:when>
      <xsl:when test="$size &lt; 1024 * 1024 * 1024 * 1024">
        <xsl:value-of select="format-number($size div (1024 * 1024 * 1024), '#.#')"/> GB</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="format-number($size div (1024 * 1024 * 1024 * 1024), '#.#')"/>
        TB</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ChecksumsAsDefinitions" match="*[local-name() = 'Checksums']">
    <!-- Returns checksum values as dt/dd pairs. The outer <dl> is
         *not* supplied, so these can be inserted into an existing
         definition list -->
    <xsl:if test="./*[local-name() = 'md5']/text()">
      <dt>MD5</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'md5']"/>
      </dd>
    </xsl:if>
    <xsl:if test="./*[local-name() = 'sha1']/text()">
      <dt>SHA1</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'sha1']"/>
      </dd>
    </xsl:if>
    <xsl:if test="./*[local-name() = 'sha256']/text()">
      <dt>SHA256</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'sha256']"/>
      </dd>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*[local-name() = 'ResourceProxyListInfo']">
    <!-- suppress default template -->
    <!-- ResourceProxyInfo nodes are rendered by the templates for the
         corresponding ResourceProxy node (see above). But because
         they're not in the same part of the document tree, the rules
         for default templates end up being applied to them and
         dumping the text of the checksums, etc. directly into the
         page unless we suppress them. -->
  </xsl:template>

  <xsl:template match="*[local-name() = 'ResourceType' and text() = 'Metadata']" mode="list-item">
    <xsl:variable name="selfLink" select="//*[local-name() = 'MdSelfLink']/text()"/>
    <!-- exclude link to self as a subordinate resource: -->
    <xsl:if test="not(contains(normalize-space(../*[local-name() = 'ResourceRef']/text()), normalize-space($selfLink)))">
      <li>
        <xsl:apply-templates select="../*[local-name() = 'ResourceRef']" mode="link-to-url"/>
        <xsl:if test="./@*[local-name() = 'mimetype']">
          <xsl:text> (</xsl:text>
          <xsl:value-of select="./@*[local-name() = 'mimetype']"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </li>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
