/* 수업전 컬럼확인용 */
select * from emp;
select * from DEPT;
select * from student;
select * from PROFESSOR;
select * from employees;
select * from locations;
select * from department;
DESC salgrade;
/*23/06/26*/
/*PIVOTING INSERT
  - */
/*사용예*/

/*데이터 수정
  - UPDATE 명령문은 테이블에 저장된 데이터 수정을 위한 조작어
  - WHERE 절을 생략하면 테이블의 모든 행을 수정*/
/*사용예
  - 교수번호가 9903인 교수의 현재 직급을 '부교수'로 수정*/
SELECT profno, name, position
FROM professor
WHERE profno = 9903;

UPDATE professor
SET POSITION = '부교수'
WHERE profno = 9903;

COMMIT;

SELECT profno, name, position
FROM professor
WHERE profno = 9903; 
/*문제 : 학생테이블에서 박동진 학생의 몸무게를 80으로 변경*/
UPDATE student
SET weight=80
WHERE name = '박동진';

SELECT * from student
WHERE name = '박동진';

ROLLBACK;

/*서브쿼리를 이용한 테이터 수정
  -UPDATE 명령문의 SET 절에서 서브쿼리를 이용*/
/*사용예
  - 서브쿼리를 이용하여 학번이 10201인 학생의 학년과 학과번호를 10103학번 학생의
    학년과 학과번호와 동일하게 수정하여라*/
UPDATE student
SET (grade, deptno) = (SELECT grade, deptno
                       FROM student
                       WHERE studno = 10103)
WHERE studno = 10201;

COMMIT;

SELECT studno, grade, deptno
FROM student
WHERE studno = 10201;

/*문제 : 교수테이블에서 성연희 교수의 직급과 동일 직급을 가진교수들 중 현재
        급여가 350이하인 교수들의 급여를 12% 인상 하여라*/
UPDATE professor
SET sal = sal * 1.12
WHERE position = (SELECT position
                  FROM professor
                  WHERE name = '성연희')
AND sal <= 350;

SELECT name, sal
FROM professor;
/*문제 : 사원테이블에서 'DALLAS'에 근무하는 사원들의 급여를 100으로 수정*/
UPDATE emp
SET sal = 100
WHERE deptno = (SELECT deptno
                FROM DEPT
                WHERE LOC = 'DALLAS');

select * from emp;

/*데이터 삭제
  - DELETE : 테이블에 저장된 데이터 삭제를 위한 조작어
  - WHERE 절을 생략하면 테이블의 모든 행 삭제*/
  
DELETE FROM student;

ROLLBACK;
/*단일행 삭제예
  - 학생테이블에서 학번이 20103인 학생의 데이터를 삭제하여라*/
DELETE
FROM student
WHERE studno = 20103;

commit;

SELECT * FROM student
WHERE studno = 20103;

/*서브쿼리를 이용한 데이터 삭제 예
  - 학생 테이블에서 컴퓨터 공학과에 소속된 학생을 모두 삭제하라*/
DELETE FROM student
WHERE deptno = (SELECT deptno
                FROM department
                WHERE dname = '컴퓨터공학과');
                
SELECT * FROM student
WHERE deptno = (SELECT deptno
                FROM department
                WHERE dname = '컴퓨터공학과');
                
ROLLBACK;
/*사원테이블에서 DALLAS에 근무하는 사원들을 삭제하세요*/
DELETE FROM emp
WHERE deptno = (SELECT deptno
                FROM DEPT
                WHERE LOC = 'DALLAS');
                
SELECT * FROM student
WHERE deptno = (SELECT deptno
                FROM DEPT
                WHERE LOC = 'DALLAS');
                
ROLLBACK;

/*MERGE
  - 구조가 같은 두개의 테이블을 비교하여 하나의 테이블로 합치기 위한 데이터 조작어
  - WHEN 절의 조건절에서 결과 테이블에 해당 행이 존재하면 UPDATE 명령문에 의해
    새로운 값으로 수정, 그렇지 않으면 INSERT 명령문으로 새로운 행을 삽입*/
/*사용예
  - professor 테이블과 professor_temp 테이블을 비교하여 professor 테이블에 있는
    기존 데이터는 professor_temp테이블의 데이터에 의해 수정하고, professor 테이블에 없는 데이터는 신규로 입력*/
CREATE TABLE professor_temp AS
SELECT *
FROM professor
WHERE position = '교수';

UPDATE professor_temp
SET position = '명예교수'
WHERE position = '교수';

INSERT INTO professor_temp
VALUES(9999, '김도경', 'aromm21', '전임강사', 200, SYSDATe, 10, 101);

/*MERGE 사용예2*/
merge into professor p
using professor_temp f
on (p.profno = f.profno)
when matched then
update set p.position = f.position
when not matched then
insert values(f.profno, f.name, f.userid, f.position, f.sal, f.hiredate, f.comm, f.deptno);

select * from professor;

/*트랜잭션 관리
  - 관계형 데이터베이스에서 실행되는 여러개의 SQL 명령문을 하나의 논리적 작업단위로 처리하는 개념
  - COMMIT : 트랜잭션의 정상적인 종료
  - ROLLBACK : 트랜잭션의 전체 취소*/

/*시퀀스
  - 유일한 식별자
  - 기본 키 값을 자동으로 생성하기 위하여 일련번호를 생성 객체*/
/*시퀀스 생성 
  사용예 : 시작번호는1, 증가치는 1, 최대 값은 2인 s_seq 시퀀스를 생성하라*/
CREATE SEQUENCE s_seq
INCREMENT BY 1
START WITH 1
MAXVALUE 100;

SELECT min_value, max_value, increment_by, last_number
FROM user_sequences
WHERE SEQUENCE_NAME = 'S_SEQ';
/*CURRVAL 과 NEXTVALUE 함수
  - INSERT, UPDATE 문에서 사용
  - 서브쿼리, GROUP BY, HAVING, ORDER BY, DISTINCT와 함께 사용할 수 없으며, 컬럼의 기본값으로 사용할 수 없음
  - CURRVAL : 시퀀스에서 생성된 현재번호를 확인
  - NEXTVALUE : 시퀀스에서 다음 번호 생성*/

INSERT INTO EMP VALUES
(S_SEQ.NEXTVAL, 'test1','SALESMAN', 7698,sysdate,800,NULL,20);

INSERT INTO EMP VALUES
(S_SEQ.NEXTVAL, 'test2','SALESMAN', 7698,sysdate,800,NULL,20);

INSERT INTO EMP VALUES
(S_SEQ.NEXTVAL, 'test3','SALESMAN', 7698,sysdate,800,NULL,20);

SELECT * from emp;

SELECT S_SEQ.CURRVAL
FROM dual;

SELECT S_SEQ.NEXTVAL
FROM dual;
/*시퀀스 정의 변경시
  - ALTER SEQUENCE 명령문 사용
  사용예 : s_seq 시퀀스의 최대값을 200으로 변경하여라*/
ALTER SEQUENCE s_seq MAXVALUE 200;

SELECT min_value, max_value, increment_by, last_number

/*시퀀스 삭제
  - DROP SEQUENCE 명령문사용
  사용예 : s_seq 시퀀스를 삭제하여라*/
drop sequence s_seq;


/*테이블 관리*/
/*테이블 생성
  - 사용예 : 연락처 정보를 저장하기 위한 주소록테이블을 생성하라*/
CREATE TABLE address
(id NUMBER(3),
name VARCHAR2(50),
addr VARCHAR2(100),
phone VARCHAR2(30),
emmail VARCHAR2(100));

SELECT * FROM tab;

DESC address;

/*DEFAULT 옵션
  - 칼럼의 입력값이 생략될 경우에 NULL대신에 입력되는 기본값을 지정하기 위한 기능*/

/*서브쿼리를 이용한 테이블 생성
  - CREATe TABlE 명령문에서 서브쿼리 절을 이용하여 다른 테이블의 구조와 데이터를 복사하여 새로운 테이블 생성가능
  - 서브쿼리의 출력결과가 테이블의 초기 데이터로 삽입
  예제 */
INSERT INTO address
VALUES(1, 'HGDONG', 'SEOUL', '123-4567', 'gdhong@naver.com');

COMMIT;

SELECT * FROM address;
/*사용예 : 서브쿼리절을 이용하여 주소록테이블의 구조와 데이터를 복사하여 addr_second 테이블을 생성하라*/
CREATE TABLE addr_second(id, name, addr, phone, e_mail)
AS SELECT * FROM address;

DESC addr_second;

/*테이블 구조 복사
  - 서브쿼리를 이용한 테이블 생성시 데이터는 복사하지 않고 기존 테이블의 구조만 복사 가능
  - 서브쿼리의 WHERE 조건절에 거짓이 되는 조건을 지정하여 출력 결과 집합이 생성되지 않도록 지정*/
/*  사용예 : 주소로게이블에서 id, name 칼럼만 복사하여 addr_fourth 테이블을 생성하라,
          단, 데이터는 복사하지 않는다. */
CREATE TABLE addr_fourth
AS SELECT id, name FROM address
WHERE 1=2;

DESC addr_fourth;

SELECT * FROM addr_fourth;

/*서브쿼리를 이용한 테이블 생성
  사용예: 주소록테이블에서 id,name 칼럼만 복사하여 adde_third테이블을 생성하라*/
CREATE TABLE addr_third
AS SELECT id, name FROM address;

DESC addr_third;

SELECT * FROM addr_third;

/*테이블 구조 변경
  - ALTER TABLE 명령문이용
  - 칼럼 추가, 삭제, 타입이나 길이의 재정의와 같은 작업
  사용예 : 주소록테이블에 날짜 타입을 가지는 birth 칼럼을 추가하여라*/
ALTER TABLE address
ADD (birth DATE);

DESC address;
/*실습예 : 주소록테이블에 문자타입을 가지는 comment 칼럼을 추가하여라 기본값은 No Comment로 지정*/
ALTER TABLE address
ADD(comments VARCHAR2(200) DEFAULT 'NO Comment');

DESC address;

/*테이블 칼럼 삭제
  - 테이블 내의 특정 칼럼과 칼럼의 데이터를 삭제
  - 2 개이상의 칼럼이 존재하는 테이블에서만 삭제 가능
  사용예: 주소록 테이블에서 comment 칼럼을 삭제하여라.*/
ALTER TABLE address DROP COLUMN comments;
DESC address;

/*테이블 칼럼 변경
  - 테이블에서 칼럼의 타입, 크기, 기본값 변경가능
  - 기존칼럼에 데이터가 없는 경우 : 칼럼타입이나 크기 변경이 자유로움
  - 기존데이터가 존재할 경우 : 타입변경은 CHAR와 VARCHAR2만 허용
                            변경한 칼럼의 크기가 저장된 데이터의 크기보다 같거나 클경우 변경가능
  사용예 : */
ALTER TABLE address
MODIFY phone VARCHAR2(50);

/*테이블 이름 변경
  - RENAME 명령문 사용
  - 뷰, 시퀀스, 동의 등과 같은 데이터베이스 객체의 이름 변경 가능
  사용예 : addr_second 테이블 이름을 client_address로 변경하여라*/
RENAME addr_second TO client_address;
SELECT * FROM tab;

/*테이블 삭제
  - 기존 테이블과 데이터를 모두 삭제
  - DROP TABLE 명령문 사용
  - 삭제할 테이블의 기본 키나 고유키를 다른 테이블에서 참조하고 있는 경우 삭제 불가능
  사용예 : addr_third 테이블을 삭제하여라*/
DROP TABLE addr_third;
SELECT * FROM tab
WHERE tname = 'ADDR_THIRD';
/*TRUNCATE 명령문
  - 테이블 구조는 그대로 유지하고, 테이블의 데이터와 할당된 공간만 삭제
  - 테이블에 생성된 제약조건과 연관된 인덱스, 뷰, 동의어는 유지
  - DDL문이므로 ROLLBACK 이 불가능 WHERE 절을 이용하여 특정 행만 삭제하는것이 불가능
  사용예 : 테이블의 데이터와 할당된 공간을 삭제하여라*/
TRUNCATE TABLE client_address;

/*주석추가
  - 테이블이나 칼럼에 최대 2,000 바이트까지 주석을 추가
  - COMMENT ON TABLE ... IS 명령문 이용
  사용예 : 주소록 테이블에서 '고객 주소록을 관리하기 위한 테이블'이라는 주석을 추가하여라*/
COMMENT ON TABLE address
IS '고객 주소록을 관리하기 위한 테이블';
/*사용예 : 주소록 테이블의 name 칼럼에 '고객이름'이라는 주석을 추가하여라*/
COMMENT ON COLUMN address.name
IS '고객 이름';

/*주석확인방법*/
SELECT comments
FROM user_tab_comments
WHERE table_name = 'ADDRESS';
/*컬럼주석 확인하는 방법*/
SELECT * FROM user_col_comments
WHERE table_name = 'ADDRESS';
/*테이블 주석 삭제*/
COMMENT ON TABLE ADDRESS IS '';
/**/
COMMENT 

/*데이터 사전*/
/*데이터 사전의 종류
  - 다수의 사용자가 동일한 데이터를 공유
  - 읽기 전용 뷰로 구성
  - 용도에 따라 USER, ALL, DBA 접두어를 사용하여 분류*/
/*USER_ 데이터 사전 뷰
  - 일반 사용자와 가장 밀접하게 관련된 뷰
  사용예 : USER_ 데이터 사전뷰 조회예*/
SELECT table_name FROM user_tables;
/*ALL_ 데이터 사전 뷰
  - 데이터베이스 전체 사용자와 관련된 뷰
  - 해당 객체의 소유자를 확인가능
  사용예 : ALL_ 데이터 사전뷰 조회예*/
SELECT owner, table_name FROM all_tables;  
/*DBA_ 데이터 사전 뷰
  - 시스템 관리와 관련된 뷰
  사용예 : DBA_ 데이터 사전뷰 조회예*/
SELECT owner, table_name FROM dba_tables;


/*데이터 무결성*/
/*데이터 무결성 제약조건의 개념
  - 데이터의 정확성과 일관성을 보장
  장점
  - 테이블생성시 무결성 제약조건을 정의가능
  - 테이블에 대한 정의, 데이터 딕셔너리에 저장되므로 응용프로그램에서 입력된 모든 데이터에 대해 동일하게 적용
  종류
  - NOT NULL
  - 고유키(nuique key)
  - 기본키(primary key)
  - 참조키(foreign key)
  - CHECK */
  
/*dept에서 30번 부서를 삭제하세요*/
DELETE FROM dept
WHERE deptno = 30; /*자식 테이블에 존재하기 때문에 오류발생*/
/*삭제 순서도*/
/*emp에서 33번 SALES 부서를 추가하세요*/
INSERT INTO dept
VALUES(33,'SALES','SEOUL');
/*emp에서 30번 부서 소속사원을 33번부서로 변경해보세요*/
UPDATE emp
SET deptno = 33
WHERE deptno = 30;
/*dept 테이블에서 30번 부서를 삭제하세요*/
DELETE FROM dept
WHERE deptno = 30;

select * from emp;

/*무결성 제약조건 생성
  - 테이블 생성과 동시에 정의*/
/*무결성 제약조건 생성 예*/
CREATE TABLE subject /*강좌 테이블 인스턴스*/
    (subno NUMBER(5)
        CONSTRAINT subject_no_pk PRIMARY KEY
        DEFERRABLE INITIALLY DEFERRED
        USING INDEX TABLESPACE indx,
    subname VARCHAR2(20)
        CONSTRAINT subject_name_nn NOT NULL,
    term VARCHAR2(1)
        CONSTRAINT subject_term_ck CHECK (term in('1', '2')),
    type VARCHAR2(6));
/*수강 테이블 인스턴스*/    
ALTER TABLE student
ADD CONSTRAINT stud_no_pk PRIMARY KEY(studno);
CREATE TABLE sugang
(studno NUMBER(5)
    CONSTRAINT sugang_studno_fk REFERENCES student(studno),
subno NUMBER(5)
    CONSTRAINT sugang_subno_fk REFERENCES subject(subno),
regdate DATE,
result NUMBER(3),
    CONSTRAINT sugang_pk PRIMARY KEY(studno, subno));
/*무결성 제약조건 조회*/
SELECT constraint_name, constraint_type
FROM user_constraints
WHERE table_name IN ('SUBJECT','SUGANG');
/*기존테이블에 무결성 제약조건 추가
 - NULL을 제외한 무결성 제약조건 추가 : ALTER ... ADD CONSTRAINT 명령문사용
 - NULL 무결성 제약조건 추가 : ALTER TABLE ... MODIFY 명령문사용
 사용예: */
ALTER TABLE student
ADD CONSTRAINT stud_idnum_uk UNIQUE(idnum);
ALTER TABLE student
MODIFY (name CONSTRAINT stud_name_nn NOT NULL);

ALTER TABLE department 
ADD CONSTRAINT dept_pk PRIMARY KEY(deptno); /*PRIMARY KEY를 꼭 지정해야 오류없이 출력가능 */

ALTER TABLE student ADD CONSTRAINT stud_deptno_fk
FOREIGN KEY(deptno) REFERENCES department(deptno);

/*실습 예 */
ALTER TABLE professor add constraints prof_pk PRIMARY KEY(profno);

/*무결성 제약조건에 의한 DML 명령문의 영향
  - 즉시제약 조건()에 위배되는 데이터 입력시 : 테이블에 데이터를 먼저 입력한 다음 무결성 제약조건을 위반하는 명령문을 롤백
  - 지연제약조건에 위배되는 데이터 입력시 : 트랜잭션내의 DML 명령문에서 제약조건 검사를 COMMIT 시점에서
    한꺼번에 처리하여 트랜잭션의 처리성능을 향상시키기 위해 사용
    사용예 : 강좌테이블에서 무결성 제약조건에 위반되는 데이터의 예를 입력하라*/
INSERT INTO subject VALUES(1, 'SQL', '1', '필수');
INSERT INTO subject VALUES(2, '', '2', '필수');/*오류 제약조건 위배*/
INSERT INTO subject VALUES(2, 'KEI', '3', '필수')/*오류 제약조건 위배*/

/*지연제약조건 위배되는 데이터 입력
  사용예 : */
INSERT INTO subject VALUES(4, '데이터베이스', '1', '필수');
INSERT INTO subject VALUES(4, '데이터모델링', '2', '선택'); /*제약조건 위배로 롤백*/
/*무결성 제약조건 삭제
  사용예 : 강좌테이블의 subject_pk_ck 무결성 제약조건을 삭제하라*/
SELECT constraint_name, constraint_type
FROM user_constraints
WHERE table_name = 'SUBJECT';

ALTER TABLE subject
DROP CONSTRAINT subject_term_ck;

SELECT constraint_name, constraint_type
FROM user_constraints
WHERE table_name = 'SUBJECT';

/*무결성 제약조건 활성화 및 비활성화*/
/*비활성화 사용예: 수강테이블의 sugang_pk, sugang_studno_fk 무결성제약조건을 비활성화 하여라*/
ALTER TABLE sugang
DISABLE CONSTRAINT sugang_Pk;

ALTER TABLE sugang
DISABLE CONSTRAINT sugang_studno_fk;

SELECT constraint_name, status
FROM user_constraints
WHERE table_name IN ('SUGANG','SUBJECT');

/*활성화 사용예 : 수강테이블의 sugang_pk, sugang_studno_fk 무결성제약조건을 활성화 하여라*/
ALTER TABLE sugang
ENABLE CONSTRAINT sugang_Pk;

ALTER TABLE sugang
ENABLE CONSTRAINT sugang_studno_fk;

SELECT constraint_name, status
FROM user_constraints
WHERE table_name = 'SUGANG' ;

/*문제풀이*/
/*1. 아래와 같이 EE 테이블을 생성하세요.
   Name		Null		Type
  --------       -------------  	        ------------
   EMPLOYEE_ID			NUMBER(7)
   LAST_NAME			VARCHAR2(25)
   FIRST_NAME			VARCHAR2(25)
   DEPTNO			NUMBER(2)
   PHONE_NUMBER			VARCHAR2(20)*/
  - 사용예 : 연락처 정보를 저장하기 위한 주소록테이블을 생성하라*/
CREATE TABLE EE
(EMPLOYEE_ID NUMBER(7),
 LAST_NAME VARCHAR2(25),
 FIRST_NAME VARCHAR2(25),
 DEPTNO NUMBER(2),
 PHONE_NUMBER VARCHAR2(20));

DESC EE; 
/*2. 1.에서 생성한 테이블에 아래와 같이 4건의 데이터를 입력하세요.
EMPLOYEE_ID	LAST_NAME	FIRST_NAME	DEPTNO		PHONE_NUMBER
----------------------------------------------------------------------------------------------------------
   1    test1		Ben		      10		123-4566	1100
   2	test2		Betty		  20		123-7890	1860
   3	test3		Chad	 	  20		123-8888	2200
   3	test4		haha	 	  20		123-8888	2200 */
INSERT INTO EE VALUES(1, 'test1', 'Ben', 10, '123-4566'); 
INSERT INTO EE VALUES(2, 'test2', 'Betty', 20, '123-7890 1860');
INSERT INTO EE VALUES(3, 'test3', 'Chad', 20, '123-8888 2200');
INSERT INTO EE VALUES(3, 'test4', 'haha', 20, '123-8888 2200');
select * from EE;
/*3. EE 테이블의 EMPLOYEE_ID열에 PRIMARY KEY 제약조건을 추가하세요.
   만약, 제약조건이 걸리지 않는다면 이유를 말하시고, 수정후 제약조건을 추가해 보세요.*/
ALTER TABLE EE
ADD CONSTRAINT EE_ID PRIMARY KEY(EMPLOYEE_ID); /*EMPLOYEE_ID 안에 중복값 있어 PK 설정 불가능*/

UPDATE EE SET EMPLOYEE_ID = 4
WHERE EMPLOYEE_ID = 3 AND LAST_NAME = 'test4';
ALTER TABLE EE
ADD CONSTRAINT EE_ID PRIMARY KEY(EMPLOYEE_ID);
select * from EE;
/*4. 위에서 생성한 EE 테이블의 DEPTNO는 DEPT테이블의 DEPTNO 컬럼을 참조하게 제약 조건을 설정해 보세요.*/
ALTER TABLE EE
ADD CONSTRAINT deptno_fk foreign key(deptno) references dept(deptno);
/*5. INSERT INTO ee(employee_id, first_name, deptno)
     VALUES(4, 'cindy',50);
     데이터를 입력하려고 하였으나 실패하였다. 이유는?*/
EMPLOYEE_ID컬럼이 PK값. 4라는 중복값이 허용되지 않는다.
/*6. 생성한 ee 테이블을 삭제해 보세요.*/
drop table EE;