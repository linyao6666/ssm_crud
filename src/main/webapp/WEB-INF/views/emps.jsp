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
</head>
<body>
	<div class="container">
		<!-- 标题 -->
		<div class="row">
			<h1>员工信息列表</h1>
		</div>
		<!-- 按钮 -->
		<div class="row">
			<button class="btn btn-info pull-right"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span>新增</button>
			<button class="btn btn-success pull-right"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span>删除</button>
		</div>
		<!-- 信息 -->
		<div class="row">
			<table class="table table-hover table-bordered table-striped">
				<tr>
					<td>ID</td>
					<td>姓名</td>
					<td>性别</td>
					<td>Email</td>
					<td>部门</td>
					<td>操作</td>
				</tr>
				<c:forEach items="${pageInfo.list }" var="emp">
					<tr>
					<td>${emp.id }</td>
					<td>${emp.name }</td>
					<td>${emp.gender == "M"?"男":"女" }</td>
					<td>${emp.email }</td>
					<td>${emp.department.depName }</td>
					<td>
						<button class="btn btn-info btn-xs "><span class="glyphicon glyphicon-edit" aria-hidden="true"></span>编辑</button>
						<button class="btn btn-success btn-xs"><span class="glyphicon glyphicon-remove" aria-hidden="true"></span>删除</button>
					</td>
					</tr>
				</c:forEach>
				
			</table>
		</div>
		<!-- 分页信息 -->
		<div class="row">
			<div class="col-md-4">当前第 ${pageInfo.pageNum } 页,总共 ${pageInfo.pages } 页，总共 ${pageInfo.total } 条</div>
			<div class="col-md-8">
				<nav aria-label="Page navigation">
				  <ul class="pagination">
				  	<li><a href="${path }/emps?pn=1">首页</a></li>
					<c:if test="${pageInfo.hasPreviousPage }">
						<li><a href="${path }/emps?pn=${pageInfo.pageNum-1}"
							aria-label="Previous"> <span aria-hidden="true">&laquo;</span>
						</a></li>
					</c:if>
				  
				  	<c:forEach items="${pageInfo.navigatepageNums }" var="page_Num">
						<c:if test="${page_Num == pageInfo.pageNum }">
							<li class="active"><a href="#">${page_Num }</a></li>
						</c:if>
						<c:if test="${page_Num != pageInfo.pageNum }">
							<li><a href="${path }/emps?pn=${page_Num }">${page_Num }</a></li>
						</c:if>
					</c:forEach>
					
					<c:if test="${pageInfo.hasNextPage }">
						<li><a href="${path }/emps?pn=${pageInfo.pageNum+1 }"
							aria-label="Next"> <span aria-hidden="true">&raquo;</span>
						</a></li>
					</c:if>
					<li><a href="${path }/emps?pn=${pageInfo.pages}">末页</a></li>
				  </ul>
				</nav>
			</div>
		</div>
	</div>
</body>
</html>