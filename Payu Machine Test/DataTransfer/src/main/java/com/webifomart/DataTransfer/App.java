package com.webifomart.DataTransfer;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Scanner;
import java.util.regex.Pattern;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 * Hello world!
 *
 */
public class App 
{
	public static String columnDetails;
	public static String file1;
	public static String file2;
	
	public static String  fileformate;
	
	public static ArrayList<String> firstfilecolumnlist = new ArrayList<String>();
	
	public static ArrayList<String> secoundfilecolumnlist = new ArrayList<String>();
	
    public static void main( String[] args )
    {
    	App  app=new App();
    	app.informationGathering();
    	
    }
 
    public void cacheforcolumn()  {
    	
    	try{
    	File firstfile=new File(file1);

    	FileInputStream    fistfileinputstream =new FileInputStream(firstfile) ;
    	
    	
    	XSSFWorkbook myWorkBook = new XSSFWorkbook (fistfileinputstream); 
    	
    	int column=myWorkBook.getSheetAt(0).getRow(0).getLastCellNum();
    	
    	for (int i = 0; i <= column; i++) {
		firstfilecolumnlist.add(myWorkBook.getSheetAt(0).getRow(0).getCell(i).toString());	
		}
    	
    	File secoundfile=new File(file2);

    	FileInputStream    secoundfileinputstream =new FileInputStream(secoundfile) ;
    	
    	
    	XSSFWorkbook myWorkBook2 = new XSSFWorkbook (secoundfileinputstream); 
    	
    	int secoundfilecolumn=myWorkBook2.getSheetAt(0).getRow(0).getLastCellNum();
    	
    	for (int i = 0; i <= secoundfilecolumn; i++) {
    		secoundfilecolumnlist.add(myWorkBook.getSheetAt(0).getRow(0).getCell(i).toString());	
		}
    	
    	
    	XSSFSheet mySheet = myWorkBook.getSheetAt(0);
    	
    	Iterator<Row> rowIterator = mySheet.iterator();
    	
    
    	
    	
    	
    	
    	}catch(FileNotFoundException fileNotFoundException)
    	{
    		System.out.println("file not found ");
    	}catch (IOException e) {
    		System.out.println("IOException occure");
		}
    	
    	
    	
    	
    }
    
	
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    public void informationGathering() {
		
		Pattern pattern= Pattern.compile("\\\"");

		Pattern pattern1= Pattern.compile("\"\"");
		
		Scanner input = new Scanner(System.in);
		
		System.out.println("please tells column of CVS file, which must be  in below formate");

		System.out.println("EXAMPLE :-  1,2,3");

		columnDetails = input.next();
		
		System.out.println("upload first file ");
	
		file1=input.next();
		
		file1=file1.replaceAll("\\\\", "//");;
		
		System.out.println("file1 input "+ file1);
				
		//System.out.println("upload secound  file ");
		
		file2=input.next();
		
		file2=file2.replaceAll("\\\\", "//");
		
		//System.out.println("file2 input "+file2);
		
		
		System.out.println("please enter formate ");
		
		
		fileformate=input.next();
		
		
		

	}
    
    
    
    
}
