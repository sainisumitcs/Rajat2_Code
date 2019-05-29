package com.spring.bussiness;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.spring.services.inter.Sort;


@Component("BusinesswithAutowireWithNmae")
public class BusinesswithAutowireWithNmae { 
    
   // primary will override the name and  Qualifier
    @Autowired(required=false)
    Sort QuicksortwithQualifier;
    
    
    public  String toString() {
     
         return "BusinesswithAutowireWithNmae [sort=" + QuicksortwithQualifier.toString() + "]";
       }

}
