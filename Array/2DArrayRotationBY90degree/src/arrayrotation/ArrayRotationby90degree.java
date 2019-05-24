package arrayrotation;

public class ArrayRotationby90degree {

	 static  int arr[][] = { { 1, 2, 3}, { 4, 5, 6 }, { 7, 8, 9 } };
	
	
	public static void main(String[] args) {
		
		//System.out.println(arr.length);
		//System.out.println(arr[0].length);
		rotateby90degreewithoutaditionalarray(arr);
		
	for (int i = 0; i < arr.length; i++) {
			
			for (int j = 0; j < arr[i].length; j++) {
  
			
				System.out.println(arr[i][j]+",");
				
				
			}
			System.out.println("\n");
			
		
		}
		
	}


	private static void rotateby90degreewithoutaditionalarray(int arr[][]) {
		 
		
		// i == column for first row 
		for(int i=0; i<arr[0].length-1 ; i++)
		{
			
			int temp;
			int temp1;
			
		/*	temp=arr[i][arr.length-i-1];
			arr[i][arr.length-i-1]=arr[i][i];
			temp = arr[arr.length-i][arr.length-i];
			 arr[arr.length-i][arr.length-i]=temp;
			 temp=arr[arr.length-i][3];*/
			 
	/*		 System.out.println(arr[0][i]+" ");
			 
			 temp1= arr[i][(i+arr.length-1)%arr.length];
			 arr[i][(i+arr.length-1)%arr.length]=arr[0][i];
			 
			 System.out.println(temp1+" ");
			 
			 temp=arr[(i+arr.length-1)%arr.length][(i+2*arr.length-2)%arr.length];
			 arr[(i+2*arr.length-1)%arr.length][(i+2*arr.length-2)%arr.length]=temp1;
			 
			 System.out.println(temp+" ");
			
			 temp1=arr[(i+2*arr.length-1)%arr.length][(i+3*arr.length-3)%arr.length];
			 arr[(i+3*arr.length-3)%arr.length][(i+3*arr.length-3)%arr.length]=temp;
			 
			 System.out.println(temp1+" ");
			 
			 arr[0][i]=temp1;*/
			
			
			
		// System.out.println(arr[0][i]+" ");
			 
			 temp1= arr[i][arr.length-1];
			 arr[i][arr.length-1]=arr[0][i];
			 
			// System.out.println(temp1+" ");
			 
			 temp=arr[arr.length-1][arr.length-1-i];
			 arr[arr.length-1][arr.length-1-i]=temp1;
			 
			// System.out.println(temp+" ");
			
			 temp1=arr[arr.length-1-i][0];
			 arr[arr.length-1-i][0]=temp;
			 
			// System.out.println(temp1+" ");
			 
			 arr[0][i]=temp1;
			 
			
			
		}
		
		
		
		
		
	}

}
