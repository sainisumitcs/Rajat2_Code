import java.util.HashSet;
import java.util.Iterator;

public class Stringpermutation {

	public static void main(String[] args) {

		String input = "ABCDEFGHIJ";
    long  starttime=System.currentTimeMillis();
		HashSet<String> hashset = new HashSet<String>();

		char inputchararr[] = input.toCharArray();

		Utility.permute(hashset, inputchararr, 0, inputchararr.length - 1);
		int i = 0;
		for (Iterator iterator = hashset.iterator(); iterator.hasNext();) {
			String string = (String) iterator.next();
			System.out.println(++i + "-" + string);
		}
		
		System.out.println(System.currentTimeMillis()-starttime);
		long time= System.currentTimeMillis()-starttime;
		System.out.printf("Tasks took %.3f ms to run%n", time/1e6);

	}

}
