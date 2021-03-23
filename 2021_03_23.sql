아우터 조인 사용실

월별실적 조회 반도체     핸드폰     냉장고
2021년 1월    500       300     400
2021년 2월    0         0          400
.
.
.
2021년 12월    500         300     400



테이블 

SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty, NVL(BUY_QTY, 0)
FROM BUYPROD b , PROD p 
where b.buy_prod(+) = p.prod_id 
    and b.buy_date(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD'); 

PROD 테이블과 조회된 결과가 같은겉이다


실습 2

SELECT TO_DATE(:YYYYDDMM, 'YYYY/MM/DD'), b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM BUYPROD b , PROD p 
where b.buy_prod(+) = p.prod_id 
    and b.buy_date(+) = TO_DATE(:YYYYDDMM, 'YYYY/MM/DD'); 
    
SELECT *
FROM BUYPROD;

SELECT *
FROM PROD;

실습 3

SELECT BUY_DATE, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty, NVL(BUY_QTY, 0)
FROM BUYPROD b , PROD p 
where b.buy_prod(+) = p.prod_id 
    and b.buy_date(+) = TO_DATE(:YYYYDDMM, 'YYYY/MM/DD');     
    
    
    
실습 4
SELECT *
FROM CYCLE;
SELECT *
FROM PRODUCT;

1번고객잉 먹는 제품명 조회 / 먹지 않는것도 조회

SELECT PRODUCT.*, :CID , NVL(CYCLE.DAY, 0) DAY, NVL(CYCLE.CNT, 0) CNT
FROM CYCLE, PRODUCT
WHERE PRODUCT.PID = CYCLE.PID(+)
          AND CYCLE.CID(+) = :CID;


SELECT PRODUCT.*, :CID , NVL(CYCLE.DAY, 0) DAY, NVL(CYCLE.CNT, 0) CNT
FROM PRODUCT LEFT OUTER JOIN CYCLE ON ( PRODUCT.PID = CYCLE.PID AND CID = :CID);

과제  - 실습 5
4번 쿼리 기준으로 고랙이름 컬럼 추가하기
-- 커스터머 테이블 3개 어떻게 추가를 할지 방법은 다양
    
    
    
--  -----
강조했던거 
WHERE 절
GROUP BY (그룹핑)
JOIN

JOIN 
카테고리 기준
문법  안시 / 오라클
논리적 형태
 SELF JOIN
 NON-EQUI-JOIN(나주엥 이걸 할줄 아냐 모르냐에따라서 작업차이에 있다)  <==> EQUI-JOIN
 참을 만족하는 수식이 ____ 냐?
 아우터조인
  연결조건 성공, 실패에 따라 조회여부 결정
  OUTER JOIN <==> INNER JOIN : 연결이 성공적으로 이루어진 행에 대해서만 조회가 되는 조인
  
  SELECT *
  FROM DEPT INNER JOIN EMP ON (DEPT.DEPTNO = EMP.DEPTNO);
 
 CROSS JOIN
 = 별도의 연결 조건이 없는 조인;
 = 묻지마 조인 
 = 두 테이블의 행간 연결가능한 모든 경우의 수로 연결
        ==> CROSS JOIN의 결과는 두 테이블의 행의 수를 곱합 값과 같은 행이 반환된다.
 = 데이터 복제를 위해서 사용한다. ( 참고적으로만  알고잇어라 )
 SELECT *
 FROM EMP, DEPT;
 -- EMP행 하나가 DEPT랑 전부 비교
 -- 행의 건수 = 2개의 태이블 끼리 곲한 값
 SELECT *
 FROM EMP CROSS JOIN DEPT;
    
    CROSS JOIN 실습 1)
손님 생산 테이블을 이용하여 조회하라
SELECT *
FROM CUSTOMER CROSS JOIN PRODUCT;
    
--
SELECT STORECATEGORY
FROM BURGERSTORE
WHERE SIDO = '대전'
GROUP BY STORECATEGORY;
    
    -- E대전 중구
    도시발전 지수 : (KFC + 맥날 + 버거킹) / 롯리
                    1   3   2           3       ==> 2
SELECT SIDO, SIGUNGU, STORECATEGORY
FROM BURGERSTORE
WHERE SIDO = '대전'
        AND SIGUNGU = '중구'
ORDER BY STORECATEGORY;
    
    
-- 롯데리아와 나머지를 인라인 뷰 테이블로 받아서 계산    
SELECT B.SIDO, B.SIGUNGU, K맥버/롯데리아 도시발전지수
FROM
         (SELECT COUNT(STORECATEGORY) K맥버
          FROM BURGERSTORE
          WHERE SIDO = :SIDO
                   AND SIGUNGU = :SIGUNGU
                 AND STORECATEGORY NOT IN('LOTTERIA'))LOTTE,
          (SELECT COUNT(STORECATEGORY) 롯데리아
           FROM BURGERSTORE
          WHERE SIDO = :SIDO
                   AND SIGUNGU = :SIGUNGU
                 AND STORECATEGORY IN('LOTTERIA')) K맥버,
            BURGERSTORE B
WHERE SIDO = :SIDO
       AND SIGUNGU = :SIGUNGU
GROUP BY B.SIGUNGU, B.SIDO, K맥버, 롯데리아;    
    
-- 전체 나오게 만들어보기

SELECT B.SIDO, B.SIGUNGU, K맥버/롯데리아 도시발전지수
FROM
         (SELECT COUNT(STORECATEGORY) K맥버
          FROM BURGERSTORE
          WHERE SIDO = SIDO
                   AND SIGUNGU = SIGUNGU
                 AND STORECATEGORY NOT IN('LOTTERIA'))LOTTE,
          (SELECT COUNT(STORECATEGORY) 롯데리아
           FROM BURGERSTORE
          WHERE SIDO = SIDO
                   AND SIGUNGU = SIGUNGU
                 AND STORECATEGORY IN('LOTTERIA')) K맥버,
            BURGERSTORE B
WHERE SIDO = SIDO
       AND SIGUNGU = SIGUNGU
GROUP BY B.SIGUNGU, B.SIDO, K맥버, 롯데리아;   
    
SELECT SIDO, SIGUNGU,COUNT(STORECATEGORY) K맥버
          FROM BURGERSTORE
          WHERE SIDO = SIDO
                   AND SIGUNGU = SIGUNGU
                 AND STORECATEGORY  IN('LOTTERIA')
GROUP BY SIGUNGU, SIDO;
    
SELECT *
FROM BURGERSTORE;
GROUP BY SIGUNGU, SIDO;


SELECT SIDO, SIGUNGU, STORECATEGORY
FROM BURGERSTORE
WHERE STORECATEGORY IN('BURGER KING', 'KFC', 'MACDONALD', 'LOTTERIA');
 978 875
    

-- 한단계 진화 어려워 진다.
-- 써먹을곳 있을거야
-- 행을 컬럼으로 변경(엑셀 = 피벗)
SELECT SIDO, SIGUNGU,
        ROUND((SUM(DECODE(storecategory, 'BURGER KING', 1,0)) +
        SUM(DECODE(storecategory, 'KFC', 1,0)) +
        SUM(DECODE(storecategory, 'MACDONALD', 1,0)) )/
        DECODE(SUM(DECODE(storecategory, 'LOTTERIA', 1,0)),0,1,SUM(DECODE(storecategory, 'LOTTERIA', 1,0))),2) IDK      
FROM BURGERSTORE
GROUP BY SIDO, SIGUNGU
ORDER BY IDK DESC;

-- 시험본다 4교시
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    