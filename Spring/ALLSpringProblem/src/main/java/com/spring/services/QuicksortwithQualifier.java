package com.spring.services;

import java.util.TreeSet;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import com.spring.services.inter.Sort;


@Component
@Qualifier("QuicksortwithQualifier")
public class QuicksortwithQualifier  implements  Sort {
    
    @Autowired(required=false)
    public TreeSet<Integer> sort() {
        System.out.println("QuicksortwithQualifier sort");
          return null;
      }

    @Override
    public String toString() {
        return "QuicksortwithQualifier []";
    }
    
    

}
