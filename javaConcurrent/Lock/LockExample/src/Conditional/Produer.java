package Conditional;

import java.util.LinkedList;
import java.util.Queue;
import java.util.Random;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

public class Produer implements Runnable {

	public LinkedList<Integer> queue;
	Condition bufferFull;
	Condition bufferEmpty;
	ReentrantLock lock;
	

	public Produer(Queue queue ,Condition bufferFull,Condition bufferEmpty,Lock lock) {

		super();
		this.queue = (LinkedList<Integer>) queue;
		this.bufferFull=bufferFull;
		this.bufferEmpty=bufferEmpty;
		this.lock= (ReentrantLock)lock;
	}


	@Override
	public void run() {
		
		
		lock.lock();
		
      if(queue.size()==10)
      {
    	  try {
			bufferFull.await();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
      }
		Random rand = new Random();
		queue.add(rand.nextInt());
		bufferEmpty.signalAll();
		lock.unlock();
		
		

	}

}
