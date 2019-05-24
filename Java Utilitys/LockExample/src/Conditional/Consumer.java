package Conditional;

import java.util.LinkedList;
import java.util.Queue;
import java.util.Random;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

public class Consumer implements Runnable{
	
	
	public LinkedList<Integer> queue;
	Condition bufferEmpty;
	Condition bufferFull;
	ReentrantLock lock;	

	
	public Consumer(Queue queue,Condition bufferEmpty,Condition bufferFull,Lock lock) {

		super();
		this.queue = (LinkedList<Integer>) queue;
		this.bufferEmpty=bufferEmpty;
		this.bufferFull=bufferFull;
		this.lock=(ReentrantLock) lock;
	}

	@Override
	public void run() {

		/*while(true)
		{*/
		
		lock.lock();
		if(queue.size()==0)
			try {
				bufferEmpty.await();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		
		System.out.println(Thread.currentThread().getName()+" DATA-"+queue.remove());	
		bufferFull.signalAll();
		lock.unlock();
		}

	//}

}
