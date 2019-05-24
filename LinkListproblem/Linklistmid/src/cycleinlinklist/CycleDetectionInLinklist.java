package cycleinlinklist;

import createlinklist.Linklist;
import createlinklist.Linklist.Node;

public class CycleDetectionInLinklist {
	static Node mettingpoint = null;

	public static void main(String[] args) {

		Linklist<Integer> list = new Linklist<Integer>();

		for (int i = 0; i < 15; i++) {
			// list.add(i);
			list.push(i);

		}

		Node node = null;
		node = list.gethead().next;

		while (node.next != null) {
			node = node.next;

		}

		node.next = list.gethead().next.next.next;

		if (isCycle(list)) {
			findConnectedpoint(list);
		}
		if (!isCycle(list)) {
			System.out.println("cycle not found ");
		}

	}

	private static void findConnectedpoint(Linklist<Integer> list) {

		Node slow, fast = null;
		slow = list.gethead();

		Outer: while (slow.next != null) {
			fast = mettingpoint;
			while (fast.next != mettingpoint) {
				fast = fast.next;
				if (slow.next == fast.next) {
					System.out.println("first node =" + slow.next.id);
					fast.next = null;
					break Outer;
				}
			}
			slow = slow.next;

		}

	}

	public static boolean isCycle(Linklist<Integer> list) {
		Node fast, slow;
		fast = list.gethead().next.next;
		slow = list.gethead().next;

		boolean iscycle = false;
		while (fast.next != null && fast.next.next != null && slow.next != null) {
			fast = fast.next.next;
			slow = slow.next;
			if (slow == fast) {
				iscycle = true;
				mettingpoint = slow;
				System.out.println("cycle found id =" + slow.id);
				break;

			}

		}

		return iscycle;
	}

}
