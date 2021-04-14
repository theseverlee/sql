package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import oracle.net.aso.h;
import oracle.net.aso.p;

public class JDBCUtil {
	// 싱글톤 패턴
	// 객체가 하나만 생성됨
	// 싱글톤 패턴 : 인스턴스 생성을 제한하여 하나의 인스턴스만 사용하는 디자인 패턴
	// 패턴 몇가지마 배울거다
	
	//private를 붙이면 객체생성을 못하는걸 활용
	private JDBCUtil(){
	}
	
	// 인스턴스를 보관할 변수
	private static JDBCUtil instance;
	
	// 인스턴스를 빌려주는 메서드
	public static JDBCUtil getInstance(){
		if (instance == null) {
			instance = new JDBCUtil();
		}
		return instance;
	}
	
	// 메모리를 많이 절약할수잇다. 속도도 빨리지고
	
	String ur = "jdbc:oracle:thin:@localhost:1521:xe";
	String us = "Vitta";
	String pw = "java";
	
	Connection con = null;
	PreparedStatement  ps = null;
	ResultSet rs = null;
	
	
	/*
	 * 	 				 * selectOne - 조회 결과가 한줄일때 사용하는 메서드
	 * Map(String, Object> selectOne(String sql)  한개의 행
	 * 								물음표가 없는 경우 = sql에서 값이 정해져있다.
	 * Map(String, Object> selectOne(String sql, List<Object> param) 한개의 행
	 * 								물음표가 잇는 쿼리 / 물음표의 값을 list로 넣는다.	
	 * List<Map<String, Object>> selectList(String sql) 
	 * 								조회의 결과가 여러중이 예상이 될 때
	 * List<Map<String, Object>> selectList(String sql, List<Object> param)
	 * int update(String sql)
	 * 				셀렉트를 제외한 나머지
	 * int update(String sql, List<Object> param)
	 */
	
	// 완성된 SQL 물음표 없는
	public Map<String, Object> selectOne(String sql) {
		Map<String, Object> map = null;
		try {
			con = DriverManager.getConnection(ur, us, pw);
			ps = con.prepareStatement(sql);
			rs = ps.executeQuery();
			ResultSetMetaData mt = rs.getMetaData();
			int col = mt.getColumnCount();
			while (rs.next()) {
				map = new HashMap<>();
				for (int i = 1; i <= col; i++) {
					String key = mt.getColumnName(i);
					Object value = rs.getObject(i);
					map.put(key, value);
				}
			}			
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			if(rs != null)try{rs.close();} catch(Exception e){}
			if(ps != null)try{ps.close();} catch(Exception e){}
			if(con != null)try{con.close();} catch(Exception e){}
		}
		return map;
	}
	
	// 물음표가 있는 sql 한개의 행 데이터
	public Map<String, Object> selectOne(String sql, List<Object> param){
		Map<String, Object> map = null;
		// null과 초기화의 차이
//		Map<String, Object> map = new HashMap<>();
		// 아예 안나올수도있고 여러줄이 나올수도 있고
		// 결과를 받아서 조회가 됫는지 안됬는지가 확인하느방법이 null인지 아닌지 비교하는거임
		// 마이바티스 프레임워크
		try {
			con = DriverManager.getConnection(ur, us, pw);
			ps = con.prepareStatement(sql);
			for (int i = 0; i < param.size(); i++) {
				ps.setObject(i+1, param.get(i));
			}
			rs = ps.executeQuery();
			ResultSetMetaData mt = rs.getMetaData();
			int col = mt.getColumnCount();
			while(rs.next()){
				map = new HashMap<>();
				for (int i = 1; i <= col; i++) {
					String key = mt.getColumnName(i);
					Object value = rs.getObject(i);
					map.put(key, value);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			if(rs != null)try{rs.close();} catch(Exception e){}
			if(ps != null)try{ps.close();} catch(Exception e){}
			if(con != null)try{con.close();} catch(Exception e){}
		}
		return map;
	}
	

	
	// 물음표가 있고 여러행이 나오는
	public List<Map<String, Object>> selectList(String sql){
		List<Map<String, Object>> list = new ArrayList<>();
		try {
			con = DriverManager.getConnection(ur, us, pw);
			ps = con.prepareStatement(sql);
			rs = ps.executeQuery();
			ResultSetMetaData mt = rs.getMetaData();
			int col = mt.getColumnCount();
			while (rs.next()) {
				HashMap<String, Object> row = new HashMap<>();
				for (int j = 1; j <= col ; j++) {
					String key = mt.getColumnName(j);
					Object value = rs.getObject(j);
					row.put(key, value);
				}
				list.add(row);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			if(rs != null)try{rs.close();} catch(Exception e){}
			if(ps != null)try{ps.close();} catch(Exception e){}
			if(con != null)try{con.close();} catch(Exception e){}
		}
		return list;
	}
	
	
	
	public List<Map<String, Object>> selectList(String sql, List<Object> param){
		List<Map<String, Object>> list = new ArrayList<>();
		try{
			con = DriverManager.getConnection(ur,us,pw);
			ps = con.prepareStatement(sql);
			for (int i = 0; i < param.size(); i++) {
				ps.setObject(i+1, param.get(i));
			  }
			rs = ps.executeQuery();
			ResultSetMetaData mt = rs.getMetaData();
			int col = mt.getColumnCount();
			while (rs.next()) {
				HashMap<String, Object> row = new HashMap<>();
				for (int i = 1; i <= col; i++) {
					String key = mt.getColumnName(i);
					Object value = rs.getObject(i);
					row.put(key, value);
				}
				list.add(row);	
			}
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			if(rs != null)try{rs.close();} catch(Exception e){}
			if(ps != null)try{ps.close();} catch(Exception e){}
			if(con != null)try{con.close();} catch(Exception e){}
		}
		return list;
	}
	
	public int update(String sql){
		int result = 0;
		try {
			con = DriverManager.getConnection(ur, us, pw);
			ps = con.prepareStatement(sql);
			result = ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			if(rs != null)try{rs.close();} catch(Exception e){}
			if(ps != null)try{ps.close();} catch(Exception e){}
			if(con != null)try{con.close();} catch(Exception e){}
		}
		return result;
	}
	

	
	public int update(String sql, List<Object> param){
		int result = 0;
		try {
			con = DriverManager.getConnection(ur,us,pw);
			ps = con.prepareStatement(sql);
			for (int i = 0; i < param.size(); i++) {
				ps.setObject( i + 1, param.get(i));
			}
			result = ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			if(rs != null)try{rs.close();} catch(Exception e){}
			if(ps != null)try{ps.close();} catch(Exception e){}
			if(con != null)try{con.close();} catch(Exception e){}
		}
		return result;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
 }






















