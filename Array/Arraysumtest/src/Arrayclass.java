
public class Arrayclass {
	
	public static void main(String[] args) {
		
		   int result[] =new int[2];
		   
		   int nums[] = {2, 7, 11, 15};
		   result=twoSum(nums,9);
		   for (int i = 0; i < result.length; i++) {
			System.out.println(result[i]);
		}
		   
		   
		   
	}

	public static  int[] twoSum(int[] nums, int target) {
        int sum;
        int result[] =new int[2];
        
       for(int i=0;i<nums.length;i++)
       {
          
           for(int j=++i;j<nums.length;j++ )
           {
               if(target==nums[i]+nums[j])
               {
                   result[0]=i;
                   result[1]=j;
                   return result;
               }
               
                   
           }
           
           
       }
        
        
        
    return result;
    }
    
	
}


