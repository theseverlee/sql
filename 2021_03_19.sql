--실습 3
--emp테이블에서 grp2에서 작성한 쿼리 활용해서 부서번호대신 부서명 

SELECT 
        CASE
            WHEN deptno = 10 then 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATIONS'
            ELSE 'DDIT'
        END DNA,
        MAX(SAL), MIN(SAL), ROUND(AVG(SAL),2), SUM(SAL), COUNT(SAL), COUNT(MGR)      
FROM EMP;


-- 실습4
EMP 입사년월별로 몇명이 입사했는지 카우팅

SELECT
       TO_CHAR(hiredate, 'YYYYmm'), COUNT(*)
FROM EMP
GROUP BY TO_CHAR(hiredate, 'YYYYmm')
ORDER BY TO_CHAR(hiredate, 'YYYYmm');

-- 실습 5
-- 년도별로 입사인원 구하시오
SELECT
       TO_CHAR(hiredate, 'YYYY'), COUNT(*)
FROM EMP
GROUP BY TO_CHAR(hiredate, 'YYYY')
ORDER BY TO_CHAR(hiredate, 'YYYY');

-- 실습 6
회사 존재부서 정보 구하시고
프롬에 테에블말고 칼럼지정
SELECT
    COUNT(*)
FROM DEPT;

-- 실습 7
직원이 속한 부서의 갯수를 구해라

select *
from emp;


select count(*) cnt
from
(SELECT deptno    
FROM emp
GROUP BY deptno);

-   -   -   -   -   -   -       -   -   -   -   -   -   -   -
데이터 결합(호ㅏㄱ장)
1. 컬럼의 대한 확장  : JOIN
2. 행에 대한 확장 : 집합연산자(UNION(합집합), UNION ALL, INTERSECT(교집합), MINUS(차집합)

JOIN
 RDBMs는 중복을 최소화 하는 형태의 데이터 베이스
 다른 테이블과 결합하여 데이터를 조회
 조인인 없는 코드는거의 없다
 테이블에 없느느 데이터를 다른데서 가죠오는거
 하나로 합쳐지면 중복이 많았따
---
EMP에서 세일즈르 바꿀며녀 6번으 ㄹ바꿔야됨 
JOIN으로 중복을 최솨화 하는 RDBMS방식 설계한 경우
EMP에 부서코드만 존재
부서정보를 담은 DEPT 테이블을 별도 생성
EMP테이블 DEPT테이블의 연결고리를 부서번호로 조인하여 
실제 부서명을 조회한다.

JOIN : 크게 보면 2가지 
1. 포준 SQL  ==> ANSI SQL 단체이름이다
2. 비표준 SQL  - DBMS를 만드는 회사에서 만든 고유의  SQL 문법(1번보다 간결하다)

2개다 알려줄거다 종류가 많기함 - 햇갈릴거야 다 챙기기는 어려워
흔적남기고 궁금하면 찾아봐라  범용적인녀석은 신경써서 외워라

ANSI : SQL
ORACLE : SQL

ANSI - NATURAL JOIN
    - 조인하고자 하는 테이블의 연결 컬럼명이( 타입도 동일해야함) 동일한 경우 (emp.deptno,  detp,deptno)
    - 연결 컬럼의 값이 동일할 때 (=) 컬럼명이 확장된다.

SELECT emp.ename, emp.empno, deptno
FROM EMP NATURAL JOIN DEPT;
-- 결합해서 원하는 데이터만 셀렉트 할수있다.
-- 조인했을때 연결자라서 안된다. 연결고리 칼럼
-- 네츄럴은 에러야 / 다른데는 안그럴수도잇어

ORACLE JOIN :
1. FROM 절에 조인할 테이블을 (,) 콤마로 구분하여 나열
2. WHERE 조인할 테이블의 연결조건을 기술

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;
-- 조건절 컬럼명에 한정자를 붙여서  기술한다.
-- 이어붙어서 나온다.

--7369 스미스, 상사이름 알고싶다. 7902의 이름을 알고싶다 ford
SELECT *
FROM emp, emp
where emp.mgr = emp.empno;
-- 위같을때 테이블 별칭을 쓴다 as못슴
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
where e.mgr = m.empno;
킹 매니져값은 null인데 안나옴
null = m.empno로 인식했기때문에 안나옴 is를 써야됨

ANSI SQL : JOIN WITH USING
    - 조인하려고 하는 테이블의 컬럼명과 타입이 같은 칼럼이 2개 이상일 때
    두컬럼을 모두 조인 조건으로 참여시키지 않고, 개발자가 원하는 특정 컬럼으로만 연결을 시키고 싶을 때 사용
    
SELECT *
FROM emp JOIN dept USING(deptno);
-- 위 네츄럴 조인이랑 결과값이 현재 같다
-- 연결칼럼에서 한정자 못씀 
-- 대체하는게 잇으니 넘어가도 상관없다.
==> 오라클로
SELECT *
FROM emp, dept
where emp.deptno = dept.deptno;


ANSI 조인 커버할 녀석
    JOIN WITH ON : NATURAL JOIN, JOIN WITH USING  을 대체할 수 있는 보편적인 문법
조인 컬럼 조건은 개발자가 임의로 지정

SELECT *
FROM emp JOIN dept on(emp.deptno = dept.deptno);

-- 사번 직원이름 해아사번의 상사 사번 상사이름 : join with on으로 짜라
-- 단 사원이 7369 ~ 7698만
select e.empno, e.ename, m.empno, m.ename
from emp e join emp m on(e.mgr=m.empno)
WHERE  e.empno between 7369 and 7698;

select e.empno, e.ename, m.empno, m.ename
from emp e, emp m 
WHERE  e.empno between 7369 and 7698
        AND e.mgr=m.empno;


논리적인 조인 형태
암기하듯이 할 피요없고 자연스럽게 받아들여라
1. SELF JOIN : 조인 테이블이 같은 경우 
            바로 위 쿼리
    - 계층구조
2. NON-EQUI-JOIN : 조인 조건이 =(equlas)가 아닌 조인
        조인 조건이 이퀄이 아닐수도잇다
            많이 쓰인다
              ****
              이건 시험에 나온다잉
SELECT *
FROM emp , dept
WHERE emp.deptno != dept.deptno;
-- 42건 나온다 1명당 다른값으로 대입하니

SELECT *
FROM salgrade;

-- SALGARADE를 이요해서 급여 등급
-- 사번 이름 급여 급여 등급
SELECT *
FROM EMP;

SELECT e.empno, e.ename, e.sal, s.grade
FROM emp e join salgrade s on(e.sal between s.losal and s.hisal); 

e.sal >= s.losal and e.sal <= s.hisal
where e.sal between s.losal and s.hisal; 

엑셀같은 데이터를 띄워놓고 비교하면 능률이 오른다.

-`      -   -   -   -   -조인
실습0
emp dept 테이블 다음과같이 조회해봐
SELECT e.empno, e.ename, d.deptno, d.dname
FROM EMP e join  dept d on(e.deptno = d.deptno)
ORDER BY d.deptno;

조인칼럼명을 확실히 명시해줘라
--  -   -   --
실습 1
emp dept / 실습 0엥서 부서번호 10,30만 조회

SELECT e.empno, e.ename, d.deptno, d.dname
FROM EMP e join  dept d on(e.deptno = d.deptno and d.deptno  in(10,30))
ORDER BY d.deptno;

-- 어느테이블의 부서번호로 해도 상관없음

--  -   -   -   -   -
실습 2 
emp dept조인하고 급여 2500이상 조회

SELECT e.empno, e.ename,e.sal, d.deptno, d.dname
FROM EMP e join  dept d on(e.deptno = d.deptno and sal > 2500)
ORDER BY d.deptno;


--  -   -   -   -   -   -   -   -
실습 3
실습 2에서 사번이 7600보다 크다

SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM EMP e join  dept d on(e.deptno = d.deptno and sal > 2500 and e.empno > 7600)
ORDER BY d.deptno;

--  -   -   -   -   -   -   -
실습 4
실습3에서 리서치 부서만 뽑아라

SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM EMP e join  dept d on(e.deptno = d.deptno and sal > 2500 and e.empno > 7600 and d.deptno = 20)
ORDER BY d.deptno;

--  -   -   -   -   -   --  --- --  -   -   -   --  -       --  -   -   

복사하라고 했던 버츄얼 폴더

개인피시에서오라클쓰고 쉽게 버리는 방법 
가상화

윈도우에 리눅스를 프로그램처럼 설치
리눅스에서 오라클을 설치
단점. win 프로그램으로  리눅스 프로그램으로 오라클이 돌아가기에 느리다

도입이유 기본 os하나만 가능
    컴이 좋더라도 하드웨어는 15~20만 사용














