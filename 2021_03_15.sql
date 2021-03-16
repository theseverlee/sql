3-12 복습

조건에 맞는 데이터 조회 : WHERE 절  : 필털링 / 기술한 조건이 참이냐? 만족하는 행만 조회

-- 테이블 : 14개
-- 컬럼 8개
-- 컬럼 조회하기 : 3개

SELECT *
FROM emp
WHERE 1=1;

SELECT *
FROM emp
WHERE deptno = 30;

SELECT *
FROM emp
WHERE deptno = deptno;
-- 14건 즉 1=1;과 같다

SELECT *
FROM emp
WHERE deptno != deptno;
-- =! : 같지않다 / 1 != 1;과 동일 항상거짓이기때문에


int a = 20;
String a = "20";
String a = '20';
-- sql은 문자열을 싱글코ㅌㅔ이션으로 표기

SELECT 'SELECT * FROM' || table_name || ';'
FROM user_table;
-- 문자열 조합기호 : ||(쌍파이프)
-- 문자열은 데이터를 표기하는 값에 영향을 준다
-- 컬럼명을 변경하고 싶다면 알리아스로 표기


'81/03/01' 
위와같이 작성시 다른나라에서는 다른값을 표현될 수 있다.
TO_DATE('81/03/01', 'YY/MM/DD');
이처럼해서 쓰자 / 투데이트가 앞에 붙어있어야만 실행되니 자동으로 붙는다고생각하지말자

깃업로드 구조 ( 워킹 - 스테이지 - 로컬 ) / 깃헙 (원격)

--입사일자가 1982년 1월 1일 이후인 모든 직원을 조회하는 쿼리 작성해보시오

SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD');
WHERE hiredate >= TO_DATE('1982-01-01', 'YYYY-MM-DD');
WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD');
-- 투데이트가 앞에 붙어있어야만 실행되니 자동으로 붙는다고생각하지말자
--YYYYMMDD / YYYY-MM-DD등 포맷팅에 맞게 사용하자
-- 
30 > 20 : 숫자 > 숫자
날짜 > 날짜
2021-03-15 > 2021-03012
-   -   -   -   -   -   -       -   -   -   -   -   -   -       --

WHERE절에서 사용 가능한 연산자
비교 ( =, !=, <, >, ....)
몇항연산자인지 
+는 2개의 연산자 필요  A + B / 이항연산자
단항연산자 A++ / ++A

BETWWWN AND 이놈도 삼항연산자 입니다. 
비교대상 BETWEEN 비교대상의 허용 시작값  AND 비교대상의 허용 종료값
-- 부서번호가 10~ 20번에 사이에 속한 직원 조회
SELECT *
FROM emp
WHERE deptno BETWEEN 10 AND 20;

-- emp 테이블에서 급여가 1000보닥 크거나 같고 2000보다 작걱나 같은 직원만 조회
-- sal >= 1000 / sal <= 2000
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

SELECT *
FROM emp
WHERE sal >=1000 and sal <= 2000 and deptno =10;


true and true ==> true
true and false ==> false
true or false ==> true

비트윈 실습 1

SELECT ename, hiredate
FROM emp
WHERE hiredate between to_date('1982/01/01', 'YYYY/MM/DD') and to_date('1983/01/01', 'YYYY/MM/DD');

비트윈 실습 2
SELECT concat('이름 :', name), concat('입사일 :', hiredate)
FROM emp
WHERE hiredate >= to_date('1982/01/01', 'YYYY/MM/DD') 
        and hiredate <= to_date('1983/01/01', 'YYYY/MM/DD');

between and : 포함(이상, 이하)  /
                        초과, 미만읜 개념을 적용하려면 비교연산장르 ㄹ사용해야 한다 ( and, or)
                        
                        
                        
IN 연산자
대산자 IN (대상자와 비교할 값1, 대상자와 비교할 값2, 대상자와 비교할 값3 ............ 약 1000개?)
deptno IN(10,20)
        ==> deptno값이 10이나 20이면 true 
        ==> 논리연산으로는 or와 같다

SELECT *
FROM emp
WHERE deptno IN(10,20);

SELECT concat('이름 ', ename) 성명 
FROM emp
WHERE deptno = 10 OR deptno =20;

SELECT *
FROM emp
WHERE 10 IN(10,20);
10은 10과 같거나 10은 20과 같다
true      or       fale     ==> true 참 14건 다나옴

in 실습 1
users 테이블에서 if가 brow cony sally 만 조회

SELECT userid AS 아이디, usernm AS 이름, alias 별명
FROM users
WHERE userid IN('brown', 'cony', 'sally');
      컬럼명       데이터값=문자열이다 싱글코테이션사용/데이터는 대.소문자를 가린다.
        userid = 'brown'
        or userid = 'cony'
        or userid = 'sally'
                컬럼명에 공백이나 영어대소문자가릴거면 더블코데이션으로 만들어라
                
        sql의 끝은 세미콜론 중간에 실수로 넣지 않앗는지는 확인하자 


LIKE 연산자 : 문자열 매칭 조회
게시글 : 제목 검색, 내용 검색
        제목에 [맥북에어]가 들어가는 게시글만 조회

1. 얼마안됨 맥북에어 팔아요
2. 맥북에어 팔아요
3. 팝니다 맥북에어
테이블 게시글 / 제목칼럼 :제목/ 내용칼럼 : 내용
SELECT *
FROM 게시글
WHERE 제목 Like '%맥북에어%' or 내용 Like '%맥북에어%';
제목      내용
1         2
t    or   t     t
t    or   f     t
f    or   t     t
f    or   f     f

제목      내용
1          2
t    and   t     t
t    and   f     f
f    and   t     f
f    and   f     f



퍼센트 언더바
%(퍼센트) : 0개 이상의 문자
_(언더바) : 한개의 문자
 c로 시작 c???????????????를 조회하고싶다 = c%
SELECT *
FROM users
WHERE userid like 'c%';
라이크도 2항연산자이다.

c로시작하면 서 c이후에 3개의 글자가오는상황
SELECT *
FROM users
WHERE userid like 'c___';


id에서 1이 들어가는 모든 사용자를 조회
%(퍼센트) : 0개 이상의 문자/자주씀
_(언더바) : 한개의 문자/자주안씀

SELECT *
FROM users
WHERE userid like '%l%';
        지정한 문자앞이 0개이상이고/문자뒤가 0개 이상이다.

라이크 실습 1
멤버테이블에서 성이 신ㅅ씨를 아이디 이름 조회하기
SELECT mem_id, mem_name
FROM member
WHERE mem_name Like '신%';

이름에 [이]가들억나늣 라마
SELECT mem_id, mem_name
FROM member
WHERE mem_name Like '%이%';

is(Null) 비교
SELECT *
FROM  emp
WHERE comm = null;
null은 동등비교 연산을 사용할수 없다. is로 사용한다

커미션값이 널아닌사람 조회하자
SELECT *
FROM  emp
WHERE comm is null;
    sal = 1000
    sla != 1000
위처럼 부정어로 쓰려면 not을 붙이면 된다.
SELECT *
FROM  emp
WHERE comm is not null;

emp테이블에서 매니저가 없는 직원만 조회
SELECT *
FROM EMP
WHERE mgr is null;
0과 null 은 다르다

BETWEEN AND, IN, LIKE, IS
논리연산자 : AND, OR, NOT
AND : 두가지 조건을 만족시키는지 확인할때 
            조건 1 AND 조건 2
OR : 두가지 조건중 한나라도 만족시키는지 확인할대
            조건 1 OR 조건 2
NOT : 부정형 논리연산자, 특정 조건을 부정
                mgr IS NULL : mgr 컬럼의 값이 null인 사람만 조회
                mgr IS NOT NULL : mgr 컬럼의 값이 null이 아닌 사람만 조회

EMP 테이브에서 매니저가 사번이 7698이면서 급여가 1000보다 큰사람
SELECT *
FROM emp
WHERE mgr = 7698 and sal > 1000;
    조건의 순서는 결과와 무관하다
WHERE sal > 1000 and mgr = 7698;

SELECT *
FROM emp
WHERE mgr = 7698 or sal > 1000;
-- sla 값이 1000보다 크거나 mgr이 7698인사람

AND 조건이 많아지면 : 조회한는 데이터 건수가 줄어든다.
OR 조건이 많아지면 : 조회되는 데이터 건수가 많아진다.(하나라도 걸리면 되니까)

NOT : 부정형 연산자, 다른연산자와 결합하여 쓰인디ㅏ.
        IS NOT, NOT IN, NOT LIKE

SELECT *
FROM emp
WHERE deptno not in(30);    
-- 부서번호가 30이 아닌 사람들 조회하기

SELECT *
FROM emp
WHERE deptno != 30;

SELECT *
FROM emp
WHERE ename not like 'S%';
__----- -   -   -   -   -   -   -   -       --  -   -   -       -   -
**** NOT IN  연산자 사용시 주의 점 : 비교값중에서 NULL 이 포함되면 데이터가 조회되지 않는다!!! ***** 시험
이해못하면 당황하는 경우가 생길수있다.
SELECT *
FROM emp
WHERE mgr IN (7698, 7839, NULL);
-- 9명이여야 하는데 8명만 나옴 킹잉 안나옴 null
 ==>  mgr = 7698 or mgr = 7839 or mgr = NULL     이건 중요한거야
                애가 3가지 값중 하나와 부합한다.라고 보바
SELECT *
FROM emp
WHERE mgr not IN (7698, 7839, NULL);
    ?????? 데이터가 안나옵니다. 
        논리적으로 잘 해석하면 됩니다.
   ==>  7698이 아니면서  7839 아니면서  null 아니여야 한다.       /  and와 같다. *****
==> !(mgr = 7698 or mgr = 7839 or mgr = NULL)
==> mgr != 7698 or mgr != 7839 or mgr != NULL
            true false 의미가 없음 and false
            애가 이것도 아니고 이것도 아니고 이것도 아니여야한다.
mgr != 7698 ==> mgr = 7698
and         ==> not
    -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
실습 7번
emp에서 잡이 세일즈맨이고 입사일일 1981 .6/1이후 잊궝ㄴ 조회
SELECT *
FROM emp
WHERE job = 'SALESMAN'  
        and hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');


실습 8
EMP에서 부서번호가 10이 아니고 입사일자 198166월 1일 이후 저회
SELECT *
FROM emp
WHERE deptno != 10
        AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

실습 9
WHERE deptno not in (10)


실습 1-0
emp에서 부서번호 가 10아니고 
입사일자 1981 0601이후 ㅈ조회하기(in으로 10 2030만잇다
SELECT *
FROM emp
WHERE deptno in (20, 30) 
        AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD'); 


실습 11
emp에서 잡 세이맨 이거나 입사일자 1981 06 01 이조회

SELECT *
FROM emp;
WHERE job = 'SALESMAN'  
        or hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');
        
        
        
실습 12 풀면 좋고 못풀어도 ㄱㅊㄱ
emp에서 w잡에서 세이즈맨 이거나 사번이 78로 시자ㄱ\하는 직원 조회
SELECT *
FROM emp;
WHere job = 'SALESMAN' 
        OR empno like '78%';

-- \사번의 숫자를 문자열로 변경을 했겠구나~~ 

과제 13
emp emp에서 w잡에서 세이즈맨 이거나 사번이 78로 시작하는 직원 조회 ( 라이크 사용안하기)
SELECT *
FROM emp
WHere job = 'SALESMAN'
            or empno BETWEEN 7800 AND 7899
            or empno BETWEEN 780 AND 789
            or empno = 78;
















