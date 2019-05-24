package Acyclicgraph;

import java.util.LinkedList;

public class Graph {

	int noOfVertices;

public 	LinkedList<Integer> adjacencyLinkedList[];

	public Graph(int noOfVertices) {
		this.noOfVertices = noOfVertices;
		adjacencyLinkedList = new LinkedList[this.noOfVertices];
		for (int i = 0; i < noOfVertices; i++) {
			adjacencyLinkedList[i] = new LinkedList<Integer>();

		}

	}

	public void addEageDetails(int vrtx1, int vrtx2) throws Exception {

		try {

			adjacencyLinkedList[vrtx1].add(vrtx2);
		} catch (ArrayIndexOutOfBoundsException e) {

			throw new Exception("This vertices is not define yet");

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}
