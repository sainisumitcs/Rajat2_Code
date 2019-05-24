import java.util.ArrayList;
import java.util.function.Consumer;
import java.util.stream.Collectors;

public class stream {

	public static void main(String[] args) {

		ArrayList<String> al = new ArrayList();

		al.add("rajat2");
		al.add("rajat2");
		al.add("rajat2");
		al.add("rajat2");
		al.add("rajat1");
		al.add("rajat1");

		Consumer<String> con = (x) -> {
			x = x + "modify";
			System.out.println(x);

		};

		al.stream().filter(x -> x.equalsIgnoreCase("rajat1")).forEach(x -> con.accept(x));

		al.stream().filter(x -> x.equalsIgnoreCase("rajat1")).map(x -> x + 5).forEach(System.out::printf);

		al = (ArrayList<String>) al.stream().filter(x -> x.equalsIgnoreCase("rajat1")).collect(Collectors.toList());

		for (String str : al) {
			System.out.println(str);
		}

	}

}
