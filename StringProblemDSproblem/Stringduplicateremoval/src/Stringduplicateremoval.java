
public class Stringduplicateremoval {

	public static void main(String[] args) {

		String input = "fdghhhgfhhhhhdshhhhhhh";

		char inputCharArray[] = input.toCharArray();

		for (int i = 1; i < inputCharArray.length; i++) {

			int result = compare(inputCharArray[i-1], inputCharArray[i]);
			if (result == 0) {
				inputCharArray[i] = '@';
				continue;
			} else {

				for (int j = i-1; j >= 0; j--) {

					result = compare(inputCharArray[i], inputCharArray[j]);
					if (result == 0){
						inputCharArray[i] = '@';
						break;
					}
				}
			}

		}
		
		
		
	
		
		System.out.println(new String(inputCharArray));
		
		
		System.out.println(new String(inputCharArray,0,6));

	}

	public static int compare(char input_1, char input_2) {
		if (input_1>input_2)
			return 1;
		else if (input_1 < input_2)
			return -1;
		else
			return 0;

	}

}
