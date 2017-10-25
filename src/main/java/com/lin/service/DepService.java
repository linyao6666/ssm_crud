package com.lin.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lin.bean.Department;
import com.lin.dao.DepartmentMapper;

@Service
public class DepService {
	@Autowired
	private DepartmentMapper departmentMapper ;
	
	public List<Department> getDeps(){
		return departmentMapper.selectByExample(null) ;
	}
}
