<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="xs xd functx">

  <xsl:output method="html" indent="yes"/>

  <xsl:template name="AccessAsTable" match="*[local-name() = 'Access']">
    <table>
      <!-- TODO: table header? -->
      <tbody>
        <!-- assuming single occurrence of sub-node -->
        <tr>
          <td>
            <b>Availability: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'Availability']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Distribution Medium: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'DistributionMedium']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Catalogue Link: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'CatalogueLink']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Price: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'Price']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Licence: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'Licence']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Contact: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'Contact']/*[local-name() = 'firstname']"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="./*[local-name() = 'Contact']/*[local-name() = 'lastname']"/>
            <xsl:if test="./*[local-name() = 'Contact']/*[local-name() = 'role'] != ''">
            (<xsl:value-of select="./*[local-name() = 'Contact']/*[local-name() = 'role']"/>) </xsl:if>
            <xsl:if test="./*[local-name() = 'Contact']/*[local-name() = 'email'] != ''">
              <xsl:text>, e-mail:</xsl:text>
              <xsl:value-of select="./*[local-name() = 'Contact']/*[local-name() = 'email']"/>
            </xsl:if>
            <xsl:if test="./*[local-name() = 'Contact']/*[local-name() = 'telephoneNumber'] != ''">
              <xsl:text>, telephone:</xsl:text>
              <xsl:value-of
                  select="./*[local-name() = 'Contact']/*[local-name() = 'telephoneNumber']"/>
            </xsl:if>
          </td>
        </tr>
        <tr>
          <td>
            <b>Deployment Tool Info: </b>
          </td>
          <td>
            <xsl:value-of
                select="./*[local-name() = 'DeploymentToolInfo']/*[local-name() = 'DeploymentTool']"/>
            <xsl:if
                test="./*[local-name() = 'DeploymentToolInfo']/*[local-name() = 'ToolType'] != ''">
              (<xsl:value-of
              select="./*[local-name() = 'DeploymentToolInfo']/*[local-name() = 'ToolType']"/>) </xsl:if>
              <xsl:if
                  test="./*[local-name() = 'DeploymentToolInfo']/*[local-name() = 'Version'] != ''"> ,
              Version: <xsl:value-of
              select="./*[local-name() = 'DeploymentToolInfo']/*[local-name() = 'Version']"/>.
              </xsl:if>
          </td>
        </tr>
        <tr>
          <td>
            <b>Descriptions: </b>
          </td>
          <td>
            <xsl:value-of select=".//*[local-name() = 'Description']"/>
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template>

</xsl:stylesheet>
