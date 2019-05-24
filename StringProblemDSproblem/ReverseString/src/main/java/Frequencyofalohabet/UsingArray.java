package Frequencyofalohabet;

import java.util.ArrayList;

public class UsingArray {

	public int[] frequencyCount(String str) {

		 int baseindex = 65;
		 int list[] = new int[60];
		
		char chararr[] = str.toCharArray();
		for (char element : chararr) {
			int temp = list[element - baseindex];
			if (temp == 0)
				list[element - baseindex] = 1;
			else {
				temp++;
				list[element - baseindex] = temp;
			}

		}
		return list;

	}

}
