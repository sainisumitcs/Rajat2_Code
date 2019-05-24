package createlinklist;

import java.util.Iterator;

import createlinklist.Linklist.Node;

public class Linklistintretor<E> implements Iterator<E> {

	Linklist<E> list;

	Node node = null;

	Node stroreperpose = null;

	Node movingnode = null;

	Linklistintretor(Linklist<E> object) {
		this.list = object;
		stroreperpose = object.gethead();
		movingnode = this.list.gethead();

	}

	@Override
	public boolean hasNext() {

		stroreperpose=movingnode;
		if (movingnode == null)
			return false;

		movingnode = movingnode.next;
		return true;

	}

	@Override
	public E next() {

		return (E) stroreperpose.id;
	}

}
