package reverse;

public class Reverse {
	
	
	public static  String  reverse(String str)
	{
		int i;
		char   chararr[]=str.toCharArray();
		char   newchar[]=new char[str.length()];
		i=str.length();
		
		for (int j = 0; j < ((chararr.length)%2==0? (chararr.length)/2 : (chararr.length)/2+1); j++) {
			
	      /* newchar[j]=chararr[chararr.length-1-j];
	       newchar[chararr.length-1-j]=chararr[j];*/
			char temp=chararr[chararr.length-1-j];
			chararr[chararr.length-1-j]=chararr[j];
			chararr[j]=temp;
			
			
	
			
		}
	
		return new String(chararr);
		
		
		
	}
	
	

}
