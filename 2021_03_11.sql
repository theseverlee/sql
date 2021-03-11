select * from emp;

SELECT *
FROM EMP;

 -- 데이터를 조회하는 방법에 대해서 
--  FROM : 조회할 데이터 테이블을 명시
    -- SELECT : 테이블에 잇는 컬럼명 , 조회하고자 하는 컬렴명
    --          테이블의 모든 컬럼을 조회할 경우 *를 기술 아스테리스크
SELECT *
FROM EMP;
-- EMPNO : 직원번호, ENAME : 직원이름, JOB : 담당업무, MER : 상위 담당자
-- HIREDATE : 입사일자, SAL : 급여  COMM : 커미션보너스, DEPTNO : 부서번호  
-- 위에 8개는 적어도 외우자!!

-- 컬럼 구분은 나열일 아니라 콤마를 찍어서 구분을 해줘야 한다.
SELECT EMPNO, ENAME
FROM EMP;
