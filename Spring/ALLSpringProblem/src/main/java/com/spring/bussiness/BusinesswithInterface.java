package com.spring.bussiness;

import com.spring.services.inter.Sort;

import com.spring.services.inter.Sort;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("BusinesswithInterface")
public class BusinesswithInterface {

    @Autowired
    Sort sort;

    public String toString() {
        
        return  "BusinesswithInterface [sort=" + sort.toString() + "]";
    }

}
