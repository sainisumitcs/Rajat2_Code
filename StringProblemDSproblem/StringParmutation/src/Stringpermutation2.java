import java.util.concurrent.CopyOnWriteArrayList;

public class Stringpermutation2 {

	static int count;

	static String input = "ABCDEF";

	public static CopyOnWriteArrayList<String> listprocess = new CopyOnWriteArrayList<String>();

	public static void main(String[] args) {

		char inputarr[] = input.toCharArray();

		String stringarr[] = new String[inputarr.length];

		for (int i = 0; i < inputarr.length; i++) {

			stringarr[i] = new Character(inputarr[i]).toString();

		}

		/*for (int i = 0; i < stringarr.length - 1; i++) {*/

			for (int j = 0; j < stringarr.length; j++) {

				genratepermutation(stringarr[j]);

			}/*

			String temp = stringarr[0];
			int j;

			for (j = 0; j < stringarr.length - 1; j++) {
				stringarr[j] = stringarr[j + 1];
			}

			stringarr[j] = temp;

		}*/

		int i = 0;

		for (String result : listprocess) {

			System.out.println("\n" + "Element " + (++i) + ": " + result);

		}

	}

	public static void genratepermutation(String element) {
		if (listprocess.size() == 0) {
			listprocess.add(element);
			return;

		}

		int count = listprocess.size();

		for (int i = 0; i < count; i++) {

			String temp = listprocess.get(0);
           
			listprocess.remove(temp);
			temp = temp + element;

			char stringarr[] = temp.toCharArray();

			for (int j = 0; j < stringarr.length; j++) {

				char temp1 = stringarr[0];
				int k;
				for ( k= 0; k < stringarr.length - 1; k++) {
					stringarr[k] = stringarr[k + 1];
				}

				stringarr[k] = temp1;

				listprocess.add(new String(stringarr));

			}

		}
	}

}
