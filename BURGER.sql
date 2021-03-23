-- 롯데리아와 나머지를 인라인 뷰 테이블로 받아서 계산    
SELECT B.SIDO, B.SIGUNGU, K맥버/롯데리아 도시발전지수
FROM
         (SELECT COUNT(STORECATEGORY) K맥버
          FROM BURGERSTORE
          WHERE SIDO = :SIDO
                   AND SIGUNGU = :SIGUNGU
                 AND STORECATEGORY NOT IN('LOTTERIA'))LOTTE,
          (SELECT COUNT(STORECATEGORY) 롯데리아
           FROM BURGERSTORE
          WHERE SIDO = :SIDO
                   AND SIGUNGU = :SIGUNGU
                 AND STORECATEGORY IN('LOTTERIA')) K맥버,
            BURGERSTORE B
WHERE SIDO = :SIDO
       AND SIGUNGU = :SIGUNGU
GROUP BY B.SIGUNGU, B.SIDO, K맥버, 롯데리아;   