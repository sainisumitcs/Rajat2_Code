package problemoverthread;

import java.util.HashSet;
import java.util.concurrent.CopyOnWriteArraySet;

public class Utility {

	public void permuate(CopyOnWriteArraySet<String> result, char inputarr[], int start, int end) {
		int l = start;
               start++;
		
			System.out.println(++(Stringpermutation.count) + "-" + new String(inputarr));
			//result.add(new String(inputarr));
		

		for (int i = l; i <= end; i++) {
			char temp = inputarr[l];
			inputarr[l] = inputarr[i];
			inputarr[i] = temp;
			permuate(result, inputarr, start, end);

			temp = inputarr[i];
			inputarr[i] = inputarr[l];

			inputarr[l] = temp;

		}

	}

}
