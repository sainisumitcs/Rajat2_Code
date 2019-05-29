package com.spring.services;

import java.util.TreeSet;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;

import org.springframework.stereotype.Component;

import com.spring.services.inter.Sort;

@Component("BubbleSortAlogorithm")
public class BubbleSortAlogorithm implements Sort {

    @PostConstruct
    public void preconstruct() {
        System.out.println("Pre Construct");
    }

    public TreeSet<Integer> sort() {
        System.out.println("Bubble sort");
        return null;
    }

    @PreDestroy
    public void PreDestroy() {
        System.out.println("PreDestroy");
    }

    @Override
    public String toString() {
        return "BubbleSortAlogorithm []";
    }
    
    
    

}
