package Frequencyofalohabet;

import java.util.ArrayList;

public class FrequencyofAlphabet {

	String str = "";
	static final int baseindex = 65;
	static ArrayList<Integer> list = new ArrayList<Integer>(100);
	

	public static  ArrayList<Integer> frequencyCount(String str) {
		
     for (int i = 0; i < 100; i++) {
    	 list.add(0);
		
	}
		
		
		char chararr[] = str.toCharArray();
		for (char element : chararr) {
			list.set((element-baseindex),(list.size()>0 ?  ((list.get(element-baseindex)==0? 1: ((int)list.get(element-baseindex))+1)): 1) );
		

		}
		return list;

	}

}
