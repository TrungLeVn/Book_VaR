**Chương 4**

# **MÔ HÌNH ĐO LƯỜNG GIÁ TRỊ CHỊU RỦI RO VÀ TỔN THẤT KỲ VỌNG**

Chương 1 đã giới thiệu tỷ lệ sinh lời, phân phối tỷ lệ sinh lời và ý nghĩa trực giác của Giá trị chịu rủi ro (*Value-at-Risk*, VaR) trong quản trị rủi ro thị trường. Chương 2 trình bày các mô hình đo lường và dự báo volatility, còn Chương 3 áp dụng các mô hình volatility cho VN-Index. Chương này chuyển trọng tâm sang **mô hình đo lường rủi ro đuôi** (*tail risk models*), trong đó hai thước đo trung tâm là **VaR** và **Tổn thất kỳ vọng** (*Expected Shortfall*, ES).

Về mặt phương pháp, VaR và ES không tách rời khỏi volatility. Hầu hết mô hình VaR đều cần một cách mô tả phân phối tỷ lệ sinh lời hoặc phân phối lỗ trong tương lai. Phân phối này có thể được xây dựng từ dữ liệu lịch sử, từ giả định tham số như chuẩn hoặc Student-t, từ mô phỏng Monte Carlo, từ mô hình volatility có điều kiện như EWMA/GARCH, hoặc từ mô hình trực tiếp của phân vị có điều kiện. Vì vậy, Chương 4 đóng vai trò là chương nền tảng cho Chương 5: Chương 4 giải thích cơ chế mô hình, còn Chương 5 sẽ dùng cùng khung phương pháp để đánh giá VaR và ES thực nghiệm cho VN-Index (Brooks, 2019; Choudhry, 2013; Jorion, 2007; Tsay, 2010, 2013).

Chương này sử dụng chuỗi tỷ lệ sinh lời mô phỏng để minh họa. Mục tiêu không phải là đưa ra kết luận về một thị trường cụ thể, mà là giúp người đọc hiểu rõ: VaR và ES được định nghĩa như thế nào; historical simulation, parametric VaR, GARCH VaR và semi-parametric VaR khác nhau ra sao; vì sao giả định phân phối ảnh hưởng mạnh đến rủi ro đuôi; và tại sao mọi mô hình VaR phải được kiểm định ngược trước khi sử dụng trong quản trị rủi ro.

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><p><strong>Bảng 1: Thông tin chuỗi tỷ lệ sinh lời mô phỏng sử dụng trong Chương 4</strong></p>
<table style="width:85%;">
<colgroup>
<col style="width: 19%" />
<col style="width: 64%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Nội dung</th>
<th style="text-align: left;">Thông tin</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">Loại dữ liệu</td>
<td style="text-align: left;">Chuỗi tỷ lệ sinh lời mô phỏng</td>
</tr>
<tr>
<td style="text-align: left;">Số quan sát</td>
<td style="text-align: left;">1.600</td>
</tr>
<tr>
<td style="text-align: left;">Cấu trúc mô phỏng</td>
<td style="text-align: left;">Volatility có điều kiện với cú sốc Student-t</td>
</tr>
<tr>
<td style="text-align: left;">Đặc điểm chính</td>
<td style="text-align: left;">Volatility clustering, đuôi dày, phản ứng bất đối xứng với cú sốc âm</td>
</tr>
<tr>
<td style="text-align: left;">Vai trò trong chương</td>
<td style="text-align: left;">Minh họa VaR, ES, mô hình VaR động và backtesting</td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>

**Bảng 1 mô tả dữ liệu minh họa của chương. Việc sử dụng chuỗi mô phỏng có chủ đích giúp tách phần phương pháp khỏi phần kết luận thực nghiệm. Trong dữ liệu thực, volatility thật không quan sát được; trong dữ liệu mô phỏng, volatility được tạo ra từ quá trình có điều kiện, vì vậy người học có thể thấy rõ tại sao VaR cần thay đổi khi điều kiện thị trường thay đổi.**

Gọi $`r_{t + 1}`$ là tỷ lệ sinh lời của tài sản hoặc danh mục trong kỳ tiếp theo. Nếu xét rủi ro theo biến lỗ, ta định nghĩa:

``` math
L_{t + 1} = - r_{t + 1}.
```

Với mức tin cậy $`1 - \alpha`$, VaR là phân vị mức $`1 - \alpha`$ của phân phối lỗ:

``` math
VaR_{1 - \alpha} = q_{1 - \alpha}(L_{t + 1}).
```

Cách diễn giải là: nếu mô hình phân phối được chỉ định đúng, xác suất lỗ vượt VaR bằng $`\alpha`$:

``` math
P(L_{t + 1} > VaR_{1 - \alpha}) = \alpha.
```

Nếu làm việc trực tiếp với tỷ lệ sinh lời, VaR được viết thông qua phân vị đuôi trái của tỷ lệ sinh lời:

``` math
VaR_{1 - \alpha}^{return} = - q_{\alpha}(r_{t + 1}).
```

VaR là một ngưỡng tổn thất, nhưng không cho biết mức lỗ trung bình khi khoản lỗ đã vượt qua ngưỡng đó. **Expected Shortfall** bổ sung thông tin này bằng cách đo lường mức lỗ kỳ vọng trong vùng tổn thất vượt VaR:

``` math
ES_{1 - \alpha} = E(L_{t + 1} \mid L_{t + 1} > VaR_{1 - \alpha}).
```

Trong quản trị rủi ro, ES thường được xem là thước đo thận trọng hơn VaR vì nó phản ánh mức độ nghiêm trọng của các tổn thất nằm ngoài ngưỡng VaR. Điểm này đặc biệt quan trọng khi phân phối tỷ lệ sinh lời có đuôi dày, vì hai mô hình có cùng số lần vượt VaR vẫn có thể tạo ra mức tổn thất vượt ngưỡng rất khác nhau (Acerbi & Tasche, 2002; Tsay, 2013).

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><embed src="media/rId10.pdf" style="width:5.83333in;height:3.49392in" />
<p><strong>Hình 1: VaR là ngưỡng phân vị, ES là tổn thất trung bình trong vùng vượt ngưỡng</strong></p></td>
</tr>
</tbody>
</table>

**Hình 1 nhấn mạnh sự khác biệt giữa hai thước đo. VaR trả lời câu hỏi “ngưỡng lỗ tại mức xác suất cho trước là bao nhiêu?”, trong khi ES trả lời câu hỏi “nếu tổn thất vượt ngưỡng đó, mức lỗ trung bình là bao nhiêu?”. Vì vậy, VaR phù hợp để mô tả tần suất vượt ngưỡng, còn ES phù hợp hơn để mô tả mức độ nghiêm trọng của tổn thất đuôi.**

## **1.1 MÔ HÌNH MÔ PHỎNG LỊCH SỬ**

### **1.1.1 Mô hình mô phỏng lịch sử với VaR**

**Mô phỏng lịch sử** (*historical simulation*) là phương pháp tính VaR trực tiếp từ phân phối thực nghiệm của tỷ lệ sinh lời quá khứ. Với chuỗi tỷ lệ sinh lời $`r_{1},\ldots,r_{T}`$, ta sắp xếp các quan sát từ thấp đến cao và lấy phân vị đuôi trái mức $`\alpha`$. Nếu làm việc với tỷ lệ sinh lời, VaR lịch sử được xác định bởi:

``` math
VaR_{1 - \alpha}^{HS} = - {\widehat{q}}_{\alpha}(r_{1},\ldots,r_{T}).
```

Nếu làm việc với biến lỗ $`L_{t} = - r_{t}`$, công thức tương đương là:

``` math
VaR_{1 - \alpha}^{HS} = {\widehat{q}}_{1 - \alpha}(L_{1},\ldots,L_{T}).
```

Ưu điểm chính của phương pháp này là không cần giả định phân phối chuẩn, Student-t hay bất kỳ phân phối tham số nào. Toàn bộ thông tin về đuôi dày, bất đối xứng và các cú sốc lớn được lấy trực tiếp từ dữ liệu quá khứ. Đây là lý do mô phỏng lịch sử thường được dùng làm benchmark trong các nghiên cứu VaR và trong thực hành quản trị rủi ro (Choudhry, 2013; Tsay, 2013).

Tuy nhiên, phương pháp này có hai hạn chế quan trọng. Thứ nhất, nó phụ thuộc mạnh vào độ dài cửa sổ dữ liệu. Cửa sổ quá ngắn làm VaR nhiễu; cửa sổ quá dài làm VaR phản ứng chậm với thay đổi chế độ thị trường. Thứ hai, mô phỏng lịch sử giả định quá khứ đại diện cho tương lai. Nếu giai đoạn lịch sử không chứa khủng hoảng, VaR có thể đánh giá thấp rủi ro; nếu chứa một cú sốc cực đoan rất cũ, VaR có thể duy trì ở mức cao cho đến khi cú sốc đó rơi ra khỏi cửa sổ tính toán.

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><p><strong>Bảng 2: Các biến thể thường gặp của mô phỏng lịch sử</strong></p>
<table style="width:85%;">
<colgroup>
<col style="width: 11%" />
<col style="width: 30%" />
<col style="width: 21%" />
<col style="width: 21%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Biến thể</th>
<th style="text-align: left;">Cách thực hiện</th>
<th style="text-align: left;">Điểm mạnh</th>
<th style="text-align: left;">Hạn chế</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">Historical simulation toàn mẫu</td>
<td style="text-align: left;">Dùng toàn bộ dữ liệu quá khứ để lấy phân vị thực nghiệm</td>
<td style="text-align: left;">Đơn giản, dễ giải thích</td>
<td style="text-align: left;">Phản ứng chậm với structural breaks</td>
</tr>
<tr>
<td style="text-align: left;">Rolling historical simulation</td>
<td style="text-align: left;">Dùng cửa sổ trượt gồm các quan sát gần nhất</td>
<td style="text-align: left;">Cập nhật theo điều kiện thị trường gần đây</td>
<td style="text-align: left;">Nhạy với lựa chọn độ dài cửa sổ</td>
</tr>
<tr>
<td style="text-align: left;">Weighted historical simulation</td>
<td style="text-align: left;">Gán trọng số lớn hơn cho quan sát gần hiện tại</td>
<td style="text-align: left;">Phản ứng nhanh hơn với thay đổi volatility</td>
<td style="text-align: left;">Cần chọn quy luật trọng số</td>
</tr>
<tr>
<td style="text-align: left;">Filtered historical simulation</td>
<td style="text-align: left;">Chuẩn hóa tỷ lệ sinh lời bằng volatility động rồi tái nhân với volatility dự báo</td>
<td style="text-align: left;">Kết hợp ưu điểm của mô phỏng lịch sử và mô hình volatility</td>
<td style="text-align: left;">Phụ thuộc vào mô hình volatility được dùng để lọc dữ liệu</td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>

**Bảng 2 cho thấy mô phỏng lịch sử không chỉ có một cách triển khai. Trong Chương 5, khi áp dụng cho VN-Index, rolling historical simulation nên được sử dụng như một benchmark vì nó phản ánh cách nhà quản trị rủi ro cập nhật VaR theo thời gian.**

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><p><strong>Bảng 3: VaR theo mô phỏng lịch sử</strong></p>
<table style="width:85%;">
<colgroup>
<col style="width: 21%" />
<col style="width: 21%" />
<col style="width: 21%" />
<col style="width: 21%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Phương pháp</th>
<th style="text-align: left;">Mức tin cậy</th>
<th style="text-align: right;">VaR, tỷ lệ</th>
<th style="text-align: right;">VaR, danh mục 100 tỷ đồng</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">Mô phỏng lịch sử</td>
<td style="text-align: left;">99,00%</td>
<td style="text-align: right;">2,34%</td>
<td style="text-align: right;">2.336.393.002 đồng</td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>

**Bảng 3 minh họa cách chuyển VaR từ tỷ lệ sang giá trị tiền tệ. Nếu danh mục có giá trị 100 tỷ đồng, VaR tỷ lệ được nhân trực tiếp với giá trị danh mục để có mức tổn thất tiền tệ tương ứng. Trong thực tế, phép chuyển đổi này chỉ đúng khi VaR được tính cho tỷ lệ sinh lời của chính danh mục đang xét.**

### **1.1.2 Mô hình mô phỏng lịch sử với ES**

Historical simulation cũng có thể dùng để tính ES. Sau khi xác định phân vị $`{\widehat{q}}_{\alpha}`$ của tỷ lệ sinh lời, ES lịch sử là trung bình của các tỷ lệ sinh lời nằm trong vùng đuôi trái:

``` math
ES_{1 - \alpha}^{HS} = - \frac{1}{N_{\alpha}}\sum_{t:r_{t} \leq {\widehat{q}}_{\alpha}}^{}r_{t},
```

trong đó $`N_{\alpha}`$ là số quan sát nằm trong vùng vượt ngưỡng. Nếu làm việc với biến lỗ, công thức có dạng:

``` math
ES_{1 - \alpha}^{HS} = \frac{1}{N_{\alpha}}\sum_{t:L_{t} \geq {\widehat{VaR}}_{1 - \alpha}}^{}L_{t}.
```

Điểm khác biệt cốt lõi là VaR chỉ sử dụng vị trí của phân vị, còn ES sử dụng thông tin của toàn bộ các quan sát vượt ngưỡng. Vì vậy, ES nhạy hơn với độ nghiêm trọng của rủi ro đuôi. Đây là lý do ES thường được xem là bổ sung cần thiết cho VaR, đặc biệt trong bối cảnh VaR có thể không phản ánh đầy đủ mức tổn thất cực đoan sau khi ngưỡng đã bị vượt qua (Tsay, 2010, 2013).

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><p><strong>Bảng 4: VaR và ES theo mô phỏng lịch sử</strong></p>
<table style="width:85%;">
<colgroup>
<col style="width: 14%" />
<col style="width: 10%" />
<col style="width: 9%" />
<col style="width: 8%" />
<col style="width: 21%" />
<col style="width: 21%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Phương pháp</th>
<th style="text-align: left;">Mức tin cậy</th>
<th style="text-align: right;">VaR, tỷ lệ</th>
<th style="text-align: right;">ES, tỷ lệ</th>
<th style="text-align: right;">VaR, danh mục 100 tỷ đồng</th>
<th style="text-align: right;">ES, danh mục 100 tỷ đồng</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">Mô phỏng lịch sử</td>
<td style="text-align: left;">99,00%</td>
<td style="text-align: right;">2,34%</td>
<td style="text-align: right;">3,44%</td>
<td style="text-align: right;">2.336.393.002 đồng</td>
<td style="text-align: right;">3.437.792.946 đồng</td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>

**Bảng 4 cho thấy ES lớn hơn VaR vì ES là trung bình của vùng tổn thất nghiêm trọng hơn VaR. Khi diễn giải cho nhà quản trị rủi ro, có thể nói: VaR là ngưỡng cảnh báo, còn ES là mức tổn thất trung bình trong các tình huống ngưỡng cảnh báo bị phá vỡ.**

## **1.2 MÔ HÌNH THAM SỐ**

### **1.2.1 Mô hình biến động giản đơn**

Phương pháp tham số bắt đầu từ giả định về phân phối tỷ lệ sinh lời. Trường hợp đơn giản nhất là giả định tỷ lệ sinh lời có điều kiện tuân theo phân phối chuẩn:

``` math
r_{t + 1} \mid \mathcal{F}_{t} \sim N(\mu_{t + 1},\sigma_{t + 1}^{2}).
```

Khi đó, VaR theo tỷ lệ ở mức tin cậy $`1 - \alpha`$ là:

``` math
VaR_{1 - \alpha,t + 1}^{N} = - \left( \mu_{t + 1} + z_{\alpha}\sigma_{t + 1} \right),
```

trong đó $`z_{\alpha}`$ là phân vị mức $`\alpha`$ của phân phối chuẩn chuẩn hóa. Với $`\alpha = 0,01`$, $`z_{0.01} \approx - 2,33`$.

ES dưới giả định chuẩn được tính bởi:

``` math
ES_{1 - \alpha,t + 1}^{N} = - \left( \mu_{t + 1} - \sigma_{t + 1}\frac{\phi(z_{\alpha})}{\alpha} \right),
```

trong đó $`\phi( \cdot )`$ là hàm mật độ của phân phối chuẩn chuẩn hóa.

Mô hình chuẩn có ưu điểm là đơn giản và dễ triển khai. Tuy nhiên, tỷ lệ sinh lời tài chính thường có đuôi dày và bất đối xứng. Khi đó, phân phối Student-t có thể phù hợp hơn vì cho phép xác suất xuất hiện cú sốc cực đoan cao hơn phân phối chuẩn. Với cùng volatility, Student-t thường tạo VaR và ES lớn hơn ở vùng đuôi xa (Brooks, 2019; Tsay, 2010).

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><p><strong>Bảng 5: VaR và ES tham số dưới giả định chuẩn và Student-t</strong></p>
<table style="width:85%;">
<colgroup>
<col style="width: 9%" />
<col style="width: 14%" />
<col style="width: 13%" />
<col style="width: 24%" />
<col style="width: 23%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Phân phối</th>
<th style="text-align: right;">VaR 99%, tỷ lệ</th>
<th style="text-align: right;">ES 99%, tỷ lệ</th>
<th style="text-align: right;">VaR, danh mục 100 tỷ đồng</th>
<th style="text-align: right;">ES, danh mục 100 tỷ đồng</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">Chuẩn</td>
<td style="text-align: right;">2,00%</td>
<td style="text-align: right;">2,29%</td>
<td style="text-align: right;">1.998.017.854 đồng</td>
<td style="text-align: right;">2.291.885.340 đồng</td>
</tr>
<tr>
<td style="text-align: left;">Student-t</td>
<td style="text-align: right;">2,21%</td>
<td style="text-align: right;">2,84%</td>
<td style="text-align: right;">2.205.826.936 đồng</td>
<td style="text-align: right;">2.835.911.443 đồng</td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>

**Bảng 5 cho thấy vai trò của giả định phân phối. Nếu dữ liệu có đuôi dày, VaR và ES dựa trên Student-t thường thận trọng hơn so với giả định chuẩn. Đây là lý do trong thực nghiệm tài chính, mô hình normal VaR thường nên được xem như benchmark, không nên là mô hình duy nhất.**

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><embed src="media/rId21.pdf" style="width:5.83333in;height:3.49392in" />
<p><strong>Hình 2: Tác động của phân phối đuôi dày đến VaR</strong></p></td>
</tr>
</tbody>
</table>

**Hình 2 minh họa trực quan tác động của giả định phân phối. Khi phân phối có đuôi dày, vùng tổn thất cực đoan có xác suất lớn hơn so với phân phối chuẩn, làm ngưỡng VaR dịch sâu hơn về phía đuôi trái của tỷ lệ sinh lời.**

### **1.2.2 Mô hình GARCH**

Mô hình tham số ở trên sử dụng một volatility cố định cho toàn bộ mẫu. Cách tiếp cận đó không phù hợp khi dữ liệu có volatility clustering. Trong quản trị rủi ro ngắn hạn, VaR phải phản ứng với điều kiện thị trường hiện tại: khi volatility tăng, VaR tăng; khi volatility giảm, VaR giảm. Do đó, mô hình volatility có điều kiện như EWMA, GARCH, GJR-GARCH hoặc EGARCH là đầu vào tự nhiên cho VaR động (Brooks, 2019; Ding & Meade, 2010; Tsay, 2013).

Nếu mô hình cung cấp dự báo một bước trước $`{\widehat{\sigma}}_{t + 1|t}`$, conditional VaR có thể viết:

``` math
VaR_{1 - \alpha,t + 1} = - \left( {\widehat{\mu}}_{t + 1|t} + q_{\alpha}{\widehat{\sigma}}_{t + 1|t} \right),
```

trong đó $`q_{\alpha}`$ là phân vị của sai số chuẩn hóa. Nếu sai số chuẩn hóa là chuẩn, $`q_{\alpha} = z_{\alpha}`$. Nếu sai số theo Student-t chuẩn hóa, $`q_{\alpha}`$ là phân vị Student-t đã chuẩn hóa.

Với GARCH(1,1), phương trình volatility thường được viết:

``` math
\sigma_{t}^{2} = \omega + \alpha\varepsilon_{t - 1}^{2} + \beta\sigma_{t - 1}^{2}.
```

Với GJR-GARCH, tác động bất đối xứng của cú sốc âm được đưa vào thông qua biến chỉ báo:

``` math
\sigma_{t}^{2} = \omega + \alpha\varepsilon_{t - 1}^{2} + \gamma I(\varepsilon_{t - 1} < 0)\varepsilon_{t - 1}^{2} + \beta\sigma_{t - 1}^{2}.
```

Nếu $`\gamma > 0`$, cú sốc âm làm volatility tăng mạnh hơn cú sốc dương có cùng độ lớn. Đây là đặc điểm thường gặp ở thị trường cổ phiếu và đặc biệt quan trọng khi ước lượng VaR cho các thị trường mới nổi.

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><embed src="media/rId26.pdf" style="width:5.83333in;height:3.49392in" />
<p><strong>Hình 3: VaR động từ các phương pháp khác nhau</strong></p></td>
</tr>
</tbody>
</table>

**Hình 3 cho thấy VaR động thay đổi theo điều kiện volatility. Nếu VaR phản ứng quá chậm, số lần lỗ vượt VaR có thể tăng trong giai đoạn biến động mạnh. Nếu VaR quá bảo thủ, tổ chức có thể giữ vốn rủi ro quá lớn so với nhu cầu thực tế.**

## **1.3 MÔ HÌNH BÁN THAM SỐ**

### **1.3.1 Giá trị phân vị của phân phối xác suất**

VaR về bản chất là một bài toán phân vị. Vì vậy, trước khi đi vào các mô hình phức tạp, cần phân biệt ba cách hiểu về phân vị.

Thứ nhất, **phân vị thực nghiệm** (*empirical quantile*) được lấy trực tiếp từ dữ liệu đã quan sát. Historical simulation sử dụng đúng logic này. Thứ hai, **phân vị dựa trên mô hình** (*model-based quantile*) được suy ra từ một phân phối tham số, chẳng hạn chuẩn hoặc Student-t. Thứ ba, **phân vị có điều kiện** (*conditional quantile*) mô tả phân vị của tỷ lệ sinh lời hoặc biến lỗ sau khi đã biết thông tin tại thời điểm $`t`$.

Ký hiệu $`Q_{\tau}(Y)`$ là phân vị mức $`\tau`$ của biến ngẫu nhiên $`Y`$. Khi $`Y = L_{t + 1}`$ là biến lỗ, VaR ở mức tin cậy $`\tau = 1 - \alpha`$ là:

``` math
VaR_{\tau} = Q_{\tau}(L_{t + 1}).
```

Nếu xét thông tin hiện tại $`\mathcal{F}_{t}`$, VaR động là phân vị có điều kiện:

``` math
VaR_{\tau,t + 1} = Q_{\tau}(L_{t + 1} \mid \mathcal{F}_{t}).
```

Cách viết này cho thấy VaR không bắt buộc phải được xây dựng qua volatility. GARCH VaR là một cách gián tiếp: dự báo volatility trước, sau đó nhân với phân vị của sai số chuẩn hóa. Quantile regression là một cách trực tiếp hơn: mô hình hóa phân vị có điều kiện của lỗ hoặc tỷ lệ sinh lời (Brooks, 2019; Tsay, 2013).

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><p><strong>Bảng 6: Ba cách tiếp cận phân vị trong mô hình VaR</strong></p>
<table style="width:85%;">
<colgroup>
<col style="width: 12%" />
<col style="width: 28%" />
<col style="width: 20%" />
<col style="width: 22%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Loại phân vị</th>
<th style="text-align: left;">Cách tính</th>
<th style="text-align: left;">Ví dụ VaR</th>
<th style="text-align: left;">Hàm ý</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">Phân vị thực nghiệm</td>
<td style="text-align: left;">Sắp xếp dữ liệu lịch sử và lấy quantile</td>
<td style="text-align: left;">Historical simulation VaR</td>
<td style="text-align: left;">Đơn giản nhưng phụ thuộc mẫu lịch sử</td>
</tr>
<tr>
<td style="text-align: left;">Phân vị dựa trên mô hình</td>
<td style="text-align: left;">Ước lượng tham số phân phối rồi lấy quantile lý thuyết</td>
<td style="text-align: left;">Normal VaR, Student-t VaR</td>
<td style="text-align: left;">Rõ công thức nhưng nhạy với giả định phân phối</td>
</tr>
<tr>
<td style="text-align: left;">Phân vị có điều kiện</td>
<td style="text-align: left;">Ước lượng quantile phụ thuộc vào thông tin tại thời điểm t</td>
<td style="text-align: left;">GARCH VaR, quantile regression VaR, CAViaR</td>
<td style="text-align: left;">Phù hợp khi tail risk thay đổi theo thời gian</td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>

**Bảng 6 là cầu nối giữa historical simulation, parametric VaR và các mô hình bán tham số. Điểm chung của các phương pháp là đều đi tìm phân vị của phân phối lỗ; điểm khác nhau nằm ở cách xây dựng phân phối đó.**

### **1.3.2 Mô hình hồi quy phân vị**

Hồi quy phân vị (*quantile regression*) mô hình hóa trực tiếp phân vị có điều kiện của biến phụ thuộc. Nếu biến phụ thuộc là lỗ $`L_{t}`$, mô hình đơn giản có thể viết:

``` math
Q_{\tau}(L_{t} \mid X_{t - 1}) = X_{t - 1}'\beta_{\tau},
```

trong đó $`\tau = 1 - \alpha`$ đối với VaR trên biến lỗ. Khác với OLS mô hình hóa kỳ vọng có điều kiện, hồi quy phân vị mô hình hóa một vị trí cụ thể của phân phối có điều kiện. Vì vậy, nó phù hợp để đo tail risk khi phần đuôi của phân phối phụ thuộc vào các biến giải thích như lỗ quá khứ, volatility quá khứ hoặc biến thị trường.

Về ước lượng, hồi quy phân vị tối thiểu hóa hàm mất mát bất đối xứng:

``` math
\min_{\beta}\sum_{t}^{}\rho_{\tau}(L_{t} - X_{t - 1}'\beta),
```

với:

``` math
\rho_{\tau}(u) = u\left( \tau - I(u < 0) \right).
```

Mô hình dưới đây minh họa một VaR bán tham số, trong đó VaR của lỗ phụ thuộc vào lỗ ngày trước và độ lớn tuyệt đối của tỷ lệ sinh lời ngày trước.

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><p><strong>Bảng 7: Minh họa hệ số mô hình VaR bán tham số bằng hồi quy phân vị</strong></p>
<table style="width:85%;">
<colgroup>
<col style="width: 42%" />
<col style="width: 42%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Biến</th>
<th style="text-align: right;">Hệ số phân vị 99%</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">Hằng số</td>
<td style="text-align: right;">0,01299</td>
</tr>
<tr>
<td style="text-align: left;">Lỗ kỳ trước</td>
<td style="text-align: right;">-0,14977</td>
</tr>
<tr>
<td style="text-align: left;">|Tỷ lệ sinh lời kỳ trước|</td>
<td style="text-align: right;">0,49595</td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>

**Bảng 7 không nhằm diễn giải một thị trường cụ thể. Mục đích là cho thấy VaR có thể được mô hình hóa trực tiếp như một phân vị có điều kiện. Trong Chương 5, cách tiếp cận này có thể được dùng như một mô hình đối chiếu với historical simulation và GARCH-type VaR.**

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><embed src="media/rId35.pdf" style="width:5.83333in;height:3.49392in" />
<p><strong>Hình 4: VaR bán tham số từ hồi quy phân vị</strong></p></td>
</tr>
</tbody>
</table>

**Hình 4 minh họa cách VaR từ hồi quy phân vị thay đổi theo thông tin quá khứ. Ưu điểm của cách tiếp cận này là ít phụ thuộc hơn vào giả định phân phối chuẩn. Hạn chế là kết quả phụ thuộc vào lựa chọn biến giải thích, dạng hàm và độ ổn định của quan hệ giữa các biến giải thích với tail risk.**

## **1.4 KIỂM ĐỊNH ƯỚC LƯỢNG GIÁ TRỊ CHỊU RỦI RO**

### **1.4.1 Phương pháp kiểm định ước lượng VaR**

Một mô hình VaR chỉ hữu ích nếu được kiểm định ngược (*backtesting*). Với VaR ở mức tin cậy $`1 - \alpha`$, biến vi phạm VaR được định nghĩa:

``` math
I_{t} = I(L_{t} > VaR_{t}).
```

Nếu mô hình đúng, $`I_{t}`$ có xác suất nhận giá trị 1 bằng $`\alpha`$. Với VaR 99%, xác suất vi phạm kỳ vọng là 1%. Backtesting không chỉ xem tổng số vi phạm có phù hợp hay không, mà còn xem các vi phạm có độc lập theo thời gian hay không. Nếu các vi phạm tập trung thành cụm, mô hình có thể đang phản ứng chậm với thay đổi volatility (Choudhry, 2013; Christoffersen, 1998; Kupiec, 1995).

Ba tiêu chí cơ bản thường được xem xét là:

- **Unconditional coverage:** tỷ lệ vi phạm thực tế có xấp xỉ $`\alpha`$ hay không.
- **Independence:** các vi phạm có độc lập theo thời gian hay không.
- **Conditional coverage:** mô hình có đồng thời thỏa mãn tỷ lệ vi phạm đúng và tính độc lập của vi phạm hay không.

Ngoài ba tiêu chí này, các nghiên cứu gần đây thường bổ sung hàm mất mát phân vị, kiểm định dynamic quantile và các scoring rules cho cặp VaR–ES (Alexander & Dakos, 2023; Engle & Manganelli, 2004; Fissler & Ziegel, 2016).

### **1.4.2 Kiểm định tính phủ không điều kiện**

Kiểm định Kupiec đánh giá giả thuyết:

``` math
H_{0}:p = \alpha,
```

trong đó $`p`$ là xác suất vi phạm thực tế của mô hình. Nếu $`x`$ là số lần vi phạm trên tổng số $`n`$ quan sát backtesting, tỷ lệ vi phạm mẫu là $`\widehat{p} = x/n`$. Kiểm định so sánh likelihood dưới giả thuyết $`p = \alpha`$ với likelihood dưới giả thuyết thay thế $`p = \widehat{p}`$.

Nếu p-value của kiểm định Kupiec nhỏ, mô hình bị bác bỏ về mặt unconditional coverage. Tuy nhiên, một mô hình có thể có số vi phạm đúng kỳ vọng nhưng các vi phạm lại tập trung thành cụm. Khi đó, cần kiểm định tính độc lập.

### **1.4.3 Kiểm định tính phủ có điều kiện**

Kiểm định Christoffersen mở rộng logic của Kupiec bằng cách xem chuỗi vi phạm như một chuỗi nhị phân. Nếu mô hình phản ứng đúng với thay đổi của rủi ro, vi phạm không nên tạo thành cụm. Nói cách khác, xác suất vi phạm hôm nay không nên phụ thuộc mạnh vào việc hôm qua có vi phạm hay không.

Kiểm định conditional coverage kết hợp hai thành phần: unconditional coverage và independence. Vì vậy, đây là kiểm định nghiêm ngặt hơn Kupiec. Trong thực nghiệm, một mô hình VaR được xem là tốt hơn nếu không bị bác bỏ bởi cả Kupiec và Christoffersen, đồng thời có hàm mất mát dự báo thấp.

### **1.4.4 Kiểm định phân vị biến thiên**

Kiểm định phân vị biến thiên (*dynamic quantile test*) đánh giá liệu chuỗi hit có còn phụ thuộc vào thông tin quá khứ hay không. Ý tưởng trực giác là: nếu VaR là phân vị có điều kiện đúng, phần vi phạm sau khi trừ xác suất kỳ vọng $`\alpha`$ không nên còn dự báo được bằng các biến trễ hoặc bằng chính VaR.

Gọi:

``` math
Hit_{t} = I(L_{t} > VaR_{t}) - \alpha.
```

Nếu mô hình VaR đúng, $`Hit_{t}`$ không nên có cấu trúc động còn sót lại. Có thể kiểm tra điều này bằng cách hồi quy $`Hit_{t}`$ lên các độ trễ của chính nó và các biến thông tin khác. Đây là logic nền tảng của kiểm định Dynamic Quantile và cũng là động cơ của các mô hình CAViaR, trong đó VaR được mô hình hóa trực tiếp như một quá trình phân vị có điều kiện (Engle & Manganelli, 2004).

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><p><strong>Bảng 8: Backtesting VaR 99% theo dạng bảng journal-style</strong></p>
<table style="width:85%;">
<colgroup>
<col style="width: 16%" />
<col style="width: 9%" />
<col style="width: 12%" />
<col style="width: 12%" />
<col style="width: 9%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 5%" />
<col style="width: 5%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Mô hình</th>
<th style="text-align: right;">Số quan sát</th>
<th style="text-align: right;">Vi phạm kỳ vọng</th>
<th style="text-align: right;">Vi phạm thực tế</th>
<th style="text-align: right;">Failure rate</th>
<th style="text-align: right;">QLoss</th>
<th style="text-align: right;">Kupiec p</th>
<th style="text-align: right;">CC p</th>
<th style="text-align: right;">DQ p</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">EWMA-normal</td>
<td style="text-align: right;">600</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">1,67%</td>
<td style="text-align: right;">0.000383</td>
<td style="text-align: right;">0.1342</td>
<td style="text-align: right;">0.1162</td>
<td style="text-align: right;">0.0920</td>
</tr>
<tr>
<td style="text-align: left;">GARCH-t</td>
<td style="text-align: right;">600</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">1,67%</td>
<td style="text-align: right;">0.000394</td>
<td style="text-align: right;">0.1342</td>
<td style="text-align: right;">0.2748</td>
<td style="text-align: right;">0.6785</td>
</tr>
<tr>
<td style="text-align: left;">GJR-GARCH-t</td>
<td style="text-align: right;">600</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">10</td>
<td style="text-align: right;">1,67%</td>
<td style="text-align: right;">0.000402</td>
<td style="text-align: right;">0.1342</td>
<td style="text-align: right;">0.2748</td>
<td style="text-align: right;">0.6779</td>
</tr>
<tr>
<td style="text-align: left;">Historical simulation</td>
<td style="text-align: right;">600</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">17</td>
<td style="text-align: right;">2,83%</td>
<td style="text-align: right;">0.000539</td>
<td style="text-align: right;">0.0002</td>
<td style="text-align: right;">0.0000</td>
<td style="text-align: right;">0.0000</td>
</tr>
<tr>
<td style="text-align: left;">Normal rolling</td>
<td style="text-align: right;">600</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">19</td>
<td style="text-align: right;">3,17%</td>
<td style="text-align: right;">0.000569</td>
<td style="text-align: right;">0.0000</td>
<td style="text-align: right;">0.0000</td>
<td style="text-align: right;">0.0000</td>
</tr>
<tr>
<td style="text-align: left;">Quantile regression</td>
<td style="text-align: right;">600</td>
<td style="text-align: right;">6</td>
<td style="text-align: right;">20</td>
<td style="text-align: right;">3,33%</td>
<td style="text-align: right;">0.000542</td>
<td style="text-align: right;">0.0000</td>
<td style="text-align: right;">0.0000</td>
<td style="text-align: right;">0.0000</td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>

**Bảng 8 trình bày kết quả theo dạng thường gặp trong bài báo thực nghiệm: mỗi dòng là một mô hình VaR; các cột gồm số vi phạm, tỷ lệ vi phạm, kiểm định coverage và hàm mất mát dự báo. Trong diễn giải, không nên chỉ chọn mô hình có số vi phạm gần nhất với kỳ vọng. Một mô hình tốt cũng cần có vi phạm không bị clustering và có loss function thấp.**

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><embed src="media/rId45.pdf" style="width:5.83333in;height:3.49392in" />
<p><strong>Hình 5: Minh họa các lần vi phạm VaR trong giai đoạn backtesting</strong></p></td>
</tr>
</tbody>
</table>

**Hình 5 cho thấy backtesting có ý nghĩa trực quan rất rõ. Nếu các điểm vi phạm xuất hiện quá thường xuyên hoặc tập trung thành cụm, nhà phân tích cần xem lại mô hình volatility, giả định phân phối, độ dài cửa sổ ước lượng hoặc cách cập nhật VaR.**

## **1.5 CÁC MÔ HÌNH MỞ RỘNG**

### **1.5.1 Mô hình GARCH với mô phỏng xác suất**

Monte Carlo VaR không nhất thiết chỉ dựa trên một phân phối tĩnh. Một cách triển khai mạnh hơn là dùng GARCH để tạo **phân phối có điều kiện** tại thời điểm $`t`$, sau đó mô phỏng nhiều kịch bản tỷ lệ sinh lời cho $`t + 1`$. Quy trình gồm bốn bước:

1.  Ước lượng mô hình volatility có điều kiện, ví dụ GARCH-t hoặc GJR-GARCH-t.
2.  Lấy dự báo $`{\widehat{\mu}}_{t + 1|t}`$ và $`{\widehat{\sigma}}_{t + 1|t}`$.
3.  Sinh nhiều sai số chuẩn hóa $`z_{t + 1}^{(b)}`$ từ phân phối giả định, chẳng hạn Student-t.
4.  Tạo kịch bản $`r_{t + 1}^{(b)} = {\widehat{\mu}}_{t + 1|t} + {\widehat{\sigma}}_{t + 1|t}z_{t + 1}^{(b)}`$, sau đó lấy phân vị của biến lỗ.

Cách làm này phù hợp khi muốn kết hợp ưu điểm của mô hình volatility động và tính linh hoạt của mô phỏng. Với danh mục phi tuyến, mô phỏng còn cho phép định giá lại danh mục dưới từng kịch bản thay vì chỉ nhân volatility với một hệ số phân vị (Brooks, 2019; Choudhry, 2013; Tsay, 2013).

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><embed src="media/rId51.pdf" style="width:5.83333in;height:3.49392in" />
<p><strong>Hình 6: GARCH Monte Carlo VaR từ phân phối lỗ có điều kiện</strong></p></td>
</tr>
</tbody>
</table>

**Hình 6 cho thấy Monte Carlo không thay đổi bản chất của VaR: VaR vẫn là phân vị của phân phối lỗ. Điểm khác là phân phối lỗ được tạo ra từ mô hình có điều kiện thay vì lấy trực tiếp từ dữ liệu lịch sử hoặc từ một phân phối tĩnh.**

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><p><strong>Bảng 9: VaR và ES minh họa từ GARCH Monte Carlo</strong></p>
<table style="width:85%;">
<colgroup>
<col style="width: 13%" />
<col style="width: 9%" />
<col style="width: 11%" />
<col style="width: 10%" />
<col style="width: 20%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Phương pháp</th>
<th style="text-align: left;">Số kịch bản</th>
<th style="text-align: right;">VaR 99%, tỷ lệ</th>
<th style="text-align: right;">ES 99%, tỷ lệ</th>
<th style="text-align: right;">VaR, danh mục 100 tỷ đồng</th>
<th style="text-align: right;">ES, danh mục 100 tỷ đồng</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">GARCH Monte Carlo</td>
<td style="text-align: left;">20.000</td>
<td style="text-align: right;">1,72%</td>
<td style="text-align: right;">2,15%</td>
<td style="text-align: right;">1.717.342.457 đồng</td>
<td style="text-align: right;">2.149.941.128 đồng</td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>

### **1.5.2 Mô hình GARCH với moment bậc cao biến đổi**

GARCH cơ bản chủ yếu mô hình hóa moment bậc hai, tức phương sai có điều kiện. Tuy nhiên, rủi ro đuôi còn phụ thuộc vào độ lệch (*skewness*) và độ nhọn (*kurtosis*) của phân phối. Nếu mô hình volatility đúng nhưng phân phối sai, VaR và ES vẫn có thể sai. Vì vậy, các mở rộng của GARCH thường tập trung vào hai hướng.

Hướng thứ nhất là dùng phân phối sai số linh hoạt hơn, chẳng hạn Student-t, GED hoặc skewed Student-t. Hướng thứ hai là cho phép phản ứng bất đối xứng của volatility đối với tin xấu và tin tốt, chẳng hạn GJR-GARCH hoặc EGARCH. Các nghiên cứu gần đây về thị trường mới nổi thường cho thấy mô hình bất đối xứng và phân phối đuôi dày cải thiện khả năng mô hình hóa volatility và tail risk, đặc biệt trong giai đoạn khủng hoảng hoặc biến động cao (ví dụ Ding và Meade, 2010; Alexander và Dakos, 2023; Gupta, 2025; Adegboyo và Sarwar, 2025).

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><p><strong>Bảng 10: Các mở rộng GARCH thường dùng trong mô hình VaR</strong></p>
<table style="width:85%;">
<colgroup>
<col style="width: 9%" />
<col style="width: 34%" />
<col style="width: 40%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Mô hình</th>
<th style="text-align: left;">Ý tưởng chính</th>
<th style="text-align: left;">Phù hợp khi</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">GARCH-normal</td>
<td style="text-align: left;">Volatility động, sai số chuẩn</td>
<td style="text-align: left;">Dùng làm benchmark cơ bản</td>
</tr>
<tr>
<td style="text-align: left;">GARCH-Student-t</td>
<td style="text-align: left;">Volatility động, sai số đuôi dày</td>
<td style="text-align: left;">Dữ liệu có kurtosis cao</td>
</tr>
<tr>
<td style="text-align: left;">GJR-GARCH</td>
<td style="text-align: left;">Tin xấu và tin tốt có tác động khác nhau đến volatility</td>
<td style="text-align: left;">Có leverage effect</td>
</tr>
<tr>
<td style="text-align: left;">EGARCH</td>
<td style="text-align: left;">Mô hình hóa log variance và hiệu ứng bất đối xứng</td>
<td style="text-align: left;">Volatility phản ứng bất đối xứng và cần ràng buộc dương tự nhiên</td>
</tr>
<tr>
<td style="text-align: left;">GARCH-skewed-t</td>
<td style="text-align: left;">Cho phép đuôi dày và độ lệch của phân phối</td>
<td style="text-align: left;">Phân phối tỷ lệ sinh lời vừa lệch vừa đuôi dày</td>
</tr>
<tr>
<td style="text-align: left;">GAS/GARCH-score</td>
<td style="text-align: left;">Cập nhật tham số động bằng score của likelihood</td>
<td style="text-align: left;">Muốn mô hình hóa tham số phân phối thay đổi theo thời gian</td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>

**Bảng 10 giúp định vị các mô hình mở rộng. Trong Chương 5, không nhất thiết phải sử dụng tất cả các mô hình này. Một thiết kế thực nghiệm hợp lý là chọn một nhóm benchmark vừa đủ: historical simulation, normal rolling VaR, EWMA VaR, GARCH-t, GJR-GARCH-t và một mô hình bán tham số như quantile regression hoặc CAViaR.**

### **1.5.3 Mô hình hồi quy cực trị**

Các phương pháp trên thường sử dụng toàn bộ phân phối hoặc một phần lớn dữ liệu để ước lượng VaR. Tuy nhiên, khi mục tiêu là rủi ro cực đoan, phần quan trọng nhất chính là vùng đuôi. Extreme Value Theory (EVT) cung cấp khung mô hình chuyên biệt cho các quan sát cực trị. Trong tài chính, EVT thường được dùng để ước lượng tail quantile và ES ở các mức tin cậy cao như 99% hoặc 99,5% (Brooks, 2019; Nolde & Zhou, 2021; Tsay, 2010, 2013).

Có hai hướng chính. Hướng thứ nhất là **block maxima**, trong đó dữ liệu được chia thành các khối và lấy giá trị cực đại của mỗi khối. Hướng thứ hai là **Peaks Over Threshold** (POT), trong đó chỉ các quan sát vượt một ngưỡng cao $`u`$ được mô hình hóa. Trong ứng dụng VaR, POT thường linh hoạt hơn vì sử dụng trực tiếp các quan sát nằm trong vùng đuôi.

Với POT, phần vượt ngưỡng $`Y = L - u \mid L > u`$ thường được mô hình hóa bằng phân phối Pareto tổng quát (*Generalized Pareto Distribution*, GPD):

``` math
G(y;\xi,\beta) = 1 - \left( 1 + \frac{\xi y}{\beta} \right)^{- 1/\xi},\quad\quad y > 0,
```

trong đó $`\xi`$ là tham số đuôi và $`\beta`$ là tham số thang. Nếu $`\xi`$ càng lớn, đuôi phân phối càng dày. Với ngưỡng $`u`$, số quan sát vượt ngưỡng $`N_{u}`$ và tổng số quan sát $`N`$, VaR mức $`p`$ có thể xấp xỉ bởi:

``` math
VaR_{p}^{POT} = u + \frac{\beta}{\xi}\left\lbrack \left( \frac{N}{N_{u}}(1 - p) \right)^{- \xi} - 1 \right\rbrack.
```

Công thức này cho thấy EVT không cố mô hình hóa toàn bộ phân phối lỗ; nó chỉ tập trung vào vùng đuôi sau một ngưỡng cao. Đây là điểm mạnh khi rủi ro cực đoan là trọng tâm, nhưng cũng là nguồn nhạy cảm vì kết quả phụ thuộc vào lựa chọn ngưỡng.

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><embed src="media/rId59.pdf" style="width:5.83333in;height:3.49392in" />
<p><strong>Hình 7: Minh họa mean excess plot trong phương pháp POT</strong></p></td>
</tr>
</tbody>
</table>

**Hình 7 minh họa công cụ trực quan thường dùng trong POT. Nếu ngưỡng quá thấp, phần dữ liệu được chọn có thể chưa thật sự thuộc vùng đuôi. Nếu ngưỡng quá cao, số quan sát vượt ngưỡng quá ít, làm ước lượng không ổn định. Vì vậy, lựa chọn ngưỡng là một quyết định thực nghiệm quan trọng.**

<table style="width:85%;">
<colgroup>
<col style="width: 84%" />
</colgroup>
<tbody>
<tr>
<td style="text-align: center;"><p><strong>Bảng 11: Minh họa VaR và ES theo EVT/POT bằng ước lượng moment đơn giản</strong></p>
<table style="width:85%;">
<colgroup>
<col style="width: 10%" />
<col style="width: 17%" />
<col style="width: 14%" />
<col style="width: 17%" />
<col style="width: 13%" />
<col style="width: 12%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Ngưỡng u</th>
<th style="text-align: right;">Số vượt ngưỡng</th>
<th style="text-align: right;">Xi ước lượng</th>
<th style="text-align: right;">Beta ước lượng</th>
<th style="text-align: right;">VaR 99% POT</th>
<th style="text-align: right;">ES 99% POT</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;">1,22%</td>
<td style="text-align: right;">80</td>
<td style="text-align: right;">0,2192</td>
<td style="text-align: right;">0,0054</td>
<td style="text-align: right;">2,27%</td>
<td style="text-align: right;">3,27%</td>
</tr>
</tbody>
</table></td>
</tr>
</tbody>
</table>

**Bảng 11 chỉ là minh họa nhập môn. Trong nghiên cứu thực nghiệm, EVT/POT nên được ước lượng cẩn trọng hơn, thường bằng maximum likelihood, kèm kiểm tra độ nhạy theo ngưỡng và backtesting ngoài mẫu. Với VN-Index, EVT/POT có thể được dùng như mô hình mở rộng hoặc robustness check cho các mức tin cậy cao.**

## **1.6 TÓM LƯỢC CHƯƠNG**

Chương này đã trình bày hệ thống các phương pháp đo lường rủi ro đuôi thông qua VaR và ES. VaR là ngưỡng phân vị của phân phối lỗ, còn ES là mức tổn thất trung bình trong vùng vượt VaR. Mô phỏng lịch sử dễ hiểu và không cần giả định phân phối, nhưng phụ thuộc mạnh vào cửa sổ dữ liệu và phản ứng chậm với thay đổi chế độ thị trường. Mô hình tham số đơn giản và có công thức rõ ràng, nhưng nhạy với giả định chuẩn hoặc Student-t. Các mô hình GARCH-type kết nối trực tiếp với phần volatility ở Chương 2 vì chúng dùng volatility forecast làm đầu vào cho VaR động.

Chương cũng đã mở rộng sang mô hình bán tham số, trong đó VaR được nhìn như một phân vị có điều kiện và có thể được ước lượng trực tiếp bằng hồi quy phân vị. Phần backtesting cho thấy một mô hình VaR không thể được đánh giá chỉ bằng trực giác hoặc độ phức tạp mô hình; mô hình phải được kiểm tra bằng số lần vi phạm, tính độc lập của vi phạm, conditional coverage, dynamic quantile test và hàm mất mát dự báo. Cuối cùng, các mô hình mở rộng như GARCH Monte Carlo, GARCH với phân phối đuôi dày/bất đối xứng và EVT/POT cung cấp thêm công cụ khi tail risk là trọng tâm.

Trong Chương 5, các nội dung này sẽ được chuyển sang đánh giá thực nghiệm với VN-Index. Trình tự phù hợp là: chuẩn bị chuỗi tỷ lệ sinh lời VN-Index; chia mẫu ước lượng và mẫu backtesting; ước lượng các mô hình VaR/ES; so sánh số lần vượt ngưỡng; kiểm định Kupiec, Christoffersen và Dynamic Quantile; sau đó kết luận mô hình nào phù hợp nhất cho quản trị rủi ro thị trường Việt Nam.

Acerbi, C., & Tasche, D. (2002). On the coherence of expected shortfall. Journal of Banking and Finance, 26(7), 1487–1503.

Alexander, C., & Dakos, M. (2023). Assessing the accuracy of exponentially weighted moving average models for value-at-risk and expected shortfall of crypto portfolios. Quantitative Finance, 23(3), 393–427. <https://doi.org/10.1080/14697688.2022.2159505>

Brooks, C. (2019). Introductory econometrics for finance (4th ed.). Cambridge University Press.

Choudhry, M. (2013). An introduction to value-at-risk (5th ed.). John Wiley & Sons.

Christoffersen, P. F. (1998). Evaluating interval forecasts. International Economic Review, 39(4), 841–862. <https://doi.org/10.2307/2527341>

Ding, J., & Meade, N. (2010). Forecasting accuracy of stochastic volatility, GARCH and EWMA models under different volatility scenarios. Applied Financial Economics, 20(10), 771–783. <https://doi.org/10.1080/09603101003636188>

Engle, R. F., & Manganelli, S. (2004). CAViaR: Conditional autoregressive value at risk by regression quantiles. Journal of Business & Economic Statistics, 22(4), 367–381. <https://doi.org/10.1198/073500104000000370>

Fissler, T., & Ziegel, J. F. (2016). Higher order elicitability and osband’s principle. The Annals of Statistics, 44(4), 1680–1707.

Jorion, P. (2007). Value at risk: The new benchmark for managing financial risk (3rd ed.). McGraw-Hill.

Kupiec, P. H. (1995). Techniques for verifying the accuracy of risk measurement models. The Journal of Derivatives, 3(2), 73–84. <https://doi.org/10.3905/jod.1995.407942>

Nolde, N., & Zhou, C. (2021). Extreme value analysis for financial risk management. Annual Review of Statistics and Its Application, 8, 217–240. <https://doi.org/10.1146/annurev-statistics-042720-015705>

Tsay, R. S. (2010). Analysis of financial time series (3rd ed.). John Wiley & Sons.

Tsay, R. S. (2013). An introduction to analysis of financial data with r. John Wiley & Sons.
