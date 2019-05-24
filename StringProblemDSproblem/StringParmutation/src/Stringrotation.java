import java.util.HashSet;
import java.util.Set;

public class Stringrotation {

	
static 	int count = 0;

	
	public static void main(String[] args) {

		String input = new String("123456");
		
		String input1 = new String("123456");
		
		Set permutealphabat=new HashSet<String >();

		
		
		
		char chararr2[]=input1.toCharArray();
		
		
		//permuateString(chararr2, permutealphabat);

		for (int i = 0; i < input.length(); i++) {
			
			//chararr1=chararr2;
			int  k=i;
			
			

			for (int j = i+1; j < input.length() ; j++) {
				
				char chararr1[] = input.toCharArray();
                 
				char temp = chararr1[k];
				chararr1[k] = chararr1[j];
				chararr1[j] = temp;
				
				
				
				
				//permuateString(chararr1, permutealphabat);
				
				System.out.println(++count + "\n :" + new String(chararr1));
				
			//permutealphabat.add( new String(chararr1));
				

			}
			k++;

		}
		
		
		for (Object  permute : permutealphabat) {
			
			System.out.println(++count + "\n :" + permute.toString());
			
		}

	}
	
	public static  void permuateString(char chararr1[],Set permutealphabat)
	{

		for (int j3 = 0; j3 < chararr1.length; j3++) {

			char temp1 = chararr1[0];
			int j2;
			for (j2 = 0; j2 < chararr1.length -1; j2++) {

				chararr1[j2] = chararr1[j2 + 1];
			}

			chararr1[j2] = temp1;

			//System.out.println(++count + "\n :" + new String(chararr1));
			permutealphabat.add( new String(chararr1));
		}
	}

}
