<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="xs xd functx">

  <xsl:output method="html" indent="yes"/>
  <xsl:template name="ChecksumsAsTable"
                match="*[local-name() = 'ResourceProxyListInfo']">
    <!-- ignore content, generate About instead, still to do, especially enhancing! -->

      <table>
        <thead>
          <tr><th>Original File Name</th><th>Size</th><th>Checksums</th></tr>
        </thead>
        <tbody>
          <xsl:apply-templates select="*[local-name() = 'ResourceProxyInfo']"/>
        </tbody>
      </table>

      
  </xsl:template>

  <!-- TODO: more useful information here? just put this in a
       paragraph instead of a table? -->
  <xsl:template name="AboutChecksumsTable">
    <table>
        <thead>
          <tr>
            <th><h3>About</h3></th>
            <th/>
          </tr>
        </thead>
        <tr>
          <td><b>Generation: </b></td>
          <td>Automatically generated with an XSL stylesheet from the CMDI file, v.02</td>
        </tr>
        <tr>
          <td><b>Contact: </b></td>
          <td>Thorsten Trippel and Claus Zinn, SfS Tuebingen</td>
        </tr>
      </table>
  </xsl:template>
  
  <xsl:template name="ResourceProxyInfoAsRow"
                match="//*[local-name() = 'ResourceProxyInfo']">
    <tr>
      <td>
        <xsl:value-of select="*[local-name() = 'ResProxFileName']"/>
      </td>
      <td>
	<xsl:if test="*[local-name() = 'SizeInfo']/*[local-name() = 'TotalSize']/*[local-name() = 'Size']/text()">
	  <xsl:variable name="FileSizeKb">
	    <!-- <xsl:if test="string-length(*[local-name() = 'SizeInfo']/*[local-name() = 'TotalSize']/*[local-name() = 'Size']/text() &gt; 0"> -->
	    <xsl:if test="number(*[local-name() = 'SizeInfo']/*[local-name() = 'TotalSize']/*[local-name() = 'Size']/text()) &gt; 0"> 
	      <xsl:choose>
		<xsl:when test="round(*[local-name() = 'SizeInfo']/*[local-name() = 'TotalSize']/*[local-name() = 'Size']/text()div 1024) &lt; 1">
		<xsl:value-of select="*[local-name() = 'SizeInfo']/*[local-name() = 'TotalSize']/*[local-name() = 'Size']/text()" /> <xsl:text> Bytes</xsl:text></xsl:when>
		<xsl:when test="round(*[local-name() = 'SizeInfo']/*[local-name() = 'TotalSize']/*[local-name() = 'Size']/text() div 1048576) &lt; 1">
		<xsl:value-of select="format-number((*[local-name() = 'SizeInfo']/*[local-name() = 'TotalSize']/*[local-name() = 'Size']/text() div 1024), '0.0')" /><xsl:text> KB</xsl:text></xsl:when> 
		<xsl:otherwise><xsl:value-of select="format-number((*[local-name() = 'SizeInfo']/*[local-name() = 'TotalSize']/*[local-name() = 'Size']/text() div 1048576), '0.00')" /><xsl:text> MB</xsl:text></xsl:otherwise> 
	      </xsl:choose> 
	    </xsl:if> 
	    <!-- </xsl:if> -->
	  </xsl:variable>
	  <xsl:value-of select="$FileSizeKb"/>
	  <!-- 
	       <xsl:for-each select="*[local-name() = 'SizeInfo']/*[local-name() = 'TotalSize']">
	       <xsl:value-of select="*[local-name() = 'Size']"/><xsl:text> </xsl:text>
	       <xsl:value-of select="*[local-name() = 'SizeUnit']"/>
	       </xsl:for-each> -->
	</xsl:if>

      </td>
      <td>
        <ul>
          <xsl:if test="*[local-name() = 'Checksums']/*[local-name() = 'md5']/text()">  <li><xsl:value-of select="*[local-name() = 'Checksums']/*[local-name() = 'md5']"/>
          (MD5)</li></xsl:if>
          <xsl:if test="*[local-name() = 'Checksums']/*[local-name() = 'sha1']/text()"><li><xsl:value-of select="*[local-name() = 'Checksums']/*[local-name() = 'sha1']"/>
          (SHA1)</li></xsl:if>
          <xsl:if test="*[local-name() = 'Checksums']/*[local-name() = 'sha256']/text()"><li><xsl:value-of select="*[local-name() = 'Checksums']/*[local-name() = 'sha256']"/>
          (SHA256)</li></xsl:if>
        </ul>
      </td>
    </tr>
  </xsl:template>

  <xsl:template name="DatasetCitation">
    <!-- Provides a citation for the whole dataset -->
    <cite>
      <xsl:call-template name="CreatorsAsCommaSeparatedText" />
      <xsl:call-template name="CreationDatesAsText" />
      <xsl:call-template name="TitleAsEm" />
      Data set in Tübingen Archive of Language Resources. 
      <br/>Persistent identifier: <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="//*[local-name() = 'MdSelfLink']"/>
      </xsl:attribute>
      <xsl:value-of select="//*[local-name() = 'MdSelfLink']"/>
    </xsl:element>
    </cite>
  </xsl:template>

  <xsl:template name="InDatasetCitation">
    <!-- Provides an example citation of an individual item in the
         collection, using the second ResourceRef element in the document.
         (We use the second because the first might be the landing page and have the same 
         PID as the data set itself.
    -->
    <cite>
      <xsl:call-template name="CreatorsAsCommaSeparatedText" />
      <xsl:call-template name="CreationDatesAsText" />
      <xsl:value-of select="substring-after((//*[local-name() = 'ResourceRef'])[2], '@')" />
      <xsl:text>. </xsl:text>
      In: <xsl:call-template name="TitleAsEm" />
      Data set in Tübingen Archive of Language Resources. 
      <br/>Persistent identifier: <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="(//*[local-name() = 'ResourceRef'])[2]"/>
        </xsl:attribute>
        <xsl:value-of select="(//*[local-name() = 'ResourceRef'])[2]"/>
      </xsl:element>
    </cite>
  </xsl:template>

  <xsl:template name="CreatorsAsCommaSeparatedText">
    <!-- Get the list of creators, last name followed by initial, comma separated -->
    <xsl:for-each select="//*[local-name() = 'Creators']/*[local-name() = 'Person']/.">
      <xsl:choose>
        <xsl:when test="position() = last()">
          <xsl:value-of select="*[local-name() = 'lastName']"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="substring(*[local-name() = 'firstName'], 1, 1)"/>
          <xsl:text>.</xsl:text>
        </xsl:when>
        <xsl:when test="position() = last() - 1">
          <xsl:value-of select="*[local-name() = 'lastName']"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="substring(*[local-name() = 'firstName'], 1, 1)"/>
          <xsl:text>. &amp; </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="*[local-name() = 'lastName']"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="substring(*[local-name() = 'firstName'], 1, 1)"/>
          <xsl:text>., </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="CreationDatesAsText">
      <!-- Provides publication date and last update like (YYYY): or (YYYY-YYYY): --> 
      <!-- Assumes the last 4 characters in PublicationDate and LastUpdate refer to the year -->
      <xsl:text> (</xsl:text>
      <xsl:value-of select="substring-before(//*[local-name() = 'PublicationDate'], '-')"/>
      <xsl:if test="//*[local-name() = 'LastUpdate'] !=''">
	<xsl:text> - </xsl:text>
	<xsl:value-of select="substring-before(//*[local-name() = 'LastUpdate'], '-')"/>
      </xsl:if>            
      <xsl:text>): </xsl:text>

  </xsl:template>

  <xsl:template name="TitleAsEm">
    <em>
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
    </em>
    <xsl:text>. </xsl:text>
  </xsl:template>

</xsl:stylesheet>
