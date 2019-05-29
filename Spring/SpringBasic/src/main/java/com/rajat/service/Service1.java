package com.rajat.service;



import com.rajat.beans.Employee;
import com.rajat.service.abst.UserOpreation;

import java.util.TreeMap;

import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Service;



@Service(value="Service1")
public class Service1 implements UserOpreation {

    static TreeMap<Integer, Employee> employeelist;
    static {
        employeelist = new TreeMap<Integer, Employee>();
    }

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
    
    public void addEmployee(Employee emp) {
        if (employeelist.containsKey(emp.getId()))
            System.out.println("User already present");
        else {
            employeelist.put(emp.getId(), emp);
            System.out.println("Service1 "+emp.toString());
        }

    }

    public Employee employeeDetails(int id) {
        if (!employeelist.containsKey(id))
            return null;
        else 
        return employeelist.get(id);
    }

    public void deleteUser(int id ) {
        if (!employeelist.containsKey(id))
            System.out.println("Employee not present ");
        else
            employeelist.remove(id);

    }

}
