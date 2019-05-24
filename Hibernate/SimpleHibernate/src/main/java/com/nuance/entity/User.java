package com.nuance.entity;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Generated;
import org.hibernate.annotations.GenerationTime;

@Entity
@Table(name="user")
public class User {
	
			
	@Id
	//@GeneratedValue(strategy=GenerationType.AUTO)		
	@Column(name="id")
	private int id;
	
	@Column(name="name")
	private String name;
	
	@Column(name="location")
	private  String location;
	
	@Column(name="phone")
	private int phone ;

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

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public int getPhone() {
		return phone;
	}

	public void setPhone(int phone) {
		this.phone = phone;
	}
	

}
