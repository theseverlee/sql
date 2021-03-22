3월 22일 월요일

erd 다이어그램
prod와 lprod조인 


select prod_lgu, prod_name
from prod;

select lprod_gu, lprod_nm
from lprod;

select lprod_gu, lprod_nm, prod_name
from prod p, lprod l
WHERE p.prod_lgu = l.lprod_gu;

select p.prod_id ,lprod_gu, lprod_nm, prod_name
from prod p join lprod l on ( p.prod_lgu = l.lprod_gu)
order by l.lprod_gu;

-- 설계서를 제대로 하지않으면 다음사람이 봣을때 보기힘들억진다.

실습 2
buyer, prdo조인 buyer별 담담제품 조횜

select *
from prod;
select *
from buyer;

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod p join buyer b on (p.prod_buyer = b.buyer_id);

-- 조회된 행이 50개였는데 / 페이즈를 내리면 74개까지 나옴
-- 처음에 50개만 가져오고 내리니까 더불러온거임 / like 페이징 처리

실습 3
멤버 차트 prod 조인하여
장바구니 담은 제춤 결과 출력

SELECT mem_id, mem_name
FROM MEMBER;

SELECT PROD_ID, PROD_NAME
FROM PROD;

SELECT *
FROM CART;

SELECT mem_id, mem_name,PROD_ID, PROD_NAME,CART_QTY
FROM MEMBER M, PROD P, CART C
WHERE M.MEM_ID = C.CART_MEMBER
         AND P.PROD_ID = C.CART_PROD; 


SELECT mem_id, mem_name,PROD_ID, PROD_NAME,CART_QTY
FROM MEMBER  JOIN  CAR ON (MEMBER.MEM_ID = CART.CART_MEMBER) 
              JOIN PROD P ON(PROD.PROD_ID = CATY.CART_PROD);

실습 4
손님 사이클 테이블사용 / 제품,애음요일, 개수를 드음곽 같이 브라운과 샐리만 

SELECT *
FROM CUSTOMER;

SELECT *
FROM PRODUCT;

SELECT *
FROM CYCLE;

SELECT CT.CID, CT.CNM, P.PID, C.DAY, C.CNT
FROM CUSTOMER CT, PRODUCT P, CYCLE C
WHERE CT.CID = C.CID
    AND C.PID = P.PID
    AND CT.CNM in('brown','sally');


실습 5

SELECT CT.CID, CT.CNM, P.PID, P.PNM, C.DAY, C.CNT
FROM CUSTOMER CT, PRODUCT P, CYCLE C
WHERE CT.CID = C.CID
    AND C.PID = P.PID
    AND CT.CNM in('brown','sally');

실습 6

SELECT CT.CID, CT.CNM, P.PID, P.PNM, SUM(C.CNT)CNT
FROM CUSTOMER CT, PRODUCT P, CYCLE C
WHERE CT.CID = C.CID
    AND C.PID = P.PID
    AND CT.CNM in('brown','sally')
GRoup BY CT.CID, CT.CNM, C.PID, P.PNM;



실습 7 

SELECT P.PID, P.PNM, C.CNT
FROM PRODUCT P,CYCLE C
GROUP BY C.PID;




SELECT cycle.PID, product.PNM, SUM(CNT)
FROM PRODUCT, CYCLE
WHERE  cycle.PID = product.PID
GROup BY cycle.PID, product.PNM;


과제 실습 8~ 13


--------------------------------

아우터 조인 : 두개다 못나오녹 한쪾만 나오는?
            연결이 실패하더라도
            성공하면 -> kin g 나오고 널나오게 할수있다
            
OUTER JOIN : 컬럼연견이 실패해도 [기준 ]이 되는 테이블 쪽의 컬럼 정보는 나오도로고 하는 조인
LEFT OUTER JOIN : 기준이 되는 ㅌㅔ이블이 왼쪽에 있다
RIGHT OUTER JOIN : 기준이 되는 ㅌㅔ이블이 오른쪽에 있다
FULL OUTER JOIN : left outer + right outer = 중복데이터 제거 / 사용거의 안함 
기존은 
테이블1 JOIN 테이블 2
테이블1 LEFT OUTER JOIN 테이블 2
 ==
테이블2 RIGHT OUTER JOIN 테이블 1


--직원의 이름 직원 상사이름 두개 컬람 나오도록  조인쿼리 작성

SELECT e.ename, m.ename, m.mgr
FROM emp e join emp m on(e.mgr = m.empno);

SELECT e.ename, m.ename, m.mgr
FROM emp e LEFT OUTER JOIN emp m on(e.mgr = m.empno);

SELECT e.ename, m.ename, m.mgr
FROM emp e , emp m 
WHERE e.mgr = m.empno(+);
-- 누락이 되는쪽에 ( + ) 를 붙여줘서 결과출력하면 나온다.
-- ORACLE SQL , OUTER JOIN  표기  = ( + )
-- OUTER 조인으로 인해 데이터가 안나오는 쪽 컬럼에 ( + )를 붙여준다


SELECT e.ename, m.ename, m.DEPTNO
FROM emp e LEFT OUTER JOIN emp m on(e.mgr = m.empno AND m.deptno = 10);

-- 보통은 아래처럼 쓴다.
SELECT e.ename, m.ename, m.deptno
FROM emp e , emp m 
WHERE e.mgr = m.empno(+)
    AND m.deptno(+) =10;

-----------------------------
 2개씩 같은 값을 출력한다. 
 
SELECT e.ename, m.ename, m.DEPTNO
FROM emp e LEFT OUTER JOIN emp m on(e.mgr = m.empno)
WHERE m.deptno = 10;


SELECT e.ename, m.ename, m.deptno
FROM emp e , emp m 
WHERE e.mgr = m.empno(+)
    AND m.deptno =10;




select ename, empno, deptno, mgr
from emp;


SELECT e.ename, m.ename, m.DEPTNO
FROM emp e LEFT OUTER JOIN emp m on(e.mgr = m.empno);
SELECT e.ename, m.ename, m.DEPTNO
FROM emp m RIGHT OUTER JOIN emp e on(e.mgr = m.empno);


-- 위와 같은 쿼리지만 기준이 오른쪽으로 바꿧더니 결과춝력물이 달라졌다.
select ename, empno, deptno, mgr
from emp;



-- full outer = LEFT 14 + RIGHT 21 - 중복 제거 13 = 22

SELECT e.ename, m.ename
FROM emp e FULL OUTER JOIN emp m on(e.mgr = m.empno);
-- 풀 아우터는 오라클 SQL 문법으로 제공하지 않느다.
SELECT e.ename, m.ename
FROM emp e , emp m 
WHERE e.mgr(+) = m.empno(+);

실습 1
OUTER조인으로 

SELECT *
FROM buyprod
where buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD');

모든제품을 다 보여주고, 실제 구매가 ㅇ있을때는 구매수량 조회 / 업으면 NULL조회

SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM BUYPROD b right join PROD p on(b.buy_prod = p.pr
od_id 
                                and b.buy_date = TO_DATE('2005/01/25', 'YY/MM/DD')); 

SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM BUYPROD b , PROD p 
where b.buy_prod(+) = p.prod_id 
    and b.buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD'); 




