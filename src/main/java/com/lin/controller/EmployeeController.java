package com.lin.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.lin.bean.Employee;
import com.lin.bean.Msg;
import com.lin.service.EmployeeService;
import com.lin.utils.CommonParam;

@Controller
public class EmployeeController {
	@Autowired
	EmployeeService employeeService ;
	
	@RequestMapping(value="/deleteEmp/{id}",method=RequestMethod.DELETE)
	@ResponseBody
	public Msg deleteEmp(@PathVariable("id")String ids){
		if(!ids.contains("-")){
			employeeService.deleteEmp(Integer.parseInt(ids)) ;
		}else{
			String[] str = ids.split("-") ;
			List<Integer> list = new ArrayList<Integer>() ;
			for(String s : str){
				list.add(Integer.parseInt(s)) ;
			}
			employeeService.deleteEmpAll(list);
		}
		return Msg.success() ;
	}
	
	@RequestMapping(value="/updateEmp/{id}",method=RequestMethod.PUT) //这里请求的的id需要与employee中的id属性名一样
	@ResponseBody
	public Msg updateEmp(Employee employee){
		employeeService.updateEmp(employee) ;
		return Msg.success() ;
	}
	
	@RequestMapping(value="/getEmp/{id}")
	@ResponseBody
	public Msg getEmp(@PathVariable("id")Integer id){
		Employee employee = employeeService.getEmpById(id) ;
		return Msg.success().add("emp",employee) ;
	}
	
	@RequestMapping(value="/checkName")
	@ResponseBody
	public Msg checkName(@RequestParam("name")String name){
		if(employeeService.checkNameIsExists(name)){ //返回true 表示存在
			return Msg.error().add("info","用户名已存在！") ;
		}else{
			return Msg.success().add("info","用户名可用！")  ;
		}
	}
	
	@RequestMapping(value="/emp",method=RequestMethod.POST)
	@ResponseBody
	public Msg saveEmployee(Employee employee){
		employeeService.saveEmp(employee) ;
		return Msg.success() ;
	}
	
	
	/**
	 * 使用 @ResponseBody 注解的前提是导入jackson jar包
	 * @param pageNum
	 * @return
	 */
	@RequestMapping("/emps")
	@ResponseBody //此注解能自动将返回的对象转换为json字符串，并返回
	public Msg getEmpWithJson(@RequestParam(value="pn",defaultValue="1") Integer pageNum){
		//查询之前需要调用，传入页码和每页大小
		PageHelper.startPage(pageNum, CommonParam.PAGE_SIZE) ;
		//startPage方法后面紧跟着的这个查询就是分页查询了
		List<Employee> list = employeeService.selectByExampleWithDep() ;
		//使用PageInfo来封装查询的结果，将pageInfo交给页面就行
		//pageInfo封装了详细的分页信息，包括查询的数据和连续显示的分页数量
		PageInfo pageInfo = new PageInfo(list,CommonParam.PAGE_BUTTON_SIZE) ; //若直接返回pageInfo，则得不到一些错误信息，因此可以写一个通用的bean，将这些信息封装进去
//		return pageInfo ;
		return Msg.success().add("pageInfo", pageInfo) ;
	}
	
	/*@RequestMapping("/emps") 
	public List<Employee> getAll(@RequestParam(value="pn",defaultValue="1") Integer pageNum,Map<String,Object> map){
		//查询之前需要调用，传入页码和每页大小
		PageHelper.startPage(pageNum, CommonParam.PAGE_SIZE) ;
		//startPage方法后面紧跟着的这个查询就是分页查询了
		List<Employee> list = employeeService.selectByExampleWithDep() ;
		//使用PageInfo来封装查询的结果，将pageInfo交给页面就行
		//pageInfo封装了详细的分页信息，包括查询的数据和连续显示的分页数量
		PageInfo pageInfo = new PageInfo(list,CommonParam.PAGE_BUTTON_SIZE) ;
		map.put("pageInfo", pageInfo) ;
		return list ;
	}*/
}
