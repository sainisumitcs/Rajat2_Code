package com.nuance.hibernateutil;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import com.nuance.entity.User;

public class HibernateUtil {

	private static SessionFactory sessionFactory = getSessionFactory();

	public  static SessionFactory getSessionFactory() {

		try {

			Configuration configuration = new Configuration();
			configuration.addAnnotatedClass(User.class);

			sessionFactory = configuration.buildSessionFactory();

		} catch (Exception e) {
			new RuntimeException("Session factory fail");
		}

	return	sessionFactory;
	}

}
