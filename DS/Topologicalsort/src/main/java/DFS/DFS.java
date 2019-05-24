package DFS;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.Queue;

import Acyclicgraph.Graph;

public class DFS {

	static Queue<Integer> remainingvertixset;

	public static void DFS(Graph graph, Queue<Integer> remainingvertixset, int vertices) {
		while (remainingvertixset.size() != 0) {

			LinkedList<Integer> adjacency = graph.adjacencyLinkedList[vertices];
			

			for (Integer integer : adjacency) {

				if (!remainingvertixset.contains(integer))
					continue;
				remainingvertixset.remove(vertices);
				DFS(graph, remainingvertixset, integer);

			}
			System.out.println(vertices);
			remainingvertixset.remove(vertices);
			break;
			

		}

	}

}
