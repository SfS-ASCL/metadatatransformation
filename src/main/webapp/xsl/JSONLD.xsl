<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  exclude-result-prefixes="xs xd functx">

  <xsl:output method="html" indent="yes"/>

  <xsl:template name="JSONLD">

    <xsl:choose>
      <xsl:when test="//*[local-name() = 'ResourceName'] != '' and //*[local-name()='GeneralInfo']/*[local-name()='Descriptions']/*[local-name()='Description'][@xml:lang='en' or @xml:lang='de'] != ''">
        <xsl:text>

        </xsl:text>
	<xsl:element name="script">
	  <xsl:attribute name="type">application/ld+json</xsl:attribute>

	  <xsl:text disable-output-escaping="yes">
            /*&lt;![CDATA[*/
          </xsl:text>
	  {
	  "name": "<xsl:value-of select="//*[local-name() = 'ResourceName']"/>",		
	  <xsl:variable name="description_in_cmdi">  
	    <xsl:for-each select="//*[local-name()='GeneralInfo']/*[local-name()='Descriptions']/*[local-name()='Description']">
	      <xsl:if test='@xml:lang="en"'>
		<xsl:value-of select="."/>
	      </xsl:if>
	      <xsl:if test='@xml:lang="de" and not(../*[local-name() = "Description"][@xml:lang="en"])'>
		<xsl:value-of select="."/>
	      </xsl:if>
	      <!-- <xsl:value-of select="."/>-->
	      <xsl:if test='not(@xml:lang="de") and not(../*[local-name() = "Description"][@xml:lang="en"])'>
		<xml:text>No English or German description available.</xml:text>
	      </xsl:if>
	    </xsl:for-each>
	  </xsl:variable>
	  <xsl:variable name="description_in_cmdi2">
	    <!-- <xsl:value-of select="replace($description_in_cmdi[1], '&quot;', '\\&quot;')"/> -->
	    <xsl:call-template name="replace-string">
	      <xsl:with-param name="text" select="$description_in_cmdi"/>
	      <xsl:with-param name="replace" select="'&quot;'" />
	      <xsl:with-param name="with" select="'\\&quot;'"/>
	    </xsl:call-template>
	    
	    
	  </xsl:variable>
	  "description": " <xsl:value-of select="$description_in_cmdi2"/>", 
	  "url": "<xsl:value-of select="//*[local-name() = 'MdSelfLink']"/>",
	  "identifier": "<xsl:value-of select="//*[local-name() = 'MdSelfLink']"/>",
	  <!-- <xsl:for-each select="//*[local-name() = 'CMD']/*[local-name() = 'Resources']/*[local-name() = 'ResourceProxyList']/*[local-name() = 'ResourceProxy'][contains(*[local-name()='ResourceType'],'LandingPage')]">"<xsl:value-of select="./*[local-name() = 'ResourceRef']"/>" </xsl:for-each>,
          -->
	  "sameAs": "<xsl:for-each select="//*[local-name() = 'CMD']/*[local-name() = 'Resources']/
          *[local-name() = 'ResourceProxyList']/*[local-name() = 'ResourceProxy'][contains(*[local-name() = 'ResourceType'],'LandingPage')]">
	  <xsl:value-of select="./*[local-name() = 'ResourceRef']"/> </xsl:for-each>",

	  <xsl:choose>
	    <xsl:when test="//*[local-name()='Project']/*[local-name()='Institution']/*[local-name()='Organisation']//*[local-name()='name'] != '' and concat(./*[local-name()='firstName'], ' ', ./*[local-name()='lastName']) != ''">
	      "creator": [
	      <xsl:choose>
		<xsl:when test="//*[local-name()='Project']/*[local-name()='Institution']/*[local-name()='Organisation']//*[local-name()='name'] != ''">
		  {
		  "@type": "Organization",
		  "sameAs": <xsl:text>[</xsl:text> <xsl:for-each select="//*[local-name()='Project']/*[local-name()='Institution']/*[local-name()='Organisation']//*[local-name()='AuthoritativeID']">
		  "<xsl:value-of select="./*[local-name()='id']"/>"
		  <xsl:choose>
		    <xsl:when test="position() != last()">,</xsl:when>
		  </xsl:choose>
		  </xsl:for-each><xsl:text>]</xsl:text>,
		  "name": "<xsl:value-of select="//*[local-name()='Project']/*[local-name()='Institution']/*[local-name()='Organisation']//*[local-name()='name']"/>"
		  }  <xsl:choose>
		  <xsl:when test="concat((//*[local-name()='Creators']/*[local-name()='Person']/*[local-name()='firstName'])[1], ' ', (//*[local-name()='Creators']/*[local-name()='Person']/*[local-name()='lastName'])[1]) !=  ' '">
		    ,
		  </xsl:when>
		</xsl:choose>

		</xsl:when>
	      </xsl:choose>

	      <xsl:choose>
		<xsl:when test="concat((//*[local-name()='Creators']/*[local-name()='Person']/*[local-name()='firstName'])[1], ' ', (//*[local-name()='Creators']/*[local-name()='Person']/*[local-name()='lastName'])[1]) !=  ' '">
		  <xsl:for-each select="//*[local-name()='Creators']//*[local-name()='Person']">
		    {
		    "@type": "Person",
		    "givenName": "<xsl:value-of select="./*[local-name()='firstName']"/>",
		    "familyName": "<xsl:value-of select="./*[local-name()='lastName']"/>",
		    "name": "<xsl:value-of select="concat(./*[local-name()='firstName'], ' ', ./*[local-name()='lastName'])"/>"
		    }<xsl:if test="position() != last()">
		    <xsl:text>, </xsl:text>
		  </xsl:if>
		  </xsl:for-each>
		</xsl:when>
	      </xsl:choose>
	      ],
	    </xsl:when>
	  </xsl:choose>
	  <xsl:choose>
	    <xsl:when test="//*[local-name()='Licence']">
	      <xsl:if test="//*[local-name()='Licence'] != ''">
		"license": "<xsl:value-of select="//*[local-name()='Licence']"/>",
	      </xsl:if>
	    </xsl:when>
	  </xsl:choose>

	  "spatial": [
	  {
	  "name": "Germany",
	  "@type": "Place"
	  }
	  ],

	  <xsl:choose>
	    <xsl:when test="//*[local-name()='ResourceProxy']">
	      <xsl:if test="//*[local-name()='ResourceProxy'] != ''">

		"distribution": [<xsl:for-each select="//*[local-name()='ResourceProxy']">
		{
		"contentURL": "<xsl:value-of select="./*[local-name()='ResourceRef']"/>",
		"encodingFormat": "<xsl:value-of select="./*[local-name()='ResourceType']/@mimetype"/>",
		"@type": "DataDownload"
		}<xsl:if test="position() != last()">
		<xsl:text>, </xsl:text>
	      </xsl:if>
	      </xsl:for-each>],
	      </xsl:if>
	    </xsl:when>
	  </xsl:choose>
	  "includedInDataCatalog": {
	  "url": "https://vlo.clarin.eu",
	  "@type": "DataCatalog"
	  },
	  "@context": "https://schema.org",
	  "@type": "DataSet"
	  <xsl:text disable-output-escaping="yes">}/*]]&gt;*/</xsl:text>


	</xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
