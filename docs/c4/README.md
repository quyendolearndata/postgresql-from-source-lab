# PostgreSQL C4 diagrams (lab)

Sơ đồ dùng để học kiến trúc — đã chỉnh theo **runtime thật** của PostgreSQL.

## Files

| File | Ý nghĩa |
|------|---------|
| `c1-system-context.puml` | C1 — Postgres trong ngữ cảnh (app, OS, replica) |
| `c2-containers.puml` | C2 — container runtime: postmaster / backend / aux / shm / PGDATA; **libpq ở client** |
| `c2-deployment.puml` | Deployment trên một host |
| `c3-components.puml` | C3 — component trong **một** backend session |
| `dynamic-query-sequence.puml` | Sequence path of a query (**không** phải C4 Level 4 Code) |

Export (chỉ PNG): thư mục `export/`.

## Quy tắc đọc nhanh

1. **Frontend/Backend Protocol** = wire protocol. libpq/JDBC là client nói protocol đó.
2. **libpq client** ≠ **`src/backend/libpq`** (I/O protocol phía server).
3. **postmaster** nhận kết nối và fork; **backend** chạy SQL của session.
4. Shared memory không phải process riêng — là vùng nhớ map vào nhiều process.

## Preview trong Cursor

`.puml` là **text nguồn** — mở file không tự hiện sơ đồ.

1. Cài extension **PlantUML** (`jebbs.plantuml`) — lab đã cấu hình Java trong `.vscode/settings.json`.
2. Mở một file `.puml`.
3. Command Palette → **PlantUML: Preview Current Diagram** (macOS thường `⌥⌘D` hoặc `Alt+D` tùy keymap).
4. Lần đầu có `!include https://...C4-PlantUML...` → cần **mạng** để tải thư viện C4.

Nếu preview vẫn lỗi Java: Reload Window sau khi mở đúng folder `postgresql-from-source-lab`.

**Cách không cần PlantUML:** mở sẵn ảnh trong `export/*.png`.

## Render lại ra file

```bash
cd docs/c4
plantuml -tpng -o export \
  c1-system-context.puml \
  c2-containers.puml \
  c2-deployment.puml \
  c3-components.puml \
  dynamic-query-sequence.puml
```

File cũ `c4-query-sequence.puml` đã được thay bằng `dynamic-query-sequence.puml`.
