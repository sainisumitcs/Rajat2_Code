import java.util.Comparator;

public class ComparatorbyAge implements Comparator<StudentDetails>{

	@Override
	public int compare(StudentDetails o1, StudentDetails o2) {
		if(o1.getAge()>o2.getAge())
		return 1;
		else if (o1.getAge()== o2.getAge())
			return 0;
			else 
				return -1;
	}

}
