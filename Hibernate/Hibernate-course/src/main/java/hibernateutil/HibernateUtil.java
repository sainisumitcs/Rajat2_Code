package hibernateutil;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.*;
import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;

import beans.Address;
import beans.Bank;
import beans.User;

public class HibernateUtil {

	final static Logger logger = LogManager.getLogger(HibernateUtil.class);

	private static SessionFactory sessionFactory = getSessionFactory();

	@SuppressWarnings("deprecation")
	public static SessionFactory getSessionFactory() {

		try {

			/*
			 * Configuration configuration=new
			 * Configuration().configure("hibernate.cfg.xml");
			 * configuration.addAnnotatedClass(User.class);
			 * //configuration.addAnnotatedClass(Bank.class);
			 * configuration.addAnnotatedClass(Address.class);
			 * 
			 * 
			 * sessionFactory= configuration.buildSessionFactory();
			 */

			Configuration configuration = new Configuration();
			configuration.addAnnotatedClass(User.class);
			configuration.addAnnotatedClass(Address.class);
			sessionFactory = configuration.buildSessionFactory();
			throw new RuntimeException("Session factory fail to create ");

		} catch (Exception e) {

			logger.error("Exception while preparing session Factory ", e);
			return sessionFactory;

		} finally {
			return null;
		}

	}

}
