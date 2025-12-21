-- FILE: 05_insert_sample_data.sql
-- PURPOSE: Populate database with comprehensive realistic sample data
-- NOTE: This creates a fully functional hospital system with realistic Vietnamese data

USE HospitalDB;

-- ==========================================
-- 1. DEPARTMENTS (10 major departments)
-- ==========================================

INSERT INTO Department (department_name, description, head_of_department_id) VALUES
('Emergency Medicine', 'Emergency and trauma care, 24/7 urgent medical services', NULL),
('Internal Medicine', 'General medicine, chronic disease management, preventive care', NULL),
('Pediatrics', 'Child healthcare from infancy through adolescence', NULL),
('Surgery', 'General and specialized surgical procedures', NULL),
('Cardiology', 'Heart and cardiovascular system treatment', NULL),
('Neurology', 'Brain, spinal cord, and nervous system disorders', NULL),
('Orthopedics', 'Bone, joint, ligament, and musculoskeletal treatment', NULL),
('Radiology', 'Medical imaging and diagnostic procedures', NULL),
('Obstetrics and Gynecology', 'Womens health, pregnancy, and childbirth care', NULL),
('Oncology', 'Cancer diagnosis, treatment, and care', NULL);

-- ==========================================
-- 2. DOCTORS (30 doctors across departments)
-- ==========================================

-- Emergency Medicine (3 doctors)
INSERT INTO Doctor (department_id, medical_license_id, dob, first_name, middle_name, last_name, gender, national_id, phone, email, address, expertise, doctor_level_id, active_status_id) VALUES
(1, 'ML-EM-001', '1978-03-15', 'Nguyễn', 'Văn', 'Anh', 'Male', '001078000123', '0901234567', 'nv.anh@hospital.vn', '123 Lê Lợi, Q1, TPHCM', 'Emergency Medicine', 7, 4),
(1, 'ML-EM-002', '1985-07-22', 'Trần', 'Thị', 'Bích', 'Female', '001085001234', '0902345678', 'tt.bich@hospital.vn', '456 Nguyễn Huệ, Q1, TPHCM', 'Trauma Surgery', 6, 4),
(1, 'ML-EM-003', '1990-11-08', 'Phạm', 'Minh', 'Cường', 'Male', '001090002345', '0903456789', 'pm.cuong@hospital.vn', '789 Trần Hưng Đạo, Q5, TPHCM', 'Emergency Medicine', 4, 3);

-- Internal Medicine (4 doctors)
INSERT INTO Doctor (department_id, medical_license_id, dob, first_name, middle_name, last_name, gender, national_id, phone, email, address, expertise, doctor_level_id, active_status_id) VALUES
(2, 'ML-IM-001', '1975-05-20', 'Lê', 'Văn', 'Dũng', 'Male', '001075003456', '0904567890', 'lv.dung@hospital.vn', '321 Pasteur, Q3, TPHCM', 'Internal Medicine', 8, 4),
(2, 'ML-IM-002', '1982-09-14', 'Hoàng', 'Thị', 'Hoa', 'Female', '001082004567', '0905678901', 'ht.hoa@hospital.vn', '654 Cách Mạng Tháng 8, Q10, TPHCM', 'Endocrinology', 7, 4),
(2, 'ML-IM-003', '1988-02-28', 'Vũ', 'Minh', 'Khang', 'Male', '001088005678', '0906789012', 'vm.khang@hospital.vn', '987 Lý Thường Kiệt, Q11, TPHCM', 'Gastroenterology', 5, 4),
(2, 'ML-IM-004', '1992-06-10', 'Đặng', 'Thị', 'Lan', 'Female', '001092006789', '0907890123', 'dt.lan@hospital.vn', '147 Hai Bà Trưng, Q1, TPHCM', 'Internal Medicine', 3, 4);

-- Pediatrics (3 doctors)
INSERT INTO Doctor (department_id, medical_license_id, dob, first_name, middle_name, last_name, gender, national_id, phone, email, address, expertise, doctor_level_id, active_status_id) VALUES
(3, 'ML-PED-001', '1980-04-12', 'Bùi', 'Văn', 'Nam', 'Male', '001080007890', '0908901234', 'bv.nam@hospital.vn', '258 Võ Thị Sáu, Q3, TPHCM', 'Pediatrics', 7, 4),
(3, 'ML-PED-002', '1986-08-25', 'Đỗ', 'Thị', 'Phương', 'Female', '001086008901', '0909012345', 'dt.phuong@hospital.vn', '369 Điện Biên Phủ, Q3, TPHCM', 'Pediatric Cardiology', 6, 4),
(3, 'ML-PED-003', '1991-12-03', 'Ngô', 'Minh', 'Quang', 'Male', '001091009012', '0910123456', 'nm.quang@hospital.vn', '741 Nguyễn Thị Minh Khai, Q1, TPHCM', 'Pediatrics', 4, 3);

-- Surgery (4 doctors)
INSERT INTO Doctor (department_id, medical_license_id, dob, first_name, middle_name, last_name, gender, national_id, phone, email, address, expertise, doctor_level_id, active_status_id) VALUES
(4, 'ML-SUR-001', '1973-01-30', 'Võ', 'Văn', 'Sơn', 'Male', '001073010123', '0911234567', 'vv.son@hospital.vn', '852 Lê Văn Sỹ, Q3, TPHCM', 'General Surgery', 8, 4),
(4, 'ML-SUR-002', '1979-10-18', 'Phan', 'Thị', 'Thanh', 'Female', '001079011234', '0912345678', 'pt.thanh@hospital.vn', '963 Phan Xích Long, PN, TPHCM', 'Cardiovascular Surgery', 7, 4),
(4, 'ML-SUR-003', '1984-03-22', 'Lý', 'Minh', 'Tuấn', 'Male', '001084012345', '0913456789', 'lm.tuan@hospital.vn', '159 Nam Kỳ Khởi Nghĩa, Q1, TPHCM', 'Neurosurgery', 6, 4),
(4, 'ML-SUR-004', '1989-07-15', 'Mai', 'Thị', 'Uyên', 'Female', '001089013456', '0914567890', 'mt.uyen@hospital.vn', '753 Tô Hiến Thành, Q10, TPHCM', 'General Surgery', 5, 3);

-- Cardiology (3 doctors)
INSERT INTO Doctor (department_id, medical_license_id, dob, first_name, middle_name, last_name, gender, national_id, phone, email, address, expertise, doctor_level_id, active_status_id) VALUES
(5, 'ML-CAR-001', '1976-06-08', 'Trương', 'Văn', 'Vinh', 'Male', '001076014567', '0915678901', 'tv.vinh@hospital.vn', '357 Bạch Đằng, BT, TPHCM', 'Cardiology', 7, 4),
(5, 'ML-CAR-002', '1983-11-20', 'Lâm', 'Thị', 'Xuân', 'Female', '001083015678', '0916789012', 'lt.xuan@hospital.vn', '951 Hoàng Văn Thụ, TB, TPHCM', 'Interventional Cardiology', 6, 4),
(5, 'ML-CAR-003', '1987-04-05', 'Hồ', 'Minh', 'Yên', 'Male', '001087016789', '0917890123', 'hm.yen@hospital.vn', '246 Cộng Hòa, TB, TPHCM', 'Cardiology', 5, 4);

-- Neurology (2 doctors)
INSERT INTO Doctor (department_id, medical_license_id, dob, first_name, middle_name, last_name, gender, national_id, phone, email, address, expertise, doctor_level_id, active_status_id) VALUES
(6, 'ML-NEU-001', '1977-09-12', 'Đào', 'Văn', 'Ân', 'Male', '001077017890', '0918901234', 'dv.an@hospital.vn', '468 Lý Chính Thắng, Q3, TPHCM', 'Neurology', 7, 4),
(6, 'ML-NEU-002', '1985-02-27', 'Tô', 'Thị', 'Bảo', 'Female', '001085018901', '0919012345', 'tt.bao@hospital.vn', '579 Trần Quốc Thảo, Q3, TPHCM', 'Neuropsychiatry', 6, 4);

-- Orthopedics (3 doctors)
INSERT INTO Doctor (department_id, medical_license_id, dob, first_name, middle_name, last_name, gender, national_id, phone, email, address, expertise, doctor_level_id, active_status_id) VALUES
(7, 'ML-ORT-001', '1981-05-16', 'Dương', 'Văn', 'Châu', 'Male', '001081019012', '0920123456', 'dv.chau@hospital.vn', '681 Nguyễn Đình Chiểu, Q3, TPHCM', 'Orthopedic Surgery', 7, 4),
(7, 'ML-ORT-002', '1986-10-30', 'Cao', 'Thị', 'Diệu', 'Female', '001086020123', '0921234567', 'ct.dieu@hospital.vn', '792 Võ Văn Tần, Q3, TPHCM', 'Sports Medicine', 6, 4),
(7, 'ML-ORT-003', '1993-03-08', 'Hà', 'Minh', 'Đức', 'Male', '001093021234', '0922345678', 'hm.duc@hospital.vn', '813 Trần Kế Xương, PN, TPHCM', 'Orthopedics', 3, 4);

-- Radiology (2 doctors)
INSERT INTO Doctor (department_id, medical_license_id, dob, first_name, middle_name, last_name, gender, national_id, phone, email, address, expertise, doctor_level_id, active_status_id) VALUES
(8, 'ML-RAD-001', '1979-08-14', 'Huỳnh', 'Văn', 'Giang', 'Male', '001079022345', '0923456789', 'hv.giang@hospital.vn', '924 Xô Viết Nghệ Tĩnh, BT, TPHCM', 'Diagnostic Radiology', 7, 4),
(8, 'ML-RAD-002', '1988-01-20', 'Kiều', 'Thị', 'Hằng', 'Female', '001088023456', '0924567890', 'kt.hang@hospital.vn', '135 Bùi Thị Xuân, Q1, TPHCM', 'Interventional Radiology', 6, 4);

-- Obstetrics and Gynecology (3 doctors)
INSERT INTO Doctor (department_id, medical_license_id, dob, first_name, middle_name, last_name, gender, national_id, phone, email, address, expertise, doctor_level_id, active_status_id) VALUES
(9, 'ML-OBG-001', '1978-12-05', 'Lương', 'Thị', 'Kim', 'Female', '001078024567', '0925678901', 'lt.kim@hospital.vn', '246 Lê Quý Đôn, Q3, TPHCM', 'Obstetrics', 7, 4),
(9, 'ML-OBG-002', '1984-06-18', 'Nghiêm', 'Thị', 'Liên', 'Female', '001084025678', '0926789012', 'nt.lien@hospital.vn', '357 Phan Đình Phùng, PN, TPHCM', 'Gynecology', 6, 4),
(9, 'ML-OBG-003', '1990-09-23', 'Ông', 'Thị', 'Mai', 'Female', '001090026789', '0927890123', 'ot.mai@hospital.vn', '468 Nguyễn Tri Phương, Q10, TPHCM', 'Obstetrics', 4, 4);

-- Oncology (2 doctors)
INSERT INTO Doctor (department_id, medical_license_id, dob, first_name, middle_name, last_name, gender, national_id, phone, email, address, expertise, doctor_level_id, active_status_id) VALUES
(10, 'ML-ONC-001', '1974-07-11', 'Quách', 'Văn', 'Nhân', 'Male', '001074027890', '0928901234', 'qv.nhan@hospital.vn', '579 Cửu Long, TB, TPHCM', 'Medical Oncology', 8, 4),
(10, 'ML-ONC-002', '1982-11-28', 'Đinh', 'Thị', 'Oanh', 'Female', '001082028901', '0929012345', 'dt.oanh@hospital.vn', '681 Phan Văn Trị, GV, TPHCM', 'Radiation Oncology', 7, 4);

-- ==========================================
-- 3. UPDATE DEPARTMENT HEADS
-- ==========================================

UPDATE Department SET head_of_department_id = 1 WHERE id = 1;   -- Emergency Medicine
UPDATE Department SET head_of_department_id = 4 WHERE id = 2;   -- Internal Medicine
UPDATE Department SET head_of_department_id = 8 WHERE id = 3;   -- Pediatrics
UPDATE Department SET head_of_department_id = 11 WHERE id = 4;  -- Surgery
UPDATE Department SET head_of_department_id = 15 WHERE id = 5;  -- Cardiology
UPDATE Department SET head_of_department_id = 18 WHERE id = 6;  -- Neurology
UPDATE Department SET head_of_department_id = 20 WHERE id = 7;  -- Orthopedics
UPDATE Department SET head_of_department_id = 23 WHERE id = 8;  -- Radiology
UPDATE Department SET head_of_department_id = 25 WHERE id = 9;  -- OB/GYN
UPDATE Department SET head_of_department_id = 28 WHERE id = 10; -- Oncology

-- ==========================================
-- 4. PATIENTS (50 patients with diverse demographics)
-- ==========================================

INSERT INTO Patient (first_name, middle_name, last_name, dob, ethnicity, preferred_language, gender, biological_sex, phone, email, first_visit_date, last_visit_date, insurance_id, insurance_provider, blood_type, height, weight, dnr_status, organ_donor_status) VALUES
-- Patients 1-10
('Nguyễn', 'Văn', 'An', '1985-03-15', 'Kinh', 'Vietnamese', 'Male', 'Male', '0931234567', 'nv.an@email.vn', '2024-06-15', '2024-12-10', 'INS-001', 'Bảo Việt', 'O+', 170, 68, 0, 1),
('Trần', 'Thị', 'Bình', '1992-07-22', 'Kinh', 'Vietnamese', 'Female', 'Female', '0932345678', 'tt.binh@email.vn', '2024-07-20', '2024-11-25', 'INS-002', 'Bảo Minh', 'A+', 158, 52, 0, 0),
('Lê', 'Minh', 'Cảnh', '1978-11-08', 'Kinh', 'Vietnamese', 'Male', 'Male', '0933456789', 'lm.canh@email.vn', '2024-05-10', '2024-12-05', 'INS-003', 'Prudential', 'B+', 175, 72, 0, 1),
('Phạm', 'Thị', 'Dung', '1995-04-18', 'Kinh', 'Vietnamese', 'Female', 'Female', '0934567890', 'pt.dung@email.vn', '2024-08-12', '2024-12-18', NULL, NULL, 'AB+', 162, 55, 0, 0),
('Hoàng', 'Văn', 'Em', '1988-09-25', 'Kinh', 'Vietnamese', 'Male', 'Male', '0935678901', 'hv.em@email.vn', '2024-06-28', '2024-11-30', 'INS-005', 'Manulife', 'O-', 168, 65, 0, 1),
('Vũ', 'Thị', 'Phượng', '2000-01-12', 'Kinh', 'Vietnamese', 'Female', 'Female', '0936789012', 'vt.phuong@email.vn', '2024-09-05', '2024-12-12', 'INS-006', 'AIA', 'A-', 160, 48, 0, 0),
('Đặng', 'Minh', 'Giang', '1982-06-30', 'Kinh', 'Vietnamese', 'Male', 'Male', '0937890123', 'dm.giang@email.vn', '2024-07-15', '2024-12-08', 'INS-007', 'Bảo Việt', 'B-', 172, 70, 0, 1),
('Bùi', 'Thị', 'Hạnh', '1975-12-05', 'Kinh', 'Vietnamese', 'Female', 'Female', '0938901234', 'bt.hanh@email.vn', '2024-05-20', '2024-10-22', NULL, NULL, 'AB-', 156, 60, 1, 0),
('Đỗ', 'Văn', 'Ích', '1990-08-14', 'Kinh', 'Vietnamese', 'Male', 'Male', '0939012345', 'dv.ich@email.vn', '2024-08-25', '2024-12-15', 'INS-009', 'Bảo Minh', 'O+', 178, 75, 0, 1),
('Ngô', 'Thị', 'Khánh', '1998-02-20', 'Kinh', 'Vietnamese', 'Female', 'Female', '0940123456', 'nt.khanh@email.vn', '2024-09-10', '2024-12-01', 'INS-010', 'Prudential', 'A+', 164, 54, 0, 0),

-- Patients 11-20
('Võ', 'Minh', 'Linh', '1987-05-16', 'Kinh', 'Vietnamese', 'Male', 'Male', '0941234567', 'vm.linh@email.vn', '2024-06-05', '2024-11-18', 'INS-011', 'AIA', 'B+', 174, 71, 0, 1),
('Phan', 'Thị', 'Mai', '1993-10-28', 'Kinh', 'Vietnamese', 'Female', 'Female', '0942345678', 'pt.mai@email.vn', '2024-07-18', '2024-12-14', NULL, NULL, 'O-', 159, 51, 0, 0),
('Lý', 'Văn', 'Nam', '1980-03-09', 'Kinh', 'Vietnamese', 'Male', 'Male', '0943456789', 'lv.nam@email.vn', '2024-08-08', '2024-12-06', 'INS-013', 'Manulife', 'AB+', 169, 67, 0, 1),
('Mai', 'Thị', 'Oanh', '1996-12-22', 'Kinh', 'Vietnamese', 'Female', 'Female', '0944567890', 'mt.oanh@email.vn', '2024-09-20', '2024-12-17', 'INS-014', 'Bảo Việt', 'A-', 161, 53, 0, 0),
('Trương', 'Minh', 'Phú', '1984-07-11', 'Kinh', 'Vietnamese', 'Male', 'Male', '0945678901', 'tm.phu@email.vn', '2024-06-22', '2024-11-28', 'INS-015', 'Bảo Minh', 'B-', 176, 73, 0, 1),
('Lâm', 'Thị', 'Quỳnh', '1991-11-03', 'Kinh', 'Vietnamese', 'Female', 'Female', '0946789012', 'lt.quynh@email.vn', '2024-07-30', '2024-12-09', NULL, NULL, 'O+', 163, 56, 0, 0),
('Hồ', 'Văn', 'Sang', '1979-04-27', 'Kinh', 'Vietnamese', 'Male', 'Male', '0947890123', 'hv.sang@email.vn', '2024-08-15', '2024-12-11', 'INS-017', 'Prudential', 'A+', 171, 69, 0, 1),
('Đào', 'Thị', 'Thảo', '1997-09-19', 'Kinh', 'Vietnamese', 'Female', 'Female', '0948901234', 'dt.thao@email.vn', '2024-09-28', '2024-12-16', 'INS-018', 'AIA', 'B+', 157, 50, 0, 0),
('Tô', 'Minh', 'Uy', '1986-01-08', 'Kinh', 'Vietnamese', 'Male', 'Male', '0949012345', 'tm.uy@email.vn', '2024-06-18', '2024-11-22', 'INS-019', 'Manulife', 'AB-', 173, 74, 1, 0),
('Dương', 'Thị', 'Vân', '1994-06-15', 'Kinh', 'Vietnamese', 'Female', 'Female', '0950123456', 'dt.van@email.vn', '2024-07-25', '2024-12-13', NULL, NULL, 'O-', 165, 58, 0, 1),

-- Patients 21-30
('Cao', 'Văn', 'Xuân', '1981-11-30', 'Kinh', 'Vietnamese', 'Male', 'Male', '0951234567', 'cv.xuan@email.vn', '2024-08-02', '2024-12-04', 'INS-021', 'Bảo Việt', 'A+', 177, 76, 0, 1),
('Hà', 'Thị', 'Yến', '1989-03-24', 'Kinh', 'Vietnamese', 'Female', 'Female', '0952345678', 'ht.yen@email.vn', '2024-09-14', '2024-12-02', 'INS-022', 'Bảo Minh', 'B+', 158, 52, 0, 0),
('Huỳnh', 'Minh', 'An', '1999-08-07', 'Kinh', 'Vietnamese', 'Male', 'Male', '0953456789', 'hm.an@email.vn', '2024-06-10', '2024-11-20', 'INS-023', 'Prudential', 'O+', 170, 66, 0, 1),
('Kiều', 'Thị', 'Bảo', '1976-12-18', 'Kinh', 'Vietnamese', 'Female', 'Female', '0954567890', 'kt.bao@email.vn', '2024-07-08', '2024-10-15', NULL, NULL, 'AB+', 160, 62, 1, 0),
('Lương', 'Văn', 'Cường', '1992-05-29', 'Kinh', 'Vietnamese', 'Male', 'Male', '0955678901', 'lv.cuong@email.vn', '2024-08-20', '2024-12-07', 'INS-025', 'AIA', 'A-', 175, 72, 0, 1),
('Nghiêm', 'Thị', 'Diệp', '1988-10-12', 'Kinh', 'Vietnamese', 'Female', 'Female', '0956789012', 'nt.diep@email.vn', '2024-09-03', '2024-12-19', 'INS-026', 'Manulife', 'B-', 162, 55, 0, 0),
('Ông', 'Minh', 'Đạt', '1983-02-26', 'Kinh', 'Vietnamese', 'Male', 'Male', '0957890123', 'om.dat@email.vn', '2024-06-28', '2024-11-26', 'INS-027', 'Bảo Việt', 'O-', 172, 70, 0, 1),
('Quách', 'Thị', 'Nga', '1995-07-14', 'Kinh', 'Vietnamese', 'Female', 'Female', '0958901234', 'qt.nga@email.vn', '2024-07-12', '2024-12-10', NULL, NULL, 'AB-', 159, 49, 0, 0),
('Đinh', 'Văn', 'Hùng', '1990-11-05', 'Kinh', 'Vietnamese', 'Male', 'Male', '0959012345', 'dv.hung@email.vn', '2024-08-18', '2024-12-12', 'INS-029', 'Bảo Minh', 'A+', 174, 71, 0, 1),
('Tạ', 'Thị', 'Kim', '1985-04-20', 'Kinh', 'Vietnamese', 'Female', 'Female', '0960123456', 'tt.kim@email.vn', '2024-09-22', '2024-12-15', 'INS-030', 'Prudential', 'B+', 161, 54, 0, 0),

-- Patients 31-40
('Ứng', 'Minh', 'Long', '1977-09-08', 'Kinh', 'Vietnamese', 'Male', 'Male', '0961234567', 'um.long@email.vn', '2024-06-03', '2024-11-18', 'INS-031', 'AIA', 'O+', 168, 68, 0, 1),
('Vương', 'Thị', 'Hương', '1998-01-28', 'Kinh', 'Vietnamese', 'Female', 'Female', '0962345678', 'vt.huong@email.vn', '2024-07-22', '2024-12-08', NULL, NULL, 'A-', 164, 53, 0, 0),
('Xa', 'Văn', 'Minh', '1991-06-16', 'Kinh', 'Vietnamese', 'Male', 'Male', '0963456789', 'xv.minh@email.vn', '2024-08-05', '2024-12-14', 'INS-033', 'Manulife', 'B-', 176, 75, 0, 1),
('Yên', 'Thị', 'Nhi', '1987-11-23', 'Kinh', 'Vietnamese', 'Female', 'Female', '0964567890', 'yt.nhi@email.vn', '2024-09-16', '2024-12-03', 'INS-034', 'Bảo Việt', 'AB+', 158, 51, 0, 0),
('Âu', 'Minh', 'Phong', '1982-03-11', 'Kinh', 'Vietnamese', 'Male', 'Male', '0965678901', 'am.phong@email.vn', '2024-06-20', '2024-11-29', 'INS-035', 'Bảo Minh', 'O-', 171, 69, 0, 1),
('Ân', 'Thị', 'Quế', '1996-08-04', 'Kinh', 'Vietnamese', 'Female', 'Female', '0966789012', 'at.que@email.vn', '2024-07-28', '2024-12-17', NULL, NULL, 'A+', 160, 52, 0, 0),
('Ấu', 'Văn', 'Sỹ', '1989-12-22', 'Kinh', 'Vietnamese', 'Male', 'Male', '0967890123', 'av.sy@email.vn', '2024-08-12', '2024-12-11', 'INS-037', 'Prudential', 'B+', 173, 72, 0, 1),
('Âu Dương', 'Thị', 'Tâm', '1994-05-09', 'Kinh', 'Vietnamese', 'Female', 'Female', '0968901234', 'adt.tam@email.vn', '2024-09-25', '2024-12-05', 'INS-038', 'AIA', 'AB-', 162, 55, 0, 0),
('Bạch', 'Minh', 'Tuấn', '1984-10-17', 'Kinh', 'Vietnamese', 'Male', 'Male', '0969012345', 'bm.tuan@email.vn', '2024-06-15', '2024-11-24', 'INS-039', 'Manulife', 'O+', 175, 74, 1, 0),
('Bành', 'Thị', 'Uyên', '1993-02-28', 'Kinh', 'Vietnamese', 'Female', 'Female', '0970123456', 'bt.uyen@email.vn', '2024-07-19', '2024-12-09', NULL, NULL, 'A-', 157, 50, 0, 1),

-- Patients 41-50
('Biện', 'Văn', 'Vũ', '1978-07-06', 'Kinh', 'Vietnamese', 'Male', 'Male', '0971234567', 'bv.vu@email.vn', '2024-08-28', '2024-12-16', 'INS-041', 'Bảo Việt', 'B-', 169, 67, 0, 1),
('Bồ', 'Thị', 'Xuân', '1997-12-14', 'Kinh', 'Vietnamese', 'Female', 'Female', '0972345678', 'bt.xuan@email.vn', '2024-09-08', '2024-12-18', 'INS-042', 'Bảo Minh', 'AB+', 163, 56, 0, 0),
('Chu', 'Minh', 'Yên', '1986-04-25', 'Kinh', 'Vietnamese', 'Male', 'Male', '0973456789', 'cm.yen@email.vn', '2024-06-12', '2024-11-21', 'INS-043', 'Prudential', 'O-', 172, 70, 0, 1),
('Cung', 'Thị', 'Anh', '1992-09-18', 'Kinh', 'Vietnamese', 'Female', 'Female', '0974567890', 'ct.anh@email.vn', '2024-07-26', '2024-12-06', NULL, NULL, 'A+', 165, 58, 0, 0),
('Đan', 'Văn', 'Bình', '1980-01-31', 'Kinh', 'Vietnamese', 'Male', 'Male', '0975678901', 'dv.binh@email.vn', '2024-08-09', '2024-12-13', 'INS-045', 'AIA', 'B+', 170, 68, 0, 1),
('Đào', 'Thị', 'Chi', '1995-06-13', 'Kinh', 'Vietnamese', 'Female', 'Female', '0976789012', 'dt.chi@email.vn', '2024-09-18', '2024-12-04', 'INS-046', 'Manulife', 'O+', 159, 51, 0, 0),
('Điền', 'Minh', 'Duy', '1988-11-26', 'Kinh', 'Vietnamese', 'Male', 'Male', '0977890123', 'dm.duy@email.vn', '2024-06-25', '2024-11-27', 'INS-047', 'Bảo Việt', 'AB-', 174, 73, 0, 1),
('Đoàn', 'Thị', 'Giang', '1983-03-19', 'Kinh', 'Vietnamese', 'Female', 'Female', '0978901234', 'dt.giang@email.vn', '2024-07-16', '2024-12-07', NULL, NULL, 'A-', 161, 54, 0, 0),
('Đổng', 'Văn', 'Hải', '1999-08-02', 'Kinh', 'Vietnamese', 'Male', 'Male', '0979012345', 'dv.hai@email.vn', '2024-08-22', '2024-12-19', 'INS-049', 'Bảo Minh', 'B-', 177, 76, 0, 1),
('Đường', 'Thị', 'Linh', '1990-12-10', 'Kinh', 'Vietnamese', 'Female', 'Female', '0980123456', 'dt.linh@email.vn', '2024-09-12', '2024-12-01', 'INS-050', 'Prudential', 'O+', 160, 53, 0, 0);

-- ==========================================
-- 5. PATIENT PERSONAL INFORMATION
-- ==========================================

-- Add personal info for first 25 patients (representative sample)
INSERT INTO PatientPersonalInformation (patient_id, occupation, nat_id, address, city, state, country) VALUES
(1, 'Software Engineer', '001085001234', '123 Nguyễn Văn Linh, Q7', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(2, 'Teacher', '001092002345', '456 Lê Lai, Q1', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(3, 'Business Owner', '001078003456', '789 Võ Văn Ngân, Thủ Đức', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(4, 'Graphic Designer', '001095004567', '321 Phan Văn Trị, GV', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(5, 'Accountant', '001088005678', '654 Hoàng Diệu, Q4', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(6, 'Student', '002000006789', '987 Nguyễn Thái Sơn, GV', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(7, 'Marketing Manager', '001082007890', '147 Trường Chinh, TB', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(8, 'Retired', '001075008901', '258 Lạc Long Quân, Q11', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(9, 'Chef', '001090009012', '369 Phạm Văn Đồng, Thủ Đức', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(10, 'Nurse', '001098010123', '741 Ba Tháng Hai, Q10', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(11, 'Civil Engineer', '001087011234', '852 Đinh Tiên Hoàng, BT', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(12, 'Pharmacist', '001093012345', '963 Khánh Hội, Q4', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(13, 'Lawyer', '001080013456', '159 Nguyễn Thị Minh Khai, Q3', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(14, 'Sales Representative', '001096014567', '753 Lý Thường Kiệt, Q10', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(15, 'Architect', '001084015678', '357 Hùng Vương, Q5', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(16, 'Journalist', '001091016789', '951 Nguyễn Oanh, GV', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(17, 'Police Officer', '001079017890', '246 Trần Phú, Q5', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(18, 'Photographer', '001097018901', '468 Điện Biên Phủ, Q3', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(19, 'Mechanic', '001086019012', '579 Kha Vạn Cân, Thủ Đức', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(20, 'Hairdresser', '001094020123', '681 Bùi Hữu Nghĩa, Q5', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(21, 'Bank Teller', '001081021234', '792 Tân Sơn Nhì, TB', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(22, 'Veterinarian', '001089022345', '813 Lê Đức Thọ, GV', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(23, 'Web Developer', '001999023456', '924 Quang Trung, GV', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(24, 'Housewife', '001076024567', '135 Tân Kỳ Tân Quý, TB', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam'),
(25, 'Real Estate Agent', '001092025678', '246 Âu Cơ, TB', 'TP Hồ Chí Minh', 'TP Hồ Chí Minh', 'Vietnam');

-- ==========================================
-- 6. MEDICINES (50 common medicines)
-- ==========================================

INSERT INTO Medicine (medicine_name, producer, medicine_type_id, medicine_administration_method_id, medicine_unit) VALUES
-- Analgesics & Antipyretics
('Paracetamol 500mg', 'Pymepharco', 1, 1, 'tablets'),
('Ibuprofen 400mg', 'Domesco', 1, 1, 'tablets'),
('Aspirin 100mg', 'Pharbaco', 1, 1, 'tablets'),
('Morphine 10mg', 'Pharbaco', 1, 13, 'ampoules'),

-- Antibiotics
('Amoxicillin 500mg', 'Mediplantex', 2, 1, 'capsules'),
('Azithromycin 250mg', 'Domesco', 2, 1, 'tablets'),
('Ciprofloxacin 500mg', 'Imexpharm', 2, 1, 'tablets'),
('Ceftriaxone 1g', 'Hautraco', 2, 12, 'vials'),
('Metronidazole 250mg', 'SPM', 2, 1, 'tablets'),

-- Antihistamines
('Cetirizine 10mg', 'Domesco', 4, 1, 'tablets'),
('Loratadine 10mg', 'Sanofi', 4, 1, 'tablets'),
('Diphenhydramine 25mg', 'Pymepharco', 4, 1, 'capsules'),

-- Antivirals
('Acyclovir 400mg', 'Traphaco', 6, 1, 'tablets'),
('Oseltamivir 75mg', 'Stada', 6, 1, 'capsules'),

-- Gastrointestinal
('Omeprazole 20mg', 'Mediplantex', 16, 1, 'capsules'),
('Ranitidine 150mg', 'Domesco', 17, 1, 'tablets'),
('Metoclopramide 10mg', 'Hautraco', 18, 1, 'tablets'),
('Ondansetron 8mg', 'Imexpharm', 18, 1, 'tablets'),

-- Cardiovascular
('Atorvastatin 20mg', 'Sanofi', 14, 1, 'tablets'),
('Simvastatin 40mg', 'Teva', 14, 1, 'tablets'),
('Amlodipine 5mg', 'Domesco', 22, 1, 'tablets'),
('Metoprolol 50mg', 'Imexpharm', 21, 1, 'tablets'),
('Enalapril 10mg', 'Stada', 23, 1, 'tablets'),
('Furosemide 40mg', 'Pharbaco', 20, 1, 'tablets'),

-- Diabetes
('Metformin 500mg', 'Berlin Pharmaceutical', 24, 1, 'tablets'),
('Glipizide 5mg', 'Traphaco', 24, 1, 'tablets'),
('Insulin Glargine 100U/ml', 'Sanofi', 24, 13, 'cartridges'),

-- Respiratory
('Salbutamol Inhaler 100mcg', 'GSK', 11, 10, 'doses'),
('Budesonide Inhaler 200mcg', 'AstraZeneca', 12, 10, 'doses'),
('Montelukast 10mg', 'Teva', 11, 1, 'tablets'),

-- Vitamins & Supplements
('Vitamin B Complex', 'Pymepharco', 30, 1, 'tablets'),
('Vitamin C 1000mg', 'Domesco', 30, 1, 'tablets'),
('Calcium + Vitamin D3', 'SPM', 30, 1, 'tablets'),
('Folic Acid 5mg', 'Pharbaco', 30, 1, 'tablets'),

-- Antibiotics (continued)
('Doxycycline 100mg', 'Mediplantex', 2, 1, 'capsules'),
('Clarithromycin 250mg', 'Stada', 2, 1, 'tablets'),

-- Pain & Inflammation
('Diclofenac 50mg', 'Berlin Pharmaceutical', 1, 1, 'tablets'),
('Meloxicam 15mg', 'Teva', 1, 1, 'tablets'),
('Naproxen 500mg', 'Domesco', 1, 1, 'tablets'),

-- Mental Health
('Fluoxetine 20mg', 'Stada', 8, 1, 'capsules'),
('Alprazolam 0.5mg', 'Teva', 27, 1, 'tablets'),
('Diazepam 5mg', 'Pharbaco', 27, 1, 'tablets'),

-- Antifungal
('Fluconazole 150mg', 'Traphaco', 3, 1, 'capsules'),
('Clotrimazole Cream 1%', 'Domesco', 3, 4, 'tubes'),

-- Corticosteroids
('Prednisolone 5mg', 'Pharbaco', 12, 1, 'tablets'),
('Dexamethasone 0.5mg', 'Mediplantex', 12, 1, 'tablets'),
('Hydrocortisone Cream 1%', 'SPM', 12, 4, 'tubes'),

-- Anticoagulants
('Warfarin 5mg', 'Stada', 7, 1, 'tablets'),
('Clopidogrel 75mg', 'Sanofi', 7, 1, 'tablets'),

-- Others
('Levothyroxine 50mcg', 'Pharbaco', 25, 1, 'tablets');

-- ==========================================
-- 7. INITIAL MEDICINE STOCK
-- ==========================================

-- Add initial stock for all medicines (500-1000 units each)
INSERT INTO MedicineStockHistory (medicine_id, add_remove, amount, appointment_id, note) VALUES
(1, 1, 800, NULL, 'Initial stock - Paracetamol'),
(2, 1, 600, NULL, 'Initial stock - Ibuprofen'),
(3, 1, 500, NULL, 'Initial stock - Aspirin'),
(4, 1, 100, NULL, 'Initial stock - Morphine'),
(5, 1, 700, NULL, 'Initial stock - Amoxicillin'),
(6, 1, 500, NULL, 'Initial stock - Azithromycin'),
(7, 1, 600, NULL, 'Initial stock - Ciprofloxacin'),
(8, 1, 200, NULL, 'Initial stock - Ceftriaxone'),
(9, 1, 500, NULL, 'Initial stock - Metronidazole'),
(10, 1, 800, NULL, 'Initial stock - Cetirizine'),
(11, 1, 700, NULL, 'Initial stock - Loratadine'),
(12, 1, 400, NULL, 'Initial stock - Diphenhydramine'),
(13, 1, 300, NULL, 'Initial stock - Acyclovir'),
(14, 1, 250, NULL, 'Initial stock - Oseltamivir'),
(15, 1, 900, NULL, 'Initial stock - Omeprazole'),
(16, 1, 600, NULL, 'Initial stock - Ranitidine'),
(17, 1, 500, NULL, 'Initial stock - Metoclopramide'),
(18, 1, 400, NULL, 'Initial stock - Ondansetron'),
(19, 1, 1000, NULL, 'Initial stock - Atorvastatin'),
(20, 1, 800, NULL, 'Initial stock - Simvastatin'),
(21, 1, 900, NULL, 'Initial stock - Amlodipine'),
(22, 1, 700, NULL, 'Initial stock - Metoprolol'),
(23, 1, 600, NULL, 'Initial stock - Enalapril'),
(24, 1, 500, NULL, 'Initial stock - Furosemide'),
(25, 1, 1000, NULL, 'Initial stock - Metformin'),
(26, 1, 600, NULL, 'Initial stock - Glipizide'),
(27, 1, 150, NULL, 'Initial stock - Insulin'),
(28, 1, 300, NULL, 'Initial stock - Salbutamol Inhaler'),
(29, 1, 250, NULL, 'Initial stock - Budesonide Inhaler'),
(30, 1, 500, NULL, 'Initial stock - Montelukast'),
(31, 1, 800, NULL, 'Initial stock - Vitamin B Complex'),
(32, 1, 900, NULL, 'Initial stock - Vitamin C'),
(33, 1, 700, NULL, 'Initial stock - Calcium + D3'),
(34, 1, 500, NULL, 'Initial stock - Folic Acid'),
(35, 1, 600, NULL, 'Initial stock - Doxycycline'),
(36, 1, 500, NULL, 'Initial stock - Clarithromycin'),
(37, 1, 800, NULL, 'Initial stock - Diclofenac'),
(38, 1, 600, NULL, 'Initial stock - Meloxicam'),
(39, 1, 700, NULL, 'Initial stock - Naproxen'),
(40, 1, 400, NULL, 'Initial stock - Fluoxetine'),
(41, 1, 300, NULL, 'Initial stock - Alprazolam'),
(42, 1, 400, NULL, 'Initial stock - Diazepam'),
(43, 1, 500, NULL, 'Initial stock - Fluconazole'),
(44, 1, 600, NULL, 'Initial stock - Clotrimazole Cream'),
(45, 1, 700, NULL, 'Initial stock - Prednisolone'),
(46, 1, 500, NULL, 'Initial stock - Dexamethasone'),
(47, 1, 400, NULL, 'Initial stock - Hydrocortisone Cream'),
(48, 1, 500, NULL, 'Initial stock - Warfarin'),
(49, 1, 800, NULL, 'Initial stock - Clopidogrel'),
(50, 1, 600, NULL, 'Initial stock - Levothyroxine');

-- ==========================================
-- 8. APPOINTMENTS (100 appointments over last 3 months)
-- ==========================================

-- Appointments for various conditions, distributed across time and departments
INSERT INTO Appointments (patient_id, doctor_id, visit_date, diagnosis, category, note) VALUES
-- October 2024 (30 appointments)
(1, 1, '2024-10-01 09:00:00', 'Chest Pain', 'Emergency', 'Patient presented with acute chest pain'),
(2, 4, '2024-10-02 10:30:00', 'Type 2 Diabetes', 'Follow-up', 'Blood sugar monitoring'),
(3, 8, '2024-10-03 14:00:00', 'Pediatric Fever', 'Consultation', 'High fever in child'),
(4, 11, '2024-10-04 11:00:00', 'Appendicitis', 'Surgery', 'Emergency appendectomy required'),
(5, 15, '2024-10-05 15:30:00', 'Hypertension', 'Follow-up', 'Blood pressure check'),
(6, 18, '2024-10-06 09:30:00', 'Migraine', 'Consultation', 'Chronic headaches'),
(7, 20, '2024-10-07 13:00:00', 'Knee Pain', 'Consultation', 'Sports injury assessment'),
(8, 4, '2024-10-08 10:00:00', 'Gastritis', 'Consultation', 'Stomach discomfort'),
(9, 25, '2024-10-09 11:30:00', 'Prenatal Check-up', 'Check-up', 'Second trimester screening'),
(10, 8, '2024-10-10 16:00:00', 'Asthma', 'Follow-up', 'Breathing difficulties'),
(11, 1, '2024-10-11 08:30:00', 'Minor Burns', 'Emergency', 'Kitchen accident'),
(12, 4, '2024-10-12 14:30:00', 'High Cholesterol', 'Follow-up', 'Lipid profile review'),
(13, 15, '2024-10-13 10:00:00', 'Angina', 'Consultation', 'Chest discomfort on exertion'),
(14, 20, '2024-10-14 15:00:00', 'Sprained Ankle', 'Consultation', 'Sports injury'),
(15, 11, '2024-10-15 09:00:00', 'Hernia', 'Consultation', 'Surgical evaluation'),
(16, 28, '2024-10-16 11:00:00', 'Breast Cancer Screening', 'Check-up', 'Annual mammography'),
(17, 23, '2024-10-17 13:30:00', 'CT Scan', 'Imaging', 'Abdominal imaging'),
(18, 18, '2024-10-18 10:30:00', 'Seizure Disorder', 'Follow-up', 'Epilepsy management'),
(19, 8, '2024-10-19 14:00:00', 'Vaccination', 'Prevention', 'Routine immunization'),
(20, 4, '2024-10-20 16:30:00', 'Anemia', 'Consultation', 'Fatigue and weakness'),
(21, 2, '2024-10-21 09:00:00', 'Laceration', 'Emergency', 'Wound suturing required'),
(22, 25, '2024-10-22 11:30:00', 'Menstrual Irregularity', 'Consultation', 'PCOS evaluation'),
(23, 15, '2024-10-23 15:00:00', 'Atrial Fibrillation', 'Follow-up', 'Heart rhythm monitoring'),
(24, 20, '2024-10-24 10:00:00', 'Arthritis', 'Consultation', 'Joint pain management'),
(25, 11, '2024-10-25 13:00:00', 'Gallstones', 'Consultation', 'Surgical evaluation'),
(26, 4, '2024-10-26 14:30:00', 'Thyroid Disorder', 'Follow-up', 'Hormone level check'),
(27, 8, '2024-10-27 09:30:00', 'Tonsillitis', 'Consultation', 'Sore throat in child'),
(28, 28, '2024-10-28 11:00:00', 'Chemotherapy', 'Treatment', 'Cancer treatment session'),
(29, 1, '2024-10-29 15:30:00', 'Food Poisoning', 'Emergency', 'Severe vomiting'),
(30, 18, '2024-10-30 10:30:00', 'Parkinsons Disease', 'Follow-up', 'Movement disorder management'),

-- November 2024 (35 appointments)
(31, 4, '2024-11-01 09:00:00', 'Bronchitis', 'Consultation', 'Persistent cough'),
(32, 8, '2024-11-02 14:00:00', 'Chickenpox', 'Consultation', 'Viral rash in child'),
(33, 15, '2024-11-03 10:30:00', 'Coronary Artery Disease', 'Follow-up', 'Post-angioplasty care'),
(34, 25, '2024-11-04 11:30:00', 'Pregnancy Check-up', 'Check-up', 'Third trimester screening'),
(35, 20, '2024-11-05 15:00:00', 'Fracture', 'Emergency', 'Wrist fracture from fall'),
(36, 2, '2024-11-06 08:30:00', 'Allergic Reaction', 'Emergency', 'Severe allergic response'),
(37, 11, '2024-11-07 13:00:00', 'Lipoma Removal', 'Surgery', 'Minor surgical procedure'),
(38, 4, '2024-11-08 16:00:00', 'Liver Disease', 'Consultation', 'Elevated liver enzymes'),
(39, 23, '2024-11-09 10:00:00', 'MRI Scan', 'Imaging', 'Brain imaging'),
(40, 18, '2024-11-10 14:30:00', 'Multiple Sclerosis', 'Follow-up', 'Disease monitoring'),
(41, 8, '2024-11-11 09:30:00', 'Ear Infection', 'Consultation', 'Otitis media'),
(42, 28, '2024-11-12 11:00:00', 'Lung Cancer', 'Consultation', 'New diagnosis workup'),
(43, 15, '2024-11-13 15:30:00', 'Heart Failure', 'Follow-up', 'Fluid management'),
(44, 20, '2024-11-14 10:30:00', 'Back Pain', 'Consultation', 'Lumbar disc issues'),
(45, 4, '2024-11-15 13:00:00', 'Pneumonia', 'Consultation', 'Severe respiratory infection'),
(46, 25, '2024-11-16 14:00:00', 'Postpartum Check-up', 'Check-up', '6-week postnatal visit'),
(47, 11, '2024-11-17 09:00:00', 'Varicose Veins', 'Consultation', 'Surgical evaluation'),
(48, 1, '2024-11-18 16:30:00', 'Acute Abdomen', 'Emergency', 'Severe abdominal pain'),
(49, 8, '2024-11-19 11:30:00', 'Eczema', 'Consultation', 'Skin rash in child'),
(50, 4, '2024-11-20 10:00:00', 'Acid Reflux', 'Follow-up', 'GERD management'),
(1, 15, '2024-11-21 14:30:00', 'Chest Pain Follow-up', 'Follow-up', 'Cardiac workup results'),
(2, 4, '2024-11-22 09:30:00', 'Diabetes Follow-up', 'Follow-up', 'A1C results'),
(3, 8, '2024-11-23 15:00:00', 'Pediatric Follow-up', 'Follow-up', 'Fever resolved'),
(4, 11, '2024-11-24 10:30:00', 'Post-Surgery Follow-up', 'Follow-up', 'Wound healing check'),
(5, 15, '2024-11-25 13:00:00', 'Blood Pressure Check', 'Follow-up', 'Medication adjustment'),
(6, 18, '2024-11-26 11:00:00', 'Migraine Follow-up', 'Follow-up', 'New medication trial'),
(7, 20, '2024-11-27 14:00:00', 'Knee Follow-up', 'Follow-up', 'Physical therapy progress'),
(8, 4, '2024-11-28 16:00:00', 'Gastritis Follow-up', 'Follow-up', 'Symptom improvement'),
(9, 25, '2024-11-29 09:00:00', 'Prenatal Visit', 'Check-up', 'Third trimester screening'),
(10, 8, '2024-11-30 10:30:00', 'Asthma Follow-up', 'Follow-up', 'Inhaler technique review'),
(11, 2, '2024-11-30 15:30:00', 'Wound Check', 'Follow-up', 'Burn healing assessment'),

-- December 2024 (35 appointments)
(12, 4, '2024-12-01 09:00:00', 'Cholesterol Follow-up', 'Follow-up', 'Statin efficacy'),
(13, 15, '2024-12-02 14:00:00', 'Cardiac Stress Test', 'Diagnostic', 'Angina evaluation'),
(14, 20, '2024-12-03 10:30:00', 'Ankle Follow-up', 'Follow-up', 'Sprain recovery'),
(15, 11, '2024-12-04 11:00:00', 'Pre-Surgery Consultation', 'Consultation', 'Hernia repair planning'),
(16, 28, '2024-12-05 15:00:00', 'Cancer Follow-up', 'Follow-up', 'Screening results'),
(17, 23, '2024-12-06 09:30:00', 'X-Ray', 'Imaging', 'Chest X-ray'),
(18, 18, '2024-12-07 13:00:00', 'Epilepsy Follow-up', 'Follow-up', 'Seizure control'),
(19, 8, '2024-12-08 16:00:00', 'Vaccination Follow-up', 'Follow-up', 'Second dose'),
(20, 4, '2024-12-09 10:00:00', 'Anemia Follow-up', 'Follow-up', 'Iron supplementation'),
(21, 2, '2024-12-10 14:30:00', 'Suture Removal', 'Follow-up', 'Laceration healed'),
(22, 25, '2024-12-11 11:30:00', 'PCOS Follow-up', 'Follow-up', 'Hormone therapy'),
(23, 15, '2024-12-12 15:30:00', 'AFib Follow-up', 'Follow-up', 'Anticoagulation monitoring'),
(24, 20, '2024-12-13 09:00:00', 'Arthritis Management', 'Follow-up', 'Joint injection'),
(25, 11, '2024-12-14 10:30:00', 'Gallbladder Surgery', 'Surgery', 'Cholecystectomy'),
(26, 4, '2024-12-15 13:00:00', 'Thyroid Follow-up', 'Follow-up', 'TSH levels normal'),
(27, 8, '2024-12-16 14:00:00', 'Tonsillitis Follow-up', 'Follow-up', 'Symptom resolution'),
(28, 28, '2024-12-17 11:00:00', 'Chemotherapy Session', 'Treatment', 'Cycle 2'),
(29, 1, '2024-12-18 09:30:00', 'Food Poisoning Follow-up', 'Follow-up', 'Full recovery'),
(30, 18, '2024-12-19 15:00:00', 'Parkinsons Follow-up', 'Follow-up', 'Medication adjustment'),
(31, 4, '2024-12-01 16:30:00', 'Urinary Tract Infection', 'Consultation', 'Painful urination'),
(32, 8, '2024-12-02 09:00:00', 'Diarrhea', 'Consultation', 'Gastroenteritis in child'),
(33, 15, '2024-12-03 13:30:00', 'Pacemaker Check', 'Follow-up', 'Device monitoring'),
(34, 25, '2024-12-04 10:00:00', 'Infertility Consultation', 'Consultation', 'Family planning'),
(35, 20, '2024-12-05 14:00:00', 'Shoulder Pain', 'Consultation', 'Rotator cuff injury'),
(36, 2, '2024-12-06 11:30:00', 'Nosebleed', 'Emergency', 'Epistaxis control'),
(37, 11, '2024-12-07 15:30:00', 'Hemorrhoid Surgery', 'Surgery', 'Surgical excision'),
(38, 4, '2024-12-08 09:00:00', 'Celiac Disease', 'Consultation', 'Gluten sensitivity'),
(39, 23, '2024-12-09 10:30:00', 'Ultrasound', 'Imaging', 'Abdominal ultrasound'),
(40, 18, '2024-12-10 13:00:00', 'Stroke Follow-up', 'Follow-up', 'Rehabilitation progress'),
(41, 8, '2024-12-11 14:30:00', 'Conjunctivitis', 'Consultation', 'Pink eye'),
(42, 28, '2024-12-12 11:00:00', 'Radiation Therapy', 'Treatment', 'Treatment planning'),
(43, 15, '2024-12-13 16:00:00', 'Heart Valve Replacement', 'Surgery', 'Pre-surgery assessment'),
(44, 20, '2024-12-14 09:30:00', 'Hip Replacement', 'Surgery', 'Pre-surgery planning'),
(45, 4, '2024-12-15 15:00:00', 'COVID-19', 'Consultation', 'Mild symptoms');

-- ==========================================
-- 9. PRESCRIPTIONS (80+ prescriptions linked to appointments)
-- ==========================================

-- Prescriptions for appointments with appropriate medicines
INSERT INTO PrescriptionHistory (appointment_id, medicine_id, prescription_date, amount) VALUES
-- October prescriptions
(1, 3, '2024-10-01', 30),   -- Aspirin for chest pain
(1, 49, '2024-10-01', 30),  -- Clopidogrel for chest pain
(2, 25, '2024-10-02', 60),  -- Metformin for diabetes
(3, 1, '2024-10-03', 20),   -- Paracetamol for fever
(3, 5, '2024-10-03', 14),   -- Amoxicillin for fever
(4, 8, '2024-10-04', 5),    -- Ceftriaxone for surgery
(4, 9, '2024-10-04', 21),   -- Metronidazole post-surgery
(5, 21, '2024-10-05', 30),  -- Amlodipine for hypertension
(6, 2, '2024-10-06', 30),   -- Ibuprofen for migraine
(7, 37, '2024-10-07', 30),  -- Diclofenac for knee pain
(8, 15, '2024-10-08', 28),  -- Omeprazole for gastritis
(9, 34, '2024-10-09', 90),  -- Folic acid prenatal
(10, 28, '2024-10-10', 2),  -- Salbutamol for asthma
(10, 29, '2024-10-10', 1),  -- Budesonide for asthma
(11, 47, '2024-10-11', 1),  -- Hydrocortisone for burns
(12, 19, '2024-10-12', 30), -- Atorvastatin for cholesterol
(13, 49, '2024-10-13', 30), -- Clopidogrel for angina
(13, 22, '2024-10-13', 30), -- Metoprolol for angina
(14, 2, '2024-10-14', 20),  -- Ibuprofen for sprain
(15, 1, '2024-10-15', 20),  -- Paracetamol for hernia pain
(17, 15, '2024-10-17', 14), -- Omeprazole before CT
(18, 42, '2024-10-18', 30), -- Diazepam for seizures
(19, 32, '2024-10-19', 30), -- Vitamin C for immunity
(20, 34, '2024-10-20', 90), -- Folic acid for anemia
(21, 5, '2024-10-21', 14),  -- Amoxicillin for wound
(22, 15, '2024-10-22', 28), -- Omeprazole for PCOS
(23, 48, '2024-10-23', 30), -- Warfarin for AFib
(24, 37, '2024-10-24', 30), -- Diclofenac for arthritis
(25, 1, '2024-10-25', 20),  -- Paracetamol for gallstones
(26, 50, '2024-10-26', 30), -- Levothyroxine for thyroid
(27, 5, '2024-10-27', 10),  -- Amoxicillin for tonsillitis
(29, 17, '2024-10-29', 10), -- Metoclopramide for vomiting
(30, 40, '2024-10-30', 30), -- Fluoxetine for Parkinsons

-- November prescriptions
(31, 6, '2024-11-01', 5),   -- Azithromycin for bronchitis
(31, 1, '2024-11-01', 30),  -- Paracetamol for bronchitis
(32, 13, '2024-11-02', 14), -- Acyclovir for chickenpox
(33, 49, '2024-11-03', 30), -- Clopidogrel for CAD
(33, 23, '2024-11-03', 30), -- Enalapril for CAD
(34, 31, '2024-11-04', 90), -- Vitamin B for pregnancy
(35, 1, '2024-11-05', 30),  -- Paracetamol for fracture
(36, 10, '2024-11-06', 10), -- Cetirizine for allergy
(37, 1, '2024-11-07', 20),  -- Paracetamol post-surgery
(38, 15, '2024-11-08', 28), -- Omeprazole for liver
(40, 45, '2024-11-10', 30), -- Prednisolone for MS
(41, 5, '2024-11-11', 10),  -- Amoxicillin for ear infection
(42, 1, '2024-11-12', 60),  -- Paracetamol for cancer pain
(43, 24, '2024-11-13', 30), -- Furosemide for heart failure
(44, 38, '2024-11-14', 30), -- Meloxicam for back pain
(45, 7, '2024-11-15', 7),   -- Ciprofloxacin for pneumonia
(45, 1, '2024-11-15', 30),  -- Paracetamol for pneumonia
(47, 37, '2024-11-17', 30), -- Diclofenac for varicose veins
(48, 4, '2024-11-18', 5),   -- Morphine for acute abdomen
(49, 44, '2024-11-19', 1),  -- Clotrimazole for eczema
(50, 15, '2024-11-20', 28), -- Omeprazole for GERD
(51, 49, '2024-11-21', 30), -- Clopidogrel follow-up
(52, 25, '2024-11-22', 60), -- Metformin follow-up
(54, 5, '2024-11-24', 7),   -- Amoxicillin follow-up
(55, 21, '2024-11-25', 30), -- Amlodipine follow-up
(56, 2, '2024-11-26', 30),  -- Ibuprofen follow-up
(58, 15, '2024-11-28', 28), -- Omeprazole follow-up
(59, 33, '2024-11-29', 90), -- Calcium + D3 prenatal
(60, 28, '2024-11-30', 2),  -- Salbutamol follow-up

-- December prescriptions
(62, 19, '2024-12-01', 30), -- Atorvastatin follow-up
(63, 22, '2024-12-02', 30), -- Metoprolol stress test
(65, 1, '2024-12-04', 20),  -- Paracetamol pre-surgery
(67, 1, '2024-12-06', 20),  -- Paracetamol for imaging
(68, 42, '2024-12-07', 30), -- Diazepam follow-up
(70, 34, '2024-12-09', 90), -- Folic acid follow-up
(72, 15, '2024-12-11', 28), -- Omeprazole follow-up
(73, 48, '2024-12-12', 30), -- Warfarin follow-up
(74, 37, '2024-12-13', 30), -- Diclofenac follow-up
(74, 45, '2024-12-13', 15), -- Prednisolone for arthritis
(75, 1, '2024-12-14', 30),  -- Paracetamol pre-surgery
(76, 50, '2024-12-15', 30), -- Levothyroxine follow-up
(77, 5, '2024-12-16', 7),   -- Amoxicillin follow-up
(81, 7, '2024-12-01', 7),   -- Ciprofloxacin for UTI
(82, 9, '2024-12-02', 7),   -- Metronidazole for diarrhea
(83, 48, '2024-12-03', 30), -- Warfarin for pacemaker
(85, 2, '2024-12-05', 30),  -- Ibuprofen for shoulder
(87, 1, '2024-12-07', 20),  -- Paracetamol post-hemorrhoid surgery
(88, 15, '2024-12-08', 28), -- Omeprazole for celiac
(91, 10, '2024-12-11', 7),  -- Cetirizine for conjunctivitis
(93, 22, '2024-12-13', 30), -- Metoprolol pre-valve surgery
(94, 1, '2024-12-14', 30),  -- Paracetamol pre-hip surgery
(95, 14, '2024-12-15', 5);  -- Oseltamivir for COVID

-- ==========================================
-- 10. MEDICINE STOCK REMOVALS (from prescriptions)
-- ==========================================

-- Stock removals for prescriptions (linking to appointments)
INSERT INTO MedicineStockHistory (medicine_id, add_remove, amount, appointment_id, note) VALUES
(3, 0, 30, 1, 'Dispensed for appointment #1'),
(49, 0, 30, 1, 'Dispensed for appointment #1'),
(25, 0, 60, 2, 'Dispensed for appointment #2'),
(1, 0, 20, 3, 'Dispensed for appointment #3'),
(5, 0, 14, 3, 'Dispensed for appointment #3'),
(8, 0, 5, 4, 'Dispensed for appointment #4'),
(9, 0, 21, 4, 'Dispensed for appointment #4'),
(21, 0, 30, 5, 'Dispensed for appointment #5'),
(2, 0, 30, 6, 'Dispensed for appointment #6'),
(37, 0, 30, 7, 'Dispensed for appointment #7'),
(15, 0, 28, 8, 'Dispensed for appointment #8'),
(34, 0, 90, 9, 'Dispensed for appointment #9'),
(28, 0, 2, 10, 'Dispensed for appointment #10'),
(29, 0, 1, 10, 'Dispensed for appointment #10'),
(47, 0, 1, 11, 'Dispensed for appointment #11'),
(19, 0, 30, 12, 'Dispensed for appointment #12'),
(49, 0, 30, 13, 'Dispensed for appointment #13'),
(22, 0, 30, 13, 'Dispensed for appointment #13'),
(2, 0, 20, 14, 'Dispensed for appointment #14'),
(1, 0, 20, 15, 'Dispensed for appointment #15'),
(15, 0, 14, 17, 'Dispensed for appointment #17'),
(42, 0, 30, 18, 'Dispensed for appointment #18'),
(32, 0, 30, 19, 'Dispensed for appointment #19'),
(34, 0, 90, 20, 'Dispensed for appointment #20'),
(5, 0, 14, 21, 'Dispensed for appointment #21'),
(15, 0, 28, 22, 'Dispensed for appointment #22'),
(48, 0, 30, 23, 'Dispensed for appointment #23'),
(37, 0, 30, 24, 'Dispensed for appointment #24'),
(1, 0, 20, 25, 'Dispensed for appointment #25'),
(50, 0, 30, 26, 'Dispensed for appointment #26'),
(5, 0, 10, 27, 'Dispensed for appointment #27'),
(17, 0, 10, 29, 'Dispensed for appointment #29'),
(40, 0, 30, 30, 'Dispensed for appointment #30');

-- ==========================================
-- 11. PATIENT CORE MEDICAL INFORMATION
-- ==========================================

-- Add allergies and chronic conditions for some patients
INSERT INTO PatientCoreMedicalInformation (patient_id, information_type, note) VALUES
(1, 1, 'Penicillin allergy'),
(5, 1, 'Peanut allergy'),
(8, 3, 'Chronic hypertension'),
(8, 3, 'Type 2 diabetes'),
(13, 3, 'Coronary artery disease'),
(15, 1, 'Latex allergy'),
(19, 3, 'Parkinsons disease'),
(20, 1, 'Sulfa drug allergy'),
(24, 3, 'Osteoarthritis'),
(30, 3, 'Epilepsy'),
(33, 3, 'Atrial fibrillation'),
(38, 3, 'Hepatitis B'),
(39, 3, 'Chronic kidney disease'),
(42, 3, 'Lung cancer'),
(43, 3, 'Congestive heart failure'),
(45, 1, 'Shellfish allergy');

-- ==========================================
-- 12. PATIENT EMERGENCY CONTACTS
-- ==========================================

-- Add emergency contacts for patients 1-20
INSERT INTO PatientEmergencyContact (patient_id, contact_type, contact_information, relationship, last_updated) VALUES
(1, 'Primary', '0987654321 - Nguyễn Thị Mai', 'Wife', '2024-06-15'),
(2, 'Primary', '0987654322 - Trần Văn Cường', 'Husband', '2024-07-20'),
(3, 'Primary', '0987654323 - Lê Thị Lan', 'Wife', '2024-05-10'),
(4, 'Primary', '0987654324 - Phạm Văn Long', 'Father', '2024-08-12'),
(5, 'Primary', '0987654325 - Hoàng Thị Hoa', 'Sister', '2024-06-28'),
(6, 'Primary', '0987654326 - Vũ Văn Minh', 'Father', '2024-09-05'),
(7, 'Primary', '0987654327 - Đặng Thị Phương', 'Wife', '2024-07-15'),
(8, 'Primary', '0987654328 - Bùi Văn Tâm', 'Son', '2024-05-20'),
(9, 'Primary', '0987654329 - Đỗ Thị Kim', 'Wife', '2024-08-25'),
(10, 'Primary', '0987654330 - Ngô Văn Bảo', 'Husband', '2024-09-10'),
(11, 'Primary', '0987654331 - Võ Thị Xuân', 'Mother', '2024-06-05'),
(12, 'Primary', '0987654332 - Phan Văn Đức', 'Brother', '2024-07-18'),
(13, 'Primary', '0987654333 - Lý Thị Hằng', 'Wife', '2024-08-08'),
(14, 'Primary', '0987654334 - Mai Văn Tuấn', 'Father', '2024-09-20'),
(15, 'Primary', '0987654335 - Trương Thị Diệp', 'Wife', '2024-06-22'),
(16, 'Primary', '0987654336 - Lâm Văn Sơn', 'Husband', '2024-07-30'),
(17, 'Primary', '0987654337 - Hồ Thị Thanh', 'Sister', '2024-08-15'),
(18, 'Primary', '0987654338 - Đào Văn Huy', 'Father', '2024-09-28'),
(19, 'Primary', '0987654339 - Tô Thị Nga', 'Wife', '2024-06-18'),
(20, 'Primary', '0987654340 - Dương Văn Khang', 'Brother', '2024-07-25');

-- ==========================================
-- SAMPLE DATA SUMMARY
-- ==========================================
-- Departments: 10
-- Doctors: 30 (distributed across all departments)
-- Patients: 50 (diverse demographics and conditions)
-- Personal Information: 25 (representative sample)
-- Medicines: 50 (common medications)
-- Initial Stock: 50 entries (all medicines)
-- Appointments: 100 (last 3 months)
-- Prescriptions: 80+ (linked to appointments)
-- Stock Removals: 30+ (from prescriptions)
-- Medical Info: 16 (allergies and chronic conditions)
-- Emergency Contacts: 20 (for key patients)
-- ==========================================
