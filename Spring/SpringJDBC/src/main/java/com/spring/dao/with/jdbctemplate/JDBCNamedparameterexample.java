package com.spring.dao.with.jdbctemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.stereotype.Component;

import com.spring.beans.Person;
import com.spring.dao.inter.CurdInterface;


@Component
public class JDBCNamedparameterexample implements CurdInterface {

	@Autowired
	NamedParameterJdbcTemplate namedParameterJdbcTemplate;
	Map<String, Object> map;

	public int insertPerson() {
		Person person = new Person();
		person.setId(23);
		person.setLoaction("Ashok");
		person.setPhone("2323223");
		person.setName("sumit");
		map = new HashMap<String, Object>();
		map.put("id", person.getId());
		map.put("name", person.getName());
		map.put("location", person.getLoaction());
		map.put("phone", person.getPhone());

		return namedParameterJdbcTemplate.update("insert into user  values(:id, :name , :location , phone )", map);
		/*
		 * ("insert into user  values(:id, :name , :location , phone )",
		 * person.getId(), person.getName(), person.getLoaction(),
		 * person.getPhone());
		 */

	}

	public int deletePerson() {
		Person person = new Person();
		person.setId(14);
		person.setLoaction("Ashok");
		person.setPhone("2323223");
		person.setName("sumit");
		map = new HashMap<String, Object>();
		map.put("id", person.getId());
		map.put("name", person.getName());
		map.put("loaction", person.getLoaction());
		map.put("phone", person.getPhone());

  
		return namedParameterJdbcTemplate.update("delete from  user  where id=:id" ,map);

	}

	public Person findPerson() {
		SqlParameterSource sqlParameterSource=new MapSqlParameterSource("id",5);
		return namedParameterJdbcTemplate.queryForObject("Select * from user where id=:id",sqlParameterSource,new RowMapper<Person>()
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
