<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="xs xd functx">

  <xsl:output method="html" indent="yes"/>
  <!-- TODO: cleanup. Get rid of outer table, split individual
       sections into their own templates. -->
  <xsl:template name="ResourceProxyListSection" match="//*[local-name() = 'ResourceProxyList']">
    <table>
      <tbody> 
        <tr>
          <td><b>Persistent Identifier (PID) of this digital object: </b></td>
          <td>
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="//*[local-name() = 'MdSelfLink']"/>
              </xsl:attribute>
              <xsl:value-of select="//*[local-name() = 'MdSelfLink']"/>
            </xsl:element>
          </td>
        </tr>
        <tr>
          <td><b>Resource landing page: </b></td>
          <td>
            <xsl:for-each select="./*">
              <xsl:if test="./*[local-name() = 'ResourceType'] = 'LandingPage'">
                <xsl:element name="a">
                  <xsl:attribute name="href">
                    <xsl:value-of select="./*[local-name() = 'ResourceRef']"/>
                  </xsl:attribute>
                  <xsl:value-of select="./*[local-name() = 'ResourceRef']"/>
                </xsl:element>
              </xsl:if>
            </xsl:for-each>
          </td>
        </tr>
        <tr>
          <td><b>Packaged files for this dataset: </b></td>
          <td>
            <xsl:if test="./*[local-name() = 'ResourceType']/@mimetype = 'application/zip'">
              <ul>
                <xsl:for-each select="./*[local-name() = 'ResourceType']/@mimetype = 'application/zip'">
                  
                  
                  <li>
                   <!-- <xsl:element name="a">
                      <xsl:attribute name="href">
                        <xsl:value-of select="./*[local-name() = 'ResourceRef']"/>
                      </xsl:attribute>
                      <xsl:value-of select="./*[local-name() = 'ResourceRef']"/>
                    </xsl:element> -->
                  </li>
                  
                  
                </xsl:for-each>
              </ul>
            </xsl:if>
          </td>
        </tr>
      </tbody>
    </table>
    <!-- TODO: don't generate this section if there are none -->
    <p>This data set contains the following subordinate data objects: </p>
    <ul>
      <xsl:for-each select="./*">
        <xsl:choose>
          <xsl:when test="./*[local-name() = 'ResourceType'] = 'Metadata' and not(contains(normalize-space(./*[local-name() = 'ResourceRef']),normalize-space(//*[local-name() = 'MdSelfLink'])))">
            <xsl:variable name="id" select="./*[local-name() = 'ResourceType']/../@id"/>
            <li>
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="./*[local-name() = 'ResourceRef']"/>
                </xsl:attribute>
                <xsl:value-of select="./*[local-name() = 'ResourceRef']"/>
              </xsl:element>
              <xsl:if test="./*[local-name() = 'ResourceType']/@*[local-name() = 'mimetype']">
                <xsl:text> </xsl:text> (<xsl:value-of
                select="./*[local-name() = 'ResourceType']/@*[local-name() = 'mimetype']"/>)
                
              </xsl:if>
            </li>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </ul>
    <!-- TODO: don't generate this if there are none -->
    <p>This data set contains the following data streams: </p>
    <ul>
      <xsl:for-each select="./*">
        <xsl:choose>
          <xsl:when test="./*[local-name() = 'ResourceType'] = 'Resource'">
            <xsl:variable name="id" select="./*[local-name() = 'ResourceType']/../@id"/>
            <li>
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="./*[local-name() = 'ResourceRef']"/>
                </xsl:attribute>
                <xsl:value-of select="./*[local-name() = 'ResourceRef']"/>
              </xsl:element>
              <xsl:if test="./*[local-name() = 'ResourceType']/@*[local-name() = 'mimetype']">
                <xsl:text> </xsl:text> (<xsl:value-of
                select="./*[local-name() = 'ResourceType']/@*[local-name() = 'mimetype']"/>)
                <xsl:for-each select="//*[local-name() = 'ResourceProxyInfo']">
                  <xsl:if test="./@*[local-name() = 'ref'] = $id"> - <xsl:variable name="size"
                  select="number(./*[local-name() = 'SizeInfo']/*[local-name() = 'TotalSize']/*[local-name() = 'Size'])"/>
                  <xsl:choose>
                    <xsl:when test="$size &lt; 1024">
                    <xsl:value-of select="$size"/> B </xsl:when>
                    <xsl:when test="$size &lt; 1024*1024">
                    <xsl:value-of select="format-number($size div 1024, '#.#')"/> KB </xsl:when>
                    <xsl:when test="$size &lt; 1024*1024*1024">
                      <xsl:value-of select="format-number($size div (1024*1024), '#.#')"/>
                    MB </xsl:when>
                    <xsl:when test="$size &lt; 1024*1024*1024*1024">
                      <xsl:value-of select="format-number($size div (1024*1024*1024), '#.#')"/>
                    GB </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="format-number($size div (1024*1024*1024*1024), '#.#')"/>
                    TB </xsl:otherwise>
                  </xsl:choose>
                  </xsl:if>
                </xsl:for-each>
              </xsl:if>
            </li>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </ul>
  </xsl:template>
</xsl:stylesheet>
