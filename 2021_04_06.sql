2021_04_06

SELECT INTO
FROM

FROM 절에 온 테이블을 

]
----------------
커서(CURSOR) -> SELECT문의 결과 LIKE VIEW
행들의 집합 4단계 조인이나 서브쿼리 경로를 굉장히 단축시킬수잇따
-- 커서는 쿼리문의 영향을 받은 행들의 집합
-- 묵시적커서(IMPLICITE), 명시적(EXPLICITE) 커서로 구분
-- 커서의 선언은 선언부에서 수행
-- 커서의 OPEN, FETCH, CLOSE는 실행부에서 기술
1) 묵시적 커서
    이름이 없는 커서
    항상 CLOSE 상태이기 때문에 커서내로 접근 불가능
    (속성)
    -----------------------------------------
    속성              의미
    -----------------------------------------
    SQL%ISOPEN         커서가 있으면 OPEN되었으면 참(TRUE) 반환 / 묵시적 커서는 항항 FALSE
    SQL%NOTFOUND       커서내에 읽을 자료가 없으면 참(TRUE) 반환
    SQL%FOUND          커서내에 읽을 자료가 남아있으면 참(TRUE) 반환
    SQL%ROWCOUNT       커서내 자료의 수 반환
    -----------------------------------------
2) 명시적 커서
    이름이 있는 커서
    생성 -> OPEN -> FETCH -> CLOSE 순서로 처리해야함 
    (단, FOR문은 예외) --> FOR문은 거의 커서임
    
    A.생성
        (사용형식)
        CURSOR 커서명 [ ( 매개변수 LIST ) ]
        IS
            SELECT 문;
        (사용_예);
        상품매입테이블(BUTPROD)에서 2005년 3월 상품별 매입 현황(상품코드,상품명,거래처명,매입수량)
        출력쿼리를 커서로 작성하시오

DECLARE
    V_PCODE PROD.PROD_ID%TYPE;
    V_PNAME PROD.PROD_NAME%TYPE;
    V_BNAME BUYER.BUYER_NAME%TYPE;
    V_AMT NUMBER:= 0;  -- 크기지정안해도 큰문제없다.
    
    CURSOR CUR_BUY_INFO
    IS
        SELECT BUY_PROD,
               SUM(BUY_QTY)
          FROM BUYPROD
         WHERE BUY_DATE BETWEEN '20050301' AND '20050331'
         GROUP BY BUY_PROD;

BEGIN

END;
    
    B. OPEN문 
        명시적 커서를 사용하기전 커서를 OPEN
        (사용형식)
        OPEN 커서명[ ( 매개변수 LIST ) ];
        
DECLARE
    V_PCODE PROD.PROD_ID%TYPE;
    V_PNAME PROD.PROD_NAME%TYPE;
    V_BNAME BUYER.BUYER_NAME%TYPE;
    V_AMT NUMBER:= 0;  -- 크기지정안해도 큰문제없다.
    
    CURSOR CUR_BUY_INFO
    IS
        SELECT BUY_PROD,
               SUM(BUY_QTY) AS AMT
          FROM BUYPROD
         WHERE BUY_DATE BETWEEN '20050301' AND '20050331'
         GROUP BY BUY_PROD;

BEGIN
    OPEN CUR_BUY_INFO;
    
END;

    C. FETCH
        커서 내의 자료를 읽어오는 명령
        보통 반복문 내에 사용
        (사용형식)
        FETCH 커서명 INTO 변수명
        . 커서내의 컬럼값을 INTO 다음 기술된 변수에 할당

DECLARE
    V_PCODE PROD.PROD_ID%TYPE;
    V_PNAME PROD.PROD_NAME%TYPE;
    V_BNAME BUYER.BUYER_NAME%TYPE;
    V_AMT NUMBER:= 0;
    
    CURSOR CUR_BUY_INFO IS
            SELECT BUY_PROD,
                   SUM(BUY_QTY) AS AMT
              FROM BUYPROD
             WHERE BUY_DATE BETWEEN '20050301' AND '20050331'
             GROUP BY BUY_PROD;
BEGIN
    OPEN CUR_BUY_INFO;
    LOOP
        FETCH CUR_BUY_INFO INTO V_PCODE, V_AMT;
        EXIT WHEN CUR_BUY_INFO%NOTFOUND;
                SELECT PROD_NAME, BUYER_NAME
                  INTO V_PNAME, V_BNAME
                  FROM PROD, BUYER
                 WHERE PROD_ID = V_PCODE
                   AND PROD_BUYER = BUYER_ID;
        DBMS_OUTPUT.PUT_LINE('상품코드 : ' || V_PCODE);
        DBMS_OUTPUT.PUT_LINE('상품명 : ' || V_PNAME);
        DBMS_OUTPUT.PUT_LINE('거래처명 : ' || V_BNAME);
        DBMS_OUTPUT.PUT_LINE('매입수량 : ' || V_AMT);
        DBMS_OUTPUT.PUT_LINE('------------------------');
        
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('자료수 : ' ||  CUR_BUY_INFO%ROWCOUNT);
    CLOSE CUR_BUY_INFO;
END;

사용예)
상품분류코드 'p102'에 속한 상품의 상품명, 매입가격, 마일리지를 출력하는 커서를 작성하시오
(표준sql);
SELECT PROD_NAME AS 상품명,
        PROD_COST AS 매입가격,
        PROD_MILEAGE AS 마일리지
FROM PROD
WHERE PROD_LGU = 'P102';

(익명블록)
-- 출력되는건 모두 변수로 설정해야 합니다.
ACCEPT P_LCODE PROMPT '이이이이이이이이이이이이ㅣ이이이이이이이이이이이이이이이이이이이이이잉이'
DECLARE
    V_PNAME PROD.PROD_NAME%TYPE;
    V_COST PROD.PROD_COST%TYPE;
    V_MILE PROD.PROD_MILEAGE%TYPE;
    
    CURSOR CUR_PROD_COST(P_LGU LPROD.LPROD_GU%TYPE)  -- 파라미터를 이용한 커서
    IS
        SELECT PROD_NAME, PROD_COST, PROD_MILEAGE 
          FROM PROD
         WHERE PROD_LGU = P_LGU;        -- P102대신 파라미터로 받음
         
BEGIN
    OPEN CUR_PROD_COST('&P_LCODE');
    DBMS_OUTPUT.PUT_LINE('상 품 명                 단   가            마 일 리지');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------');
    LOOP
        FETCH CUR_PROD_COST INTO V_PNAME, V_COST, V_MILE;
        EXIT WHEN CUR_PROD_COST%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(V_PNAME || '  ' || V_COST || '   ' || NVL(V_MILE,0)); 
    END LOOP;
    CLOSE CUR_PROD_COST;
END;





















