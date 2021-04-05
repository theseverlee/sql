4월 5일
인덱스
-- 빈도수 위치 등 상황을 고려해서 적당히~ 만들어라
CREATE [UNIQUE | BITMAP] INDEX 인덱스명
    ON 테이블명(컬럼 1,[2....]) [ASC|DESC];
-- 복수개로 되었을때 WHERE에서 복수개의 조건이 나와야한다.    
인덱스가 2개이상으로 구성만들시에 WHERE에서 둘중 하나라도 기술되면 인덱스는 사용되지 않는다. 둘다 나와야함

식별자 / 비식별관계 -- 원론적인 이야기 / DB설계할때 효율성측면에서 구분한다

기본키 --> 인덱스가 만들어진다.

사용예) 상품테이블에서 상품명으로 NOMAL INDEX를 구성하시오
CREATE INDEX IDX_PROD_NAME
    ON PROD(PROD_NAME);

Index IDX_PROD_NAME이(가) 생성되었습니다.;

사용예) 장바구니테이블에서 장바구니번호 중 3번째에서 6글자로 인덱스를 구성하시오
CREATE INDEX IDX_CART_NO
    ON CART(SUBSTR(CART_NO,3,6));
Index IDX_CART_NO이(가) 생성되었습니다.

** 인덱스의 재구성 **
-- 데이터 테이블을 다른 테이블 스페이스로 이동시킨 후 ( REBUILD가 반드시 필요)
-- 자료의 삽입과 삭제 동작 후
 ( 사용 형식 )
ALTER INDEX 인덱스명  REBUILD;
--> 최신의 상태로 쏵 바뀐다.
나중에 경력이쌓여야 중요성이 높아진다. 튜닝시에 사용됨

----------------------------------------------------------------------------------------------
PL SQL
-- PROCEDURAL LANGEAGE SQL의 약자
- 표준 SQL에 절차적 언어의 기능(비교,반복, 변수 등)이 추가
- 블록(BLOCK) 구조로 구성
- 미리 컴파일도 되어 실행 가능한 상태로 서버에 저장되어 필요시 호출되어 사용됨
- 모듈화, 갭슐화 기능 제공
- Anonymous block, Stored Procedure, User Defined Function, Package, Trigger 등으로 구성

1. 익명블록
- pl sql의 기본구조
- 선언부와 실행부로 구성
(구성 형식);
DECLARE
    -- 선언영역
    -- 변수, 상수, 커서 선언
BEGIN
    -- 실행영역
    -- BUSINESS LOGIC 처리

    [ EXCEPTION
        예외처리명령;
    ]
END;
/(슬래쉬)가 있으면 종결된것으로간주-> SQL PLUS처럼 라인에디터를 사용할때

결과창 출력
보기 - DBMS 출력- 아래에 뜸 - +버튼 클릭- 사용계정 접속-활성화

사용예) 키보드로 2~9사이의 값을 입력 받아 그 수에 해당하는 구구단을 작성하시오
ACCEPT P_NUM PROMPT '수 입력 ( 2 ~ 9 ) : ';
DECLARE
  V_BASE NUMBER := T0_NUMBER('P_NUM');
  V_CNT NUMBER := 0;
  V_RES NUMBER := 0;
BEGIN
    LOOP
      V_CNT := V_CNT+1;
        EXIT WHEN V_CNT > 9;
        V_RES := V_BASE * V_CNT;

        DBMS_OUTPUT.PUT_LINE(V_BASE || '*' || V_CNT ||'=' || V_RES);
    END LOOP;
    
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('예외발생 : ' || SQLERRM);
END;
/

ACCEPT 입력받아쓸때 - 검토용 가끔 쓴다
&로 변수값을 받아준다
초기화 안하면 NULL이니 초기화 하자
DBMS_OUTPUT.PUT_LINE 자바에서 SYSOUT
WHEN OTHERS THEN 자바에서의 EXCEPTION 클래스와 같이 예외의 부모클래스다
SQLERRM SQL의 ERRM 에러 메세지임 

 1)변수, 상수 선언
    - 실행영역에서 사용할 변수 및 상수 선언
    (1) 변수의 종류
        . SCLAR 변수 - 하나의 데이터를 저장하는 일반적 변수
        . REFERENCES 변수 - 해당 테이블의 컬럼이나 행에 대응하는 타입과 크기를 참조하는 변수
        . COMPOSITE 변수 - PL/SQL에서 사용하는 배열 함수
          RECORD TYPE
          TABLE TYPE 변수
        . BIND 변수 - 파라미터로 넘겨지는 IN,OUT, INOUT에서 사용되는 변수 
                        RETURN 되는 값을 전달받기 위한 변수

    (2) 선언 방식
    변수명 [ CONSTANT ] 데이터 타입 [ := 초기값 ]
             상수
    변수명 테이블명. 칼럼명 % TYPE [ := 초기값 ], -> 칼럼 참조형
    변수명 테이블명 % ROWTYPE -> 행참조형
    (3) 데이터 타입
    - 표준 SQL에서 사용하는 데이터 타입 
    - PLS_INTEGER, BINARY_INTEGER : 2137483647  ~  -21474836648 까지 자료처리 잘안써
    - 숫자는 NUMBER로 쓴다 
    - BOOLEAN : TRUE, FALSE, NULL처리
    - LONG, LONG RAW : DEPRECATED 2기가까지 나타내는 문자열

예) 장바구니에2005년 5월 가장 많이 구매를 한(구매금액기준) 회원정보를 조회하시오
    회원번호ㅡ 회원명, 구매금액 합
;
SELECT *
FROM CART;

SELECT *
FROM PROD;

SELECT *
FROM MEMBER;

SELECT CART.CART_MEMBER AS 회원번호,
        MEMBER.MEM_NAME AS 회원명,
        SUM(PROD.PROD_PRICE * CART.CART_PTY) AS 구매금액 합
FROM CART,MEMBER,PROD
WHERE CART.CART_MEMBER = MEMBER.MEM_ID
  AND CART.CART_PROD = PROD.PROD_ID
GROUP BY CART.CART_PROD, MEMBER.MEM_NAME
ORDER BY 3 DESC;
집계함수가 SELECT 절에 사용되었을때 집계함수 외에 다른 컬럼이 들어왔으면 GROUP BY를 써야하지

SELECT A.*
FROM 
(SELECT ROWNUM RN , A.*
FROM
    (SELECT CART.CART_MEMBER, MEMBER.MEM_NAME, SUM(PROD.PROD_PRICE * CART.CART_QTY)
      FROM CART, MEMBER, PROD
       WHERE CART.CART_MEMBER = MEMBER.MEM_ID
      GROUP BY MEMBER.MEM_NAME, CART.CART_MEMBER
       ORDER BY 3 DESC) A) A
WHERE RN = 1





























