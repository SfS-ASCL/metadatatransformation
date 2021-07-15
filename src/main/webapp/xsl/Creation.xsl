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

    <xsl:apply-templates select="./*[local-name() = 'Creators']" mode="section" />
    <section>
      <h3>Creation process</h3>
      <xsl:call-template name="SourcesDetails"/>
      <xsl:apply-templates select="./*[local-name() = 'Annotation']" mode="details" />
      <xsl:call-template name="CreationToolsSection"/>
    </section>

  </xsl:template>

  <xsl:template match="*[local-name() = 'Creators']" mode="section">
    <section>
      <h3>Creators</h3>
      <xsl:choose>
        <!-- avoid generating an empty list when there are no last names: -->
        <xsl:when test="./*[local-name() = 'Person']/*[local-name() = 'lastName']/text()">
          <address>
            <ol>
              <xsl:apply-templates select="./*[local-name() = 'Person']" mode="list-item-with-role" />
            </ol>
          </address>
        </xsl:when>
        <xsl:otherwise>
          <p>No information available about the creators of this resource.</p>
        </xsl:otherwise>
      </xsl:choose>
    </section>
  </xsl:template>

  <xsl:template name="SourcesDetails">
    <!-- we call this by name because there is no <Sources> wrapper element
         under which <Source> elements are collected, somewhat exceptionally -->

    <xsl:if test="./*[local-name() = 'Source']">
      <details>
        <summary>Original Sources</summary>
        <xsl:choose>
          <xsl:when test="./*[local-name() = 'Source']/*[local-name() = 'OriginalSource']/text()">
            <ol>
              <xsl:apply-templates select="./*[local-name() = 'Source']" mode="list-item"/>
            </ol>
          </xsl:when>
          <xsl:otherwise>
            <p>No information on original sources available for this resource.</p>
          </xsl:otherwise>
        </xsl:choose>
      </details>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Source']" mode="list-item">
    <li>
      <p>
        <cite>
          <xsl:value-of select="./*[local-name() = 'OriginalSource']"/>
        </cite>
        <xsl:if test="./*[local-name() = 'SourceType'] != ''">
          <xsl:text> (</xsl:text>
          <xsl:value-of select="./*[local-name() = 'SourceType']"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </p>
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']" />
      <xsl:apply-templates select="./*[local-name() = 'MediaFiles']" mode="details" />
      <xsl:apply-templates select="./*[local-name() = 'Derivation']" mode="details" />
    </li>
  </xsl:template>

  <xsl:template match="*[local-name() = 'MediaFiles']" mode="details">
      <details>
        <summary>Media files</summary>
        <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
        <xsl:choose>
          <xsl:when test="./*[local-name() = 'MediaFile']">
            <ol>
              <xsl:apply-templates select="./*[local-name() = 'MediaFile']" mode="list-item"/>
            </ol>
          </xsl:when>
          <xsl:otherwise>
            <p>No information about media files is available for this source.</p>
          </xsl:otherwise>
        </xsl:choose>
      </details>
  </xsl:template>

  <xsl:template match="*[local-name() = 'MediaFile']" mode="list-item">
    <xsl:if test="./*[local-name() = 'CatalogueLink' and text()]"> 
      <li>
        <xsl:apply-templates select="./*[local-name() = 'CatalogueLink']" mode="link-to-url" /> 
        <xsl:if test="./*[local-name() = 'Type' and (text() != 'Unknown' or text() != 'Unspecified')]">
          <xsl:text> (</xsl:text>
          <xsl:value-of select="./*[local-name() = 'Type']"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
        <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
      </li>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Derivation']" mode="details">
      <details>
        <summary>Derivation</summary>
        <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
        <dl>
          <dt>Organisation</dt>
          <dd>
            <xsl:value-of select="./*[local-name() = 'Organisation']" />
          </dd>
 
          <dt>Date</dt>
          <dd>
            <xsl:value-of select="./*[local-name() = 'DerivationDate']" />
          </dd>
                          
          <dt>Mode</dt>
          <dd>
            <xsl:value-of select="./*[local-name() = 'DerivationMode']" />
          </dd>
 
          <dt>Type</dt>
          <dd>
            <xsl:value-of select="./*[local-name() = 'DerivationType']" />
          </dd>
 
          <dt>Workflow</dt>
          <dd>
            <xsl:value-of select="./*[local-name() = 'DerivationWorkflow']" />
          </dd>

          <dt>Derivation tools</dt>
          <dd>
            <ul>
              <xsl:apply-templates select="./*[local-name() = 'DerivationToolInfo']"
                                   mode="list-item" />
            </ul>
          </dd>

        </dl>
      </details>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Annotation']" mode="details">
    <details>
      <summary>Annotation</summary>
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
      <dl>
        <dt>Annotation mode</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'AnnotationMode']"/>
        </dd>

        <dt>Annotation standoff</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'AnnotationStandoff']"/>
        </dd>

        <dt>Interannotator agreement</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'InterannotatorAgreement']"/>
        </dd>

        <dt>Annotation format</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'AnnotationFormat']"/>
        </dd>

        <dt>Segmentation units</dt>
        <dd>
          <xsl:if test=".//*[local-name() = 'SegmentationUnit']">
            <p>
              <xsl:apply-templates select=".//*[local-name() = 'SegmentationUnit']" mode="comma-separated-text" />
            </p>
          </xsl:if>
          <xsl:apply-templates select="./*[local-name() = 'SegmentationUnits']/*[local-name() = 'Descriptions']" />
        </dd>
        
        <dt>Annotation types</dt>
        <dd>
          <dl>
            <dt>Levels</dt>
            <dd>
              <xsl:apply-templates select=".//*[local-name() = 'AnnotationLevelType']" mode="comma-separated-text" />
            </dd>
            
            <dt>Modes</dt>
            <dd>
              <xsl:apply-templates select=".//*[local-name() = 'AnnotationMode']" mode="comma-separated-text" />
            </dd>
            
            <dt>Tag sets</dt>
            <dd>
              <xsl:apply-templates select=".//*[local-name() = 'Tagset']" mode="comma-separated-text" />
            </dd>
          </dl>
          <xsl:apply-templates select="./*[local-name() = 'AnnotationTypes']/*[local-name() = 'Descriptions']" />
        </dd>

        <dt>Annotation tools</dt>
        <dd>
          <ul>
            <xsl:apply-templates select="./*[local-name() = 'AnnotationToolInfo']" mode="list-item" />
          </ul>
        </dd>

      </dl>
    </details>
  </xsl:template>

  <xsl:template name="CitationExamples">
    <!-- Provides the contents of the "Cite data set" tab -->
    <p>Please cite the data set itself as follows:</p>
    <blockquote>
      <xsl:call-template name="DatasetCitation"/>
    </blockquote>
    <xsl:if test="count(//*[local-name() = 'ResourceType' and text() = 'Resource']) > 1">
      <p>
        Individual items in the data set may be cited using their
        persistent identifiers (see <a href="#data-files">Data files</a>).
        For example, cite the file
        <code><xsl:value-of select="substring-after((//*[local-name() = 'ResourceRef' and preceding-sibling::*[text() = 'Resource']])[2], '@')" /></code>
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

  <!-- TODO: move this to CommonComponents and cleanup -->
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
      <xsl:variable name="startDate"
                    select="substring(normalize-space(//*[local-name() = 'PublicationDate']), 0, 5)"/>
      <xsl:variable name="endDate"
                    select="substring(normalize-space(//*[local-name() = 'LastUpate']), 0, 5)"/>

      <xsl:text> (</xsl:text>
      <xsl:value-of select="$startDate"/>
      <xsl:if test="$endDate != ''">
	<xsl:text>&#8211;</xsl:text>
	<xsl:value-of select="$endDate"/>
      </xsl:if>            
      <xsl:text>): </xsl:text>
  </xsl:template>

  <xsl:template name="TitleAsCite">
    <cite>
      <xsl:choose>
        <xsl:when test="//*[local-name() = 'ResourceTitle']/text()">
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
          <xsl:value-of select="//*[local-name() = 'ResourceName']/text()"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="//*[local-name() = 'Version']/text()">
        <xsl:text>, version </xsl:text>
        <xsl:value-of select="//*[local-name() = 'Version']/text()" />
      </xsl:if>
    </cite>
    <xsl:text>. </xsl:text>
  </xsl:template>

  <xsl:template name="CreationToolsSection">
    <details>
      <summary>Creation tools</summary>
      <xsl:choose>
        <xsl:when test="./*[local-name() = 'CreationToolInfo']/*[local-name() = 'CreationTool']/text()">
          <ul>
            <xsl:apply-templates select="./*[local-name() = 'CreationToolInfo']" mode="list-item" />
          </ul>
        </xsl:when>
        <xsl:otherwise>
          <p>No information available about the tools used to create this resource.</p>
        </xsl:otherwise>
      </xsl:choose>
    </details>
  </xsl:template> 

</xsl:stylesheet>
