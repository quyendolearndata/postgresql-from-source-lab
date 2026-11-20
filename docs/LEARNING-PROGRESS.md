# Learning Progress — PostgreSQL from Source Lab

> Mục đích: một nơi duy nhất để biết **đang ở đâu**, **đã có bằng chứng gì**, **bước tiếp theo là gì**.  
> Cập nhật khi hoàn thành một mốc (đổi status + ghi Evidence + ngày).  
> Phương pháp: First Principles + Evidence-based — chưa thấy artifact thì chưa đánh dấu Done.

**Cập nhật lộ trình:** 2026-11-16 (tinh chỉnh trọng tâm cho Data Platform Engineer)  
**Mục tiêu 6–12 tháng:** Tự build và chạy PostgreSQL; đọc source theo hành vi quan sát được; dùng hiểu biết engine để thiết kế và vận hành DE platform.  
**Nguyên tắc:** Build sớm, mỗi chủ đề có SQL/`EXPLAIN`/log để đối chiếu; không đặt tỷ lệ thời gian engine/platform cố định.

---

## Bạn đang ở đâu (tóm tắt)

| Trục | Vị trí hiện tại | Status |
|------|-----------------|--------|
| **Engine track** | Đã clone source + quan sát cấu trúc/C4; **chưa có bằng chứng** configure/build/run | **Phase 0 → Phase 1** |
| **Platform track** | Chưa có instance lab để đo và đối chiếu `EXPLAIN` / schema | **Bắt đầu sau khi chạy server** |
| **Git / lab repo** | Lab repo ignore upstream; C4 đã commit trên nhánh docs; progress chưa commit | **Cần lưu thay đổi lộ trình** |

**Một câu:** Bạn có *bản đồ kiến trúc + source trên đĩa*; mốc tiếp theo là *PostgreSQL tự biên dịch chạy được một câu SQL*.

---

## Lộ trình thực hành — checklist

Legend: `[ ]` chưa · `[~]` đang / một phần · `[x]` xong (có bằng chứng). Chỉ đánh dấu xong khi có lệnh, kết quả hoặc artifact đối chiếu được.

### Phase 0 — Lab & định hướng

| # | Mốc | Status | Evidence (điền khi xong) |
|---|-----|--------|---------------------------|
| 0.1 | Khởi tạo repo lab trên GitHub | [x] | Repo `postgresql-from-source-lab`, branch `main` |
| 0.2 | Hiểu lab vs upstream (`postgres-src` nested `.git`) | [x] | Warning embedded repo; chọn ignore `postgres-src/` (hướng A) |
| 0.3 | `.gitignore` có căn cứ (upstream riêng) | [x] | `.gitignore` chứa `postgres-src/` (và tùy chọn `.vscode/`, `docs/superpowers/`) |
| 0.4 | Bản đồ kiến trúc C4 + export PNG | [x] | `docs/c4/*.puml` + `docs/c4/export/*.png` (đã sửa postmaster vs backend) |
| 0.5 | Query Lab canvas / simulation (Cursor) | [~] | Canvas ngoài git; dùng khi học query path — không bắt buộc commit |
| 0.6 | File tracking lộ trình này | [x] | `docs/LEARNING-PROGRESS.md` |

### Phase 1 — Build & chạy từ source  ← **BẠN Ở ĐÂY**

| # | Mốc | Status | Evidence |
|---|-----|--------|----------|
| 1.1 | Clone PostgreSQL source; ghi commit đang học để tránh lệch source với ghi chú | [x] | Clone và commit đã kiểm tra; xem “Ghi chú mốc 1.1” bên dưới |
| 1.2 | Đọc hướng dẫn build; chọn Meson hoặc configure/make, prefix local; **chọn tag release ổn định** (`git tag -l 'REL_*'`) thay vì `master`; bật debug symbols, **không bật `cassert`** (tránh sai lệch số đo 3.2) | [ ] | Tag release, đường dẫn prefix và lệnh setup đã chọn |
| 1.3 | Configure/setup, build, install vào prefix local | [ ] | Lệnh build thành công; `pg_config --bindir` trỏ đúng prefix lab |
| 1.4 | `initdb`, start server, kết nối bằng `psql`, chạy một câu SQL | [ ] | Lệnh start/kết nối, `SELECT version()` và kết quả trên instance tự build |
| 1.5 | Viết ngắn vai trò `src/backend`, `src/bin`, `src/include`, `src/interfaces` | [~] | Đã có C2/C3; còn thiếu ghi chú bằng lời của bạn. Không chặn mốc 1.2–1.4 |

#### Ghi chú mốc 1.1 — Source trên máy

- `postgres-src/` là một Git clone **riêng** của PostgreSQL; `origin` là `https://github.com/postgres/postgres.git`, nhánh đang checkout là `master`.
- Commit quan sát được: `60826a352d497b15a30de29b7796d0c2d097a0e3` (ngày commit 2026-07-31). Đây là **SHA đã ghi nhận**, không phải release/tag được cố định; kiểm tra lại HEAD trước khi dùng ghi chú hoặc kết quả build về sau.
- Source có `src/backend/`, `src/bin/`, `src/include/`, `src/interfaces/`. Mốc này chỉ xác nhận source hiện diện, **chưa** ghi nhận vai trò chi tiết của từng thư mục (mốc 1.5).
- Repo lab ignore `postgres-src/`, nên commit/push tài liệu lab không tự mang theo mã nguồn upstream. Clone tương đương cần lấy từ remote trên rồi checkout đúng SHA; không suy đoán lệnh clone ban đầu đã dùng.
- `postgres-src/README.md` giới thiệu source distribution và dẫn tới [hướng dẫn build cho nhánh devel](https://www.postgresql.org/docs/devel/installation.html). Chưa có bằng chứng configure, build, install hoặc chạy server; các việc đó thuộc mốc 1.2–1.4.

### Phase 2 — Quan sát trước, trace source sau

| # | Mốc | Status | Evidence |
|---|-----|--------|----------|
| 2.1 | Tạo bảng nhỏ; chạy `SELECT` và `INSERT`; lưu kết quả và `EXPLAIN (ANALYZE, BUFFERS)` phù hợp | [ ] | SQL, plan thật, giả thuyết ban đầu |
| 2.2 | Trace một Simple Query từ `tcop` (`exec_simple_query`) qua parser, rewrite, planner đến `ExecutorRun` — **giới hạn 1–2 buổi**, chỉ nắm luồng chính, không đọc sâu từng module C | [ ] | File/hàm chính đã mở, đường đi đối chiếu với truy vấn 2.1 |
| 2.3 | So sánh seq scan và index scan trên dữ liệu có kích thước phù hợp | [ ] | SQL, plan, buffers; ghi khi nào planner chọn mỗi cách |
| 2.4 | Quan sát transaction và một thao tác ghi; lần theo access/storage, buffer, WAL theo câu hỏi cụ thể | [ ] | Kết quả quan sát + file/hàm liên quan; không cần đọc hết từng module |
| 2.5 | MVCC & `VACUUM`: tạo dead tuple bằng `UPDATE`/`DELETE`, quan sát `n_dead_tup`, `autovacuum`, bloat và `age(datfrozenxid)` | [ ] | Số liệu trước/sau `VACUUM`, kích thước bảng/index |

### Phase 3 — DE platform dựa trên bằng chứng

| # | Mốc | Status | Evidence |
|---|-----|--------|----------|
| 3.1 | Thiết kế schema, constraints và transaction boundary cho workload nhỏ, xác định grain | [ ] | DDL, tình huống đúng/sai có thể chạy lại |
| 3.2 | Đo workload bằng pgbench hoặc script nhỏ; xác định baseline trước tối ưu | [ ] | Cấu hình, số liệu, môi trường đo |
| 3.3 | Điều tra sự cố bằng **`pg_stat_statements`, `pg_stat_activity`, `pg_locks`**, plan và log (debugger gắn backend chỉ là tùy chọn). Tình huống mẫu: `ALTER TABLE` bị treo do session `idle in transaction` | [ ] | Output các view/PID/plan/log và nguyên nhân gốc rễ |
| 3.4 | Thử một thay đổi index/schema/config có căn cứ; đo lại và giải thích trade-off | [ ] | So sánh trước/sau trên cùng workload |
| 3.5 | Đối chiếu tài liệu `/postgres` với hành vi của instance lab khi chủ đề liên quan | [ ] | Sách nói X; máy quan sát Y; giải thích khác biệt |
| 3.6 | Ingest dữ liệu theo lô có thể chạy lại (**so sánh `COPY` với `INSERT`**); thử CDC bằng logical replication và **thử tắt subscriber để quan sát replication slot giữ WAL làm `pg_wal/` phình to** | [ ] | Dữ liệu sau chạy lại không trùng; INSERT/UPDATE/DELETE đến đích; ghi điểm bắt đầu, cách nhận biết lag và dung lượng `pg_wal/` khi slot bị nghẽn |
| 3.7 | Tạo backup và **restore vào cluster riêng**, kiểm tra tính đúng đắn của dữ liệu sau khôi phục | [ ] | Lệnh backup/restore, vị trí dữ liệu, truy vấn kiểm chứng; phân biệt đã tạo backup với đã thử khôi phục |
| 3.8 | Dựng primary + standby trong lab; quan sát streaming replication, độ trễ và hành vi khi ngắt kết nối | [ ] | Truy vấn/trạng thái ở hai bên trước và sau gián đoạn; ghi giới hạn của bản sao và điều kiện failover an toàn |
| 3.9 | Đặt PgBouncer (transaction pooling) trước instance lab, so sánh với kết nối trực tiếp khi tải nhiều connection | [ ] | Kết quả `pgbench` hai cấu hình, giải thích theo process model ở C2 |
| 3.10 | *(Tùy chọn)* Partition bảng event theo thời gian, xóa dữ liệu cũ bằng `DETACH`/`DROP` partition | [ ] | DDL, plan có partition pruning, so sánh với `DELETE` |

---

## Quyết định đã chốt (để khỏi quay vòng)

| Quyết định | Lựa chọn | Vì sao (ngắn) |
|------------|----------|----------------|
| `postgres-src` trong Git lab | **Ignore** (không submodule, không gitlink) | Lab = sổ tay; upstream clone riêng |
| Thứ tự học | **Build và chạy sớm; đọc source song song thực nghiệm** | Không biến ghi chú thư mục thành điều kiện chặn; dùng hành vi thật để đặt câu hỏi |
| C4 boundary | Cluster = **server runtime**; libpq ở client | Đúng process model |
| Export diagram | Chỉ **PNG** | Đủ xem trong lab |
| Mốc source | **Ghi commit đang học; chọn release/tag ổn định khi bắt đầu build** | Tránh ghi chú và kết quả bị lệch khi `master` thay đổi |
| Vai trò mục tiêu | **Data Platform Engineer**, không phải kernel developer | Đọc source để giải thích hành vi quan sát được, không để đóng góp patch |

---

## Artifacts trên đĩa (inventory nhanh)

| Path | Vai trò | Trong Git lab? |
|------|---------|----------------|
| `postgres-src/` | Upstream source | Không (ignored) |
| `docs/c4/` | Kiến trúc C4 + PNG | Có |
| `docs/superpowers/` | Spec/plan Query Lab | **Ignored** — chỉ local trừ khi đổi `.gitignore` |
| `docs/LEARNING-PROGRESS.md` | Tracking lộ trình (DPE) | Nên commit |
| `docs/LEARNING-PROGRESS-FRESHMAN.md` | Lộ trình cho sinh viên năm nhất | Có |
| `.vscode/settings.json` | PlantUML Java paths | Ignored (máy-local) |
| Cursor canvases | Simulation / Query Lab | Ngoài repo lab |

---

## Bước tiếp theo đề xuất (chỉ 1 “next”)

**Phase 1.2:** Đọc `postgres-src/README.md` và hướng dẫn cài đặt tương ứng; chọn Meson hoặc configure/make, ghi prefix local và lý do. Sau đó tiến thẳng tới build → `initdb` → `psql`; ghi chú bốn thư mục `src/` có thể làm song song.

Khi hoàn thành một ô: đổi status, ghi ngày cùng lệnh/kết quả hoặc artifact vào Evidence. Không đánh dấu xong chỉ vì đã lên kế hoạch.

---

## Cách dùng file này (tránh hoang mang)

1. Mở file này **đầu buổi học** — nhìn “Bạn đang ở đâu”.  
2. Chỉ làm **một mốc** Phase hiện tại.  
3. Cuối buổi: cập nhật Status + Evidence.  
4. Nếu kế hoạch lệch (ví dụ muốn submodule): sửa bảng “Quyết định đã chốt” + ghi ngày — được phép đổi hướng khi có căn cứ mới.

---

## Liên hệ DE

- Chưa có server tự build → chưa có bằng chứng platform (`EXPLAIN`, WAL trên máy bạn).  
- C4 + process model → sau này giải thích connection pool, checkpoint, “query chậm = backend PID nào”.  
- Sau Phase 1.4, học engine và platform qua cùng một workload; dùng `/postgres` để đặt giả thuyết và đối chiếu với instance lab.
- Mốc 3.6–3.10 bổ sung các năng lực platform dễ bỏ sót khi chỉ học query path: ingest/CDC, khôi phục có kiểm chứng, replica/lag, connection pooling và partitioning. Thực hành trên các cluster lab riêng, không dùng dữ liệu thật.
