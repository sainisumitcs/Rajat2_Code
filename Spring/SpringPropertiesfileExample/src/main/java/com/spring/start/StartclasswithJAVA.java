package com.spring.start;

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Configuration;

import com.spring.configuration.ConfiguationDetails;
import com.spring.readpropertiesfile.ReadFile;

public class StartclasswithJAVA {



	public static void main(String[] args) {
		
		ApplicationContext ctx = new AnnotationConfigApplicationContext(ConfiguationDetails.class);
		
		                                         ReadFile re =ctx.getBean(ReadFile.class);
		                                         System.out.println(re.getURL());

	}

}
