package com.spring.readpropertiesfile;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;


@Component
public class ReadFile {
	
	@Value(value = "${spring.server.url}")
	private String URL;

	
	

	public String getURL() {
		return URL;
	}

	
	
	public void setURL(String uRL) {
		URL = uRL;
	}
	
	
	 
	
	
	

}
