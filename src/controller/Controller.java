package controller;

import java.util.Map;
import java.util.Scanner;

import service.BoradService;
import service.UserService;
import util.ScanUtil;
import util.View;

public class Controller {

	public static void main(String[] args) {
		/*
		 * 발표순서 : 조 소개 -> 주제 소개 -> 선정 배경 -> 메뉴 구조 > 시연 > 소감
		 * 발표인원 : 발표자 1 ppt 시연 도우미 1
		 * 
		 * controller  화면이동
		 * service 화면기능
		 * dao 쿼리작성 오라클
		 */
		
		new Controller().start();
	}
	public static Map<String, Object> LoginUser;
	
	private UserService userService = UserService.getInstance();
	private BoradService boardService = BoradService.getInstance();
	
	private void start() {
		// 여기서 화면을 이동시키는 걸 만들거임
		int view = View.HOME;// 처음 화면이 홈이라서 홈을 넣었다
		
		while (true) {
			switch (view) {
			case View.HOME :
				view = home(); 
					break;
			case View.LOGIN : 
				view = userService.login();
					break;
			case View.JOIN :
				view = userService.join();
					break;
			case View.BOARD_LIST :
				view = boardService.boardList();
					break;
			 // 							어떤 화면으로 갈지 리턴을 해줘야한다
			}
		}
	}

	private int home() {
		System.out.println("_________________________");
		System.out.println("1.로그인\t2.회원가입\t0.프로그램 종료");
		System.out.println("_________________________");
		System.out.print("번호입력>");
		int input = ScanUtil.nextInt();
		
		switch (input) {
		case 1: return View.LOGIN;
		case 2: return View.JOIN; // 회원가입
		case 0:
				System.out.println("프로그램이 종료됩니다.");
				System.exit(0);
		
		}
		return View.HOME;
	}
	


}

















