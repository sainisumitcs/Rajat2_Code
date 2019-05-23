import java.util.concurrent.CopyOnWriteArrayList;

public class Test {
	
	
	public static void main(String[] args) {
		
		CopyOnWriteArrayList<String> ns=new CopyOnWriteArrayList<String>();
		
		ns.add("1");
		
		ns.add("1");
		
	for (String string : ns) {
	System.out.println(string);	
	}
	
	System.out.println("\n"+ns.size());
	}

}
