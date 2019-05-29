package com.spring.bussiness;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import com.spring.services.inter.Sort;

@Component("BusinessWithQualifierExample")
public class BusinessWithQualifierExample {
    
    
    @Autowired
    @Qualifier("QuicksortwithQualifier")
    Sort sort;

    @Override
    public String toString() {
        return "BusinessWithQualifierExample [sort=" + sort.toString() + "]";
    }
    
    

    
}
