package com.spring.dao.with.jdbctemplate;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.spring.beans.Person;
import com.spring.dao.inter.CurdInterface;


@Component
public class JDBCTemplateExample   implements CurdInterface{

	@Autowired
	JdbcTemplate jdbcTemplate;

	public int insertPerson() {
		Person person = new Person();
		person.setId(25);
		person.setLoaction("Ashok");
		person.setPhone("2323223");
		person.setName("sumit");

		return jdbcTemplate.update("insert into user  values(?,?,?,?)", person.getId(), person.getName(),
				person.getLoaction(), person.getPhone());

	}

	public int deletePerson() {

		return jdbcTemplate.update("delete from  user  where id=1");

	}

	public Person findPerson() {
		return jdbcTemplate.queryForObject("Select * from user where id=6", new RowMapper<Person>()
				{

					public Person mapRow(ResultSet rs, int rowNum) throws SQLException {
						Person person=new Person();
						while(rs.next())
						{
							person.setId(rs.getInt(1));
							person.setName(rs.getNString(2));
							person.setLoaction(rs.getNString(3));
							person.setPhone(rs.getNString(4));
						}
						return person;
					}
			
				});

	}

}
