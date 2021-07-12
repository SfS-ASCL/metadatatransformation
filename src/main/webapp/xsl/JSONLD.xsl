<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cmd="http://www.clarin.eu/cmd/" exclude-result-prefixes="">

	<xsl:output method="html" indent="yes"/>

	<xsl:template name="JSONLD">
		<xsl:element name="script">
			<xsl:attribute name="type">application/ld+json</xsl:attribute>

			<!-- Only generate JSON-LD if name and description exist -->
			<xsl:if test="//*[local-name() = 'ResourceName'] != '' or //*[local-name() = 'ResourceTitle'] != ''">

				<xsl:text>/*&lt;![CDATA[*/</xsl:text>
				<xsl:text>{&#xA;</xsl:text>
				<xsl:text>    "@context": "https://schema.org/",&#xA;</xsl:text>
				<xsl:text>    "@type": "DataSet",&#xA;</xsl:text>
				<xsl:text>    "name": "</xsl:text>
				
				<xsl:choose>
					<xsl:when test="//*[local-name() = 'ResourceName'] != ''">
						<xsl:value-of select="//*[local-name() = 'ResourceName']"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="//*[local-name() = 'ResourceTitle']"/>
					</xsl:otherwise>
				</xsl:choose>
				
				<xsl:text>",&#xA;</xsl:text>

				<!-- Add Description -->
				<!-- Escape quotation marks and remove linebreaks, since multi-line strings are not allowed in JSON -->
				<xsl:variable name="description_in_cmdi">
					<xsl:for-each
						select="//*[local-name() = 'GeneralInfo']/*[local-name() = 'Descriptions']/*[local-name() = 'Description']">
						<xsl:if test='@xml:lang = "en"'>
							<xsl:value-of select="."/>
						</xsl:if>
						<xsl:if
							test='@xml:lang = "de" and not(../*[local-name() = "Description"][@xml:lang = "en"])'>
							<xsl:value-of select="."/>
						</xsl:if>
						<!-- <xsl:value-of select="."/>-->
						<xsl:if
							test='not(@xml:lang = "de") and not(../*[local-name() = "Description"][@xml:lang = "en"])'>
							<xml:text>No English or German description available.</xml:text>
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="description_in_cmdi2">
					<!-- <xsl:value-of select="replace($description_in_cmdi[1], '&quot;', '\\&quot;')"/> -->
					<xsl:call-template name="replace-string">
						<xsl:with-param name="text" select="$description_in_cmdi"/>
						<xsl:with-param name="replace" select="'&quot;'"/>
						<xsl:with-param name="with" select="'\\&quot;'"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="description_in_cmdi3">
					<xsl:call-template name="replace-string">
						<xsl:with-param name="text" select="$description_in_cmdi2"/>
						<xsl:with-param name="replace" select="'&#xA;'"/>
						<xsl:with-param name="with" select="' '"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:text>    "description": "</xsl:text>
				<xsl:value-of select="normalize-space($description_in_cmdi3)"/>
				<xsl:text>",&#xA;</xsl:text>
				<xsl:text>    "url": "</xsl:text>
				<xsl:value-of select="//*[local-name() = 'MdSelfLink']"/>
				<xsl:text>",&#xA;</xsl:text>
				<xsl:text>    "identifier": "</xsl:text>
				<xsl:value-of select="//*[local-name() = 'MdSelfLink']"/>
				<xsl:text>",&#xA;</xsl:text>
				<xsl:text>    "dateModified": "</xsl:text>
				<xsl:value-of select="//*[local-name() = 'LastUpdate']"/>
				<xsl:text>",&#xA;</xsl:text>

				<!-- Check for LegalOwner nodes -->
				<xsl:if test="//*[local-name() = 'LegalOwner'] != ''">
					<xsl:text>    "copyrightHolder": [&#xA;</xsl:text>
					<xsl:for-each select="//*[local-name() = 'LegalOwner']">
						<xsl:text>        {&#xA;</xsl:text>
						<xsl:text>            "@language": "</xsl:text>
						<xsl:value-of select="./@*[local-name() = 'lang']"/>
						<xsl:text>",&#xA;</xsl:text>
						<xsl:text>            "@value": "</xsl:text>
						<xsl:value-of select="."/>
						<xsl:text>"&#xA;</xsl:text>
						<xsl:text>        }</xsl:text>

						<!-- Check if comma is needed -->
						<xsl:if test="position() != last()">
							<xsl:text>,&#xA;</xsl:text>
						</xsl:if>

					</xsl:for-each>
					<xsl:text>&#xA;    ],&#xA;</xsl:text>
				</xsl:if>

				<!-- Check for Genre -->
				<xsl:if test="//*[local-name() = 'Genre'] != ''">
					<xsl:text>    "genre": "</xsl:text>
					<xsl:value-of select="//*[local-name() = 'Genre']"/>
					<xsl:text>",&#xA;</xsl:text>
				</xsl:if>

				<!-- Check for fundingAgency -->
				<xsl:if test="//*[local-name() = 'fundingAgency'] != ''">
					<xsl:text>    "funder": "</xsl:text>
					<xsl:value-of select="//*[local-name() = 'fundingAgency']"/>
					<xsl:text>",&#xA;</xsl:text>
				</xsl:if>

				<!-- Check for Accessibility -->
				<xsl:if test="//*[local-name() = 'Availability'] != ''">
					<xsl:text>    "conditionsOfAccess": "</xsl:text>
					<xsl:value-of select="//*[local-name() = 'Availability']"/>
					<xsl:text>",&#xA;</xsl:text>
				</xsl:if>

				<!-- Check for Licence -->
				<xsl:if test="//*[local-name() = 'Licence'] != ''">
					<xsl:text>    "license": "</xsl:text>
					<xsl:value-of select="//*[local-name() = 'Licence']"/>
					<xsl:text>",&#xA;</xsl:text>
				</xsl:if>

				<xsl:text>&#xA;</xsl:text>
				
				<!-- DataCatalog -->
				<xsl:text>    "includedInDataCatalog": {&#xA;</xsl:text>
				<xsl:text>        "@type": "DataCatalog",&#xA;</xsl:text>
				<xsl:text>        "url": "https://vlo.clarin.eu"&#xA;</xsl:text>
				<xsl:text>    },&#xA;</xsl:text>

				<!-- Location Created -->
				<xsl:variable name="CreatLoc"
					select="//*[local-name() = 'GeneralInfo']/*[local-name() = 'Location']"/>
				<xsl:if test="$CreatLoc/*[local-name() = 'Address'] != ''">
					<xsl:text>    "locationCreated": {&#xA;</xsl:text>
					<xsl:text>        "@type": "Place",&#xA;</xsl:text>
					<xsl:text>        "address": {&#xA;</xsl:text>
					
					<xsl:text>            "@type": "PostalAddress",&#xA;</xsl:text>
					<xsl:text>            "name": "</xsl:text>
					<xsl:value-of select="normalize-space($CreatLoc/*[local-name() = 'Address'])"/>
					<xsl:text>"</xsl:text>

					<!-- Check if CountryCoding exists -->
					<xsl:if
						test="$CreatLoc/*[local-name() = 'Country']/*[local-name() = 'CountryCoding'] != ''">
						<xsl:text>,&#xA;</xsl:text>
						<xsl:text>            "addressCountry": "</xsl:text>
						<xsl:value-of
							select="normalize-space($CreatLoc/*[local-name() = 'Country']/*[local-name() = 'CountryCoding'])"/>
						<xsl:text>"&#xA;</xsl:text>
					</xsl:if>
					<!-- If CountryCoding empty/null add whitespace for correct indent -->
					<xsl:if
						test="$CreatLoc/*[local-name() = 'Country']/*[local-name() = 'CountryCoding'] = '' or not($CreatLoc/*[local-name() = 'Country']/*[local-name() = 'CountryCoding'])">
						<xsl:text>&#xA;</xsl:text>
					</xsl:if>
					<xsl:text>        }&#xA;</xsl:text>
					<xsl:text>    },&#xA;</xsl:text>
				</xsl:if>

				<!-- Creator -->
				<!-- Check if at least one Creator Person or an Organization exists -->
				<xsl:variable name="CreatorOrg"
					select="//*[local-name() = 'Project']/*[local-name() = 'Institution']/*[local-name() = 'Organisation']"/>
				<xsl:variable name="CreatorPers" select="//*[local-name() = 'Creators']"/>

				<xsl:if
					test="$CreatorOrg/*[local-name() = 'name'] != '' or $CreatorPers/*[local-name() = 'Person']/*[local-name() = 'lastName'] != ''">

					<xsl:text>    "creator": [&#xA;</xsl:text>
					<!-- Organization info -->
					<xsl:if test="$CreatorOrg/*[local-name() = 'name'] != ''">
						<xsl:text>        {&#xA;</xsl:text>
						<xsl:text>            "@type": "Organization",&#xA;</xsl:text>
						<xsl:text>            "name": "</xsl:text>
						<xsl:value-of select="$CreatorOrg/*[local-name() = 'name']"/>
						<xsl:text>"</xsl:text>

						<!-- Check if Organization Authoritative IDs exist -->
						<xsl:if
							test="$CreatorOrg/*[local-name() = 'AuthoritativeIDs']/*[local-name() = 'AuthoritativeID']/*[local-name() = 'id'] != ''">
							<xsl:text>,&#xA;</xsl:text>
							<xsl:text>            "sameAs": [&#xA;</xsl:text>
							<!-- Loop through IDs -->
							<xsl:for-each
								select="$CreatorOrg/*[local-name() = 'AuthoritativeIDs']/*[local-name() = 'AuthoritativeID']">
								<xsl:text>                "</xsl:text>
								<xsl:value-of select="./*[local-name() = 'id']"/>
								<xsl:text>"</xsl:text>

								<!-- Check for last comma -->
								<xsl:if test="position() != last()">
									<xsl:text>,</xsl:text>
								</xsl:if>
								<xsl:text>&#xA;</xsl:text>
							</xsl:for-each>
							<xsl:text>            ]&#xA;</xsl:text>
						</xsl:if>
						<xsl:text>        }</xsl:text>
					</xsl:if>

					<!-- Check for Person Creator -->
					<xsl:if
						test="$CreatorPers/*[local-name() = 'Person']/*[local-name() = 'lastName'] != ''">
						<xsl:for-each select="$CreatorPers/*[local-name() = 'Person']">
							<xsl:text>,&#xA;</xsl:text>
							<xsl:text>        {&#xA;</xsl:text>
							<xsl:text>            "@type": "Person",&#xA;</xsl:text>
							<xsl:text>            "givenName": "</xsl:text>
							<xsl:value-of select="./*[local-name() = 'firstName']"/>
							<xsl:text>",&#xA;</xsl:text>
							<xsl:text>            "familyName": "</xsl:text>
							<xsl:value-of select="./*[local-name() = 'lastName']"/>
							<xsl:text>",&#xA;</xsl:text>
							<xsl:text>            "name": "</xsl:text>
							<xsl:value-of
								select="concat(./*[local-name() = 'firstName'], ' ', ./*[local-name() = 'lastName'])"/>
							<xsl:text>"&#xA;</xsl:text>
							<xsl:text>        }</xsl:text>
						</xsl:for-each>
					</xsl:if>
					<xsl:text>&#xA;    ],&#xA;</xsl:text>
				</xsl:if>

				<!-- Check for isBasedOn (Source) -->
				<xsl:if test="//*[local-name() = 'OriginalSource'] != ''">
					<xsl:text>    "isBasedOnUrl": {&#xA;</xsl:text>
					<xsl:text>        "@type": "CreativeWork",&#xA;</xsl:text>
					<xsl:text>        "name": "</xsl:text>
					<xsl:value-of select="//*[local-name() = 'OriginalSource']"/>
					<xsl:text>"&#xA;</xsl:text>
					<xsl:text>    },&#xA;</xsl:text>
				</xsl:if>

				<!-- Distribution (ResoureProxy Informations) -->

				<xsl:text>    "distribution": [&#xA;</xsl:text>
				<xsl:for-each select="//*[local-name() = 'ResourceProxy']">
					<xsl:variable name="ResName" select="./*[local-name() = 'ResourceRef']"/>
					<xsl:variable name="ResFileName" select="tokenize($ResName, '@')[last()]"/>
					<xsl:variable name="ResProxListInfo"
						select="//*[text() = $ResFileName]/parent::node()"/>

					<xsl:text>        {&#xA;</xsl:text>
					<xsl:text>           "@type": "DataDownload",&#xA;</xsl:text>
					<xsl:text>           "contentURL": "</xsl:text>
					<xsl:value-of select="$ResName"/>
					<xsl:text>",&#xA;</xsl:text>
					<xsl:text>           "encodingFormat": "</xsl:text>
					<xsl:value-of select="./*[local-name() = 'ResourceType']/@mimetype"/>
					<xsl:text>"&#xA;</xsl:text>

					<xsl:if test="$ResProxListInfo//*[local-name() = 'Size'] != ''">
						<xsl:text>,&#xA;</xsl:text>
						<xsl:text>           "contentSize": "</xsl:text>
						<xsl:value-of select="$ResProxListInfo//*[local-name() = 'Size']"/>
						<xsl:text>",&#xA;</xsl:text>

						<!-- Checksums -->
						<!-- MD5 -->
						<xsl:text>           "identifier": [&#xA;</xsl:text>
						<xsl:text>               {&#xA;</xsl:text>
						<xsl:text>                  "@type": "PropertyValue",&#xA;</xsl:text>
						<xsl:text>                  "propertyID": "MD5",&#xA;</xsl:text>
						<xsl:text>                   "identifier": "md5:</xsl:text>
						<xsl:value-of select="$ResProxListInfo//*[local-name() = 'md5']"/>
						<xsl:text>",&#xA;</xsl:text>
						<xsl:text>                   "value": "</xsl:text>
						<xsl:value-of select="$ResProxListInfo//*[local-name() = 'md5']"/>
						<xsl:text>"&#xA;</xsl:text>
						<xsl:text>               },&#xA;</xsl:text>

						<!-- SHA1 -->
						<xsl:text>               {&#xA;</xsl:text>
						<xsl:text>                   "@type": "PropertyValue",&#xA;</xsl:text>
						<xsl:text>                   "propertyID": "SHA1",&#xA;</xsl:text>
						<xsl:text>                   "identifier": "sha1:</xsl:text>
						<xsl:value-of select="$ResProxListInfo//*[local-name() = 'sha1']"/>
						<xsl:text>",&#xA;</xsl:text>
						<xsl:text>                   "value": "</xsl:text>
						<xsl:value-of select="$ResProxListInfo//*[local-name() = 'sha1']"/>
						<xsl:text>"&#xA;</xsl:text>
						<xsl:text>               },&#xA;</xsl:text>

						<!-- SHA256 -->
						<xsl:text>               {&#xA;</xsl:text>
						<xsl:text>                  "@type": "PropertyValue",&#xA;</xsl:text>
						<xsl:text>                  "propertyID": "SHA256",&#xA;</xsl:text>
						<xsl:text>                  "identifier": "sha1:</xsl:text>
						<xsl:value-of select="$ResProxListInfo//*[local-name() = 'sha256']"/>
						<xsl:text>",&#xA;</xsl:text>
						<xsl:text>                  "value": "</xsl:text>
						<xsl:value-of select="$ResProxListInfo//*[local-name() = 'sha256']"/>
						<xsl:text>"&#xA;</xsl:text>
						<xsl:text>               }&#xA;</xsl:text>

						<xsl:text>            ]&#xA;</xsl:text>
					</xsl:if>
					<xsl:text>        }</xsl:text>

					<!-- Check for last comma -->
					<xsl:if test="position() != last()">
						<xsl:text>,</xsl:text>
					</xsl:if>
					<xsl:text>&#xA;</xsl:text>

				</xsl:for-each>
				<xsl:text>    ]</xsl:text>
				<xsl:text>&#xA;}</xsl:text>
				<xsl:text>]</xsl:text>
			</xsl:if>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
