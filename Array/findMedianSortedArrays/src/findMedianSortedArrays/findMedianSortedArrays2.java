package findMedianSortedArrays;

public class findMedianSortedArrays2 {

	static int count = 0;

	public static void main(String[] args) {

		
	int nums1[] = { 1, 3 };
		
		int nums2[] = { 2 };
		
	
	/*int nums1[] = {  };
		
		int nums2[] = { 2,3 };*/
		
	/*int nums1[] = { 3 };
		
		int nums2[] = { -2,-1 };*/
		
		
/*int nums1[] = {1  };
		
		int nums2[] = { 2,3 };*/
		
/*int nums1[] = {1 ,2 };
		
		int nums2[] = { 3,4 };*/
		

	/*	int nums2[] = { 1, 2 ,200,201,356};

		int nums1[] = { 3};*/
		
		
		/*int nums2[] = {3 };

		int nums1[] = { 1,2,4,5};*/
    System.out.println(  findMedianSortedArrays(nums1, nums2));
		
		//System.out.println(binarySearch(nums2, 0, nums2.length-1, 100));

	}

	public static float   findMedianSortedArrays(int[] nums1, int[] nums2) {
		
		
		int median = (int) Math.ceil((float)((nums1.length + nums2.length-2))/2); 

		int evenorodd = (nums1.length + nums2.length) % 2 == 0 ? 0 : 1;
		
		if((nums1.length<=0) )
		{
			if((nums2.length<=0))
			{
				return -1;
			}else
			{
				if(evenorodd==1)
				return nums2[(0+nums2.length-1)/2];
				else
					return (float)(nums2[(0+nums2.length-1)/2]+nums2[((0+nums2.length-1)/2)+1])/2;
			}
			
		}
		else	if((nums2.length<=0) )
			{
				if((nums1.length<=0))
				{
					return -1;
				}else
				{
					if(evenorodd==1)
					return nums1[(0+nums1.length)/2];
					else
						return (float)(nums1[(0+nums1.length-1)/2]+nums1[((0+nums1.length-1)/2)+1])/2;
				}
				
		}


	return	findthemedianonSortedArray(nums1, nums2, 0, nums1.length-1 , 0, nums2.length-1, median,
				evenorodd);

	}

	public static int findMedianSortedArrayUsingRecursive(int[] nums1, int[] nums2, int start1, int end1, int start2,
			int end2, int median, int evenorodd) {
		int finalanswer = 0;
		if (end1 + end2 == median - 2) {
			if (evenorodd == 0) {

			} else if (nums1[end1] < nums2[end2]) {
				return nums2[end2];
			} else {
				return nums1[end1];
			}
		} else if (nums1[(start1 + end1) / 2] < nums2[(start2 + end2) / 2]) {
			finalanswer = findMedianSortedArrayUsingRecursive(nums1, nums2, (start1 + end2) / 2, end1, start2,
					(start2 + end2) / 2, median, evenorodd);
		} else {
			finalanswer = findMedianSortedArrayUsingRecursive(nums1, nums2, start1, (start1 + end1) / 2,
					(start2 + end2) / 2, end2, median, evenorodd);
		}
		return finalanswer;

	}

	public static  float     findthemedianonSortedArray(int[] nums1, int[] nums2,int start1, int end1,int start2,int end2 ,int median,int evenorodd)
   {
	   
	   int lastindexvalue;
	   
	   
	   if(nums1[(start1+end1)/2]<nums2[(start2+end2)/2])
	        {
		     lastindexvalue=(start2+end2)/2;
		     
		   return   recursion(lastindexvalue,nums1,nums2,median,evenorodd );
       	  
	        }else 
	        {
	        	lastindexvalue=(start1+end1)/2;
	        return 	 recursion(lastindexvalue,nums2,nums1,median,evenorodd );
	        }
	   
   }

	public  static float recursion(int end, int[] smallerarray, int[] greatorarray, int median,int evenorodd) {
		int value = 0;

		value = binarySearch(smallerarray,0,smallerarray.length-1,greatorarray[end]);

		if ((value) + end > median) {
			if(end==0){
				
				if(evenorodd==0)
					return smallerarray[median]+smallerarray[median+1];
				else 
					return smallerarray[median];
					
					
			}
			recursion(end - 1, smallerarray, greatorarray, median,evenorodd);

		} else if ((value) + end < median) {
			value = median - end;
			if(evenorodd==0)
			{
				System.out.println("median " + (float)(smallerarray[value]+greatorarray[end])/2);
				return (float)((smallerarray[value-1]+greatorarray[end])/2);
			}else {
				System.out.println("median " + smallerarray[value-1]);
			
				return  (float) smallerarray[value-1];
			
			}

		} else if ((value) + end == median) {
			if(evenorodd==0)
			{
				System.out.println("median " +(float) (smallerarray[value]+greatorarray[end])/2);
				return (float) (smallerarray[value]+greatorarray[end])/2;
			}else {
			
				if( greatorarray[end]<smallerarray[value-1]){
				System.out.println("median " + greatorarray[end]);
				return (float)greatorarray[end];
				}else 
				{
					System.out.println("median " + smallerarray[value]);
					return (float)smallerarray[value];
				}
			}
			

		}

		return 0;
	}

	 public static  int binarySearch(int arr[], int l, int r, int x) 
	    { 
	        if (r >= l) { 
	        	if(arr.length==1)
	        		return 1;
	        	
	            int mid =(int) Math.ceil((float)(l + r) / 2) ; 
	  
	            if (mid ==l ||(arr[mid]>=x && arr[mid-1]<=x)||(mid==r) ) 
	                return mid; 
	  
	            // If element is smaller than mid, then 
	            // it can only be present in left subarray 
	            if (arr[mid] > x) 
	                return binarySearch(arr, l, mid , x); 
	  
	            // Else the element can only be present 
	            // in right subarray 
	            return binarySearch(arr, mid , r, x); 
	        } 
	  
	        // We reach here when element is not present 
	        // in array 
	        return -1; 
	    } 
}