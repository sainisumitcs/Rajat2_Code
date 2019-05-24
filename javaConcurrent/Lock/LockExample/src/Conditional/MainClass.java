package Conditional;

import java.util.LinkedList;
import java.util.Queue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import ThreadDefinition.MyThreadFactory;

public class MainClass {

	public static void main(String[] args) {
		Queue<Integer> queue = new LinkedList<Integer>();

		Lock lock = (Lock) new ReentrantLock();
		Condition bufferFull = lock.newCondition();
		Condition bufferEmpty = lock.newCondition();

		Produer produser = new Produer(queue,bufferFull,bufferEmpty,lock);
		Consumer consumer = new Consumer(queue,bufferEmpty,bufferFull,lock);

		ExecutorService produserservice = Executors.newFixedThreadPool(10, new MyThreadFactory("Produser", 5, false));
		produserservice.execute(produser);
		produserservice.execute(produser);
		produserservice.execute(produser);
		produserservice.execute(produser);
		produserservice.execute(produser);
		produserservice.execute(produser);
		produserservice.execute(produser);
		produserservice.execute(produser);

		ExecutorService consumerservice = Executors.newFixedThreadPool(10, new MyThreadFactory("Consumer", 5, false));
		consumerservice.execute(consumer);
		consumerservice.execute(consumer);
		consumerservice.execute(consumer);
		consumerservice.execute(consumer);
		consumerservice.execute(consumer);
		consumerservice.execute(consumer);
		consumerservice.execute(consumer);

	}

}
