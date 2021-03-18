ROUND 
    년원일엥서도 반올림이 가능하다
    자주쓰이는건아닌다
TRUNC
    내림
    ㅇ위와 같다

/*    
날짜 관련 함수

MONTHS_BETWEEN : DATE 타입의 인자가 2개 들어간다 / start date, end date, 반환값 : 두 일자 사이의 개월수
--- 이놈은 숫자를 반환 / 잘안씀
--- 아래는 date 반환
ADD_MONTHS : 몇달뒤 몇일인가  ****
인자 : date, number 더할 개월수  == date뒤 부터 x개월 뒤의 날짜

date + 90 : 일수를 구할 수 있다.
1/15뒤 3개월 뒤 날짜 / 90일수도 잇꼬 아닐수도 있따.
그러니까 add먼뜨로 구하자

NEXT_DAY =   ***
인자 : date, number(weekday, 주간일자) == date이후의 가장 첫번째 주간일자에 해당하는 date를 반환
일요일 1 월 2 ~ 토 7
LAST_DAY  ***
인자 : date == date가 속한 월의 마지막 일자를 date로 반환

*/


-- 잘안쓰이지만 알아는 둬라
MONTHS_BETWEEN
SELECT ename, TO_CHAR(hiredate, 'yyyy/mm/dd HH24:mi:ss') hiredate,
        MONTHS_BETWEEN(SYSDATE, hiredate) months_between,
        ADD_MONTHS(SYSDATE, 5) ADD_MONTHS,
        ADD_MONTHS(TO_DATE('2021-02-15', 'YYYY-MM-DD'), 5) ADD_MONTHS2,
        NEXT_DAY(SYSDATE, 1) NEXT_DAY,
        LAST_DAY(SYSDATE) LAST_DAY,
        TO_DATE(TO_CHAR(SYSDATE, 'YYYYMM') || '01', 'YYYY-MM-DD')FIRST_DAY
FROM EMP;

/*    
-- SYSDATE 이용 현대 월의 첫날구하기
-- SYSTDE 년원까지 문자 + || '01'
202103 || 01 --> 20210301
*/

-- 문제 파라미터 YYYYMM혁싱 문자사용 해당년월 ㅁ 마지막일자 구하시오 LAST_DAY(날짜)사용할라면 문자로 바꿔여ㅑ한다
SELECT :YYYYMM, TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM,'YYYYMM')), 'DD')
FROM DUAL;
-- 원하는 값을 넣기위해 날짜를 문자로 바꾸고
-- 라스트데이로  마지막 일자를 뽑고
-- 투캐릭터로 원하는 포맷을 뽑는다.
-- 두번쨰값은 3월넣으며 31

SELECT :YYYYMM, TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'MMDD')
FROM DUAL;
/*8
형변환(숫자 문자 날짜)
- 명시적 형변환
    - TO_DATE, TO_CHAR, TO_NUMBER
- 묵시적 형변환
    - 
 
 */
    
SELECT *
FROM EMP
WHERE empno = '7369';


-- NUMBER
    9 숫자 - 값을 모르면 많이넣느다
    0 강제로 0
    , 1000자리
    . 소수점 
    w 화페단위
    $ 달러표시
-- 잘 안쓴따


NULL 처리 함수 : 4가지
1. NVL(ecpr1(컬럼도 가능), expt2) // 1이 null값이 아니면 1쓰고, 1이 null값이면 2쓴다
자바 :  if(expr1 == null)
        sysout(expr2)
        else
        sysout(expr1)

-- emp테이블에서 comm컬럼의 값이 null일경우 0으로 대채해서 조회
SELECT empno, comm, NVL(comm, 1),
        NVL(sal+comm, 0), sal + nvl(comm,0)
FROM EMP;

2. NVL2(ecpr1, ecpr2, ecpr3)
if(ecpr1 != null)
    sysout(expr2)
else
    sysout(expr3)
    
comm이 null이 아니면 sal+comm을 반환
comm이 널   이면 sal반환
SELECT empno, sal, comm,
        NVL2(comm, sal+comm, sal) nvl2,
        sal + nvl(comm, 0)
FROM EMP;
    
    -- 편한거 써라~~~
    
3. NULLIF(expr1, expr2)
널을 생성을 해버림\
if(expr1 == expr2)
    sysout(null)
else
    sysout(expr1)

SELECT EMPNO, SAL, NULLIF(SAL, 1250)
FROM EMP;

4. COALESCE(expr1, expr2, expr3, ......) = 가변인자 / 재귀함수
=  인자들 중에서 가정먼저 등장하는 null이 아닌 인자를 반환
if(expr1 != null)
    sysout(expr1);
else
    COALESCE(expr2, expr3, ....);

if(expr2 != null)
    sysout(expr2);
else
    COALESCE(expr3, ....);

SELECT empno, sal, comm, COALESCE
FROM EMP;

--실습 4
EMP테이블을 다음과같이 조회하시오 NULLIF 뺴고

SELECT empno, ename,
        mgr, NVL(mgr, 9999) MGR_N,
        NVL2(mgr, mgr, 9999) MGR_N_1,
        COALESCE(mgr, 9999) MGR_N_2
FROM EMP;



-- 실습 5
USERS 테이블에서 REG_DT가 널이면 SYSDATE로 적ㄱ요

SELECT userid, usernm, reg_dt,NVL(reg_dt, sysdate)
FROM USERS
WHERE UserID IN('cony', 'brown', 'sally', 'james');



조건 분기(자바 if)
컬럼값이 어떨때 어떤값으 반환해라
1. CASE 절
    CASE 컬럼(수식) 비교식(참거짓을 판단 할수잇는 수식) THEN 사용할 값         
    CASE 컬럼(수식) 비교식(참거짓을 판단 할수잇는 수식) THEN 사용할 값2        --> ELSE IF에 해당
    CASE 컬럼(수식) 비교식(참거짓을 판단 할수잇는 수식) THEN 사용할 값3        --> ELSE IF
    ELSE 사용할 값 4                                                      --> ELSE
   END 
    
    직원들 급여를 인상하고 싶다
직군이 세일즈맨이면 현재급여에서 5% 인상
직군이 매니저이면 현재급여에서 10% 인상
직군이 프레지던트이면 현재급여에서 20% 인상
직군이 그외 이면 현재급여에서 유지

SELECT ename, job, sal,
        CASE
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.10
            WHEN job = 'PRESIDENT' THEN sal * 1.20
            ELSE SAL * 1.00
        END SAL_BONUS,
        DECODE(job,
                    'SALESMAN', sal * 1.05,
                    'MANAGER', sal * 1.10,
                    'PRESIDENT' , sal * 1.20,
                    sal * 1.00) SAL_BONUS_DECODE        
FROM emp;

2. DECODE 함수 --> COALESCE 함수처럼 가변인자 사용
    사용범위가 한정적이다
DECODE( expr1, search1, return1, search2, return2, search3, return3,.....,[default])
DECODE( expr1, 
                search1, return1, 
                search2, return2,
                search3, return3,
                            .....,[default])
                                디폴트 안넣음면 기본값이 없기떄문에 null로 나온다
if (expr1 == search1)   -- 대소비교가아니라 
    sysout(return1)
else if(expr1 == search2)
    sysout(return2)
    ....
else
    sysout(default)



실습 1
emp테이블 이요 부서번호를 부서명으로 변경하고
다음고 같이 조회

SELECT empno, ename, deptno,
        CASE
            WHEN deptno = 10 then 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATIONS'
            ELSE 'DDIT'
        END DNA,
        DECODE(deptno, 10, 'ACCOUNTING', 20,'RESEARCH', 30, 'SALES',40,'OPERATIONS','ddit')
FROM EMP;


실습2
emp테이블에서 고용링리 올해 건강검진 대상인지 조회해라

SELECT empno, ename, TO_CHAR(hiredate,'YYYY') 고용일,MOD(TO_CHAR(hiredate,'YYYY') ,2) 입사,MOD(TO_CHAR(SYSDATE,'YYYY') ,2) 올해,
        DECODE( MOD(TO_CHAR(SYSDATE,'YYYY') ,2), MOD(TO_CHAR(hiredate,'YYYY') ,2), '대상',  '비대상') 결과,
        CASE
            WHEN  MOD(TO_CHAR(SYSDATE,'YYYY') ,2) =
                    MOD(TO_CHAR(hiredate,'YYYY') ,2) THEN '대상'
            ELSE '비대상'
        END 결과2
    
FROM EMP;


실습 3
유져스 테이블 레짓디따라서 
SELECT USERID, USERNM,REG_DT,
 CASE
            WHEN  MOD(TO_CHAR(REG_DT,'YYYY') ,2) =
                    MOD(TO_CHAR(REG_DT,'YYYY') ,2) THEN '대상'
            ELSE '비대상'
        END 결과2
                 
FROM USERS
WHERE  USERID IN ('cony', 'brown', 'sally', 'james', 'moon');

SELECT TO_DATE('2021' || '0101', 'YYYYMMDD')
FROM DUAL;
-- 값을 년만주고 놔왔을때는 나머지값이 현재월의 기본값이  나온다.

-   -   -   -   -   -   -   -   -   -
    
    --그룹함수 / group function : 여러행을 그룹으로 하여 하나의 행을 결과값을 반환하는 함수
    -- 그룹핑기준이 중요한다 무엇을 기준으로 할지?
    -- 하나\의행응로만 할수잇는건 아니다 여러개 가능하다
    
select *
from emp;

    5개
    1. AVG   평균
    2. COUNT 건수 - 그룹핑된 행중에서 컬럼의 값이 NULL 이 아닌 건수
    3. MAX   최대값
    4. MIN   최소값
    5. SUM   합
GROUP BY : WHERE 절 다음에 나온다  오더 바이 전에

SELECT deptno, MAX(SAL), Min(sal), ROUND(AVG(sal),2), SUM(SAL),
            COUNT(SAL),  --그룹핑된 행중에서 컬럼의 값이 NULL 이 아닌 건수
            COUNT(MGR),  --그룹핑된 행중에서 컬럼의 값이 NULL 이 아닌 건수
            COUNT(*) -- 그룹핑되니 행 건수
FROM EMP
GROUP BY  deptno
ORDER BY deptno;

--  그룹바이를 사용하지 않을 경우 테이블의 모든 행을 하나의 행으로 그룹핑한다.
SELECT COUNT(*), MAX(SAL), MIN(SAL), ROUND( AVG(SAL),2), SUM(SAL)
FROM EMP;


SELECT *
FROM EMP;
-- 
-- 그룹 바이 절에 나온 컬럼이 셀렉트 절에 그룹함수가 적용되지 ㅇ낳은채로 기술되면 에러가난다요
SELECT deptno, empno,
        MAX(SAL), Min(sal), ROUND(AVG(sal),2), SUM(SAL),
            COUNT(SAL),  --그룹핑된 행중에서 컬럼의 값이 NULL 이 아닌 건수
            COUNT(MGR),  --그룹핑된 행중에서 컬럼의 값이 NULL 이 아닌 건수
            COUNT(*) -- 그룹핑되니 행 건수
FROM EMP
GROUP BY  deptno, empno;
-- 한행씩만 나온다
-- 논리적인 사고가 필요하다

SELECT deptno, COUNT(*), MAX(SAL), MIN(SAL), ROUND( AVG(SAL),2), SUM(SAL)
FROM EMP;
-- 에러임
SELECT deptno, COUNT(*), MAX(SAL), MIN(SAL), ROUND( AVG(SAL),2), SUM(SAL)
FROM EMP
group by deptno;
-- 이런식으로 바꿔야 한다.

-- 예외사항
SELECT deptno, 'test','1000000',
        MAX(SAL), Min(sal), ROUND(AVG(sal),2), SUM(SAL),
            COUNT(SAL),  --그룹핑된 행중에서 컬럼의 값이 NULL 이 아닌 건수
            COUNT(MGR),  --그룹핑된 행중에서 컬럼의 값이 NULL 이 아닌 건수
            COUNT(*), -- 그룹핑되니 행 건수
            SUM(COMM),    -- 더할때 널값을 무시하고 계산한다.
            SUM(NVL(COMM,0)),        -- 계산식이 아래보다 길다
            NVL(SUM(COMM), 0)  -- 좀더 컴퓨터 친화적
            
            
FROM EMP
WHERE LOWER(ename) = 'smith'
-- 그룹함수의 조건은 해빙절에 써야한다.
GROUP BY  deptno
HAVING COUNT(*) >= 4;
-- 고정된 상수는 행에 맞춰서 알아서 나온다.


 - 그룹함수에서 NULL 컴럼은 계산에서 제외된다
 - 그룹바이 절에서 작성된 컴럼 이외의 컬럼이 섹렉절에 올수 없다.
 - 웨어절에서 그룹 함수 조건으로 사용할 수 없다
    해빙절 사용
            WHERE SUM(SAL) >3000  XXXX
            HAVING
             SUM(SAL) >3000 OOOO
            
            
            실습 
            EMP에서 
            급여 1등
            급여 꼴뜽
            급여 평균 2자리
            급여 합
            급여있는 직원수 널제뢰
            상급자있는수 널 제외
            전체직원수
            
SELECT COUNT(*), MAX(SAL), MIN(SAL), ROUND(AVG(SAL),2), SUM(SAL), COUNT(SAL), COUNT(MGR)
FROM EMP;


GROUP BY COUNT(*);
            
            
SELECT COUNT(*), MAX(SAL), MIN(SAL), ROUND(AVG(SAL),2), SUM(SAL), COUNT(SAL), COUNT(MGR)
FROM EMP
GROUP BY DEPTNO;
            
            
            
            
            
            
            
           































