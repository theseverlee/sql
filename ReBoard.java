package K_jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import E_oop.ScanUtil;


public class ReBoard {
	static ArrayList<HashMap<String, Object>> boradList = new ArrayList<>();
	static SimpleDateFormat format = new SimpleDateFormat("yy-MM-dd");
	static Object a = new Date();
	static String time = format.format(a);
	
	public static void main(String[] args) {
		ReBoard r = new ReBoard();
		while (true) {
			System.out.println("-----------------------------");
			
			System.out.println("번호\t제목\t작성자\t일자");
			System.out.println("-----------------------------");
			r.jdbcMain();
			System.out.println("-----------------------------");
			System.out.println("1.조회  2.등록  0.종료");
			
			System.out.print("번호 >");
			int input = ScanUtil.nextInt();
			switch (input) {
				case 1: // 조회 수정  삭제
					r.read();
					break;
	
				case 2: // 등록
					r.insert();
					break;
				case 0:
					System.out.println("종료 됩니다.");
					System.exit(0);
					break;
				default:
					break;
				}
		}

	}
	
	void read(){
		System.out.println("조회하고 싶은 번호를 입력해주세요");
		int readNum = ScanUtil.nextInt();
		jdbcRead(readNum);
		System.out.println("1.수정 2.삭제 0.뒤로가기");
		
		
	}
	
	void jdbcRead(int readNum){
		String ur = "jdbc:oracle:thin:@localhost:1521:xe";
		String us = "Vitta";
		String pw = "java";
		
		Connection con = null;
		PreparedStatement  ps = null;
		ResultSet rs = null;
		try {
			con = DriverManager.getConnection(ur,us,pw);
					String readSql = "SELECT BOARD_NO, TITLE, USER_ID, CONTENT, REG_DATE "
							+ "FROM TB_JDBC_BOARD "
							+ "WHERE BOARD_NO = ?";
					ps = con.prepareStatement(readSql);
					ps.setObject(1, readNum);
					rs = ps.executeQuery();

			while (rs.next()) {
				System.out.println("-------------------------------------");
				System.out.print  ("글  번호 : " +rs.getObject(1));
				System.out.println("\t작 성 일 : " +rs.getObject(1));
				System.out.println("작 성 자 : " +rs.getObject(1));
				System.out.println("제     목 : " +rs.getObject(1));
				System.out.println("-------------------------------------");
				System.out.println("내     용 : " +rs.getObject(1));
				System.out.println("-------------------------------------");
			break;
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			if(rs != null)try{rs.close();} catch(Exception e){}
			if(ps != null)try{ps.close();} catch(Exception e){}
			if(con != null)try{con.close();} catch(Exception e){}
		}
	}
		
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	void insert(){
		System.out.println("게시글 작성");
		System.out.print("제   목 > ");
		String title = ScanUtil.nextLine();
		System.out.print("작성자 > ");
		String writer = ScanUtil.nextLine();
		System.out.print("내   용 > ");
		String content = ScanUtil.nextLine();

		int maxNumber = 0;
		for (int i = 0; i < boradList.size(); i++) {
			int num = (Integer)boradList.get(i).get("번호");
			if (maxNumber < num ) {
				maxNumber = num;
			}
		}
		HashMap<String, Object> inter = new HashMap<>();
		inter.put("번호", maxNumber + 1);
		inter.put("제목", title);
		inter.put("작성자", writer);
		inter.put("내용", content);
		inter.put("작성일", time);
		boradList.add(inter);
		jdbcInsert(inter);
	}
	
	void jdbcInsert (HashMap<String, Object> inse ){
		String ur = "jdbc:oracle:thin:@localhost:1521:xe";
		String us = "Vitta";
		String pw="java";

		Connection con = null;
		PreparedStatement ps = null;
		
		try {
			con = DriverManager.getConnection(ur,us,pw);
			String insertSql = "INSERT INTO TB_JDBC_BOARD(BOARD_NO, TITLE, CONTENT, USER_ID, REG_DATE)"
					+ "VALUES(TB_JDBC_BOARD_NO_seq.nextval,?,?,?,?) ";
			ps = con.prepareStatement(insertSql);
//			ps.setObject(1, 시퀀스.nextval);
			ps.setObject(1, inse.get("제목"));
			ps.setObject(2, inse.get("내용"));
			ps.setObject(3, inse.get("작성자"));
			ps.setObject(4, inse.get("작성일"));
			int res = ps.executeUpdate();
			System.out.println(res + "개의 게시글이 등록되었습니다.");

		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			if (ps != null) try {ps.close();} catch (Exception e) {	}
			if (con != null) try {con.close();} catch (Exception e) {	}
		}
	}
	
	
	void jdbcMain(){
		String ur = "jdbc:oracle:thin:@localhost:1521:xe";
		String us = "Vitta";
		String pw = "java";
		
		Connection con = null;
		PreparedStatement  ps = null;
		ResultSet rs = null;
		
		try {
			con = DriverManager.getConnection(ur,us,pw);
			String selectSql = "SELECT BOARD_NO, TITLE, USER_ID, REG_DATE "
					+ "FROM TB_JDBC_BOARD ORDER BY BOARD_NO DESC";
			ps = con.prepareStatement(selectSql);
			rs = ps.executeQuery();
			ResultSetMetaData md = rs.getMetaData();
			int col = md.getColumnCount();
			while (rs.next()) {
				for (int i = 1; i < col; i++) {
					Object value  = rs.getObject(i);
					System.out.print( value + "\t");
				}
				Object date  = rs.getObject(4);
				System.out.print( format.format(date));
				System.out.println();
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			if(rs != null)try{rs.close();} catch(Exception e){}
			if(ps != null)try{ps.close();} catch(Exception e){}
			if(con != null)try{con.close();} catch(Exception e){}
		}
		
	}
	
	
	
	
	
	
	
	
	
	
	

}
