import static org.junit.Assert.assertEquals;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.spring.readpropertiesfile.ReadFile;


@ContextConfiguration(locations="/applicationxontext.xml")
@RunWith(SpringJUnit4ClassRunner.class)
public class BasicJunitTestWithXML {
	
	
	@Autowired
	ReadFile re;
	
	@Test
	public void testvalue() {
         System.out.println("BasicJunitTestWithXML");
		assertEquals("http://readfileurl.com", re.getURL());

	}


}


