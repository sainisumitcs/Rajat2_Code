package com.spring.businesslogic;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import com.spring.dao.with.jdbctemplate.JDBCNamedparameterexample;
import com.spring.dao.with.jdbctemplate.JDBCTemplateExample;

@Service
public class BusinesslogicwithJDBCTemplate {
	

	
	@Autowired
	JDBCTemplateExample example;
		
		
		 public void allCurdOpreation()
	     {
	    	System.out.println( "BusinesslogicwithJDBCTemplate delete="+example.deletePerson());
	    	System.out.println( "BusinesslogicwithJDBCTemplate find ="+example.findPerson().toString());
	    	System.out.println( "BusinesslogicwithJDBCTemplate insert ="+example.insertPerson());
	     }
	
	

}
