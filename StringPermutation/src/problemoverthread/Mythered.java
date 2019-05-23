package problemoverthread;

import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class Mythered implements Runnable {

	static ArrayBlockingQueue<String> queue;

	public Mythered(ArrayBlockingQueue<String> queue) {
		this.queue = queue;

	}

	@Override
	public void run() {

		

			String reString = queue.poll();
			Utility utility = new Utility();
			utility.permuate(Stringpermutation.hashset, reString.toCharArray(), 0, reString.length()-1);

		

	}

}
