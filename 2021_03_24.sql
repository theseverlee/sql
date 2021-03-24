2021 03 24 복습

WHERE, GROUP BY, JOIN -- 중요하다

문제]
SMITH가 속한 부서에 있는 직원들을 조회하기? ==> 20번 부서에 속하는 직원들 조회하기

1. SMITH가 속한 부서 이름을 알아 낸다.
2. 1번에서 알아낸 부서번호로 해당 부서에 속하는 직원을 emp테이블에서 검색한다.

1.
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

2.
SELECT *
FROM emp
WHERE deptno = 20;

SUBQUERY를 활용;
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');

//서브쿼리 ==> 한결과를 가져다 쓰는것
// (=)를 쓰기때문에 2개의 값이 오면 안됨


SUBQUERY : 쿼리의 일부로 사용되는 쿼리
서브쿼리에서 사용하는 것을 메인쿼리라고 한다.
다른 개발자와 소통시 필요한점이 많다.
1. 사용위치에 따른 분류
    SELECT : 스칼라 서브 쿼리 - 서브쿼리의 실행결과가 하나의 행, 하나의 컬럼을 반환하는 쿼리
    FROM : 인라인 뷰
    WHERE : 서브쿼리
                메인쿼리의 컬럼을 가져다가 사용할 수 있다.
                반대로 서브쿼리의 컬럼을 메인쿼리에 가져가서 사용할 수 없다

2. 반환값에 따른 분류 (행, 컬럼의 개수에 따른 분류)
    행-다중행, 단일행, 컬럼 - 단일 컬럼, 복수 컬럼
다중행 / 단일 컬럼 in, not in
다중행 / 복수 컬럼 pairwise
단일행 / 단일 컬럼
단일행 / 복수 컬럼

3. main-sub query의 관계에 따른 분류
    상호 연관 서브 쿼리 - 메인 쿼리의 컬럼을 서브 쿼리에서 가져다 쓴 경우 (correlated subquery)
        ==> 메인쿼리가 없으면 서브쿼리만 독자적으로 실행 불가능
    비상호 연관 서브 쿼리 - 메인 쿼리의 컬럼을 서브 쿼리에서 가져다 쓰지 않은 경우 (non-correlated subquery)
        ==> 메인쿼리가 없어도 서브쿼리만 실행가능

서브쿼리 (실습 sub1)
급여 평균 보다 높은 사람 카운트

SELECT *
FROM emp; -- 테이블 확인

SELECT AVG(sal) -- 평균확인
FROM emp;

SELECT COUNT(*)
FROM emp
WHERE sal >= 2073;  -- 서브 쿼리 안쓰고

SELECT COUNT(*)
FROM emp
WHERE sal >= (SELECT AVG(sal) -- 서브쿼리 쓰고 직원이 바뀔때마다 손을 안쓰고 자동으로 바꿔줌
                FROM emp);
                

서브쿼리 (실습 sub 2)
평균 급여보다 높은 급여를 받는 직원의 정보를 조회하세요

SELECT *
FROM emp; 

SELECT *
FROM emp
WHERE sal >= (SELECT AVG(sal) -- 위에서 카운트(그룹함수를 지운다)
                FROM emp);
                

서브쿼리 (실습 sub3)
SMITH와 WARD사원이 속한 부서의 모든 사원 정보를 조회하는 쿼리를 다음과 같이 작성하세요.

SELECT *
FROM emp;

SELECT *
FROM emp m
WHERE m.deptno IN ('SMITH', 'WARD');
    
SELECT *
FROM emp m
WHERE m.deptno IN (SELECT s.deptno
                    FROM emp s
                    WHERE s.ename IN ('SMITH', 'WARD'));
                    

MULTI ROW 연산자
    IN : = + OR
    비교 연산자 ANY
    비교 연산자 ALL
    
SELECT *
FROM emp e
WHERE e.sal < ANY (SELECT s.sal
                    FROM emp s
                    WHERE s.ename IN ('SMITH', 'WARD'));
                
직원중에 급여값이 SMITH(800)나 WARD(1250)의 급여보다 작은 직원을 조회
    ==> 직원중에 급여값이 1250보다 작은 직원 조회

SELECT *
FROM emp e
WHERE e.sal < (SELECT MAX (s.sal)
                    FROM emp s
                    WHERE s.ename IN ('SMITH', 'WARD'));
-- ANY를 안써도 가능한 논리가 쓰게 되는 경우가 드물다 MAX로 대체가 되었다

직원의 급여가 800보다 작고 1250보다 작은 직원 조회
    ==> 직원의 급여가 800보다 작은 직원 조회
SELECT *
FROM emp e
WHERE e.sal < ALL (SELECT s.sal
                    FROM emp s
                    WHERE s.ename IN ('SMITH', 'WARD'));
                    
SELECT *
FROM emp e
WHERE e.sal < (SELECT MIN(s.sal)
                    FROM emp s
                    WHERE s.ename IN ('SMITH', 'WARD'));
-- 800보다 적게 받는 직원이 없다
-- MIN과 같은 의미로 쓰였다
-- 비상화라 서브쿼리를 독자적으로 실행할 수 있다.

subquery 사용시 주의점 NULL 값
IN ()
NOT IN ()

SELECT *
FROM emp
WHERE deptno IN (10,20,NULL);
    ==> deptno = 10 OR deptno = 20 OR deptno = NULL -- 결과는 FALSE
    


select *
from emp
where deptno in(10,20, null);
==>  !(deptno = 10 or deptno = 20 or deptno = null)
==>  deptno != 10 and deptno != 20 and deptno != null
                                            false
t and t and t 여야하는데 ..
t and t and f ==> false 

select * 
from emp
where empno not in( select mgr
                    from emp );
        == 나는 잘못짠게 없는데 안나와 이상하다/ 이런게 자주잇따 not in이라 그런거임 / null처리 해야됨
        ==> 직원중 매니져가 아닌 사람
        ***** 요거 2번째 시험 *****
        
-- 
PAIR WISE : 순서쌍

SELECT *
FROM emp
WHERE mgr in (SELECT mgr
                from emp
                where empno in(7698, 7782))
    and deptno in (SELECT DEPTNO
                    FROM EMP
                    WHERE EMPNO IN (6989, 7782 ));
                    
SELECT ENAME, MGR, DEPTNO
FROM EMP
WHERE EMPNO IN(7499, 7782);
    -- 엘런 30 7698 / 클락 10 7839
        
SELECT *
FROM emp
WHERE mgr in (7698, 7782)
    and deptno IN (10,30);       
        ==> 7698 10 /7698 30/ 7782 10/ 7782 30 이렇게 4가지 조합

요구사항 : 앨런 또는 클락의 소속 부서번호와 같으면서, 상사도 같은 경우

SELECT *
FROM EMP 
WHERE (MGR, DEPTNO) IN (
                        SELECT MGR, DEPTNO
                        FROM emp
                        WHERE ENAME IN ('ALLEN', 'CLARK'));

==> 두가지의 행을 동시에 만족하는 값만 나온다. / 기억은 하셔야 한다. / 일할때나 나온다
------------------
DISTINCT :
    1. 설계가 잘못된 경우 / 
    2. 계발자가 SQL을 잘 작성하지 못하는 사람인 경우
    3. 요구사항이 이상한 경우
    
스칼라 서브 쿼리 : 잘못쓰면 남용한다. / 성능에 영향을 미침 함부로 쓰면 독임
     1.SELECT 절에 사용된 쿼리
     2. 하나의 행, 하나의 컬럼을 반환하는 서바쿼리(스칼라 서브 쿼리) 만족할때만 사용이 가능하다.
     3. 보통은 상호연관으로씀 / 비상호도 됨
     
SELECT EMPNO, ENAME, SYSDATE
FROM EMP;

SELECT SYSDATE
FROM DUAL;

SELECT EMPNO, ENAME, (SELECT SYSDATE
                        FROM DUAL)
FROM EMP;

EMP 테이블 직원이 속한 부서번호는 관리하지만 해당 부서명 정보는 DEPTM테이메만 있다
해당 지구언이 속한 부서 이름을 알고 싶다면 DEPT 테이블과 조인을 해야한다.

컬럼 확장 = 조인 / 행 = 집합연산

상호연관 서브쿼리는 항상 메인 쿼리가 먼저 실행된다.
비상호 연관 서브쿼리는 메인 쿼리가 먼저 실행 될 수도있고 
                    서브 쿼리가 먼저 실행 될 수도 있다
                    ==> 성능측면에서 유리한 쪽으로 오라클이 선택
                    
행에 개수에 따라서 조회랑이 많아진다.

SELECT empno, ename, deptno, (select dname from dept where DEPT.DEPTNO = EMP.DEPTNO)
FROM EMP;
메인 1 / 서브 14번


------------- ---- 
인라인 뷰 : select 쿼리 컬럼들로 이루어진 테이블이다.
    - inline : 해당 위치에 직접 기술을 했다
    - inline view : 해당 위치에 직접 기술한 view
            view : 쿼리( o ) -==> view table ( x ) 

select *
from
(select deptno, round(avg(sal), 2) avg_sal
from emp
group by deptno);


-
--실습 3
--아래 쿼리는 전체 직원의 급여 평균보다 높은 급여를 받는 직원을 조회하는 쿼리
SELECT COUNT(*)
FROM emp
WHERE sal >= (SELECT AVG(sal)
                FROM emp);
                
--직원이 속한 부서의 급여 평균보다 높은 급여를 받는 직원을 조회

select empno, ename, sal , deptno
from emp;

20번 부서 평균 2175
select avg(sal)
from emp
where deptno = 20;

10번 부서 평균 2916.666
select avg(sal)
from emp
where deptno = 10;

select empno, ename, sal , deptno
from emp e
where e.sal > (  select avg(sal)
                from emp a
                where a.deptno = e.DEPTNO)
order by deptno;
        -- 상호 비상호 연관성 좋은 예제 이해하자

상호 = main -> sub
비상호 = 순서다름 매번
우위의 개념이 아니다 / 요구사항에 맞춰서

실습 
                        부서번호 부서이름 위치
INSERT INTO dept VALUES (99,'ddid', 'daejeon');
commit;

select *
from dept;

q. 직원이 속하지 않은 부서정보

select * 
from dept d
where d.deptno not in ( select e.deptno
                        from emp e
                        where e.deptno = d.deptno);

-----

select e.empno, e.ename, e.sal , e.deptno, a.avg_sal 
from emp e
where e.sal > (  select avg(sal) avg_sal
                from emp a
                where a.deptno = e.DEPTNO);
-- 서브에 잇는 컬럼을 메인으로 가져올수는 없다.
select e.empno, e.ename, e.sal , e.deptno,
                (  select avg(sal) avg_sal
                from emp a
                where a.deptno = e.DEPTNO)
from emp e
where e.sal > (  select avg(sal) avg_sal
                from emp a
                where a.deptno = e.DEPTNO);

실습

사이클 프로덕트 이용cid 1dl이용 안먹는건/

SELECT PID
FROM CYCLE
WHERE CID = 1;

SELECT *
FROM PRODUCT;

SELECT *
FROM PRODUCT
WHERE PID NOT IN ( SELECT PID
                    FROM CYCLE
                    WHERE CID =1);
    





















        
        
        
        
        
        
        