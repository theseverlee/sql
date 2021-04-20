SELECT 
  FROM P1_BOARD;

CREATE SEQUENCE P1_RE_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE;

commit;


insert into P1_BOARD VALUES (001,'잡담','제목1','내용임',SYSDATE,'MASTER');
commit

insert into p1_board_re values (001,'댓글이지롱',sysdate,1,'MASTER');
insert into p1_board_re values (002,'힝 속았지',sysdate,1,'MASTER');



SELECT REG_DATE
FROM P1_BOARD;


select *
from p1_board
where board_no =1

DELETE P1_BOARD
WHERE BOARD_NO = 1

DELETE P1_BOARD_RE
WHERE BOARD_NO = 1

ROLLBACK

SELECT ROWNUM, B.RE_CONTENT, B.USER_ID, B.RE_DATE
 FROM P1_BOARD A INNER JOIN P1_BOARD_RE B ON(A.BOARD_NO = B.BOARD_NO)
WHERE A.BOARD_NO = 1
ORDER BY ROWNUM;


SELECT BOARD_NO, SUBJECT, TITLE, CONTENT, USER_ID, REG_DATE 
FROM P1_BOARD 
 WHERE BOARD_no = 1
 
 
 INSERT INTO P1_BOARD_RE VALUES (3,'언제끝나지',SYSDATE,3,'MASTER')
 
 delete p1_board_re
 where re_no = ( SELECT A.RN
                     FROM 
                        ( SELECT ROWNUM RN ,A.*
                            FROM 
                            ( SELECT B.RE_CONTENT, B.USER_ID, B.RE_DATE
                                 FROM P1_BOARD A INNER JOIN P1_BOARD_RE B ON(A.BOARD_NO = B.BOARD_NO)
                                WHERE A.BOARD_NO = 3
                                ORDER BY B.RE_NO)A)A
                                WHERE RN = 3)
 
 SELECT A.re_no
 FROM ( SELECT ROWNUM RN ,A.*
           FROM ( SELECT b.re_no,B.RE_CONTENT, B.USER_ID, B.RE_DATE
                     FROM P1_BOARD A INNER JOIN P1_BOARD_RE B ON(A.BOARD_NO = B.BOARD_NO)
                     WHERE A.BOARD_NO = 1
                    ORDER BY B.RE_NO)A)A
           WHERE RN = 3
           
 
 
SELECT ROWNUM ,A.RE_CONTENT, A.USER_ID, A.RE_DATE
FROM
( SELECT B.RE_CONTENT, B.USER_ID, B.RE_DATE
 FROM P1_BOARD A INNER JOIN P1_BOARD_RE B ON(A.BOARD_NO = B.BOARD_NO)
 WHERE A.BOARD_NO = 1
ORDER BY B.RE_NO)A
 
 
select *
from p1_board_re
order by re_no
 
 COMMIT
rollback
 
SELECT *
FROM P1_NOTICE
 
INSERT INTO P1_NOTICE VALUES(1,'어서오고','왜이리 죽상이야 도우너',SYSDATE,SYSDATE+7)
INSERT INTO P1_NOTICE VALUES(2,'여의보세혀','거기 누구 없소',SYSDATE,SYSDATE+7)


 NOTICE_BOARD_NO
NOTICE_TITLE
NOTICE_CONTENT
NOTICE_REG_DATE
NOTICE_LAST_DATE

update p1_notice set notice_title = '수정한글', notice_content = '배고프다'
where notice_board_no = 2




CREATE SEQUENCE P1_NOTICE_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE;

commit;

SELECT *
FROM P1_NOTICE
WHERE SYSDATE < NOTICE_LAST_DATE
ORDER BY 1 DESC

SELECT *
FROM P1_NOTICE
WHERE SYSDATE >= NOTICE_LAST_DATE
ORDER BY 1



ALTER TABLE P1_REGION_CODE ADD REGION_LARGE_CODE NUMBER(2);
                 
UPDATE P1_REGION_CODE SET REGION_LARGE_CODE = 1 WHERE REGION_LARGE_NAME = '서울';
UPDATE P1_REGION_CODE SET REGION_LARGE_CODE = 2 WHERE REGION_LARGE_NAME = '인천';
UPDATE P1_REGION_CODE SET REGION_LARGE_CODE = 3 WHERE REGION_LARGE_NAME = '광주';
UPDATE P1_REGION_CODE SET REGION_LARGE_CODE = 4 WHERE REGION_LARGE_NAME = '세종';
UPDATE P1_REGION_CODE SET REGION_LARGE_CODE = 5 WHERE REGION_LARGE_NAME = '대구';
UPDATE P1_REGION_CODE SET REGION_LARGE_CODE = 6 WHERE REGION_LARGE_NAME = '울산';
UPDATE P1_REGION_CODE SET REGION_LARGE_CODE = 7 WHERE REGION_LARGE_NAME = '대전';
UPDATE P1_REGION_CODE SET REGION_LARGE_CODE = 8 WHERE REGION_LARGE_NAME = '부산';

COMMIT;

SELECT ROWNUM ,a.*
  FROM (SELECT *
         FROM P1_USER
        WHERE USER_TYPE ='USER'
        ORDER BY USER_NAME) a
  
SELECT A.USER_ID
FROM
(SELECT ROWNUM RN ,a.*
  FROM (SELECT *
         FROM P1_USER
        WHERE USER_TYPE ='USER'
        ORDER BY USER_NAME) a)A
WHERE RN = 8
INSERT INTO P1_USER VALUES('USER', '1', '1', '박신혜', 01012345678,00000,'대전광역시 중구 대덕인재개발원', '402호');

INSERT INTO P1_USER VALUES('OWNER', 'MASTER', '1', '관리자', 01012345678,00000,'대전광역시 중구 대덕인재개발원', '402호');
INSERT INTO P1_USER VALUES('OWNER', 'A', '1', '김공갈', 01012345678,00000,'대전광역시 중구 대덕인재개발원', '402호');
INSERT INTO P1_USER VALUES('OWNER', 'B', '1', '리환자', 01012345678,00000,'대전광역시 중구 대덕인재개발원', '402호');
INSERT INTO P1_USER VALUES('USER', 'C', '1', '박신혜', 01012345678,00000,'대전광역시 중구 대덕인재개발원', '402호');
INSERT INTO P1_USER VALUES('USER', 'D', '1', '신신혜', 01012345678,00000,'대전광역시 중구 대덕인재개발원', '402호');
INSERT INTO P1_USER VALUES('USER', 'C', '1', '최신혜', 01012345678,00000,'대전광역시 중구 대덕인재개발원', '402호');
INSERT INTO P1_USER VALUES('USER', 'E', '1', '염신혜', 01012345678,00000,'대전광역시 중구 대덕인재개발원', '402호');
INSERT INTO P1_USER VALUES('USER', 'F', '1', '김신혜', 01012345678,00000,'대전광역시 중구 대덕인재개발원', '402호');
INSERT INTO P1_USER VALUES('USER', 'G', '1', '나신혜', 01012345678,00000,'대전광역시 중구 대덕인재개발원', '402호');
INSERT INTO P1_USER VALUES('USER', 'H', '1', '정신혜', 01012345678,00000,'대전광역시 중구 대덕인재개발원', '402호');
INSERT INTO P1_USER VALUES('USER', 'I', '1', '금신혜', 01012345678,00000,'대전광역시 중구 대덕인재개발원', '402호');
INSERT INTO P1_USER VALUES('USER', 'J', '1', '제갈신혜', 01012345678,00000,'대전광역시 중구 대덕인재개발원', '402호');
INSERT INTO P1_USER VALUES('USER', 'K', '1', '권신혜', 01012345678,00000,'대전광역시 중구 대덕인재개발원', '402호');
INSERT INTO P1_USER VALUES('USER', 'L', '1', '서신혜', 01012345678,00000,'대전광역시 중구 대덕인재개발원', '402호');
INSERT INTO P1_USER VALUES('USER', 'M', '1', '신혜', 01012345678,00000,'대전광역시 중구 대덕인재개발원', '402호');


COMMIT;


CREATE SEQUENCE P1_NON_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE;

INSERT INTO P1_NON_MEMBER VALUES (0);

 
 SELECT *
 FROM P1_MANAGER
 
 
 
 
 
 
 SELECT rownum ,a.*
 FROM P1_FACILITY a
 where 
 
 
 
 
 