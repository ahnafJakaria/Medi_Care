-- ============================================================
-- MediCare HMS — Database Schema
-- Database: hospital_management
-- ============================================================

CREATE DATABASE IF NOT EXISTS hospital_management;
USE hospital_management;

-- ── Departments ──────────────────────────────────────────────
CREATE TABLE departments (
  dept_id   INT AUTO_INCREMENT PRIMARY KEY,
  dept_name VARCHAR(100) UNIQUE NOT NULL
);

INSERT INTO departments (dept_name) VALUES
  ('Cardiology'),
  ('Neurology'),
  ('Orthopedics'),
  ('Dermatology'),
  ('Pediatrics'),
  ('Ophthalmology'),
  ('Anesthesiology'),
  ('Endocrinology'),
  ('Oncology'),
  ('General Medicine');

-- ── Doctors ──────────────────────────────────────────────────
CREATE TABLE doctors (
  did        INT AUTO_INCREMENT PRIMARY KEY,
  email      VARCHAR(50) UNIQUE NOT NULL,
  doctorname VARCHAR(50) NOT NULL,
  dept_id    INT NOT NULL,
  FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

INSERT INTO doctors (email, doctorname, dept_id) VALUES
  ('ahmed.rahman@medicare.com',    'Ahmed Rahman',    1),
  ('sarah.khan@medicare.com',      'Sarah Khan',      2),
  ('james.wilson@medicare.com',    'James Wilson',    3),
  ('amina.begum@medicare.com',     'Amina Begum',     4),
  ('robert.chowdhury@medicare.com','Robert Chowdhury',5),
  ('priya.sharma@medicare.com',    'Priya Sharma',    6);

-- ── Diseases ─────────────────────────────────────────────────
CREATE TABLE diseases (
  disease_id   INT AUTO_INCREMENT PRIMARY KEY,
  disease_name VARCHAR(100) UNIQUE NOT NULL
);

INSERT INTO diseases (disease_name) VALUES
  ('Hypertension'),
  ('Diabetes Mellitus'),
  ('Migraine'),
  ('Fracture'),
  ('Eczema'),
  ('Asthma'),
  ('Cataract'),
  ('COVID-19'),
  ('Fever'),
  ('Back Pain'),
  ('Heart Disease'),
  ('Anxiety Disorder');

-- ── Patients ─────────────────────────────────────────────────
CREATE TABLE patients (
  pid    INT AUTO_INCREMENT PRIMARY KEY,
  email  VARCHAR(50) UNIQUE NOT NULL,
  name   VARCHAR(50) NOT NULL,
  gender VARCHAR(20) NOT NULL,
  number VARCHAR(14) NOT NULL
);

-- ── Appointments ─────────────────────────────────────────────
CREATE TABLE appointments (
  appointment_id   INT AUTO_INCREMENT PRIMARY KEY,
  pid              INT NOT NULL,
  did              INT NOT NULL,
  disease_id       INT NOT NULL,
  slot             VARCHAR(20) NOT NULL,
  appointment_time TIME NOT NULL,
  appointment_date DATE NOT NULL,
  FOREIGN KEY (pid)        REFERENCES patients(pid)  ON DELETE CASCADE,
  FOREIGN KEY (did)        REFERENCES doctors(did),
  FOREIGN KEY (disease_id) REFERENCES diseases(disease_id)
);

-- ── Audit ─────────────────────────────────────────────────────
CREATE TABLE audit (
  tid       INT AUTO_INCREMENT PRIMARY KEY,
  pid       INT NOT NULL,
  action    VARCHAR(50) NOT NULL,
  timestamp DATETIME NOT NULL
);

-- ── Triggers ─────────────────────────────────────────────────
DELIMITER $$

CREATE TRIGGER patient_after_insert
AFTER INSERT ON patients
FOR EACH ROW
  INSERT INTO audit (pid, action, timestamp)
  VALUES (NEW.pid, 'PATIENT INSERTED', NOW())
$$

CREATE TRIGGER patient_after_update
AFTER UPDATE ON patients
FOR EACH ROW
  INSERT INTO audit (pid, action, timestamp)
  VALUES (NEW.pid, 'PATIENT UPDATED', NOW())
$$

CREATE TRIGGER patient_before_delete
BEFORE DELETE ON patients
FOR EACH ROW
  INSERT INTO audit (pid, action, timestamp)
  VALUES (OLD.pid, 'PATIENT DELETED', NOW())
$$

DELIMITER ;

-- ── Users ─────────────────────────────────────────────────────
CREATE TABLE users (
  id       INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  usertype VARCHAR(50) NOT NULL,
  email    VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(1000) NOT NULL
);

-- ─────────────────────────────────────────────────────────────
-- Done! Run this file once, then start the Flask app.
-- ─────────────────────────────────────────────────────────────
