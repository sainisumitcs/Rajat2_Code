import java.util.Scanner;

public class Stringrotate {
	
	public static void main(String[] args) {
	
		
				     
				   String   input ="i.like.this.program.very.much";
				   String  inputarry[]= input.split("\\.");
				    StringBuffer buffer=new StringBuffer();
				    
				    for(int i=inputarry.length-1;i>=0;i--)
				    {
				        buffer.append("."+inputarry[i]);
				        
				    }
				   String  buffer1=buffer.substring(2);

			     System.out.println(buffer1.toString());	    
				     
	}

}
