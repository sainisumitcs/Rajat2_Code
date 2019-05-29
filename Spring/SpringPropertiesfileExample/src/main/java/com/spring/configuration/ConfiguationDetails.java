package com.spring.configuration;

import org.springframework.context.annotation.ComponentScan;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;

@Configuration
@ComponentScan(basePackages={"com.spring",""})
@PropertySource(value={"file:C://Users//rajat.singh//Desktop//folder//Externalfile.properties","classpath:Externalfile.properties"} )
public class ConfiguationDetails {
	
	ConfiguationDetails()
	{
		super();
	}
	
	


}
