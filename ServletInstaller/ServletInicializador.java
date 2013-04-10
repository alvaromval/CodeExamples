package mvc.controlador;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;

import common.BlowFish;
import common.Common;

import mvc.modelo.Evento;
import mvc.modelo.UsuarioBean;

public class ServletInicializador extends HttpServlet {
	/*
	 * (non-Javadoc)
	 * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		// Parámetros obtenidos del fichero de despliegue web.xml
		String driver =  this.getServletConfig().getServletContext().getInitParameter("driver"); // Por defecto com.mysql.jdbc.Driver
		String tipoBD = this.getServletConfig().getServletContext().getInitParameter("tipoBD"); // Por defecto mysql
		String prefijoBD = this.getServletConfig().getServletContext().getInitParameter("prefijoBD"); // Por defecto jdbc:mysql://
		
		// Comprobamos si el fichero de configuración ya existe o no
		File configFile = new File(request.getRealPath("") + "/config.xml");
		if(this.getServletContext().getAttribute("INICIADO") == null)
		{
			if(!configFile.exists())
			{
				// Este jsp sirve para inicializar la base de datos
				// Primero cogemos los parámetros necesarios
				String tipodb = request.getParameter("tipodb");
				String database = request.getParameter("database");
				String dbuser = request.getParameter("dbuser");
				String dbpass = request.getParameter("dbpass");
				String superadmin = request.getParameter("superadmin");
				String sapass = request.getParameter("sapass");
				String dburl = request.getParameter("dburl");
				String nombre = request.getParameter("nombre");
				String apellido = request.getParameter("apellido");
				String email = request.getParameter("email");
				String ciudad = request.getParameter("ciudad");
				String pais = request.getParameter("pais");
					
				// Comprobamos que hemos recibido todos los parámetros
				if(database != null && dbuser != null && dbpass != null && superadmin != null
					&& sapass != null && dburl != null)
				{	
					// Ahora intentamos crear la base de datos:		
					Connection connection = null;
					Statement statement = null;
					try
					{
						Class.forName(driver).newInstance();
				    	String url = prefijoBD + dburl + "/" + tipoBD;
				    	System.out.println(url);
						connection = DriverManager.getConnection(url, dbuser, dbpass);
					    statement = connection.createStatement();
						// Creamos la base de datos
					    statement.executeUpdate("CREATE DATABASE " + database + " DEFAULT CHARACTER SET=utf8");
						// La seleccionamos
					    statement.executeUpdate("USE " + database);
						// Creamos la tabla de usuarios
					    System.out.println("Insertando usuarios: " + statement.executeUpdate("CREATE TABLE USUARIOS ("
						    	+ "login VARCHAR(15),"
						    	+ "passHASH VARCHAR(40),"
						    	+ "nombre VARCHAR(20),"
						    	+ "apellido VARCHAR(40),"
						    	+ "email VARCHAR(40),"
						    	+ "ciudad VARCHAR(20),"
						    	+ "pais VARCHAR(15),"
						    	+ "directorio VARCHAR(40),"
						    	+ "tipo INTEGER,"
						    	+ "PRIMARY KEY(login),"
						    	+ "UNIQUE KEY(directorio)) ENGINE=INNODB;"));
						// Creamos la tabla de cursos
					    System.out.println("Insertando cursos: " + statement.executeUpdate("CREATE TABLE CURSOS ("
						    	+ "nombre VARCHAR(10),"
						    	+ "tipo INTEGER,"
						    	+ "directorio VARCHAR(40),"
						    	+ "PRIMARY KEY(nombre, directorio),"
						    	+ "FOREIGN KEY (directorio) References USUARIOS(directorio) ON UPDATE CASCADE ON DELETE CASCADE) ENGINE=INNODB;"));
						// Creamos la tabla de instrumentos para el servicio EvalCOMIX
					    System.out.println("Insertando instrumentos: " + statement.executeUpdate("CREATE TABLE INSTRUMENTS ("
						    	+ "identifier VARCHAR(255),"
						    	+ "title VARCHAR(255),"
						    	+ "description BLOB(500),"
						    	+ "type VARCHAR(50),"
						    	+ "publicIdentifier VARCHAR(255),"
						    	+ "shared INTEGER,"
						    	+ "user VARCHAR(15),"
						    	+ "PRIMARY KEY(identifier),"
						    	//+ "UNIQUE KEY(publicIdentifier),"
						    	+ "FOREIGN KEY (user) References USUARIOS(login) ON UPDATE CASCADE ON DELETE CASCADE) ENGINE=INNODB;"));
						// Creamos la tabla de cursos compartidos
						System.out.println("Insertando cursos compartidos: " + statement.executeUpdate("CREATE TABLE SHAREDCOURSES ("
						    	+ "name VARCHAR(255),"
						    	+ "author VARCHAR(15),"
						    	+ "structure BLOB(65535),"
						    	+ "locked BOOL,"
						    	+ "hour BIGINT,"
						    	+ "currentuser VARCHAR(15),"
						    	+ "repository VARCHAR(50),"
						    	+ "PRIMARY KEY(name, author),"
						    	+ "FOREIGN KEY (author) References USUARIOS(login) ON UPDATE CASCADE ON DELETE CASCADE) ENGINE=INNODB;"));
						// Creamos la tabla de cursos compartidos
						statement.executeUpdate("CREATE TABLE SHAREDCOURSESUSERS ("
						    	+ "name VARCHAR(255),"
						    	+ "author VARCHAR(15),"
						    	+ "user VARCHAR(15),"
						    	+ "PRIMARY KEY(name, author, user),"
						    	+ "FOREIGN KEY(name, author) References SHAREDCOURSES(name, author) ON UPDATE CASCADE ON DELETE CASCADE,"
						    	+ "FOREIGN KEY(user) References USUARIOS(login) ON UPDATE CASCADE ON DELETE CASCADE) ENGINE=INNODB;");
						// Insertamos al superadministrador
						// Pero antes ciframos el password
						sapass = BlowFish.encriptar(sapass, BlowFish.key());
					    statement.executeUpdate("INSERT INTO USUARIOS " + " (login, passHASH, nombre, apellido, email, ciudad, pais, directorio, tipo) VALUES ('" + superadmin + "','" + sapass + "','" + nombre + "','" + apellido + "','" + email + "','" + ciudad + "','" + pais + "','superadmin','" + UsuarioBean.SUPER_ADMIN + "')");
						// Creamos los directorios para el superadministrador
					    File file = new File(request.getRealPath("") + "/usuarios/superadmin/");
						file.mkdir();
						// Creamos el directorio donde se van a guardar los recursos
						file = new File(request.getRealPath("") + "/usuarios/superadmin/recursos");
						file.mkdirs();
						// Creamos el directorio donde se va a escribir el log
						file = new File(request.getRealPath("") + "/usuarios/superadmin/log/");
						file.mkdir();
						// Creamos un directorio temporal
						file = new File(request.getRealPath("") + "/usuarios/superadmin/tmp/");
						file.mkdir();
						// Creamos el directorio de log
						file = new File(request.getRealPath("") + "/log/");
						file.mkdir();
						// Ahora registramos el servidor en el servicio EvalCOMIX
						String identificadorEvalCOMIX = "";
						try
						{
							identificadorEvalCOMIX = Common.registrarServicioEvalComix(this.getServletContext().getInitParameter("URL_evalCOMIX"));
					    	// Como todo ha ido bien creamos el fichero de configuración
							configFile.createNewFile();
							// Ahora lo rellenamos con los valores obtenidos de los parámetros
							PrintWriter pw = new PrintWriter(configFile);
							pw.write("<config>\n" +
									"\t<database>" + database + "</database>\n" + 
									"\t<dbuser>" + dbuser + "</dbuser>\n" + 
									"\t<dbpass>" + dbpass + "</dbpass>\n" + 
									"\t<dburl>" + dburl + "</dburl>\n" +  
									"\t<evalcomix>" + identificadorEvalCOMIX + "</evalcomix>\n" +
									"</config>");
							pw.close();
							// Establecemos los parámetros de inicio en el contexto
							this.getServletContext().setAttribute("basedatos", prefijoBD + dburl + "/" + database);
							this.getServletContext().setAttribute("user", dbuser);
							this.getServletContext().setAttribute("password", dbpass);
							this.getServletContext().setAttribute("evalcomixID", identificadorEvalCOMIX);
				        	this.getServletContext().setAttribute("INICIADO", true);
							// Devolvemos mensaje de éxito
							ServletOutputStream salida = response.getOutputStream();
							Common.escribirSalida(salida, "Inicalizacion completada", "exito");
						}
						catch(IOException e)
						{
							ServletOutputStream salida = response.getOutputStream();
							Common.escribirSalida(salida, "Error en la creación del fichero de configuración: " + e.getMessage(), "error");
						}
						catch(JDOMException e)
						{
							ServletOutputStream salida = response.getOutputStream();
							Common.escribirSalida(salida, "Error en el registro del servicio EvalComix: " + e.getMessage(), "error");
						}
					}
					catch(Exception e) 
					{
						e.printStackTrace();
						ServletOutputStream salida = response.getOutputStream();
						Common.escribirSalida(salida, "Error en la creación de la base de datos: " + e.getMessage(), "error");
				    } 
					finally
					{
				      	if(statement != null) 
				      	{
					        try
					        {
				          		statement.close();
					       	} 
					        catch (SQLException e) 
					        {
					        	e.printStackTrace();
								ServletOutputStream salida = response.getOutputStream();
								Common.escribirSalida(salida, "Error en la conexión con la base de datos: " + e.getMessage(), "error");
					        }
						}
						if (connection != null) 
						{
				        	try 
				        	{
								connection.close();
					        } 
				        	catch (SQLException e) 
				        	{
					        	e.printStackTrace();
								ServletOutputStream salida = response.getOutputStream();
								Common.escribirSalida(salida, "Error en la creación de la base de datos: " + e.getMessage(), "error");
							}
						}
					}
				}
				else
				{
					// Si faltan parámetros devolvemos un error
					ServletOutputStream salida = response.getOutputStream();
					Common.escribirSalida(salida, "Faltan parámetros para la creación de la base de datos", "error");
				}
			}
			else
			{
				try
				{
					// Si el fichero ya existe debemos leerlo y obtener los parámetros de configuración
					SAXBuilder builder=new SAXBuilder(false);
			        Document doc= builder.build(configFile);
			        // Construyo el arbol en memoria desde el fichero
			        Element raiz = doc.getRootElement();
			        // Cojo los parámetros
			        String database = raiz.getChild("database").getValue();
			        String dbuser = raiz.getChild("dbuser").getValue();
			        String dbpass = raiz.getChild("dbpass").getValue();
			        String dburl = raiz.getChild("dburl").getValue();
			        String identificadorEvalCOMIX = raiz.getChild("evalcomix").getValue();
			        System.out.println("Fichero de configuración leído");
			        // Inicializo los valores de configuración en el contexto
			        this.getServletContext().setAttribute("basedatos", prefijoBD + dburl + "/" + database);
					this.getServletContext().setAttribute("user", dbuser);
					this.getServletContext().setAttribute("password", dbpass);
					this.getServletContext().setAttribute("evalcomixID", identificadorEvalCOMIX);
					this.getServletContext().setAttribute("INICIADO", true);
					// Devolvemos mensaje de éxito
					ServletOutputStream salida = response.getOutputStream();
					Common.escribirSalida(salida, "Inicalizacion completada", "error");
		     	}
				catch (Exception e){
		        	e.printStackTrace();
		        	ServletOutputStream salida = response.getOutputStream();
					Common.escribirSalida(salida, "Error en la inicialización: " + e.getMessage(), "error");
		     	}
			}
		}
	}

	public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException 
	{
		this.doPost(req, res);
	}
}
