-- ==========================================
-- Hospital Management System Database
-- Oracle SQL
-- ==========================================

-- 1. Departments (الأقسام)
CREATE TABLE Departments (
    DepartmentID NUMBER PRIMARY KEY,
    DepartmentName VARCHAR2(20) UNIQUE NOT NULL,
    OfficeNumber VARCHAR2(13)
);

-- 2. Patients (المرضى)
CREATE TABLE Patients (
    PatientID NUMBER PRIMARY KEY,
    FirstName VARCHAR2(20) NOT NULL,
    LastName VARCHAR2(20) NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M','F')),
    BirthDate DATE
);

-- 3. Doctors (الأطباء)
CREATE TABLE Doctors (
    DoctorID NUMBER PRIMARY KEY,
    FirstName VARCHAR2(30) NOT NULL,
    LastName VARCHAR2(30) NOT NULL,
    Specialization VARCHAR2(50) NOT NULL,
    PhoneNumber VARCHAR2(13) UNIQUE NOT NULL,
    Email VARCHAR2(100) UNIQUE NOT NULL,
    DepartmentID NUMBER NOT NULL,
    CONSTRAINT fk_doctors_department FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- 4. Staff (الموظفون)
CREATE TABLE Staff (
    StaffID NUMBER PRIMARY KEY,
    FirstName VARCHAR2(30) NOT NULL,
    LastName VARCHAR2(30) NOT NULL,
    Role VARCHAR2(50) NOT NULL,
    PhoneNumber VARCHAR2(13) UNIQUE NOT NULL,
    Email VARCHAR2(100) UNIQUE NOT NULL,
    DepartmentID NUMBER NOT NULL,
    CONSTRAINT fk_staff_department FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- 5. Appointment (المواعيد)
CREATE TABLE Appointment (
    AppointmentID NUMBER PRIMARY KEY,
    AppointmentDate DATE NOT NULL,
    Status VARCHAR2(20) NOT NULL,
    DoctorID NUMBER NOT NULL,
    PatientID NUMBER NOT NULL,
    CONSTRAINT fk_appointment_doctor FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    CONSTRAINT fk_appointment_patient FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- 6. MedicalRecords (السجلات الطبية)
CREATE TABLE MedicalRecords (
    RecordID NUMBER PRIMARY KEY,
    VisitDate DATE NOT NULL,
    Treatment VARCHAR2(100) NOT NULL,
    Diagnosis VARCHAR2(100) NOT NULL,
    Notes VARCHAR2(100),
    PatientID NUMBER NOT NULL,
    DoctorID NUMBER NOT NULL,
    AppointmentID NUMBER UNIQUE,
    CONSTRAINT fk_patient_medical_record FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    CONSTRAINT fk_doctor_medicalrecord FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    CONSTRAINT fk_appointment_medicalrecord FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID)
);

-- 7. Medications (الأدوية)
CREATE TABLE Medications (
    MedicationID NUMBER PRIMARY KEY,
    MedicationName VARCHAR2(100) UNIQUE NOT NULL,
    Description VARCHAR2(100),
    UnitPrice NUMBER(10,2)
);

-- 8. Prescriptions (الوصفات الطبية)
CREATE TABLE Prescriptions (
    PrescriptionID NUMBER PRIMARY KEY,
    RecordID NUMBER NOT NULL,
    CONSTRAINT fk_prescription_record FOREIGN KEY (RecordID) REFERENCES MedicalRecords(RecordID)
);

-- 9. PrescriptionDetails (تفاصيل الوصفة)
CREATE TABLE PrescriptionDetails (
    PrescriptionID NUMBER NOT NULL,
    MedicationID NUMBER NOT NULL,
    Quantity NUMBER NOT NULL,
    Instructions VARCHAR2(100),
    PRIMARY KEY (PrescriptionID, MedicationID),
    CONSTRAINT fk_pd_prescription FOREIGN KEY (PrescriptionID) REFERENCES Prescriptions(PrescriptionID),
    CONSTRAINT fk_pd_medication FOREIGN KEY (MedicationID) REFERENCES Medications(MedicationID)
);

-- 10. Inventory (المخزون)
CREATE TABLE Inventory (
    InventoryID NUMBER PRIMARY KEY,
    Quantity NUMBER(10) NOT NULL,
    ExpiryDate DATE,
    Supplier VARCHAR2(50),
    MedicationID NUMBER NOT NULL,
    CONSTRAINT fk_inventory_medication FOREIGN KEY (MedicationID) REFERENCES Medications(MedicationID)
);

-- 11. Services (الخدمات)
CREATE TABLE Services (
    ServiceID NUMBER PRIMARY KEY,
    ServiceName VARCHAR2(40) UNIQUE NOT NULL,
    Description VARCHAR2(100) NOT NULL,
    Price NUMBER(10,2)
);

-- 12. Bills (الفواتير)
CREATE TABLE Bills (
    BillID NUMBER PRIMARY KEY,
    BillDate DATE,
    TotalAmount NUMBER(10,2) NOT NULL,
    PaymentStatus VARCHAR2(30),
    AppointmentID NUMBER,
    PatientID NUMBER NOT NULL,
    CONSTRAINT fk_bill_appointment FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID),
    CONSTRAINT fk_bill_patient FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- 13. BillDetails (تفاصيل الفاتورة)
CREATE TABLE BillDetails (
    BillDetailID NUMBER PRIMARY KEY,
    BillID NUMBER NOT NULL,
    Quantity NUMBER(10) NOT NULL,
    Subtotal NUMBER(10,2),
    ServiceID NUMBER NOT NULL,
    CONSTRAINT fk_billdetail_service FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID),
    CONSTRAINT fk_billdetail_bill FOREIGN KEY (BillID) REFERENCES Bills(BillID)
);

-- 14. Rooms (الغرف)
CREATE TABLE Rooms (
    RoomID VARCHAR2(20) PRIMARY KEY,
    RoomNumber NUMBER UNIQUE NOT NULL,
    RoomType VARCHAR2(20) NOT NULL,
    Status VARCHAR2(20) NOT NULL,
    DepartmentID NUMBER NOT NULL,
    CONSTRAINT fk_dep_room FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- 15. PatientAdmissions (حالات التنويم)
CREATE TABLE PatientAdmissions (
    AdmissionID NUMBER PRIMARY KEY,
    PatientID NUMBER NOT NULL,
    RoomID VARCHAR2(20) NOT NULL,
    AdmissionDate DATE NOT NULL,
    DischargeDate DATE,
    CONSTRAINT fk_pat_admiss FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    CONSTRAINT fk_admiss_room FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
);

-- 16. LabTests (الفحوصات المخبرية)
CREATE TABLE LabTests (
    TestID NUMBER PRIMARY KEY,
    TestName VARCHAR2(20) UNIQUE NOT NULL,
    Description VARCHAR2(100),
    Price NUMBER(10,2)
);

-- 17. TestResult (نتائج الفحوصات)
CREATE TABLE TestResult (
    ResultID NUMBER PRIMARY KEY,
    PatientID NUMBER NOT NULL,
    TestID NUMBER NOT NULL,
    RecordID NUMBER,
    TestDate DATE NOT NULL,
    Result VARCHAR2(100) NOT NULL,
    Notes VARCHAR2(100),
    CONSTRAINT fk_result_patient FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    CONSTRAINT fk_result_test FOREIGN KEY (TestID) REFERENCES LabTests(TestID),
    CONSTRAINT fk_result_record FOREIGN KEY (RecordID) REFERENCES MedicalRecords(RecordID)
);
