INSERT 단건 , 복수;
INSERT INTO 테이블명 
SELECT .....


UPDATE 테이블명 SET 컬럼명1 = ( 스칼라 서브 쿼리),
                    컬럼명2 = ( 스칼라 서브 쿼리),
                    컬럼명3 = 'TEST';
업데이트를 고정된 값만 아니라 
서브쿼리를 가져와서 사용도 가능하다

--9999EMPNO 가지는 brown직원ename에 입력

INSERT INTO EMP (EMPNO, ENAME) VALUES (9999, 'brown');
-- INSERT INTO EMP (ename, EMPNO) VALUES ('brown', 9999);
-- 2개는 같은값이다 컬럼을 나열했을때는 맞는 값을 넣고,  컬럼을 안넣을때는 테이블 서식에 맞게 넣는다.

select *
from emp;

-- 9999직원의 부서번호와 잡정보를 스미스사원의 부서번호와 job정보로 업데이트 할거다


SELECT DEPTNO,JOB
FROM EMP
WHERE ENAME = 'SMITH';  

UPDATE EMP SET DEPTNO = (SELECT DEPTNO
                        FROM EMP
                        WHERE ENAME = 'SMITH'),
                JOB = (SELECT JOB
                        FROM EMP
                        WHERE ENAME = 'SMITH')
WHERE EMPNO = 9999;
-- 사실 자주나오는 사례는 아니다 / 데이터 양이 많아지면 비효율적이다
SELECT *
FROM EMP
WHERE EMPNO = 9999;
-- 위에 방법보다 좋은 방법은 MERGE라는건데 고급시간에 배울거다

DELETE : 기존의 존재하는 데이터를 삭제 - 그행을 지우는거다 - 컬럼에대한 기술이 없다
DELETE 테이블명
WHERE 조건 (참이면 삭제);

DELETE 테이블명;테이블에이는 행 모두 삭제

-- 삭제 테스트
-- 위에서 입력한 값

DELETE EMP
WHERE EMPNO = 9999;

매니져가 7698인 사번 모두 삭제
SELECT *
FROM EMP
WHERE EMPNO IN (SELECT EMPNO FROM EMP WHERE MGR = 7698);

DELETE EMP
WHERE EMPNO IN (SELECT EMPNO FROM EMP WHERE MGR = 7698);

ROLLBACK;

DBMS는 DML 문장를 실행하게 되면 LOG를 남긴다.
    오라클 버전에 따라서  UNDO(REDO) LOG
    
-- 함부로하면 로그가 안남기때문에 복구가안된다 롤백이 안된다 주의!!!
-- 로그를 남기지 않고 더 빠르게 데이터를 삭제하는 방법 : TRUNCATE
    .DML이 아니다 DDL임
    . ROLLBACK이 불가함 (복구 안됨)
    . 주로 테스트 환경에서 사용
    TRUNCATE TABLE 테이블명; -- 테이블의 모든 데이터르 ㄹ삭제
    
CREATE TABLE emp_test AS
SELECT *
FROM EMP;
    
    ROLLBACK;

SELECT *
FROM EMP_TEST;
    
TRUNCATE TABLE EMP_TEST;
    
    ROLLBACK;

-- 트랜잭션
DML문장이 시작될떄 트랜잭션도 시작
논리적인 일의 단위
COMMIT은 트랜잭션을 종료 데이터확정
롤백은 트랜잭션에서 실행한 DML문을 취소하고 트랜잭션 종료
첫 DML문을 실행함과 동시에 트랜잭션 싲가
이후 다른DML문 실행
--
ㅇㅖ시 -- 
    . 게시글 입력시 ( 제목 내용 복수개의 첨부파일)
    . 게시글 테이블, 게시글 첨부파일 테이블
    .1. DML 게시글 입력
    .2. DML 게시글 첨부파일 입력 INSERT가 2번일어난다
    . 1번이 정상적이고 2버이 에러라면? 빡구
-
읽기 일관성 ( 우선 말하자면 어렵다 - SQL작성시 어렵진 않는데 깊이공부해보고싶다 정도?)
--샘갠적으로는 이해하기 어려웟ㄷㅏ.
트랜잭션 결과가 다른 트랜잭션에 영향을 미치는지 정의 0 ~ 3까지 4단계
일관성레벨 임의로 수정하면 위험해 -- 그냥써~
오라클은 올려도 문제없으나 논의거치고 수장해야됨
ISOLATION LEVEL 0 ~ 3
트랜잭션에서 실행한 결과가 다른 트랜젝션에 어떻게 영향을 미치는지 정의한 레벨 단계
LEVEL 0 : READ UNCOMMITED
    -  DIRTY(변경이 가해졌다) READ
    -  커밋을 하지 않은 변경 사항도 다른 트랜잭션에서 확인 가능
    - 오라클 지원 안함
LEVEL 1 : READ COMMITED
    - 대부분의 DBMS 일기 일관성 설정 레벨
    - 커밋한 데이터만 다른 트랜잭션에서 읽을 수 있다.
    커밋하지 않은 데이터는 다른 트랜잭션에서 볼 수 없다
LEVEL 2 : REAPEATABLE READ
    - 선행 트랜잭션에서 읽은 데이터를 
        후행 트랜잭션에서 수정하지 못하도록 방지
    - 선행 트랜잭션에서 읽은 데이터를 
        트랜잭션의 마지막에 가서도 다시 조회를 해도 동일한 결과가 나오게끔 유지(반복적으로 읽더라도)
    - 신규 입력 데이터에 대해서는 막을 수 없다
            -> PHANTOM READ(유령 읽기) - 없던 데이터가 조회되는 현상
    - 기존 데이터의 대해서는 동일한 데이터가 조회되도록 유지
    
    오라클에서는 LEVEL 2에 대해서 공식적으로 지워하지 않으나
    FOR UPDATE 구문을 이요하여 효과적으로 만들어 낼수 있다.(다른사람이 사용못하게 잡아놓는것)
LEVEL 3 : Serializable Read 직렬화 읽기
    - 후행 트랜잭션에서 수정, 입력, 삭제한 데이터가 선행 트랜잭션에 영향을 주지 않는다.
    - 선 : 데이터 조회 14
    - 후 : 신규 데이터 입력 15
       선 : 데이터 조회 14
--------------------------------------------------------------------------
인덱스 ( 좀 답답하다 - 눈에 안보여 직접제어를 못해)
    - 눈에 안보임
    - 테이블의 일부 컬럼을 가지고서 사용하여 데이터를 정렬한 객체
        ==> 원하는 데이터를 빠르게 찾을 수 있다.
        ==> 일부 컬럼과 함께 그 컬럼의 행을 찾을 수 있는 ROWID가 같이 저장됨
    - ROWID : 테이블에 저장된 행의 물리적 위치, 집 주소 같은 개념
              주소를 통해서 해당 행의 위치를 빠르게 접근하는 것이 가능
                데이터가 입력이 될 때 생성된다.

select *
from emp
WHERE EMPNO = 7782;

select EMPNO, Rowid
from emp;
WHERE EMPNO = 7782;
-- 정렬이 되어있을때는 내가 찾고자하는 데이터를 빠르게 찾을 수 있따.

-- 실행계획 만들기
explain plan for
select *
from emp
WHERE EMPNO = 7782;

-- 실행계획 보는 법
select *
from table(dbms_xplan.display);

-- rows : 예측값 ( 안봐도 됨)
-- cost : 상대적 개념

--------------------------------------------------------------------------
| Id  | Operation         | Name | 여기는 없다고 봐도 됨                    |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    38 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    38 |     3   (0)| 00:00:01 |
            위는 모두 EMP테이블을 모두 읽었다.
--------------------------------------------------------------------------
   1 - filter("EMPNO"=7782)
       인덱스가 없다면 =     14건중에서 필터조건만 주고 나머지 버림/
                            버릴거면 조회 안해도 될까?
                            그래서 .인덱스가 필요하다~~~
            
----
오라클 객체 생성
CREATE 객체 타입(INDEX, TABLE......) 객체명 
    == 자바 INT 변수명 

인덱스 생성 전
CRAETE [UNIQUE]INDEX   인덱스이름 ON 테이블명(컬럼1, 컬럼2....);
            유니크 - 유일해야함 ㅡ.ㅡ
            
CREaTE UNIQUE INDEX PK_emp on emp(empno);            
            

-- 실행계획 만들기
explain plan for
select *
from emp
WHERE EMPNO = 7782;

-- 실행계획 보는 법
select *
from table(dbms_xplan.display);

| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    38 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    38 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
   2 - access("EMPNO"=7782)
필터는 찾아봤다이고, 엑세스는 찾아갔다 이렇지않다면 2시간이 걸리수도잇다
2-1-0
- 인덱스는 계속 추가할수있다.



-- 실행계획 만들기
explain plan for
select empno
from emp
WHERE EMPNO = 7782;

-- 실행계획 보는 법
select *
from table(dbms_xplan.display);

 1 -> 0
----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |     4 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |     4 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
   1 - access("EMPNO"=7782)

-- 인덱스를 삭제할거야
DROP INDEX PK_EMP;

-- 다시만들거임
UNIQUE는 중복이 없으면 사용해서쑤고 / 중복이잇으면 일반 인덱스
CREATE INDEX IDX_emp_01 on emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM EMP
WHERE EMPNO=7782;

SELECT *
FROM TABLE (DBMS_XPLAN.DISPLAY);

------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
            RANGE 여러건의 범위를 읽엇따. / 중복의 허용 여부 때문에 그렇다
------------------------------------------------------------------------------------------
Predicate Information (identified by operation id):
---------------------------------------------------
   2 - access("EMPNO"=7782)


-- 인덱스 하나더 만들어 볼거야
JOB컬럼기준으로 
CREATE INDEX IDX_emp_02 on emp(job);

EXPLAIN PLAN FOR
SELECT *
FROM EMP
WHERE JOB = 'MANAGER';

SELECT *
FROM TABLE (DBMS_XPLAN.DISPLAY);
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     3 |   114 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     3 |   114 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
            01인덱스는 배제 02에서 조건을 찾아갔는데 밑에도 조건에 참이네? 그다음꺼까지 읽었는데 
                                                                    이제 불일때까지 읽는거지
------------------------------------------------------------------------------------------
Predicate Information (identified by operation id):
--------------------------------------------------
   2 - access("JOB"='MANAGER')


EXPLAIN PLAN FOR
SELECT *
FROM EMP
WHERE JOB = 'MANAGER'
        AND ENAME LIKE'C%';

SELECT *
FROM TABLE (DBMS_XPLAN.DISPLAY);
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    38 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
Predicate Information (identified by operation id):
--------------------------------------------------
   1 - filter("ENAME" LIKE 'C%') -- 2번을 읽은 데이터를 읽어서 참만 조회 / 나머지는 버려
   2 - access("JOB"='MANAGER') -- 인덱스 위치를 빠르게 접근을 했따
   

CREATE INDEX IDX_emp_03 on emp(job, ename);

select job, ename, rowid
from emp
order by job,ename;

EXPLAIN PLAN FOR
SELECT *
FROM EMP
WHERE JOB = 'MANAGER'
        AND ENAME LIKE'C%';

SELECT *
FROM TABLE (DBMS_XPLAN.DISPLAY);   

------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
        d인덱스 이름이 바꿤 / 2건만 읽음 인덱스가 / 
------------------------------------------------------------------------------------------
Predicate Information (identified by operation id):
--------------------------------------------------
  2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')  -- 내가 찾아가서 찾았다
       filter("ENAME" LIKE 'C%')  -- 읽고나서 버렷다




EXPLAIN PLAN FOR
SELECT *
FROM EMP
WHERE JOB = 'MANAGER'
        AND ENAME LIKE '%C';

SELECT *
FROM TABLE (DBMS_XPLAN.DISPLAY);
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |

 -- 앞에 뭐가와도 상관이없다 -== 정렬의 의미가 없다. ==> 엑세스 할 필요가 없다.
   2 - access("JOB"='MANAGER') 4건 읽고 3건 찾았다
       filter("ENAME" LIKE '%C' AND "ENAME" IS NOT NULL)
-- 조회하는 데이터가 ㄱ없어도 오라클은 조회하려는 계획을 세웠다.
-- 이거이해안되도문제없지만 












