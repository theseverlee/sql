/*
// WHERER 조건 1 : 10건

// WHERER 조건 1
        AND : 조건 10건은 넘을수 없다
        
// WHERER deptno = 10
        and sal > 500
        
-   -   -   -   -   -       -   -   -       -   -       
17일 수 
/*
함수 ( function )- 하나하나 외우지 않아도 ㄱㅊ하다
        이름을 보고 무엇을 하는지 알아야한다
        사전식으로 
        2가지로 구분
        1. single row
            단일 행을 기준으로 작업하고 행당 하나의 결과를 반환
            특정 컬럼의 문자열 길이 : length(ename)
            
        2. Mltirow
            여러 행을 기줁으로 작업하고  하나의 결과를 반환
            그룹함수 : count, sum, avg
        우리회사의 직원은 몇명인가>? 14명
        입력은 여러개인데 
        메서드드 따로 뺴놓으면 장점 : 유지보수하는데 편리하다.





*/

/* 이런연습을 해봐라
// 함수명을 보고서
1. 파라미터(인자)가 어떤게 들어갈까?
2. 몇개의 파라미터가 들어갈까?
3. 반환되는 값은 무엇일까?


character
    - 대소문자
        - LOWER(소문자)
            입력값이 문자 / 들어가는 갯수 1개/ 반환 문자
        - UPPEP(대문자)
        - INITCAP(첫글자를 대문자로)
    - 문자열 조작
        - CONCAT(연쇄)
            문자열 인자 2개 / 결합반화 1개
        - SUBSTR
            (부분문자열) / 그문자열에 일부분을 뺴오고 싶을때 
            substr(컬럼명, 시작, 끝날갯수)
            substr(컬럼명, 시작위치)
        - LENGTH(문자열의 길이)
        - INSTR(특정문자열에 내가 검색하고싶은문자가 잇는지)
        - LPAD | RPAD
        - TRIM 
            문자열 공백제거하기
        - REPLACE
            치환 / 교체하겟다 인자 3개 (대상문자열, 바꾸고싶으문자열, 교체문자열)
        
        
        
        
*/

SELECT ename, LOWER(ename), UPPER(ename), INITCAP(ename), LOWER('TEST'),SUBSTR(ename,1,3),  SUBSTR(ename, 2)
FROM emp;
// 문자열 상수다

-- DUAL TABLE
    sys계정에 잇는 테이블
    누누간 사용가능
    DUMMY컬럼 하나만 존재하며 값은 'X'이며 데이터는 한 행만 존재
    
    - 사용 용도
        - 데이터와 관련 없이
            - 함수 실행
            - 시퀀스 실행
        - merge 문에서
        - 데이터 복제시(connect by level)
SELECT *
FROM  dual;

SELECT LENGTH()
FROM emp;

SELECT LENGTH('TEST')
FROM DUAL;
// 행자체가 1행이기에   // 실행자체가 1번만 실행이됨

싱글로우 함수 : WHERE 절에서도 사용이 가능
// EMP테이블에 등록된 직원중 이름이 5글자 초과하는 직원 조회

SELECT *
FROM emp
WHERE LENGTH(ename) > 5;
// 멀티로우는 불가능

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith';
       // 로어함수는 14번이 실행후 
       ename = UPPER('smith');
        // 어퍼함수를 1번만 실행
        
엔코아 -> 엔코아_부사장 : B2EN  ==> B2EN 대폭컨설턴트 : dbian
1. 테이블컬럼을 가공하지 말아라
2. 인텍스 컬럼은 변형이 일어나면 인덱스 못쓴다

오라클 문자열 함스
//       CONCAT SUBSTR  LENGRH  INSTR
// 인자     2개    3개     1개     2개
SELECT  'HELLO'|| ' '  || 'WORLD',
        CONCAT('HELLO', CONCAT(' ', 'WORLD')) CONCAT,
        SUBSTR('HELLO, WORLD', 1, 5) SUBSTR, -- 1부터 5개 보여줘
        LENGTH('HELLO, WORLD')  LENGTH, -- 문자열의 수
        INSTR('HELLO, WORLD', 'O') INSTR,  -- O를 찾아라 첫번째에서 걸림
        INSTR('HELLO, WORLD', 'O', 6) INSTR2,  --  6번쨰부터 O를 찾아라
        LPAD('HELLO, WORLD', 15, '-') LPAD, -- 왼쪽추가
        RPAD('HELLO, WORLD', 15, '-') RPAD, -- 오른쪽 추가
        REPLACE('HELLO, WORLD', 'O', 'X') REPLACE, -- O를 X로 치환
         -- 공백을 제거, 문자열의 앞과 뒷부분에 있는 공백만, 가운데 안건듬
        TRIM('   HELLO, WORLD    ') TRIM,
        TRIM('D' FROM  'HELLO, WORLD') TRIM2 -- 조건을찾아서 없어겟다
        
FROM dual;


/*
숫자 조작
    ROUND
        반올림 / 인자 2개
    TRUNC
        내림 / 인자 2개
    MOD
        나눗셈의 나머지 / 인자 2개
        자바랑 달라 
        SELECT MOD(10,3)
        FROM dual;
*/
        -- 피제수, 제수
SELECT MOD(10,3)
FROM dual;

SELECT
ROUND(105.54, 1) round1,   -- 반올림 결과가 소서점 첫번째 자리까지 = 둘째자리에서 반올림 105.5
ROUND(105.55, 1) round2,   -- 반올림 결과가 소서점 첫번째 자리까지                        105.6
ROUND(105.55, 0) round3,   -- 결과가 일의 자리 까지 나오도록 = 소수점 첫자리에서 반올림    106
ROUND(105.55, -1) round4,   -- 결과가 십의 자리 까지  나오도록 = 정수 첫자리에서 반올림    110
round(105.55) round5         -- 2번쨰 인자 생략하면 ,0을 입력한것과 같다
FROM DUAL;

-- 라운드나 트럼트나 사용방법은 똑같다 위 라운드를 트럼프로 바꾸면 됨

-- 자바 알트 쉬프트 에이 / 세로편집 / 똑같이입력시켜준다.


SELECT
TRUNC(105.54, 1) trunc1,   -- 반올림 결과가 소서점 첫번째 자리까지 = 둘째자리에서 절삭 105.5
TRUNC(105.55, 1) trunc2,   -- 반올림 결과가 소서점 첫번째 자리까지                        105.5
TRUNC(105.55, 0) trunc3,   -- 결과가 일의 자리 까지 나오도록 = 소수점 첫자리에서 절삭    105
TRUNC(105.55, -1) trunc4,   -- 결과가 십의 자리 까지  나오도록 = 정수 첫자리에서 절삭    100
trunc(105.55) trunc5        -- 2번쨰 인자 생략하면 ,0을 입력한것과 같다
FROM DUAL;

-- EX) 7499. ALLEN, 1600, 1, 600
-- MOD(
SELECT  empno, ename, sal, sal을 1000으로 나웠을 때의 몫, sal을 1000으로 나눌때 나머지
FROM EMP;

SELECT  empno, ename, sal, TRUNC((SAL/1000),0) , MOD(SAL, 1000)
FROM EMP;

/*
날짜  < -- > 문자
서버의 현재 시간 : SYSDATE // 인자가없는 함수 괄호 안쓴다

TO_DATE : 인자-문자, 문자의 형식
    문자를 날짜로
TO_CHAR : 인자-날짜, 문자의 형식
    날짜를 문자로

*/
SELECT SYSDATE, (SYSDATE - (1/24/60/60)*3)
FROM DUAL;

-- 실습 1
2019 12 31을 DATE형으로 표현
상동                         하고 5일 전날짜
현재날짜
현재날짜 3일전값

SELECT SYSDATE 옛날, SYSDATE 옛날5일전, SYSDATE 현재날짜, SYSDATE-((1) * 3) 일전3
FROM DUAL;

TO_DATE 나짜를 문자열로 안전하게 바꾸는 방법

SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') LASTDAY,
        TO_DATE('2019/12/31', 'YYYY/MM/DD')-5 LASTDAY,
         SYSDATE 현재날짜,
         SYSDATE-((1) * 3) 일전3
FROM EMP;

SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD') 날짜를문자로, TO_CHAR(SYSDATE, 'YYYY')
FROM EMP;

-- 1년 52주  : 'IW' 는 현재 주차알기
-- 주간요리 (D)   :  0 = 일요일 / 1 - 월 / 2 화/ 3수/ 4목/5 금/ 6토
SELECT SYSDATE, TO_CHAR(SYSDATE, 'IW'), TO_CHAR(SYSDATE, 'D')
FROM EMP;

/*
숫자 포맷 - 어느정도는 외우자 많이쓰는 포맷팅
YYYY 년도 4자리
DD 2자리 워
MM 2자리 일자
D : 주간일자 0 ~ 6
IW : 주차 1 ~ 53
HH, HH12 : 2자리시간 (12시간)
HH24 : 2자리시간 24시간
MI : 2자리 분
SS : 2자리 초 

자바포맷은 오라클이랑 다르다
*/

실습2
오늘날짜는 아래포맷으로
1. 년-월-일
2. 년-월-일 시간(24)-분-초
3. 일 월 년

SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD'),
        TO_CHAR(SYSDATE,'YYYY-MM-DD HH24-MI-SS'),
                TO_CHAR(SYSDATE,'DD-MM-YYYY')
FROM DUAL;
-- TO_CHAR로 바꾼건 문자열이다 .
TO_DATE(TO_CHAR(SYSDATE,'YYYY-MM-DD'), 'YYYY-DD-MM')
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD'), 
        TO_DATE(TO_CHAR(SYSDATE,'YYYY-MM-DD'), 'YYYY-DD-MM')

FROM DUAL;
'2021-03-17' ->시분초를 붙이고싶다
        아래같이 포맷팅을 하면 시분초가 날아가서 000000 이된다ㅣ
SELECT TO_CHAR(TO_DATE('2021-03-17', 'YYYY-MM-DD'), 'YYYY-MM-DD HH24-MI-SS')
FROM DUAL;

SELECT SYSDATE, TO_DATE(TO_CHAR(SYSDATE, 'YYYY-MM-DD'), 'YYYY-MM-DD HH24-MI-SS')
FROM DUAL;
==> 컨캣
CONCAT('HELLO, CONCAT(' ', 'WORLD'))




















