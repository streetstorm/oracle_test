ALTER SESSION SET CONTAINER = XE;
ALTER SESSION SET CURRENT_SCHEMA = sys;

CREATE TABLE ACCOUNTS (
  ACCOUNT_NUMBER VARCHAR2(15) PRIMARY KEY,
  msisdn VARCHAR2(11) NOT NULL,
  status VARCHAR2(10)
);

INSERT INTO ACCOUNTS
VALUES(1,'Hi','ok');
