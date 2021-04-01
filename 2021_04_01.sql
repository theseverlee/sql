4월 1일 
-- VIEW는 TABLE과 유사한 객체
VIEW 객체
View는  테이블이나 다른 View 객체를 통해서 새로운 select문의 결과를 테이블 처럼
select에 귀속되는게 아니고 독립적
사용하는 경우
1. 필요한 정보가 한개의 테이블에 있지 않고, 여러개의 테이블에 분산되있는경우
2. 테이블에 들어있는 자료의 일부분만 필요하고 자료의 전체 row / 칼럼이 필요하지 않은 경우
3. 특정 자료에 대한 접근을 제한하는 경우

View는 왜 사용할까?
테이블과 유사한 기능
1. 보안 강화
2. Query 단순화, 실행의 효율성
3.table의 은닉성 위해서
CREATE [ OR RAPALVE ] [FORCE | NOFORCE ] VIEW 뷰이름[ (칼럼 LIST) ]
AS
    SELECT 문;
    [WITH CHECK OPTION;]
    [WITH READ ONLY;]

REPALCE를 쓸수있는게 적다 / ㅇ
포스 - 테이블 없어도 만들어도 만들수있는
노포스 - 
칼럼 리스트 - 
칼럼명제목 = 스키마

동의어 객체
다른dbms 자동의로 증가되는 값을 속성으로 정의(테이블 안에 키로 설정할만한게없어 (게시글)번호?)
시퀀스는 1씩증가되거나 감소되거나 자동으로 
인덱스 객체 -- 효율적으로 자료를 찾아가기 위해서 / 많이 만들어서는 안된다 적당히 만들어라

- 'OR REPLACE' : 뷰가 존재하면 대치되고 없으면 신규로 생성
- 'FORCE | NOFORCE' : 원본테이블의 존재하지 않아도 VIEW를 생성(FORCE)
                     생성불가 (NOFORCE)
- '컬럼LIST' : 생성된 VIEW의 컬럼명
- 'WITH CHECK OPTION' :  SELECT문의 WHERE절에 위배되는 경우 DML명령 실행 거부
- 'WITH READ ONLY' : 읽기 전용 뷰 생성/ CRUD를 못쓰게 막는것

실습_)
사원테이블에서 부모부서코드가 90인사원조회 / 사번 이름 부서명 급여




실습_)
회원테이블에서 마일리지가 3000이상인 회원의 회원번호, 회원명, 직어브 마일리지 조회

SELECT MEM_ID 회원번호, MEM_NAME 회원이름, MEM_JOB 직업, MEM_MILEAGE 마일리지
FROM MEMBER
WHERE MEM_MILEAGE >= 3000;
-- 현재 위상태는 저장을 할수없는 일회용 날라가기전에 뷰를 만들어버리자
-> 뷰생성 
CREATE OR REPLACE VIEW  V_MEMBER01
AS
    SELECT MEM_ID AS 회원번호, MEM_NAME AS 회원이름, MEM_JOB AS 직업, MEM_MILEAGE AS 마일리지
    FROM MEMBER
    WHERE MEM_MILEAGE >= 3000;
    
SELECT * FROM V_MEMBER01;
;
SELECT MEM_MILEAGE, MEM_NAME, MEM_JOB
FROM MEMBER
WHERE UPPER(MEM_ID) = 'C001';

못찾는다 - 나오면 이상한거임 ㅡ.ㅡ
대소문자 굳이 구별하지말고 대문자 소문자로 포맷팅하자
WHERE MEM_ID = 'C001'; -> WHERE UPPER(MEM_ID) = 'C001';

MEMBER테이블에서 신용환의 마일리지를 10000 으로 변경;
UPDATE MEMBER
    SET MEM_MILEAGE = 10000
WHERE MEM_NAME = '신용환';

SELECT*
FROM V_MEMBER01;
-- 테이블에서 내용이 바뀌면 뷰에서도 내용이 바로 반영된다.

생성했던 뷰에서 신용환의 마일리지를 10000 으로 변경;
UPDATE V_MEMBER01
    SET 마일리지 = 500
WHERE 회원이름 = '신용환';
-- 뷰에 저장된 컬럼명으로 써라
-- 알리아스로 됬을수도잇느니 확인하자
SELECT*
FROM V_MEMBER01;
-- 신용환이 없어졌음
-- 뷰를 만드는 조건이 마일리지가 3000 이상이니까
-- 마일리지가 500인 신용환은 뷰에서 쫓겨낫음
SELECT MEM_MILEAGE, MEM_NAME, MEM_JOB
FROM MEMBER
WHERE UPPER(MEM_ID) = 'C001';
-- 위같이 내용이 바뀌는걸 못하는걸 WITH ONLY READ
-- WITH CHECK OPTION
DML 작업이 뷰 영역에만 적용되도록 할 수 있습니다. 
즉, 한번 생성된 뷰에서 데이터의 변경이 없도록 VIEW 단에서 CRUD가 불가능합니다.
;
-- WITH CHECK OPTION 사용 VIEW생성
CREATE OR REPLACE VIEW  V_MEMBER01(MID,MNAME,MJOB,MILE)
AS
    SELECT MEM_ID AS 회원번호,
            MEM_NAME AS 회원이름,
            MEM_JOB AS 직업,
            MEM_MILEAGE AS 마일리지
    FROM MEMBER
    WHERE MEM_MILEAGE >= 3000
WITH CHECK OPTION;
--뷰 컬럼명 뷰여 3가지
뷰이름 뒤에 적는게 1등
원본 SELECT 문에 별칭 2등
해당 컬럼명이 뷰 컬럼명 3등

SELECT *
FROM V_MEMBER01;

(뷰 V_MEMBER01에서 신용환 마일리지 2000으뢰 변경;
UPDATE V_MEMBER01
   SET MILE = 2000
 WHERE UPPER(MID) = 'C001';
 
 (테이블 MEMBER에서 신용환 마일리지 2000으뢰 변경;
UPDATE MEMBER
   SET MEM_MILEAGE = 2000
 WHERE UPPER(MEM_ID) = 'C001';

-- WITH READ ONLY 사용해서 뷰 생성
CREATE OR REPLACE VIEW  V_MEMBER01(MID,MNAME,MJOB,MILE)
AS
    SELECT MEM_ID AS 회원번호,
            MEM_NAME AS 회원이름,
            MEM_JOB AS 직업,
            MEM_MILEAGE AS 마일리지
    FROM MEMBER
    WHERE MEM_MILEAGE >= 3000
WITH READ ONLY;

SELECT *
FROM V_MEMBER01;

UPDATE V_MEMBER01
   SET MILE = 5700
 WHERE UPPER(MID) = 'K001';
SQL 오류: ORA-42399: cannot perform a DML operation on a read-only view
DML불가 SELECT로 보기만 가능합니다;

CREATE OR REPLACE VIEW  V_MEMBER01(MID,MNAME,MJOB,MILE)
AS
    SELECT MEM_ID AS 회원번호,
            MEM_NAME AS 회원이름,
            MEM_JOB AS 직업,
            MEM_MILEAGE AS 마일리지
    FROM MEMBER
    WHERE MEM_MILEAGE >= 3000
WITH READ ONLY
WITH CHECK OPTION;
둘다 쓰면 아오대요 ORA-00933: SQL command not properly ended

hr계정에 있는걸 조회하고 싶을때
SELECT HR.DEPARTMENTS.DEPARTMENT_ID,
       HR.DEPARTMENTS.DEPARTMENT_NAME
  FROM HR.DEPARTMENTS;
        계정명.테이블명.컬럼명
        
실습_)
HR계정의 사원테이블에서 50번 부서에 속한 사원중 급여가 5000 이상인
사번,사원명, 입사일, 급여를 일기전용으로 view생성하시오
뷰이름은 V_EMP_SAL01
뷰가 생성된 후 뷰ㄱ와 테이블을 이요하여
해당 사원의 사번 사원명 직무명 급여를 출력


CREATE VIEW V_EMP_SAL01
AS
    SELECT EMPLOYEES.EMPLOYEE_ID ,
           EMP_NAME,
           EMPLOYEES.HIRE_DATE ,
           EMPLOYEES.SALARY 
    FROM EMPLOYEES
    WHERE EMPLOYEES.DEPARTMENT_ID =50
          AND EMPLOYEES.SALARY >= 5000
WITH READ ONLY;

select *
from v_emp_sal01;

select v.employee_id as 사번,
       v.emp_name as 사원명,
       j.job_title as 직무명,
       v.salary as 급여
  from employees e,JOBS j ,v_emp_sal01 v
 where e.employee_id = v.employee_id
   and e.job_id = j.job_id;
   
   커서라는게 있다 깜빡거는자리 = 커서(우리가 아는)
   오라클 커서 sql문이 실행되는 범위
   익명 커서
   명시적 커서





















