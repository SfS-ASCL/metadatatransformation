<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="">

  <xsl:output method="html" indent="yes"/>

  <xsl:template name="ToolContextAsTable" match="*[local-name() = 'ToolContext']">
    <table>
      <!-- TODO: table header? -->
      <tbody>
        <tr>
          <td>
            <b>Tool Classification: </b>
          </td>
          <td>
            <xsl:value-of
                select="./*[local-name() = 'ToolClassification']/*[local-name() = 'ToolType']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Distribution: </b>
          </td>
          <td>
            <xsl:value-of
                select="./*[local-name() = 'Distribution']/*[local-name() = 'DistributionType']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Size: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'TotalSize']/*[local-name() = 'Size']"/>
            <xsl:value-of select="./*[local-name() = 'TotalSize']/*[local-name() = 'SizeUnit']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Input(s): </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'Inputs']//*[local-name() = 'Description']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Output(s): </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'Outputs']//*[local-name() = 'Description']"
                          />
          </td>
        </tr>
        <tr>
          <td>
            <b>Implementatation(s): </b>
          </td>
          <td>
            <xsl:value-of
                select="./*[local-name() = 'Implementations']//*[local-name() = 'ImplementationLanguage']"
                />
          </td>
        </tr>
        <tr>
          <td>
            <b>Install Environment(s): </b>
          </td>
          <td>
            <xsl:value-of
                select="./*[local-name() = 'InstallEnv']//*[local-name() = 'OperatingSystem']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Prerequisite(s): </b>
          </td>
          <td>
            <xsl:value-of
                select="./*[local-name() = 'Prerequisites']//*[local-name() = 'PrerequisiteName']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Tech Environment(s): </b>
          </td>
          <td>
            <xsl:value-of
                select="./*[local-name() = 'TechEnv']//*[local-name() = 'ApplicationType']"/>
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template>
</xsl:stylesheet>
