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

</xsl:stylesheet>
