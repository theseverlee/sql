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
 
 
 
 