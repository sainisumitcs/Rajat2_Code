package MainClass;

import java.util.ArrayDeque;
import java.util.Queue;

import Acyclicgraph.Graph;
import DFS.DFS;

public class MainClass {

	public static void main(String[] args) throws Exception {

		Queue<Integer> queue = new ArrayDeque<Integer>();
		for (int i = 0; i < 4; i++) {
			queue.add(i);

		}

		Graph graph = new Graph(4);

		graph.addEageDetails(0, 1);
		graph.addEageDetails(0, 2);
		graph.addEageDetails(1, 2);
		graph.addEageDetails(2, 0);
		graph.addEageDetails(2, 3);
		graph.addEageDetails(3, 3);

		System.out.println("Following is a DFS " + "of the given graph");

		DFS.DFS(graph, queue, 2);

	}

}
