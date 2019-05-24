package reverselinklist;

import createlinklist.Linklist;
import createlinklist.Linklist.Node;

public class reversethelinklist {

 static 	Node curr, next, pre = null;

	public static void main(String[] args) {

		Linklist<Integer> list = new Linklist<Integer>();

		for (int i = 0; i < 15; i++) {
			// list.add(i);
			list.push(i);
		}

		for (Integer value : list) {
			System.out.println(value);
		}
		
		Linklist<Integer> reverselinkedlist	=reverseLinkedlist(list);
		
		

		for (Integer value : reverselinkedlist) {
			System.out.println("value"+value);
		}
		
		
		
	}

	public static Linklist<Integer> reverseLinkedlist(Linklist<Integer> list) {

		Node node = list.gethead();
		pre=node;
		curr=pre.next;
		next=curr.next;
		
		while (next!= null) {
			
			curr.next=pre;
			pre=curr;
			curr=next;
			next=next.next;
			

		}
		curr.next=pre;
		
		node.next=null;
		list.sethead(curr);
		return list;

		

	}
	

}
