2021-04-02
-- 시퀀스 객체 sequence

-- 자동으로 증가하는 값을 반환할 수 있는 객체
-- 테이블에 독립적(다수의 테이블에서 동시 참조 가능)
-- 기본키로 설정할 적당한 칼럼이 존재하지 않는 경우 자동으로 증가되는 컬럼의 속성으로 주도 사용된다.
( 사  용 형 식 )
CREATE SEQUENCE 시퀀스명
    [ START WITH n ]             -- 시작 숫자, 생략하면(디폴트 값) MINVALUE
    [ INCREMENT BY  n ]             -- 증감 숫자, 생략시(디폴트 값)  1
    [ MAXVALUE n | NOMAXVALUE ]     --  사용하는 최대값, 디폴트는 NOMAXVALUE / 10^27까지 사용
    [ MINVALUE n | NOMINVALUE ]     -- 사용하는 최소값, 디폴트는 NOMINVALUE / 1
    [ CYCLE | NOCYCLE ]             -- 최대(최소)까지 도달한 후 다시 시작할 것인지 여부 / 디폴트는 NOCYCLE
    [ CACHE n | NOCACHE ]           -- 생성할 값을 캐시에 미리 만들어 사용 / 디폴트는 CACHE 20
    [ ORDER | NO ORDER ]            -- 정의된대로 시쿼스 생성 강제 / 디폴트는 NOORDER
    
-- 조심해야될 사항
한번 건너뛴 숫자는 뒤로올 수 없다.(재사용할 수 없다.) / 테이블에 독립적이기 때문에 
**** 시퀀스 객체 의사(Preudo Column)컬럼
    1. 시퀀스명.ENXTVAL : '시퀀스'의 다음 값 반환 계속 다음값 다음값 증가. / 만들어지고 첫번째로 와야 해
    2. 시퀀스명.CURRVAL : '시퀀스'의 현재 값 반환 / 안만들어졌을때(값 배정이 안됬을때) 
    -- 시퀀스가 생성되고 해당 세션의 첫 번째 명령은 반드시 시퀀스명.NEXTVAL 이여야 함  
            
LPROD ID는 1씩 증가 GU는 품목별로 맞게 증가
위 테이블에 다음 자료를 삽입하시오(단, 시퀀스를 이용하시오)
    [자료]
    LPROD_ID : 10번 부터
    LPROD_GU : P501,    502,    503
    LPROD_NM : 농산물, 수산물,    임산물
    
1. 시퀀스 부터 만들어야한다. 생성;
CREATE SEQUENCE SEQ_LPROD
    START WITH 10;

SELECT SEQ_LPROD.CURRVAL
FROM DUAL;
    -- EX) 비상긴급연락체계 첫번째 녀석이 없는거임
    
2. 자료를 삽입합니다.
INSERT INTO LPROD VALUES(SEQ_LPROD.NEXTVAL,'P501','농산물');
INSERT INTO LPROD VALUES(SEQ_LPROD.NEXTVAL,'P502','수산물');
INSERT INTO LPROD VALUES(SEQ_LPROD.NEXTVAL,'P503','임산물');
SELECT *
FROM LPROD;
-- 컬럼명을 삽입하는 경우
--1. 대입하는 데이터 컬럼수가 많을 때는 어떤 자료가 어디에 넣어야 하는지 알려주기 위해서
--2. 모든 컬럼에 자료를 대입하는게 아니라 필요한 컬럼에만 넣는거지 , 다른곳은 NULL
-- 컬럼명을 쓰지 않은경우
-- 컬럼에 데이터 타입에 맞는걸 순서대로 입력하겠다.
    
사용 예) 오늘이 2005년 7월 28일ㄴ 경우 'm001'회원이 'p201000004'를 5개를 구입했을 때
        cart테이블에 해당자료는 삽입하는 쿼리를 작성하시오
        먼저 날짜를 2005년 7월 28일로 변경 후 작성할 것
-- 이벤트(인서트 업데이트 딜리트)발생시 = 트리거    
    
select sysdate
from dual;

**CART_NO 생성
SELECT TO_CHAR(TO_CHAR(SYSDATE, 'YYYYMMDD') || MAX(SUBSTR(CART_NO,9))+1)
FROM CART;

SELECT TO_CHAR(MAX(CART_NO)+1)
FROM CART;
-- 오라클은 숫자가 우선이다  / 자바는 문자가 우선
SELECT 100 + '100'  FROM DUAL;
-- 위같이 하면 복잡하니 시퀀스를 만들자
1. 순번을 확인하자
SELECT MAX(SUBSTR(CART_NO,9)) FROM CART;
2. 시퀀스 객체 생성
CREATE SEQUENCE SEQ_CART
    START WITH 5;
    
INSERT INTO CART(CART_MEMBER,CART_NO,CART_PROD,CART_QTY)
        VALUES('m001',(TO_CHAR(SYSDATE, 'YYYYMMDD') || LTRIM(TO_CHAR(SEQ_CART.NEXTVAL,'00000'))),
                'P201000004',5);


** 시퀀스가 사용되는곳
1. select문의   SELECT 절 ( 서브쿼리 제외)
2. INSERT문의  SELECT 절(서브쿼리, VALUE절
3. UPDATE문의 SET절

** 시퀀스가 제한되는곳
1. SELECT, DELETE, UPDATE문에서 사용되는 서브쿼리
2. VIEW를 대상으로 사용하는 쿼리
3. DISTINCT가 사용된 SELECT절
4. GROUP BY/ ORDER BY가 사용된 SELECT 문
5. 집합연산자(UNION, MINUS, INTERSECT)가 사용된 SELECT 문
6. SELECT 문의 WHERE절

--               ----------------------------------------------------------
SYNONYM 객체
- 동의어 의미 / 알리아스 개념
- 오라클에서 생성된 객체에 별도로 이름을 부여
- 긴 이름의 객체를 쉽게 사용하기 위한 용도로 주로 사용
    (사용 형식)
CREATE [OR REPLACE] SYNONYM 동의어 이름
    FOR 객체명;
    
    1. '객체'에 별도의 이름인 '동의어 이름'을 부여

사용예) 
1. HR계정의 REGIONS테이블의 내용을 조회
SELECT HR.REGIONS.REGION_ID AS 지역코드,
       HR.REGIONS.REGION_NAME AS 지역명
  FROM HR.REGIONS;    
  -- 이때는 위치한 풀네임을 쓴다.
2. 테이블 별칭를 사용한 경우
SELECT A.REGION_ID AS 지역코드,
       A.REGION_NAME AS 지역명
  FROM HR.REGIONS A;
  
CREATE SYNONYM REG FOR HR.REGIONS;

3. 동의어를 사용한 경우
SELECT A.REGION_ID AS 지역코드,
       A.REGION_NAME AS 지역명
  FROM REG A;
  
-----   -   --  -   --  -   -   -   -   -   -   -   -   ----    -
INDEX 객체
- 데이터 검색 효율을 증대 시키기 위한 도구
- DBMS의 부하를 줄여 전체 성능향상
- 별도의 추가공간이 필요하고 INDEX FILE을 위한 PROCESS가 요구됨
1. 인덱스가 요구된느곳
    자주 검색되는 컬럼
    기본키(자동 인덱스 생성)외 외래키
    SORT, GROUP의 기본 컬럼
    JOIN조건에 사용되는 컬럼
2. 인덱스가 불필요한 곳
    컬럼의 도메인이 적은 경우(성별,초딩학년, 나이 등)(값으 범위)중복이 많은경우
    검색조건으로 상요했으나 데이터의 대부분이 반환되는 경우
    SELECT 보다 DML명령의 효율성이 중요한 경우
    
    해쉬코드메세지 데이터가 저장될 주소에서 꺼내오는 기법

3. 인덱스 종류(중요한건 아닌데)
    1. UNIQUE
    - 중복 값을 허용하지 않는 인덱스
    - null값을 가질 수 있으나 이것도 중복해서는 안됨
    - 기본키, 외래키 인덱스가 이에 해당
    2. NON UNIQUE
    - 중복값을 허용하는 인덱스
    3. NORMAL INDEX
    -   default INDEX
    - 트리구조로 구성(동일 검색 횟수 보장)
    - 컬럼값과 rowid(물리적 주소)
    4.function-based Normal INDEX
    - 조건절에 사용되는 함수를 이용한 인덱스
    5.bitmap index
    - rowid와 칼럼 값을 이진으로 변환하여 이를 조합한 값을 기반으로 저장
    - 추가, 삭제, 수정이 비번히 발생되는 경우 비효율적
    
    기본키 PRIMARY KEY
    어떤 테이블이든 거의 무조건 하나는 들어간다 
    테이블당 하나만 정의 가능하다
    NOT NULL + UNIQUE 의 기능
    1) 컬럼명 옆에 바로 주키를 선언
    2) [해당 컬럼] [타입] CONSTRAINT [제약조건 명] PRIMARY KEY
    3) CONSTRAINT [제약조건 명] PRIMARY KEY([컬럼명1],[컬럼명2],...)


