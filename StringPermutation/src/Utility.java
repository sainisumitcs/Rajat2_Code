import java.util.HashSet;

public class Utility {

	static int i = 0;

	public static void permute(HashSet result, char chararr[], int start, int end) {

		int l=start;
		start++;
		
			result.add(result(chararr));
              
			for (int i = l; i <= end; i++) {
				char temp = chararr[l];
				chararr[l] = chararr[i];
				chararr[i ] = temp;
				permute(result, chararr, start, end);
				
				temp=chararr[i];
				chararr[i]=chararr[l];
			
				chararr[l]=temp;

			}

	}

	public static  String result(char chararr[]) {
		i++;
		System.out.println(i +"="+ new String(chararr) );
		return new String(chararr) ;

	}

}
