package com.rajat.service;

import java.util.TreeMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.rajat.beans.Employee;
import com.rajat.service.abst.UserOpreation;

@Service(value="Service2")
public class Service2 implements UserOpreation{

    static TreeMap<Integer, Employee> employeelist;
    static {
        employeelist = new TreeMap<Integer, Employee>();
    }
    
    @Autowired
    UserOpreation userOpreation;

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

    public static TreeMap<Integer, Employee> getEmployeelist() {
        return employeelist;
    }

    public static void setEmployeelist(TreeMap<Integer, Employee> employeelist) {
        Service2.employeelist = employeelist;
    }

    public UserOpreation getUserOpreation() {
        return userOpreation;
    }

    public void setUserOpreation(UserOpreation userOpreation) {
        this.userOpreation = userOpreation;
    }
    
}
