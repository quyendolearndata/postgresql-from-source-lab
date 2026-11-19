 

# Learning Progress — PostgreSQL Lab (Phiên bản Sinh viên Năm nhất)

> Mục đích: Lộ trình 2–3 năm đi **song song với các môn đại học**, giữ nguyên phương pháp **First Principles + Evidence-based** (chưa có kết quả/artifact thực tế thì chưa đánh dấu Done).
> Khác với bản gốc ([LEARNING-PROGRESS.md](LEARNING-PROGRESS.md)) dành cho người đã đi làm hoặc nắm sẵn C/OS/SQL, bản này bổ sung **Phase −1** và điều chỉnh thứ tự để không bị "ngợp" ngay từ bước đầu.

**Thời gian dự kiến:** 2–3 năm (tùy tốc độ học kỳ)
**Nguyên tắc:** Dùng thành thạo Postgres có sẵn rồi mới tự build; học tới đâu đối chiếu với môn học trên trường tới đó (Cấu trúc dữ liệu, Hệ điều hành, Cơ sở dữ liệu).

---

## Bản đồ tổng quan theo năm học

| Năm học         | Trọng tâm                                                                           | Phase tương ứng                                      | Môn đại học bổ trợ                                |
| ----------------- | ------------------------------------------------------------------------------------- | ------------------------------------------------------- | ------------------------------------------------------- |
| **Năm 1**  | Terminal, Git, SQL vững, đọc hiểu kiến trúc tổng quan, thử tự build Postgres | Phase −1, Phase 0, Phase 1                             | Nhập môn lập trình (C/Python), Công cụ phần mềm |
| **Năm 2**  | Đọc `EXPLAIN`, hiểu Index (B-Tree), Transaction, WAL, Buffer, MVCC/VACUUM        | Phase 2 *(trừ đọc sâu code C)*                    | Cấu trúc dữ liệu & Giải thuật, Hệ điều hành   |
| **Năm 3+** | Benchmark, tối ưu, debug lock, CDC, Backup/Restore, Replication, Pooling            | Phase 3 *(+ đọc source nếu thích hướng engine)* | Cơ sở dữ liệu, Hệ phân tán, Đồ án             |

---

## Checklist chi tiết

Legend: `[ ]` chưa · `[~]` đang làm · `[x]` xong (có bằng chứng: lệnh, screenshot, file SQL, log hoặc ghi chú đối chiếu).

### Phase −1 — Nền tảng (Năm 1)

*Làm trên PostgreSQL cài sẵn (Homebrew trên macOS, `apt` trên Linux hoặc Docker) để tập trung vào SQL và thao tác công cụ.*

| #    | Mốc                                                                                                                                    | Status | Evidence (điền khi xong)                                                                                                                                                     | Ngày hoàn thành |
| ---- | --------------------------------------------------------------------------------------------------------------------------------------- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------ |
| -1.1 | Thành thạo Terminal & Git cơ bản: `cd`, `ls`, `grep`/`rg`, biến môi trường `PATH`, `git clone/commit/branch`        | [ ]    | Ghi chú hoặc link bài tập hoàn thành (ví dụ MIT Missing Semester)                                                                                                      |                    |
| -1.2 | Cài Postgres bằng công cụ có sẵn, tạo database, kết nối bằng `psql`                                                         | [x]    | Lệnh chạy `psql` và kết quả `SELECT version();`<br />brew install postgresql@18;<br />psql postgres<br />`PostgreSQL 18.7 (Homebrew) on aarch64-apple-darwin27.2.0` | 2026-11-18         |
| -1.3 | Viết SQL vững: `CREATE TABLE`, `INSERT/UPDATE/DELETE`, `JOIN`, `GROUP BY`, `HAVING`, subquery/CTE                           | [ ]    | File `.sql` tự viết + kết quả truy vấn mẫu (2–3 bảng liên kết)                                                                                                     |                    |
| -1.4 | Hiểu Transaction cơ bản: `BEGIN`, `COMMIT`, `ROLLBACK` và thử mở 2 cửa sổ `psql` để thấy lock/isolation              | [ ]    | Kịch bản 2 terminal và kết quả quan sát được                                                                                                                          |                    |
| -1.5 | Đọc hiểu C cơ bản (không cần viết giỏi): biến, hàm, `struct`, pointer cơ bản để sau này đọc code không bị choáng | [ ]    | Ghi chú ngắn hoặc bài tập C nhập môn đã chạy                                                                                                                         |                    |



| col1 | col2 | col3 |
| ---- | ---- | ---- |
|      |      |      |
|      |      |      |

### Phase 0 — Lab & Định hướng (Năm 1)

| #   | Mốc                                                                                                                                       | Status | Evidence                                                                   |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------ | ------ | -------------------------------------------------------------------------- |
| 0.1 | Tạo repo lab trên GitHub; hiểu repo lab tách biệt với thư mục `postgres-src/` (dùng `.gitignore`)                             | [ ]    | Link repo + file `.gitignore`                                            |
| 0.2 | Đọc sơ đồ C4 ([docs/c4/](c4/)) ở mức khái niệm: phân biệt Client (`psql`/`libpq`) với Server (`postmaster` + `backend`) | [ ]    | Tóm tắt 5–10 dòng bằng lời của bạn về đường đi một kết nối |

### Phase 1 — Tự build & chạy từ source (Cuối Năm 1 / Hè Năm 1)

| #   | Mốc                                                                                                                                             | Status | Evidence                                                   |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------ | ------ | ---------------------------------------------------------- |
| 1.1 | Clone `postgres-src`, checkout một **tag release ổn định** (xem bằng `git tag -l 'REL_*'`)                                        | [ ]    | Tên tag và `git rev-parse HEAD`                        |
| 1.2 | Cài các thư viện phụ thuộc (compiler, `meson`/`ninja` hoặc `make`, `icu`, `readline`, `zlib`…), chọn thư mục prefix local | [ ]    | Danh sách lệnh cài dependencies + lệnh setup/configure |
| 1.3 | Build & `install` vào prefix local (bật debug symbols, **không bật `cassert`**)                                                    | [ ]    | `pg_config --bindir` trỏ đúng prefix local            |
| 1.4 | Chạy `initdb`, start server tự build, kết nối bằng `psql` và chạy `SELECT version();`                                               | [ ]    | Lệnh start/kết nối và output                           |

### Phase 2 — Quan sát hành vi & liên hệ kiến thức (Năm 2)

*Gắn chặt với môn **Cấu trúc dữ liệu** (B-Tree, Hash) và **Hệ điều hành** (Process, RAM, Disk I/O).*

| #   | Mốc                                                                                                                                                    | Status | Evidence                                                                                          |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ | ------------------------------------------------------------------------------------------------- |
| 2.1 | Tạo bảng có ~100k–1M dòng; chạy `SELECT` và ghi lại `EXPLAIN (ANALYZE, BUFFERS)`                                                            | [ ]    | File SQL + output plan; giải thích ý nghĩa `actual time` và `Buffers`                    |
| 2.2 | Tạo B-Tree index; so sánh `Seq Scan` và `Index Scan` trên cùng bảng với các điều kiện lọc khác nhau                                    | [ ]    | 2 output `EXPLAIN`; giải thích khi nào Postgres chọn quét toàn bảng thay vì dùng index |
| 2.3 | Quan sát Transaction, Buffer & WAL: chạy một batch `INSERT`/`UPDATE`, đối chiếu thay đổi trong `pg_wal/` và `shared_buffers`           | [ ]    | Lệnh/truy vấn kiểm tra + giải thích vì sao ghi WAL trước khi ghi data file                |
| 2.4 | MVCC & `VACUUM`: `UPDATE`/`DELETE` hàng loạt, xem `n_dead_tup`, kích thước bảng trước và sau `VACUUM`                                | [ ]    | Số liệu từ `pg_stat_user_tables` và `pg_relation_size`                                    |
| 2.5 | *(Tùy chọn)* Mở `postgres-src/src/backend/` lần theo đường đi hàm chính từ `exec_simple_query` → parser → planner → `ExecutorRun` | [ ]    | Danh sách file/hàm đã đọc (giới hạn 1–2 buổi, không sa đà)                           |

### Phase 3 — Data Platform thực chiến (Năm 3+)

*Làm khi đã hiểu nền tảng hoặc khi học môn Cơ sở dữ liệu / Hệ phân tán.*

| #   | Mốc                                                                                                                                                              | Status | Evidence                                                                  |
| --- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ | ------------------------------------------------------------------------- |
| 3.1 | Thiết kế schema có khóa chính/khóa ngoại, xác định rõ grain và transaction boundary cho một bài toán nhỏ                                          | [ ]    | File DDL + kịch bản test đúng/sai                                     |
| 3.2 | Đo tải bằng `pgbench` để có baseline trước khi tối ưu                                                                                                 | [ ]    | Lệnh `pgbench`, TPS và latency trung bình                            |
| 3.3 | Điều tra lỗi: dùng `pg_stat_statements`, `pg_stat_activity`, `pg_locks` bắt tình huống `ALTER TABLE` bị treo bởi session `idle in transaction` | [ ]    | Truy vấn bắt lock và giải thích nguyên nhân                        |
| 3.4 | Thử thay đổi index hoặc cấu hình (`work_mem`, `shared_buffers`), đo lại bằng `pgbench` và giải thích trade-off                                  | [ ]    | Bảng so sánh trước/sau                                                |
| 3.5 | Ingest theo lô (`COPY` vs `INSERT`) và dựng thử **CDC (Logical Replication)**; thử tắt bên nhận để thấy `pg_wal/` phình to                | [ ]    | Lệnh tạo publication/subscription + dung lượng `pg_wal/` khi nghẽn |
| 3.6 | Tạo backup (`pg_basebackup` hoặc `pg_dump`) và **restore sang một cluster mới**, kiểm tra lại dữ liệu                                          | [ ]    | Lệnh restore + truy vấn xác nhận dữ liệu khớp                      |
| 3.7 | Dựng 1 Primary + 1 Standby (Streaming Replication), thử ngắt kết nối và quan sát replication lag                                                           | [ ]    | Trạng thái `pg_stat_replication` trước/sau ngắt kết nối          |
| 3.8 | Đặt **PgBouncer** (transaction pooling) trước Postgres lab, so sánh với kết nối trực tiếp khi mở nhiều connection                               | [ ]    | Kết quả `pgbench` hai cấu hình                                      |

---

## Tài liệu gợi ý theo giai đoạn

* **Phase −1:**
  * *The Missing Semester of Your CS Education* (MIT) — học Terminal, Shell, Git bài bản.
  * *PostgreSQL Tutorial* (tài liệu chính thức tại `postgresql.org/docs/current/tutorial.html`) — học SQL chuẩn.
* **Phase 2:**
  * Khóa **CMU 15-445 (Database Systems — Andy Pavlo)** trên YouTube — giải thích cực kỳ dễ hiểu về Storage, Buffer Pool, B-Tree, Query Execution, Concurrency.
  * Sách *Operating Systems: Three Easy Pieces (OSTEP)* (miễn phí online) — nắm chắc Process, Memory, File I/O.
  * Sách *The Internals of PostgreSQL* (`interdb.jp/pg/`) — cầu nối hoàn hảo giữa lý thuyết DB và kiến trúc Postgres.

---

## Bảng thuật ngữ tra nhanh (Glossary)

| Thuật ngữ                     | Giải thích ngắn gọn                                                                                                                                |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Postmaster**            | Tiến trình cha của PostgreSQL: lắng nghe kết nối, xác thực và tạo (`fork`) tiến trình Backend phục vụ từng client.                    |
| **Backend Process**       | Tiến trình riêng được tạo ra cho **mỗi kết nối** client để chạy SQL (1 connection = 1 OS process).                                  |
| **PID**                   | Process ID — mã số định danh của một tiến trình trong hệ điều hành.                                                                       |
| **PGDATA**                | Thư mục trên đĩa cứng chứa toàn bộ dữ liệu của một cluster PostgreSQL (bảng, index, cấu hình, WAL).                                    |
| **Page (Block)**          | Đơn vị lưu trữ cơ bản của Postgres (mặc định 8 KB). Dữ liệu được đọc/ghi theo từng Page chứ không từng dòng lẻ.                |
| **Tuple**                 | Một dòng dữ liệu (row) hoặc một phiên bản của dòng dữ liệu lưu bên trong Page.                                                           |
| **Shared Buffers**        | Vùng RAM dùng chung giữa các tiến trình Postgres để cache các Page vừa đọc/ghi, giảm truy cập đĩa cứng.                               |
| **WAL (Write-Ahead Log)** | Nhật ký ghi mọi thay đổi dữ liệu xuống đĩa **trước** khi sửa file dữ liệu chính, giúp khôi phục an toàn nếu mất điện.    |
| **MVCC**                  | *Multi-Version Concurrency Control* — giữ nhiều phiên bản của một dòng để người đọc và người ghi không chặn nhau.                 |
| **Dead Tuple & Bloat**    | Khi `UPDATE`/`DELETE`, dòng cũ chưa biến mất ngay mà thành "xác" (dead tuple); tích tụ nhiều gây phình dung lượng bảng (bloat).    |
| **VACUUM**                | Cơ chế dọn dẹp các dead tuple để tái sử dụng chỗ trống và tránh cạn Transaction ID.                                                     |
| **Replication Slot**      | Cơ chế đánh dấu vị trí đọc WAL cho replica/CDC; nếu bên nhận chết mà không xóa slot, Primary sẽ giữ WAL mãi dẫn đến đầy đĩa. |
| **Grain**                 | Độ chi tiết của một dòng trong bảng (ví dụ: 1 dòng = 1 đơn hàng, hay 1 dòng = 1 sản phẩm trong đơn hàng).                           |
