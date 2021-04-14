package service;

import java.sql.ResultSet;
import java.util.List;
import java.util.Map;

import controller.Controller;
import util.ScanUtil;
import util.View;
import dao.BoardDao;

public class BoradService {
	
	private BoradService(){};
	private static BoradService instance;
	public static BoradService getInstance(){
		if (instance == null) {
			instance = new BoradService();
		}
		return instance;
	}
	
	// 목록출력
	private BoardDao boardDao = BoardDao.getInstance();
	
	public int boardList(){
		//db에서 게시판내요을 가져오아ㅑ지'
		List<Map<String, Object>> boardList = boardDao.selectBoardList();
		System.out.println("________________________");
		System.out.println("번호\t제목\t작성자\t작성일");
		System.out.println("________________________");
		for (Map<String, Object> board : boardList) {
			System.out.println(board.get("BOARD_NO")
					+ "\t" + board.get("TITLE")
					+ "\t" + board.get("USER_NAME")
					+ "\t" + board.get("REG_DATE"));
		}
		System.out.println("________________________");
		System.out.println("1.조회\t2.등록\t0.로그아웃");
		System.out.print("번호입력>");
		int input = ScanUtil.nextInt();
		
		switch (input) {
		case 1: 	
			System.out.println("조회할 게시글의 번호를 입력해주세요");
			int readNum = ScanUtil.nextInt();
			Map<String, Object> readList = boardDao.readBoardList(readNum);
				System.out.println("-----------------------------");
				System.out.print("글번호 : "+readList.get("BOARD_NO"));
				System.out.println("\t작성일 : "+readList.get("REG_DATE"));
				System.out.println("작성자 : "+readList.get("USER_NAME"));
				System.out.println("제   목 : "+readList.get("TITLE"));
				System.out.println("___________________________");
				System.out.println("내   용 : "+readList.get("CONTENT"));
				System.out.println("-----------------------------");
				System.out.println("1.수정\t2.삭제\t0.뒤로가기");
				int c = ScanUtil.nextInt();
				switch (c) {
				case 1:
					System.out.println("수정을 합니다.");
					System.out.print("제목 >");
					String retitle = ScanUtil.nextLine();
					System.out.print("내용 >");
					String recontent = ScanUtil.nextLine(); 
					
					int a = boardDao.updateBoardList(retitle,recontent,readNum);
					System.out.println();
					if (a == 0) {
						System.out.println("수정되지 않았습니다.");
					}else{
						System.out.println("수정 됬지비.");
					}
					break;
				case 2:
					int b = boardDao.deleteBoardList(readNum);
					if (b == 0) {
						System.out.println("삭제되지 않았습니다.");
					}else{
						System.out.println("삭제 됬지라");
					}					
					break;

				default:
					break;
				}
			break;
		case 2: 	
			System.out.println("게시글을 등록합니다");
			System.out.print("제목 >");
			String title = ScanUtil.nextLine();
			System.out.print("내용 >");
			String content = ScanUtil.nextLine();
			boardDao.insertBoardList(title, content);
			break;
		case 0: Controller.LoginUser = null;
				return View.HOME;
		}
		
		return View.BOARD_LIST;
	}
	
	
}
