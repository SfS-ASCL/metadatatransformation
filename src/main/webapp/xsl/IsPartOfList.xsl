<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="xs xd functx">

  <xsl:output method="html" indent="yes"/>


  <!-- TODO: this stylesheet is not imported by the main one, because
       at the moment it doesn't do anything. Does it need to be made
       to work again?
  -->

  <xsl:template match="*[local-name() = 'IsPartOfList']">
  
    <!-- <xsl:if test=".//text()">
    <tr>
      
      <td>
        <b>Part of Collection:</b>
        
      </td>
      <td>
        
   
    <xsl:for-each select="./*[local-name() = 'IsPartOf']">
      <ul>
       
          <li>
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="."/>
              </xsl:attribute>
              <xsl:value-of select="."/>
            </xsl:element>
          </li>
        
      </ul>
    </xsl:for-each>
      </td>
    </tr>
    </xsl:if> -->
  </xsl:template>
</xsl:stylesheet>
