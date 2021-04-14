package dao;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import controller.Controller;
import util.JDBCUtil;
import util.ScanUtil;

public class BoardDao {
	private BoardDao(){};
	private static BoardDao instance;
	public static BoardDao getInstance(){
		if (instance == null) {
			instance = new BoardDao();
		}
		return instance;
	}
	
	private JDBCUtil jdbc = JDBCUtil.getInstance();	
	
	
	public List<Map<String, Object>> selectBoardList(){
		String sql = "SELECT A.BOARD_NO, A.TITLE, A.CONTENT, B.USER_NAME, A.REG_DATE"
				+ " FROM TB_JDBC_BOARD A"
				+ "		 LEFT OUTER JOIN TB_JDBC_USER B"
				+ " ON A.USER_ID = B.USER_ID"
				+ " ORDER BY A.BOARD_NO DESC";
		return jdbc.selectList(sql);
	}
	
	public int insertBoardList(String title, String content){
		String sql = "INSERT INTO TB_JDBC_BOARD"
				+ "  VALUES (TB_JDBC_BOARD_NO_SEQ.NEXTVAL,?,?,?,SYSDATE)";
		List<Object> param = new ArrayList<>();
		param.add(title);
		param.add(content);
		param.add(Controller.LoginUser.get("USER_ID"
				+ ""));
		return jdbc.update(sql, param);
	}
	
	public Map<String, Object> readBoardList(int readNum){
		String sql =  "SELECT A.BOARD_NO, A.TITLE, A.CONTENT, B.USER_NAME,"
				+ " A.REG_DATE"
				+ " FROM TB_JDBC_BOARD A, TB_JDBC_USER B"
				+ " WHERE A.USER_ID = B.USER_ID "
				+ "	  AND BOARD_NO = ? "
				+ " ORDER BY A.BOARD_NO DESC";
		List<Object> param = new ArrayList<>();
		param.add(readNum);
		
		return jdbc.selectOne(sql, param);
	
	}
	
	public int updateBoardList(String retitle, String recontent,int readNum){
		String sql = "UPDATE TB_JDBC_BOARD "
				+ " SET TITLE = ?, CONTENT = ?"
				+ " WHERE BOARD_NO = ?";

		List<Object> param = new ArrayList<>();
		param.add(retitle);
		param.add(recontent);
		param.add(readNum);
		
		return jdbc.update(sql, param);
	}
	
	
	public int deleteBoardList(int readNum){
		String sql = "DELETE TB_JDBC_BOARD "
				+ " WHERE BOARD_NO = ? ";
		List<Object> param = new ArrayList<>();
		param.add(readNum);
		return jdbc.update(sql, param);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
