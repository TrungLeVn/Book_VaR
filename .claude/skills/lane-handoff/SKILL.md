---
name: lane-handoff
description: Dựng khối "Prompt mở phiên" cho dự án sách VaR (CLAUDE.md mục "Kết thúc mỗi phản hồi") — chọn ticket Sẵn sàng theo tickets/TASKS.md, kiểm tập ghi và giới hạn R nặng, rồi xuất prompt Code/Cowork tự đủ, dán được ngay. Dùng khi kết thúc một khối việc, đổi trạng thái ticket, nêu bước tiếp theo, hoặc khi tác giả gõ "/lane-handoff", "prompt mở phiên", "mở phiên làn", "brief cho L3", "việc tiếp theo cho các làn".
argument-hint: "[mã ticket ...] [--surface Code|Cowork]"
---

# Prompt mở phiên kế tiếp

Quy cách gốc: `CLAUDE.md` mục "Kết thúc mỗi phản hồi", `tickets/LANES.md` mục 2–4, 6, 7, 9. Skill này chỉ đọc; không sửa TASKS.md/LOG.md.

## 1. Lấy trạng thái (không tự đọc cả TASKS.md)
```bash
python3 .claude/skills/lane-handoff/ready_tickets.py          # Sẵn sàng / Đang làm / Cần quyết định
python3 .claude/skills/lane-handoff/ready_tickets.py --all    # thêm ticket bị chặn và mã còn thiếu
```
- `Sẵn sàng (L0)`: L0 đã mở (dòng Trạng thái). `Sẵn sàng`: mọi phụ thuộc cứng đã Done theo script — vẫn đọc dòng `Phụ thuộc` để chắc (script bỏ ghi chú trong ngoặc và phần sau `;`).
- `Kiểm tay`: phụ thuộc dạng dải (`C01…C06-M6`) — tự kiểm trong TASKS.md.

## 2. Chọn phiên (đối chiếu trước khi xuất)
- Chỉ ticket Sẵn sàng; nếu tác giả nêu mã ticket (`$ARGUMENTS`) thì dùng mã đó, nhưng báo nếu chưa sẵn sàng.
- Không hai phiên cùng làn hoặc trùng tập ghi; ticket `Đang làm` đã có phiên → không mở phiên mới (chỉ prompt "tiếp tục" nếu tác giả yêu cầu).
- Phiên làn cấu phần (L3a/b/c, L5a/b/c) song song với phiên điều phối chương được, vì tập ghi tách (LANES.md mục 3).
- Tối đa 3 phiên chạy R nặng cùng lúc (cột `R nặng?` chỉ là gợi ý; C02-M3, C04-M3 là mô phỏng nhẹ theo LANES.md mục 9). Tính cả phiên đang chạy theo LOG.md.
- Bề mặt theo `Nơi làm`. `Either`: Code nếu cần đọc/chạy code hoặc dựng tệp; Cowork nếu chỉ đọc tài liệu, viết, Word/Drive.
- Phản hồi có hai lựa chọn bước tiếp khác nhau → ghi rõ prompt nào thuộc lựa chọn nào.

## 3. Dựng prompt
```bash
python3 .claude/skills/lane-handoff/ready_tickets.py --prompt <mã> [--surface Code|Cowork]
```
Script điền: làn, thứ tự đọc, card agent (từ `tickets/<mã>.md`), đầu vào `_project/data/` kèm SHA từ `DATA_MANIFEST.csv`, đầu ra + tiêu chí, tập ghi theo LANES.md, điểm dừng, cách cập nhật TASKS/LOG; bản Cowork thêm quy tắc bảo vệ nguồn và "NOT RUN → Code". Cảnh báo (sai bề mặt, chưa sẵn sàng) in ra stderr — đọc và xử lý, không bỏ qua.

Sau đó tự rà và sửa bản nháp:
- Đầu vào là kết quả của làn khác (run `results/<mã>_<ts>/`) → thêm đường dẫn run và SHA ghi trong README của run đó; chưa Done/chưa khoá → không mở phiên.
- Thêm điểm dừng riêng của khối việc vừa bàn (nếu có), ví dụ "gộp với C05-D1 thành một gói Design".
- Giữ ngắn: không chép lại nội dung ticket; phiên mới tự đọc `tickets/<mã>.md`.

## 4. Xuất
Cuối phản hồi, sau hai lựa chọn bước tiếp, dưới tiêu đề **Prompt mở phiên**: mỗi phiên một khối ```` ```text ```` riêng, dòng đầu `[Lx] <mã> — Code` hoặc `— Cowork`.
- Prompt giống hệt phản hồi trước → ghi "Prompt mở phiên: như phản hồi trước".
- Không có ticket nào sẵn sàng → nói rõ đang chờ gì (mã ticket, điểm duyệt, quyết định của tác giả), không bịa phiên.
