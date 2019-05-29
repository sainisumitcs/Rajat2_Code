package com.rajat.service.abst;

import com.rajat.beans.Employee;

public interface UserOpreation {

    public void addEmployee(Employee emp);

    public Employee employeeDetails(int id);

    public void deleteUser(int id);

}
