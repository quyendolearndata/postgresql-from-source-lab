-- 1. Thêm 4 sinh viên (không cần nhập id vì id là SERIAL tự tăng 1, 2, 3, 4)
INSERT INTO sinh_vien (ho_ten, email) VALUES
    ('Nguyen Van A', 'an@example.com'),
    ('Tran Thi Binh', 'binh@example.com'),
    ('Le Van Cuong', 'cuong@example.com'),
    ('Pham Thi Dung', 'dung@example.com');

-- 2. Thêm 3 khóa học (id tự tăng 1, 2, 3)
INSERT INTO khoa_hoc (ten_khoa_hoc, hoc_phi) VALUES
    ('SQL Co Ban', 1500000.00),
    ('PostgreSQL Internals', 3200000.00),
    ('Git & Terminal', 0.00);
    
-- 3. Thêm 5 lượt đăng ký (bỏ qua ngay_dang_ky để dùng DEFAULT CURRENT_DATE)
-- Lưu ý: sinh viên 4 chưa đăng ký khóa nào, và 1 lượt đăng ký chưa có điểm (NULL)
INSERT INTO dang_ky (sinh_vien_id, khoa_hoc_id, diem_so) VALUES
    (1, 1, 8.50),
    (1, 2, 9.00),
    (2, 1, 7.75),
    (2, 3, 8.00),
    (3, 2, NULL);
    