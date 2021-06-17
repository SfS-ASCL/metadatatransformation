<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="">

  <xsl:output method="html" indent="yes"/>

  <xsl:template name="CourseProfileSpecificAsTable" match="*[local-name() = 'CourseProfileSpecific']">
    <table>
      <!-- TODO: table header? -->
      <tbody>
        <tr>
          <td>
            <b>Course Targeted at: </b>
          </td>
          <td>
            <ul>
              <xsl:apply-templates select="*[local-name() = 'CourseTargetedAt']"/>
            </ul>
          </td>
        </tr>
        <tr>
          <td>
            <b>First held: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'FirstHeldAt']"/>
            <xsl:value-of select="./*[local-name() = 'FirstHeldOn']"/>
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="*[local-name() = 'CourseTargetedAt']">
    <li>
      <xsl:value-of select="."/>
    </li>
  </xsl:template>

</xsl:stylesheet>
