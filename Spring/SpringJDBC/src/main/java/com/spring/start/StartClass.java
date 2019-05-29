package com.spring.start;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.spring.businesslogic.BusinesslogicwithJDBCTemplate;
import com.spring.businesslogic.BusinesslogicwithNamedParameterJDBCTemplate;

public class StartClass {
	
	public static void main(String[] args) {
		
		ApplicationContext  ctx=new  ClassPathXmlApplicationContext("Spring.xml");
		BusinesslogicwithJDBCTemplate businesslogicwithJDBCTemplate=ctx.getBean(BusinesslogicwithJDBCTemplate.class);
		
		   businesslogicwithJDBCTemplate.allCurdOpreation();
		   
		
		   BusinesslogicwithNamedParameterJDBCTemplate businesslogicwithNamedParameterJDBCTemplate=ctx.getBean(BusinesslogicwithNamedParameterJDBCTemplate.class);
		
		   businesslogicwithNamedParameterJDBCTemplate.allCurdOpreation();
		   
		   
		
		
	}
	
	

}
