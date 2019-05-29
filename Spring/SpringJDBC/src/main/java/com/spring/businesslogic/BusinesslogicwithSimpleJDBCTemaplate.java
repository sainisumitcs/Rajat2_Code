package com.spring.businesslogic;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import com.spring.dao.with.jdbctemplate.JDBCSimpleJDBCTemplate;
import com.spring.dao.with.jdbctemplate.JDBCTemplateExample;

@Service
public class BusinesslogicwithSimpleJDBCTemaplate {
	
 @Autowired
 JDBCSimpleJDBCTemplate example;
 
 
     public void allCurdOpreation()
     {
    	System.out.println( "BusinesslogicwithSimpleJDBCTemaplate delete="+example.deletePerson());
    	System.out.println( "BusinesslogicwithSimpleJDBCTemaplate  find="+example.findPerson());
    	System.out.println( "BusinesslogicwithSimpleJDBCTemaplate  insert="+example.insertPerson());
     }                                                                           
	
	
	
	
	

}
