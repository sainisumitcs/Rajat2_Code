package ThreadDefinition;

import java.util.concurrent.ThreadFactory;

public class MyThreadFactory implements ThreadFactory {

	String threadname;
	int threadPriority;
	boolean isdemon;
	int  count;

	public MyThreadFactory(String threadname, int threadPriority, boolean isdemon) {
		this.threadname = threadname;
		this.threadPriority = threadPriority;
		this.isdemon = isdemon;

	}
	



	@Override
	public Thread newThread(Runnable r) {
	    Thread thread=new Thread(r);
	    thread.setName(threadname+"-"+String.valueOf(count++));
	    thread.setPriority(threadPriority);
	    thread.setDaemon(isdemon);
	    thread.currentThread().getName();
		return thread;
	}
	
	

}
