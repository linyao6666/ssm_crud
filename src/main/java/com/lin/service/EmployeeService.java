package com.lin.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lin.bean.Employee;
import com.lin.bean.EmployeeExample;
import com.lin.bean.EmployeeExample.Criteria;
import com.lin.dao.EmployeeMapper;

@Service
public class EmployeeService {
	@Autowired
	EmployeeMapper employeeMapper ;

	public List<Employee> selectByExampleWithDep() {
		return employeeMapper.selectByExampleWithDep(null);
	}

	public void saveEmp(Employee employee) {
		employeeMapper.insertSelective(employee) ;
	}

	public boolean checkNameIsExists(String name) {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andNameEqualTo(name);
		long count = employeeMapper.countByExample(example); //大于0，表示存在
		return count != 0; //存在返回true，不存在返回false
	}

	public Employee getEmpById(Integer id) {
		return employeeMapper.selectByPrimaryKey(id);
	}

	public void updateEmp(Employee employee) {
		employeeMapper.updateByPrimaryKeySelective(employee);
	}

	public void deleteEmp(Integer id) {
		employeeMapper.deleteByPrimaryKey(id) ;
	}
	
	public void deleteEmpAll(List<Integer> ids) {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		//delete from xxx where emp_id in(1,2,3)
		criteria.andIdIn(ids);
		employeeMapper.deleteByExample(example);
	}
	
	
}
