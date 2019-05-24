package logException;

import java.io.FileNotFoundException;
import java.io.PrintStream;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class logExample {

	private static Logger logger = LogManager.getLogger(logExample.class);

	public static void main(String[] args) throws FileNotFoundException {
		
		try {
			
			m1();
			
		} catch (Exception e) {
		//	logger.error("Error found ",e);
                   PrintStream ps=			new PrintStream("");
			for (int i = 0; i < e.getStackTrace().length; i++) {
				logger.error(e.getStackTrace()[i].toString());
			}
			logger.error(e.getMessage());
			logger.error(e.getLocalizedMessage());
			logger.error(e.fillInStackTrace());
			
		
			
		}
		
	}

	public static void m1() {
		n1();

	}

	private static void n1() {

		throw new NullPointerException();

	}

}
