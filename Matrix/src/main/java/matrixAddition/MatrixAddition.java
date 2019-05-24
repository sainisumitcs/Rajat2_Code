package matrixAddition;

public class MatrixAddition {

	public static void addition(int arr1[][], int arr2[][], int result[][]) {
		for (int i = 0; i < arr1.length; i++) {

			for (int j = 0; j < arr1[i].length; j++) {

				result[i][j] = arr1[i][j] + arr2[i][j];

			}

		}

	}

}
