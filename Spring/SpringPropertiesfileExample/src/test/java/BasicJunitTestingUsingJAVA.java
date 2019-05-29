import static org.junit.Assert.assertEquals;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.spring.configuration.ConfiguationDetails;
import com.spring.readpropertiesfile.ReadFile;

@ContextConfiguration(classes=ConfiguationDetails.class)
@RunWith(SpringJUnit4ClassRunner.class)
public class BasicJunitTestingUsingJAVA {

	
	@Autowired
	ReadFile re;
	
	@Test
	public void testvalue() {

		assertEquals("http://readfileurl.com1", re.getURL());

	}

}
