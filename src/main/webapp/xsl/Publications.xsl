<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="xs xd functx">

  <xsl:output method="html" indent="yes"/>
  <xsl:template name="PublicationsAsTable" match="*[local-name() = 'Publications']">
    <table>
      <!-- TODO: table header? -->
      <!-- TODO: should this even be table output? perhaps we should
           use something more like citation format -->
      <tbody>
        <xsl:for-each select="./*[local-name() = 'Publication']">
          <tr>
            <td>
              <table border="3" cellpadding="10" cellspacing="10">
                <tr>
                  <td>
                    <b>Title:</b>
                  </td>
                  <td>
                    <xsl:value-of select="./*[local-name() = 'PublicationTitle']"/>
                  </td>
                </tr>
                <tr>
                  <td>
                    <b>Author(s):</b>
                  </td>
                  <td>
                    <xsl:for-each select="./*[local-name() = 'Author']">
                      <xsl:choose>
                        <xsl:when
                            test="./*[local-name() = 'AuthoritativeIDs']/*[local-name() = 'AuthoritativeID']/*[local-name() = 'id'] != ''">
                          <xsl:element name="a">
                            <xsl:attribute name="href">
                              <xsl:value-of
                                  select=".//*[local-name() = 'AuthoritativeID'][1]/*[local-name() = 'id']"
                                  />
                            </xsl:attribute>
                            <xsl:value-of select="./*[local-name() = 'firstName']"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="./*[local-name() = 'lastName']"/>
                          </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="./*[local-name() = 'firstName']"/>
                          <xsl:text> </xsl:text>
                          <xsl:value-of select="./*[local-name() = 'lastName']"/>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="position() != last()">, </xsl:if>
                    </xsl:for-each>
                  </td>
                </tr>
                <tr>
                  <td>
                    <b>Abstract:</b>
                  </td>
                  <td>
                    <xsl:apply-templates select="*[local-name() = 'Descriptions']"/> 
                    <!-- <xsl:value-of
                         select="./*[local-name() = 'Descriptions']/*[local-name() = 'Description']" /> -->
                  </td>
                </tr>
                <tr>
                  <td>
                    <b>Link:</b>
                  </td>
                  <td>
                    <xsl:element name="a">
                      <xsl:attribute name="href">
                        <xsl:value-of select="./*[local-name() = 'resolvablePID']"/>
                        <!--<xsl:value-of
                            select=".//*[local-name() = 'AuthoritativeID'][1]/*[local-name() = 'id']"
                            />-->
                      </xsl:attribute>
                      <xsl:value-of select="./*[local-name() = 'resolvablePID']"/>
                    </xsl:element>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>
</xsl:stylesheet>
