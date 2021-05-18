<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:cmd="http://www.clarin.eu/cmd/"
  xmlns:cmde="http://www.clarin.eu/cmd/1"
  xmlns:functx="http://www.functx.com"
  xmlns:foo="foo.com"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  exclude-result-prefixes="xs xd functx">

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Jan 24, 2017</xd:p>
      <xd:p><xd:b>Author:</xd:b> ttrippel, czinn</xd:p>
      <xd:p/>
    </xd:desc>
  </xd:doc>

  <!-- Stylesheets with templates used in multiple places:  -->
  <xsl:include href="xsl/Utils.xsl"/>

  <!-- Stylesheets for individual components: -->
  <xsl:include href="xsl/GeneralInfo.xsl"/>
  <xsl:include href="xsl/Project.xsl"/>
  <xsl:include href="xsl/Publications.xsl"/>
  <xsl:include href="xsl/Creation.xsl"/>
  <xsl:include href="xsl/Documentations.xsl"/>
  <xsl:include href="xsl/Access.xsl"/>
  <xsl:include href="xsl/ResourceProxyList.xsl"/>
  <xsl:include href="xsl/ResourceProxyListInfo.xsl"/>

  <xsl:output method="html" indent="yes"/>

  <!-- <xsl:strip-space elements="cmd:Description"/> -->
  <xsl:strip-space elements="*"/>

<!-- ToolProfile:            clarin.eu:cr1:p_1447674760338 
		 TextCorpusProfile:      clarin.eu:cr1:p_1442920133046
		 LexicalResourceProfile: clarin.eu:cr1:p_1445542587893
		 ExperimentProfile:      clarin.eu:cr1:p_1447674760337
		 

new ExperimentProfile: clarin.eu:cr1:p_1524652309872 
new TextCorpusProfile: clarin.eu:cr1:p_1524652309874
new ToolProfile: clarin.eu:cr1:p_1524652309875
new LexicalResourceProfile: clarin.eu:cr1:p_1524652309876
new CourseProfile: clarin.eu:cr1:p_1524652309877
new SpeechCorpusProfile: clarin.eu:cr1:p_1524652309878 
		 
    -->

  <!-- This need to be OR'ed for all valid NaLiDa-based profiles -->
  <xsl:template match="/cmd:CMD">
    <xsl:choose>
      <xsl:when
        test="
          contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1447674760338')
          or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1442920133046')
          or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1445542587893')
          or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1485173990943')
          or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1447674760337')
          or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1505397653792')">
        <!-- CMDI 1.1 -->
        <xsl:call-template name="mainProcessing"/>
      </xsl:when>
      <xsl:otherwise>
        <error>
          <xsl:text>
		  Please use a valid CMDI schema v1.1 from the NaLiDa project.
		  Currently the following profiles are being supported:
		
		  - ToolProfile (clarin.eu:cr1:p_1447674760338),
		  - TextCorpusProfile ('clarin.eu:cr1:p_1442920133046),
		  - LexicalResourceProfile (clarin.eu:cr1:p_1445542587893), 
		  - SpeechCorpusProfile (clarin.eu:cr1:p_1485173990943), and
		  - ExperimentProfile (clarin.eu:cr1:p_1447674760337)
		  - CourseProfile (clarin.eu:cr1:p_1505397653792).
		  
		  Additional we suppor the following profiles, which are utilized by the CLARIN-D-Centre in Tübingen
		  - OLAC-DcmiTerms: clarin.eu:cr1:p_1288172614026
		  - DcmiTerms: clarin.eu:cr1:p_1288172614023
		  
		  Older version of the profiles are partly supported, currently only if used  in CMDI 1.2 files: 
		  - ExperimentProfile: clarin.eu:cr1:p_1302702320451
		  - LexicalResourceProfile: clarin.eu:cr1:p_1290431694579
		  - TextCorpusProfile: clarin.eu:cr1:p_1290431694580
		  - ToolProfile: clarin.eu:cr1:p_1290431694581
		  - WebLichtWebService: clarin.eu:cr1:p_1320657629644
		  - Resource Bundle: clarin.eu:cr1:p_1320657629649
		  
		  Newer version of the profiles are partly, currently only if used  in CMDI 1.2 files: 
		  - ExperimentProfile: clarin.eu:cr1:p_1524652309872 
		  - TextCorpusProfile: clarin.eu:cr1:p_1524652309874
		  - ToolProfile: clarin.eu:cr1:p_1524652309875
		  - LexicalResourceProfile: clarin.eu:cr1:p_1524652309876
		  - CourseProfile: clarin.eu:cr1:p_1524652309877
		  - SpeechCorpusProfile: clarin.eu:cr1:p_1524652309878 
		  
	  
		</xsl:text>
        </error>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/cmde:CMD/cmde:Header">
    <!-- ignore header -->
  </xsl:template>
  
  <xsl:template match="/cmde:CMD">
    <xsl:choose>
      <xsl:when
        test="
          contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1447674760338')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1442920133046')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1445542587893')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1485173990943')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1447674760337')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1505397653792')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1288172614026')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1288172614023')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1302702320451')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1290431694579')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1290431694580')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1320657629644')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1320657629649')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1524652309872')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1524652309874')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1524652309875')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1524652309876')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1524652309877')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1524652309878')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176122')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176123')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176124')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176125')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176126')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176127')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176128')
          or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1548239945774')
          ">
        <!-- CMDI 1.2 -->
        <xsl:call-template name="mainProcessing"/>
      </xsl:when>
      <xsl:otherwise>
        <error>
          <xsl:text>
		Please use a valid CMDI v1.2 schema from the NaLiDa project.
		Currently the following profiles are being supported:
		
		- ToolProfile (clarin.eu:cr1:p_1447674760338),
		- TextCorpusProfile ('clarin.eu:cr1:p_1442920133046)
		- LexicalResourceProfile (clarin.eu:cr1:p_1445542587893) 
 		- SpeechCorpusProfile (clarin.eu:cr1:p_1485173990943)		
		- ExperimentProfile (clarin.eu:cr1:p_1447674760337)
		- CourseProfile (clarin.eu:cr1:p_1505397653792)

		  - ExperimentProfile: clarin.eu:cr1:p_1524652309872 
		  - TextCorpusProfile: clarin.eu:cr1:p_1524652309874
		  - ToolProfile: clarin.eu:cr1:p_1524652309875
		  - LexicalResourceProfile: clarin.eu:cr1:p_1524652309876
		  - CourseProfile: clarin.eu:cr1:p_1524652309877
		  - SpeechCorpusProfile: clarin.eu:cr1:p_1524652309878 
		  
		    - TextCorpusProfile: clarin.eu:cr1:p_1527668176122
		    - LexicalResourceProfile: clarin.eu:cr1:p_1527668176123
		    - ToolProfile: clarin.eu:cr1:p_1527668176124
		    - CourseProfile: clarin.eu:cr1:p_1527668176125
		    - ExperimentProfile: clarin.eu:cr1:p_1527668176126
		    - ResourceBundle: clarin.eu:cr1:p_1527668176127
		    - SpeechCorpusProfile: clarin.eu:cr1:p_1527668176128
		
    Additionally we support the following profiles, which are utilized by the CLARIN-D-Centre in Tübingen
		  - OLAC-DcmiTerms: clarin.eu:cr1:p_1288172614026
		  - DcmiTerms: clarin.eu:cr1:p_1288172614023
		  
		  Older versions of the profiles are partly supported, currently only if used in CMDI 1.2 files: 
		  - ExperimentProfile: clarin.eu:cr1:p_1302702320451
		  - LexicalResourceProfile: clarin.eu:cr1:p_1290431694579
		  - TextCorpusProfile: clarin.eu:cr1:p_1290431694580
		  - ToolProfile: clarin.eu:cr1:p_1290431694581
		  - WebLichtWebService: clarin.eu:cr1:p_1320657629644
		  - Resource Bundle: clarin.eu:cr1:p_1320657629649
		  
                    
                    </xsl:text>
        </error>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="mainProcessing">
    <html>
      <head>
        <title>Resource: <xsl:value-of select="//*[local-name() = 'ResourceName']"/>
        </title>

        <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"/>

        <link rel="stylesheet" type="text/css"
          href="https://talar.sfb833.uni-tuebingen.de/assets/main.css"/>

        <script src="https://code.jquery.com/jquery-3.1.1.min.js" integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8=" crossorigin="anonymous"/>

        <script src="https://code.jquery.com/ui/1.12.0/jquery-ui.min.js" integrity="sha256-eGE6blurk5sHj+rmkfsGYeKyZx3M4bG+ZlFyA7Kns7E=" crossorigin="anonymous"/>
        <xsl:call-template name="JSONLD"/>
	<xsl:comment>Generated with CMDI2HTML version 1.0.8</xsl:comment>
      </head>


      <body>
        <header class="site-header" role="banner">
          <div class="wrapper">
            <a class="site-title" rel="author" href="https://talar.sfb833.uni-tuebingen.de/"
              style="margin-bottom:15px;">TALAR - Tübingen Archive of Language Resources</a>
            <nav class="site-nav">
              <label for="nav-trigger">
                <span class="menu-icon">
                  <svg viewBox="0 0 18 15" width="18px" height="15px">
                    <path
                      d="M18,1.484c0,0.82-0.665,1.484-1.484,1.484H1.484C0.665,2.969,0,2.304,0,1.484l0,0C0,0.665,0.665,0,1.484,0 h15.032C17.335,0,18,0.665,18,1.484L18,1.484z M18,7.516C18,8.335,17.335,9,16.516,9H1.484C0.665,9,0,8.335,0,7.516l0,0 c0-0.82,0.665-1.484,1.484-1.484h15.032C17.335,6.031,18,6.696,18,7.516L18,7.516z M18,13.516C18,14.335,17.335,15,16.516,15H1.484 C0.665,15,0,14.335,0,13.516l0,0c0-0.82,0.665-1.483,1.484-1.483h15.032C17.335,12.031,18,12.695,18,13.516L18,13.516z"
                    />
                  </svg>
                </span>
              </label>

              <div class="trigger" style="margin-bottom:15px;">
                <a class="page-link" href="https://talar.sfb833.uni-tuebingen.de/about/">About</a>
                <a class="page-link" href="https://talar.sfb833.uni-tuebingen.de/contact/"
                  >Contact</a>
                <a class="page-link" href="https://talar.sfb833.uni-tuebingen.de/archival/">Data
                  Management</a>
                <a class="page-link" href="https://talar.sfb833.uni-tuebingen.de/help/">Help</a>
                <a class="page-link" href="https://talar.sfb833.uni-tuebingen.de/privacy_html/"
                  >Privacy</a>
                <a class="page-link" href="https://talar.sfb833.uni-tuebingen.de/stats/"
                  >Statistics</a>
                <a class="page-link" href="https://talar.sfb833.uni-tuebingen.de/technology/"
                  >Technology</a>
              </div>
            </nav>
          </div>
        </header>
        <script>
    	    $(function() {
    	    $( "#tabs" ).tabs({
            event: "mouseover"
    	    //event: "click"
    	    });
    	    });
	  </script>
        
        <h1 style="margin-left:15px;">
          <b>Resource: <xsl:value-of
              select="//*[local-name() = 'GeneralInfo']/*[local-name() = 'ResourceName']"/></b>
        </h1>

        <div id="tabs">
          <ul>
            <li>
              <a href="#tabs-1">General Info</a>
            </li>
            <xsl:if test="//*[local-name() = 'Project']">
              <li>
                <a href="#tabs-2">Project</a>
              </li>
            </xsl:if>
            <xsl:if test="//*[local-name() = 'Publications']">
              <li>
                <a href="#tabs-3">Publications</a>
              </li>
            </xsl:if>
            <xsl:if test="//*[local-name() = 'Creation']">
              <li>
                <a href="#tabs-4">Creation</a>
              </li>
            </xsl:if>
            <xsl:if test="//*[local-name() = 'Documentations']">
              <li>
                <a href="#tabs-5">Documentation</a>
              </li>
            </xsl:if>
            <xsl:if test="//*[local-name() = 'Access']">
              <li>
                <a href="#tabs-6">Access</a>
              </li>
            </xsl:if>
            <!--      <xsl:if test="not(contains(//*:Components/*/local-name(), 'DcmiTerms'))"><li><a href="#tabs-7">Resource-specific information</a></li></xsl:if> -->
            <li>
              <a href="#tabs-7">Resource-specific information</a>
            </li>
            <li>
              <a href="#tabs-8">Data files</a>
            </li>
            <li>
              <a href="#tabs-9">About...</a>
            </li>
            <li>
              <a href="#tabs-10">Cite dataset as</a>
            </li>
          </ul>

          <xsl:apply-templates/>
        </div>
        <footer class="site-footer h-card">
          <data class="u-url" href="/"/>

          <div class="wrapper">

            <h2 class="footer-heading">TALAR - Tübingen Archive of Language Resources</h2>

            <div class="footer-col-wrapper">
              <div class="footer-col footer-col-1">
                <ul class="contact-list">
                  <li class="p-name">TALAR - Tübingen Archive of Language Resources</li>
                  <li>
                    <a class="u-email" href="mailto:clarin-repository@sfs.uni-tuebingen.de"
                      >clarin-repository@sfs.uni-tuebingen.de</a>
                  </li>
                </ul>
              </div>
              <div class="footer-col footer-col-1">
                <ul class="social-media-list">
                  <li>
                    <a href="https://www.facebook.com/clarindeutschland">
                      <svg class="svg-icon" id="facebook" fill-rule="evenodd" clip-rule="evenodd"
                        stroke-linejoin="round" stroke-miterlimit="1.414">
                        <path
                          d="M15.117 0H.883C.395 0 0 .395 0 .883v14.234c0 .488.395.883.883.883h7.663V9.804H6.46V7.39h2.086V5.607c0-2.066 1.262-3.19 3.106-3.19.883 0 1.642.064 1.863.094v2.16h-1.28c-1 0-1.195.48-1.195 1.18v1.54h2.39l-.31 2.42h-2.08V16h4.077c.488 0 .883-.395.883-.883V.883C16 .395 15.605 0 15.117 0"
                        />
                      </svg>
                      <span class="username">clarindeutschland</span>
                    </a>
                  </li>
                  <li>
                    <a href="https://www.twitter.com/CLARIN_D">
                      <svg class="svg-icon" id="twitter" fill-rule="evenodd" clip-rule="evenodd"
                        stroke-linejoin="round" stroke-miterlimit="1.414">
                        <path
                          d="M16 3.038c-.59.26-1.22.437-1.885.517.677-.407 1.198-1.05 1.443-1.816-.634.37-1.337.64-2.085.79-.598-.64-1.45-1.04-2.396-1.04-1.812 0-3.282 1.47-3.282 3.28 0 .26.03.51.085.75-2.728-.13-5.147-1.44-6.766-3.42C.83 2.58.67 3.14.67 3.75c0 1.14.58 2.143 1.46 2.732-.538-.017-1.045-.165-1.487-.41v.04c0 1.59 1.13 2.918 2.633 3.22-.276.074-.566.114-.865.114-.21 0-.41-.02-.61-.058.42 1.304 1.63 2.253 3.07 2.28-1.12.88-2.54 1.404-4.07 1.404-.26 0-.52-.015-.78-.045 1.46.93 3.18 1.474 5.04 1.474 6.04 0 9.34-5 9.34-9.33 0-.14 0-.28-.01-.42.64-.46 1.2-1.04 1.64-1.7z"
                        />
                      </svg>
                      <span class="username">CLARIN_D</span>
                    </a>
                  </li>
                  <li>
                    <a href="https://youtube.com/CLARINGermany">
                      <svg class="svg-icon" id="youtube" fill-rule="evenodd" clip-rule="evenodd"
                        stroke-linejoin="round" stroke-miterlimit="1.414">
                        <path
                          d="M0 7.345c0-1.294.16-2.59.16-2.59s.156-1.1.636-1.587c.608-.637 1.408-.617 1.764-.684C3.84 2.36 8 2.324 8 2.324s3.362.004 5.6.166c.314.038.996.04 1.604.678.48.486.636 1.588.636 1.588S16 6.05 16 7.346v1.258c0 1.296-.16 2.59-.16 2.59s-.156 1.102-.636 1.588c-.608.638-1.29.64-1.604.678-2.238.162-5.6.166-5.6.166s-4.16-.037-5.44-.16c-.356-.067-1.156-.047-1.764-.684-.48-.487-.636-1.587-.636-1.587S0 9.9 0 8.605v-1.26zm6.348 2.73V5.58l4.323 2.255-4.32 2.24z"
                        />
                      </svg>
                      <span class="username">CLARINGermany</span>
                    </a>
                  </li>
                </ul>
              </div>
            </div>

          </div>

        </footer>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="*[local-name() = 'GeneralInfo']">
    <div id="tabs-1">
      <h3>General Information</h3>
      <xsl:call-template name="GeneralInfoAsTable" />
    </div>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Project']">
    <div id="tabs-2">
      <h3>Project</h3>
      <xsl:call-template name="ProjectAsTable" />
    </div>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Publications']">
    <div id="tabs-3">
      <h3>Publications</h3>
      <xsl:call-template name="PublicationsAsTable" />
    </div>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Creation']">
    <div id="tabs-4">
      <h3>Creation</h3>
      <xsl:call-template name="CreationAsTable" />
    </div>
    <div id="tabs-10">
      <h3>Citation</h3>
      <p>To cite <em>the dataset itself</em>, please use the following:</p>
      <xsl:call-template name="CitationAsTable"/>
    </div>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Documentations']">
    <div id="tabs-5">
      <h3>Documentation</h3>
      <xsl:call-template name="DocumentationsAsTable" />
    </div>
  </xsl:template>

  <xsl:template match="*[local-name() = 'Access']">
    <div id="tabs-6">
      <h3>Access</h3>
      <xsl:call-template name="AccessAsTable" />
    </div>
  </xsl:template>

  <xsl:template match="//*[local-name() = 'ResourceProxyList']">
    <div id="tabs-8">
      <h3>Data Files</h3>
      <xsl:call-template name="ResourceProxyListSection" /> 
    </div>
  </xsl:template>


  <xsl:template match="*[local-name() = 'ResourceProxyListInfo']">
    <!-- ignore content, generate About instead, still to do, especially enhancing! -->

    <div id="tabs-9">
      <h3>About</h3>
      <p> This digital object contains: </p>
      <xsl:call-template name="ChecksumsAsTable" /> 
      <xsl:call-template name="AboutChecksumsTable" /> 
    </div>
      
  </xsl:template>

  <!-- Resource type specific templates -->

  <xsl:template match="*[local-name() = 'LexicalResourceContext']">
    <div id="tabs-7">
      <p>
        <table>
          <thead>
            <tr>
              <th>
                <h3>Lexical Resource</h3>
              </th>
              <th/>
            </tr>
          </thead>
          <tr>
            <td>
              <b>Lexicon Type: </b>
            </td>
            <td>
              <xsl:value-of select="./*[local-name() = 'LexiconType']"/>
            </td>
          </tr>
          <tr>
            <td>
              <b>Subject Language(s): </b>
            </td>
            <td>
              <xsl:value-of
                select="./*[local-name() = 'SubjectLanguages']/*[local-name() = 'SubjectLanguage']/*[local-name() = 'Language']/*[local-name() = 'LanguageName']"
              />
            </td>
          </tr>
          <tr>
            <td>
              <b>Auxiliary Language(s): </b>
            </td>
            <td>
              <xsl:value-of
                select="./*[local-name() = 'AuxiliaryLanguages']/*[local-name() = 'Language']/*[local-name() = 'LanguageName']"
              />
            </td>
          </tr>
          <tr>
            <td>
              <b>Headword Type: </b>
            </td>
            <td>
              <xsl:value-of
                select="./*[local-name() = 'HeadwordType']/*[local-name() = 'LexicalUnit']"/>
              <xsl:if
                test="./*[local-name() = 'HeadwordType']/*[local-name() = 'Descriptions']/*[local-name() = 'Description'] != ''"
                > (<xsl:value-of
                  select="./*[local-name() = 'HeadwordType']/*[local-name() = 'Descriptions']/*[local-name() = 'Description']"
                />) </xsl:if>
            </td>
          </tr>
          <tr>
            <td>
              <b>Type-specific Size Info(s): </b>
            </td>
            <td>
              <xsl:apply-templates select="*[local-name() = 'TypeSpecificSizeInfo']"></xsl:apply-templates>
              <!-- <xsl:value-of
                   select="./*[local-name() =
                   'TypeSpecificSizeInfo']/*[local-name() = 'TypeSpecificSize']/*[local-name() = 'Size']" /> -->
            </td>
          </tr>
          <tr>
            <td>
              <b>Description: </b>
            </td>
            <td>
              <xsl:apply-templates select="*[local-name() = 'Descriptions']"/> 
              <!-- <xsl:value-of
                   select="./*[local-name() = 'Descriptions']/*[local-name() = 'Description']"/> -->
            </td>
          </tr>
        </table>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="*[local-name() = 'ExperimentContext']">
    <div id="tabs-7">
      <p>
        <table>
          <thead>
            <tr>
              <th>
                <h3>Experiment(s)</h3>
              </th>
              <th/>
            </tr>
          </thead>
          <tr>
            <xsl:for-each
              select="./*[local-name() = 'ExperimentalStudy']/*[local-name() = 'Experiment']">
              <tr>
                <td>
                  <b>Name:</b>
                </td>
                <td>
                  <xsl:value-of select="./*[local-name() = 'ExperimentName']"/>
                </td>
              </tr>
              <tr>
                <td>
                  <b>Title:</b>
                </td>
                <td>
                  <xsl:value-of select="./*[local-name() = 'ExperimentTitle']"/>
                </td>
              </tr>
              <tr>
                <td>
                  <b>Paradigm:</b>
                </td>
                <td>
                  <xsl:value-of select="./*[local-name() = 'ExperimentalParadigm']"/>
                </td>
              </tr>
              <tr>
                <td>
                  <b>Description:</b>
                </td>
                <td>

                  <xsl:apply-templates select="*[local-name() = 'Descriptions']"/> 
                  <!--<xsl:value-of
                      select="./*[local-name() = 'Descriptions']/*[local-name() = 'Description']"/> -->
                </td>
              </tr>
              <!-- more here -->
              <tr>
                <td>
                  <b>Experimental Quality:</b>
                </td>
                <td>
                  <xsl:value-of
                    select="./*[local-name() = 'ExperimentalQuality']/*[local-name() = 'QualityCriteria']"
                  />
                </td>
              </tr>
              <tr>
                <td>
                  <b>Subject Language(s):</b>
                </td>
                <td>
                  <xsl:value-of
                    select="./*[local-name() = 'SubjectLanguages']/*[local-name() = 'SubjectLanguage']/*[local-name() = 'Language']/*[local-name() = 'LanguageName']"
                  />
                </td>
              </tr>
              <tr>
                <td>
                  <b>Material(s):</b>
                </td>
                <td>
                  <ul>
                    <xsl:for-each
                      select="./*[local-name() = 'Materials']/*[local-name() = 'Material']">
                      <li>
                        <xsl:value-of select="./*[local-name() = 'Domain']"/>
                        <xsl:if
                          test="./*[local-name() = 'Descriptions']/*[local-name() = 'Description'] != ''">
                          <xsl:text>
			      : 
			    </xsl:text>
                            <xsl:apply-templates select="*[local-name() = 'Descriptions']"/> 
                            <!-- <xsl:value-of
				 select="./*[local-name() = 'Descriptions']/*[local-name() = 'Description']" /> -->
                        </xsl:if>
                      </li>
                    </xsl:for-each>
                  </ul>
                </td>
              </tr>
              <tr>
                <td>
                  <b>Hypotheses:</b>
                </td>
                <td>
                  <xsl:value-of
                    select="./*[local-name() = 'Hypotheses']/*[local-name() = 'Hypothesis']/*[local-name() = 'Descriptions']/*[local-name() = 'Description']"
                  />
                </td>
              </tr>
              <!-- much more here -->
              <tr>
                <td>
                  <b>Method(s):</b>
                </td>
                <td>
                  <table border="3" cellpadding="10" cellspacing="10">
                    <tr>
                      <td>
                        <b>Experiment type:</b>
                      </td>
                      <td>
                        <xsl:value-of
                          select="./*[local-name() = 'Method']/*[local-name() = 'Elicitation']//*[local-name() = 'ExperimentType']"
                        />
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <b>Elicitation instrument:</b>
                      </td>
                      <td>
                        <xsl:value-of
                          select="./*[local-name() = 'Method']/*[local-name() = 'Elicitation']//*[local-name() = 'ElicitationInstrument']"
                        />
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <b>Elicitation software:</b>
                      </td>
                      <td>
                        <xsl:value-of
                          select="./*[local-name() = 'Method']/*[local-name() = 'Elicitation']//*[local-name() = 'ElicitationSoftware']"
                        />
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <b>Variable(s)</b>
                      </td>
                      <td>
                        <ul>
                          <xsl:for-each
                            select="./*[local-name() = 'Method']/*[local-name() = 'Elicitation']/*[local-name() = 'Variables']/*[local-name() = 'Variable']">
                            <li>
                              <xsl:value-of select="./*[local-name() = 'VariableName']"/>
                              <xsl:if test="./*[local-name() = 'VariableType'] != ''">
                                <xsl:text> (</xsl:text>
                                <xsl:value-of select="./*[local-name() = 'VariableType']"/>
                                <xsl:text>)</xsl:text>
                              </xsl:if>
                            </li>
                          </xsl:for-each>
                        </ul>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <b>Participant(s)</b>
                      </td>
                      <td>
                        <table border="3" cellpadding="10" cellspacing="10">
                          <tr>
                            <td>
                              <b>Anonymization flag:</b>
                            </td>
                            <td>
                              <xsl:value-of
                                select="./*[local-name() = 'Method']/*[local-name() = 'Participants']/*[local-name() = 'AnonymizationFlag']"
                              />
                            </td>
                          </tr>
                          <tr>
                            <td>
                              <b>Sampling method:</b>
                            </td>
                            <td>
                              <xsl:value-of
                                select="./*[local-name() = 'Method']/*[local-name() = 'Participants']/*[local-name() = 'SamplingMethod']"
                              />
                            </td>
                          </tr>
                          <tr>
                            <td>
                              <b>Sampling size:</b>
                            </td>
                            <td>
                              <xsl:value-of
                                select="./*[local-name() = 'Method']/*[local-name() = 'Participants']/*[local-name() = 'SampleSize']/*[local-name() = 'Size']"/>
                              <xsl:if
                                test="./*[local-name() = 'Method']/*[local-name() = 'Participants']/*[local-name() = 'SampleSize']/*[local-name() = 'SizeUnit'] != ''">
                                <xsl:text> </xsl:text>
                                <xsl:value-of
                                  select="./*[local-name() = 'Method']/*[local-name() = 'Participants']/*[local-name() = 'SampleSize']/*[local-name() = 'SizeUnit']"
                                />
                              </xsl:if>
                            </td>
                          </tr>
                          <tr>
                            <td>
                              <b>Sex distribution:</b>
                            </td>
                            <td>
                              <ul>
                                <xsl:for-each
                                  select="./*[local-name() = 'Method']/*[local-name() = 'Participants']/*[local-name() = 'SexDistribution']/*[local-name() = 'SexDistributionInfo']">
                                  <li>
                                    <xsl:value-of select="./*[local-name() = 'ParticipantSex']"
                                      />:<xsl:value-of select="./*[local-name() = 'Size']"/>
                                  </li>
                                </xsl:for-each>
                              </ul>
                            </td>
                          </tr>
                          <tr>
                            <td>
                              <b>Age distribution:</b>
                            </td>
                            <td>
                              <xsl:value-of
                                select="./*[local-name() = 'Method']/*[local-name() = 'Participants']//*[local-name() = 'ParticipantMeanAge']"
                              />
                            </td>
                          </tr>
                          <tr>
                            <td>
                              <b>Language variety:</b>
                            </td>
                            <td>
                              <xsl:value-of
                                select="./*[local-name() = 'Method']/*[local-name() = 'Participants']//*[local-name() = 'VarietyName']"
                                />:<xsl:value-of
                                select="./*[local-name() = 'Method']/*[local-name() = 'Participants']//*[local-name() = 'NoParticipants']"
                              />
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr>
                <td>
                  <b>Results:</b>
                </td>
                <td>
                  <xsl:value-of
                    select="./*[local-name() = 'Results']/*[local-name() = 'Descriptions']/*[local-name() = 'Description']"
                  />
                </td>
              </tr>
              <tr>
                <td>
                  <b>Analysis Tool Info:</b>
                </td>
                <td>
                  <xsl:value-of
                    select="./*[local-name() = 'AnalysisToolInfo']/*[local-name() = 'AnalysisTool']"/>
                  <xsl:if
                    test="./*[local-name() = 'AnalysisToolInfo']/*[local-name() = 'ToolType'] != ''"
                    > (<xsl:value-of
                      select="./*[local-name() = 'AnalysisToolInfo']/*[local-name() = 'ToolType']"
                    />) </xsl:if>
                  <xsl:if
                    test="./*[local-name() = 'AnalysisToolInfo']/*[local-name() = 'Version'] != ''">
                    , Version: <xsl:value-of
                      select="./*[local-name() = 'AnalysisToolInfo']/*[local-name() = 'Version']"/>.
                  </xsl:if>
                </td>
              </tr>
              <tr>
                <td>
                  <b>Type-specific Size info: </b>
                </td>
                <td>
                  <xsl:value-of
                    select="./*[local-name() = 'TypeSpecificSizeInfo']/*[local-name() = 'TypeSpecificSize']/*[local-name() = 'Size']"
                  />
                </td>
              </tr>
              <hr/>
            </xsl:for-each>
          </tr>
        </table>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="*[local-name() = 'ToolContext']">
    <div id="tabs-7">
      <p>
        <table>
          <thead>
            <tr>
              <th>
                <h3>Tool(s)</h3>
              </th>
              <th/>
            </tr>
          </thead>
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
        </table>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="*[local-name() = 'SpeechCorpusContext']">
    <div id="tabs-7">
      <p>
        <table>
          <thead>
            <tr>
              <th>
                <h3>Speech Corpus</h3>
              </th>
              <th/>
            </tr>
          </thead>
          <tr>
            <td>
              <b>Modalities: </b>
            </td>
            <td>
              <xsl:value-of select="./*[local-name() = 'Modalities']"/>
            </td>
          </tr>
          <tr>
            <td>
              <b>Mediatype: </b>
            </td>
            <td>
              <xsl:value-of select="./*[local-name() = 'Mediatype']"/>
            </td>
          </tr>
          <tr>
            <td>
              <b>Speech Corpus: </b>
            </td>
            <td>
              <table border="3" cellpadding="10" cellspacing="10">
                <tr>
                  <td>
                    <b>Duration (effective speech):</b>
                  </td>
                  <td>
                    <xsl:value-of
                      select="./*[local-name() = 'SpeechCorpus']/*[local-name() = 'DurationOfEffectiveSpeech']"
                    />
                  </td>
                </tr>
                <tr>
                  <td>
                    <b>Duration (full database):</b>
                  </td>
                  <td>
                    <xsl:value-of
                      select="./*[local-name() = 'SpeechCorpus']/*[local-name() = 'DurationOfFullDatabase']"
                    />
                  </td>
                </tr>
                <tr>
                  <td>
                    <b>Number of speakers:</b>
                  </td>
                  <td>
                    <xsl:value-of
                      select="./*[local-name() = 'SpeechCorpus']/*[local-name() = 'NumberOfSpeakers']"
                    />
                  </td>
                </tr>
                <tr>
                  <td>
                    <b>Recording Environment:</b>
                  </td>
                  <td>
                    <xsl:value-of
                      select="./*[local-name() = 'SpeechCorpus']/*[local-name() = 'RecordingEnvironment']"
                    />
                  </td>
                </tr>
                <tr>
                  <td>
                    <b>Speaker demographics:</b>
                  </td>
                  <td>
                    <xsl:value-of
                      select="./*[local-name() = 'SpeechCorpus']/*[local-name() = 'SpeakerDemographics']"
                    />
                  </td>
                </tr>
                <tr>
                  <td>
                    <b>Quality:</b>
                  </td>
                  <td>
                    <xsl:value-of
                      select="./*[local-name() = 'SpeechCorpus']/*[local-name() = 'Quality']"/>
                  </td>
                </tr>
                <tr>
                  <td>
                    <b>Recording Platform (hardware):</b>
                  </td>
                  <td>
                    <xsl:value-of
                      select="./*[local-name() = 'SpeechCorpus']/*[local-name() = 'RecordingPlatformHardware']"
                    />
                  </td>
                </tr>
                <tr>
                  <td>
                    <b>Recording Platform (software):</b>
                  </td>
                  <td>
                    <xsl:value-of
                      select="./*[local-name() = 'SpeechCorpus']/*[local-name() = 'RecordingPlatformSoftware']"
                    />
                  </td>
                </tr>
                <tr>
                  <td>
                    <b>Speech-technical metadata:</b>
                  </td>
                  <td>
                    <xsl:value-of
                      select="./*[local-name() = 'SpeechCorpus']/*[local-name() = 'SpeechTechnicalMetadata']"
                    />
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td>
              <b>Multilinguality: </b>
            </td>
            <td>
              <xsl:value-of
                select="./*[local-name() = 'Multilinguality']/*[local-name() = 'Multilinguality']"/>
            </td>
          </tr>
          <tr>
            <td>
              <b>Annotation Type(s): </b>
            </td>
            <td>
              <xsl:value-of select=".//*[local-name() = 'AnnotationType']"/>
            </td>
          </tr>
          <tr>
            <td>
              <b>Subject Language(s): </b>
            </td>
            <td>
              <xsl:value-of select=".//*[local-name() = 'LanguageName']"/>
            </td>
          </tr>
          <tr>
            <td>
              <b>Type-specific Size info: </b>
            </td>
            <td>
              <xsl:value-of
                select="./*[local-name() = 'TypeSpecificSizeInfo']//*[local-name() = 'Size']"/>
            </td>
          </tr>
        </table>
      </p>
    </div>
  </xsl:template>
  <xsl:template match="*[local-name() = 'TextCorpusContext']">
    <div id="tabs-7">
      <p>
        <table>
          <thead>
            <tr>
              <th>
                <h3>Text Corpus</h3>
              </th>
              <th/>
            </tr>
          </thead>
          <tr>
            <td>
              <b>Corpus Type: </b>
            </td>
            <td>
              <xsl:value-of select="./*[local-name() = 'CorpusType']"/>
            </td>
          </tr>
          <tr>
            <td>
              <b>Temporal Classification: </b>
            </td>
            <td>
              <xsl:value-of select="./*[local-name() = 'TemporalClassification']"/>
            </td>
          </tr>
          <tr>
            <td>
              <b>Description(s): </b>
            </td>
            <td>
              <xsl:value-of select=".//*[local-name() = 'Description']"/>
            </td>
          </tr>
          <tr>
            <td>
              <b>Validation: </b>
            </td>
            <td>
              <xsl:value-of
                select="./*[local-name() = 'ValidationGrp']//*[local-name() = 'Description']"/>
            </td>
          </tr>
          <tr>
            <td>
              <b>Subject Language(s): </b>
            </td>
            <td>
              <xsl:value-of
                select="./*[local-name() = 'SubjectLanguages']//*[local-name() = 'LanguageName']"/>
            </td>
          </tr>
          <tr>
            <td>
              <b>Type-specific Size Info: </b>
            </td>
            <td>
              <xsl:value-of
                select="./*[local-name() = 'TypeSpecificSizeInfo']//*[local-name() = 'Size']"/>
            </td>
          </tr>
        </table>
      </p>
    </div>
  </xsl:template>
  <xsl:template match="*[local-name() = 'CourseProfileSpecific']">
    <div id="tabs-7">
      <p>
        <table>
          <thead>
            <tr>
              <th>
                <h3>Course information</h3>
              </th>
              <th/>
            </tr>
          </thead>
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
        </table>
      </p>
    </div>

  </xsl:template>
  <xsl:template match="*[local-name() = 'CourseTargetedAt']">
    <li>
      <xsl:value-of select="."/>
    </li>

  </xsl:template>
 


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

  <xsl:template match="*[local-name() = 'Descriptions']">
    <xsl:for-each select="*[local-name() = 'Description']">
      <xsl:if test="@xml:lang='en'">
	<p><span class="langkeyword">English: </span> <xsl:value-of select="."/> </p>
      </xsl:if>
      <xsl:if test="@xml:lang='de'">
	<p><span class="langkeyword">Deutsch: </span> <xsl:value-of select="."/> </p>
      </xsl:if>	
      
      
    </xsl:for-each>
    <!-- 	<xsl:value-of
	 select="./*[local-name() = 'Descriptions']/*[local-name() = 'Description']"/> -->
  </xsl:template>

  <xsl:template match="*[local-name() ='TypeSpecificSizeInfo']">

    <dl>
      <dt>
	<xsl:variable name="referenceid">
	  <xsl:value-of select="@*[local-name()='ref']"></xsl:value-of>
	</xsl:variable>
	
	<!-- <xsl:value-of select="../../../*:ResourceProxyListInfo/*:ResourceProxyInfo"/> -->
	
	<xsl:value-of select="../../../..//*[local-name() = 'ResourceProxyListInfo']/*[local-name() = 'ResourceProxyInfo'][@*[local-name()='ref']=$referenceid]/*[local-name() = 'ResProxItemName']"/>
	
	<!--	<xsl:value-of select="../../../..//*[local-name() = 'ResourceProxyListInfo']/*[local-name() = 'ResourceProxyInfo'][@ref=$referenceid]/*[local-name() = 'ResProxItemName']"></xsl:value-of>
	-->
      </dt>
      <dd>
	<xsl:for-each select="./*[local-name() = 'TypeSpecificSize']">
	  <li><xsl:value-of select="*[local-name() = 'Size']"/> <xsl:text> </xsl:text><xsl:value-of select="*[local-name() = 'SizeUnit']"/> </li>
	</xsl:for-each>
      </dd>
    </dl>	
  </xsl:template>

  

</xsl:stylesheet>


