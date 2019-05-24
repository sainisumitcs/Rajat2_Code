package createlinklist;

import java.util.Iterator;

public class Linklist<E> implements Iterable<E>, Cloneable {

	Node<E> head;

	public Linklist() {

	}

	public class Node<E> {
		public E id;
		public Node<E> next;

		Node(E value) {
			this.id = value;
			this.next = null;

		}

	}

	public void push(E data) {

		Node<E> node = new Node<E>(data);
		node.next = head;
		head = node;

	}

	public Node<E> gethead() {
		return this.head;

	}

	public void sethead(Node<E> head) {
		this.head = head;

	}

	@Override
	public Iterator<E> iterator() {

		return new Linklistintretor<E>(this);
	}

}
