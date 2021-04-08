20210408

저장 프로시저 (Stored Procedure : Procedure)
    특정 결과를 상출하기 위한 코드의 집합
    반환값이 없으
    컴파일되어 서버에 보관(실행속도를 증가, 은닉성, 보안성)
(사용형식)
CREATE [ON REPLAVE] PROCEDURE 프로시져명 PROC_ [ (
        매개변수명 [ IN | OUT | INOUT ] 데이터 타입 [[ := | DEFAULT ] expr] 
        매개변수명 [ IN | OUT | INOUT ] 데이터 타입 [[ := | DEFAULT ] expr] 
                                    :
        매개변수명 [ IN | OUT | INOUT ] 데이터 타입 [[ := | DEFAULT ] expr] )]
            --가져올때 / 내보낼 때      크기지정시 오류
AS | IS
        선언영역;
BEGIN
        실행영역;
END;
-- 값반환 = FUNGTION  / 반환ㄴㄴ PROCEDURE

**다음 조건에 맞는  재고수불 테이블을 생성하시오
1. 테이블명 : REMAIN
2. 컬럼
----------------------------------------------------------------------
컬럼명         데이터타입                           제약사항
----------------------------------------------------------------------
REMAIN_YEAR     CHAR(4)                             PK
PROD_ID         VARCHAR(10)                         PK&FK
REMAIN_J_00     NUMBER(5)                          DEFAULT 0        --기초재고
REMAIN_I        NUMBER(5)                          DEFAULT 0        --입고수량
REMAIN_0        NUMBER(5)                          DEFAULT 0         -- 출고수량
REMAIN_J_99     NUMBER(5)                          DEFAULT 0        -- 기말재고
RAMAIN_DATE     DATE                               DEFAULT SYSDATE  -- 처리재고
---------------------------------------------------------------------


CREATE TABLE REMAIN(
    REMAIN_YEAR CHAR(4) ,
    PROD_ID VARCHAR(10) ,
    REMAIN_J_00 NUMBER(5) DEFAULT 0,
    REMAIN_I    NUMBER(5) DEFAULT 0,
    REMAIN_O    NUMBER(5) DEFAULT 0,
    REMAIN_J_99 NUMBER(5) DEFAULT 0,
    REMAIN_DATE DATE      DEFAULT SYSDATE,
    CONSTRAINT PK_REMAIN PRIMARY KEY (REMAIN_YEAR, PROD_ID),
    CONSTRAINT FK_RAMAIN_PROD FOREIGN KEY (PROD_ID)
        REFERENCES PROD(PROD_ID));

SELECT *
FROM REMAIN

-- 기초자료를 넣을거다
년도 : 2005
상품코드 : 상품테이블의 상품코드
기초재고 : 상품테이블의 PROPERSTOCK
입고수량 / 출고수량 : 없음
처리일자 : 2004/12/31

INSERT INTO REMAIN(REMAIN_YEAR, PROD_ID, REMAIN_J_00, REMAIN_J_99, REMAIN_DATE)
SELECT '2005',PROD_ID,PROD_PROPERSTOCK,PROD_PROPERSTOCK,
                                                    TO_DATE('20041231')
FROM PROD;
---------------------------------------------- 
사용 예제 1.
오늘이 2005년 1월 31일 이고 오늘까지 발생한 상품입고 정보를 이용하여 재고 수불 테이블을 
update하는 프로시져를 생성
    프로시져명 PROC_REMAIN_IN
    매개변수 : 상품코드, 입고수량
    처리내용 : 해당 상품 코드에 대한 입고

-> 1. 2005년 상품별 매입수량 집계 -- 프로시져 밖에서 처리해준다.
-> 2. 1에서 만든 결과 각 행을 PROCEDURE 에 전달 (커서로 하나씩 전달)
-> 3. PROCEDURE에서 재고 수불테이블 UPDATE 하면 된다.

(PROCEDURE생성)
CREATE OR REPLACE PROCEDURE PROC_REMAIN_IN(
    P_CODE IN PROD.PROD_ID%TYPE,
    P_CNT IN NUMBER)
IS
BEGIN
    UPDATE REMAIN
       SET (REMAIN_I,REMAIN_J_99,REMAIN_DATE)  =(SELECT REMAIN_I + P_CNT,
                                                        REMAIN_J_99 + P_CNT,
                                                        TO_DATE('20050131')
                                                   FROM REMAIN
                                                  WHERE REMAIN_YEAR = '2005'
                                                    AND PROD_ID = P_CODE)
     WHERE REMAIN_YEAR = '2005'
       AND PROD_ID = P_CODE;
END;


(프로시져 실행 명령)
EXEC | EXECUTE 프로시져명 [(매개변수 LIST)];
단, 익명블록 등 또 다른 프로시져나 함수에서 프로시져 호출시 EXEC | EXECUTE는 생략해야한다.

(2005년 1월 상품별 매입집계)

SELECT BUY_PROD AS B_CODE, SUM(BUY_QTY) AS B_AMT
  FROM BUYPROD
 WHERE BUY_DATE BETWEEN '20050101' AND '20050131'
 GROUP BY BUY_PROD;

(익명 블록작성)
DECLARE
    CURSOR CUR_BUY_AMT
    IS
        SELECT BUY_PROD AS B_CODE,
               SUM(BUY_QTY) AS B_AMT
          FROM BUYPROD
         WHERE BUY_DATE BETWEEN '20050101' AND '20050131'
         GROUP BY BUY_PROD;
BEGIN 
    FOR REC_01 IN CUR_BUY_AMT
    LOOP
        PROC_REMAIN_IN(REC_01.B_CODE, REC_01.B_AMT);
    END LOOP;
END;

** remain 테이블에 내용을 뷰로 만들어본다. 검증하려고

CREATE OR REPLACE VIEW V_REMAIN_01
AS
    SELECT *
      FROM REMAIN;
      
CREATE OR REPLACE VIEW V_REMAIN_02
AS
    SELECT *
      FROM REMAIN;

SELECT *
FROM V_REMAIN_01;
SELECT *
FROM V_REMAIN_02;

---------
사용예제  2
회원아이디를 입력받아 그 회원의 이름, 주소와 지ㄱ업을 반환하는 프로시져를 작성하시오
1. 프로시져명 : PROC_MEM_INFO
2. 매개변수 : 입력용 : 아이디
             출력용 : 이름 주소 직업

SELECT MEM_NAME, MEM_ADD1||' '||MEM_ADD2, MEM_JOB
  FROM MEMBER;

CREATE OR REPLACE PROCEDURE PROC_MEM_INFO(
    P_ID IN MEMBER.MEM_ID%TYPE,
    P_NAME OUT MEMBER.MEM_NAME%TYPE,
    P_ADDR OUT VARCHAR2,
    P_JOB OUT MEMBER.MEM_JOB%TYPE)
AS
BEGIN
    SELECT MEM_NAME, MEM_ADD1||' '||MEM_ADD2, MEM_JOB
      INTO P_NAME, P_ADDR, P_JOB
      FROM MEMBER
     WHERE MEM_ID = P_ID;
END;

(실행)
ACCEPT PID PROMPT '회원아이디 : '
DECLARE
    V_NAME MEMBER.MEM_NAME%TYPE;
    V_ADDR VARCHAR2(200);
    V_JOB MEMBER.MEM_JOB%TYPE;
BEGIN
    PROC_MEM_INFO('&PID', V_NAME, V_ADDR, V_JOB);
    DBMS_OUTPUT.PUT_LINE('회원아이디 : ' || '&PID');
    DBMS_OUTPUT.PUT_LINE('회원이  름 : ' || V_NAME);
    DBMS_OUTPUT.PUT_LINE('회원주  소 : ' || V_ADDR);
    DBMS_OUTPUT.PUT_LINE('회원직  업 : ' || V_JOB);
END;

문제 1]
년도를 입력 받아 해당년도에 구매를 가장 많이한 회원이름과 구매액을
반환하는 프로시져를 작성하시오.
1.프로시져명 : PROC_MEM_PTOP
2.매개변수 : 입력용: 년도 2005년
            출력용 : 회원이름, 구매액

-- 프로시져 만들기
CREATE OR REPLACE PROCEDURE PROC_MEM_PTOP(
    P_YEAR IN CHAR,
    P_NAME OUT MEMBER.MEM_NAME%TYPE,
    P_AMT OUT NUMBER)
IS
BEGIN
        SELECT M.MEM_NAME, A.AMT
          INTO P_NAME, P_AMT
          FROM
                (SELECT ROWNUM RN, A.*
                   FROM
                       (SELECT C.CART_MEMBER CID , SUM(C.CART_QTY * P.PROD_PRICE) as AMT
                          FROM CART C, PROD P
                         WHERE C.CART_PROD  = P.PROD_ID
                           AND SUBSTR(C.CART_NO,1,4) = '2005'
                         GROUP BY C.CART_MEMBER
                         ORDER BY AMT DESC) A)A, MEMBER M
                  WHERE M.MEM_ID = A.CID
                    AND RN = 1;    
END;

Procedure PROC_MEM_PTOP이(가) 컴파일되었습니다.

-- 실행하기
DECLARE
    V_NAME MEMBER.MEM_NAME%TYPE;
    V_AMT NUMBER := 0;
BEGIN
    PROC_MEM_PTOP('2005',V_NAME,V_AMT);
    DBMS_OUTPUT.PUT_LINE('회원이름 : '||V_NAME);
    DBMS_OUTPUT.PUT_LINE('구매금액 : '||V_AMT);
END;

-- 결과
회원이름 : 신영남
구매금액 : 44641500



------------------------------------------------------------------- 
문제
2005년도 구매 금액이 없는 회원을 찾아 회원 테이블의 삭제여부
컬럼의 값경하는 프로시져
을 Y로 변경
1.프로시져명 : PROC_MEM_DELETE
2.매개변수 : 입력용: 
            출력용 : 
-- 안산녀석 찾기
SELECT MEM_ID
FROM
    (SELECT MEM_ID 
       FROM MEMBER
      GROUP BY MEMBER.MEM_ID)A 
      LEFT OUTER JOIN 
      CART 
      ON(A.MEM_ID = CART.CART_MEMBER)
WHERE SUBSTR(CART.CART_NO,1,4) != '2005'        

-- 프로시져 만들기
CREATE OR REPLACE PROCEDURE PROC_MEM_DELETE(
    P_ID OUT MEMBER.MEM_ID%TYPE,
    P_DEL IN VARCHAR2)
IS
BEGIN
    UPDATE MEMBER
       SET (MEM_DELETE) =('Y')
     WHERE MEM_ID =(SELECT A.MID
                     FROM (SELECT MEM_ID MID
                             FROM
                                 (SELECT MEM_ID 
                                    FROM MEMBER
                                   GROUP BY MEMBER.MEM_ID) A 
                                 LEFT OUTER JOIN 
                                 CART
                                 ON(A.MEM_ID = CART.CART_MEMBER)
                            WHERE SUBSTR(CART.CART_NO,1,4) != '2005')A);
END;

Procedure PROC_MEM_DELETE이(가) 컴파일되었습니다.

-- 익명블록으로 커서 사용해서 프로시져 실행시키기
DECLARE
    CURSOR CUR_MEM_DEL
    IS
        SELECT MEM_ID MID, MEM_DELETE MDL
          FROM MEMBER, CART
         WHERE MEM_ID = CART_MEMBER(+)
         GROUP BY MEM_ID,MEM_DELETE;
BEGIN
    FOR REC_01 IN CUR_MEM_DEL
    LOOP
        PROC_MEM_DELETE(REC_01.MID, REC_01.MDL);
    END LOOP;
END;

-- 결과보기
SELECT MEM_ID, MEM_DELETE
FROM MEMBER

l001	
m001	Y
n001	
o001	



