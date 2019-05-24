package main;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.function.IntPredicate;
import java.util.stream.IntStream;
import java.util.stream.Stream;

import Frequencyofalohabet.FrequencyofAlphabet;
import Frequencyofalohabet.UsingArray;
import reverse.Reverse;

public class classmain {

	public static void main(String[] args) {

		String str = "ABCDEEEEjfadjkhqedhjashjaayjkashjkdshsfE";

		/*
		 * str=Reverse.reverse(str); System.out.println(str);
		 */

		/*
		 * ArrayList<Integer> list= FrequencyofAlphabet.frequencyCount(str); int
		 * i=64; for(Integer element :list) { i++; if(element==0) continue;
		 * System.out.println((char)i+"--->"+element);
		 * 
		 * 
		 * }
		 */

		UsingArray use = new UsingArray();
		int[] arr = use.frequencyCount(str);

		/*IntStream stream = Arrays.stream(arr);
		IntPredicate i1 = (x) -> x != 0;

		
		// not possible to add aditional symbol
		  stream.filter(i1).forEach(j -> {
			  System.out.println( + "--->" + j);
			  
		  });;*/
		  
		  ; ArrayList<Integer> list= FrequencyofAlphabet.frequencyCount(str);
		 
		int i = 64;
		for (Integer element : arr) {
			i++;
			if (element == 0)
				continue;
			System.out.println((char) i + "--->" + element);

		}
	}

}
