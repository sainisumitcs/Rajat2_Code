package com.spring.dao.with.jdbctemplate;

import java.sql.ResultSet;
import java.sql.SQLException;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;

import com.spring.beans.Person;
import com.spring.dao.inter.CurdInterface;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;


@Component
public class JDBCSimpleJDBCTemplate implements CurdInterface {

	@Autowired
	JdbcTemplate simpleJdbcTemplate;
	
	DataSource datasource;

	public int insertPerson() {
		Person person = new Person();
		person.setId(24);
		person.setLoaction("Ashok");
		person.setPhone("2323223");
		person.setName("sumit");

		return simpleJdbcTemplate.update("insert into user  values(?,?,?,?)", person.getId(), person.getName(),
				person.getLoaction(), person.getPhone());

	}

	public int deletePerson() {

		return simpleJdbcTemplate.update("delete from  user  where id=1");

	}

	public Person findPerson() {
		return simpleJdbcTemplate.queryForObject("Select * from user where id=10", new RowMapper<Person>()
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
