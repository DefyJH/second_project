--���� ���� ���̺�
CREATE TABLE USER_INFO(
    user_code NUMBER(10) NOT NULL,
    user_type VARCHAR(3) NOT NULL,
    user_email VARCHAR2(30) NOT NULL,
    user_pw VARCHAR2(20) NOT NULL,
    user_nickname VARCHAR2(50) NOT NULL,
    user_name VARCHAR2(20) NOT NULL,
    user_rsd_reg_num VARCHAR2(14) NOT NULL,
    user_phone_num VARCHAR2(15) NOT NULL,
    user_postal_code VARCHAR2(5) NOT NULL,
    user_addr_line VARCHAR2(100),
    user_addr VARCHAR2(100) NOT NULL,
    user_reg_dt DATE NOT NULL,
    user_status VARCHAR(1) NOT NULL,
    PRIMARY KEY (user_code, user_email, user_rsd_reg_num)
);

SELECT * FROM USER_INFO;

COMMIT;


--����� ���� ���̺�
CREATE TABLE BUSINESS (
    bsns_code VARCHAR2(12) NOT NULL PRIMARY KEY,
    user_code NUMBER(10) NOT NULL,
    bsns_owner_name VARCHAR2(20) NOT NULL
);

SELECT * FROM BUSINESS;

--���� ���� ���̺�
CREATE TABLE ACCOMMODATION (
    acm_code NUMBER(10) NOT NULL PRIMARY KEY,
    acm_type VARCHAR(3) NOT NULL,
    acm_type_name VARCHAR2(20) NOT NULL,
    acm_name VARCHAR2(50) NOT NULL,
    bsns_code VARCHAR2(12) NOT NULL,
    acm_tel VARCHAR2(15) NOT NULL,
    acm_addr VARCHAR2(100) NOT NULL,
    acm_reg_dt DATE NOT NULL,
    acm_status VARCHAR(1) NOT NULL,
    acm_reg_site NUMBER(1) NOT NULL
);

SELECT * FROM ACCOMMODATION;

SELECT acm_code, acm_type, acm_type_name, acm_name, bsns_code, acm_tel,
        acm_addr, TO_CHAR(acm_reg_dt, 'YYYY/MM/DD') acm_reg_dt, acm_status, acm_reg_site
FROM ACCOMMODATION
WHERE acm_code = 1;


--���� ������
CREATE TABLE ACCOMMODATION_DETAILS (
    acm_code NUMBER(10) NOT NULL PRIMARY KEY,
    acm_dtl_introduction VARCHAR2(4000),
    acm_dtl_notice VARCHAR2(4000),
    acm_dtl_info VARCHAR2(4000),
    acm_dtl_usage_guide VARCHAR2(4000),
    acm_dtl_add_personnel VARCHAR2(4000),
    acm_dtl_room_info VARCHAR2(4000),
    acm_dtl_faciliteis VARCHAR2(4000),
    acm_dtl_parking VARCHAR2(4000),
    acm_dtl_transport VARCHAR2(4000),
    acm_dtl_benefit VARCHAR2(4000),
    acm_dtl_surrounding_info VARCHAR2(4000),
    acm_dtl_guide VARCHAR2(4000), 
    acm_dtl_policy VARCHAR2(4000) NOT NULL,
    acm_dtl_etc VARCHAR2(4000)
);

SELECT * FROM ACCOMMODATION_DETAILS
WHERE acm_code = 1;

--���� ����
CREATE TABLE ROOM (
    room_code NUMBER(10) NOT NULL PRIMARY KEY,
    acm_code NUMBER(10) NOT NULL,
    room_name VARCHAR2(50) NOT NULL,
    room_type VARCHAR2(30),
    total_rooms NUMBER(2) NOT NULL,
    check_in_time DATE NOT NULL,
    check_out_time DATE NOT NULL,
    room_capacity NUMBER(2) NOT NULL,
    room_max_capacity NUMBER(2) NOT NULL,
    room_weekday_price NUMBER(10) NOT NULL,
    room_weekend_price NUMBER(10) NOT NULL,
    peak_season_weekday_price NUMBER(10),
    peak_season_weekend_price NUMBER(10),
    room_info VARCHAR2(1000) NOT NULL,
    room_amenities VARCHAR2(1000),
    room_status VARCHAR2(1) NOT NULL
);

--SELECT r.room_code AS room_code, r.acm_code AS acm_code, 
--    r.room_name AS room_name, r.room_type AS room_type, 
--    r.total_rooms AS total_rooms,
--    r.total_rooms - COALESCE(SUM(CASE
--        WHEN rsvt.rsvt_chek_in_date <= TO_DATE('2024/08/31', 'YYYY/MM/DD')
--        AND rsvt.rsvt_chek_out_date >= TO_DATE('2024/08/30', 'YYYY/MM/DD')
--        THEN 1 ELSE 0 END), 0) AS available_rooms,
--    r.check_in_time AS check_in_time, 
--    r.check_out_time AS check_out_time,
--    r.room_capacity AS room_capacity, 
--    r.room_max_capacity AS room_max_capacity,
--    r.room_weekday_price AS room_weekday_price, 
--    r.room_weekend_price AS room_weekend_price,
--    r.peak_season_weekday_price AS peak_season_weekday_price,
--    r.peak_season_weekend_price AS peak_season_weekend_price,
--    r.room_info AS room_info, 
--    r.room_amenities AS room_amenities, 
--    r.room_status AS room_status
--FROM 
--    ROOM r
--LEFT JOIN 
--    RESERVATION rsvt
--ON
--    r.room_code = rsvt.room_code
--WHERE 
--    r.acm_code = 1
--    AND (rsvt.rsvt_chek_in_date <= TO_DATE('2024/08/31', 'YYYY/MM/DD')
--    AND rsvt.rsvt_chek_out_date >= TO_DATE('2024/08/30', 'YYYY/MM/DD'))
--    AND r.room_max_capacity <= 3
--GROUP BY 
--    r.room_code, r.acm_code, r.room_name, r.room_type, 
--    r.total_rooms, r.check_in_time, r.check_out_time,
--    r.room_capacity, r.room_max_capacity,
--    r.room_weekday_price, r.room_weekend_price,
--    r.peak_season_weekday_price,
--    r.peak_season_weekend_price,
--    r.room_info, r.room_amenities, r.room_status;

SELECT 
    r.room_code,
    r.acm_code,
    r.room_name,
    r.room_type,
    r.total_rooms,
    r.total_rooms - COALESCE(reserved_rooms.reserved_count, 0) AS available_rooms,
    r.check_in_time,
    r.check_out_time,
    r.room_capacity,
    r.room_max_capacity,
    r.room_weekday_price,
    r.room_weekend_price,
    r.peak_season_weekday_price,
    r.peak_season_weekend_price,
    r.room_info,
    r.room_amenities,
    r.room_status
FROM 
    ROOM r
LEFT JOIN (
    SELECT 
        rsvt.room_code,
        COUNT(*) AS reserved_count
    FROM 
        RESERVATION rsvt
    WHERE 
        rsvt.rsvt_chek_in_date < TO_DATE('2024/08/31', 'YYYY/MM/DD')
        AND rsvt.rsvt_chek_out_date > TO_DATE('2024/08/30', 'YYYY/MM/DD')
    GROUP BY 
        rsvt.room_code
) reserved_rooms
ON 
    r.room_code = reserved_rooms.room_code
WHERE 
    r.acm_code = 18
    AND r.room_max_capacity <= 3;

SELECT * FROM ROOM;

DROP TABLE ROOM;

COMMIT;

--���� ���� ���� ���̺�
CREATE TABLE ACCOMMODATION_IMG (
    acc_img_code NUMBER(10) NOT NULL PRIMARY KEY,
    acm_code NUMBER(10) NOT NULL,
    room_code NUMBER(10),
    acc_img_origin_name VARCHAR2(258) NOT NULL,
    acc_img_save_name VARCHAR2(258) NOT NULL,
    acc_img_extension VARCHAR2(10) NOT NULL,
    acc_img_url VARCHAR2(258) NOT NULL
);

SELECT * FROM ACCOMMODATION_IMG;

SELECT * FROM ACCOMMODATION_IMG
WHERE acc_img_save_name LIKE '%��ǥ%';

SELECT *
FROM ACCOMMODATION_IMG
WHERE acm_code = 5;

COMMIT;

--���� ���� ���� ���̺�
CREATE TABLE RESERVATION(
    rsvt_code VARCHAR2(18) NOT NULL PRIMARY KEY,
    acm_code NUMBER(10) NOT NULL,
    room_code NUMBER(10) NOT NULL,
    rsvt_chek_in_date DATE NOT NULL,
    rsvt_chek_out_date DATE NOT NULL,
    rsvt_pament_date DATE NOT NULL,
    rsvt_room_amount NUMBER(10) NOT NULL,
    rsvt_discount NUMBER(3),
    rsvt_payment_info VARCHAR2(50) NOT NULL,
    rsvt_payment_amount NUMBER(10) NOT NULL,
    user_code NUMBER(10) NOT NULL,
    rsvt_guest_name VARCHAR2(100) NOT NULL,
    rsvt_guest_tel VARCHAR2(15) NOT NULL,
    rsvt_status NUMBER(1) NOT NULL,
    rsvt_review_status VARCHAR2(1) NOT NULL
);

UPDATE reservation
SET rsvt_guest_name = '������',
	rsvt_guest_tel = '010-1234-5678'
WHERE rsvt_code = '20240813-00001';

Drop table reservation;

SELECT * FROM RESERVATION;

UPDATE reservation
SET rsvt_status = 1
WHERE rsvt_code = '20240814-00005';

commit;

--�����ڵ� ������� �������� �ҷ�����(selectList)
		SELECT rv.rsvt_code rsvt_code, rv.acm_code acm_code, rv.room_code room_code,
				TO_CHAR(rsvt_chek_in_date, 'YYYY/MM/DD')
        			|| ' (' || TO_CHAR(rsvt_chek_in_date, 'DY') || ') ' ||
        			TO_CHAR(rsvt_chek_in_date, 'HH:MI') AS rsvt_chek_in_date,
        		TO_CHAR(rsvt_chek_out_date, 'YYYY/MM/DD')
        			|| ' (' || TO_CHAR(rsvt_chek_out_date, 'DY') || ') ' ||
        			TO_CHAR(rsvt_chek_out_date, 'HH:MI') AS rsvt_chek_out_date,
        	(TRUNC(rv.rsvt_chek_out_date) - TRUNC(rv.rsvt_chek_in_date)) AS total_night,
        	(TRUNC(rv.rsvt_chek_out_date) - TRUNC(rv.rsvt_chek_in_date) + 1) AS total_days,
        	TO_CHAR(rv.rsvt_pament_date, 'YYYY/MM/DD HH24:MI') rsvt_pament_date, rv.rsvt_room_amount rsvt_room_amount,
        	rv.rsvt_discount rsvt_discount, rv.rsvt_payment_info rsvt_payment_info, rv.rsvt_payment_amount rsvt_payment_amount,
        	rv.user_code user_code, rv.rsvt_guest_name rsvt_guest_name, rv.rsvt_guest_tel rsvt_guest_tel,
        	rv.rsvt_status rsvt_status, rv.rsvt_review_status rsvt_review_status, acm.acm_name acm_nmae, r.room_name || ' ' || r.room_type AS room_name,
        	img.acc_img_code img_code, img.acc_img_origin_name img_origin_name,
        	img.acc_img_save_name img_save_name, img.acc_img_extension img_extension, img.acc_img_url img_url
        FROM RESERVATION rv
		INNER JOIN ACCOMMODATION acm
		ON rv.acm_code = acm.acm_code
		INNER JOIN ROOM r
		ON rv.room_code = r.room_code
		INNER JOIN ACCOMMODATION_IMG img
		ON rv.acm_code = img.acm_code
		WHERE rv.user_code = 1
		AND rv.rsvt_status != 0
		AND img.acc_img_origin_name LIKE '%��ǥ%';

SELECT rv.rsvt_code rsvt_code, rv.acm_code acm_code, rv.room_code room_code,
				TO_CHAR(rsvt_chek_in_date, 'YYYY/MM/DD')
        			|| ' (' || TO_CHAR(rsvt_chek_in_date, 'DY') || ') ' ||
        			TO_CHAR(rsvt_chek_in_date, 'HH:MI') AS rsvt_chek_in_date,
        		TO_CHAR(rsvt_chek_out_date, 'YYYY/MM/DD')
        			|| ' (' || TO_CHAR(rsvt_chek_out_date, 'DY') || ') ' ||
        			TO_CHAR(rsvt_chek_out_date, 'HH:MI') AS rsvt_chek_out_date,
        	(TRUNC(rv.rsvt_chek_out_date) - TRUNC(rv.rsvt_chek_in_date)) AS total_night,
        	(TRUNC(rv.rsvt_chek_out_date) - TRUNC(rv.rsvt_chek_in_date) + 1) AS total_days,
        	TO_CHAR(rv.rsvt_pament_date, 'YYYY/MM/DD HH24:MI') rsvt_pament_date, rv.rsvt_room_amount rsvt_room_amount,
        	rv.rsvt_discount rsvt_discount, rv.rsvt_payment_info rsvt_payment_info, rv.rsvt_payment_amount rsvt_payment_amount,
        	rv.user_code user_code, rv.rsvt_guest_name rsvt_guest_name, rv.rsvt_guest_tel rsvt_guest_tel,
        	rv.rsvt_status rsvt_status , acm.acm_name acm_name, r.room_name || ' ' || r.room_type AS room_name,
        	img.acc_img_code img_code, img.acc_img_origin_name img_origin_name,
        	img.acc_img_save_name img_save_name, img.acc_img_extension img_extension, img.acc_img_url img_url
        FROM RESERVATION rv
		INNER JOIN ACCOMMODATION acm
		ON rv.acm_code = acm.acm_code
		INNER JOIN ROOM r
		ON rv.room_code = r.room_code
		INNER JOIN ACCOMMODATION_IMG img
		ON rv.acm_code = img.acm_code
		WHERE rv.rsvt_code = '20240813-00005'
		AND rv.rsvt_status != 0
		AND img.acc_img_origin_name LIKE '%��ǥ%';

--�����ȣ ������� ���� ���� �ҷ�����(selectOne)
SELECT rv.rsvt_code rsvt_code, rv.acm_code acm_code, rv.room_code room_code,
        TO_CHAR(rsvt_chek_in_date, 'YYYY/MM/DD')
        || ' (' || TO_CHAR(rsvt_chek_in_date, 'DY') || ') ' ||
        TO_CHAR(rsvt_chek_in_date, 'HH:MI') AS rsvt_chek_in_date,
        TO_CHAR(rsvt_chek_out_date, 'YYYY/MM/DD')
        || ' (' || TO_CHAR(rsvt_chek_out_date, 'DY') || ') ' ||
        TO_CHAR(rsvt_chek_out_date, 'HH:MI') AS rsvt_chek_out_date,
        (TRUNC(rv.rsvt_chek_out_date) - TRUNC(rv.rsvt_chek_in_date)) AS total_night,
        (TRUNC(rv.rsvt_chek_out_date) - TRUNC(rv.rsvt_chek_in_date) + 1) AS total_days,
        TO_CHAR(rv.rsvt_pament_date, 'YYYY/MM/DD HH24:MI') rsvt_pament_date, rv.rsvt_room_amount rsvt_room_amount,
        rv.rsvt_discount rsvt_discount, rv.rsvt_payment_info rsvt_payment_info, rv.rsvt_payment_amount rsvt_payment_amount,
        rv.user_code user_code, rv.rsvt_guest_name guest_name, rv.rsvt_guest_tel guest_tel,
        rv.rsvt_status rsvt_status, acm.acm_name acm_nmae, r.room_name || ' ' || r.room_type AS room_name,
        img.acc_img_code img_code, img.acc_img_origin_name img_origin_name,
        img.acc_img_save_name img_save_name, img.acc_img_extension img_extension, img.acc_img_url img_url
FROM RESERVATION rv
INNER JOIN ACCOMMODATION acm
ON rv.acm_code = acm.acm_code
INNER JOIN ROOM r
ON rv.room_code = r.room_code
INNER JOIN ACCOMMODATION_IMG img
ON rv.acm_code = img.acm_code
WHERE rv.rsvt_code = '20240812-00005'
AND rv.rsvt_status != 0
AND img.acc_img_origin_name LIKE '%��ǥ%';

SELECT TO_CHAR(rsvt_chek_in_date, 'YYYY/MM/DD')
        || ' (' || TO_CHAR(rsvt_chek_in_date, 'DY') || ') ' ||
        TO_CHAR(rsvt_chek_in_date, 'HH:MI') AS check_in_date
FROM RESERVATION;

SELECT *
FROM ROOM;

SELECT *
FROM ACCOMMODATION;

SELECT TO_CHAR(rsvt_chek_in_date, 'DY')
FROM RESERVATION;

SELECT *
FROM RESERVATION rv
INNER JOIN ACCOMMODATION acm
ON rv.acm_code = acm.acm_code
INNER JOIN ROOM r
ON rv.room_code = r.room_code
INNER JOIN ACCOMMODATION_IMG img
ON rv.acm_code = img.acm_code
WHERE rv.user_code = 1
AND rv.rsvt_status != 0
AND img.acc_img_origin_name LIKE '%��ǥ%';

COMMIT;
UPDATE reservation
SET rsvt_status = 1
WHERE rsvt_code = '20240809-00005';

UPDATE reservation
SET rsvt_review_status = '1'
WHERE rsvt_code = '20240814-00003';

COMMIT;

INSERT INTO reservation
VALUES(TO_CHAR(SYSDATE, 'YYYYMMDD')||'-'||LPAD(rsvt_code_sq.NEXTVAL, 5, '0'), 5, 16, TO_DATE('20240712 21:00', 'YYYYMMDD HH24:MI'), TO_DATE('20240714 15:00', 'YYYYMMDD HH24:MI'), TO_DATE('20240620 23:11', 'YYYYMMDD HH24:MI'), 110000, 0, '�ſ�/üũī�� ����', 220000, 1, '������', '010-1234-5678', 3, 0);

INSERT INTO reservation
VALUES(TO_CHAR(SYSDATE, 'YYYYMMDD')||'-'||LPAD(rsvt_code_sq.NEXTVAL, 5, '0'), 5, 16, (TO_DATE('20240712 21:00', 'YYYYMMDD HH24:MI')), (TO_DATE('20240714 15:00', 'YYYYMMDD HH24:MI')), TO_DATE('20240620 23:30', 'YYYYMMDD HH24:MI'), 110000, 0, '�ſ�/üũī�� ����', 220000, 1, '������', '010-1234-5678', 3, 0);

INSERT INTO reservation
VALUES(TO_CHAR(SYSDATE, 'YYYYMMDD')||'-'||LPAD(rsvt_code_sq.NEXTVAL, 5, '0'), 5, 16, (TO_DATE('20240719 21:00', 'YYYYMMDD HH24:MI')), (TO_DATE('20240721 15:00', 'YYYYMMDD HH24:MI')), TO_DATE('20240625 11:53', 'YYYYMMDD HH24:MI'), 110000, 0, '�ſ�/üũī�� ����', 220000, 1, '������', '010-1234-5678', 2, 1);

INSERT INTO reservation
VALUES(TO_CHAR(SYSDATE, 'YYYYMMDD')||'-'||LPAD(rsvt_code_sq.NEXTVAL, 5, '0'), 11, 41, (TO_DATE('20240802 15:00', 'YYYYMMDD HH24:MI')), (TO_DATE('20240803 11:00', 'YYYYMMDD HH24:MI')), TO_DATE('20240701 21:36', 'YYYYMMDD HH24:MI'), 600000, 0, '�ſ�/üũī�� ����', 600000, 1, '������', '010-1234-5678', 2, 0);

INSERT INTO reservation
VALUES(TO_CHAR(SYSDATE, 'YYYYMMDD')||'-'||LPAD(rsvt_code_sq.NEXTVAL, 5, '0'), 18, 78, (TO_DATE('20240830 15:00', 'YYYYMMDD HH24:MI')), (TO_DATE('20240831 11:00', 'YYYYMMDD HH24:MI')), TO_DATE('20240712 15:44', 'YYYYMMDD HH24:MI'), 75000, 0, '�ſ�/üũī�� ����', 75000, 1, '������', '010-1234-5678', 1, 0);

INSERT INTO reservation
VALUES(TO_CHAR(SYSDATE, 'YYYYMMDD')||'-'||LPAD(rsvt_code_sq.NEXTVAL, 5, '0'), 24, 109, (TO_DATE('20240920 15:00', 'YYYYMMDD HH24:MI')), (TO_DATE('20240922 11:00', 'YYYYMMDD HH24:MI')), TO_DATE('20240803 17:28', 'YYYYMMDD HH24:MI'), 30000, 0, '�ſ�/üũī�� ����', 60000, 1, '������', '010-1234-5678', 1, 0);

INSERT INTO reservation
VALUES(TO_CHAR(SYSDATE, 'YYYYMMDD')||'-'||LPAD(rsvt_code_sq.NEXTVAL, 5, '0'), 1, 1, (TO_DATE('20241020 15:00', 'YYYYMMDD HH24:MI')), (TO_DATE('20241023 12:00', 'YYYYMMDD HH24:MI')), TO_DATE('20240813 00:31', 'YYYYMMDD HH24:MI'), 80000, 0, '�ſ�/üũī�� ����', 240000, 1, '������', '010-1234-5678', 0, 0);

COMMIT;

CREATE SEQUENCE rsvt_code_sq
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 99999
CYCLE
CACHE 20;

DROP SEQUENCE rsvt_code_sq;


--���� ���� ���̺�
CREATE TABLE USER_REVIEW(
    review_code NUMBER(10) NOT NULL PRIMARY KEY,
    rsvt_code VARCHAR2(18) NOT NULL,
    user_code NUMBER(10) NOT NULL,
    acm_code NUMBER(10) NOT NULL,
    room_code NUMBER(10) NOT NULL,
    rating NUMBER(1) NOT NULL,
    review_text VARCHAR2(2000) NOT NULL,
    review_date DATE NOT NULL,
    reply_exists VARCHAR2(1) NOT NULL,
    report_status VARCHAR2(1) NOT NULL,
    report_reason VARCHAR2(500)
);

COMMIT;

DROP TABLE user_review;

SELECT * FROM USER_REVIEW;

SELECT ur.review_code review_code, ur.rsvt_code rsvt_code, ur.user_code user_code, ur.acm_code acm_code,
        ur.room_code room_code, ur.rating rating, ur.review_text review_text,
        TO_CHAR(ur.review_date, 'YYYY/MM/DD HH:MI') review_date, ur.reply_exists reply_exists,
        acm.acm_name acm_name, r.room_name || ' ' || r.room_type room_name
FROM user_review ur
INNER JOIN accommodation acm
ON ur.acm_code = acm.acm_code
INNER JOIN room r
ON ur.room_code = r.room_code
WHERE user_code = 1
AND report_status != 2
ORDER BY review_date DESC;

SELECT * FROM review_img
WHERE rsvt_code = #{rsvtCode};

DROP TABLE user_review;

INSERT INTO user_review
VALUES (1, '20240814-00003', 1, 5, 16, 5, '����ö������ ����� ��ġ�� ���ټ��� �ʹ� ���Ҿ��!!
��� ���� �ֺ��� �������� ����� ���� ������ �̿��ؾ��ϱ�������, ����ó ���������� �ʿ��Ѱ͵� ����� �ƾ��
ȭ��ǿ� �񵥰� �־ ���Ұ�, ħ�� ����ǵ� ����� ���Ƽ� ���� ����ϴ� ����
�׸��� ���� â������ ���� ���̴µ�, ��ħ�� �Ͼ�� Ŀư�� ���� �ɾƼ� �۶����⵵ �߽��ϴ� �䰡 �� ���Ҿ��~%%���������� �� �˳��ؼ� ������ ���� �������ϴ�!!
�����е鵵 ģ���ϼż� ���� ���������� �̿��ϰ� �Գ׿�~', SYSDATE, '1', '0', '');

COMMIT;

SELECT NVL(MAX(review_code), 0)+1 new_review_code FROM user_review;

SELECT * FROM ACCOMMODATION_DETAIL_TEST;

--���� ���� �̹��� ���� ���̺�
CREATE TABLE REVIEW_IMG(
    review_img_code NUMBER(10) NOT NULL PRIMARY KEY,
    review_code NUMBER(10) NOT NULL,
    review_img_origin_name VARCHAR2(258) NOT NULL,
    review_img_save_name VARCHAR2(258) NOT NULL,
    review_img_extension VARCHAR2(10) NOT NULL,
    review_img_url VARCHAR2(258) NOT NULL
);

SELECT NVL(MAX(review_img_code), 0)+1 new_review_img_code FROM review_img;

DROP TABLE review_img;

SELECT * FROM REVIEW_IMG;

INSERT INTO review_img
VALUES (1, 1, '23c8698bdf3b48909dbd2aef57d28dfa_w420_h420', '23c8698bdf3b48909dbd2aef57d28dfa_w420_h420', '.jpg', '/review_img/1/20240814-00003');

INSERT INTO review_img
VALUES (2, 1, '9df5f89dad3541e39437293616f0c5c5_w420_h420', '9df5f89dad3541e39437293616f0c5c5_w420_h420', '.jpg', '/review_img/1/20240814-00003');

SELECT * FROM review_img
WHERE review_code = 1;

COMMIT;

--�̿��� ���信 ���� ����� ��� ���� ���̺�
CREATE TABLE BUSINESS_REPLY(
    reply_code NUMBER(10) NOT NULL PRIMARY KEY,
    review_code NUMBER(10) NOT NULL,
    user_code NUMBER(10) NOT NULL,
    reply_text VARCHAR2(2000) NOT NULL,
    reply_date DATE NOT NULL
);

SELECT * FROM BUSINESS_REPLY;


--���� ������ ��ġ ���� ����
CREATE TABLE POLICE_STATION(
    plc_code NUMBER(10) NOT NULL PRIMARY KEY,
    plc_provincial_office VARCHAR2(20) NOT NULL,
    plc_station VARCHAR2(20) NOT NULL,
    plc_name VARCHAR2(30) NOT NULL,
    plc_type VARCHAR2(15) NOT NULL,
    plc_addr VARCHAR2(500) NOT NULL,
    plc_tel VARCHAR2(15) NOT NULL
);

SELECT * FROM POLICE_STATION;


--���� ���� ��ġ ���� ����
CREATE TABLE HOSPITAL(
    hospital_code NUMBER(10) NOT NULL PRIMARY KEY,
    hospital_name VARCHAR2(100) NOT NULL,
    hospital_type VARCHAR2(35) NOT NULL,
    hospital_addr VARCHAR2(500) NOT NULL,
    hospital_map_x VARCHAR2(15) NOT NULL,
    hospital_map_y VARCHAR2(15) NOT NULL
);

SELECT * FROM HOSPITAL;

COMMIT;