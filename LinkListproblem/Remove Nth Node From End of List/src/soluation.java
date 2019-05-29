
public class soluation {

	public ListNode removeNthFromEnd(ListNode head, int n) {

		ListNode actualnode = head;
		ListNode pre = null;
		ListNode result = head;
		if (head == null) {

		} else {
			for (int i = 0; i < n; i++) {
				head = head.next;
			}
			while (head != null) {
				pre = actualnode;
				actualnode = actualnode.next;
				head = head.next;

			}
			if (pre == null) {
				result = result.next;
			} else {
				pre.next = actualnode.next;
			}

		}
		return result;

	}

}
