package de.tuebingen.uni.sfs.metadtrans;

import net.sf.saxon.xqj.SaxonXQDataSource;
import org.apache.commons.io.FilenameUtils;
import org.w3c.dom.Document;

import javax.ws.rs.core.MediaType;
import javax.xml.namespace.QName;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;
import javax.xml.xquery.XQConnection;
import javax.xml.xquery.XQDataSource;
import javax.xml.xquery.XQPreparedExpression;
import javax.xml.xquery.XQResultSequence;
import java.io.*;
import java.net.URL;
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

	public static File castFile(File dcfile, String converter) throws Exception
	{
		// String converter takes the convertion type as parameter (e.g. "CMDI2HTML"). Case does not matter

		// standard call to xslt
		//System.setProperty("javax.xml.transform.TransformerFactory",
		//		"net.sf.saxon.TransformerFactoryImpl");
		String clean_xsl = "";
		String foo_xsl = "";
		String name = FilenameUtils.removeExtension(dcfile.getName());
		File output = null;

		// XQuery Converter (CMDI2MARC and CMDI2DC)
		if (converter.equalsIgnoreCase("CMDI2Marc") || converter.equalsIgnoreCase("CMDI2DC"))
		{
			XQDataSource ds = new SaxonXQDataSource();
			XQConnection conn = ds.getConnection();


			try (InputStream cmdi2marcStream = getInputStream(converter.toLowerCase() + ".xquery");
				 InputStream cmdiInstanceStream = new FileInputStream(dcfile);
				 InputStream cmdiFileStream = new FileInputStream(dcfile))
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
				System.out.println("CMD Version found -" + CMDIVersionString);

				String schemaLocationString = (String) schemaLocation.evaluate(cmdiFileDocument, XPathConstants.STRING);
				System.out.println("schema location found -" + schemaLocationString + "- in cmdi instance " + dcfile.getName());

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
					output = new File(dcfile.getParent(), name + ".marc.xml");
				} else
				{
					output = new File(dcfile.getParent(), name + ".dc.xml");
				}
				System.out.println("TT");

				BufferedOutputStream outputStream = new BufferedOutputStream(new FileOutputStream(output));
				result.writeSequence(outputStream, props);
				return output;
			}
		}
		// XSL Converter (CMDi2HTMl, NaLiDa2Marc, Marc2RDFDC, Marc2EAD, DC2Marc)
		else
		{
			if (converter.equalsIgnoreCase("CMDI2HTML"))
			{
				clean_xsl = "CMDI2CMDI.xsl";
				foo_xsl = "CMDI2HTML.xsl";

				InputStream clean_xsl_stream = getInputStream(clean_xsl);
				File intermediate = new File(dcfile.getParent(), name + ".clean.xml");

				BufferedOutputStream intermediateStream = new BufferedOutputStream(new FileOutputStream(intermediate));
				TransformerFactory tfactoryClean = TransformerFactory.newInstance();
				Transformer transformerClean = tfactoryClean.newTransformer(new StreamSource(clean_xsl_stream));
				transformerClean.transform(new StreamSource(dcfile),
						new StreamResult(intermediateStream));
				dcfile = intermediate;
				output = new File(dcfile.getParent(), name + ".html");

			} else if (converter.equalsIgnoreCase("NaLiDa2Marc"))
			{
				clean_xsl = "CMDI2CMDI.xsl";
				foo_xsl = "NaLiDa2MARC21_v1.2.xsl";
				output = new File(dcfile.getParent(), name + ".marc21.xml");

				InputStream clean_xsl_stream = getInputStream(clean_xsl);
				File intermediate = new File(dcfile.getParent(), name + ".clean.xml");

				BufferedOutputStream intermediateStream = new BufferedOutputStream(new FileOutputStream(intermediate));
				TransformerFactory tfactoryClean = TransformerFactory.newInstance();
				Transformer transformerClean = tfactoryClean.newTransformer(new StreamSource(clean_xsl_stream));
				transformerClean.transform(new StreamSource(dcfile),
						new StreamResult(intermediateStream));
				dcfile = intermediate;


			} else if (converter.equalsIgnoreCase("Marc2RDFDC"))
			{
				foo_xsl = "MARC21slim2RDFDC.xsl";
				output = new File(dcfile.getParent(), name + ".rdfdc.xml");
			} else if (converter.equalsIgnoreCase("Marc2MODS"))
			{
				foo_xsl = "MARC21slim2MODS3-6.xsl";
				output = new File(dcfile.getParent(), name + ".mods.xml");
			} else if (converter.equalsIgnoreCase("Marc2EAD"))
			{
				foo_xsl = "MARC21slim2EAD.xsl";
				output = new File(dcfile.getParent(), name + ".ead.xml");
			} else if (converter.equalsIgnoreCase("DC2Marc"))
			{
				foo_xsl = "DC2MARC21slim.xsl";
				output = new File(dcfile.getParent(), name + ".marc21.xml");
			}

			InputStream foo_xsl_stream = getInputStream(foo_xsl);

			BufferedOutputStream outputStream = new BufferedOutputStream(new FileOutputStream(output));
			TransformerFactory tfactory = TransformerFactory.newInstance();
			StreamSource xslSource = new StreamSource(foo_xsl_stream);
			System.out.println("Set StreamSource");
			tfactory.setURIResolver(new ClasspathResourceURIResolver());
			System.out.println("Set ClasspathResourceUIRResolver");
			Templates cachedXSLT = tfactory.newTemplates(xslSource);
			Transformer transformer = cachedXSLT.newTransformer(); // new File(foo_xsl)
			transformer.transform(new StreamSource(dcfile),
					new StreamResult(outputStream));
		}
		return output;
	}
}

	class ClasspathResourceURIResolver implements URIResolver
	{
		@Override
		public Source resolve(String href, String base) throws TransformerException {
			return new StreamSource(this.getClass().getClassLoader().getResourceAsStream(href));
		}
	}
