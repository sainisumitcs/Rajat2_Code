package main;

import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;

import javax.naming.spi.DirStateFactory.Result;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import utility.Utilty;

public class mainClass {
	
	static ArrayList<String>  allUserDefineTableList=new ArrayList<String>();
	

	public static void main(String[] args) throws SQLException {
		
		
		extractUserDefineTable();
		try {
			writeTableData();
		} catch (IOException e) {
			
			e.printStackTrace();
		}

	}
	
	

	
	
	public static void extractUserDefineTable() throws SQLException {
      int count=0;

		
		Connection conn = Utilty.getConnection();
		String query = "select name from tables where system=false";

		Statement stmt = conn.createStatement();

		ResultSet rest = stmt.executeQuery(query);
		while (rest.next()) {
			count++;
			allUserDefineTableList.add(rest.getString(1));

		}
		System.out.println("Total table count="+count);

	}
	
	public static void   writeTableData() throws IOException
	{
		Process script_exec=null;
		for(String tablename : allUserDefineTableList)
		{
			
			ProcessBuilder pb2=new ProcessBuilder(
				    "/bin/sh",
				    "-c",
				    "/home/loanteam/TESTSETUP/AIRTEL/UFM/Airtel_10.3.117.32/TALK_TIME_TRANSFER/UFM_141/poly9.1/examples/new/tabledatascripts.sh  "+tablename);
			
			try
			{
			 script_exec = pb2.start();
			}catch (Exception e) {
				e.printStackTrace();
			}
			//	System.out.println(script_exec.exitValue());
				
				
		}
		
	}
	
	

}
