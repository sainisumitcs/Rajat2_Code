package com.spring.start;

import java.util.Arrays;

import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.spring.bussiness.BusinessWithQualifierExample;
import com.spring.bussiness.BusinesswithAutowireWithNmae;
import com.spring.bussiness.BusinesswithInterface;
import com.spring.services.BubbleSortAlogorithm;
import com.spring.services.QuIckSortAlgorithmwithPrimary;

public class SpringmainwithXMLconfiguration {

    public static void main(String[] args) {

        try (ClassPathXmlApplicationContext ctx = new ClassPathXmlApplicationContext("spring.xml")) {

            QuIckSortAlgorithmwithPrimary quIckSortAlgorithm = (QuIckSortAlgorithmwithPrimary) ctx
                    .getBean("QuIckSortAlgorithm");

            BubbleSortAlogorithm bubbleSortAlogorithm = (BubbleSortAlogorithm) ctx.getBean("BubbleSortAlogorithm");
            
            
            BusinesswithAutowireWithNmae businesswithAutowireWithNmae = (BusinesswithAutowireWithNmae) ctx.getBean("BusinesswithAutowireWithNmae");
            
            BusinessWithQualifierExample businessWithQualifierExample = (BusinessWithQualifierExample) ctx.getBean("BusinessWithQualifierExample");
            BusinesswithInterface businesswithInterface = (BusinesswithInterface) ctx.getBean("BusinesswithInterface");

            System.out.println(businesswithAutowireWithNmae.toString());
            System.out.println(businessWithQualifierExample.toString());
            System.out.println(businesswithInterface.toString());
            
            System.out.println(Arrays.deepToString(ctx.getBeanDefinitionNames()));

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}
