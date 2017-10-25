<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	pageContext.setAttribute("path", request.getContextPath()) ;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="${path }/static/js/jquery-3.1.1.min.js"></script>
<script type="text/javascript" src="${path }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
<link href="${path }/static/bootstrap-3.3.7-dist/css/bootstrap.css" rel="stylesheet">
<title>员工信息列表</title>
<script type="text/javascript">
	var totalCount ,currentPage;
	$(function(){
		to_page(1) ;
		
		$("#add_emp_btn").click(function(){
			//初始化下拉框
			initDepSelect("#dep_select") ;
			
			clearInput() ; //显示模态框之前，清除以前的
			
			//显示模态框
			$("#addEmpModal").modal({
				backdrop:"static" //此参数时点击模态框的灰色背景，不关闭模态框
			}) ;
			
		}) ;
		
		$("#name").blur(function(){
			if(!checkName()){
				return false ;
			}
			$.ajax({
				url:"${path }/checkName",
				type:"GET",
				data:"name="+$("#name").val(),
				success:function(result){
					console.log(result) ;
					if(result.code == 100){
						showMsg("#name","success",result.extend.info) ;
					}else{
						showMsg("#name","error",result.extend.info) ;
					}
				}
			}) ;
		}) ;
		
		$("#email").blur(function(){
			if(!checkEmail("#email")){
				return false ;
			}
		}) ;
		
		$("#update_email").blur(function(){
			if(!checkEmail("#update_email")){
				return false ;
			}
		}) ;
		
		$("#update_emp_btn").click(function(){
			var id=$("#update_emp_btn").attr("emp_id") ;
			$.ajax({
				url:"${path }/updateEmp/"+id,
				type:"PUT",
				data:$("#updateEmpModal form").serialize(),
				success:function(result){
					if(result.code == 100){
						$("#updateEmpModal").modal('hide') ; //关闭模态框
						to_page(currentPage) ;
					}
				}
			}) ;
		}) ;
		
		$("#save_emp_btn").click(function(){
			/* var empName = $("#name").val() ;
			var empReg = /^[a-zA-Z0-9_-]{3,16}$/ ;
			if(!empReg.test(empName)){
				showMsg("#name","error","用户名必须为数字，字母，下划线，-组成，长度3~16") ;
				return false ;
			} */
			if(!checkName()){
				return false ;
			}
			if(!checkEmail("#email")){
				return false ;
			}
			
			/* var email = $("#email").val() ;
			var emailReg=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if(!emailReg.test(email)){
				showMsg("#email","error","不合法的邮箱格式！") ;
				return false ;
			} */
			console.log($("#addEmpModal form").serialize()) ;
			
			$.ajax({
				url:"${path }/emp",
				type:"POST",
				data:$("#addEmpModal form").serialize(),
				success:function(result){
					if(result.code == 100){
						$("#addEmpModal").modal('hide') ; //关闭模态框
						//跳转到最后一页 ,如果传入的参数大于总页数，那么也会跳到最后一页
						to_page(totalCount) ;
					}
				}
			}) ;
		}) ;
		
		//关闭模态框
		$("#close_emp_btn").click(function(){
			$("#addEmpModal").modal('hide') ;
		}) ;
		
		//关闭模态框
		$("#update_close_emp_btn").click(function(){
			$("#updateEmpModal").modal('hide') ;
		}) ;
		
		$("#delete_checkbox").click(function(){
			$(".check_item").prop("checked",$(this).prop("checked")) ;
		}) ;
		
		//这里需要用on，因为页面加载的时候，check_item还没有
		$(document).on("click",".check_item",function(){
			var flag = $(".check_item:checked").length == $(".check_item").length ;
			$("#delete_checkbox").prop("checked",flag) ;
		}) ;
	}) ;
	
	function checkEmail(selector){
		var email = $(selector).val() ;
		var emailReg=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
		if(!emailReg.test(email)){
			showMsg(selector,"error","不合法的邮箱格式！") ;
			return false ;
		}else {
			$(selector).next("p").text("") ;
			$(selector).parent().removeClass("has-success has-error") ;
			return true ;
		}
	}
	
	function checkName(){
		var empName = $("#name").val() ;
		var empReg = /^[a-zA-Z0-9_-]{3,16}$/ ;
		if(!empReg.test(empName)){
			showMsg("#name","error","用户名必须为数字，字母，下划线，-组成，长度3~16") ;
			return false ;
		}else{
			return true ;
		}
	}
	
	function clearInput(){
		$("#addEmpModal form")[0].reset() ;
		$("input").parent().removeClass("has-success has-error") ;
		$("input").next("p").text("") ;
	}
	
	function showMsg(id,flag,msg){
		if("success" == flag){
			$(id).parent().removeClass("has-error").addClass("has-success") ;
			$(id).next().text(msg) ;
		}else{
			$(id).parent().removeClass("has-success").addClass("has-error") ;
			$(id).next().text(msg) ;
		}
	}
	
	function initDepSelect(selector){
		$.ajax({
			url:"${path }/depController/getDeps",
			type:"GET",
			success:function(result){
				$(selector).empty() ;
				var deps = result.extend.deps ;
				for(var i=0; i<deps.length; i++){
					var option = '<option value="'+deps[i].depId +'">'+deps[i].depName+'</option>' ;
					$(selector).append(option) ;
				}
			}
		}) ;
	}
	
	function to_page(pn){
		$.ajax({
			url:"${path }/emps",
			data:"pn=" + pn,
			type:"GET",
			success:function(result){
				var pageInfo = result.extend.pageInfo ;
				totalCount = pageInfo.total;
				currentPage = pageInfo.pageNum ;
				initTable(pageInfo) ;
				initCountInfo(pageInfo) ;
				initPageInfo(pageInfo) ;
			}
		}) ;
	}
	
	function initTable(pageInfo){
		$("#mytable tbody").empty() ;
		var list = pageInfo.list ;
		var htmls = "" ;
		for(var i=0; i<list.length; i++){
			var html = "<tr>" 
				 	 +		"<td><input type='checkbox' class='check_item'/></td>" 
				 	 +		"<td>" + list[i].id + "</td>" 
					 +		"<td>" + list[i].name + "</td>" 
					 +		"<td>" + (list[i].gender == "M"?"男":"女") + "</td>" 
					 +		"<td>" + list[i].email + "</td>" 
					 +		"<td>" + list[i].department.depName + "</td>" 
					 +		"<td>"
					 +			'<button class="btn btn-info btn-xs " onclick="updateEmp(\''+list[i].id+'\')"><span class="glyphicon glyphicon-edit"></span>编辑</button>&nbsp;'
					 +			'<button class="btn btn-success btn-xs" onclick="deleteEmp(\''+list[i].id+'\',\''+list[i].name+'\')"><span class="glyphicon glyphicon-remove"></span>删除</button>'
					 +      "</td>" 
					 +	"</tr>" ;
			htmls += html ;
		}
		$("#mytable tbody").append(htmls) ;
	}
	
	function initCountInfo(pageInfo){
		$("#count_info").text("") ;
		var text = "当前第 " +pageInfo.pageNum+" 页,总共 "+pageInfo.pages+" 页，总共"+pageInfo.total+" 条" ;
		$("#count_info").text(text) ;
	}
	
	function initPageInfo(pageInfo){
		$("#page_info").empty() ;
		var html = '<li><a href="javascript:;" onclick="to_page('+1+')">首页</a></li>' ;
		if(pageInfo.hasPreviousPage){
			html += '<li><a href="javascript:;" onclick="to_page('+(pageInfo.pageNum-1)+')"> <span>&laquo;</span></a></li>' ;
		}
		for(var i=0; i<pageInfo.navigatepageNums.length; i++){
			var num = (pageInfo.navigatepageNums)[i] ;
			if(num == pageInfo.pageNum){
				html += '<li class="active"><a href="javascript:;" onclick="to_page('+num+')">' + num + '</a></li>' ;
			}else{
				html += '<li><a href="javascript:;" onclick="to_page('+num+')">' + num + '</a></li>' ;
			}
		}
		if(pageInfo.hasNextPage){
			html += '<li><a href="javascript:;" onclick="to_page('+(pageInfo.pageNum+1)+')"><span>&raquo;</span></a></li>' ;
		}
		html += '<li><a href="javascript:;" onclick="to_page('+pageInfo.pages+')">末页</a></li>' ;
		$("#page_info").append(html) ;
	}
	
	function updateEmp(id){
		initDepSelect("#update_dep_select") ;
		getEmp(id) ;
		$("#updateEmpModal").modal({
			backdrop:"static"
		}) ;
	}
	
	function getEmp(id){
		$.ajax({
			url:"${path }/getEmp/"+id,
			type:"GET",
			success:function(result){
				var emp = result.extend.emp ;
				console.log(emp) ;
				$("#update_name").text(emp.name) ;
				$("#update_email").val(emp.email) ;
				$("#updateEmpModal input[name=gender]").val([emp.gender]);
				$("#updateEmpModal select").val([emp.dId]);
				$("#update_emp_btn").attr("emp_id",emp.id) ;
				
			}
		}) ;
	}
	
	function deleteEmp(id,name){
		if(confirm("确定要删除 "+name+" 的信息么？")){
			$.ajax({
				url:"${path }/deleteEmp/"+id,
				type:"DELETE",
				success:function(result){
					to_page(currentPage) ;
				}
			}) ;
		}
	}
	
	function deleteEmpAll(){
		if($(".check_item:checked").length == 0){
			alert("至少选中一行") ;
			return false ;
		}
		var ids = "" ;
		var names = "" ;
		$.each($(".check_item:checked"),function(index,item){
			var id = $(this).parents("tr").find("td:eq(1)").text() ; //找到当前元素的tr祖先元素，再找该祖先元素下面子元素td，且index=1
			var name = $(this).parents("tr").find("td:eq(2)").text() ;
			ids += id+"-" ;
			names += name+"," ;
		}) ;
		ids = ids.substr(0,ids.length-1) ;
		names = names.substr(0,names.length-1) ;
		if(confirm("确定要删除 "+names+" 的信息么？")){
			$.ajax({
				url:"${path }/deleteEmp/"+ids,
				type:"DELETE",
				success:function(result){
					$("#delete_checkbox").prop("checked",false) ;
					to_page(currentPage) ;
				}
			}) ;
		}
	}
	
</script>
</head>
<body>
	<div class="container">
		<!-- 标题 -->
		<div class="row">
			<h1>员工信息列表</h1>
		</div>
		<!-- 按钮 -->
		<div class="row">
			<button class="btn btn-info pull-right" id="add_emp_btn"><span class="glyphicon glyphicon-plus"></span>新增</button>
			<button class="btn btn-success pull-right" id="del_emp_btn" onclick="deleteEmpAll()"><span class="glyphicon glyphicon-remove"></span>删除</button>
		</div>
		<!-- 信息 -->
		<div class="row">
			<table class="table table-hover table-bordered table-striped" id="mytable">
				<thead>
					<tr>
						<td><input type="checkbox" name="deletecheckbox" id="delete_checkbox"></td>
						<td>ID</td>
						<td>姓名</td>
						<td>性别</td>
						<td>Email</td>
						<td>部门</td>
						<td>操作</td>
					</tr>
				</thead>
				<tbody>
				
				</tbody>
			</table>
		</div>
		<!-- 分页信息 -->
		<div class="row">
			<div class="col-md-4" id="count_info"></div>
			<div class="col-md-8">
				<nav aria-label="Page navigation">
				  <ul class="pagination" id="page_info">
				  	
				  </ul>
				</nav>
			</div>
		</div>
	</div>
	
	<!-- 添加员工信息模态框 -->
	<div class="modal fade" id="addEmpModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">新增员工信息</h4>
	      </div>
	      
	      <div class="modal-body">
	      	<form class="form-horizontal">
			  <div class="form-group">
			    <label for="name" class="col-sm-2 control-label">姓名</label>
			    <div class="col-sm-10">
			      <input type="text"  name="name" class="form-control" id="name" placeholder="input name">
			      <p class="help-block"></p>
			    </div>
			  </div>
			  <div class="form-group">
			    <label for="email" class="col-sm-2 control-label">邮箱</label>
			    <div class="col-sm-10">
			      <input type="text"  name="email" class="form-control" id="email" placeholder="input email">
			      <p class="help-block"></p>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">性别</label>
			    <div class="col-sm-10">
			      <label class="radio-inline" for="mail">
				  	<input type="radio" name="gender" id="male" value="M" checked="checked"> 男
				  </label>
				  <label class="radio-inline" for="famale">
				    <input type="radio" name="gender" id="famale" value="F"> 女
				  </label>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">部门</label>
			    <div class="col-sm-4">
			    	<select class="form-control" name="dId" id="dep_select">
					</select>
			    </div>
			    
			  </div>
			</form>
	      </div>
	      
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal" id="close_emp_btn">关闭</button>
	        <button type="button" class="btn btn-primary" id="save_emp_btn">保存</button>
	      </div>
	    </div>
	  </div>
	</div>
	
	<!-- 更新员工信息模态框 -->
	<div class="modal fade" id="updateEmpModal" tabindex="-1" role="dialog" aria-labelledby="updateModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="updateModalLabel">更新员工信息</h4>
	      </div>
	      
	      <div class="modal-body">
	      	<form class="form-horizontal">
			  <div class="form-group">
			    <label for="name" class="col-sm-2 control-label">姓名</label>
			    <div class="col-sm-10">
			      <p class="form-control-static" id="update_name"></p>
			    </div>
			  </div>
			  <div class="form-group">
			    <label for="email" class="col-sm-2 control-label">邮箱</label>
			    <div class="col-sm-10">
			      <input type="text"  name="email" class="form-control" id="update_email" placeholder="input email">
			      <p class="help-block"></p>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">性别</label>
			    <div class="col-sm-10">
			      <label class="radio-inline">
				  	<input type="radio" name="gender" id="update_male" value="M" checked="checked"> 男
				  </label>
				  <label class="radio-inline">
				    <input type="radio" name="gender" id="update_famale" value="F"> 女
				  </label>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">部门</label>
			    <div class="col-sm-4">
			    	<select class="form-control" name="dId" id="update_dep_select">
					</select>
			    </div>
			    
			  </div>
			</form>
	      </div>
	      
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal" id="update_close_emp_btn">关闭</button>
	        <button type="button" class="btn btn-primary" id="update_emp_btn">更新</button>
	      </div>
	    </div>
	  </div>
	</div>
</body>
</html>