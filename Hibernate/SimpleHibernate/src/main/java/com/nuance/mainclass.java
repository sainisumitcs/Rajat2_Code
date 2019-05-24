package com.nuance;

import java.nio.channels.SeekableByteChannel;

import org.hibernate.Session;
import org.hibernate.SessionFactory;

import com.nuance.entity.User;
import com.nuance.hibernateutil.HibernateUtil;

public class mainclass {
	
	
	public static void main(String[] args) {
		
	SessionFactory sessionFactory	=HibernateUtil.getSessionFactory();
	
	User user=new User();
	
	user.setId(12345);
	user.setLocation("NOIDA-132");
	user.setName("kalu");
	user.setPhone(6);
	
	Session session=sessionFactory.openSession();
	session.getTransaction().begin();
	
	session.save(user);
	
	session.getTransaction().commit();
	session.close();
	
	
	
	
	
		
		
		
		
	}

}
