package main;

import matrixAddition.MatrixAddition;
import matrixMultiplication.matrixMultiplication;

public class Classmain {
	
	public static void main(String[] args) {
		
		int arr1[][]={{1,2,3},{4,5,6},{7,8,9}};
		int arr2[][]={{1,2,3},{4,5,6},{7,8,9}};
		int result[][]=new int[3][3];
		
	//	MatrixAddition.addition(arr1, arr2, result);
		
		matrixMultiplication.matrixMultiplication(arr1, arr2, result);
		
		
		for (int i = 0; i < result.length; i++) {

			for (int j = 0; j < result.length; j++) {

				System.out.println(result[i][j]);

			}
			System.out.println("\n");
			

		}
		
		
		
	}
	
	
	
	

}
