package matrixMultiplication;

public class matrixMultiplication {

static 	int sum = 0;

	public static  void  matrixMultiplication(int arr1[][], int arr2[][], int result[][])
	{
		
		for (int i = 0; i < arr1.length; i++) {
			
		 
        for (int k = 0; k < arr1.length; k++) {
			
        	  sum=0;
		
			for (int j = 0; j < arr1[i].length; j++) {

				sum=sum+ arr1[i][j] *arr2[j][k];

			}
			result[i][k]=sum;
			
        }
		
		
	}

}
}