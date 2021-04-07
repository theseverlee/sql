0407
반복문
    개발언어의 반복문과 같은 기능 제공
    loop while for
1_ loop 문
    반복문의 기본 구조
    java에서의  do문과 유사한 구조
    기본적으로 무한 루프 구조
    (_사용형식_)
    LOOP
        반복처리문(들);
        [EXIT WHEN 조건;]
    END LOOP;
        - EXIT WHNE 조건 : 조건이 참인경우 반복문의 범위를 벗어남
    
사용예
구구단 7단을 출력하라
DECLARE
    V_CNT NUMBER := 1;
    V_RES NUMBER := 0;
BEGIN
    LOOP
        V_RES := 7 * V_CNT;
        
        EXIT WHEN V_CNT > 9;
        DBMS_OUTPUT.PUT_LINE(7||'*'||V_CNT||'='||V_RES);
        V_CNT := V_CNT + 1;
    END LOOP;
END;

사용예 )
1 - 50 사이의 피보나치수를 구하여 출력하시오
            1번, 2번이 1,1 3번은 12번 더한수
            
DECLARE
    V_PNUM NUMBER := 1;
    V_PPNUM NUMBER := 1;
    V_CURRNUM NUMBER := 0;
    V_RES VARCHAR(100);
BEGIN
    V_RES := V_PPNUM || ',' || V_PNUM;
    LOOP
        V_CURRNUM := V_PPNUM + V_PNUM;
        EXIT WHEN V_CURRNUM >= 50;
        V_RES := V_RES || ',' || V_CURRNUM;
        V_PPNUM := V_PNUM;
        V_PNUM := V_CURRNUM;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('1~50사이의 피보나치수 : '|| V_RES);
END;

-- 1~50사이의 피보나치수 : 1,1,2,3,5,8,13,21,34 --


2. WHILE 문
    개발언어의 WHILE문과 같은 기능
    조건을 미리 체크하여 조건이 참인 경우에만 번복 처리
    (사용형식)
WHILE 조건    
    LOOP
        반복처리문 ( 들 );
    END LOOP;

사용 예 )
첫날에 100원 둘째날 부터 전날의 2배씩 저출할 경우 
최초로 100만원을 넘는 날과 저축한 금액을 구하시오

DECLARE
    V_DAYS NUMBER := 1;
    V_AMT  NUMBER := 100;
    V_SUM  NUMBER := 0;
BEGIN
    WHILE V_SUM < 1000000
    LOOP
        V_SUM  := V_SUM + V_AMT;
        V_DAYS := V_DAYS + 1;
        V_AMT  := V_AMT * 2;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(V_DAYS||' 걸린일수 / '||V_SUM||' 모은 금액');
END;

사용예)
회원 테이블에서 마일리지가 3000인상인 회원들을 찾아 그들이 2005년 5월에 구매한 횟수와 구매금액합계를 구하시오
커서사용    회원번호 회원명 구매횟수 구매금액
SELECT *
FROM MEMBER;
SELECT *
FROM PROD;

- LOOP를 사용한 커서

DECLARE
    V_MID MEMBER.MEM_ID%TYPE;   -- 회원번호
    V_MNAME MEMBER.MEM_NAME%TYPE;   -- 회원명
    V_CNT NUMBER := 0; -- 구매횟수
    V_AMT NUMBER := 0; -- R구매금액 합계
    
    CURSOR CUR_CART_AMT IS
        SELECT MEM_ID, MEM_NAME
          FROM MEMBER
         WHERE MEM_MILEAGE >= 3000; 
BEGIN
    OPEN CUR_CART_AMT;
    LOOP
        FETCH CUR_CART_AMT INTO V_MID, V_MNAME;
        EXIT WHEN CUR_CART_AMT%NOTFOUND;
        SELECT SUM(CART.CART_QTY * PROD.PROD_PRICE), COUNT(CART.CART_PROD)
               INTO V_AMT, V_CNT
          FROM CART, PROD
         WHERE CART.CART_PROD = PROD.PROD_ID
                AND CART.CART_MEMBER = V_MID
                AND SUBSTR(CART.CART_NO,1,6) = '200505';
        DBMS_OUTPUT.PUT_LINE(V_MID||', '||V_MNAME||' -> '||V_AMT||'('||V_CNT||')');
    END LOOP;
    CLOSE CUR_CART_AMT;
END;

DECLARE
    V_MID MEMBER.MEM_ID%TYPE;   -- 회원번호
    V_MNAME MEMBER.MEM_NAME%TYPE;   -- 회원명
    V_CNT NUMBER := 0; -- 구매횟수
    V_AMT NUMBER := 0; -- R구매금액 합계
    
    CURSOR CUR_CART_AMT IS
        SELECT MEM_ID, MEM_NAME
          FROM MEMBER
         WHERE MEM_MILEAGE >= 3000; 
BEGIN
    OPEN CUR_CART_AMT;
    FETCH CUR_CART_AMT INTO V_MID, V_MNAME;
    -- 여기에 먼저  읽어준다.
    WHILE CUR_CART_AMT%FOUND
    -- FETCH없이 WHILE문에서CURSOR를 돌리면 FALSE라서 데이터는 안나온다.
    LOOP
        
        EXIT WHEN CUR_CART_AMT%NOTFOUND;
        SELECT SUM(CART.CART_QTY * PROD.PROD_PRICE), COUNT(CART.CART_PROD)
               INTO V_AMT, V_CNT
          FROM CART, PROD
         WHERE CART.CART_PROD = PROD.PROD_ID
                AND CART.CART_MEMBER = V_MID
                AND SUBSTR(CART.CART_NO,1,6) = '200505';
        DBMS_OUTPUT.PUT_LINE(V_MID||', '||V_MNAME||' -> '||V_AMT||'('||V_CNT||')');
        FETCH CUR_CART_AMT INTO V_MID, V_MNAME;
        -- 마지막에 읽는다.
    END LOOP;
    CLOSE CUR_CART_AMT;
END;

3. FOR
반복횟수를 알고 있거나 횟수가 중요한 경우 사용
(사용형식  - 일반적 FOR)
-- 인덱스는 자동으로 시스템에서 설정 해준다.
-- 무조건 1증가 감소 
-- 점 2개임 3개1개아니고 2개임
            FOR  인덱스  IN [REVERSE] 최소값.. 최댓값
            LOOP
                반복처리문(들);
            END LOOP;

사용예) 구구단 7단을 FOR 문으로 출력해보자
DECLARE
    V_RES  NUMBER := 0; -- 결과
BEGIN
    FOR I IN 1..9
    LOOP
--        V_RES := 7 * I;
        DBMS_OUTPUT.PUT_LINE(7||'*'||I||'='||7*I);
    END LOOP;
END;

사용 형식 2)
CURSOR에 사용하는 FOR
  FOR  레코드명  IN 커서명|(커서 선언문)
    LOOP
          반복처리문(들);
    END LOOP;
    . 레코드명 = 시스템에서 자동으로 설정
    . 커서 컬럼 참조형식 : 레코드명.커서컬럼명
    . 커서명 대신 커서 선언문(선언부에 존재했던) INLINE형식으로 기술할 수 있음
    . FOR문으로 사용하는 경우 커서의 OPEN FETCH CLOSE 생략함

DECLARE
    V_CNT NUMBER := 0; -- 구매횟수
    V_AMT NUMBER := 0; -- R구매금액 합계
    
    CURSOR CUR_CART_AMT IS
        SELECT MEM_ID, MEM_NAME
          FROM MEMBER
         WHERE MEM_MILEAGE >= 3000; 
BEGIN
    FOR REC_CART IN CUR_CART_AMT
    LOOP
        SELECT SUM(CART.CART_QTY * PROD.PROD_PRICE), COUNT(CART.CART_PROD)
               INTO V_AMT, V_CNT
          FROM CART, PROD
         WHERE CART.CART_PROD = PROD.PROD_ID
                AND CART.CART_MEMBER = REC_CART.MEM_ID
                AND SUBSTR(CART.CART_NO,1,6) = '200505';
        DBMS_OUTPUT.PUT_LINE(REC_CART.MEM_ID||', '||REC_CART.MEM_NAME||
                                                    ' -> '||V_AMT||'('||V_CNT||')');
    END LOOP;
END;

c001, 신용환 -> 12018000(6)
e001, 이혜나 -> 4850000(2)
k001, 오철희 -> 17434500(5)
l001, 구길동 -> 1160000(2)
s001, 안은정 -> 929000(3)
v001, 이진영 -> 511000(2)
x001, 진현경 -> 3519000(3)

--  인라인으로 커서를 사용 
DECLARE
    V_CNT NUMBER := 0; -- 구매횟수
    V_AMT NUMBER := 0; -- R구매금액 합계
    
BEGIN
    FOR REC_CART IN (SELECT MEM_ID, MEM_NAME
                       FROM MEMBER
                      WHERE MEM_MILEAGE >= 3000)
    LOOP
        SELECT SUM(CART.CART_QTY * PROD.PROD_PRICE), COUNT(CART.CART_PROD)
               INTO V_AMT, V_CNT
          FROM CART, PROD
         WHERE CART.CART_PROD = PROD.PROD_ID
                AND CART.CART_MEMBER = REC_CART.MEM_ID
                AND SUBSTR(CART.CART_NO,1,6) = '200505';
        DBMS_OUTPUT.PUT_LINE(REC_CART.MEM_ID||', '||REC_CART.MEM_NAME||
                                                    ' -> '||V_AMT||'('||V_CNT||')');
    END LOOP;
END;


----------------------------
--                                                          ---------------
--                                      -----------------   
--------    ---         ---------------------   -----------------   --------
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



































































