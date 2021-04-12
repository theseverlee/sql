오라클 보강 1일차

1.ROLLUP
    - GROUP BY 절과 같이 사용하여 추가적인 집계정보를 제공함
    - 명시한 표현식의 수와 순서(오른쪽에서 왼쪽으로 순서)에 따라 레벨별로 집계한 결과를 반환한다.
    - 표현식이 N개 사용된 경우 n+1 가지의 집계 반환
    
    사용형식 _
SELECT 칼럼LIST
  FROM 테이블명
 WHERE 조건
 GROUP BY  [컬럼명] ROLLUP 컬럼명( 1,2,3...)
 - 롤럽안에 기술된 컬럼명들을 오른쪽부터 왼쪽순으로 레벨화 시키고 그것을 기준으로한 집계결과 반환
 3 32 321

사용예제_
우리나라 광역시도의 대출현황테이블에서 기간별, 지역별 구분하여
잔액합계를 조회하시오  (기간은 연도별로)
KOR_LOAN_STATUS;
-- 그룹바이절만 사용했을 때 
SELECT SUBSTR(PERIOD,1,4) AS "기간(년)",
        REGION AS 지역,
        GUBUN AS 구분,
        SUM(LOAN_JAN_AMT) AS 대출잔액
  FROM KOR_LOAN_STATUS
 GROUP BY SUBSTR(PERIOD,1,4), REGION, GUBUN
 ORDER BY 1

--롤업절을 사용 했을때
SELECT SUBSTR(PERIOD,1,4) AS "기간(년)",
        REGION AS 지역,
        GUBUN AS 구분,
        SUM(LOAN_JAN_AMT) AS 대출잔액
  FROM KOR_LOAN_STATUS
 GROUP BY ROLLUP(SUBSTR(PERIOD,1,4), REGION, GUBUN)
 ORDER BY 1

3개 칼럼 가지고 하나
오른쪽빼고 2개 가지고 2번째
1개로 3번째
2011년의 총값 NULL NULL 

2. CUBE
    - GROUP BY 절과 같이 사용하여 추가적인 집계정보를 제공함
    - CUBE절 안에 사용된 컬럼의 조합가능한 가지수 만큼의 종류별 집계 반환
    2^N의 개수를 가지수 나온다. 2 4 8 16 32 ....
    (큐브 사용) 3가지라 8종류
SELECT SUBSTR(PERIOD,1,4) AS "기간(년)",
        REGION AS 지역,
        GUBUN AS 구분,
        SUM(LOAN_JAN_AMT) AS 대출잔액
  FROM KOR_LOAN_STATUS
 GROUP BY CUBE(SUBSTR(PERIOD,1,4), REGION, GUBUN)
 ORDER BY 1

-- 부분 롤업
SELECT SUBSTR(PERIOD,1,4) AS "기간(년)",
        REGION AS 지역,
        GUBUN AS 구분,
        SUM(LOAN_JAN_AMT) AS 대출잔액
  FROM KOR_LOAN_STATUS
 GROUP BY SUBSTR(PERIOD,1,4), ROLLUP( REGION, GUBUN)
 ORDER BY 1
-- SUBSTR이 롤업밖에서 적용된거라 년도는 빠짐없이 나온다고~~~~~~~~~~~~~~~
롤업빡으로 그룹바이절이 나오면 롤업과 밖에섬 ㅏㄴ난 애들이동등하다 그래서 하나의 컬럼처럼 적용된다.
-- 부분 큐브
잘안씀 생략 ~~

--------------------------------------------------------

































