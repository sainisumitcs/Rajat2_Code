package com.rajat.beans;

public class Employee {
    
    
    private int id;
    private String  name;
    private String  role ;
    private String   phonenumber;
    private String  address;
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getRole() {
        return role;
    }
    public void setRole(String role) {
        this.role = role;
    }
    public String getPhonenumber() {
        return phonenumber;
    }
    public void setPhonenumber(String phonenumber) {
        this.phonenumber = phonenumber;
    }
    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }
    @Override
    public String toString() {
        return "Employee [id=" + id + ", name=" + name + ", role=" + role + ", phonenumber=" + phonenumber
                + ", address=" + address + "]";
    }
    
    
    

}
