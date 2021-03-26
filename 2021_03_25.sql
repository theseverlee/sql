3월 25일

sub 실습 6)
사이클 테이블 1번이 먹는걸랑 2도 먹는거 조회해라
                       
SELECT *
FROM CYCLE
WHERE CID = 1
    AND PID IN (   SELECT PID
                    FROM CYCLE
                    WHERE CID = 2);
2번 고객이 먹는 제품에 대해서만 
SELECT *
FROM CYCLE
WHERE CID = 2;

SUB 7)
6번에서 고객명이랑 제품명추가 -- 프롬절 테이블 기술 순서 상과없다.
SELECT *
FROM CYCLE
WHERE CID = 1
    AND PID IN (   SELECT PID
                    FROM CYCLE
                    WHERE CID = 2);
    
                    
SELECT *
FROM PRODUCT;

SELECT *
FROM CUSTOMER;

SELECT *
FROM CYCLE, CUSTOMER, PRODUCT
WHERE CYCLE.CID = 1
    AND CYCLE.CID = CUSTOMER.CID
    AND CYCLE.PID = PRODUCT.PID
     AND CYCLE.PID IN (   SELECT PID
                    FROM CYCLE
                    WHERE CID = 2);
    
    -- 잘안되면 스프레드 시트에 그려봐라

연산자 = 몇항인가?
대다수는 이항 연산자 1  + 5
삼항
단항 ++ --
-- 마지막 연산자
EXISTS 서브쿼리 연산자: 단항연산자임 
(NOT) IN : WHERE 컬럼|EXPRESSION IN (값.1.2.3.)
(NOT) EXISTS : WHERE EXISTS ( 서브쿼리)
            ==> 서브쿼리 실행결과로 조회되는 행이 **** 하나라도 **** 있으면 참 / 없으면 거짓
            ==> 값이 중요한게 아님 ! 서브쿼리에 관습적으로 'X'를 많이 사용함
            ==> EXISTS  연산자와 사용되는 서브쿼리는 상호연관, 비상호연관 서브쿼리 둘다 사용 가능 ㅇㅇ
            ==> 행을 제한하기 위해서 상호연관 서브쿼리와 사용되는 경우가 일반적이다.
            -- 서ㅓ브쿼리에서 EXISTS 연산자를 만족하는 행이 하나라도 발견을 하면 더이상 진행하지 않고 효율적으로 일을 끊는다.
            -- 서브쿼리가 1000건이여도 10번째 행에서 EXISTS 연산을 만족하는
                            --행을 발견하면 나머지 990건 데이터는 확인도 안한다.
            
-- 매니져가 존재하는 직원;
SELECT *
FROM EMP
WHERE MGR IS NOT NULL;

SELECT *
FROM EMP E
WHERE EXISTS (SELECT 'X'
                FROM EMP M
                WHERE E.MGR = M.EMPNO);
-- 상호연관 쿼리  - 메인 -서브

SELECT *
FROM EMP E
WHERE EXISTS (SELECT 'X'
                FROM DUAL);
-- 비상호            


SELECT COUNT(*)
FROM EMP
WHERE DEPTNO = 10;
-- 1000억 건 데이터 전부 조회
SELECT *
FROM DUAL
WHERE EXISTS ( SELECT 'X' FROM EMP WHERE DEPTNO =10);
-- 100번째 잇으면 거기서 끝

실습 9)
사이클 프로덕트 이용 1번 고객 애음료 EXISTS 이용 조회

SELECT PID, PNM
FROM PRODUCT
WHERE NOT EXISTS ( SELECT 'X'
                FROM CYCLE
                WHERE CID =1
                    AND CYCLE.PID = PRODUCT.PID);

SELECT *
FROM PRODUCT
WHERE NOT EXISTS ( SELECT 'X'
                FROM CYCLE
                WHERE CID = 1
                AND CYCLE.PID = PRODUCT.PID);




---------------------------------------------------------
집합연산 
UNION      { A , B ) U { A ,  C } = { A, B ,C }
        ==> 수학에서 이야기하는 일반적인 합집합 / 중복을 제거
        == > 합집합, 2개의 SELECT 결과를 하나로 합친다. 단, 중복되는 데이터는 중복을 제거한다.
UNION ALL   { A , B ) U { A ,  C } = { A, A, B ,C }
        ==> 중복을 허용하는 합집합  UNION보다 연산속도가 빠르다// 중복없으면 이거써보자
INTERSECT : 교집합
MINUS : 차집합 공통되는 부분을 뺸거

-- 데이터를 ㅗ학장하는 바업ㅂ
-- 수학시간 배운 집합 개념과 동일
-- 집합에서는 중복, 순서가 없다.
==> 행을 확장 - 위아래 
        - 위 아래 집합의 COL의 개수와 타입이 일치해야한다.



SELECT  EMPNO, ENAME
FROM EMP
WHERE EMPNO IN (7369, 7499)

UNION 

SELECT  EMPNO, ENAME
FROM EMP
WHERE EMPNO IN (7369, 7521);
-- 비교하는 컬럼의 개수가 같아야됨



UNION ALL : 중복을 허용하는 합집합
            중복제거로직이 없기 때문에 속도가 빠르다
            합집합 하려는 집합간에 중복이 없다는것을 알고 있을 경우 UNION 연산자보다 ALL 연산자가 유리하다
SELECT  EMPNO, ENAME
FROM EMP
WHERE EMPNO IN (7369, 7499)

UNION ALL

SELECT  EMPNO, ENAME
FROM EMP
WHERE EMPNO IN (7369, 7521);


INTERSECT 두개의 집합중 중복되는 부분만 조회

SELECT  EMPNO, ENAME
FROM EMP
WHERE EMPNO IN (7369, 7499)

INTERSECT

SELECT  EMPNO, ENAME
FROM EMP
WHERE EMPNO IN (7369, 7521);

MINUS 한쪽 집합에서 다른 한쪽 집합을 제외한 나머지 요소들을 반환

SELECT  EMPNO, ENAME
FROM EMP
WHERE EMPNO IN (7369, 7499)

MINUS

SELECT  EMPNO, ENAME
FROM EMP
WHERE EMPNO IN (7369, 7521);

-- 교환법칙 - 순서를 바꾸면 값이 다를 수 있다.
    ==> A U B  ==  B U A (UNION, UNION ALL)
    ==> A ^ B  ==  B ^ A
    ==> A - B !=   B - A ( 집합의 순서에 따라 결과가 달라질 수 있다 [ 주의 ]
    
집합연산 특징 
1. 집합연산의 결과로 조회되는 데이터의 컬럼 이름은 첫번째 집합의 컬럼을 따른다. 모든집합에 알리아스 안줘도됨
2. 집합연산의 결과를 정렬하고 싶으면 가장 마지막 집합 뒤에 ORDER BY를 기술한다.
                . 개별 집합에 ORDER BY 를 사용한 경우 에러
                단. ORDER BY를 적용한 인라인 뷰를 사용하는 것은 가능
3. 중복은 제거 된다 ( 예외 UNION ALL)
4. 참고.옵션  9I 이전 버전은 그룹연산 하게되면 자동 오름차순 정렬 => 이후버전 : 정렬 보장하지 않음
    
-----------------------------------------------------------------------------------------
DML
    . SELECT
    . 데이터 신규 입력 INSERT
    . 기존 데이터 수정 UPDATE
    . 기존 데이터 삭제 DELETE
    
INSERT 문법
INSERT INTO 테이블명 [ ({ column }) ] VALUES ({VALUE})
INSERT INTO 테이블명 ( 컬럼명1, 컬럼명2,.....)
            VALUES ( 값1,   값2, ....... )
    
만약 테이블에 존재하는 모든 컬럼에 데이터를 입력하는 경우 컬럼을 생략 가능하다ㅑ
값을 기술하는 순서를  테이블에 정의된 컬럼 순서와 일치시킨다.
1. 단건으로 입력
INSERT INTO 테이블명 VALUES( 값 1, 값 2,...);

INSERT INTO DEPT (DEPTNO,DNAME,LOC)
            VALUES (99, 'ddit', 'daejeon');            

select *
from dept;
          -- 중복제거하려면 추가적으로 설정을 해야한다.
          
desc dept;
- 널?에 아무것도 없는데 ==> 널 허용 한다는 소리임
-- 반면 emp 조회하면 not null잇음 허용 안한다.

insert into emp (EMPNO,ename, job) 
                values (9999,'brown', 'RANGER');
    
select *
from EMP;    
    
insert into emp (EMPNO,ename, job, hiredate, sal, comm) 
                values (9998,'sally', 'RANGER', to_date('2021-03-24', 'YYYY-MM-DD'), 1000, NULL);
    
2. 여러건을 한번에 입력하기
INSERT INTO 테이블명
SELECT 쿼리;
    
INSERT INTO DEPT
SELECT 90, 'DDIT', '대전' FROM DUAL UNION ALL 
SELECT 80, 'DDIT8', '대전' FROM DUAL;
    
    SELECT *
    FROM DEPT;

ROLLBACK;
SELECT *
FROM EMP;
    
-------------------
UPDATE 테이블에 존재하는 기존 데이터의 값을 변경;

UPDATE 테이블명 SET 컬럼명1 = 값 1, 컬럼명2 = 값 2, 컬럼명3 값 3,....
WHERE ;

SELECT *
FROM DEPT;
-- 부서번홀 99번 부서정보를 부서명은 = 대덕IT로 LOC = 영민빌딩으로 변경

UPDATE DEPT SET DNAME = '대덕IT', LOC = '영민빌딩'
WHERE DEPTNO = 99;

-- WHERE절이 누락 되었는지 확인 / 누락된 경우 테이블의 모든 행에 대하여 업데이트를 진행 // DB마다 롤백커밋설정이 다름
------------------------------------











