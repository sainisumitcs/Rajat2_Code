import java.util.HashSet;
import java.util.Iterator;
import java.util.TreeSet;
import java.util.function.Function;

public class main1 {
	
	
	public static void main(String[] args) {
		
	

		StudentDetails std=new StudentDetails(7, 20, 50);
		StudentDetails std1=new StudentDetails(8, 28, 50);
		StudentDetails std2=new StudentDetails(1, 26, 50);
		StudentDetails std3=new StudentDetails(2, 2, 50);
		StudentDetails std4=new StudentDetails(10, 9, 50);
		StudentDetails std5=new StudentDetails(9, 20, 50);
		StudentDetails std6=new StudentDetails(14, 3, 50);
		StudentDetails std7=new StudentDetails(5, 4, 50);
		
		TreeSet<StudentDetails> tee=new TreeSet<StudentDetails>();
		tee.add(std);
		tee.add(std1);
		tee.add(std2);
		tee.add(std3);
		tee.add(std4);
		tee.add(std5);
		tee.add(std6);
		tee.add(std7);
		
	/*Iterator<StudentDetails> itr =tee.iterator();
	while(itr.hasNext())
	{
		System.out.println(itr.next().toString());
	}	*/
		HashSet<StudentDetails> has=new HashSet<StudentDetails>();
		has.add(std);
		has.add(std1);
		has.add(std2);
		has.add(std3);
		has.add(std4);
		has.add(std5);
		has.add(std6);
		has.add(std7);
		
		/*Iterator itrt=has.iterator();
		for (StudentDetails studentDetails : has) {
			System.out.println("Hashset itreate"+studentDetails);
		}
		*/
		
		
		
		TreeSet<StudentDetails> tee1=new TreeSet<StudentDetails>(new ComparatorbyAge());
		
		tee1.add(std);
		tee1.add(std1);
		tee1.add(std2);
		tee1.add(std3);
		tee1.add(std4);
		tee1.add(std5);
		tee1.add(std6);
		tee1.add(std7);
 		
	/*	Iterator<StudentDetails> itr =tee1.iterator();
		while(itr.hasNext())
		{
			System.out.println(itr.next().toString());
		}*/
		 
		
		
		tee.stream().distinct().forEach((s) ->  System.out.print(s+"\n"));

	}

}
