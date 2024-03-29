import java.util.PriorityQueue;

public class Soluation {
	
	/**
	 * Definition for singly-linked list.
	 * public class ListNode {
	 *     int val;
	 *     ListNode next;
	 *     ListNode(int x) { val = x; }
	 * }
	 */
	class Solution {
	    public ListNode mergeKLists(ListNode[] lists) {
	        
	        
	          PriorityQueue<Integer> number = new PriorityQueue<Integer>();
	       
	        
	        for(int i=0; i<lists.length; i++)
	        {
	            ListNode list=lists[i];
	           while(list!=null)
	           {
	               number.add(list.val);
	               list=list.next;
	           }
	            
	            
	        }
	         ListNode head=null;
	         ListNode result=null;
	         ListNode pre=null;
	        
	        
	    if(!number.isEmpty())
	{

	        
	     head = new ListNode(number.remove());
	    result=head;
	               head.next=pre;
	               pre=head;
	    }
	     
	        if(!number.isEmpty()){
	do{
	        head = new ListNode(number.remove());
	      pre.next=head;
	               pre=head;   

	    
	}while (!number.isEmpty());
	        }
	        
	        return result;
	        
	        
	    }
	}

}
