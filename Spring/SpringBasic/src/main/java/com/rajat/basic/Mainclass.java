package com.rajat.basic;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Service;

import com.rajat.beans.Employee;
import com.rajat.service.Service1;
import com.rajat.service.Service2;
import com.rajat.service.abst.UserOpreation;

public class Mainclass {

    public static void main(String[] args) {

        ClassPathXmlApplicationContext ctx = new ClassPathXmlApplicationContext("spring.xml");

        Employee emp = ctx.getBean("Employee", Employee.class);

        System.out.println(emp.toString());
        
        UserOpreation UserOpreation = ctx.getBean("Service1", UserOpreation.class);
        
         UserOpreation.addEmployee(emp);
         
         Service2  service2= ctx.getBean("Service2", Service2.class);
         
         System.out.println(service2.getUserOpreation().employeeDetails(1).toString());
         
         
       

    }

}
