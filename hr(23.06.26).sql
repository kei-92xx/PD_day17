/* ������ �÷�Ȯ�ο� */
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
/*��뿹*/

/*������ ����
  - UPDATE ��ɹ��� ���̺� ����� ������ ������ ���� ���۾�
  - WHERE ���� �����ϸ� ���̺��� ��� ���� ����*/
/*��뿹
  - ������ȣ�� 9903�� ������ ���� ������ '�α���'�� ����*/
SELECT profno, name, position
FROM professor
WHERE profno = 9903;

UPDATE professor
SET POSITION = '�α���'
WHERE profno = 9903;

COMMIT;

SELECT profno, name, position
FROM professor
WHERE profno = 9903; 
/*���� : �л����̺��� �ڵ��� �л��� �����Ը� 80���� ����*/
UPDATE student
SET weight=80
WHERE name = '�ڵ���';

SELECT * from student
WHERE name = '�ڵ���';

ROLLBACK;

/*���������� �̿��� ������ ����
  -UPDATE ��ɹ��� SET ������ ���������� �̿�*/
/*��뿹
  - ���������� �̿��Ͽ� �й��� 10201�� �л��� �г�� �а���ȣ�� 10103�й� �л���
    �г�� �а���ȣ�� �����ϰ� �����Ͽ���*/
UPDATE student
SET (grade, deptno) = (SELECT grade, deptno
                       FROM student
                       WHERE studno = 10103)
WHERE studno = 10201;

COMMIT;

SELECT studno, grade, deptno
FROM student
WHERE studno = 10201;

/*���� : �������̺��� ������ ������ ���ް� ���� ������ ���������� �� ����
        �޿��� 350������ �������� �޿��� 12% �λ� �Ͽ���*/
UPDATE professor
SET sal = sal * 1.12
WHERE position = (SELECT position
                  FROM professor
                  WHERE name = '������')
AND sal <= 350;

SELECT name, sal
FROM professor;
/*���� : ������̺��� 'DALLAS'�� �ٹ��ϴ� ������� �޿��� 100���� ����*/
UPDATE emp
SET sal = 100
WHERE deptno = (SELECT deptno
                FROM DEPT
                WHERE LOC = 'DALLAS');

select * from emp;

/*������ ����
  - DELETE : ���̺� ����� ������ ������ ���� ���۾�
  - WHERE ���� �����ϸ� ���̺��� ��� �� ����*/
  
DELETE FROM student;

ROLLBACK;
/*������ ������
  - �л����̺��� �й��� 20103�� �л��� �����͸� �����Ͽ���*/
DELETE
FROM student
WHERE studno = 20103;

commit;

SELECT * FROM student
WHERE studno = 20103;

/*���������� �̿��� ������ ���� ��
  - �л� ���̺��� ��ǻ�� ���а��� �Ҽӵ� �л��� ��� �����϶�*/
DELETE FROM student
WHERE deptno = (SELECT deptno
                FROM department
                WHERE dname = '��ǻ�Ͱ��а�');
                
SELECT * FROM student
WHERE deptno = (SELECT deptno
                FROM department
                WHERE dname = '��ǻ�Ͱ��а�');
                
ROLLBACK;
/*������̺��� DALLAS�� �ٹ��ϴ� ������� �����ϼ���*/
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
  - ������ ���� �ΰ��� ���̺��� ���Ͽ� �ϳ��� ���̺�� ��ġ�� ���� ������ ���۾�
  - WHEN ���� ���������� ��� ���̺� �ش� ���� �����ϸ� UPDATE ��ɹ��� ����
    ���ο� ������ ����, �׷��� ������ INSERT ��ɹ����� ���ο� ���� ����*/
/*��뿹
  - professor ���̺�� professor_temp ���̺��� ���Ͽ� professor ���̺� �ִ�
    ���� �����ʹ� professor_temp���̺��� �����Ϳ� ���� �����ϰ�, professor ���̺� ���� �����ʹ� �űԷ� �Է�*/
CREATE TABLE professor_temp AS
SELECT *
FROM professor
WHERE position = '����';

UPDATE professor_temp
SET position = '������'
WHERE position = '����';

INSERT INTO professor_temp
VALUES(9999, '�赵��', 'aromm21', '���Ӱ���', 200, SYSDATe, 10, 101);

/*MERGE ��뿹2*/
merge into professor p
using professor_temp f
on (p.profno = f.profno)
when matched then
update set p.position = f.position
when not matched then
insert values(f.profno, f.name, f.userid, f.position, f.sal, f.hiredate, f.comm, f.deptno);

select * from professor;

/*Ʈ����� ����
  - ������ �����ͺ��̽����� ����Ǵ� �������� SQL ��ɹ��� �ϳ��� ���� �۾������� ó���ϴ� ����
  - COMMIT : Ʈ������� �������� ����
  - ROLLBACK : Ʈ������� ��ü ���*/

/*������
  - ������ �ĺ���
  - �⺻ Ű ���� �ڵ����� �����ϱ� ���Ͽ� �Ϸù�ȣ�� ���� ��ü*/
/*������ ���� 
  ��뿹 : ���۹�ȣ��1, ����ġ�� 1, �ִ� ���� 2�� s_seq �������� �����϶�*/
CREATE SEQUENCE s_seq
INCREMENT BY 1
START WITH 1
MAXVALUE 100;

SELECT min_value, max_value, increment_by, last_number
FROM user_sequences
WHERE SEQUENCE_NAME = 'S_SEQ';
/*CURRVAL �� NEXTVALUE �Լ�
  - INSERT, UPDATE ������ ���
  - ��������, GROUP BY, HAVING, ORDER BY, DISTINCT�� �Բ� ����� �� ������, �÷��� �⺻������ ����� �� ����
  - CURRVAL : ���������� ������ �����ȣ�� Ȯ��
  - NEXTVALUE : ���������� ���� ��ȣ ����*/

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
/*������ ���� �����
  - ALTER SEQUENCE ��ɹ� ���
  ��뿹 : s_seq �������� �ִ밪�� 200���� �����Ͽ���*/
ALTER SEQUENCE s_seq MAXVALUE 200;

SELECT min_value, max_value, increment_by, last_number

/*������ ����
  - DROP SEQUENCE ��ɹ����
  ��뿹 : s_seq �������� �����Ͽ���*/
drop sequence s_seq;


/*���̺� ����*/
/*���̺� ����
  - ��뿹 : ����ó ������ �����ϱ� ���� �ּҷ����̺��� �����϶�*/
CREATE TABLE address
(id NUMBER(3),
name VARCHAR2(50),
addr VARCHAR2(100),
phone VARCHAR2(30),
emmail VARCHAR2(100));

SELECT * FROM tab;

DESC address;

/*DEFAULT �ɼ�
  - Į���� �Է°��� ������ ��쿡 NULL��ſ� �ԷµǴ� �⺻���� �����ϱ� ���� ���*/

/*���������� �̿��� ���̺� ����
  - CREATe TABlE ��ɹ����� �������� ���� �̿��Ͽ� �ٸ� ���̺��� ������ �����͸� �����Ͽ� ���ο� ���̺� ��������
  - ���������� ��°���� ���̺��� �ʱ� �����ͷ� ����
  ���� */
INSERT INTO address
VALUES(1, 'HGDONG', 'SEOUL', '123-4567', 'gdhong@naver.com');

COMMIT;

SELECT * FROM address;
/*��뿹 : ������������ �̿��Ͽ� �ּҷ����̺��� ������ �����͸� �����Ͽ� addr_second ���̺��� �����϶�*/
CREATE TABLE addr_second(id, name, addr, phone, e_mail)
AS SELECT * FROM address;

DESC addr_second;

/*���̺� ���� ����
  - ���������� �̿��� ���̺� ������ �����ʹ� �������� �ʰ� ���� ���̺��� ������ ���� ����
  - ���������� WHERE �������� ������ �Ǵ� ������ �����Ͽ� ��� ��� ������ �������� �ʵ��� ����*/
/*  ��뿹 : �ּҷΰ��̺��� id, name Į���� �����Ͽ� addr_fourth ���̺��� �����϶�,
          ��, �����ʹ� �������� �ʴ´�. */
CREATE TABLE addr_fourth
AS SELECT id, name FROM address
WHERE 1=2;

DESC addr_fourth;

SELECT * FROM addr_fourth;

/*���������� �̿��� ���̺� ����
  ��뿹: �ּҷ����̺��� id,name Į���� �����Ͽ� adde_third���̺��� �����϶�*/
CREATE TABLE addr_third
AS SELECT id, name FROM address;

DESC addr_third;

SELECT * FROM addr_third;

/*���̺� ���� ����
  - ALTER TABLE ��ɹ��̿�
  - Į�� �߰�, ����, Ÿ���̳� ������ �����ǿ� ���� �۾�
  ��뿹 : �ּҷ����̺� ��¥ Ÿ���� ������ birth Į���� �߰��Ͽ���*/
ALTER TABLE address
ADD (birth DATE);

DESC address;
/*�ǽ��� : �ּҷ����̺� ����Ÿ���� ������ comment Į���� �߰��Ͽ��� �⺻���� No Comment�� ����*/
ALTER TABLE address
ADD(comments VARCHAR2(200) DEFAULT 'NO Comment');

DESC address;

/*���̺� Į�� ����
  - ���̺� ���� Ư�� Į���� Į���� �����͸� ����
  - 2 ���̻��� Į���� �����ϴ� ���̺����� ���� ����
  ��뿹: �ּҷ� ���̺��� comment Į���� �����Ͽ���.*/
ALTER TABLE address DROP COLUMN comments;
DESC address;

/*���̺� Į�� ����
  - ���̺��� Į���� Ÿ��, ũ��, �⺻�� ���氡��
  - ����Į���� �����Ͱ� ���� ��� : Į��Ÿ���̳� ũ�� ������ �����ο�
  - ���������Ͱ� ������ ��� : Ÿ�Ժ����� CHAR�� VARCHAR2�� ���
                            ������ Į���� ũ�Ⱑ ����� �������� ũ�⺸�� ���ų� Ŭ��� ���氡��
  ��뿹 : */
ALTER TABLE address
MODIFY phone VARCHAR2(50);

/*���̺� �̸� ����
  - RENAME ��ɹ� ���
  - ��, ������, ���� ��� ���� �����ͺ��̽� ��ü�� �̸� ���� ����
  ��뿹 : addr_second ���̺� �̸��� client_address�� �����Ͽ���*/
RENAME addr_second TO client_address;
SELECT * FROM tab;

/*���̺� ����
  - ���� ���̺�� �����͸� ��� ����
  - DROP TABLE ��ɹ� ���
  - ������ ���̺��� �⺻ Ű�� ����Ű�� �ٸ� ���̺��� �����ϰ� �ִ� ��� ���� �Ұ���
  ��뿹 : addr_third ���̺��� �����Ͽ���*/
DROP TABLE addr_third;
SELECT * FROM tab
WHERE tname = 'ADDR_THIRD';
/*TRUNCATE ��ɹ�
  - ���̺� ������ �״�� �����ϰ�, ���̺��� �����Ϳ� �Ҵ�� ������ ����
  - ���̺� ������ �������ǰ� ������ �ε���, ��, ���Ǿ�� ����
  - DDL���̹Ƿ� ROLLBACK �� �Ұ��� WHERE ���� �̿��Ͽ� Ư�� �ุ �����ϴ°��� �Ұ���
  ��뿹 : ���̺��� �����Ϳ� �Ҵ�� ������ �����Ͽ���*/
TRUNCATE TABLE client_address;

/*�ּ��߰�
  - ���̺��̳� Į���� �ִ� 2,000 ����Ʈ���� �ּ��� �߰�
  - COMMENT ON TABLE ... IS ��ɹ� �̿�
  ��뿹 : �ּҷ� ���̺��� '�� �ּҷ��� �����ϱ� ���� ���̺�'�̶�� �ּ��� �߰��Ͽ���*/
COMMENT ON TABLE address
IS '�� �ּҷ��� �����ϱ� ���� ���̺�';
/*��뿹 : �ּҷ� ���̺��� name Į���� '���̸�'�̶�� �ּ��� �߰��Ͽ���*/
COMMENT ON COLUMN address.name
IS '�� �̸�';

/*�ּ�Ȯ�ι��*/
SELECT comments
FROM user_tab_comments
WHERE table_name = 'ADDRESS';
/*�÷��ּ� Ȯ���ϴ� ���*/
SELECT * FROM user_col_comments
WHERE table_name = 'ADDRESS';
/*���̺� �ּ� ����*/
COMMENT ON TABLE ADDRESS IS '';
/**/
COMMENT 

/*������ ����*/
/*������ ������ ����
  - �ټ��� ����ڰ� ������ �����͸� ����
  - �б� ���� ��� ����
  - �뵵�� ���� USER, ALL, DBA ���ξ ����Ͽ� �з�*/
/*USER_ ������ ���� ��
  - �Ϲ� ����ڿ� ���� �����ϰ� ���õ� ��
  ��뿹 : USER_ ������ ������ ��ȸ��*/
SELECT table_name FROM user_tables;
/*ALL_ ������ ���� ��
  - �����ͺ��̽� ��ü ����ڿ� ���õ� ��
  - �ش� ��ü�� �����ڸ� Ȯ�ΰ���
  ��뿹 : ALL_ ������ ������ ��ȸ��*/
SELECT owner, table_name FROM all_tables;  
/*DBA_ ������ ���� ��
  - �ý��� ������ ���õ� ��
  ��뿹 : DBA_ ������ ������ ��ȸ��*/
SELECT owner, table_name FROM dba_tables;


/*������ ���Ἲ*/
/*������ ���Ἲ ���������� ����
  - �������� ��Ȯ���� �ϰ����� ����
  ����
  - ���̺������ ���Ἲ ���������� ���ǰ���
  - ���̺� ���� ����, ������ ��ųʸ��� ����ǹǷ� �������α׷����� �Էµ� ��� �����Ϳ� ���� �����ϰ� ����
  ����
  - NOT NULL
  - ����Ű(nuique key)
  - �⺻Ű(primary key)
  - ����Ű(foreign key)
  - CHECK */
  
/*dept���� 30�� �μ��� �����ϼ���*/
DELETE FROM dept
WHERE deptno = 30; /*�ڽ� ���̺� �����ϱ� ������ �����߻�*/
/*���� ������*/
/*emp���� 33�� SALES �μ��� �߰��ϼ���*/
INSERT INTO dept
VALUES(33,'SALES','SEOUL');
/*emp���� 30�� �μ� �Ҽӻ���� 33���μ��� �����غ�����*/
UPDATE emp
SET deptno = 33
WHERE deptno = 30;
/*dept ���̺��� 30�� �μ��� �����ϼ���*/
DELETE FROM dept
WHERE deptno = 30;

select * from emp;

/*���Ἲ �������� ����
  - ���̺� ������ ���ÿ� ����*/
/*���Ἲ �������� ���� ��*/
CREATE TABLE subject /*���� ���̺� �ν��Ͻ�*/
    (subno NUMBER(5)
        CONSTRAINT subject_no_pk PRIMARY KEY
        DEFERRABLE INITIALLY DEFERRED
        USING INDEX TABLESPACE indx,
    subname VARCHAR2(20)
        CONSTRAINT subject_name_nn NOT NULL,
    term VARCHAR2(1)
        CONSTRAINT subject_term_ck CHECK (term in('1', '2')),
    type VARCHAR2(6));
/*���� ���̺� �ν��Ͻ�*/    
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
/*���Ἲ �������� ��ȸ*/
SELECT constraint_name, constraint_type
FROM user_constraints
WHERE table_name IN ('SUBJECT','SUGANG');
/*�������̺� ���Ἲ �������� �߰�
 - NULL�� ������ ���Ἲ �������� �߰� : ALTER ... ADD CONSTRAINT ��ɹ����
 - NULL ���Ἲ �������� �߰� : ALTER TABLE ... MODIFY ��ɹ����
 ��뿹: */
ALTER TABLE student
ADD CONSTRAINT stud_idnum_uk UNIQUE(idnum);
ALTER TABLE student
MODIFY (name CONSTRAINT stud_name_nn NOT NULL);

ALTER TABLE department 
ADD CONSTRAINT dept_pk PRIMARY KEY(deptno); /*PRIMARY KEY�� �� �����ؾ� �������� ��°��� */

ALTER TABLE student ADD CONSTRAINT stud_deptno_fk
FOREIGN KEY(deptno) REFERENCES department(deptno);

/*�ǽ� �� */
ALTER TABLE professor add constraints prof_pk PRIMARY KEY(profno);

/*���Ἲ �������ǿ� ���� DML ��ɹ��� ����
  - ������� ����()�� ����Ǵ� ������ �Է½� : ���̺� �����͸� ���� �Է��� ���� ���Ἲ ���������� �����ϴ� ��ɹ��� �ѹ�
  - �����������ǿ� ����Ǵ� ������ �Է½� : Ʈ����ǳ��� DML ��ɹ����� �������� �˻縦 COMMIT ��������
    �Ѳ����� ó���Ͽ� Ʈ������� ó�������� ����Ű�� ���� ���
    ��뿹 : �������̺��� ���Ἲ �������ǿ� ���ݵǴ� �������� ���� �Է��϶�*/
INSERT INTO subject VALUES(1, 'SQL', '1', '�ʼ�');
INSERT INTO subject VALUES(2, '', '2', '�ʼ�');/*���� �������� ����*/
INSERT INTO subject VALUES(2, 'KEI', '3', '�ʼ�')/*���� �������� ����*/

/*������������ ����Ǵ� ������ �Է�
  ��뿹 : */
INSERT INTO subject VALUES(4, '�����ͺ��̽�', '1', '�ʼ�');
INSERT INTO subject VALUES(4, '�����͸𵨸�', '2', '����'); /*�������� ����� �ѹ�*/
/*���Ἲ �������� ����
  ��뿹 : �������̺��� subject_pk_ck ���Ἲ ���������� �����϶�*/
SELECT constraint_name, constraint_type
FROM user_constraints
WHERE table_name = 'SUBJECT';

ALTER TABLE subject
DROP CONSTRAINT subject_term_ck;

SELECT constraint_name, constraint_type
FROM user_constraints
WHERE table_name = 'SUBJECT';

/*���Ἲ �������� Ȱ��ȭ �� ��Ȱ��ȭ*/
/*��Ȱ��ȭ ��뿹: �������̺��� sugang_pk, sugang_studno_fk ���Ἲ���������� ��Ȱ��ȭ �Ͽ���*/
ALTER TABLE sugang
DISABLE CONSTRAINT sugang_Pk;

ALTER TABLE sugang
DISABLE CONSTRAINT sugang_studno_fk;

SELECT constraint_name, status
FROM user_constraints
WHERE table_name IN ('SUGANG','SUBJECT');

/*Ȱ��ȭ ��뿹 : �������̺��� sugang_pk, sugang_studno_fk ���Ἲ���������� Ȱ��ȭ �Ͽ���*/
ALTER TABLE sugang
ENABLE CONSTRAINT sugang_Pk;

ALTER TABLE sugang
ENABLE CONSTRAINT sugang_studno_fk;

SELECT constraint_name, status
FROM user_constraints
WHERE table_name = 'SUGANG' ;

/*����Ǯ��*/
/*1. �Ʒ��� ���� EE ���̺��� �����ϼ���.
   Name		Null		Type
  --------       -------------  	        ------------
   EMPLOYEE_ID			NUMBER(7)
   LAST_NAME			VARCHAR2(25)
   FIRST_NAME			VARCHAR2(25)
   DEPTNO			NUMBER(2)
   PHONE_NUMBER			VARCHAR2(20)*/
  - ��뿹 : ����ó ������ �����ϱ� ���� �ּҷ����̺��� �����϶�*/
CREATE TABLE EE
(EMPLOYEE_ID NUMBER(7),
 LAST_NAME VARCHAR2(25),
 FIRST_NAME VARCHAR2(25),
 DEPTNO NUMBER(2),
 PHONE_NUMBER VARCHAR2(20));

DESC EE; 
/*2. 1.���� ������ ���̺� �Ʒ��� ���� 4���� �����͸� �Է��ϼ���.
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
/*3. EE ���̺��� EMPLOYEE_ID���� PRIMARY KEY ���������� �߰��ϼ���.
   ����, ���������� �ɸ��� �ʴ´ٸ� ������ ���Ͻð�, ������ ���������� �߰��� ������.*/
ALTER TABLE EE
ADD CONSTRAINT EE_ID PRIMARY KEY(EMPLOYEE_ID); /*EMPLOYEE_ID �ȿ� �ߺ��� �־� PK ���� �Ұ���*/

UPDATE EE SET EMPLOYEE_ID = 4
WHERE EMPLOYEE_ID = 3 AND LAST_NAME = 'test4';
ALTER TABLE EE
ADD CONSTRAINT EE_ID PRIMARY KEY(EMPLOYEE_ID);
select * from EE;
/*4. ������ ������ EE ���̺��� DEPTNO�� DEPT���̺��� DEPTNO �÷��� �����ϰ� ���� ������ ������ ������.*/
ALTER TABLE EE
ADD CONSTRAINT deptno_fk foreign key(deptno) references dept(deptno);
/*5. INSERT INTO ee(employee_id, first_name, deptno)
     VALUES(4, 'cindy',50);
     �����͸� �Է��Ϸ��� �Ͽ����� �����Ͽ���. ������?*/
EMPLOYEE_ID�÷��� PK��. 4��� �ߺ����� ������ �ʴ´�.
/*6. ������ ee ���̺��� ������ ������.*/
drop table EE;