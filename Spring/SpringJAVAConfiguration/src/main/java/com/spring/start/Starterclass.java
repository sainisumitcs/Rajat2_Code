package com.spring.start;


import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

import com.spring.beans.Employee;
import com.spring.configurationpak.ConfigurationDetails;

public class Starterclass {
    
 static   ApplicationContext ctx=new AnnotationConfigApplicationContext(ConfigurationDetails.class);
   
   public static void main(String[] args) {
    
      Employee em= ctx.getBean("Employee", Employee.class);
      
      System.out.println(em.toString());
       
       
}
                               
   
   

}
