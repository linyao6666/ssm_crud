package com.lin.bean;

import java.util.HashMap;
import java.util.Map;

/**
 * 通用的返回类
 * @author feifei
 *
 */
public class Msg {
	private int code ;//状态码，100成功，200失败
	private String msg ;//提示信息
	private Map<String,Object> extend = new HashMap<>() ;//用户要返回给浏览器的数据
	
	public static Msg success(){
		Msg result = new Msg() ;
		result.setCode(100) ;
		result.setMsg("处理成功") ;
		return result ;
	}
	
	public static Msg error(){
		Msg result = new Msg() ;
		result.setCode(200) ;
		result.setMsg("处理失败") ;
		return result ;
	}
	
	/**
	 * 为了可以链式操作，返回当前对象，向当前对象的map中添加key-value
	 * @param key
	 * @param value
	 * @return
	 */
	public Msg add(String key, Object value){
		this.extend.put(key,value) ;
		return this ;
	}
	
	public int getCode() {
		return code;
	}
	public void setCode(int code) {
		this.code = code;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public Map<String, Object> getExtend() {
		return extend;
	}
	public void setExtend(Map<String, Object> extend) {
		this.extend = extend;
	}
	
	
}
