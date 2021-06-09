package de.tuebingen.uni.sfs.metadtrans;

import java.io.*;
import java.net.URL;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.StreamingOutput;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xquery.XQException;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.w3c.dom.Document;

/**
 *
 * @author edima
 */
@Produces(MediaType.APPLICATION_JSON)
@Path("/")
public class Service {

	@Context
	HttpServletRequest request;
	@Context
	HttpServletResponse response;

	@GET
	@Path("multi/{sessiondir}/{id}")
	@Consumes(MediaType.MULTIPART_FORM_DATA)
	public Response getFile(@PathParam("sessiondir") String sessiondir, @PathParam("id") String id) throws IOException {
		final File dir = SessionTmpDir.getSessionDir(request.getSession()).getParentFile();
		final File f = new File(dir, sessiondir + File.separator + id);
		if (!f.exists()) {
//			System.out.println("file not found: " + f.getAbsolutePath());
			return Response.status(404).entity("File not found: " + id).build();
		}
		StreamingOutput stream = new StreamingOutput() {
			@Override
			public void write(OutputStream output) throws IOException, WebApplicationException {
				Files.copy(f.toPath(), output);
			}
		};
		return Response.ok(stream, "text/html").build();
		// return Response.ok(stream, "text/xml")
		// 		.header("content-disposition", "attachment; filename=" + f.getName())
		// 		.build();
	}

	public static class FileEntry {

		public final String name;
		public final File file;

		public FileEntry(String name, File file) {
			this.name = name;
			this.file = file;
		}
	}

	public static List<FileEntry> extractFiles(HttpServletRequest request) throws Exception {
		System.out.println("ITEM1" + request.getParameter("url"));
		List<FileEntry> files = new ArrayList<>();
		System.out.println("ITEM1");
		if (ServletFileUpload.isMultipartContent(request)) {
			System.out.println("ITEM2");
			FileItemFactory factory = new DiskFileItemFactory();
			ServletFileUpload upload = new ServletFileUpload(factory);
			for (Object item : upload.parseRequest(request)) {
				System.out.println("OBject item" + item);
				if (item instanceof FileItem) {
					FileItem fi = (FileItem) item;
					System.out.println("ITEM");
					System.out.println(request.getSession() + ":" + fi);
					if (!fi.isFormField()) { // it's a file
						System.out.println(request.getSession() + ":" + fi.getName());
						File f = SessionTmpDir.newNamedFile(request.getSession(), fi.getName());
						fi.write(f);
						files.add(new FileEntry(fi.getName(), f));
					}else{
						if(fi.getFieldName().equals("url"))
						{
							System.out.println(fi.getString());
							DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
							DocumentBuilder docBuilder = dbf.newDocumentBuilder();

							URL url = new URL(fi.getString());
							File f = SessionTmpDir.newNamedFile(request.getSession(), "download_file");
							InputStream inputStream = url.openStream();
							try(OutputStream outputStream = new FileOutputStream(f)){
								IOUtils.copy(inputStream, outputStream);
							} catch (FileNotFoundException e) {
								// handle exception here
							} catch (IOException e) {
								// handle exception here
							}
							files.add(new FileEntry("download_file", f));
						}
					}
				}
			}
		}
		return files;
	}

	@POST
	@Path("multi/{converter}")
	@Consumes(MediaType.MULTIPART_FORM_DATA)
	@Produces(MediaType.APPLICATION_JSON)
	public Response postMulti(@PathParam("converter") String converter) throws IOException {
		try {
			if (!ServletFileUpload.isMultipartContent(request)) {
				return Response.status(400).entity("Multipart content expected, and this is not").build();
			}
			System.out.println("PARAMS" + request.getParameter("url"));
			List<FileEntry> files = extractFiles(request);
			Map<String, String> results = new HashMap<>();
			if (files.isEmpty()) {
				return Response.status(400).entity("No file!").build();
			}
			String sessiondir = SessionTmpDir.getSessionDir(request.getSession()).getName();
			for (FileEntry fileEntry : files) {
//				File result = fileEntry.file;
				File result = CMDICast.castFile(fileEntry.file, converter);
				results.put(result.getName(), "rest/multi/" + sessiondir + "/" + result.getName());
			}
			return Response.ok().entity(results).build();
		} catch (FileNotFoundException xc) {
			return Response.status(404).entity(xc.toString()).build();
		} catch (XQException xc) {
			return Response.status(400).entity(xc.toString()).build();
		} catch (Exception xc) {
			return Response.status(500).entity(xc.toString()).build();
		}
	}

	@POST
	@Path("/{converter}")
	public Response postDirect(InputStream is, @PathParam("converter") String converter) throws IOException, Exception {
		System.out.println(converter);
		File fmeta = File.createTempFile("cmdi2html-", ".xml");
		fmeta.delete(); // needed by Files.copy
		Files.copy(is, fmeta.toPath());
		final File fdc = CMDICast.castFile(fmeta, converter);
		StreamingOutput stream = new StreamingOutput() {
			@Override
			public void write(OutputStream output) throws IOException, WebApplicationException {
				Files.copy(fdc.toPath(), output);
			}
		};
		return Response.ok(stream, "text/html").build();
	}
}