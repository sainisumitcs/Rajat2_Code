package com.spring.services;

import java.util.TreeSet;

import javax.annotation.PreDestroy;

import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;

import com.spring.services.inter.Sort;


@Component("QuIckSortAlgorithm")
@Primary
public class QuIckSortAlgorithmwithPrimary implements Sort {

    
    
    public TreeSet<Integer> sort() {
      System.out.println("Quick sort ");
        return null;
    }

    @Override
    public String toString() {
        return "QuIckSortAlgorithmwithPrimary []";
    }
    
    

}
