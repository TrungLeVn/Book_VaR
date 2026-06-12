# ============================================================
# 02_tables.R
# Tables for Chapter 1
# ============================================================

# ---- Table 1.1 ------------------------------------------------
tbl_1_1 <- tibble::tribble(
  ~`Tài sản`, ~`Giá đầu kỳ`, ~`Giá cuối kỳ`,
  "A", 50, 55,
  "B", 200, 206
) |>
  dplyr::mutate(
    `Thay đổi giá` = `Giá cuối kỳ` - `Giá đầu kỳ`,
    `Tỷ lệ sinh lời` = (`Giá cuối kỳ` - `Giá đầu kỳ`) / `Giá đầu kỳ`,
    `Nhận xét` = dplyr::case_when(
      `Tài sản` == "A" ~ "Tăng giá tuyệt đối thấp hơn, nhưng tỷ lệ sinh lời cao hơn",
      `Tài sản` == "B" ~ "Tăng giá tuyệt đối cao hơn, nhưng tỷ lệ sinh lời thấp hơn"
    )
  )

ft_1_1 <- tbl_1_1 |>
  dplyr::mutate(`Tỷ lệ sinh lời` = scales::percent(`Tỷ lệ sinh lời`, accuracy = 0.1, decimal.mark = ",")) |>
  flextable::flextable() |>
  format_ft()

save_ft_docx(ft_1_1, "Bảng 1.1. Vì sao cần dùng tỷ lệ sinh lời thay vì thay đổi giá tuyệt đối?", "tbl_1_1_price_return.docx")
readr::write_csv(tbl_1_1, file.path(TAB_DIR, "tbl_1_1_price_return.csv"))

# ---- Table 1.2 ------------------------------------------------
tbl_1_2 <- tibble::tribble(
  ~`Vấn đề dữ liệu`, ~`Lựa chọn khuyến nghị`, ~`Lý do`, ~`Hệ quả nếu xử lý sai`,

  "Giá đóng cửa hay giá điều chỉnh",
  "Ưu tiên giá điều chỉnh khi phân tích cổ phiếu riêng lẻ",
  "Phản ánh tốt hơn cổ tức, chia tách, cổ phiếu thưởng và quyền mua",
  "Return có thể xuất hiện cú nhảy kỹ thuật không phản ánh rủi ro thị trường thực chất",

  "Cổ tức tiền mặt",
  "Tính vào return hoặc dùng giá điều chỉnh",
  "Cổ tức là một phần lợi ích kinh tế của nhà đầu tư",
  "Có thể đánh giá thấp return thực tế và phóng đại biến động quanh ngày không hưởng quyền",

  "Chia tách/cổ phiếu thưởng",
  "Điều chỉnh lại chuỗi giá trước khi tính return",
  "Giá sau sự kiện có thể giảm mạnh về mặt kỹ thuật nhưng giá trị kinh tế không giảm tương ứng",
  "Tạo return âm giả tạo, làm sai lệch volatility và VaR",

  "Phát hành quyền mua",
  "Điều chỉnh giá hoặc xử lý riêng các quan sát bị ảnh hưởng",
  "Quyền mua làm thay đổi giá tham chiếu và lợi ích kinh tế của cổ đông",
  "Tạo outlier kỹ thuật trong chuỗi return",

  "Ngày không giao dịch",
  "Sắp xếp theo ngày giao dịch thực tế; không nội suy giá nếu không có cơ sở",
  "Dữ liệu thị trường không có quan sát vào ngày nghỉ",
  "Có thể tạo return bằng 0 hoặc return giả nếu xử lý máy móc",

  "Dữ liệu thiếu",
  "Kiểm tra nguyên nhân thiếu; loại bỏ hoặc xử lý theo quy tắc rõ ràng",
  "Dữ liệu thiếu có thể do lỗi dữ liệu, ngừng giao dịch hoặc thanh khoản thấp",
  "Làm sai lệch thống kê mô tả, kiểm định và mô hình volatility",

  "Cổ phiếu thanh khoản thấp",
  "Cân nhắc loại khỏi mẫu hoặc phân tích riêng",
  "Giao dịch thưa có thể làm chuỗi giá không phản ánh liên tục thông tin thị trường",
  "Return có nhiều giá trị bằng 0, tự tương quan giả và volatility bị bóp méo",

  "Simple return hay log return",
  "Dùng log return cho mô hình chuỗi thời gian; dùng simple return cho P&L và danh mục",
  "Log return cộng được theo thời gian; simple return trực quan và cộng được theo tỷ trọng danh mục",
  "Diễn giải sai kết quả hoặc không nhất quán giữa phần mô hình và phần lãi/lỗ",

  "Giả định tái cân bằng danh mục",
  "Nêu rõ danh mục giữ nguyên số lượng tài sản hay tái cân bằng định kỳ",
  "Tỷ trọng danh mục thay đổi theo biến động giá nếu không tái cân bằng",
  "Return và VaR danh mục không thể so sánh giữa các phương án"
)

ft_1_2 <- tbl_1_2 |>
  flextable::flextable() |>
  flextable::width(j = 1, width = 1.55) |>
  flextable::width(j = 2, width = 2.00) |>
  flextable::width(j = 3, width = 2.10) |>
  flextable::width(j = 4, width = 2.15) |>
  format_ft(font_size = 9)

save_ft_docx(ft_1_2, "Bảng 1.2. Các quyết định dữ liệu khi tính tỷ lệ sinh lời trong thực nghiệm", "tbl_1_2_data_decisions.docx")
readr::write_csv(tbl_1_2, file.path(TAB_DIR, "tbl_1_2_data_decisions.csv"))

# ---- Table 1.3 ------------------------------------------------
tbl_1_3 <- tibble::tribble(
  ~`Tiêu chí`, ~`Tỷ lệ sinh lời giản đơn`, ~`Tỷ lệ sinh lời logarit`,

  "Công thức cơ bản",
  "R_t = (P_t - P_{t-1}) / P_{t-1}",
  "r_t = ln(P_t / P_{t-1})",

  "Diễn giải kinh tế",
  "Trực quan, phản ánh lãi/lỗ tương đối trong một kỳ",
  "Ít trực quan hơn, nhưng thuận tiện về mặt toán học",

  "Tổng hợp theo thời gian",
  "Tổng hợp bằng phép nhân lãi kép",
  "Có thể cộng trực tiếp qua thời gian",

  "Tổng hợp theo danh mục",
  "Danh mục là trung bình gia quyền của return thành phần",
  "Không có tính chất trung bình gia quyền chính xác",

  "Phù hợp nhất khi",
  "Phân tích hiệu quả đầu tư, P&L, return danh mục, phân bổ tài sản",
  "Mô hình hóa chuỗi thời gian, volatility, GARCH, VaR động",

  "Cách dùng trong cuốn sách",
  "Dùng khi diễn giải lãi/lỗ và danh mục",
  "Dùng chủ yếu trong các mô hình volatility và VaR/ES"
)

ft_1_3 <- tbl_1_3 |>
  flextable::flextable() |>
  flextable::width(j = 1, width = 1.60) |>
  flextable::width(j = 2, width = 2.45) |>
  flextable::width(j = 3, width = 2.45) |>
  format_ft()

save_ft_docx(ft_1_3, "Bảng 1.3. So sánh tỷ lệ sinh lời giản đơn và tỷ lệ sinh lời logarit", "tbl_1_3_simple_log_return.docx")
readr::write_csv(tbl_1_3, file.path(TAB_DIR, "tbl_1_3_simple_log_return.csv"))

# ---- Core-language table ------------------------------------
tbl_risk_language <- tibble::tribble(
  ~`Khái niệm`, ~`Ký hiệu gợi ý`, ~`Cách hiểu ngắn`, ~`Vai trò trong cuốn sách`,
  "Tỷ lệ sinh lời", "r_t hoặc R_t", "Mức thay đổi tương đối của giá trị đầu tư qua một kỳ", "Dữ liệu đầu vào cơ sở cho toàn bộ phân tích",
  "Lãi/lỗ vị thế", "P&L_t", "Giá trị lãi hoặc lỗ bằng tiền của một vị thế đầu tư", "Cầu nối giữa return và quản trị danh mục",
  "Tổn thất", "L_t = -P&L_t", "Cách viết lại P&L để giá trị dương phản ánh mức lỗ", "Nền tảng để định nghĩa phân phối tổn thất, VaR và ES",
  "Volatility", "sigma_t", "Thước đo quy mô dao động của tỷ lệ sinh lời", "Cầu nối từ phân phối return sang mô hình rủi ro động",
  "Value-at-Risk", "VaR_alpha,t", "Ngưỡng tổn thất tại một mức xác suất đuôi cho trước", "Thước đo phân vị của rủi ro đuôi",
  "Expected Shortfall", "ES_alpha,t", "Tổn thất trung bình khi đã vượt qua ngưỡng VaR", "Thước đo độ nghiêm trọng của rủi ro đuôi"
)

ft_risk_language <- tbl_risk_language |>
  flextable::flextable() |>
  flextable::width(j = 1, width = 1.45) |>
  flextable::width(j = 2, width = 1.25) |>
  flextable::width(j = 3, width = 2.35) |>
  flextable::width(j = 4, width = 2.35) |>
  format_ft()

save_ft_docx(ft_risk_language, "Bảng 1.x. Ngôn ngữ cốt lõi của Chương 1", "tbl_1_x_risk_language.docx")
readr::write_csv(tbl_risk_language, file.path(TAB_DIR, "tbl_1_x_risk_language.csv"))
