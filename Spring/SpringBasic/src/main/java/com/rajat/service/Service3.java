package com.rajat.service;

import java.util.TreeMap;

import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;

import com.rajat.beans.Employee;
import com.rajat.service.abst.UserOpreation;


@Service(value="Service3")
@Primary
public class Service3  implements UserOpreation{
    
    static TreeMap<Integer, Employee> employeelist;
    static {
        employeelist = new TreeMap<Integer, Employee>();
    }

    public void addEmployee(Employee emp) {
        if (employeelist.containsKey(emp.getId()))
            System.out.println("User already present");
        else {
            employeelist.put(emp.getId(), emp);
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
