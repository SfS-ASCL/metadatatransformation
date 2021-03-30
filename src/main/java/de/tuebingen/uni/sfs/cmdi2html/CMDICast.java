package de.tuebingen.uni.sfs.cmdi2html;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.security.AccessControlException;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xquery.XQConnection;
import javax.xml.xquery.XQDataSource;

import net.sf.saxon.xqj.SaxonXQDataSource;
import org.apache.commons.io.FilenameUtils;

import javax.xml.xpath.*;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;

import org.w3c.dom.Document;


public class CMDICast {

	public static void main(String[] args) throws Exception {
		test();
	}

	public static void test() throws Exception {
		File result = castFile("MellonCMDI.xml");
		System.out.println("first done");
		castFile("MellonCMDI.xml");
		System.out.println("second done");
		castFile("MellonCMDI.xml");
		System.out.println("third done");
	}

	public static File castFile(String cmdifilename) throws Exception {
		return castFile(new File(cmdifilename));
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

	public static File castFile(File cmdifile) throws Exception {
		XQDataSource ds = new SaxonXQDataSource();
		XQConnection conn = ds.getConnection();
		System.out.println("Cmdi2HTML: casting file " + cmdifile.getAbsolutePath());

		try (   InputStream cmdi2htmlstream      = getInputStream("CMDI2HTML.xsl");
			InputStream cmdiInstanceStream = new FileInputStream(cmdifile);
                        InputStream cmdiFileStream     = new FileInputStream(cmdifile) )
                    
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
			System.out.println("schema location found -" + schemaLocationString + "- in cmdi instance " + cmdifile.getName());	

			// superfluous for NaLiDa-based profiles			
                        if (schemaLocationString.endsWith("/xsd")) {
                            schemaLocationString = schemaLocationString.substring(0, schemaLocationString.length() - 4);
                        }

			// In later versions of CMDI 1.2, we may need to update this (or use regular expression).
			String registryPrefix = "";
			if (CMDIVersionString.endsWith("1.2")) {
			    registryPrefix = "http://catalog.clarin.eu/ds/ComponentRegistry/rest/registry/1.x/profiles/";
			} else {
			    // this is for CMDI 1.1 or earlier versions of CMDI (approximately: could match 1.3 or later)
			    registryPrefix = "http://catalog.clarin.eu/ds/ComponentRegistry/rest/registry/profiles/";
			}
			
                        // load the dynamic schema
                        InputStream dynamicSchemaStream = new URL(registryPrefix + schemaLocationString +"/xml").openStream();
                    
			// Apply xsl to transform cmdifile into HTML
			TransformerFactory tFactory = TransformerFactory.newInstance();
			Source xslDoc = new StreamSource(cmdi2htmlstream);
			Source xmlDoc = new StreamSource(cmdifile);

			Transformer trasform = tFactory.newTransformer(xslDoc);
			String name = FilenameUtils.removeExtension(cmdifile.getName());
			File output = new File(cmdifile.getParent(), name + ".html");
			BufferedOutputStream outputStream = new BufferedOutputStream(new FileOutputStream(output));
			trasform.transform(xmlDoc, new StreamResult(outputStream));
			return output;
		}
	}
}
