import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public class Testingforsqllite {
	
	
	public static void main(String[] args) {
		
		try {
			Class.forName("org.sqlite.JDBC");
			String dbURL = "jdbc:sqlite:C://Users//rajat.singh//Desktop//mynewdatabase.db";
			
			Connection conn = DriverManager.getConnection(dbURL);
			if (conn != null) {
			System.out.println("Connected to the database");
				DatabaseMetaData dm = (DatabaseMetaData) conn.getMetaData();
				System.out.println("Driver name: " + dm.getDriverName());
				System.out.println("Driver version: " + dm.getDriverVersion());
				System.out.println("Product name: " + dm.getDatabaseProductName());
				System.out.println("Product version: " + dm.getDatabaseProductVersion());
				conn.close();
				Connection conn2 = DriverManager.getConnection(dbURL);
				Statement smt=conn2.createStatement();
				int  re=smt.executeUpdate("insert into al_pending_subscriber values('rajat1','dohan1','6ohdsn2','mohan1','good bey1')");
				smt.close();
				conn2.close();
				if(re>=0)
					System.out.println("correct");
			
				Connection conn1 = DriverManager.getConnection(dbURL);
				Statement smt1=conn1.createStatement();
				
				ResultSet res=	smt1.executeQuery("select * from al_pending_subscriber");
				while (res.next()) {
					System.out.println(res.getString(1)+",");
					
					
				}
				res.close();
					
				
				smt1.close();
				conn1.close();
				
			
		}
		} catch (ClassNotFoundException ex) {
			ex.printStackTrace();
		} catch (SQLException ex) {
			ex.printStackTrace();
		}		
		
		
	}
	

}
