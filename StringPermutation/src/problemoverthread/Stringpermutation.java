package problemoverthread;

import java.util.Iterator;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

public class Stringpermutation {

	static String input = "ABCDEFGHIJ";

	static ArrayBlockingQueue<String> queue = new ArrayBlockingQueue<String>(10);

	static CopyOnWriteArraySet<String> hashset = new CopyOnWriteArraySet<String>();
	static int count;

	public static void main(String[] args) throws InterruptedException {

		ExecutorService excutor = Executors.newFixedThreadPool(input.length() - 1);

		long start = System.currentTimeMillis();
		Mythered mythered = new Mythered(queue);

		char inputchararr[] = input.toCharArray();
		for (int i = 0; i < input.length(); i++) {

			char temp = inputchararr[0];
			inputchararr[0] = inputchararr[i];
			inputchararr[i] = temp;
			queue.add(new String(inputchararr).substring(1));
			excutor.execute(mythered);

		}
		
		excutor.shutdown();
		excutor.awaitTermination(1, TimeUnit.HOURS); // or longer.    
		long time = System.currentTimeMillis() - start;
		
		

		
		int i = 0;
		for (Iterator iterator = hashset.iterator(); iterator.hasNext();) {
			String string = (String) iterator.next();
			System.out.println("Array list "+(++i )+ "-" + string);
		}
		
		System.out.println(time);
		System.out.printf("Tasks took %.3f ms to run%n", time/1e6);

	}

}
