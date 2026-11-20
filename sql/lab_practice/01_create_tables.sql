CREATE TABLE sinh_vien (
    id SERIAL PRIMARY KEY,
    ho_ten VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE khoa_hoc (
    id SERIAL PRIMARY KEY,
    ten_khoa_hoc VARCHAR(100) NOT NULL,
    hoc_phi NUMERIC(10, 2) DEFAULT 0
);

CREATE TABLE dang_ky (
    sinh_vien_id INT REFERENCES sinh_vien(id) ON DELETE CASCADE,
    khoa_hoc_id INT REFERENCES khoa_hoc(id) ON DELETE CASCADE,
    ngay_dang_ky DATE DEFAULT CURRENT_DATE,
    diem_so NUMERIC(4, 2) CONSTRAINT chk_diem_0_10 CHECK (diem_so >= 0 AND diem_so <= 10),
    PRIMARY KEY (sinh_vien_id, khoa_hoc_id)
);