package service;

import java.util.HashMap;
import java.util.Map;

import controller.Controller;
import dao.UserDao;
import util.ScanUtil;
import util.View;

public class UserService {

	// 유저에 관련된걸 만들기 위해서  적당히 나누면됨
	// 메모리 절약하기 위해서 싱글톤 패턴 사용할거임
	
	private UserService(){};
	private static UserService instance;
	public static UserService getInstance(){
		if (instance == null) {
			instance = new UserService();
		}
		return instance;
	}
	
	private UserDao userDao = UserDao.getInstance();
	
	public int join(){
		System.out.println("====== 회 원 가 입 ======");
		System.out.print(" 아이디>");
		String userId = ScanUtil.nextLine();
		System.out.print(" 비밀번호>");
		String password = ScanUtil.nextLine();
		System.out.print(" 이   름>");
		String userName = ScanUtil.nextLine();
		// 아이디 중복 확인 생략
		// 비밀번호 확인 생략
		// 정규표현식(유효셩 검사 생략)
		
		Map<String, Object> param = new HashMap<>();
		param.put("USER_ID", userId);
		param.put("PASSWORD", password);
		param.put("USER_NAME", userName);
		
		int result = userDao.insertUser(param);
		
		if (0 < result) {
			System.out.println("회원가입 성공");
		}else{
			System.out.println("회원가입 실패");
		}
		
		return View.HOME;
		
	}
	
	
	public int login(){
		System.out.println("========= 로 그 인 ========");
		System.out.print("아이디 >");
		String userId = ScanUtil.nextLine();
		System.out.print("비밀번호 >");
		String password = ScanUtil.nextLine();
		// db에 접속해서 일치하는 사람 찾아야지 dao에서
		
		Map<String , Object> user = userDao.selectUser(userId, password);
		if (user == null) {
			System.out.println("아이디 혹은 비밀번호를 잘못 입력하셨습니다.");
		}else {
			System.out.println("로그인 성공"); // 기억한다 어딘가에 저장을 해놓는다.
			Controller.LoginUser = user; // 저장~
			return View.BOARD_LIST;
		}
		
		return View.LOGIN;
	}
	
	
	
	
	
	
	
	
	
}





























