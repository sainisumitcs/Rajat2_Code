package findMedianSortedArrays;

public class findMedianSortedArrays {
	
	public static void main(String[] args) {
		
	int nums1[]={1, 3};
	
	int nums2[]={2};
		
	
	System.out.println(findMedianSortedArrays(nums1,  nums2));
		
	}
	
	  public static  double findMedianSortedArrays(int[] nums1, int[] nums2) {
	        
	        
	    int   midean=(nums1.length+nums2.length)/2;
		
		int evenorodd =(midean%2)==0 ? 0: 1;
		
		
		return findMedianSortedArrayUsingRecursive(nums1,nums2,0,nums1.length,0,nums2.length ,midean,evenorodd);
		
	        
	}
	  
	  public static int   findMedianSortedArrayUsingRecursive(int[] nums1, int[] nums2,int start1, int end1,int start2,int end2 ,int midean,int evenorodd)
	    {
	        if(nums1[(start1+end1)/2]<nums2[(start2+end2)/2])
	        {
	        	if(((start1+end1)/2)+((start2+end2)/2)==midean)
	        	{
	        		if(evenorodd==0)
	        		{
	        		  if(nums1[(start1+end1)/2]<nums2[((start2+end2)/2)-1])
	        		  {
	        			 return  (nums2[(start2+end2)/2]+nums2[((start2+end2)/2)-1])/2;
	        		  }else 
	        		  {
	        			  return  (nums2[(start2+end2)/2]+nums1[((start1+end1)/2)])/2;
	        		  }
	        			
	        		}else
	        		{
	        			return nums2[(start2+end2)/2];
	        		}
	        		
	        	}
	        	
	        	
	        }else if (nums1[(start1+end1)/2]>=nums2[(start2+end2)/2])
	        {
	        	if(((start1+end1)/2)+((start2+end2)/2)==midean)
	        	{
	        		if(evenorodd==0)
	        		{
	        		  if(nums1[(start1+end1)/2]<nums2[((start2+end2)/2)-1])
	        		  {
	        			 return  (nums1[(start1+end1)/2]+nums1[((start1+end1)/2)-1])/2;
	        		  }else 
	        		  {
	        			  return  (nums2[(start2+end2)/2]+nums1[((start1+end1)/2)])/2;
	        		  }
	        			
	        		}else
	        		{
	        			return nums1[(start1+end1)/2];
	        		}
	        		
	        	}
	        	
	        }
	        
	        
	        
	       return 0; 
	        
	    }

}
