package com.spring.configurationpak;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

import com.spring.beans.Employee;

@Configuration
@ComponentScan(value={"com.spring",""})
public class ConfigurationDetails {
    
    @Bean(name="Employee")
    public Employee getEmployee() {
        Employee employee = new Employee();
        employee.setId(1);
        employee.setName("rajat");
        employee.setAddress("NewDelhi");
        employee.setRole("Engg");
        employee.setPhonenumber("+91");

        return employee;
    }
    
    
    

}
