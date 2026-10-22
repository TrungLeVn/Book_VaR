**Chương 5**

# **MÔ HÌNH ĐO LƯỜNG GIÁ TRỊ CHỊU RỦI RO TRÊN THỊ TRƯỜNG CHỨNG KHOÁN VIỆT NAM**

Chương 4 đã trình bày nền tảng phương pháp của các mô hình VaR và ES. Chương này chuyển từ trình bày phương pháp sang **so sánh thực nghiệm** trên thị trường chứng khoán Việt Nam, với đối tượng đại diện là chỉ số VN-Index. Vì vậy, chương này không lặp lại định nghĩa VaR/ES mà tập trung vào ba câu hỏi thực nghiệm: mô hình nào tạo ra dự báo VaR hợp lý hơn cho VN-Index, mô hình nào có tỷ lệ vi phạm phù hợp với mức tin cậy đã chọn, và các kết quả đó gợi ý gì cho quản trị rủi ro thị trường tại Việt Nam.

Cách tiếp cận của chương này là **empirical comparison of VaR models**. Tất cả mô hình được đánh giá trên cùng một chuỗi tỷ lệ sinh lời, cùng kỳ nắm giữ, cùng cửa sổ ước lượng và cùng giai đoạn kiểm định ngoài mẫu. Cấu trúc chương song song với Chương 4: bắt đầu từ thiết kế dữ liệu và cửa sổ rolling, sau đó lần lượt đánh giá mô phỏng lịch sử, mô hình tham số, mô hình bán tham số/EVT, rồi tổng hợp bằng backtesting. Phần cuối của chương rút ra hàm ý cho quản trị rủi ro trên thị trường chứng khoán Việt Nam, nơi các đặc điểm như thanh khoản không đồng đều, giới hạn biên độ giá, hiệu ứng tin tức, và thay đổi chế độ biến động có thể làm cho rủi ro đuôi khác biệt đáng kể so với các thị trường phát triển.

## **1.1 THIẾT KẾ NGHIÊN CỨU: DỮ LIỆU, TỶ LỆ SINH LỜI, MỨC TIN CẬY VÀ CỬA SỔ ROLLING**

Đối tượng thực nghiệm của chương là VN-Index. Trong ứng dụng VaR, việc sử dụng chỉ số thị trường có hai lợi thế. Thứ nhất, chỉ số đại diện cho danh mục cổ phiếu rộng hơn so với một cổ phiếu đơn lẻ, qua đó phù hợp với mục tiêu đo lường rủi ro thị trường tổng thể. Thứ hai, chuỗi chỉ số thường có lịch sử dài hơn, thanh khoản tốt hơn và ít chịu ảnh hưởng bởi rủi ro đặc thù doanh nghiệp. Tuy nhiên, với thị trường Việt Nam, VN-Index vẫn có các đặc điểm cần lưu ý: thay đổi chế độ biến động giữa các giai đoạn, khả năng xuất hiện cụm biến động, tác động của giới hạn biên độ giá, và các cú sốc vĩ mô hoặc tâm lý nhà đầu tư có thể làm cho phân phối tỷ lệ sinh lời lệch chuẩn và có đuôi dày.

Trong chương này, tỷ lệ sinh lời ngày được tính theo log return:

``` math
r_{t} = 100 \times \left\lbrack \ln(P_{t}) - \ln(P_{t - 1}) \right\rbrack,
```

trong đó $`P_{t}`$ là giá đóng cửa hoặc giá đóng cửa điều chỉnh của VN-Index tại ngày giao dịch $`t`$. Đại lượng lỗ được định nghĩa là $`L_{t} = - r_{t}`$. Tất cả VaR và ES trong chương này được báo cáo theo đơn vị phần trăm của giá trị danh mục. Nếu danh mục có giá trị $`V`$, VaR tiền tệ được tính bằng $`V \times VaR/100`$.

Thiết kế thực nghiệm cơ sở sử dụng kỳ nắm giữ một ngày, hai mức tin cậy 95% và 99%, và cửa sổ ước lượng rolling 500 quan sát giao dịch. Cửa sổ 500 ngày tương đương khoảng hai năm giao dịch, đủ dài để ước lượng phân phối hoặc mô hình volatility, nhưng vẫn đủ ngắn để phản ứng với thay đổi chế độ thị trường. Trong thực hành, người phân tích có thể kiểm tra độ nhạy với cửa sổ 250, 750 hoặc 1000 ngày. Tuy nhiên, để bảo đảm so sánh công bằng, tất cả mô hình trong chương này dùng cùng một cửa sổ cơ sở.

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><p><strong>Bảng 1: Thiết kế thực nghiệm đo lường VaR/ES cho VN-Index</strong></p>
<table style="width:85%;">
<colgroup>
<col style="width: 35%" />
<col style="width: 49%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Thành phần</th>
<th style="text-align: left;">Lựa chọn trong chương</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">Tài sản đại diện</td>
<td style="text-align: left;">VN-Index</td>
</tr>
<tr>
<td style="text-align: left;">Nguồn dữ liệu</td>
<td style="text-align: left;">../data/vni_data.xlsx</td>
</tr>
<tr>
<td style="text-align: left;">Tần suất</td>
<td style="text-align: left;">Ngày giao dịch</td>
</tr>
<tr>
<td style="text-align: left;">Tỷ lệ sinh lời</td>
<td style="text-align: left;"><span class="math inline"><em>r</em><sub><em>t</em></sub> = 100[ln (<em>P</em><sub><em>t</em></sub>) − ln (<em>P</em><sub><em>t</em> − 1</sub>)]</span></td>
</tr>
<tr>
<td style="text-align: left;">Đại lượng lỗ</td>
<td style="text-align: left;"><span class="math inline"><em>L</em><sub><em>t</em></sub> = −<em>r</em><sub><em>t</em></sub></span></td>
</tr>
<tr>
<td style="text-align: left;">Kỳ nắm giữ</td>
<td style="text-align: left;">1 ngày</td>
</tr>
<tr>
<td style="text-align: left;">Mức tin cậy</td>
<td style="text-align: left;">95% và 99%</td>
</tr>
<tr>
<td style="text-align: left;">Cửa sổ ước lượng</td>
<td style="text-align: left;">500 quan sát giao dịch</td>
</tr>
<tr>
<td style="text-align: left;">Giai đoạn kiểm định ngoài mẫu</td>
<td style="text-align: left;">2012-01-06 đến 2026-05-20</td>
</tr>
<tr>
<td style="text-align: left;">Ngưỡng POT cho EVT</td>
<td style="text-align: left;">90% của phân phối lỗ trong cửa sổ rolling</td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>

**Bảng 1 xác định rõ thiết kế thực nghiệm. Điểm quan trọng là các mô hình không được so sánh trên các giai đoạn hoặc cửa sổ khác nhau. Nếu một mô hình dùng nhiều dữ liệu hơn hoặc biết trước thông tin tương lai, kết quả backtesting sẽ bị thiên lệch. Vì vậy, mọi dự báo VaR trong chương này đều là dự báo một bước trước, sử dụng thông tin có sẵn đến ngày để đánh giá rủi ro ngày .**

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><p><strong>Bảng 2: Thống kê mô tả tỷ lệ sinh lời ngày của VN-Index</strong></p>
<table style="width:85%;">
<colgroup>
<col style="width: 8%" />
<col style="width: 9%" />
<col style="width: 9%" />
<col style="width: 10%" />
<col style="width: 12%" />
<col style="width: 9%" />
<col style="width: 9%" />
<col style="width: 6%" />
<col style="width: 10%" />
</colgroup>
<thead>
<tr>
<th style="text-align: center;">Số quan sát</th>
<th style="text-align: center;">Ngày bắt đầu</th>
<th style="text-align: center;">Ngày kết thúc</th>
<th style="text-align: center;">Trung bình (%)</th>
<th style="text-align: center;">Độ lệch chuẩn (%)</th>
<th style="text-align: center;">Nhỏ nhất (%)</th>
<th style="text-align: center;">Lớn nhất (%)</th>
<th style="text-align: center;">Skewness</th>
<th style="text-align: center;">Excess kurtosis</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: center;">4081</td>
<td style="text-align: center;">2010-01-05</td>
<td style="text-align: center;">2026-05-20</td>
<td style="text-align: center;">0,0319</td>
<td style="text-align: center;">1,1864</td>
<td style="text-align: center;">-6,9102</td>
<td style="text-align: center;">6,5469</td>
<td style="text-align: center;">-0,7780</td>
<td style="text-align: center;">3,9555</td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>

**Bảng 2 cung cấp mô tả ban đầu về phân phối tỷ lệ sinh lời. Nếu phân phối có skewness âm và excess kurtosis lớn, VaR dựa trên phân phối chuẩn có thể đánh giá thấp rủi ro ở đuôi trái. Đây là lý do chương này không chỉ dùng mô hình normal rolling mà còn so sánh với mô phỏng lịch sử, Student-t, EWMA, GARCH, hồi quy phân vị và EVT.**

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><embed src="media/rId11.pdf" style="width:5.83333in;height:3.28125in" />
<p><strong>Hình 1: Diễn biến VN-Index trong mẫu nghiên cứu</strong></p></td>
</tr>
</tbody>
</table>

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><embed src="media/rId15.pdf" style="width:5.83333in;height:3.28125in" />
<p><strong>Hình 2: Tỷ lệ sinh lời ngày và cụm biến động của VN-Index</strong></p></td>
</tr>
</tbody>
</table>

**Hình 2 là kiểm tra trực quan đầu tiên về volatility clustering. Nếu các ngày biến động mạnh có xu hướng xuất hiện gần nhau, VaR tĩnh dựa trên độ lệch chuẩn mẫu có thể phản ứng chậm trong giai đoạn thị trường căng thẳng. Khi đó, mô hình VaR động dựa trên EWMA hoặc GARCH có cơ sở thực nghiệm để được đưa vào so sánh.**

## **1.2 TỔNG QUAN NGHIÊN CỨU THỰC NGHIỆM VỀ VAR/ES, VOLATILITY ĐỘNG VÀ THỊ TRƯỜNG MỚI NỔI**

VaR trở thành thước đo trung tâm trong quản trị rủi ro thị trường vì nó chuyển toàn bộ phân phối lãi/lỗ thành một ngưỡng tổn thất có thể diễn giải trực tiếp theo kỳ nắm giữ và mức tin cậy. Cách diễn giải này đặc biệt hữu ích đối với ngân hàng, công ty chứng khoán, quỹ đầu tư và nhà quản lý danh mục vì VaR có thể được gắn với giới hạn rủi ro, phân bổ vốn và giám sát giao dịch. Tuy nhiên, các nghiên cứu hiện đại thường không xem VaR như một con số duy nhất, mà xem VaR như một **dự báo phân vị có điều kiện**. Do đó, câu hỏi trọng tâm không phải là “VaR là gì”, mà là “mô hình nào dự báo phân vị đuôi trái chính xác hơn trong điều kiện thị trường thay đổi”. Cách tiếp cận này phù hợp với định hướng của Tsay, khi Chương 7 của *An Introduction to Analysis of Financial Data with R* trình bày VaR, ES, RiskMetrics, econometric approach, quantile estimation, quantile regression và EVT như các nhóm phương pháp bổ sung cho nhau (Tsay, 2013). Brooks cũng nhấn mạnh VaR như một ứng dụng thực tiễn của kinh tế lượng tài chính, trong đó độ lệch chuẩn trong công thức delta-normal có thể được thay thế bằng dự báo volatility từ EWMA hoặc GARCH (Brooks, 2019).

Một tuyến nghiên cứu lớn so sánh các mô hình VaR theo mức độ giả định phân phối. Mô phỏng lịch sử có ưu điểm là không áp đặt phân phối chuẩn và phản ánh trực tiếp phân phối thực nghiệm của dữ liệu quá khứ. Tuy nhiên, nó phụ thuộc mạnh vào cửa sổ dữ liệu và có thể phản ứng chậm khi thị trường xuất hiện structural breaks. Ngược lại, mô hình tham số như delta-normal hoặc Student-t dễ triển khai và dễ diễn giải, nhưng kết quả phụ thuộc vào giả định phân phối. Khi dữ liệu có đuôi dày, bất đối xứng và volatility clustering, giả định chuẩn có thể làm VaR quá thấp ở các mức tin cậy cao. Đây là lý do các nghiên cứu sau này thường đưa EWMA, GARCH, GJR-GARCH, EGARCH hoặc các phân phối Student-t/skewed-t vào quy trình VaR. Trong bối cảnh thị trường mới nổi, yêu cầu này càng quan trọng vì lợi suất thường có biến động lớn hơn, thanh khoản mỏng hơn và nhạy hơn với cú sốc vĩ mô hoặc dòng vốn.

Ding and Meade (2010) cung cấp một kết quả thực nghiệm quan trọng cho việc lựa chọn giữa SV, GARCH và EWMA. Nghiên cứu của họ cho rằng dự báo volatility là đầu vào thiết yếu cho VaR; volatility bị đánh giá quá cao sẽ làm vốn rủi ro bị khóa quá mức, còn volatility bị đánh giá quá thấp sẽ làm tổ chức không được bảo vệ đầy đủ trước thua lỗ. Kết quả của họ cũng cho thấy SV chỉ vượt trội rõ trong các kịch bản volatility-of-volatility rất cao, trong khi EWMA có thể hoạt động tương đối tốt trong các kịch bản trung bình. Với chương này, kết quả đó gợi ý rằng EWMA không nên bị xem là mô hình quá đơn giản để loại bỏ. Ngược lại, EWMA là benchmark thực nghiệm cần thiết khi so sánh với các mô hình GARCH phức tạp hơn.

Các nghiên cứu gần đây về GARCH-type VaR cho thấy kết quả không hoàn toàn một chiều. Likitratcharoen and Suwannamalik (2024) đánh giá các mô hình GARCH-type VaR trong ngành vận tải Thái Lan giai đoạn COVID-19, bao gồm GARCH, ARMA-GARCH, GARCH-M, IGARCH, EWMA và csGARCH, đồng thời so sánh với Historical Simulation VaR và Delta Normal VaR. Nghiên cứu dùng Kupiec, independence test và Christoffersen interval forecast test để backtest. Kết quả đáng chú ý là Historical Simulation VaR có failure rate accuracy tốt hơn nhóm GARCH-type trong một số trường hợp, trong khi EWMA là mô hình tốt trong nhóm GARCH-type. Điều này quan trọng cho nghiên cứu VN-Index vì thị trường Việt Nam cũng là thị trường mới nổi, chịu ảnh hưởng mạnh bởi các giai đoạn căng thẳng như COVID-19 và các chu kỳ điều chỉnh thanh khoản. Vì vậy, chương này không giả định trước rằng GARCH luôn tốt hơn mô phỏng lịch sử.

Một hướng nghiên cứu khác nhấn mạnh vai trò của bất đối xứng volatility và leverage effect. Gupta (2025) so sánh GARCH chuẩn, EGARCH và GJR-GARCH cho các thị trường mới nổi và phát triển trong các giai đoạn khủng hoảng, bao gồm khủng hoảng tài chính toàn cầu, khủng hoảng Nga và COVID-19. Kết quả ủng hộ mô hình bất đối xứng, đặc biệt EGARCH, vì mô hình này ghi nhận tác động khác nhau của cú sốc dương và cú sốc âm đến volatility. Adegboyo and Sarwar (2025) cũng cho thấy thị trường chứng khoán Nigeria có volatility clustering và leverage effect, đồng thời GJR-GARCH với phân phối Student-t có kết quả dự báo volatility tốt. Các bằng chứng này có ý nghĩa trực tiếp với VN-Index: nếu cú sốc âm làm volatility tăng mạnh hơn cú sốc dương, mô hình VaR đối xứng có thể đánh giá thiếu rủi ro trong các giai đoạn thị trường giảm sâu.

Bên cạnh GARCH, các phương pháp bán tham số và phi tham số ngày càng được dùng để đo lường rủi ro đuôi. Hồi quy phân vị mô hình hóa trực tiếp conditional quantile thay vì đi qua volatility. Về mặt thực nghiệm, điều này phù hợp khi rủi ro đuôi phụ thuộc vào trạng thái thị trường, ví dụ lagged losses, lagged absolute returns hoặc biến đo căng thẳng thị trường. Tian, Cai, and Fang (2019) tổng quan các mô hình kinh tế lượng cho VaR, ES và expectile, đồng thời nhấn mạnh sự phát triển của các mô hình đo lường rủi ro dựa trên quantile, expectile và tail dependence. Với chương này, hồi quy phân vị được sử dụng như một mô hình semi-parametric VaR, bổ sung cho mô hình volatility-based VaR.

EVT là hướng tiếp cận chuyên biệt cho vùng đuôi phân phối. Brooks xem EVT là công cụ phù hợp để ước lượng VaR ở các phân vị cực đoan vì nó mô tả hình dạng đuôi của phân phối tổn thất chính xác hơn so với delta-normal (Brooks, 2019). Nolde and Zhou (2021) nhấn mạnh rằng extreme value analysis cung cấp khung lý thuyết tự nhiên để nghiên cứu các sự kiện hiếm nhưng có hậu quả lớn trong quản trị rủi ro tài chính. Chakraborty, Chandrashekhar, and Balasubramanian (2021) tổng quan nghiên cứu về đo lường extreme market risk và chỉ ra rằng EVT, filtered historical simulation, mixture distributions và các mô hình conditional volatility bất đối xứng/long memory là những hướng có độ chính xác cao trong đo lường VaR và ES. Đối với thị trường Việt Nam, EVT đặc biệt phù hợp khi mục tiêu là kiểm soát tổn thất cực đoan ở mức tin cậy 99%, nhưng nó cũng nhạy với lựa chọn ngưỡng và số lượng quan sát vượt ngưỡng.

Cuối cùng, nghiên cứu gần đây cũng đặt lại câu hỏi về sự đánh đổi giữa độ phức tạp mô hình và giá trị thực tiễn. Alexander and Dakos (2023) cho thấy các mô hình EWMA kiểu RiskMetrics có thể đạt độ chính xác VaR/ES tương đương GARCH trong một số bối cảnh, miễn là mô hình phản ánh phản ứng volatility bất đối xứng và phân phối đuôi dày. Kết quả này không hàm ý rằng GARCH không hữu ích, mà cho thấy lựa chọn mô hình cần dựa trên backtesting ngoài mẫu chứ không chỉ dựa vào độ phức tạp. Vì vậy, chương này đặt Historical Simulation, Normal rolling, Student-t rolling, EWMA, GARCH-t, GJR-GARCH-t, Quantile Regression và EVT-POT vào cùng một khung so sánh thực nghiệm.

Tóm lại, tổng quan nghiên cứu gợi ý bốn nguyên tắc cho thực nghiệm trên VN-Index. Thứ nhất, phải đánh giá mô hình bằng dự báo ngoài mẫu và backtesting. Thứ hai, phải so sánh mô hình đơn giản với mô hình phức tạp thay vì mặc định mô hình phức tạp tốt hơn. Thứ ba, phải xét đến volatility clustering, đuôi dày và bất đối xứng, vì đây là các đặc điểm thường gặp ở thị trường mới nổi. Thứ tư, nếu dùng ES hoặc EVT, cần diễn giải kết quả như thông tin bổ sung về mức độ nghiêm trọng của vùng đuôi, không chỉ là số lần vượt VaR.

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><p><strong>Bảng 3: Bản đồ nghiên cứu thực nghiệm liên quan đến mô hình VaR/ES</strong></p>
<table style="width:85%;">
<colgroup>
<col style="width: 23%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Nhóm nghiên cứu</th>
<th style="text-align: left;">Hàm ý cho chương 5</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">VaR/ES và mô hình dữ liệu tài chính</td>
<td style="text-align: left;">VaR/ES cần được xem như dự báo phân vị/tổn thất đuôi có điều kiện, không chỉ là công thức tĩnh.</td>
</tr>
<tr>
<td style="text-align: left;">EWMA, GARCH và volatility forecast</td>
<td style="text-align: left;">EWMA là benchmark quan trọng; GARCH và GJR-GARCH được dùng để kiểm tra giá trị gia tăng của volatility động.</td>
</tr>
<tr>
<td style="text-align: left;">GARCH-type VaR trong thị trường mới nổi</td>
<td style="text-align: left;">Không giả định GARCH luôn vượt trội; cần so sánh với Historical Simulation và Delta/Normal VaR.</td>
</tr>
<tr>
<td style="text-align: left;">Bất đối xứng volatility và leverage effect</td>
<td style="text-align: left;">Cần đưa mô hình bất đối xứng vào so sánh vì cú sốc âm có thể làm volatility tăng mạnh hơn cú sốc dương.</td>
</tr>
<tr>
<td style="text-align: left;">Hồi quy phân vị và risk measures</td>
<td style="text-align: left;">Quantile regression cho phép mô hình hóa trực tiếp VaR có điều kiện theo trạng thái thị trường.</td>
</tr>
<tr>
<td style="text-align: left;">EVT và extreme market risk</td>
<td style="text-align: left;">EVT-POT phù hợp với VaR 99% nhưng nhạy với ngưỡng và số lượng exceedances.</td>
</tr>
<tr>
<td style="text-align: left;">Backtesting và so sánh mô hình</td>
<td style="text-align: left;">Mô hình được chọn dựa trên tỷ lệ vi phạm, Kupiec, Christoffersen, DQ test và tail severity.</td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>

## **1.3 KẾT QUẢ VAR VÀ ES TỪ MÔ PHỎNG LỊCH SỬ**

Mô phỏng lịch sử là benchmark đầu tiên vì nó không áp đặt giả định chuẩn. Với mỗi ngày dự báo $`t`$, mô hình lấy 500 tỷ lệ sinh lời gần nhất từ $`t - 500`$ đến $`t - 1`$, tính phân vị thực nghiệm ở mức $`\alpha`$, sau đó chuyển sang VaR của phân phối lỗ. ES được tính bằng trung bình các khoản lỗ vượt VaR trong cùng cửa sổ. Điểm mạnh của phương pháp này là tính trực quan: nếu thị trường trong quá khứ gần có nhiều ngày giảm mạnh, VaR sẽ tăng. Điểm yếu là phương pháp phụ thuộc vào cửa sổ quá khứ; khi một cú sốc mới xảy ra nhưng chưa có trong cửa sổ dữ liệu, mô hình có thể phản ứng chậm.

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><embed src="media/rId22.pdf" style="width:5.83333in;height:3.49392in" />
<p><strong>Hình 3: VaR và ES từ mô phỏng lịch sử cho VN-Index</strong></p></td>
</tr>
</tbody>
</table>

**Hình 3 cho thấy ES thường nằm trên VaR vì ES đo tổn thất trung bình khi đã vượt qua ngưỡng VaR. Với VN-Index, khoảng cách giữa ES và VaR là thông tin quan trọng: nếu khoảng cách này lớn, rủi ro không chỉ nằm ở xác suất vi phạm mà còn nằm ở mức độ nghiêm trọng của các ngày giảm sâu.**

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><p><strong>Bảng 4: VaR và ES mô phỏng lịch sử tại ngày cuối mẫu</strong></p>
<table style="width:85%;">
<colgroup>
<col style="width: 28%" />
<col style="width: 28%" />
<col style="width: 28%" />
</colgroup>
<thead>
<tr>
<th style="text-align: center;">Mức tin cậy</th>
<th style="text-align: center;">VaR (% giá trị danh mục)</th>
<th style="text-align: center;">ES (% giá trị danh mục)</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: center;">95%</td>
<td style="text-align: center;">1,677</td>
<td style="text-align: center;">3,145</td>
</tr>
<tr>
<td style="text-align: center;">99%</td>
<td style="text-align: center;">4,005</td>
<td style="text-align: center;">6,023</td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>

**Bảng 4 báo cáo VaR/ES tại ngày cuối mẫu. Bảng này có ý nghĩa minh họa thực hành: nếu nhà đầu tư nắm giữ danh mục mô phỏng VN-Index trị giá 100 tỷ đồng, VaR 99% bằng 3% nghĩa là tổn thất một ngày được dự báo không vượt quá khoảng 3 tỷ đồng với xác suất 99%, trong điều kiện mô hình đúng và điều kiện thị trường không thay đổi mạnh so với cửa sổ ước lượng.**

## **1.4 KẾT QUẢ VAR TỪ MÔ HÌNH THAM SỐ VÀ GARCH-TYPE VAR**

Nhóm mô hình tham số bắt đầu từ normal rolling VaR và Student-t rolling VaR. Normal rolling VaR dùng trung bình và độ lệch chuẩn trong cửa sổ rolling, giả định tỷ lệ sinh lời có điều kiện gần chuẩn. Student-t rolling VaR giữ cấu trúc location-scale nhưng thay phân phối chuẩn bằng Student-t chuẩn hóa, do đó cho phép đuôi dày hơn. Trong chương này, bậc tự do của Student-t được suy ra từ excess kurtosis trong cửa sổ rolling và được giới hạn trong khoảng hợp lý để tránh ước lượng quá bất ổn.

Nhóm mô hình động gồm EWMA-normal, GARCH-t và GJR-GARCH-t. EWMA cho trọng số lớn hơn cho quan sát gần nhất, phù hợp khi volatility thay đổi nhanh. GARCH-t mô hình hóa phương sai có điều kiện và phân phối đuôi dày. GJR-GARCH-t bổ sung bất đối xứng: cú sốc âm có thể làm volatility tăng mạnh hơn cú sốc dương. Đây là đặc điểm thường được ghi nhận trong thị trường cổ phiếu và đặc biệt đáng kiểm tra với VN-Index.

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><embed src="media/rId28.pdf" style="width:5.83333in;height:3.49392in" />
<p><strong>Hình 4: So sánh VaR 99% từ các mô hình tham số và GARCH-type VaR</strong></p></td>
</tr>
</tbody>
</table>

**Hình 4 cho phép đánh giá trực quan độ nhạy của các mô hình tham số. Normal rolling thường phản ứng chậm nếu độ lệch chuẩn trong cửa sổ chưa kịp cập nhật. EWMA và GARCH-type VaR có xu hướng thay đổi linh hoạt hơn khi volatility tăng. Tuy nhiên, linh hoạt hơn không đồng nghĩa với chính xác hơn; mô hình cần được đánh giá bằng tỷ lệ vi phạm và kiểm định backtesting ở phần sau.**

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><p><strong>Bảng 5: VaR 99% tại ngày cuối mẫu từ các mô hình tham số và GARCH-type VaR</strong></p>
<table style="width:85%;">
<colgroup>
<col style="width: 28%" />
<col style="width: 28%" />
<col style="width: 28%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Mô hình</th>
<th style="text-align: center;">VaR 99%</th>
<th style="text-align: center;">ES 99%</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">Normal rolling</td>
<td style="text-align: center;">2,740</td>
<td style="text-align: center;">3,151</td>
</tr>
<tr>
<td style="text-align: left;">Student-t rolling</td>
<td style="text-align: center;">3,080</td>
<td style="text-align: center;">4,102</td>
</tr>
<tr>
<td style="text-align: left;">EWMA-normal</td>
<td style="text-align: center;">2,600</td>
<td style="text-align: center;">2,991</td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>

**Bảng 5 không nên được đọc như bảng xếp hạng mô hình. Một mô hình có VaR cao hơn có thể bảo thủ hơn, nhưng chưa chắc chính xác hơn. Ngược lại, một mô hình có VaR thấp hơn có thể hiệu quả hơn về vốn, nhưng nếu số lần vi phạm quá nhiều thì mô hình không đủ an toàn. Việc xếp hạng cần dựa vào backtesting ngoài mẫu.**

## **1.5 KẾT QUẢ VAR TỪ MÔ HÌNH BÁN THAM SỐ, HỒI QUY PHÂN VỊ VÀ EVT**

Mô hình bán tham số trong chương gồm hồi quy phân vị và EVT-POT. Hồi quy phân vị ước lượng trực tiếp phân vị có điều kiện của tỷ lệ sinh lời. Trong ứng dụng này, phân vị $`\alpha`$ của $`r_{t}`$ được mô hình hóa theo độ lớn biến động ngày trước, lỗ ngày trước và tỷ lệ sinh lời trễ. Cấu trúc này không nhằm tối ưu hóa một mô hình dự báo phức tạp, mà nhằm minh họa một hướng tiếp cận khác: VaR có thể được dự báo trực tiếp từ các biến trạng thái của thị trường, thay vì đi qua phương sai có điều kiện.

EVT-POT tập trung vào vùng đuôi của phân phối lỗ. Trong mỗi cửa sổ rolling, chương này chọn ngưỡng $`u`$ là phân vị 90% của phân phối lỗ, sau đó ước lượng phân phối Generalized Pareto cho phần vượt ngưỡng. VaR 95% và 99% được suy ra từ phần đuôi ước lượng. Cách tiếp cận này phù hợp với câu hỏi rủi ro cực đoan nhưng nhạy với lựa chọn ngưỡng: ngưỡng quá thấp có thể làm sai lệch giả định EVT, ngưỡng quá cao lại làm số quan sát vượt ngưỡng quá ít.

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><embed src="media/rId34.pdf" style="width:5.83333in;height:3.49392in" />
<p><strong>Hình 5: VaR 99% từ hồi quy phân vị và EVT-POT</strong></p></td>
</tr>
</tbody>
</table>

**Hình 5 cho thấy ba cách tiếp cận không tham số/bán tham số có thể tạo ra VaR khác nhau đáng kể. Historical simulation phản ánh toàn bộ phân phối thực nghiệm trong cửa sổ; quantile regression phản ánh trạng thái thị trường qua biến trễ; EVT-POT tập trung vào phần đuôi của lỗ. Nếu EVT-POT tạo VaR cao hơn hẳn ở mức 99%, điều đó thường phản ánh đuôi lỗ dày trong cửa sổ rolling, không nhất thiết là mô hình “bi quan” một cách tùy tiện.**

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><p><strong>Bảng 6: Các mô hình VaR/ES được so sánh trong chương</strong></p>
<table style="width:85%;">
<colgroup>
<col style="width: 12%" />
<col style="width: 16%" />
<col style="width: 39%" />
<col style="width: 15%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Mô hình</th>
<th style="text-align: left;">Loại phương pháp</th>
<th style="text-align: left;">Giả định chính</th>
<th style="text-align: center;">ES được tính trong chương</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">Historical simulation</td>
<td style="text-align: left;">Phi tham số</td>
<td style="text-align: left;">Phân phối quá khứ gần đại diện cho phân phối ngày tới</td>
<td style="text-align: center;">Có</td>
</tr>
<tr>
<td style="text-align: left;">Normal rolling</td>
<td style="text-align: left;">Tham số tĩnh rolling</td>
<td style="text-align: left;">Tỷ lệ sinh lời có điều kiện xấp xỉ chuẩn</td>
<td style="text-align: center;">Có</td>
</tr>
<tr>
<td style="text-align: left;">Student-t rolling</td>
<td style="text-align: left;">Tham số đuôi dày rolling</td>
<td style="text-align: left;">Tỷ lệ sinh lời có điều kiện có đuôi dày Student-t</td>
<td style="text-align: center;">Có</td>
</tr>
<tr>
<td style="text-align: left;">EWMA-normal</td>
<td style="text-align: left;">Volatility động</td>
<td style="text-align: left;">Volatility cập nhật theo trọng số hàm mũ</td>
<td style="text-align: center;">Có</td>
</tr>
<tr>
<td style="text-align: left;">GARCH-t</td>
<td style="text-align: left;">Volatility động</td>
<td style="text-align: left;">Phương sai có điều kiện GARCH; innovation Student-t</td>
<td style="text-align: center;">Không</td>
</tr>
<tr>
<td style="text-align: left;">GJR-GARCH-t</td>
<td style="text-align: left;">Volatility động bất đối xứng</td>
<td style="text-align: left;">Cú sốc âm có thể làm volatility tăng mạnh hơn; innovation Student-t</td>
<td style="text-align: center;">Không</td>
</tr>
<tr>
<td style="text-align: left;">Quantile regression</td>
<td style="text-align: left;">Bán tham số</td>
<td style="text-align: left;">VaR là conditional quantile phụ thuộc biến trạng thái</td>
<td style="text-align: center;">Không</td>
</tr>
<tr>
<td style="text-align: left;">EVT-POT</td>
<td style="text-align: left;">Extreme value</td>
<td style="text-align: left;">Đuôi phân phối lỗ tuân theo GPD trên ngưỡng cao</td>
<td style="text-align: center;">Có</td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>

**Bảng 6 cho thấy chương này không tìm kiếm một mô hình “đúng tuyệt đối”. Mỗi phương pháp có giả định khác nhau, phản ứng khác nhau trước biến động, và tạo ra mức vốn rủi ro khác nhau. Câu hỏi thực nghiệm là mô hình nào có dự báo phân vị đáng tin cậy hơn trên dữ liệu VN-Index.**

## **1.6 BACKTESTING VÀ SO SÁNH MÔ HÌNH**

Backtesting là phần quan trọng nhất của chương thực nghiệm. Một mô hình VaR có thể nhìn hợp lý trên đồ thị nhưng vẫn không đạt yêu cầu nếu tỷ lệ vi phạm quá cao, hoặc nếu các vi phạm tập trung thành cụm. Với mức tin cậy 99%, tỷ lệ vi phạm kỳ vọng là 1%. Nếu tỷ lệ vi phạm thực tế cao hơn đáng kể, mô hình có thể đánh giá thấp rủi ro. Nếu tỷ lệ vi phạm thấp hơn quá nhiều, mô hình có thể quá bảo thủ và làm chi phí vốn rủi ro tăng không cần thiết.

Ba kiểm định được sử dụng. Kiểm định Kupiec đánh giá unconditional coverage, tức số lần vi phạm có phù hợp với xác suất kỳ vọng hay không. Kiểm định Christoffersen đánh giá independence và conditional coverage, tức vi phạm có độc lập theo thời gian hay không. Dynamic Quantile test bổ sung kiểm tra liệu biến vi phạm có thể được giải thích bởi các vi phạm trễ và mức VaR dự báo hay không. Nếu mô hình VaR đúng, chuỗi vi phạm nên gần với một chuỗi Bernoulli độc lập có xác suất $`\alpha`$.

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><p><strong>Bảng 7: Backtesting VaR cho VN-Index theo mô hình và mức tin cậy</strong></p>
<table style="width:85%;">
<colgroup>
<col style="width: 10%" />
<col style="width: 6%" />
<col style="width: 10%" />
<col style="width: 5%" />
<col style="width: 4%" />
<col style="width: 7%" />
<col style="width: 7%" />
<col style="width: 11%" />
<col style="width: 5%" />
<col style="width: 7%" />
<col style="width: 8%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Mô hình</th>
<th style="text-align: center;">Mức tin cậy</th>
<th style="text-align: center;">Số quan sát backtest</th>
<th style="text-align: center;">Số vi phạm</th>
<th style="text-align: center;">Kỳ vọng</th>
<th style="text-align: center;">Tỷ lệ vi phạm</th>
<th style="text-align: center;">Kupiec p-value</th>
<th style="text-align: center;">Christoffersen p-value</th>
<th style="text-align: center;">DQ p-value</th>
<th style="text-align: center;">Quantile loss</th>
<th style="text-align: center;">Kết luận sơ bộ</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">EVT-POT</td>
<td style="text-align: center;">99%</td>
<td style="text-align: center;">3573</td>
<td style="text-align: center;">44</td>
<td style="text-align: center;">35,73</td>
<td style="text-align: center;">1,23%</td>
<td style="text-align: center;">0,1796</td>
<td style="text-align: center;">NA</td>
<td style="text-align: center;">0,0000</td>
<td style="text-align: center;">0,05146</td>
<td style="text-align: center;">Không đủ dữ liệu</td>
</tr>
<tr>
<td style="text-align: left;">EWMA-normal</td>
<td style="text-align: center;">99%</td>
<td style="text-align: center;">3581</td>
<td style="text-align: center;">93</td>
<td style="text-align: center;">35,81</td>
<td style="text-align: center;">2,60%</td>
<td style="text-align: center;">0,0000</td>
<td style="text-align: center;">NA</td>
<td style="text-align: center;">0,1406</td>
<td style="text-align: center;">0,05305</td>
<td style="text-align: center;">Không đủ dữ liệu</td>
</tr>
<tr>
<td style="text-align: left;">Historical simulation</td>
<td style="text-align: center;">99%</td>
<td style="text-align: center;">3581</td>
<td style="text-align: center;">44</td>
<td style="text-align: center;">35,81</td>
<td style="text-align: center;">1,23%</td>
<td style="text-align: center;">0,1842</td>
<td style="text-align: center;">NA</td>
<td style="text-align: center;">0,0000</td>
<td style="text-align: center;">0,05203</td>
<td style="text-align: center;">Không đủ dữ liệu</td>
</tr>
<tr>
<td style="text-align: left;">Normal rolling</td>
<td style="text-align: center;">99%</td>
<td style="text-align: center;">3581</td>
<td style="text-align: center;">98</td>
<td style="text-align: center;">35,81</td>
<td style="text-align: center;">2,74%</td>
<td style="text-align: center;">0,0000</td>
<td style="text-align: center;">NA</td>
<td style="text-align: center;">0,0000</td>
<td style="text-align: center;">0,06008</td>
<td style="text-align: center;">Không đủ dữ liệu</td>
</tr>
<tr>
<td style="text-align: left;">Student-t rolling</td>
<td style="text-align: center;">99%</td>
<td style="text-align: center;">3581</td>
<td style="text-align: center;">79</td>
<td style="text-align: center;">35,81</td>
<td style="text-align: center;">2,21%</td>
<td style="text-align: center;">0,0000</td>
<td style="text-align: center;">NA</td>
<td style="text-align: center;">0,0000</td>
<td style="text-align: center;">0,05604</td>
<td style="text-align: center;">Không đủ dữ liệu</td>
</tr>
<tr>
<td style="text-align: left;">EVT-POT</td>
<td style="text-align: center;">95%</td>
<td style="text-align: center;">3573</td>
<td style="text-align: center;">169</td>
<td style="text-align: center;">178,65</td>
<td style="text-align: center;">4,73%</td>
<td style="text-align: center;">0,4549</td>
<td style="text-align: center;">NA</td>
<td style="text-align: center;">0,0000</td>
<td style="text-align: center;">0,15912</td>
<td style="text-align: center;">Không đủ dữ liệu</td>
</tr>
<tr>
<td style="text-align: left;">EWMA-normal</td>
<td style="text-align: center;">95%</td>
<td style="text-align: center;">3581</td>
<td style="text-align: center;">217</td>
<td style="text-align: center;">179,05</td>
<td style="text-align: center;">6,06%</td>
<td style="text-align: center;">0,0048</td>
<td style="text-align: center;">NA</td>
<td style="text-align: center;">0,0000</td>
<td style="text-align: center;">0,14675</td>
<td style="text-align: center;">Không đủ dữ liệu</td>
</tr>
<tr>
<td style="text-align: left;">Historical simulation</td>
<td style="text-align: center;">95%</td>
<td style="text-align: center;">3581</td>
<td style="text-align: center;">175</td>
<td style="text-align: center;">179,05</td>
<td style="text-align: center;">4,89%</td>
<td style="text-align: center;">0,7553</td>
<td style="text-align: center;">NA</td>
<td style="text-align: center;">0,0000</td>
<td style="text-align: center;">0,15845</td>
<td style="text-align: center;">Không đủ dữ liệu</td>
</tr>
<tr>
<td style="text-align: left;">Normal rolling</td>
<td style="text-align: center;">95%</td>
<td style="text-align: center;">3581</td>
<td style="text-align: center;">179</td>
<td style="text-align: center;">179,05</td>
<td style="text-align: center;">5,00%</td>
<td style="text-align: center;">0,9969</td>
<td style="text-align: center;">NA</td>
<td style="text-align: center;">0,0000</td>
<td style="text-align: center;">0,15713</td>
<td style="text-align: center;">Không đủ dữ liệu</td>
</tr>
<tr>
<td style="text-align: left;">Student-t rolling</td>
<td style="text-align: center;">95%</td>
<td style="text-align: center;">3581</td>
<td style="text-align: center;">194</td>
<td style="text-align: center;">179,05</td>
<td style="text-align: center;">5,42%</td>
<td style="text-align: center;">0,2578</td>
<td style="text-align: center;">NA</td>
<td style="text-align: center;">0,0000</td>
<td style="text-align: center;">0,15747</td>
<td style="text-align: center;">Không đủ dữ liệu</td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>

**Bảng 7 là bảng trọng tâm của chương. Một mô hình tốt không nhất thiết có số vi phạm bằng đúng kỳ vọng, vì dữ liệu thực tế có nhiễu mẫu. Tuy nhiên, mô hình cần tránh hai sai lệch rõ ràng: tỷ lệ vi phạm quá cao, cho thấy đánh giá thấp rủi ro; hoặc tỷ lệ vi phạm quá thấp, cho thấy VaR quá bảo thủ. Nếu Kupiec không bác bỏ nhưng Christoffersen hoặc DQ test bác bỏ, vấn đề có thể không nằm ở số lượng vi phạm mà ở tính phụ thuộc theo thời gian của vi phạm. Điều này thường xảy ra khi mô hình phản ứng chậm với các cụm biến động.**

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><embed src="media/rId41.pdf" style="width:5.83333in;height:3.49392in" />
<p><strong>Hình 6: Tỷ lệ vi phạm VaR so với tỷ lệ kỳ vọng</strong></p></td>
</tr>
</tbody>
</table>

**Hình 6 trực quan hóa mức độ bảo thủ hoặc thiếu bảo thủ của từng mô hình. Cột lớn hơn 1 cho thấy mô hình có nhiều vi phạm hơn kỳ vọng; cột nhỏ hơn 1 cho thấy mô hình bảo thủ hơn. Với VaR 99%, chỉ vài vi phạm bổ sung cũng có thể làm tỷ lệ vi phạm lệch đáng kể vì xác suất tail mục tiêu rất nhỏ.**

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><embed src="media/rId45.pdf" style="width:5.83333in;height:3.49392in" />
<p><strong>Hình 7: So sánh VaR 99% của một số mô hình tiêu biểu</strong></p></td>
</tr>
</tbody>
</table>

**Hình 7 trình bày các mô hình tiêu biểu sau khi đã xét kết quả backtesting. Đây là cách trình bày phù hợp hơn so với việc hiển thị quá nhiều đường VaR trên một đồ thị. Trong báo cáo thực tế, mô hình được dùng cho giám sát rủi ro nên có đồ thị riêng để người quản trị quan sát các ngày vi phạm và các giai đoạn mô hình phản ứng chậm.**

## **1.7 ES, TAIL SEVERITY VÀ DIỄN GIẢI TỔN THẤT VƯỢT VAR**

VaR chỉ trả lời câu hỏi “ngưỡng lỗ là bao nhiêu”. Nó không trả lời đầy đủ câu hỏi “nếu vượt ngưỡng thì lỗ trung bình nghiêm trọng đến mức nào”. Vì vậy, ngoài số lần vi phạm, chương này báo cáo thêm các chỉ tiêu tail severity. Hai chỉ tiêu có ý nghĩa thực tiễn là tỷ lệ trung bình giữa lỗ thực tế và VaR trong các ngày vi phạm, và mức lỗ vượt VaR trung bình. Nếu một mô hình có ít vi phạm nhưng mỗi lần vi phạm đều rất nghiêm trọng, nhà quản trị rủi ro không nên chỉ dựa vào failure rate để kết luận mô hình tốt.

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><p><strong>Bảng 8: Tail severity trong các ngày vi phạm VaR</strong></p>
<table style="width:85%;">
<colgroup>
<col style="width: 13%" />
<col style="width: 7%" />
<col style="width: 7%" />
<col style="width: 13%" />
<col style="width: 14%" />
<col style="width: 11%" />
<col style="width: 6%" />
<col style="width: 10%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Mô hình</th>
<th style="text-align: center;">Mức tin cậy</th>
<th style="text-align: center;">Số vi phạm</th>
<th style="text-align: center;">Lỗ TB khi vi phạm (%)</th>
<th style="text-align: center;">VaR TB khi vi phạm (%)</th>
<th style="text-align: center;">Lỗ vượt VaR TB (%)</th>
<th style="text-align: center;">Lỗ/VaR TB</th>
<th style="text-align: center;">ES TB nếu có (%)</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">EVT-POT</td>
<td style="text-align: center;">99%</td>
<td style="text-align: center;">44</td>
<td style="text-align: center;">4,563</td>
<td style="text-align: center;">3,303</td>
<td style="text-align: center;">1,260</td>
<td style="text-align: center;">1,421</td>
<td style="text-align: center;">4,523</td>
</tr>
<tr>
<td style="text-align: left;">EWMA-normal</td>
<td style="text-align: center;">99%</td>
<td style="text-align: center;">93</td>
<td style="text-align: center;">3,418</td>
<td style="text-align: center;">2,353</td>
<td style="text-align: center;">1,065</td>
<td style="text-align: center;">1,497</td>
<td style="text-align: center;">2,701</td>
</tr>
<tr>
<td style="text-align: left;">Historical simulation</td>
<td style="text-align: center;">99%</td>
<td style="text-align: center;">44</td>
<td style="text-align: center;">4,494</td>
<td style="text-align: center;">3,272</td>
<td style="text-align: center;">1,222</td>
<td style="text-align: center;">1,401</td>
<td style="text-align: center;">4,307</td>
</tr>
<tr>
<td style="text-align: left;">Normal rolling</td>
<td style="text-align: center;">99%</td>
<td style="text-align: center;">98</td>
<td style="text-align: center;">3,777</td>
<td style="text-align: center;">2,567</td>
<td style="text-align: center;">1,209</td>
<td style="text-align: center;">1,498</td>
<td style="text-align: center;">2,947</td>
</tr>
<tr>
<td style="text-align: left;">Student-t rolling</td>
<td style="text-align: center;">99%</td>
<td style="text-align: center;">79</td>
<td style="text-align: center;">4,036</td>
<td style="text-align: center;">2,837</td>
<td style="text-align: center;">1,199</td>
<td style="text-align: center;">1,449</td>
<td style="text-align: center;">3,674</td>
</tr>
<tr>
<td style="text-align: left;">EVT-POT</td>
<td style="text-align: center;">95%</td>
<td style="text-align: center;">169</td>
<td style="text-align: center;">3,102</td>
<td style="text-align: center;">1,864</td>
<td style="text-align: center;">1,238</td>
<td style="text-align: center;">1,715</td>
<td style="text-align: center;">2,945</td>
</tr>
<tr>
<td style="text-align: left;">EWMA-normal</td>
<td style="text-align: center;">95%</td>
<td style="text-align: center;">217</td>
<td style="text-align: center;">2,618</td>
<td style="text-align: center;">1,681</td>
<td style="text-align: center;">0,937</td>
<td style="text-align: center;">1,596</td>
<td style="text-align: center;">2,119</td>
</tr>
<tr>
<td style="text-align: left;">Historical simulation</td>
<td style="text-align: center;">95%</td>
<td style="text-align: center;">175</td>
<td style="text-align: center;">3,064</td>
<td style="text-align: center;">1,827</td>
<td style="text-align: center;">1,237</td>
<td style="text-align: center;">1,730</td>
<td style="text-align: center;">2,943</td>
</tr>
<tr>
<td style="text-align: left;">Normal rolling</td>
<td style="text-align: center;">95%</td>
<td style="text-align: center;">179</td>
<td style="text-align: center;">3,061</td>
<td style="text-align: center;">1,830</td>
<td style="text-align: center;">1,231</td>
<td style="text-align: center;">1,702</td>
<td style="text-align: center;">2,305</td>
</tr>
<tr>
<td style="text-align: left;">Student-t rolling</td>
<td style="text-align: center;">95%</td>
<td style="text-align: center;">194</td>
<td style="text-align: center;">2,963</td>
<td style="text-align: center;">1,760</td>
<td style="text-align: center;">1,203</td>
<td style="text-align: center;">1,715</td>
<td style="text-align: center;">2,474</td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>

**Bảng 8 bổ sung góc nhìn mà backtesting VaR không thể hiện đầy đủ. Nếu tỷ lệ Lỗ/VaR TB lớn hơn nhiều so với 1, các ngày vi phạm có mức lỗ lớn hơn đáng kể so với ngưỡng dự báo. Trong trường hợp đó, ES hoặc các chỉ tiêu tail severity nên được dùng cùng VaR trong quản trị rủi ro. Với thị trường Việt Nam, điều này đặc biệt quan trọng trong các giai đoạn bán tháo, khi mức lỗ vượt ngưỡng có thể lớn hơn nhiều so với ngưỡng VaR dự báo từ dữ liệu bình thường trước đó.**

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><embed src="media/rId51.pdf" style="width:5.83333in;height:3.49392in" />
<p><strong>Hình 8: Mức lỗ vượt VaR trung bình trong các ngày vi phạm</strong></p></td>
</tr>
</tbody>
</table>

**Hình 8 cho thấy rủi ro đuôi không chỉ là xác suất vi phạm. Hai mô hình có số vi phạm tương tự có thể khác nhau mạnh về mức lỗ vượt VaR. Trong quản trị vốn, đây là lý do ES và stress testing nên được sử dụng như các công cụ bổ sung cho VaR.**

## **1.8 HÀM Ý CHO QUẢN TRỊ RỦI RO TRÊN THỊ TRƯỜNG CHỨNG KHOÁN VIỆT NAM**

Kết quả thực nghiệm trong chương này cần được diễn giải theo đặc điểm của thị trường Việt Nam. Thứ nhất, thị trường có thể trải qua các giai đoạn thay đổi chế độ biến động khá rõ: giai đoạn tăng trưởng mạnh, giai đoạn điều chỉnh thanh khoản, giai đoạn cú sốc vĩ mô hoặc cú sốc bên ngoài. Trong các giai đoạn đó, mô hình dùng cửa sổ quá dài có thể phản ứng chậm, còn mô hình dùng cửa sổ quá ngắn có thể quá nhạy với nhiễu. Vì vậy, lựa chọn cửa sổ rolling không nên được xem là tham số kỹ thuật phụ, mà là một quyết định quản trị rủi ro.

Thứ hai, nếu backtesting cho thấy normal rolling VaR có nhiều vi phạm hơn kỳ vọng ở mức 99%, nguyên nhân thường đến từ đuôi dày và volatility clustering. Khi đó, tổ chức không nên chỉ tăng hệ số an toàn thủ công mà cần chuyển sang mô hình phù hợp hơn, ví dụ Student-t, EWMA, GARCH-type hoặc EVT. Tuy nhiên, nếu EWMA hoặc historical simulation đạt kết quả tương đương GARCH, việc chọn mô hình đơn giản hơn có thể hợp lý hơn về vận hành, minh bạch và khả năng giải thích.

Thứ ba, GARCH-type VaR có ý nghĩa khi volatility thay đổi mạnh theo thời gian. Tuy nhiên, GARCH không tự động giải quyết mọi vấn đề. Nếu innovation vẫn giả định chuẩn, hoặc nếu mô hình không phản ánh cú sốc âm mạnh hơn cú sốc dương, VaR có thể vẫn đánh giá thấp rủi ro trong các giai đoạn thị trường giảm sâu. Vì vậy, nếu dùng GARCH cho VN-Index, nên ưu tiên kiểm tra GARCH-t, GJR-GARCH-t hoặc EGARCH-t thay vì chỉ dùng GARCH-normal.

Thứ tư, EVT-POT hữu ích cho VaR 99% và phân tích rủi ro cực đoan, nhưng không nên dùng một cách cơ học. Mô hình EVT phụ thuộc vào lựa chọn ngưỡng và số quan sát vượt ngưỡng. Trong thực tế, EVT nên được sử dụng như một lớp kiểm tra bổ sung cho vùng đuôi, kết hợp với historical simulation, GARCH-type VaR và stress testing. Nếu EVT cho VaR cao hơn đáng kể so với các mô hình khác, đó là tín hiệu cần rà soát các kịch bản tổn thất cực đoan chứ không nhất thiết là lý do loại bỏ EVT.

Thứ năm, ES và tail severity nên được báo cáo cùng VaR trong báo cáo rủi ro nội bộ. Với nhà đầu tư cá nhân, VaR có thể đủ để đặt ngưỡng cắt lỗ hoặc hạn mức rủi ro. Với công ty chứng khoán, quỹ đầu tư hoặc ngân hàng có danh mục cổ phiếu, chỉ tiêu ES có ý nghĩa hơn vì nó phản ánh quy mô lỗ khi VaR bị vượt. Điều này đặc biệt quan trọng trong thị trường có khả năng xuất hiện giảm điểm liên tiếp và thanh khoản suy giảm đúng vào thời điểm cần thoát vị thế.

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><p><strong>Bảng 9: Hàm ý quản trị rủi ro từ so sánh mô hình VaR/ES cho VN-Index</strong></p>
<table style="width:85%;">
<colgroup>
<col style="width: 20%" />
<col style="width: 64%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Vấn đề thực tiễn</th>
<th style="text-align: left;">Hàm ý đề xuất</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">Thay đổi chế độ biến động</td>
<td style="text-align: left;">Dùng rolling window và backtesting định kỳ; kiểm tra độ nhạy với cửa sổ 250/500/750 ngày.</td>
</tr>
<tr>
<td style="text-align: left;">Đuôi dày và ngày giảm cực đoan</td>
<td style="text-align: left;">Không chỉ dựa vào normal VaR; bổ sung Student-t, EVT hoặc GARCH với phân phối đuôi dày.</td>
</tr>
<tr>
<td style="text-align: left;">Cụm vi phạm VaR</td>
<td style="text-align: left;">Nếu Christoffersen hoặc DQ test bác bỏ, cần xem lại tốc độ phản ứng của mô hình volatility.</td>
</tr>
<tr>
<td style="text-align: left;">Đánh đổi giữa đơn giản và phức tạp</td>
<td style="text-align: left;">Giữ Historical Simulation và EWMA làm benchmark; chỉ dùng GARCH phức tạp hơn nếu có giá trị backtesting rõ ràng.</td>
</tr>
<tr>
<td style="text-align: left;">Quản trị vốn và giới hạn rủi ro</td>
<td style="text-align: left;">VaR phù hợp để đặt hạn mức; ES phù hợp để đánh giá tổn thất khi vượt hạn mức.</td>
</tr>
<tr>
<td style="text-align: left;">Báo cáo rủi ro nội bộ</td>
<td style="text-align: left;">Báo cáo nên gồm VaR, ES, số vi phạm, tail severity, và đồ thị các ngày vượt VaR.</td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>

**Bảng 9 chuyển kết quả định lượng thành gợi ý thực hành. Với thị trường Việt Nam, mô hình VaR nên được xem là một quy trình quản trị rủi ro động: dữ liệu được cập nhật hằng ngày, VaR được tính lại, vi phạm được ghi nhận, mô hình được backtest định kỳ và các tham số được rà soát khi thị trường thay đổi chế độ.**

## **1.9 TÓM LƯỢC CHƯƠNG**

Chương này đã áp dụng khung phương pháp của Chương 4 vào VN-Index. Thiết kế thực nghiệm sử dụng log return ngày, kỳ nắm giữ một ngày, mức tin cậy 95% và 99%, cùng cửa sổ rolling 500 ngày. Các mô hình được so sánh gồm Historical Simulation, Normal rolling, Student-t rolling, EWMA-normal, GARCH-t, GJR-GARCH-t, Quantile Regression và EVT-POT.

Kết quả chương cần được đọc theo logic so sánh ngoài mẫu. Một mô hình được xem là phù hợp hơn nếu có tỷ lệ vi phạm gần xác suất kỳ vọng, không tạo cụm vi phạm rõ rệt, có quantile loss thấp, và không tạo tail severity quá lớn trong các ngày vi phạm. Nếu mô hình phức tạp không cải thiện rõ ràng so với mô hình đơn giản, lựa chọn mô hình đơn giản hơn có thể hợp lý hơn trong môi trường quản trị rủi ro thực tế. Ngược lại, nếu dữ liệu cho thấy volatility clustering, đuôi dày và bất đối xứng mạnh, các mô hình Student-t, GARCH bất đối xứng hoặc EVT cần được ưu tiên trong hệ thống cảnh báo rủi ro.

Chương tiếp theo có thể mở rộng phân tích từ chỉ số thị trường sang danh mục cổ phiếu, danh mục cổ phiếu–trái phiếu, hoặc danh mục có yếu tố phòng vệ như vàng và tỷ giá. Khi chuyển từ một chỉ số sang danh mục nhiều tài sản, vấn đề không chỉ là volatility riêng lẻ mà còn là tương quan động, tail dependence và hiệu ứng đa dạng hóa trong giai đoạn khủng hoảng.

Adegboyo, O. S., & Sarwar, K. (2025). Modelling and forecasting of nigeria stock market volatility. Future Business Journal, 11, 124. <https://doi.org/10.1186/s43093-025-00536-4>

Alexander, C., & Dakos, M. (2023). Assessing the accuracy of exponentially weighted moving average models for value-at-risk and expected shortfall of crypto portfolios. Quantitative Finance, 23(3), 393–427. <https://doi.org/10.1080/14697688.2022.2159505>

Brooks, C. (2019). Introductory econometrics for finance (4th ed.). Cambridge University Press.

Chakraborty, G., Chandrashekhar, G. R., & Balasubramanian, G. (2021). Measurement of extreme market risk: Insights from a comprehensive literature review. Cogent Economics & Finance, 9(1), 1920150. <https://doi.org/10.1080/23322039.2021.1920150>

Ding, J., & Meade, N. (2010). Forecasting accuracy of stochastic volatility, GARCH and EWMA models under different volatility scenarios. Applied Financial Economics, 20(10), 771–783. <https://doi.org/10.1080/09603101003636188>

Gupta, H. (2025). Analysing volatility patterns in emerging markets: Symmetric or asymmetric models? Journal of Economic and Administrative Sciences, 41(5), 1928–1946. <https://doi.org/10.1108/JEAS-07-2023-0186>

Likitratcharoen, D., & Suwannamalik, L. (2024). Assessing financial stability in turbulent times: A study of generalized autoregressive conditional heteroskedasticity-type value-at-risk model performance in thailand’s transportation sector during COVID-19. Risks, 12(3), 51. <https://doi.org/10.3390/risks12030051>

Nolde, N., & Zhou, C. (2021). Extreme value analysis for financial risk management. Annual Review of Statistics and Its Application, 8, 217–240. <https://doi.org/10.1146/annurev-statistics-042720-015705>

Tian, D., Cai, Z., & Fang, Y. (2019). Econometric modeling of risk measures: A selective review of the recent literature. Applied Mathematics-A Journal of Chinese Universities, 34(2), 205–228. <https://doi.org/10.1007/s11766-019-3628-9>

Tsay, R. S. (2013). An introduction to analysis of financial data with r. John Wiley & Sons.
