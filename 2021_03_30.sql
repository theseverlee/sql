계층 쿼리 진도
- SQL 실행 순서
FROM ->[ START WITH ] -> WHERE ->  GROUP BY -> SELECT -> ORDER BY

SELECT
FROM
WHERE           -- 계층쿼리가 완성된 다음에 행을 제ㅎ나한다.
START WITH
CONNECT BY      -- 계층구조를 만들 때 적용을 한다.
GROUP BY
ORDER BY

가지치기 : pRUNING BRANCH;
SELECT EMPNO, LPAD(' ', (LEVEL-1)*5) || ENAME ENAME, MGR, JOB
FROM EMP
WHERE JOB != 'ANALYST'              
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR;
-- 순전히 애널리스트만 아닌녀석만 나온다
-- 위보다는 아래의 경우가 많다 계층쿼리에 조건을 적용
SELECT EMPNO, LPAD(' ', (LEVEL-1)*5) || ENAME ENAME, MGR, JOB
FROM EMP
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR AND JOB != 'ANALYST';
--                 이거 하고      애널리스트가 아닌것만 찾아간다.

계층쿼리와 관련된 특수 함수 3가지
유용하다
1. CONNECT_BY_ROOT(컬럼) : 해당 컬럼의 (ROOT)최상위 노드의 컬럼 값

2. SYS_CONNECT_BY_PATH(컬럼, '구분자 문자열') 
            : 최상위 행부터 현재 행까지의 해당 컬럼의 값을 구분자로 연결한 문자열
                ex) -KING-JONES-SCOTT-ADAMS
    LTRIM(칼럼, ' 지울 문자') 같이 ㅁ낳이 쓰인다
    문자열 자르기 좀더 배워
    SUBSTR
    INSTR('TEST', 'T') -- t라는 문자가 몇번째 잇니
    INSTR('TEST', 'T', 2) -- t라는 문자가 2번쨰부터 시작해서 몇번때 잇니?

3. CONNECT_BY_ISLEAF : 자식CHILD가 없는  leaf node 여부 0 = false(no leaf node) / 1 = true(leaf node)
SELECT LPAD(' ', (LEVEL-1)*5) || ENAME ENAME,
        CONNECT_BY_ROOT(ENAME) ROOTENAME,
        LTRIM(SYS_CONNECT_BY_PATH(ENAME, '-'), '-') pathnam,
        CONNECT_BY_ISLEAF
FROM EMP
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR;

100개의 쿼리중 계층쿼리가 한 10 ~ 15개정도 차지한다. 15%
계층잇는 데이터가 생각보다 많다
-------------
실습
SELECT SEQ, PARENT_SEQ, LPAD(' ',(LEVEL-1)*10) || TITLE TITLE
FROM BOARD_TEST
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR SEQ = PARENT_SEQ
ORDER SIBLINGS BY GN DESC,SEQ ASC;

DESC BOARD_TEST


- 계층구조 유지하면서 정렬하기
ORDER SIBLINGS BY 로 정렬하기

시작(ROOT)글은 작성 순서의 역순으로
답글은 작성 순서대로 정렬

---------   -   -   -
시작글부터 관련 답글까지 그룹번호를 부여하기위해 새로운 컬럼 추가

ALTER TABLE board_test ADD (gn NUMBER);
DESC BOARD_TEST

UPDATE BOARD_TEST SET GN = 1
WHERE SEQ IN (1,9);

UPDATE BOARD_TEST SET GN = 2
WHERE SEQ IN (2,3);

UPDATE BOARD_TEST SET GN = 4
WHERE SEQ NOT IN (1,2,3,9);

COMMIT;

SELECT *
FROM BOARD_TEST

그룹번호 넣어서 새로운 정렬넣기;

SELECT GN,SEQ, PARENT_SEQ, LPAD(' ',(LEVEL-1)*10) || TITLE TITLE
FROM BOARD_TEST
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR SEQ = PARENT_SEQ
ORDER SIBLINGS BY GN DESC,SEQ ASC;

-- 위 아래 비교 하기

SELECT *
FROM
    (SELECT  CONNECT_BY_ROOT(SEQ) ROOTSEQ,
            SEQ, PARENT_SEQ, LPAD(' ',(LEVEL-1)*10) || TITLE TITLE
    FROM BOARD_TEST
    START WITH PARENT_SEQ IS NULL
    CONNECT BY PRIOR SEQ = PARENT_SEQ)
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR SEQ = PARENT_SEQ      
ORDER BY ROOTSEQ DESC, SEQ;

CONNECT_BY_ROOT(SEQ) ROOTSEQ 이걸로 상위노드찾기


-- 페이징 처리로 조회하깅 
SELECT *
FROM
			(SELECT ROWNUM rn, A.*
			 FROM
                (SELECT *
                 FROM
                     (SELECT  CONNECT_BY_ROOT(SEQ) ROOTSEQ,
                             SEQ, PARENT_SEQ, LPAD(' ',(LEVEL-1)*10) || TITLE TITLE
                      FROM BOARD_TEST
                      START WITH PARENT_SEQ IS NULL
                      CONNECT BY PRIOR SEQ = PARENT_SEQ)
                      ORDER BY ROOTSEQ DESC, SEQ)A )
WHERE rn BETWEEN 6	AND 10;


--------    -   -   -   -   -
분석함수
( 주식 전일대비 

SELECT ENAME
FROM EMP
WHERE SAL = (SELECT MAX(SAL)
             FROM EMP
             WHERE DEPTNO = 10);

분석 함수 (window 함수)   
    SQL에서 행간 연산을 지원하는 함수
    
    해당 행의 범위를 넘어서 다른 행과 연산이 가능
    . SQLD의 약점을 보완
    . 이전행의 특정 컬럼을 참조
    . 특정 범위의 행들의 컬럼의 합
    . 특정 범위의 행 중 특정 컬럼을 기준으로 순위, 행번호 부여
    
    .SUM, COUNT, MAX, MIN, AVG, 
    . RANK, LEAD, LAG.... 많다
    ;
    실습 1
    부서별 급여 순위 구하기
    
SELECT A.*, 
FROM
(SELECT ENAME, SAL, DEPTNO
FROM EMP
ORDER BY DEPTNO, SAL DESC)A;



SELECT E.ENAME, E.SAL, E.DEPTNO
FROM EMP E JOIN EMP M ON( E.DEPTNO = M.DEPTNO)
ORDER BY DEPTNO, SAL DESC;


SELECT *
FROM
(
(
),
(SELECT B.*, ROWNUM 
FROM 
(SELECT ENAME, SAL, DEPTNO
FROM EMP
WHERE DEPTNO = 20
ORDER BY DEPTNO, SAL DESC)B),
(SELECT C.*, ROWNUM 
FROM 
(SELECT ENAME, SAL, DEPTNO
FROM EMP
WHERE DEPTNO = 30
ORDER BY DEPTNO, SAL DESC)C)
);

SELECT *
FROM
(SELECT ROWNUM, A.*
FROM
(SELECT DEPTNO
FROM EMP
ORDER BY DEPTNO) A) AA
JOIN
(SELECT DEPTNO,COUNT(*) CNT
FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO) BB ON ( AA.DEPTNO = BB.DEPTNO);

SELECT Q.ENAME, Q.SAL, Q.DEPTNO, W.RANK
FROM 
((SELECT ENAME, SAL, DEPTNO
FROM EMP
ORDER BY DEPTNO, SAL DESC) Q,

(SELECT ROWNUM RN, RANK
FROM 
(SELECT A.RN RANK
FROM 
(SELECT ROWNUM RN 
FROM EMP) A,

(SELECT DEPTNO,COUNT(*) CNT
FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO) B
WHERE A.RN <= B.CNT
ORDER BY B.DEPTNO, A.RN))) W
WHERE Q.RN = W.RN;




SELECT ENAME, SAL, DEPTNO, RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) SAL_RANK 
FROM EMP;
-- ORDER BY 하지 않아도 내부적으로 정렬이 되기때문에 위와같이 해도 문제없다.

RANK() OVER ( PARTITION BY 칼럼 ORDER BY 컬럼 DESC)
PARTITION BY DEPTNO = 같은 부서코드를 같는 ROW를 그릅으로 묵는다
ORDER BY 컬럼 DESC =  그룹내에서 SAL로 ROW순서 정한다.
랭크 파티션 단위안에서 정렬 순서대로 순위 매긴다

SELECT WINDOW FUNCTION( [ARG] )
    OVER ( [PARTITION BY 칼럼] [ ORDER BY 칼럼 ] [WINDOWING] )
                     1                   2           3
    1. D영역설정
    2. 순서설정
    3. 범위 설정

= 순위 관련된 함수 3가지( 차이점 : 중복값을 어떻게 처리하는가 )
RANK : 동일값 = 동일 순위 , 후순위 = 동일값만 건너뛴다
            EX) 1등 1등 2명이면 그다음은 3위
DENSE_RANK : 동일값 = 동일 순윗, 후순위 = 이어서 부여한다
            EX) 1등 1등 2명이면 그다은은 2위
ROW_NUMBER : 중복없이 행에 순차적인 번호를 부여 (ROWNUM)
;
SELECT ENAME, SAL, DEPTNO, 
        RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) SAL_RANK ,
        DENSE_RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) SAL_DENSE_RANK ,
        ROW_NUMBER() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) SAL_ROW_NUMBER 
FROM EMP;


SELECT WISDOW_FUCNTION( { 인자 } ) OVER  ( [ PARTITION BY 컬럼 ] [ ORDER BY 컬럼 ]  )
FROM

PARTITION BY  :  영역설정
ORDER BY (ASC / DESC) : 영역 안에서의 순서 정하기
;

실습 1
SELECT EMPNO, ENAME, SAL,
       RANK() OVER(PARTITION BY SAL ORDER BY EMPNO DESC) SAL_RANK
FROM EMP;


SELECT   COUNT(*)
FROM EMP;

SELECT EMPNO, ENAME, SAL, DEPTNO,
        RANK() OVER ( ORDER BY SAL DESC, EMPNO) SAL_RANK,
        DENSE_RANK() OVER ( ORDER BY SAL DESC, EMPNO) SAL_RANK,
        ROW_NUMBER() OVER ( ORDER BY SAL DESC, EMPNO) SAL_RANK
FROM EMP;

 실습 
 
SELECT EMPNO, ENAME, DEPTNO,
        DENSE_RANK() OVER( ORDER BY DEPTNO)* CNT
FROM EMP;

 COUNT(SELECT COUNT(*)
                FROM EMP
                GROUP BY DEPTNO)


SELECT EMP.EMPNO, EMP.ENAME, EMP.DEPTNO, B.CNT
FROM EMP,
(SELECT DEPTNO, COUNT(*) CNT
FROM EMP
GROUP BY DEPTNO) B
WHERE EMP.DEPTNO = B.DEPTNO
ORDER BY EMP.DEPTNO;

위아래 같음 

SELECT EMPNO, ENAME, DEPTNO,
    COUNT(*) OVER (PARTITION BY DEPTNO) CNT
FROM EMP;




