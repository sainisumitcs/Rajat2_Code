import java.util.ArrayList;

import createlinklist.Linklist;
import createlinklist.Linklist.Node;

public class LinklistMidleElement {

	public static void main(String[] args) {

		
		LinklistMidleElement midleelement=new LinklistMidleElement();
		
		Linklist<Integer> list = new Linklist<Integer>();

		for (int i = 0; i < 15; i++) {
			// list.add(i);
			list.push(i);

		}

		
		for (Integer integer : list) {
			System.out.println(integer);

		}
		midleelement.getmidleelement(list);
		
		//ArrayList list1 =new ArrayList<E>();
		
		
		
	}

	public void getmidleelement(Linklist<Integer> list) {
		
		Node midle=list.gethead();
		Node goForword=list.gethead();
	
		do
		{
		
		
		
		if(midle.next==null)
			break;
		else if(midle.next.next==null) 
			break;
		
		
		midle=midle.next.next;
		
		goForword=goForword.next;	
			
			
				
			
			
		}while(true);
		
		
	System.out.println("midle element :-"+goForword.id);
		
		

	}

}
