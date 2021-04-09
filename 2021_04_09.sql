어제 문제 풀이

프로시저 생성 : 입력받은 회원 번호로 해당 회원의 삭제여부 컬럼값을 변경
CREATE OR REPLACE PROCEDURE PROC_MEM_UPDATE(
    P_MID IN MEMBER.MEM_ID%TYPE)
IS
BEGIN
    UPDATE MEMBER
       SET MEMBER.MEM_DELETE = 'Y'
     WHERE MEM_ID = P_MID;
    COMMIT;
END;

Procedure PROC_MEM_UPDATE이(가) 컴파일되었습니다.
[ 구매금액이 없는 회원 ]

DECLARE
    CURSOR CUR_MID
    IS         
        SELECT MEM_ID
          FROM MEMBER
         WHERE MEM_ID NOT IN (SELECT CART_MEMBER 
                                FROM CART A   
                               WHERE CART_NO LIKE '2005%');
BEGIN
    FOR REC_MID IN CUR_MID
    LOOP
        PROC_MEM_UPDATE(REC_MID.MEM_ID);
    END LOOP;
END;

SELECT *
  FROM MEMBER
------------------------------------------------------------------------
USER DEFINED FUNCTION
사용자가 정의한 함수
반환값이 존재 ( 굉장히 큰 메리트 SELECT문에서 사용할수잇음)
자주 사용되는 복잡한 쿼리등을 모듈화 시켜 컴파일 한 후 호출하여 사용
CREATE [ OR REPLACE ] FUNCTION 함수명 FN_으로 시작한다 [( 
        매개변수 [IN|OUT|INOUT] 데이터타입 [[:=|DEFAULT] expr][,]
                                :
        매개변수 [IN|OUT|INOUT] 데이터타입 [[:=|DEFAULT] expr])]
        RETURN 데이터 타입 --(타입만 세미콜론 붙이지 않아)
AS | IS
        선언영역;
        -- 변수, 상수 , 커서
BEGIN
        실행문;
        RETURN 변수 | 수식;
         [EXCEPTION
            예외처리문;]
END;

-- 
사용 예
장바구니 테이블에서 2005년 6월 5일에 판매된 상품코드를 입력 받아
        상품명을 출력하는 함수를 작성하시오
        1. 함수명 : FN_PNAME_OUTPUT
        2. 매개변수 : 입력용 : 상품코드
        3. 반환값 : 상품명

CREATE OR REPLACE FUNCTION FN_PNAME_OUTPUT(
    P_CODE IN PROD.PROD_ID%TYPE)       -- 외부로 받을꺼니까IN
    RETURN PROD.PROD_NAME%TYPE -- VARCHAR2
IS
    V_PNAME PROD.PROD_NAME%TYPE;
BEGIN
-- 이름을 구해서 잠깐 잡아둘거니까
    SELECT PROD_NAME INTO V_PNAME
      FROM PROD
     WHERE PROD_ID = P_CODE;
     
    RETURN V_PNAME;
END;

-- 실행
SELECT CART_MEMBER, FN_PNAME_OUTPUT(CART_PROD)
  FROM CART
 WHERE CART_NO LIKE '20050605%'
-- 3번 호출된거임
-- 커서를 안써도 되는거임

사용 예)
2005년 5월 모든 상품에 대한 매입현황을 조회하시오
ALIAS는 상품코드 상품명 매입수량 매입금액
-함수안쓰고 해보기
OUTER JOIN  양쪽이 같은 컬럼일경우 많은쪽에 
            COUNT 함수는 * 쓰면 안됨
            
SELECT B.PROD_ID AS 상품코드,
       B.PROD_NAME AS 상품명,
       SUM(A.BUY_QTY) AS 매입수량,
       SUM(A.BUY_QTY * B.PROD_COST) AS 매입금액
  FROM BUYPROD A, PROD B
 WHERE A.BUY_PROD(+) = B.PROD_ID
   AND A.BUY_DATE BETWEEN '20050501' AND '20050531' -- 내부조인 결과
                                        -- 일반조건이 외부조건과 값이 같아지면 내부조인으로 바뀐다
                                        -- 안시 / 서브쿼리로 해결해야함
 GROUP BY B.PROD_ID, B.PROD_NAME

(ANSI OUTER JOIN



SELECT B.PROD_ID AS 상품코드,
       B.PROD_NAME AS 상품명,
       NVL(SUM(A.BUY_QTY),0) AS 매입수량,
       NVL(SUM(A.BUY_QTY * B.PROD_COST),0) AS 매입금액
  FROM BUYPROD A 
       RIGHT OUTER JOIN 
       PROD B
       ON(A.BUY_PROD = B.PROD_ID
          AND A.BUY_DATE BETWEEN '20050501' AND '20050531')
 GROUP BY B.PROD_ID, B.PROD_NAME

-- 서브쿼리
SELECT B.PROD_ID AS 상품코드,
       B.PROD_NAME AS 상품이름,
       NVL(A.QAMT,0) AS 매입수량,
       NVL(A.HAMT,0) AS 구입금액
  FROM PROD B, 
       (SELECT BUY_PROD AS BID,
               SUM(BUY_QTY) AS QAMT,
               SUM(BUY_QTY * BUY_COST) AS HAMT
          FROM BUYPROD
         WHERE BUY_DATE BETWEEN '20050501' AND '20050531'
         GROUP BY BUY_PROD) A
 WHERE A.BID(+)= B.PROD_ID;

-- 함수사용
CREATE OR REPLACE FUNCTION FN_BUYPROD_AMT(
    P_CODE IN PROD.PROD_ID%TYPE)
    RETURN VARCHAR2
IS
    V_RES VARCHAR2(100);    -- 매입수량과 매입금액을 문자열로 변환하여 기억 반환될 데이터
    V_QTY NUMBER := 0;  -- 매입수량 합계
    V_AMT NUMBER := 0;  -- 매입금액 합계
BEGIN
    SELECT SUM(BUY_QTY), SUM(BUY_QTY*BUY_COST) 
      INTO V_QTY, V_AMT
      FROM BUYPROD
     WHERE BUY_PROD = P_CODE
       AND BUY_DATE BETWEEN '20050501' AND '20050531';
    IF V_QTY IS NULL THEN
       V_RES := '0';
    ELSE
       V_RES := '수량 : '||V_QTY||', '||'구매금액 : '||V_AMT;
    END IF;
    RETURN V_RES;
END;
Function FN_BUYPROD_AMT이(가) 컴파일되었습니다.

-- 실행
SELECT PROD_ID AS 상품코드,
       PROD_NAME AS 상품명,
       FN_BUYPROD_AMT(PROD_ID) AS 구매내역
  FROM PROD;

----------------------------- 나머지 해봐 
상품코드를 입력받아 2005년도 상품별 평균판매횟수, 판매수량합계, 판매금액 합계를 출력하는 함수
    1. 함수명                 FN_CART_QAVG, FN_CART_QAMT, FN_CART_FAMT
    2. 매개변수: 입력 : 상품코드, 년도

CREATE OR REPLACE FUNCTION FN_CART_QAVG(
    P_CODE IN PROD.PROD_ID%TYPE,
    P_YEAR CHAR)
    RETURN NUMBER
IS
    V_QAVG NUMBER := 0;
    V_YEAR CHAR(5) := P_YEAR ||'%';
BEGIN -- 입력을 받아서
    SELECT ROUND(AVG(CART_QTY))
      INTO V_QAVG
      FROM CART
     WHERE CART_NO LIKE V_YEAR
       AND CART_PROD = P_CODE;
     
     RETURN V_QAVG;
END;

-- 실행
SELECT PROD_ID,
       PROD_NAME,
       NVL(FN_CART_QAVG(PROD_ID,'2005'),0)
  FROM PROD

나머지는 한번 해봐라 


---------------------------
[문제]
2005년 2~3월 제품별 매입수량을 구하여 재고수불테이블을 UPDATE하시오
    처리일자는 3월 마지막일임 - 함수이용하여
REMAIN 테이블


CREATE OR REPLACE FUNCTION FN_REMAIN_UPDATE(
		P_PID IN PROD.PROD_ID%TYPE,
		P_QTY IN BUYPROD.BUY_QTY%TYPE,
		P_DATE IN DATE)
		RETURN VARCHAR2
IS
    V_MES VARCHAR2(100);
BEGIN
    UPDATE REMAIN
        SET (REMAIN_I, REMAIN_J_99, REMAIN_DATE) =	(SELECT REMAIN_I + P_QTY,
                                                        	REMAIN_J_99 + P_QTY,
                                                        	P_DATE
                                                       FROM REMAIN
                                            		  WHERE REMAIN_YEAR = '2005'
                                                        AND PROD_ID = P_PID)
    WHERE REMAIN_YEAR = '2005'
      AND PROD_ID = P_PID;
    V_MES := P_PID || '제품입고 처리 완료';
    RETURN V_MES;
END;

Function FN_REMAIN_UPDATE이(가) 컴파일되었습니다.

DECLARE
    CURSOR CUR_BUYPROD
    IS
         SELECT BUY_PROD, SUM(BUY_QTY) AS AMT
           FROM BUYPROD
          WHERE BUY_DATE BETWEEN '20050201' AND '20050331'
    	  GROUP BY BUY_PROD;
    V_RES VARCHAR2(100);
BEGIN
    FOR REC_BUYPROD IN CUR_BUYPROD
	LOOP
		V_RES := FN_REMAIN_UPDATE(REC_BUYPROD.BUY_PROD,
                                  REC_BUYPROD.AMT, 
                                  LAST_DAY('20050301'));
	DBMS_OUTPUT.PUT_LINE(V_RES);
	END LOOP;
END;

SELECT *
   FROM REMAIN;


-----------------------------------------
트리거를 배울거다
어떤 이벤트가 발생하면 그 이벤트의 발생 전 (前) 후 (後) 자동으로 실행되는 
코드블록(프로시져의 일종)
(사용형식)
CREATE TRIGGER 트리거명
    (timming)BEFORE|AFTER  (event)INSERT|UPDATE|DELETE
    ON 테이블명
    [FOR EACH ROW]
    [WHEN 조건]
[DECLARE
    변수, 상수, 커서;
]
BEGIN
    명령문(들);-- 트리거 처리문
    [EXCEPTION
        예외처리문;
    ]
END;

-(timming) : 트리거처리문 수행 시점(BEFORE : 이벤트 발생전,
                                 AFTER  : 이벤트 발생후
- event : 트리거가 발생될 원인 행위 (or로 연결 사용 가능, ex)
                        INSERT OR UPDATE OR DELETE
- 테이블명 : 이벤트가 발생되는 테이블
- FOR EACH ROW : 행단위 트리거 발생 99% , 생략되면 문장단위 트리거 발생
- WHEN 조건 : 행단위 트리거에서만 사용가능, 이벤트가 발생될 세부조건 추가 설정

**뉴
**올드







































