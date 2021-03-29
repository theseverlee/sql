인덱스를 만들때 2개의 컬럼의 정렬에 따른 

JOB,ENAME 커럶으로 구성도니 IDX_EMP_03 인덱스 삭제

CREATE 객체타입 객체명
DROP 객체타입  객체명;

DROP INDEX IDX_emp_03;

CREATE INDEX IDX_EMP_04 ON EMP (ENAME, JOB);

EXPLAIN PLAN FOR
SELECT *
FROM EMP
WHERE JOB = 'MANAGER'
        AND ENAME LIKE 'C%';
        
SELECT *
FROM TABLE( DBMS_XPLAN.DISPLAY);

/*
Plan hash value: 4077983371
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_04 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
   2 - access("ENAME" LIKE 'C%' AND "JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
 */

DEPT에도 인덱스를 만들어서 해볼거임

SELECT ROWID, DEPT.* 
FROM DEPT;

-부서번호를 기준으로 만들자
CREATE INDEX IDX_DEPT_01 ON DEPT (DEPTNO);

EXPLAIN PLAN FOR
SELECT ENAME, DNAME, LOC
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO  --> 20 = DEPT.DEPTNO 
    AND EMP.EMPNO = 7788;
    
    
EMP
1. TABLE FULL ACCESS
2. EMP_01
3. EMP_02
4. EMP_04
DEPT
1. TABLE FULL ACCESS
2. DEPT_01
EMP 4 -> DEPT 2 : 8가지
DEPT 2 -> EMP 4 : 8가지
총 16가지
접근방법 * 테이블^개수

응답성 : OLTP (ONLINE TRANSACTION PROCESSING )
        항상 값은 같으나 과정이 다르다 근삿값루트
퍼포먼스 : OLAP ( ONLINE ANALYSIS PROCESSING )
            -> 은행 이자 계산
            
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);
/*
Plan hash value: 951379666
 
---------------------------------------------------------------------------------------------
| Id  | Operation                     | Name        | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |             |     1 |    32 |     3   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                 |             |       |       |            |          |
|   2 |   NESTED LOOPS                |             |     1 |    32 |     3   (0)| 00:00:01 |
|   3 |    TABLE ACCESS BY INDEX ROWID| EMP         |     1 |    13 |     2   (0)| 00:00:01 |
|*  4 |     INDEX RANGE SCAN          | IDX_EMP_01  |     1 |       |     1   (0)| 00:00:01 |
|*  5 |    INDEX RANGE SCAN           | IDX_DEPT_01 |     1 |       |     0   (0)| 00:00:01 |
|   6 |   TABLE ACCESS BY INDEX ROWID | DEPT        |     1 |    19 |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------
 4352610
   4 - access("EMP"."EMPNO"=7788)
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
*/
       
인덱스 단점 : 부가적인 데이터 공간이 필요하다(저장공간
            인덱스가 많아지면
            1. 테이블의 빈공간을 찾아 데이터를 입력한다.
            2. 인덱스의 구성 컬럼을 기준으로 정렬된 위치를 찾아 인덱스 저장
            3. 인덱스는 B*트리 구조이고, ROOT NODE부터 LEAF NODE까지의 DEPTH가 항상 같도록 밸런스 유지
            4. 즉 데이터 입력으로 밸런스가 무너질경우 밸런스를 맞추는 추가 작업이 필요
            2~4의 과정을 인덱스 별로 반복한다.
       
                상담일자 인덱스 - 데이터 특성상 0 우하향으로 트리가 성ㅇ장
                어느정도 지나면 밸런스 맞춰서 조정들어감
                
            
            인덱스가 많아 질 경우 위 과정이 인덱스 개수 만큼 반복 되기 때문에 UPDATE, INSERT, DELETE 시 부하가 커진다
            인덱스는 SELECT 실행시 조회 성능개선에 유리하지만 데이터 변경시 부하가 생긴다
            테이블에 과도한 수의 인덱스를 생성하는 것은 바람직 하지 않음
            하나의 쿼리를 위한 인덱스 설계는 쉬움
            시스템에서 실행되는 모든 쿼리를 분석하여 적절한 개수의 최적의 인덱스를 설계하는 것이 힘듬

            
인덱스 장점 : 소수의 데이터를 조회할때 유리(응답속도가 필요할 때)
            INDEX를 사용하는 INPUT/OUTPUT SINGLE BLOCK I/O
            다량의 데이터를 인덱스로 접근할 경우 속도가 느리다.( 2 ~ 3000)건정도
            웹시스템을 만드는데 인덱스를 안쓰는 경우는 없다 이말이야
테이블 엑세스
    / 테이블의 모든 데이터를 읽고서 처리를 해야하는 경우 -> 인덱스를 통해 모든 데이터를 테이블로 접근하는 경우보다 빠름
        / I/O기준이 MULTI BLOCK
       
실습 
할분만 해봐라

-- 달력만들기 쿼리
-- 이걸 잘하면 응용기술이 많으니 혼자서 만들정도 되면 실력이 상당할거다 쿼리떄문에 고생은 없을거임 ~~
-- 데이터의 행을 열로 바꾸는 방버
-- 레포트 ㅁ쿼리에서 활용 할 수 있는 예제

주어진 것: 년 월 6자리 문자열 202103
만들 것 : 해당 년월에 해당하는 달력 (7칸짜리 테이블)

20210301 -> 날짜
.
.
.
202010331

주자 IW
주간 요일 D
MAX보다 MIN구하는게 차이가 잇다 같은값이라면 MINtmWK
202103 -> 31만들기
-- LEVEL은 1부터 시작

SELECT  DECODE(D,1,IW+1, IW), 
        MIN(DECODE(D,1,DT)) S, MIN(DECODE(D,2,DT)) M,
        MIN(DECODE(D,3,DT)) T,MIN(DECODE(D,4,DT)) W,
        MIN(DECODE(D,5,DT)) TH, MIN(DECODE(D,6,DT)) F, MIN(DECODE(D,6,DT)) SA
FROM
            (SELECT TO_DATE(:YYYYMM,'YYYYMM') + (LEVEL -1)DT ,
                    TO_CHAR(TO_DATE(:YYYYMM,'YYYYMM') + (LEVEL -1 ),'D') D ,
                    TO_CHAR(TO_DATE(:YYYYMM,'YYYYMM') + (LEVEL -1),'IW') IW  
             FROM DUAL
             CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD'))
GROUP BY DECODE(D,1,IW+1, IW)  
ORDER BY DECODE(D,1,IW+1, IW) ;



SELECT TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD')
FROM DUAL;


SELECT TO_DATE(:YYYYMM,'YYYYMM') + (LEVEL -1)DT ,
                    TO_CHAR(TO_DATE(:YYYYMM,'YYYYMM') + (LEVEL -1 ),'D') D ,
                    TO_CHAR(TO_DATE(:YYYYMM,'YYYYMM') + (LEVEL -1),'IW') IW  
             FORM DUAL
             CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD';




계층쿼리 - 조직도, BOM ( BILL OF MATERIAL), 게시판(답변형 게시판)
        - 데이터의 상하 관계를 나타내는 쿼리
SELECT EMPNO, ENAME, MGR
FROM EMP;

사용방법 : 1. 시작위치 설정
            2. 행과 행의 연결 조건을 기술
SELECT EMPNO, LPAD(' ', (LEVEL-1)*10) | |ENAME 계층, MGR, LEVEL 
FROM EMP
START WITH EMPNO = 7839
CONNECT BY MGR = PRIOR EMPNO;
--AND DEPTNO = PRIOR DEPTNO;

CONNECT BY : 내가 읽은 행ㅇ의 사번 = 앞으로 읽을 행의 MGR칼럼
PRIOR --이전의 사전에 ,, 이미 읽은 데이터로 해석
START WITH EMPNO = 7839;            
읽은          읽을
킹사번 = 매니저칼럼 값이 킹ㅇ인녀석            
EMPNO = MGR

KING 1
    JONES 2
        SOCTT 3
            ADAMS 4
        FORD 3

SELECT LPAD('TEST', 1*30)
FROM DUAL;


계층쿠ㅓ리 방향에 따른 분류 / 상황에 따라서 쓴다 보통은 하향식
상향식 : 최하위 노드(LEAF)에서 자신의 부모를 방문하는 형태
하향식 : 최상위 노드(ROOT)에서 모든 자식 노드를 방문하는 형태

상향식
SIMTH부터 시작하는 부모따라간느 계층형 사향식 쿼리
SELECT EMPNO,MGR, LPAD( ' ', (LEVEL-1) * 10) ||ENAME,LEVEL
FROM EMP
START WITH EMPNO = 7369
CONNECT BY PRIOR MGR = EMPNO;
SMITH의 MGR값 = 내앞으로 읽을 EMPNOP


SELECT *
FROM DEPT_H;

최상위 노드부터 리트노드까지 탐색하는 계층쿼리
LPAD로 시각적 표현까지
SELECT DEPTCD, LPAD( ' ', (LEVEL-1) * 10) || DEPTNM, P_DEPTCD, LEVEL
FROM DEPT_H
START WITH P_DEPTCD IS NULL
CONNECT BY PRIOR DEPTCD = P_DEPTCD;

// PSUEDO CODE - 가상코드
CONNECT BY 현재행의 DEPTCD = 읽을 행의 P_DEPTCD

START WITH DEPTCD = 'dept0'
CONNECT BY PRIOR DEPTCD = P_DEPTCD;
       
실습 정보시스템부서 계층
SELECT DEPTCD, LPAD(' ', (LEVEL-1)*8) || DEPTNM DEPTNM, P_DEPTCD, LEVEL
FROM DEPT_H
START WITH DEPTCD = 'dept0_02'
CONNECT BY PRIOR DEPTCD = P_DEPTCD;
       
       
실습 디자인팀에서 상향식 계층 쿼리
SELECT DEPTCD, LPAD(' ', (LEVEL-1) *8) || DEPTNM DEPTNM, P_DEPTCD
FROM DEPT_H
START WITH DEPTCD = 'dept0_00_0'
CONNECT BY PRIOR P_DEPTCD = DEPTCD;

실습 4 - 노드아이로 계층형테ㅐ ㄱㄱ
SELECT *
FROM H_SUM;

SELECT LPAD(' ',(LEVEL-1)*3)|| S_ID S_ID, VALUE
FROM H_SUM
START WITH S_ID = '0'
CONNECT BY PRIOR S_ID = PS_ID;

START WITH TO_NUMBER(S_ID) = 0 --> 이렇게 되면 인덱스를 못쓴다.
DESC H_SUM;

    
       
       
       
       
       
       
       
       
       
       
       
       
       