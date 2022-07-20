package de.tuebingen.uni.sfs.metadtrans;

import com.saxonica.xqj.SaxonXQDataSource;
import net.sf.saxon.s9api.*;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import javax.ws.rs.core.MediaType;
import javax.xml.namespace.QName;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.*;
import javax.xml.transform.sax.SAXSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.*;
import javax.xml.xquery.XQConnection;
import javax.xml.xquery.XQDataSource;
import javax.xml.xquery.XQPreparedExpression;
import javax.xml.xquery.XQResultSequence;
import java.io.*;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.AccessControlException;
import java.util.Properties;

public class CMDICast {

	public static void main(String[] args) throws Exception {
		test();
	}

	public static void test() throws Exception {
		File result = castFile("notWorkingCMDI.xml", "CMDI2HTML");
		System.out.println("first done");
		//castFile("annotated_english_gigaword.cmdi", "CMDI2HTMI");
		//System.out.println("second done");
		//castFile("annotated_english_gigaword.cmdi", "CMDI2HTMI");
		//System.out.println("third done");
	}

	public static File castFile(String cmdifilename, String converter) throws Exception {
		return castFile(new File(cmdifilename), converter);
	}

	public static InputStream getInputStream(String filename) {
		try {
			return new FileInputStream(filename);
		} catch (FileNotFoundException | AccessControlException xc) { //ignore
		}
		try {
			return new FileInputStream("src/main/webapp/" + filename);
		} catch (FileNotFoundException | AccessControlException xc) { //ignore
		}

		ClassLoader cl = Thread.currentThread().getContextClassLoader();
		InputStream is = null;
		try {
			is = cl.getResourceAsStream(filename);
		} catch (AccessControlException xc) { //ignore
			xc.printStackTrace();
		}
		return (is != null) ? is : cl.getResourceAsStream("../../" + filename);
	}

	private static File castFileXQuery(File inputFile, String converter, String name, File output) throws Exception {
		XQDataSource ds = new SaxonXQDataSource();
		XQConnection conn = ds.getConnection();
		try (InputStream cmdi2marcStream = getInputStream(converter.toLowerCase() + ".xquery");
			 InputStream cmdiInstanceStream = new FileInputStream(inputFile);
			 InputStream cmdiFileStream = new FileInputStream(inputFile))
		{
			// get the schemaLocation using xpath
			XPathFactory xPathfactory = XPathFactory.newInstance();
			XPath xpath = xPathfactory.newXPath();
			XPathExpression schemaLocation = xpath.compile("string(//*[local-name()=\"MdProfile\"]/text())");

			// In CMDI v1.2 and later, the CMDVersion attribute is obligatory.
			XPathExpression CMDIVersion = xpath.compile("string(/*:CMD/@CMDVersion)");

			// try to parse the cmdifile
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			factory.setNamespaceAware(true);
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document cmdiFileDocument = builder.parse(cmdiFileStream);

			// In CMDI 1.2 and later, this must have a value
			String CMDIVersionString = (String) CMDIVersion.evaluate(cmdiFileDocument, XPathConstants.STRING);
			//System.out.println("CMD Version found -" + CMDIVersionString);

			String schemaLocationString = (String) schemaLocation.evaluate(cmdiFileDocument, XPathConstants.STRING);
			//System.out.println("schema location found -" + schemaLocationString + "- in cmdi instance " + inputFile.getName());

			// superfluous for NaLiDa-based profiles
			if (schemaLocationString.endsWith("/xsd"))
			{
				schemaLocationString = schemaLocationString.substring(0, schemaLocationString.length() - 4);
			}

			// In later versions of CMDI 1.2, we may need to update this (or use regular expression).
			String registryPrefix = "";
			if (CMDIVersionString.endsWith("1.2"))
			{
				registryPrefix = "http://catalog.clarin.eu/ds/ComponentRegistry/rest/registry/1.x/profiles/";
			} else
			{
				// this is for CMDI 1.1 or earlier versions of CMDI (approximately: could match 1.3 or later)
				registryPrefix = "http://catalog.clarin.eu/ds/ComponentRegistry/rest/registry/profiles/";
			}

			// load the dynamic schema
			InputStream dynamicSchemaStream = new URL(registryPrefix + schemaLocationString + "/xml").openStream();

			// now apply the xquery
			XQPreparedExpression expr = conn.prepareExpression(cmdi2marcStream);
			expr.bindDocument(new QName("cmdCCSL"), dynamicSchemaStream, null, null);
			expr.bindDocument(new QName("cmdInstancepath"), cmdiInstanceStream, null, null);
			XQResultSequence result = expr.executeQuery();

			Properties props = new Properties();
			props.setProperty(OutputKeys.METHOD, "xml");
			props.setProperty(OutputKeys.INDENT, "yes");
			props.setProperty(OutputKeys.OMIT_XML_DECLARATION, "no");
			props.setProperty(OutputKeys.STANDALONE, "yes");
			props.setProperty(OutputKeys.MEDIA_TYPE, MediaType.APPLICATION_XML);

			if (converter.equalsIgnoreCase("CMDI2Marc"))
			{
				output = new File(inputFile.getParent(), name + ".marc.xml");
			} else
			{
				output = new File(inputFile.getParent(), name + ".dc.xml");
			}
			//System.out.println("TT");

			BufferedOutputStream outputStream = new BufferedOutputStream(new FileOutputStream(output));
			result.writeSequence(outputStream, props);
			return output;
		}
	}


	private static String[] setConverter(String converter) {
		// returns an array containing the settings for the converter, e.g.
		// which XSLT stylesheet to use, which file ending, and which XSLT
		// transformation output
		String[] result = new String[3];
		if (converter.equalsIgnoreCase("CMDI2HTML")) {
			result[0] = "CMDI2HTML.xsl";
			result[1] = ".html";
			result[2] = "html";
		} else if (converter.equalsIgnoreCase("NaLiDa2MARC")) {
			result[0] = "NaLiDa2MARC21_v1.2.xsl";
			result[1] = ".marc21.xml";
			result[2] = "xml";
		} else if (converter.equalsIgnoreCase("Marc2RDFDC")) {
			result[0] = "MARC21slim2RDFDC.xsl";
			result[1] = ".rdfdc.xml";
			result[2] = "xml";
		} else if (converter.equalsIgnoreCase("Marc2MODS")) {
			result[0] = "MARC21slim2MODS3-6.xsl";
			result[1] = ".mods.xml";
			result[2] = "xml";
		} else if (converter.equalsIgnoreCase("Marc2EAD")) {
			result[0] = "MARC21slim2EAD.xsl";
			result[1] = ".ead.xml";
			result[2] = "xml";
		} else if (converter.equalsIgnoreCase("DC2Marc")) {
			result[0] = "DC2MARC21slim.xsl";
			result[1] = ".marc21.xml";
			result[2] = "xml";
		} else if (converter.equalsIgnoreCase("CMDI2MARC")) {
			result[0] = "DC2MARC21slim.xsl";
			result[1] = ".marc21.xml";
			result[2] = "xml";
		} else if (converter.equalsIgnoreCase("CMDI2JSONLD")) {
			result[0] = "chain_xsl.xsl";
			result[1] = ".jsonld";
			result[2] = "text";
		} else if (converter.equalsIgnoreCase("CMDI-v1.1-to-v.1.2")) {
			result[0] = "cmd-record-1_1-to-1_2.xsl";
			result[1] = ".xml";
			result[2] = "xml";
		}
		return result;
	}

	public static File castFile(File inputFile, String converter) throws Exception {
		String[] converterSetting = setConverter(converter);
		String name = FilenameUtils.removeExtension(inputFile.getName());
		File output = new File(inputFile.getParent(), name + converterSetting[1]);
		Processor processor = new Processor(false);
		// XQuery-based transformation
		// ToDo: Rewrite it to use new Saxon API
		if (converter.equalsIgnoreCase("CMDI2DC") || converter.equalsIgnoreCase("CMDI2MARC")) {
			return castFileXQuery(inputFile, converter, name, output);
		}
		// XSLT-based transformation
		else {
			// Download CMDI profile schema
			if (converter.equalsIgnoreCase("CMDI2JSONLD") || converter.equalsIgnoreCase("CMDI2HTML")) {
				checkCMDIProfile(inputFile.getPath());
			}
			XsltCompiler compiler = processor.newXsltCompiler();
			compiler.setURIResolver(new ClasspathResourceURIResolver());
			//StreamSource source = new StreamSource(CMDICast.class.getClassLoader().getResourceAsStream("chain_xsl.xsl"));
			//source.setSystemId(CMDICast.class.getClassLoader().getResourceAsStream("xsl/"));
			XsltExecutable stylesheet = compiler.compile(new StreamSource(getInputStream(converterSetting[0])));

			Serializer out = processor.newSerializer(output);
			out.setOutputProperty(Serializer.Property.METHOD, converterSetting[2]);
			Xslt30Transformer transformer = stylesheet.load30();
			transformer.transform(new StreamSource(inputFile), out);
		}

		return output;
	}

	// Downloads the corresponding CMDI Profile description, if not downloaded already
	private static void checkCMDIProfile(String xmlFile) throws IOException, SAXException, ParserConfigurationException, XPathExpressionException {
		// extract handle from CMDI
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		DocumentBuilder builder = factory.newDocumentBuilder();
		Document doc = builder.parse(xmlFile);
		XPathFactory xPathfactory = XPathFactory.newInstance();
		XPath xpath = xPathfactory.newXPath();
		XPathExpression expr = xpath.compile("//*[local-name()='MdProfile']");

		String handle = expr.evaluate(doc);
		//File outputFile = File.createTempFile(handle.replaceAll(":", ""), ".xml",
		//		new File("./MetaDataTransformer_CMDI_Profiles/"));
		File outputFile = new File("MetaDataTransformer_CMDI_Profiles/" + handle.replaceAll(":", "") + ".xml");

		// only download Profile, if not downloaded yet
		if (!outputFile.isFile()) {
			String handleURL = "https://catalog.clarin.eu/ds/ComponentRegistry/rest/registry/1.x/profiles/" + handle + "/xml";
			FileUtils.copyURLToFile(new URL(handleURL), outputFile);
		}
	}

	static class ClasspathResourceURIResolver implements URIResolver {
		@Override
		public Source resolve(String href, String base) throws TransformerException {
			return new StreamSource(this.getClass().getClassLoader().getResourceAsStream(href));
		}
	}

}
