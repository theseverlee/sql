dsfadf0331 복습

SELECT empno, ename, deptno,
        COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

집계함수 : COUNT AVG MIN MAX SUM // 분석함수로 사용할 수 있다

실습 ANA2]
window function을 이용하여 모든사원에 대해 사원번호, 사원이름, 본인급여, 부서번호와 해당 사원이 속한 부서의 급여 평균을 조회하는 쿼리를 작성하세요
(급여 평균은 소수점 둘째자리까지 구한다.)



SELECT empno, ename, sal, deptno,
        ROUND(AVG(sal) OVER(PARTITION BY deptno),2) avg_sal,
        MIN(sal) OVER(PARTITION BY deptno) min_sal, --해당 부서의 가장 낮은 급여
        MAX(sal) OVER(PARTITION BY deptno) max_sal,  --해당 부서의 가장 높은 급여
        SUM(sal) OVER(PARTITION BY deptno) sum_sal,
        COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

-- 그룹바이없이도 정렬을 할 수 있다
-- 행을 하나만 구하거나 적게 구할때는 그룹바이가 속도가 더 빠른경우가 있다 // 남발해서는 안된다

LAG(col)
파티션별 윈도우에서 이전행의 컬럼 값

LEAD(col)
파티션별 윈도우에서 이후행의 컬럼 값

자신보다 급여 순위가 한단계 낮은 사람의 급여를 5번째 컬럼으로 생성
SELECT empno, ename, hiredate, sal,
        LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp
/*ORDER BY sal DESC;*/ -- 오라클에서 분석함수로 정렬을 해준다

-- 같은 데이터가 있어서 기준을 하나 더 정해준다

그룹내 행 순서 실습 ana5]
window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 입사일자, 급여, 전체 사원중 급여 순위가 1단계 높은 사람의 급여를 조회하는
쿼리를 작성하세요. (급여가 같을 경우 입사일이 빠른 사람이 높은순위)


SELECT empno, ename, hiredate, sal,
        LAG(sal) OVER (ORDER BY sal DESC, hiredate) lag_sal
FROM emp;


그룹 내 행 순서 실습 ana5_1]
window function를 사용하지 않고 모든 사원에 대해 사원번호, 사원이름, 입사일자, 급여, 전체 사원중 급여 순위가 1단계 높은 사람의 급여를 조회하는 쿼리를 작성하세요
(급여가 같을 경우 입사일이 빠른 사람이 우선순위)

SELECT empno, ename, hiredate, sal
FROM emp;

SELECT a.empno, a.ename, a.hiredate, a.sal, b.sal
FROM
    (SELECT a.*, ROWNUM rn
    FROM
    (SELECT empno, ename, hiredate, sal
    FROM emp
    ORDER BY sal DESC, hiredate) a) a,
    
    (SELECT a.*, ROWNUM rn
    FROM
    (SELECT empno, ename, hiredate, sal
    FROM emp
    ORDER BY sal DESC, hiredate) a) b
WHERE a.rn - 1 = b.rn(+)
ORDER BY a.sal DESC, a.hiredate;

-- 로우넘을 바로 못쓰는 이유 sql의 실행순서 때문에 인라인뷰로 감싼다
-- 함수를 못쓰므로 조인으로 처리해야한다
-- 1에서 -1때문에 0값이 되어 1개가 안나오므로 아우터조인을 써서 null값이어도 나타내준다

그룹내 행 순서 실습 ana6]
담당업무 영역지정
SELECT empno, ename, hiredate, job, sal,
        LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp;


분석함수 OVER ([][][])
-- 파티션 바이 == 영역지정해주면 쓴다


LAG, LEAD 함수의 두번째 인자 : 이전, 이후 몇번째 행을 가져올지 표기
SELECT empno, ename, hiredate, sal,
        LAG(sal, 2) OVER (ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

SELECT empno, ename, hiredate, sal,
        LEAD(sal, 2) OVER (ORDER BY sal DESC, hiredate) lag_sal
FROM emp;


그룹 내 행 순서 - 생각해 보기 실습 no ana3]

SELECT a.empno, a.ename, a.sal, b.sal
FROM
(SELECT a.* , ROWNUM rn
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a) a,
(SELECT a.* , ROWNUM rn
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a) b
WHERE a.rn = b.rn
ORDER BY sal;

---- 선생님 풀이

1. ROWNUM
2. INLINE VIEW
3. NON-EQUI-JOIN
4. GROUP BY

SELECT a.empno, a.ename, a.sal, SUM(b.sal)
FROM
    (SELECT a.*, ROWNUM rn
    FROM
    (SELECT empno, ename, sal
    FROM emp
    ORDER BY sal, empno) a) a,

    (SELECT a.*, ROWNUM rn
    FROM
    (SELECT empno, ename, sal
    FROM emp
    ORDER BY sal, empno) a) b
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal
ORDER BY a.sal, a.empno;


분석함수() OVER ([PARTITION][ORDER][WINDOWING])
WINDOWING : 윈도우 함수의 대상이 되는 행을 지정
UNBOUNDED PRECEDING : 특정 행을 기준으로 모든 이전행(LAG)
    n PRECEDING : 특정 행을 기준으로 n행 이전행(LAG)
CURRENT ROW : 현재행
UNBOUNDED FOLLOWING : 특정 행을 기준으로 모든 이후행(LEAD)
    n FOLLOWING : 특정 행을 기준으로 n행 이후행(LAG)


SELECT empno, ename, sal, 
        SUM(sal) OVER(ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum,
        SUM(sal) OVER(ORDER BY sal, empno ROWS UNBOUNDED PRECEDING) c_sum
FROM emp
ORDER BY sal, empno;

-- 윈도잉의 기본값은 현재행이다
-- 길어도 기본방법을 쓰자 명확하기 때문에
-- 누적합에 적합해서 이 방법을 많이 쓴다

SELECT empno, ename, sal, 
        SUM(sal) OVER(ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) c_sum
FROM emp
ORDER BY sal, empno;

그룹내 행 순서 실습 ana7]
사원번호 사원이름 부서번호 급여정보를 부서별로 급여, 사원번호 오름차순으로 정렬했을때, 자신의 급여와 선행하는 사원들의 급여합을 조회하는 쿼리를 작성하세요(window 함수 사용)

SELECT empno, ename, deptno, sal, 
        SUM(sal) OVER(PARTITION BY deptno ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp
ORDER BY sal, empno;



rows 와 range의 차이

rows == 물리적인 row(행)
range == 같은 값을 하나의 행으로 본다


SELECT empno, ename, sal, 
        SUM(sal) OVER(ORDER BY sal ROWS UNBOUNDED PRECEDING) c_sum,
        SUM(sal) OVER(ORDER BY sal RANGE UNBOUNDED PRECEDING) range_sum,
        SUM(sal) OVER(ORDER BY sal) no_win_c_sum, -- ORDER BY 이후 윈도윙이 없을 경우 기본 설정 : RANGE UNBOUNDED PRECEDING
        SUM(sal) OVER() no_ord_c_sum
FROM emp
ORDER BY sal, empno;

-- 로우는 자기 값의 행만 보는것이고 레인지는 같은 값을 하나의 행으로 본다
-- 윈도윙을 적용하지 않으면 레인지가 기본값이 된다
-- 오더바이를 빼면 전체합이 나온다
-- 윈도윙은 오더바이가 무조건 있어야한다 행의 순서를 정해줘야 분류가 되기 때문에

RATIO TO REPORT
PERCENT RANK
CUME DIST
NUCE


수업시간에 잘 이해한 경우

SQL
1.전문가로 가는 지름길 오라클실습
버전이 달라서 테이블 사이즈를 올려줘야한다 
2.불친절한 SQL 프로그래밍

데이터모델링
1.관계형 데이터 모델링 프리미엄가이드 김기창

컨설팅
ENCORE ==> 대용량 데이터베이스 솔루션(조광원 인터파크) 강의 동영상 찾아보기
B2EN
DBIAN
OPEN MADE

성능 측정도구
EXEM

2. 새로쓴 대용량 데이터베이스 솔루션
3. 오라클 성능 고도화 원리와 해법 1,2

교양
1. 나는 프로그래머다

정리
1.필수 각각 게시판 작성 : JSP/Servlet , Spring
2.SI/SM업무의 베이스는 데이터 : SQL
3.언제까지 시키는 것만 할텐가 : Modeling
4.스스로의 길을 찾으세요 : 관심 사항

3주 수업 정리
수업목표 : 설계도를 보고 주어진 조건을 만족하는 SQL을 작성할 수 있다

강의
T아카데미 3강 ~ 7강 == RDBMS와 SQL맛보기
조인 서브쿼리까지