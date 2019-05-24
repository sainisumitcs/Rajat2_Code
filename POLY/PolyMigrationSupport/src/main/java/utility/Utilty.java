package utility;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Utilty {

	

	public static Connection getConnection() {
		Connection connection = null;
		String url = "jdbc:polyhedra://10.200.208.96:6018";

		try {

			String driverName = "com.polyhedra.jdbc.JdbcDriver";
			Class.forName(driverName);

			connection = DriverManager.getConnection(url);

		} catch (ClassNotFoundException | SQLException exp) {

			System.err.println("Exception while makeing new connetion with url :" + url);
			exp.printStackTrace();

		} catch (Exception exp) {
			System.err.println("Exception while makeing new connetion with url :" + url);
			exp.printStackTrace();
		}
		return connection;

	}


}
