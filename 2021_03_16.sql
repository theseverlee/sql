/*
-  연산자 우선순위
산술 연산자
문자 결합자  ||
비교 연산자
is ,(not) null, like ,(not) in
(not) between
not
and
or

AND가 OR보다 우선순위가 높다
==> 햇갈리면 ( 소괄호 )를 사용하여 우선순위를 조정하자

*/

SELECT *
FROM emp
WHERE ename = 'SMITH' OR ( ename = 'ALLEN' AND job = 'SALESMAN');
                
// 직원의 이름이 allen 이면서 job이 salesman 이거나
// 직원의 이름이 smith인 직원 정보를 조회

SELECT *
FROM emp
WHERE ( ename = 'SMITH' OR  ename = 'ALLEN' ) AND job = 'SALESMAN';

// 직원의 이름이 allen 이면서 smith 이거나
// 잡이 salesman 인 직원 정보를 조회


// 실습 14번
emp테이블에서 잡이 세이즈맨 이거나
사번이 78로 시작하면서
입사일이 1981 06 01 이후인 직원 조회

SELECT *
FROM emp
WHERE JOB = 'SALESMAN' 
            OR  empno like '78%' 
            and hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');


//  -   -   -   -       -   -   -       -   -   -
/*
테이터 정렬
테이블  객체에는 데이터르 저장 / 조회시 순서를 보장하지 않음
    보편적으로 데이터가 입력된순서대로 죄회
    데이터가 항상 동일한 순서로 조회되는 것을 보장하지 않는다.
    데이터가 삭제되고, 다른 데이터가 들어 올 수도 있음
        페이징 처리할때 쓰인다 
    
    
    -- 자주쓰는 데 어렵다  -
ORDER BY
    ASC : 오름차순(기본)
    DESE : 내림차순
    
    ORDER BY(정렬기준 컬럼 OR alias OR 컬럼번호} [ASC OR DESE..]
    
    
    
블록 기본 : 8kbite
한건을 조회하더라도 해당 행을 다 조회한다.
조회한 데이터 주변의 데이터를 같이 조회한다. 재사용 확률이 올라가기 때문에
dbms 와 거의 동일하다 = rdbms

*/

// 데이터 정렬이 필요한 이유?
1. TABEL 객체는 순서를 보장하지 않는다.
        ==> 오늘 실행한 쿼리를 내일 실행할 경우 동일한 순서로 조회가 되지 않을 수도 있다.
        ==> 입력시 빈공간에 때려넣기에 편하다 / 정렬된 상태로 조회시 불편
        
2.현실세계에서는 정렬된 데이터가 필요한 경우가 있다.
        ==> 게시판의 게시글은 보편적으로 가자 최신글이 처음에 나오고, 가장 오래된 글이 맨 밑에 있다.

SQL에서 정렬 : ORDER BY ==> SELECT -> FROM -> [ WHERE ] -> ORDER BY
    정렬 방법 : ORDER BY 컬럼명 | 컬럼인덱스(순서) | 별칭 [정렬순서]
    정렬 순서 : rlqhs ASC(오름차순), DESC(내림차순)
    Why? 정렬 해야하는가???


SELECT *
FROM emp
ORDER BY ename ASC;
// a b c d e f g 이렇게 됬음
// 1 2 3 ....       --> 오름차순 ( ASC ==> DEFAULT )  어센딩
// 100 99 98 ... 1  --> 내림차순 ( DESC ==> 명시해야 사용 가능) 디센딩
SELECT *
FROM emp
ORDER BY ename DESC;

// 잡으로하고 한번더 다른거로 하고싶으면 콤마찍고 써라 이중정렬
SELECT *
FROM emp
ORDER BY JOB DESC, SAL DESC, ename;
// 잡은 어센딩, 셀은 디센딩 가능 둘다 가능
// 컬럼뒤에 알아서 붙여라
// 동일한 데이터 출력시 또 붙여라

// 정렬 : 컬럼명이 아니라 select 절의 컬럼 순서 (index) 숫자 박아버리기
SELECT *
FROM emp
ORDER BY  2;
// 위같이 하면 enpno, ename 순이기에 ename이 오름차순으로 정렬된다.

SELECT empno, job, mgr as m
FROM emp
ORDER BY  m;
// 셀렉을 지정하면 지정한 컬럼을 변경
// 권장 하지는 않는다. 
// 알리아스 사용시 --> 알리아스 명칭으로도 정렬이 가능하다


// 데이터 정렬 실습 1
dept 테이블 모든 정보 부서이름을 오름차순 조회
dept 테이블 모든 정보를 부서위치로 내림차순 정렬
// 컬럼명 명시안합니다

SELECT *
FROM dept
ORDER BY dname;

SELECT *
FROM dept
ORDER BY loc DESC;

//실습 2
EMP 테이블에서 커밋정보만 조회하고
커밋 많은사람 조회
상여같으면 사번 내림차순

SELECT *
FROM emp
WHERE COMM > 0
ORDER BY comm DESC, empno DESC ;

SELECT *
FROM emp
WHERE COMM IS NOT NULL
        AND COMM != 0
ORDER BY comm DESC, empno DESC ;


// 실습 3
EMP테이블에서 관리자가 있는 사람 조회
잡순으로 오름차숨 정렬
직군애ㅣ 같으면 사번이 큰사원 먼저 조회하게 정렬

SELECT *
FROM emp
WHERE mgr is not null
ORDER BY JOB , empno DESC ;

// 실습 4
emp테이블에서 부서번호가 10번 혹은 30번이고
급여가 1500이 넘는사람 조회
이름으로 내림차순 정렬

SELECT *
FROM emp
WHERE deptno in(10,30)
        and sal > 1500
ORDER BY  ename DESC;
// IN이란 OR랑 동일한 값으로 만들 수 있다. 실무자입장에서는 IN연산자가 편하다

// 문법적으로 정렬자체는 어렵지 않다.
// 이제 정렬가지고 실무에서 어떻게 쓰는지 .. --> 페이징 처리
/*
페이징 처리(게시글) ==> 처리하려는 기준이 뭔데 ??? ( 일반적으로는 게시글의 작성일시 역순) 
페이징 처리 : 전체 데이터를 조회하는게 아니라 페이지 사이즈가 정해졌을때 원하는 페이지의 게시글 데이터만 가져오는 방법
                (4000건을 다 조회하고 필요한 20건만 사용하는 방법 --> 전체조회 ( 4000 ) )
                (4000건의 데이터 중에서 원하는 페이지의 20건만 조회 --> 페이징 처리 ( 20 ) )
페이징 처리시 고려할 변수 : 페이지 번호, 페이지 사이즈
*/
ROWNUM      : 행번호를 부여하는 특수 키워드(오라클에서만 제공)
            * 제약사항
                    ROWNUM은 WHERE절에서도 사용이 가능하다.
                    EMP테이블 전체데이터 14건
                    페이지 사이즈 5건
                    1페이지 : 1 ~ 5
                    2페이지 : 6 ~ 10
                    3페이지 : 11 ~ 15(14)
                    * 단, ROWNUM의 사용시 1부터 사용하는 경우에만 사용 가능
                    WHERE ROWNUM BETWEEN 1 AND 5        0
                    WHERE ROWNUM BETWEEN 6 AND 10       X
                    WHERE ROWNUM = 1; ==> O
                    WHERE ROWNUM = 2; ==> X
                    WHERE ROWNUM <= 10; ==> O // 1부터 10까지이니까
                    WHERE ROWNUM > 10; ==> X // 11부터 안되 돌아가
                    * SQL은 다음의 순서로 실행된다.  
                        FROM => WHERE => SELECT => ORDER BY 5
                                ORDER BY와 ROWNUM을 동시에 사용하면 정렬된 기준으로 ROWNUM이 부여되지 않습니다.
                                (SELECT절이 먼저  실행되므로 ROWNUM이 부여된 상태에서 ORDER BY 절에 의해 정렬이 된다.)
인라인 뷰    :
ALIAS       :
//

SELECT empno, ename
FROM emp;
2개 컬럼만 잇는데 사번앞에 번호를 입력할수는 없을까>
SELECT ROWNUM, empno, ename
FROM emp;
// ROWNUM을 번호를 부여할수잇다.
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 6 AND 10;
// 실행되나 값이 안나옴 2번쨰 페이지엿는데
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 5;
// 1번에서 5번까지는 잘나옴
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 11 AND 15;
// 3페이지도 안나오네

SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ENAME;
// rownum이 꼬임 이놈도 정렬이 되야함
// 실행순서 FROM -- SELECT -- ORDER BY 적용
//-   -   -   -   -   -   -   -   -   -   -   -       -   -       -   -   -   -
// 인라인뷰 테이블을 내가 임의 로만드는것 
(SELECT empno, ename
FROM EMP);
//( 소괄호 )를 집어넣어서 테이블화 시킨다. ==> FROM절에 올수있다.
SELECT ename
FROM (SELECT empno, ename
        FROM EMP);
//셀렉에 잡을 넣으면 업어서 에러가 뜬다 프롬에 기술한 컬럼외에 다른것들은 에러다 이말
SELECT ROWNUM, empno, ename
FROM (SELECT empno, ename
        FROM EMP
        ORDER BY ename);
// 아래꺼랑 비교해서 되는 이유
SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;

SELECT *
FROM
(SELECT ROWNUM RN, empno, ename
  FROM (SELECT empno, ename
        FROM EMP
        ORDER BY ename))
WHERE RN BETWEEN (:page -1) * :pagesize + 1 AND :page * :pagesize;
// 오라클에서 사용하는 페이징 처리의 기본
// 1 인라인- 셀렉이 오더보다 먼저니까 정렬때리고
// 2 인라인 - 로우넘에 알리아스를 먹여서 다음에 조건을 쓰기위해서
// 3        - 알리아스로 조건사용 가능


페이지사이즈 - 5건
1P. RN BETWEEN 7 AND 15;
2P. RN BETWEEN 7 AND 15;
3P. RN BETWEEN 7 AND 15;
NP.                 (n*5-4) and (5*n) 
페이지사이즈 공식 : {(n-1)*pasgesize + 1} and (n*pagesize)
            BETWEEN (page -1) * pagesize + 1 AND page * pagesize ;

// sql 변수 선언하기 : 콜론 붙이기 앞에 
                ==> 바인드 설정이라는 창이뜬다 / 변수에 맞는 값을 집어넣고 실행한다.


// rownum 실습 1
emp테이블에서 로우넘값이 1~10인 값만 조회
정렬없이
//
SELECT *
FROM 
(SELECT ROWNUM rn, empno, ename
FROM
(SELECT empno, ename
FROM EMP))
WHERE rn BETWEEN 1 and 10;

// 실습 2
로우넘 11~ 2-0인값을 조회해라
SELECT *
FROM
(SELECT ROWNUM RN, empno, ename
FROM
(SELECT empno, ename
        FROM EMP))
WHERE RN BETWEEN 11 AND 20;

// 실습 3
EMP 이름컴럶을 오름차순 적용
11 ~ 14 행조회 쿼리
SELECT 테이블별칭.*
FROM
(SELECT ROWNUM RN, EMPNO, ENAME
FROM 
(SELECT EMPNO, ENAME
FROM EMP))테이블별칭
WHERE RN BETWEEN 11 AND 14
ORDER BY ENAME;

ROW넘 용도 
    페이징 처리 ROW_1~3
    다른 행과 구분되는 유일한 가상의 컬럼 생성
    튜닝시
        인라인뷰안에서 로우넘사용시 뷰 MERGING이 일어난지 않는다.


SELECT ROWNUM, 테이블.*
FROM emp 테이블;
-- 한정자.  아스테리스크 앞에 [ emp. ]을 붙여서 로우넘 다 받기
-- 컬럼명에는 안붙느다.
-- 테이블에도 알리아스를 줄 수 있다.
-- as키워드 못쓴다.
-- 무조건 그냥 한칸 띄어서 쓰자
-- 테이블알리아스 = 조인 베우는데 , 프롬에 다른테이블에 올수잇는데 테이블끼리 겹치는게 있을 수 있으니 구분하기 위해서 쓴다.









































