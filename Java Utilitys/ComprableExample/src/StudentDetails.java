
public class StudentDetails implements Comparable<StudentDetails> {

	private int id;
	private int age;
	private int marks;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public int getMarks() {
		return marks;
	}

	public void setMarks(int marks) {
		this.marks = marks;
	}



	@Override
	public int compareTo(StudentDetails o) {
		
		if(o.id>this.id)
			return 1;
		else if (o.id<this.id)
			return -1;
		else
			return 0;
		
		
		
	}

	public StudentDetails(int id, int age, int marks) {
		super();
		this.id = id;
		this.age = age;
		this.marks = marks;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + id;
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		StudentDetails other = (StudentDetails) obj;
		if (id != other.id)
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "StudentDetails [id=" + id + ", age=" + age + ", marks=" + marks + "]";
	}

}
