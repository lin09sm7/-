const express = require("express");
const cors = require("cors");
const Database = require("better-sqlite3");
const path = require("path");

const app = express();
const PORT = 3001;

// Middleware
app.use(cors());
app.use(express.json());

// Database
const dbPath = path.join(__dirname, "..", "database", "hospital.db");
const db = new Database(dbPath);
db.pragma("journal_mode = WAL");
db.pragma("foreign_keys = ON");

// ============================
// Cities & Districts
// ============================

// GET /api/cities
app.get("/api/cities", (req, res) => {
  const cities = db.prepare("SELECT id, name FROM cities ORDER BY id").all();
  res.json(cities);
});

// GET /api/cities/:cityId/districts
app.get("/api/cities/:cityId/districts", (req, res) => {
  const districts = db
    .prepare("SELECT id, name FROM districts WHERE city_id = ? ORDER BY id")
    .all(req.params.cityId);
  res.json(districts);
});

// ============================
// Departments & Doctors
// ============================

// GET /api/departments
app.get("/api/departments", (req, res) => {
  const departments = db
    .prepare("SELECT id, code, name FROM departments ORDER BY id")
    .all();
  res.json(departments);
});

// GET /api/departments/:deptId/doctors
app.get("/api/departments/:deptId/doctors", (req, res) => {
  const doctors = db
    .prepare("SELECT id, name FROM doctors WHERE department_id = ? ORDER BY id")
    .all(req.params.deptId);
  res.json(doctors);
});

// ============================
// Patients
// ============================

// GET /api/patients?medical_no=xxx
app.get("/api/patients", (req, res) => {
  const { medical_no } = req.query;
  if (medical_no) {
    const patient = db
      .prepare("SELECT * FROM patients WHERE medical_no = ?")
      .get(medical_no);
    return res.json(patient || null);
  }
  const patients = db.prepare("SELECT * FROM patients ORDER BY id DESC").all();
  res.json(patients);
});

// POST /api/patients
app.post("/api/patients", (req, res) => {
  const { medical_no, name, gender, birthday, age, phone, city_id, district_id, address } = req.body;
  try {
    const result = db
      .prepare(
        `INSERT INTO patients (medical_no, name, gender, birthday, age, phone, city_id, district_id, address)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`
      )
      .run(medical_no, name, gender || null, birthday || null, age || null, phone || null, city_id || null, district_id || null, address || null);
    res.json({ id: result.lastInsertRowid });
  } catch (err) {
    if (err.message.includes("UNIQUE")) {
      return res.status(409).json({ error: "病歷號碼已存在" });
    }
    res.status(500).json({ error: err.message });
  }
});

// PUT /api/patients/:id
app.put("/api/patients/:id", (req, res) => {
  const { name, gender, birthday, age, phone, city_id, district_id, address } = req.body;
  try {
    db.prepare(
      `UPDATE patients SET name=?, gender=?, birthday=?, age=?, phone=?, city_id=?, district_id=?, address=?, updated_at=datetime('now','localtime')
       WHERE id=?`
    ).run(name, gender || null, birthday || null, age || null, phone || null, city_id || null, district_id || null, address || null, req.params.id);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ============================
// Registrations
// ============================

// POST /api/registrations
app.post("/api/registrations", (req, res) => {
  const { patient_id, visit_type, reg_date, department_id, doctor_id } = req.body;

  // Auto-generate reg_number: count per department per date + 1
  const count = db
    .prepare("SELECT COUNT(*) as c FROM registrations WHERE reg_date = ? AND department_id = ?")
    .get(reg_date, department_id);
  const reg_number = String((count?.c || 0) + 1).padStart(2, "0");

  try {
    const result = db
      .prepare(
        `INSERT INTO registrations (reg_number, patient_id, visit_type, reg_date, department_id, doctor_id)
         VALUES (?, ?, ?, ?, ?, ?)`
      )
      .run(reg_number, patient_id, visit_type, reg_date, department_id, doctor_id);
    const dept = db.prepare("SELECT name FROM departments WHERE id = ?").get(department_id);
    res.json({ id: result.lastInsertRowid, reg_number, department_name: dept?.name || "" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET /api/registrations
app.get("/api/registrations", (req, res) => {
  const rows = db
    .prepare(
      `SELECT r.*, p.name as patient_name, p.medical_no, dep.name as dept_name, doc.name as doctor_name
       FROM registrations r
       JOIN patients p ON r.patient_id = p.id
       JOIN departments dep ON r.department_id = dep.id
       JOIN doctors doc ON r.doctor_id = doc.id
       ORDER BY r.created_at DESC`
    )
    .all();
  res.json(rows);
});

// ============================
// Start
// ============================
app.listen(PORT, () => {
  console.log(`Backend running at http://localhost:${PORT}`);
});
