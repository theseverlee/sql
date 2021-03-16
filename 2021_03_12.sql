2021 03 12 금요일

파일과 dbms   구분

sql구문 4종류
	ddl dml dcl tcl	어제는 dml(select insert delete update) = CRUD
    
수업시간 sql 코딩 룰
	키워드는 대문자 / 그 외 소문자
    
트랙잭션
	논리적인 일의 단위
    
sql는 dbms랑 통신하기 위한 유일한 수단
		nosql(비정형 제품) - 제품마다 다름
select 쿼리

SELECT 테이블의 컬럼명을 콤마로 구분나열, * 
FROM 가져올 데이터가 담긴 테이블 이름

SELECT *
FROM emp;
테이블명은 사용자가 이름을 지어주는것이다
SELECT empno, ename  / 컬럼명은 키워드가 아니다
FROM emp;


sem계정에 있는 prod 테이블의 모든 컬럼을 조회하는 SELECT 쿼리(SQL) 작성

SELECT *
FROM prod;

[vitta계정]에 있는 prod 테이블의 prod_id, prod_name 두개의 컬럼만 조회하는 SELECT 쿼리(SQL) 작성

SELECT prod_id, prod_mane                     -- 컬럼명 오타
FROM prod;

ORA-00904 오라클에서 정의한 에러코드
 "PROD_MANE": invalid identifier - (invalid 유효하지 않음) 니가쓴 컬럼이 없다

SELECT prod_id, prod_name
FROM proc;                                   -- 테이블명 오타
ORA-00942: table or view does not exist -- 테이블자리에 뷰라는것도 올 수 있다.

SELECT1]  실습

1. lprod 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요
SELECT *
FROM lprod;

2. buyer 테이블에서 buyer_id, buyer_name 컬럼만 조회하는 쿼리를 작성하세요
SELECT buyer_id, buyer_name
FROM buyer;

3. cart 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요
SELECT *
FROM cart;

4. member 테이블에서 mem_id, mem_pass, mem_naem 컬럼만 조죄하는 쿼리를 작성하세요
SELECT mem_id, mem_pass, mem_naem
FROM member;
-- 오류 뜸 찾아서 고쳐라 

컬럼정보를 보는 방법
1. SELECT * ==> 컬럼의 이름을 알 수 있다.
2. SQL DEVELOPER의 테이블 객체를 클릭하여 정보확인
        -- EMP 테이블을 한번 보자
        -- 데이터 타입 문자 숫자 날자  NUMBER(4,0) 전체 자리수는 4자리다 / 소수점은 없다
        -- NUMBER(7,2)자리수는 7자리이고 / 소수점은 2자리까지
        -- VARCHAR2(10 BYTE) 자바의 스트링 클래스와 같다 = VARCHAR2  / 10바이트 까지 저장할 수 있다.
3. DESC 테이블명 ;
        -- 테이블명들 전체적으로 볼수있다
DESC prod;   
-- DESCRIBE 설명하다 = DESC
        -- 널? == 널값을 허용할거아 아니냐
        -- 나중에 다시 배운다 널
        -- 유형 테이터 칼럼
null 값은 정해지지 않은것
SELECT *
FROM emp;

-- 자바의 변수  = 디비에서의 컬럼명이다.
empno : NUMBER;
empno + 10, 10, hiredate + 10 ==> expression 설명, 표현
-- 컬럼정보가 아닌거 = 전부 expression 
-- 사번 사번+10 10으로 통일 하겟다
SELECT empno 사원번호, empno + 10 emp_plus , 10,
        hiredate, hiredate + 10
FROM emp;
-- +10처럼 가공을 하더라도 기본 데이터의 수정이 되지 않는다.
-- 데이터를 바꾸는건 UPDATE 쿼리 이다
-- SELECT 쿼리에서는 원본데이터 상관 없다
-- 컬멍명/익스프레션 뒤에 알리아스가 오면 컬럼명을 알리아스로 바꿔준다.[alias]
ALIAS : 컬럼의 이름을 변경
        컴럼 ㅣ expression [AS] [별칭명]
SELECT empno "emp no", empno + 10 AS emp_plus , 10
FROM emp;
--SELECT empno empno는 조회할 컬럼명이 empno이고 별칭을 empno라고 지어서 상관없다.
-- 별칭명을 소문자로 했는데 조회한 값에서는 대문자로 나온다. 하지만 소문자로 뽑고 싶다면 "알리아스"로 넣어라
                                                 + as를 넣어서 구분을 할 수 있다  + 공백도 표현이 가능

숫자, 날짜에서 사용가능한 연산자
일반적인 사칙연사 +-*/, 우선순위 연산자 () 
날짜에 대해서는 연산자중에서 + - 만 정의 가 되어있다. / /*는 x

 
NULL : 아직 모르는 값
        0과 공백은  NULL과 다르다
        **** NULL을 포함한 연산은 결과가 항상 NULL **** / 중요하다!! Like 0 x 1000000 = 0
        ==> null 값을 다른 값으로 치환해주는 함수를 배울거야 ~ 

SELECT ename, sal, comm, sal + comm, comm + 100  
FROM emp;


select 2) 실습
1. prod 테이블에서 prod_id, prod_name 두 칼럼을 조회하는 퀼를 작성하시오
    (단, prod_id -> id, prod_name -> name 으로 컬럼 별칭을 지정)
SELECT prod_id "id", prod_name "name"
FROM prod;

2. lprod 테이블에서 lprod_gu, lprod_nm 두 칼럼을 조회하는 쿼리를 작성하시오
    ( 단 lprod_gu -> gu, lprod_nm -> nm으로 컬럼 별칭을 지정)
SELECT lprod_gu as "gu", lprod_nm as "nm"
FROM lprod;

3. buyer 테이블에서 buyer_id, buyer_name 두 칼럼을 조회하는 쿼리를 작성하시오
        (단 buyer_id -> 바이어아이디, buyer_name -> 이름 으로 컬럼 별칭을 지정)
SELECT buyer_id 바이어아이디, buyer_name 이름
FROM buyer;

-- 컬럼명을 한글로 하지는 않는다 주로
-- 데이터를 가지고 올 테이블명을 확실하게 확인하자 맞는지 않 맞는지 / 왜? 조회하려는 컬럼명이 테이블에 있어야 하니까~
-- 쿼리를 짤때는 프롬부터 쓰도록 하자

< 개념상 중요한거 >
literal : 값 자체를 말한다
literal 표기법 : 값을 표현하는 방법

java 정수 값을 어떻게 표현할까?(10)
int a = 10;
float f = 10f;
long l = 10L;
String s = "hello world";


 * ㅣ {컬럼 ㅣ 표현식 [as] [알리아스], .......}
SELECT  empno, 10, 'hello world'
FROM  emp;
-- sql에서는 문자열을 싱글코테이션으로 표현한다. / 자바는 더블코테이션
-- 언어마다 리터럴의 표현방식이 다르다

문자열 연산
java : String msg = "Hello" + " world";

SELECT empno + 10, ename  || '입니다', concat(ename, '입니다 ')
FROM    emp;


에러난다 문자열 결합기호는 + 가 아니다 || = 백스페이스 옆 역슬래시 + 쉬프트
두 유 노 함수의 개념?
concat : 결합하고 싶은 2개만  소괄호 컴마로 넣어준다.
        겹합할 두개의 문자열을 결합하고 결합된 무낮열을 반환 해준다.
            CONCAT(문자열1, 문자열 2, 문자열3)
                ==> CONCAT(문자열 1,2가 결합된 문자열 , 문자열 3
                      ==> CONCAT(CONCAT(문자열1,문자열2), 문자열 3)
|| : 2개이상도 가능 



아이디 : brown
아이디 : apeach
SELECT concat('아이디 :', userid),'아이디 :' || userid
FROM users;

SELECE *
FROM user_tables;

오라클에서 관리하는 테이블임 / 테이블이름 데이터임

DESC EMP;


문자열 결합 실습 sel_con 1
1. 현재 접속한 사용자가 소유한 테이블 목록을 조회
SELECT TABLE_NAME
FROM user_tables;    

2. 문자열 결합을 이용하여 다음과 같이 조회 되로고 쿼리를 작성하시오
SELECT 'SELECT ' || '* '|| 'FROM ' || table_name ||';'
FROM user_tables;

SELECT 'SELECT * FROM ' || table_name ||';'
       concat('SELECT * FROM', table_name)
FROM user_tables;

SELECT  concat(concat('SELECT * FROM', table_name), ';')
FROM user_tables;

SELECT concat('SELECT * FROM', table_name) || ';'
FROM user_tables;

SELECT 'SELECT * FROM ' || concat(table_name, ';'),
        CONCAT('SELECT * FROM ' || table_name, ';')
FROM user_tables;


조건의 맞는 데이터 조회하기
    WHERE 절 조건 연산자 

조건을 걸어서 내가 원하는 데이터만 찾기
-- 부서번호가 10인 사람을 찾자
-- 부서번호 : DEPTNO
SELECT *
FROM emp
WHERE deptno = 10;


-- 유저 테이블에서 유저아이디 칼럼의 값이 브라운인 사용자만 조회
SELECT *
FROM users
WHERE userid = 'brown';
더블코데이션 x 문자열 표기 잘못이고
그냥쓰면 컬럼으로 인식
**** SQL 키워드는  대.소문자르 가리지 않지만 , 데이터값은 대.소문자를 가린다.

-- emp 테이블에서 부서번호가 20번보다 큰부서에 속한 지원 조회
SELECT *
FROM emp
WHERE deptno > 20;

-- emp 테이블에서 부서번호가 20번 부서에 속하지 않는 지원 조회
 SELECT *
 FROM emp
 WHERE deptno != 20;
 
[ where 절 : 기술한 조건을 참(true)으로 만족하는 행들만 조회한다.(필터링)]
참으로 만족을 하냐? 그럼 출력해라 / 참이 아니여? 그럼 내비둬

 SELECT *
 FROM emp
 WHERE 1=1;
 -- 1과 1은 같다 = 참이니 모든 데이터에 비교하면 참으로 뜬다
 
  SELECT *
 FROM emp
 WHERE 1=2;
 -- 이런조건을 참으로 하는 행이 없다

-- 81년 3월 1일 전에 입사한 사함
// 위 날짜 값을 표기하는 방법은 아직 몰라
SELECT empno, ename, hiredate
FROM emp;
WHERE hiredate >= '81/03/01';
-- 위와같이하면 조금 위험함 나라간 표기법이 다를 수 있기 때문에
-- 문자열로 하면 별로다 이말
-- 문자열을 날짜 타입으로 변환하는 방법
        TO-DATE(날짜 문자열, 날짜 문자열의 포맷팅)
TO_DATE('1981/03/01', 'YYYY/MM/DD')
를 적용 해서 다시 만들어보면
SELECT empno, ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1981/03/01', 'YYYY/MM/DD');
요런 방식이 안전빵이다 'YYYY' 4자리 표기법을 지향하자



