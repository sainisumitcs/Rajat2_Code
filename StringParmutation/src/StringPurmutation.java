import java.util.ArrayList;
import java.util.concurrent.CopyOnWriteArrayList;

public class StringPurmutation {

	static int count;

	static String input = "ABCDEF";

	public static CopyOnWriteArrayList<String> listprocess = new CopyOnWriteArrayList<String>();

	public static void main(String[] args) {

		char inputarr[] = input.toCharArray();

		String stringarr[] = new String[inputarr.length];

		for (int i = 0; i < inputarr.length; i++) {

			stringarr[i] = new Character(inputarr[i]).toString();

		}

		for (int i = 0; i < stringarr.length - 1; i++) {

			generatepermutation(stringarr);

			String temp = stringarr[0];
			int j;

			for (j = 0; j < stringarr.length - 1; j++) {
				stringarr[j] = stringarr[j + 1];
			}

			stringarr[j] = temp;

		}

		int i = 0;

		for (String result : listprocess) {

			System.out.println("\n" + "Element " + (++i) + ": " + result);

		}

	}

	public static void generatepermutation(String arr[])

	{

		String temp1 = arr[0] + arr[1];
		String temp2 = arr[1] + arr[0];

		listprocess.add(temp1);
		listprocess.add(temp2);

		for (int i = 2; i < arr.length; i++) {

			generatepermutation1(arr[i]);
		}

	}

	public static void generatepermutation1(String number)

	{
		for (String listprocesselement : listprocess) {
			if (listprocesselement.length() == input.length())
				continue;

			listprocess.remove(listprocesselement);

			listprocess.add(listprocesselement + number);
			listprocess.add(number + listprocesselement);

		}

	}

}
