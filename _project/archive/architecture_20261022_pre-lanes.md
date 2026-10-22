# Kiến trúc sách — đề cương 3.1 (bản markdown)

- **Nguồn:** `00. Book/outline_v3.docx` (đề cương 3.1, 22/10/2026), SHA-256 `7fcb6458b8eb1c7991594de543f8f8f2f2a40bbc426f72774a0de4d9183ce9c4` — khớp `_project/input_manifest_20261022.csv`.
- **Cách tạo:** trích tự động từ style Heading 1/2/3 của docx (B01, 22/10/2026); không sửa chữ tiêu đề. Kiểm đếm: **46 mục, 78 tiểu mục** trong 6 chương (+ 4 mục Mở đầu, 4 phụ lục) — khớp tiêu chí ticket.
- **Quy ước cấp tiêu đề (theo đề cương):** Heading 1 = chương/phần; Heading 2 = mục x.y; Heading 3 = tiểu mục x.y.z; dưới x.y.z dùng tiêu đề in đậm không đánh số.
- **Nguyên tắc tiêu đề:** ngắn gọn; không đan xen Anh–Việt; thuật ngữ tiếng Anh, tên kiểm định, tên tác giả đưa vào thân bài; giữ tên riêng mô hình (ARCH, GARCH) và tên chỉ số. Đối chiếu thuật ngữ: `00. Book/glossary.md`; ký hiệu: `00. Book/notation.md`.
- **Docx là bản chuẩn.** Khi đề cương đổi, sinh lại file này từ docx; không sửa tay danh sách tiêu đề.

## Tên sách
Đo lường và dự báo biến động, giá trị chịu rủi ro và tổn thất kỳ vọng có điều kiện trên thị trường chứng khoán Việt Nam (sách chuyên khảo, tiếng Việt).

## Luận điểm trung tâm (tác giả, 22/10/2026)
Cung cấp bằng chứng thực nghiệm về các phương pháp đo lường biến động tỷ suất sinh lời và rủi ro đuôi của tỷ suất sinh lời ở thị trường mới nổi với mẫu là Việt Nam. Ở thị trường mới nổi có biên độ giá, thanh khoản không đều và nhà đầu tư cá nhân chiếm đa số như Việt Nam, điều này đặc biệt quan trọng bởi rủi ro mô hình có thể dẫn tới các quyết định đầu tư, phòng ngừa rủi ro kém hiệu quả.

## Mạch sách
```
Mở đầu → Ch1 (lý luận chung) ─┬→ Ch2 (phương pháp biến động) → Ch3 (thực nghiệm biến động) ─┐
                               └→ Ch4 (phương pháp rủi ro đuôi) → Ch5 (thực nghiệm rủi ro đuôi) ┤
                                                                   5.6 nối Ch3 ↔ Ch5 ────────┘→ Ch6 (tổng hợp, hàm ý) → Phụ lục A–D
```
- **Câu hỏi nối hai phần thực nghiệm (mục 5.6):** mô hình dự báo biến động tốt (Chương 3) có cho dự báo rủi ro đuôi tốt (Chương 5) không? 5.6.1 đối chiếu xếp hạng mô hình với Chương 3; 5.6.2 tách vai trò của phương trình phương sai và phân phối sai số.
- **Cặp song song Ch3 ↔ Ch5:** 3.1↔5.1 (tổng quan, giả thuyết, cùng ba tiểu mục); 3.2↔5.2 (dữ liệu, thiết kế); 3.6↔5.7 (giai đoạn thị trường, dùng chung quy tắc chia giai đoạn — C03-D1); 3.7↔5.8 (chỉ số khác, cùng hai tiểu mục); 3.8↔5.9 (độ bền); 3.9↔5.10 (kết luận).
- **Cặp phương pháp → thực nghiệm:** Ch2 → Ch3; Ch4 → Ch5. Mỗi mô hình dùng trong Ch3/Ch5 phải được trình bày ở Ch2/Ch4.

## Phương án dữ liệu (chốt 22/10/2026 — `PROJECT.md`)
| Dữ liệu | Vai trò | Cách dùng |
|---|---|---|
| VN-Index | Chuỗi chính | Phân tích đầy đủ Chương 3 và 5 |
| HNX-Index | Chuỗi đối chứng | Toàn bộ tập mô hình; báo cáo gọn ở 3.7 và 5.8; xử lý giao dịch không đồng bộ |
| Chỉ số ngành HOSE | Dùng chọn lọc | Quy tắc chọn định trước (B07); một bảng trong thân bài, chi tiết Phụ lục D |
| VN30 | **Bỏ** (tác giả, 22/10/2026 13:50) | — |
| Cổ phiếu riêng lẻ | Không dùng | Nêu ở 6.5 |

## Điểm lệch giữa đề cương 3.1 và quyết định sau đó — CẦN TÁC GIẢ QUYẾT ĐỊNH
1. Tiêu đề **3.7.1** và **5.8.1** là "VN30 và HNX-Index", nhưng VN30 đã bị bỏ. Đề xuất: đổi thành "3.7.1. HNX-Index" và "5.8.1. HNX-Index" (hoặc "Chỉ số sàn Hà Nội"). Chưa sửa trong file này vì docx là bản chuẩn.
2. Bảng "Phương án dữ liệu" trong outline_v3.docx còn dòng VN30 "Dùng hạn chế"; Ghi chú sử dụng còn nêu VN30 trong ví dụ tên chỉ số. Đề xuất cập nhật docx (bản 3.2) cùng lúc với điểm 1.
3. 13 mục không có tiểu mục: 1.5, 1.6, 2.7, 3.6, 3.8, 3.9, 4.8, 5.7, 5.9, 5.10, 6.3, 6.5, 6.6 (gồm các mục kết luận). Đây là chủ ý của đề cương; chỉ ghi để người viết dùng tiêu đề in đậm không đánh số bên trong.

## Đề cương chi tiết
### MỞ ĐẦU

> Vai trò: Đặt vấn đề, câu hỏi nghiên cứu, luận điểm trung tâm, dữ liệu và nguyên tắc tái lập, cấu trúc sách. Viết sau cùng (ticket B09), chỉ dùng kết quả đã kiểm.

- **Vấn đề và câu hỏi nghiên cứu**
- **Luận điểm trung tâm và đóng góp**
- **Dữ liệu, phạm vi và nguyên tắc tái lập**
- **Cấu trúc sách**

### Chương 1. Cơ sở lý luận về tỷ suất sinh lời, biến động và rủi ro đuôi

> Vai trò: Nền lý luận: tỷ suất sinh lời, các đặc điểm thực nghiệm, định nghĩa biến động, giá trị chịu rủi ro và tổn thất kỳ vọng có điều kiện; quy trình đo lường chung dùng cho cả sách (1.5).

- **1.1. Rủi ro thị trường và yêu cầu đo lường**
    - 1.1.1. Từ biến động giá đến tổn thất của vị thế đầu tư
    - 1.1.2. Vai trò của đo lường biến động và rủi ro đuôi
- **1.2. Tỷ suất sinh lời của tài sản**
    - 1.2.1. Tỷ suất sinh lời của một tài sản
    - 1.2.2. Tỷ suất sinh lời danh mục và lãi/lỗ của vị thế
- **1.3. Các đặc điểm thực nghiệm của tỷ suất sinh lời**
    - 1.3.1. Trung bình khó dự báo và phương sai phụ thuộc theo thời gian
    - 1.3.2. Đuôi dày, độ lệch và hiệu ứng bất đối xứng
    - 1.3.3. Hàm ý đối với mô hình hóa
- **1.4. Biến động tỷ suất sinh lời và rủi ro đuôi**
    - 1.4.1. Biến động tỷ suất sinh lời
    - 1.4.2. Giá trị chịu rủi ro
    - 1.4.3. Tổn thất kỳ vọng có điều kiện
- **1.5. Quy trình đo lường biến động tỷ suất sinh lời, giá trị chịu rủi ro và tổn thất kỳ vọng có điều kiện**
- **1.6. Kết luận chương**

### Chương 2. Mô hình đo lường và dự báo biến động

> Vai trò: Phương pháp đo lường và dự báo biến động: thước đo giản đơn, họ GARCH, phân phối sai số, ước lượng–chẩn đoán, thước đo đối chứng, thiết kế và đánh giá dự báo. Cung cấp tập mô hình cho Chương 3.

- **2.1. Các phương pháp đo lường giản đơn**
    - 2.1.1. Biến động lịch sử và cửa sổ trượt
    - 2.1.2. Trung bình trượt có trọng số mũ
    - 2.1.3. Ước lượng dựa trên biên độ giá
- **2.2. Họ mô hình GARCH**
    - 2.2.1. ARCH và GARCH(1,1)
    - 2.2.2. Tính bền và khả năng hồi quy về trung bình
    - 2.2.3. Nhóm mô hình GARCH bất đối xứng
    - 2.2.4. Nhóm mô hình GARCH có bộ nhớ dài
- **2.3. Phân phối sai số chuẩn hóa**
    - 2.3.1. Phân phối chuẩn và các phân phối đuôi dày
    - 2.3.2. Hàm ý đối với rủi ro đuôi
- **2.4. Ước lượng, lựa chọn và chẩn đoán mô hình**
    - 2.4.1. Phương trình trung bình và phương pháp ước lượng
    - 2.4.2. Tiêu chí thông tin và chẩn đoán phần dư
- **2.5. Biến động thực hiện và biến động hàm ý**
    - 2.5.1. Biến động thực hiện
    - 2.5.2. Biến động hàm ý
- **2.6. Thiết kế và đánh giá dự báo**
    - 2.6.1. Cửa sổ ước lượng và kỳ dự báo
    - 2.6.2. Thước đo đối chứng và hàm tổn thất
    - 2.6.3. Kiểm định so sánh khả năng dự báo
- **2.7. Kết luận chương**

### Chương 3. Thực nghiệm đo lường và dự báo biến động trên thị trường Việt Nam

> Vai trò: Thực nghiệm biến động: VN-Index là chuỗi chính (3.4–3.6); HNX-Index và chỉ số ngành kiểm tra tính khái quát (3.7); kiểm định độ bền (3.8). Kết quả xếp hạng mô hình biến động là đầu vào của 5.6.

- **3.1. Tổng quan nghiên cứu và giả thuyết**
    - 3.1.1. Bằng chứng quốc tế và thị trường mới nổi
    - 3.1.2. Bằng chứng tại Việt Nam và khoảng trống nghiên cứu
    - 3.1.3. Câu hỏi và giả thuyết nghiên cứu
- **3.2. Dữ liệu và thiết kế thực nghiệm**
    - 3.2.1. Các chuỗi chỉ số và vai trò của từng chuỗi
    - 3.2.2. Xử lý dữ liệu và thước đo biến động đối chứng
    - 3.2.3. Tập mô hình và thiết kế dự báo ngoài mẫu
- **3.3. Đặc điểm thống kê của các chuỗi tỷ suất sinh lời**
    - 3.3.1. Thống kê mô tả
    - 3.3.2. Kiểm định phân phối, tính dừng, hiệu ứng ARCH và bất đối xứng
- **3.4. Kết quả ước lượng trong mẫu với VN-Index**
    - 3.4.1. Ước lượng và lựa chọn mô hình
    - 3.4.2. Ý nghĩa kinh tế của các tham số
- **3.5. Kết quả dự báo ngoài mẫu với VN-Index**
    - 3.5.1. Sai số dự báo theo hàm tổn thất và kỳ dự báo
    - 3.5.2. Kiểm định so sánh và xếp hạng mô hình
- **3.6. Phân tích theo giai đoạn thị trường**
- **3.7. Tính khái quát trên các chỉ số khác**
    - 3.7.1. VN30 và HNX-Index
    - 3.7.2. Khác biệt giữa các ngành
- **3.8. Kiểm định độ bền**
- **3.9. Kết luận về biến động tại Việt Nam**

### Chương 4. Các phương pháp đo lường giá trị chịu rủi ro và tổn thất kỳ vọng có điều kiện

> Vai trò: Phương pháp đo lường rủi ro đuôi: phi tham số, tham số, mô phỏng, bán tham số; kiểm định ngược; so sánh mô hình và rủi ro mô hình. Cung cấp tập mô hình cho Chương 5.

- **4.1. Từ dự báo biến động đến đo lường rủi ro đuôi**
    - 4.1.1. Phân vị và kỳ vọng vùng đuôi
    - 4.1.2. Tính chất của thước đo rủi ro
- **4.2. Phương pháp phi tham số**
    - 4.2.1. Mô phỏng lịch sử
    - 4.2.2. Mô phỏng lịch sử có trọng số
- **4.3. Phương pháp tham số**
    - 4.3.1. Mô hình tham số không điều kiện
    - 4.3.2. Mô hình tham số có điều kiện
    - 4.3.3. Kỳ hạn nắm giữ nhiều ngày
- **4.4. Phương pháp mô phỏng**
    - 4.4.1. Mô phỏng ngẫu nhiên
    - 4.4.2. Mô phỏng lịch sử có lọc
- **4.5. Phương pháp bán tham số**
    - 4.5.1. Lý thuyết giá trị cực trị
    - 4.5.2. Hồi quy phân vị
- **4.6. Kiểm định ngược**
    - 4.6.1. Kiểm định ngược giá trị chịu rủi ro
    - 4.6.2. Kiểm định ngược tổn thất kỳ vọng có điều kiện
- **4.7. So sánh và lựa chọn mô hình**
    - 4.7.1. Hàm điểm và kiểm định so sánh
    - 4.7.2. Rủi ro mô hình
- **4.8. Kết luận chương**

### Chương 5. Thực nghiệm đo lường và dự báo rủi ro đuôi trên thị trường Việt Nam

> Vai trò: Thực nghiệm rủi ro đuôi: VN-Index (5.3–5.5); cầu nối với Chương 3 (5.6); giai đoạn thị trường (5.7); HNX-Index và ngành (5.8); độ bền (5.9). Cấu trúc song song với Chương 3.

- **5.1. Tổng quan nghiên cứu và giả thuyết**
    - 5.1.1. Bằng chứng quốc tế và thị trường mới nổi
    - 5.1.2. Bằng chứng tại Việt Nam và khoảng trống nghiên cứu
    - 5.1.3. Câu hỏi và giả thuyết nghiên cứu
- **5.2. Dữ liệu và thiết kế kiểm định ngược**
    - 5.2.1. Chuỗi tổn thất và tập mô hình
    - 5.2.2. Mức tin cậy, kỳ hạn nắm giữ và cửa sổ trượt
- **5.3. Kết quả giá trị chịu rủi ro với VN-Index**
    - 5.3.1. Tần suất vi phạm và kiểm định độ phủ
    - 5.3.2. Sự tập trung của các vi phạm
- **5.4. Kết quả tổn thất kỳ vọng có điều kiện với VN-Index**
    - 5.4.1. Mức độ nghiêm trọng của tổn thất vượt ngưỡng
    - 5.4.2. Kiểm định ngược và hàm điểm
- **5.5. So sánh mô hình theo nhóm phương pháp**
    - 5.5.1. Phi tham số, tham số và bán tham số
    - 5.5.2. Đánh đổi giữa độ chính xác và khả năng triển khai
- **5.6. Từ dự báo biến động đến dự báo rủi ro đuôi**
    - 5.6.1. Đối chiếu xếp hạng mô hình với Chương 3
    - 5.6.2. Vai trò của phương trình phương sai và phân phối sai số
- **5.7. Phân tích theo giai đoạn thị trường**
- **5.8. Tính khái quát trên các chỉ số khác**
    - 5.8.1. VN30 và HNX-Index
    - 5.8.2. Khác biệt giữa các ngành
- **5.9. Kiểm định độ bền**
- **5.10. Kết luận về rủi ro đuôi tại Việt Nam**

### Chương 6. Tổng hợp, hàm ý và hướng phát triển

> Vai trò: Tổng hợp bằng chứng so với luận điểm trung tâm; hàm ý cho nhà đầu tư, công ty chứng khoán–quỹ, ngân hàng–cơ quan quản lý; hướng phát triển; hạn chế (gồm việc không dùng cổ phiếu riêng lẻ).

- **6.1. Tổng hợp bằng chứng của sách**
    - 6.1.1. Về mô hình biến động
    - 6.1.2. Về mô hình rủi ro đuôi
    - 6.1.3. Mức độ ủng hộ đối với luận điểm trung tâm
- **6.2. Hàm ý cho nhà đầu tư và tổ chức kinh doanh chứng khoán**
    - 6.2.1. Nhà đầu tư
    - 6.2.2. Công ty chứng khoán và quỹ đầu tư
- **6.3. Hàm ý cho ngân hàng và cơ quan quản lý**
- **6.4. Hướng phát triển về mô hình và dữ liệu**
    - 6.4.1. Mô hình biến động
    - 6.4.2. Mô hình rủi ro đuôi
    - 6.4.3. Dữ liệu mới
- **6.5. Hạn chế và hướng nghiên cứu tiếp theo**
- **6.6. Kết luận cuối sách**

### PHỤ LỤC

> Vai trò: A: ký hiệu, thuật ngữ, công thức (từ notation.md, glossary.md); B: dữ liệu và tái lập (từ hợp đồng dữ liệu B02); C: mã R đã duyệt; D: bảng bổ sung theo chỉ số và ngành (ticket B10).

- **Phụ lục A. Ký hiệu, thuật ngữ Anh–Việt và công thức chính**
- **Phụ lục B. Dữ liệu và quy trình tái lập**
- **Phụ lục C. Mã lệnh R**
- **Phụ lục D. Bảng kết quả bổ sung theo chỉ số và theo ngành**
