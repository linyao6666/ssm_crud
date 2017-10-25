package com.lin.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lin.bean.Department;
import com.lin.bean.Msg;
import com.lin.service.DepService;

@Controller
@RequestMapping("/depController")
public class DepController {
	@Autowired
	private DepService depService ;
	
	@ResponseBody
	@RequestMapping("/getDeps")
	public Msg getDeps(){
		List<Department> list = depService.getDeps() ;
		return Msg.success().add("deps", list) ;
	}
}
