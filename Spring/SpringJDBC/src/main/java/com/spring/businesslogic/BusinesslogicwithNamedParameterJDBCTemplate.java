package com.spring.businesslogic;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import com.spring.dao.with.jdbctemplate.JDBCNamedparameterexample;

@Service
public class BusinesslogicwithNamedParameterJDBCTemplate {
	
@Autowired
JDBCNamedparameterexample namedParameterJdbcTemplate;
	
	
	 public void allCurdOpreation()
     {
	   System.out.println( "BusinesslogicwithNamedParameterJDBCTemplate delete="+namedParameterJdbcTemplate.deletePerson());
	   System.out.println( "BusinesslogicwithNamedParameterJDBCTemplate  find="+namedParameterJdbcTemplate.findPerson());
	   System.out.println( "BusinesslogicwithNamedParameterJDBCTemplate  insert="+namedParameterJdbcTemplate.insertPerson());
     }
	
	

}
