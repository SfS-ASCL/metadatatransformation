<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="">

  <!-- TODO: split out Annotation, Source, and Derivations into detail sections-->
  <xsl:output method="html" indent="yes"/>

  <!-- The main template for the Creation tab -->
  <xsl:template match="*[local-name() = 'Creation']">
    <!-- TODO: topic? This looks more like "keywords" rather than anything that can usefully be printed  -->
    <xsl:apply-templates select="./*[local-name() = 'Descriptions']" />

    <h3>Creators</h3>
    <xsl:apply-templates select="./*[local-name() = 'Creators']" mode="list" />

    <details>
      <summary>Source</summary>
      <!-- TODO -->
    </details>

    <details>
      <summary>Annotation</summary>
      <!-- TODO -->
    </details>
    <details>
      <summary>Creation tools</summary>
      <ol>
        <xsl:apply-templates select="./*[local-name() = 'CreationToolInfo']" mode="list-item" />
      </ol>
    </details>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Creators']" mode="list">
    <address>
      <ol>
        <xsl:apply-templates select="./*[local-name() = 'Person']" mode="list-item-with-role" />
      </ol>
    </address>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Person']" mode="list-item-with-role">
    <xsl:variable name="fullName">
      <xsl:value-of select="./*[local-name() = 'firstName']"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="./*[local-name() = 'lastName']"/>
    </xsl:variable>

    <li>
      <xsl:value-of select="$fullName" />
      <xsl:if test="./*[local-name() = 'role'] != ''">
        (<xsl:value-of select="./*[local-name() = 'role']"/>)
      </xsl:if>
      
      <xsl:if test="./*[local-name() = 'AuthoritativeIDs']/*[local-name() = 'AuthoritativeID']">
        Identity records: 
        <xsl:apply-templates select="./*[local-name() = 'AuthoritativeIDs']/*[local-name() = 'AuthoritativeID']"
                             mode="link-with-comma"/>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="*[local-name() = 'AuthoritativeID']" mode="link-with-comma">
    <xsl:apply-templates select="./*[local-name() = 'id']" mode="link-to-url">
      <xsl:with-param name="link-text" select="./*[local-name() = 'issuingAuthority']"/>
    </xsl:apply-templates>
    <xsl:if test="last() > 1 and position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="CitationExamples">
    <!-- Provides the contents of the "Cite data set" tab -->
    <p>Please cite the data set itself as follows:</p>
    <blockquote>
      <xsl:call-template name="DatasetCitation"/>
    </blockquote>
    <xsl:if test="count(//*[local-name() = 'ResourceRef']) > 1">
      <p>
        Individual items in the data set may be cited using their
        persistent identifiers (see <a href="#data-files">Data files</a>).
        For example, cite the file
        <code><xsl:value-of select="substring-after((//*[local-name() = 'ResourceRef'])[2], '@')" /></code>
        as follows:
      </p>
      <blockquote>
        <xsl:call-template name="InDatasetCitation"/>
      </blockquote>  
    </xsl:if>
  </xsl:template>

  <xsl:template name="DatasetCitation">
    <!-- Provides a citation for the whole dataset -->
      <xsl:call-template name="CreatorsAsCommaSeparatedText" />
      <xsl:call-template name="CreationDatesAsText" />
      <xsl:call-template name="TitleAsCite" />
      Data set in Tübingen Archive of Language Resources. 
      <br/>Persistent identifier:
      <xsl:apply-templates select="//*[local-name() = 'MdSelfLink']" mode="link-to-url" />
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
      <br/>Persistent identifier:
      <xsl:apply-templates select="(//*[local-name() = 'ResourceRef'])[2]" mode="link-to-url" />
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
      <xsl:variable name="startDate" select="substring-before(//*[local-name() = 'PublicationDate'], '-')"/>
      <xsl:variable name="endDate" select="substring-before(//*[local-name() = 'LastUpdate'], '-')"/>

      <xsl:text> (</xsl:text>
      <xsl:value-of select="$startDate"/>
      <xsl:if test="$endDate != ''">
	<xsl:text> - </xsl:text>
	<xsl:value-of select="$endDate"/>
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


  <xsl:template match="*[local-name() = 'CreationToolInfo']" mode="list-item">
    <li>
      <p>
        <xsl:value-of select="./*[local-name() = 'CreationTool']" />
        <xsl:if test="./*[local-name() = 'ToolType']/text()"> 
          (<xsl:value-of select="normalize-space(./*[local-name() = 'ToolType'])" />)
        </xsl:if>
        <xsl:if test="./*[local-name() = 'Version']/text()"> 
          <xsl:text>, version </xsl:text>
          <xsl:value-of select="normalize-space(./*[local-name() = 'Version'])" />
        </xsl:if>
        <xsl:text>. </xsl:text>
        
        <xsl:if test="./*[local-name() = 'Url']/text()"> 
          Link: <xsl:apply-templates select="./*[local-name() = 'Url']" mode="link-to-url" />
        </xsl:if>
      </p>
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']" />
    </li>
  </xsl:template>

 

</xsl:stylesheet>
