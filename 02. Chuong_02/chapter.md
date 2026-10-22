# Chương 2

# PHƯƠNG PHÁP DỰ BÁO BIẾN ĐỘNG TỶ LỆ SINH LỜI

Chương 1 đã trình bày biến động tỷ lệ sinh lời như một đặc điểm thống kê cần được ước lượng từ dữ liệu và đã chỉ ra rằng biến động của tỷ lệ sinh lời thường thay đổi theo thời gian. Chương 2 chuyển từ đo lường sang dự báo. Câu hỏi trung tâm của chương không phải là “biến động là gì?”, mà là “tại thời điểm *t*, với thông tin sẵn có đến t, nhà nghiên cứu có thể dự báo biến động của $`r_{t + 1}`$ như thế nào?”. Chương này giới thiệu các phương pháp dự báo biến động tỷ lệ sinh lời được trình bày theo trình tự tăng dần về mức độ mô hình hóa: từ các quy tắc dự báo biến động giản đơn, đến quy tắc cập nhật đệ quy, sau đó đến các mô hình phương sai có điều kiện.

## 2.1. Các phương pháp dự báo biến động sinh lời giản đơn

Một câu hỏi thực tế khi dự báo biến động tỷ lệ sinh lời là: nếu hôm nay cần ước lượng mức biến động của tỷ suất sinh lời trong kỳ tiếp theo, ta có thể bắt đầu từ đâu? Một câu trả lời đơn giản là nhìn vào biến động đã quan sát trong quá khứ. Nếu tỷ suất sinh lời trong giai đoạn gần đây dao động mạnh, ta có lý do để dự báo rằng biến động trong kỳ tiếp theo cũng có thể cao hơn. Nếu tỷ suất sinh lời trong giai đoạn gần đây khá ổn định, dự báo biến động kỳ tới có thể thấp hơn. Thay vì thực hiện các mô hình tham số phức tạp, các nhà nghiên cứu thực nghiệm thường bắt đầu với các mô hình giản đơn phi tham số như một điểm khởi đầu cũng như tham chiếu so sánh về mức độ chính xác của các dự báo biến động tỷ lệ sinh lời. Trong thực hành quản trị rủi ro, không phải lúc nào mô hình phức tạp cũng là lựa chọn đầu tiên.

*Thứ nhất,* các phương pháp dự báo giản đơn phi tham số không phụ thuộc nhiều vào các mô hình ước lượng tham số phức tạp. Điều này giúp kết quả mô hình trở nên minh bạch và dễ giải thích hơn về cách tính, hiểu vai trò của độ dài cửa sổ hoặc hệ số suy giảm, và nhận biết vì sao kết quả thay đổi khi lựa chọn tham số thay đổi. *Thứ hai*, phương pháp đơn giản đóng vai trò như chuẩn so sánh dự báo. Khi một mô hình phức tạp được đề xuất, câu hỏi tự nhiên là: mô hình đó có cải thiện rõ ràng so với cách tính đơn giản hơn hay không? Nếu một mô hình nhiều tham số không tạo ra cải thiện đáng kể, việc sử dụng mô hình đó có thể làm tăng rủi ro sai đặc tả và làm giảm khả năng giải thích kết quả.

### Biến động tỷ lệ sinh lời lịch sử

Biến động lịch sử là cách tiếp cận đơn giản nhất. Giả sử ta có một chuỗi tỷ suất sinh lời trong quá khứ. Nếu xem các quan sát này là đại diện cho điều kiện thị trường gần đây hoặc cho một giai đoạn nghiên cứu đủ dài, biến động có thể được ước lượng bằng độ lệch chuẩn mẫu của tỷ suất sinh lời.

``` math
\widehat{\sigma}\ \  = \ \sqrt{\frac{1}{T - 1}\sum_{t = 1}^{T}{{{(r}_{t} - \overline{r})}^{2}\ \ }}
```

Trong đó:

- $`\widehat{\sigma}`$ là biến động lịch sử được ước lượng từ dữ liệu quá khứ.

- $`T`$ là số quan sát tỷ suất sinh lời trong mẫu.

- $`r_{t}`$ là tỷ suất sinh lời tại thời điểm t.

- $`\overline{r}`$ là tỷ suất sinh lời trung bình trong mẫu.

- $`{{(r}_{t} - \overline{r})}^{2}`$ là bình phương độ lệch của tỷ suất sinh lời so với giá trị trung bình.

Ưu điểm của biến động tỷ lệ sinh lời lịch sử là dễ tính, dễ giải thích và không yêu cầu mô hình thống kê phức tạp. Tuy nhiên, nhược điểm chính là mọi quan sát trong mẫu được gán trọng số như nhau. Một cú sốc cách đây rất xa vẫn có cùng trọng số với một cú sốc mới xảy ra gần đây. Điều này có thể không phù hợp khi thị trường chuyển từ giai đoạn ổn định sang giai đoạn căng thẳng, hoặc ngược lại. Ví dụ, nếu một chỉ số thị trường có cú giảm rất mạnh cách đây một năm nhưng các tháng gần đây tương đối ổn định, biến động lịch sử trên toàn bộ mẫu vẫn có thể ở mức cao. Ngược lại, nếu biến động mới tăng mạnh trong vài phiên gần nhất nhưng mẫu lịch sử quá dài, biến động lịch sử có thể phản ứng chậm.

### Biến động tỷ lệ sinh lời với cửa sổ trượt

Biến động theo cửa sổ trượt cải thiện biến động lịch sử bằng cách chỉ dùng một số quan sát gần nhất để ước lượng biến động tại từng thời điểm. Thay vì tính độ lệch chuẩn trên toàn bộ mẫu, ta chọn một độ dài cửa sổ, ví dụ 20 ngày, 60 ngày hoặc 252 ngày, rồi cập nhật cửa sổ này khi có thêm quan sát mới.

Giả sử tại thời điểm *t*, ta dùng *m* quan sát gần nhất để ước lượng biến động. Khi đó biến động theo cửa sổ trượt được tính như sau:

``` math
{\widehat{\sigma}}_{t,\ m} = \ \sqrt{\frac{1}{m - 1}\sum_{i = 0}^{m - 1}{(r_{t - i} - {\overline{r}}_{t,m})}^{2}}
```

Trong đó:

- $`{\widehat{\sigma}}_{t,\ m}`$ là biến động lịch sử được ước lượng tại thời điểm *t* với cửa sổ *m* quan sát

- *m* là độ dài cửa sổ trượt

- $`r_{t - i}`$ là tỷ suất sinh lời tại thời điểm *t-i.*

- $`{\overline{r}}_{t,m}`$ là tỷ suất sinh lời trung bình trong cửa sổ gồm *m* quan sát gần nhất.

Nếu dùng dữ liệu ngày, cửa sổ 22 ngày thường phản ánh biến động khoảng một tháng giao dịch; cửa sổ 60 ngày phản ánh khoảng một quý; cửa sổ 252 ngày phản ánh khoảng một năm giao dịch theo thông lệ nhiều thị trường.

Kết quả ước lượng biến động tỷ lệ sinh lời phụ thuộc vào độ dài của cửa sổ ước lượng. Hình 2.1. mô phỏng ước lượng biến động tỷ lệ sinh lời với các khung cửa sổ với độ dài khác nhau. Có thể thấy cửa sổ ngắn phản ứng nhanh hơn với cú sốc mới, nhưng dễ dao động mạnh. Cửa sổ dài tạo ra đường biến động mượt hơn, nhưng phản ứng chậm hơn khi điều kiện thị trường thay đổi. Không có lựa chọn nào luôn đúng trong mọi bối cảnh. Cửa sổ ngắn phù hợp khi mục tiêu là nhận diện thay đổi ngắn hạn; cửa sổ dài phù hợp khi mục tiêu là mô tả xu hướng biến động ổn định hơn. Vì vậy, lựa chọn độ dài cửa sổ có thể ảnh hưởng trực tiếp đến mức biến động được báo cáo.

**Hình 2.1. Mô phỏng biến động tỷ lệ sinh lời theo các cửa sổ ước lượng với độ dài khác nhau**

<img src="media/image1.png" style="width:5.61273in;height:4.5in" alt="A graph of a graph of a graph of a graph of a graph of a graph of a graph of a graph of a graph of a graph of a graph of a graph of a graph of AI-generated content may be incorrect." />

*Nguồn: Minh họa của tác giả*

### Biến động tỷ lệ sinh lời trung bình hàm trượt mũ

Biến động theo cửa sổ trượt giúp dự báo biến động thay đổi theo thời gian, nhưng vẫn có một hạn chế quan trọng: tất cả các quan sát nằm trong cửa sổ được gán trọng số như nhau, còn quan sát vừa rời khỏi cửa sổ thì bị loại bỏ hoàn toàn. Điều này có thể làm cho biến động ước lượng thay đổi đột ngột, đặc biệt khi một cú sốc lớn vừa ra khỏi cửa sổ tính toán.

Trung bình trượt hàm mũ (*Exponential Weighted Moving Average – EWMA*) khắc phục một phần hạn chế đó bằng cách gán trọng số lớn hơn cho các quan sát gần hiện tại và trọng số nhỏ hơn cho các quan sát xa quá khứ. Thay vì coi mọi quan sát quá khứ là quan trọng như nhau, phương pháp này giả định rằng thông tin mới thường có giá trị lớn hơn đối với dự báo biến động trong kỳ tiếp theo. Tuy nhiên, thông tin cũ không bị loại bỏ đột ngột; ảnh hưởng của nó giảm dần theo thời gian. Nếu thị trường vừa trải qua một cú sốc lớn, bình phương tỷ suất sinh lời gần nhất sẽ tăng lên và làm cho biến động dự báo tăng. Nếu sau đó thị trường ổn định trở lại, tác động của cú sốc không biến mất ngay lập tức mà giảm dần qua từng kỳ. Mức độ giảm nhanh hay chậm phụ thuộc vào hệ số suy giảm.

**Hình 2.2. Trọng số suy giảm trong trung bình trượt hàm mũ.**

<img src="media/image2.png" style="width:5.62847in;height:3.28571in" alt="A graph with lines and numbers AI-generated content may be incorrect." />

*Nguồn: Minh họa của tác giả*

Trọng số của quan sát có độ trễ *j* trong trung bình trượt hàm mũ được viết như sau:

``` math
w_{j} = (1 - \lambda)\lambda^{j}
```

Trong đó:

- $`w_{j}`$là trọng số của quan sát có độ trễ *j*.

- $`\lambda`$ là hệ số suy giảm, với 0 \< λ \< 1

- *j* là số kỳ trễ so với thời điểm hiện tại.

- (1 − λ) là trọng số ban đầu gắn với quan sát gần nhất.

- $`\lambda^{j}`$ làm cho trọng số giảm dần khi quan sát lùi xa hiện tại.

Công thức trên cho thấy khi *j* = 0, quan sát gần nhất có trọng số:

> 
> ``` math
> w_{0} = 1 - \lambda
> ```
>
> Khi *j = 1*, quan sát lùi một kỳ có trọng số:
>
> ``` math
> w_{1} = (1 - \lambda)\lambda
> ```
>
> Khi *j = 2*, quan sát lùi một kỳ có trọng số:
>
> ``` math
> w_{2} = (1 - \lambda)\lambda^{2}
> ```

Như vậy, trọng số giảm theo dạng hàm mũ khi quan sát ngày càng xa hiện tại. Nếu $`\lambda`$ lớn, trọng số giảm chậm hơn, nghĩa là phương pháp ghi nhớ quá khứ lâu hơn. Nếu $`\lambda`$ nhỏ, trọng số giảm nhanh hơn, nghĩa là phương pháp phản ứng mạnh hơn với thông tin mới.

Ước lượng biến động tỷ lệ sinh lời trung bình trượt hàm mũ thường được xác định như sau:

> 
> ``` math
> {\widehat{\sigma}}_{t}^{2} = \lambda{\widehat{\sigma}}_{t - 1}^{2} + (1 - \lambda)r_{t - 1}^{2}
> ```
>
> Trong đó:

- $`{\widehat{\sigma}}_{t}^{2}`$là phương sai tỷ lệ sinh lời dự báo tại thời điểm *t*.

- $`{\widehat{\sigma}}_{t - 1\ }^{2}`$là phương sai tỷ lệ sinh lời đã ước lượng ở thời điểm trước đó.

- $`r_{t - 1}^{2}`$​ là bình phương tỷ lệ sinh lời ở thời điểm trước đó.

- $`\lambda`$ là hệ số suy giảm.

- $`(1 - \lambda)`$ là trọng số gắn với thông tin mới nhất.

Từ công thức trên có thể thấy phương sai dự báo hôm nay là trung bình có trọng số giữa hai thành phần: phương sai tỷ lệ sinh lời đã ước lượng ở kỳ trước và bình phương tỷ lệ sinh lời mới nhất. Thành phần thứ nhất, $`\lambda{\widehat{\sigma}}_{t - 1}^{2}`$, thể hiện phần ký ức của phương pháp. Thành phần thứ hai, $`(1 - \lambda)r_{t - 1}^{2}`$, thể hiện phản ứng với thông tin mới. Nếu $`r_{t - 1}^{2}`$​ lớn, tức là thị trường vừa có một biến động mạnh, phương sai dự báo $`{\widehat{\sigma}}_{t}^{2}`$​ sẽ tăng. Nếu các tỷ lệ sinh lời gần đây nhỏ, phương sai dự báo sẽ giảm dần. Tuy nhiên, tốc độ tăng hoặc giảm không chỉ phụ thuộc vào cú sốc mới mà còn phụ thuộc vào hệ số suy giảm $`\lambda`$. Khi $`\lambda`$ thấp, trọng số $`(1 - \lambda)`$ dành cho cú sốc mới lớn hơn. Khi đó, biến động dự báo phản ứng nhanh hơn trước thông tin mới. Ngược lại, khi $`\lambda`$ cao, trọng số dành cho phương sai quá khứ lớn hơn. Khi đó, đường biến động dự báo mượt hơn, nhưng phản ứng chậm hơn trước các thay đổi đột ngột. Hình 2.3 mô phỏng ước lượng biến động tỷ lệ éinh lời trung bình trượt hàm mũ phản ứng với một cú sốc lớn. Hệ số suy giảm thấp làm biến động phản ứng nhanh hơn; hệ số suy giảm cao làm đường biến động mượt hơn nhưng ghi nhớ cú sốc lâu hơn.

**Hình 2.3. Phản ứng của trung bình trượt hàm mũ trước một cú sốc biến động**

<img src="media/image3.png" style="width:6.10278in;height:3.43203in" />

*Nguồn: Minh họa của tác giả*

> Hình 2.4 so sánh ước lượng biến động tỷ lệ sinh lời lịch sử, biến động tỷ lệ sinh lời trung bình theo cửa sổ trượt và ước lượng biến động tỷ lệ sinh lời trung bình trượt hàm mũ. Đường biến động lịch sử toàn mẫu là một đường ngang vì phương pháp này sử dụng toàn bộ chuỗi tỷ suất sinh lời mô phỏng để tạo ra một ước lượng biến động duy nhất. Cách tiếp cận này đơn giản và ổn định, nhưng không phản ánh được sự thay đổi của biến động qua thời gian. Khi chuỗi mô phỏng chuyển từ giai đoạn biến động thấp sang giai đoạn biến động cao, biến động lịch sử toàn mẫu không điều chỉnh theo trạng thái mới của chuỗi.
>
> Ngược lại, biến động theo cửa sổ trượt và trung bình trượt hàm mũ đều tạo ra đường biến động thay đổi theo thời gian. Khi chuỗi tỷ suất sinh lời bước vào giai đoạn biến động cao, cả hai đường này đều tăng lên; khi giai đoạn biến động cao qua đi, cả hai đường đều giảm xuống. Điều này cho thấy hai phương pháp này phù hợp hơn biến động lịch sử toàn mẫu khi mục tiêu là mô tả biến động động, tức là biến động có thể thay đổi theo từng giai đoạn.

Tuy nhiên, hai phương pháp này phản ứng theo cách khác nhau. Biến động theo cửa sổ trượt phụ thuộc trực tiếp vào độ dài cửa sổ. Trong hình minh họa, cửa sổ 60 phiên làm cho đường biến động tăng tương đối chậm khi cú sốc mới xuất hiện và cũng giảm chậm khi giai đoạn biến động cao kết thúc. Nguyên nhân là mỗi ước lượng tại thời điểm *t* vẫn bao gồm toàn bộ các quan sát trong cửa sổ gần nhất, với trọng số bằng nhau. Vì vậy, một cú sốc lớn tiếp tục ảnh hưởng đến biến động ước lượng cho đến khi nó rời khỏi cửa sổ tính toán.

Trung bình trượt hàm mũ phản ứng theo cơ chế khác. Phương pháp này không loại bỏ đột ngột các quan sát cũ mà làm cho ảnh hưởng của chúng giảm dần theo hệ số suy giảm. Trong hình, đường trung bình trượt hàm mũ với ($`\lambda = 0.94`$) phản ứng khá nhanh khi biến động tăng, sau đó giảm dần khi các cú sốc lớn không còn tiếp diễn. So với biến động theo cửa sổ trượt, đường trung bình trượt hàm mũ thể hiện rõ hơn nguyên tắc “ghi nhớ có suy giảm”: thông tin mới có trọng số lớn hơn, nhưng thông tin cũ không biến mất ngay lập tức.

**Hình 2.4. So sánh biến động lịch sử, cửa sổ trượt và trung bình trượt hàm mũ**

<img src="media/image4.png" style="width:6.09931in;height:3.40659in" alt="A graph of a graph of a graph AI-generated content may be incorrect." />

*Nguồn: Minh họa của tác giả*

Ước lượng biến động tỷ lệ sinh lời trung bình trượt hàm mũ có vai trò như một bước chuyển tự nhiên từ các phương pháp biến động giản đơn sang mô hình phương sai có điều kiện. Phương pháp này đã đưa vào ý tưởng cập nhật biến động theo thời gian và phản ứng với cú sốc mới, nhưng vẫn chưa phải là một mô hình kinh tế lượng tham số đầy đủ. Phương pháp không ước lượng đồng thời phương trình trung bình và phương trình phương sai, không tự kiểm định cấu trúc phụ thuộc trong bình phương sai số, và cũng không tự xác định phân phối của sai số chuẩn hóa. Những giới hạn này là lý do các nhà phân tích thực nghiệm chuyển sang các mô hình ước lượng tham số khi cần dự báo một cách đầy đủ hơn toàn bộ phân phối có điều kiện của tỷ lệ sinh lời.

## 2.2. Các phương pháp dự báo ước lượng tham số

Mục 2.1 đã trình bày ba cách tiếp cận giản đơn để dự báo biến động: biến động lịch sử, biến động theo cửa sổ trượt và trung bình trượt hàm mũ. Các phương pháp này có ưu điểm là minh bạch, dễ tính và phù hợp để xây dựng trực giác ban đầu. Tuy nhiên, các phương pháp này chưa trả lời đầy đủ câu hỏi: vì sao biến động tại thời điểm hiện tại lại phụ thuộc vào thông tin quá khứ, và làm thế nào để mô hình hóa sự phụ thuộc này trong một cấu trúc kinh tế lượng rõ ràng?

Thay vì chỉ tính biến động từ một cửa sổ dữ liệu hoặc từ một hệ thống trọng số cho trước, mô hình phương sai có điều kiện đặt biến động tỷ lệ sinh lời vào một cấu trúc động. Trong cấu trúc này, phương sai tại thời điểm hiện tại được mô tả như một đại lượng phụ thuộc vào tập thông tin có sẵn ở thời điểm trước đó. Trong kinh tế lượng tài chính, cách tiếp cận này đặc biệt quan trọng vì nhiều chuỗi tỷ suất sinh lời tài sản có trung bình thay đổi không quá mạnh, nhưng mức độ dao động quanh trung bình lại thay đổi rõ rệt theo thời gian. Nói cách khác, trọng tâm của mô hình không chỉ nằm ở việc dự báo giá trị trung bình của tỷ suất sinh lời, mà còn nằm ở việc dự báo mức độ bất định quanh giá trị trung bình đó.

### Mô hình phương sai có điều kiện

Để mô hình hóa biến động, trước hết cần tách tỷ suất sinh lời thành hai phần: phần có thể dự báo dựa trên thông tin hiện có và phần không dự báo được.

``` math
r_{t} = \mu_{t} + \varepsilon_{t}
```

Trong đó:

- $`r_{t}`$ ​ là tỷ suất sinh lời tại thời điểm *t*.

- $`\mu_{t}`$​ là kỳ vọng có điều kiện của tỷ suất sinh lời tại thời điểm *t*, được xác định dựa trên tập thông tin có sẵn trước thời điểm *t*.

- $`\varepsilon_{t}`$​ là phần sai số hoặc cú sốc không dự báo được tại thời điểm *t*.

Phương trình trên tỷ suất sinh lời thực tế không chỉ gồm phần có thể dự báo dựa trên thông tin quá khứ, mà còn gồm phần bất định cần phải dự báo. Để dự báo biến động tỷ lệ sinh lời, trước hết cần xác định rõ thông tin nào được phép sử dụng khi dự báo. Trong chuỗi thời gian tài chính, dự báo tại thời điểm *t* không được dùng thông tin xuất hiện sau thời điểm *t*. Do đó, mô hình phải được xây dựng trên tập thông tin có sẵn trước thời điểm cần dự báo. Giả sử, tập thông tin có sẵn tại thời điểm dự báo được ký hiệu là $`\mathcal{F}_{t - 1}`$. Tập thông tin này có thể bao gồm tỷ suất sinh lời quá khứ, cú sốc quá khứ, phương sai có điều kiện quá khứ và các biến giải thích khác nếu mô hình sử dụng.

Khi đó, kỳ vọng và phương sai có điều kiện của tỷ lệ sinh lời xác định là

``` math
\mu_{t} = E(r_{t} \mid \mathcal{F}_{t - 1})
```

``` math
\sigma_{t}^{2} = Var\left( r_{t}\mid\mathcal{F}_{t - 1} \right) = Var(\varepsilon_{t} \mid \mathcal{F}_{t - 1})
```

Công thức trên cho thấy phương sai tại thời điểm *t* không phải là một hằng số mà có thể thay đổi theo thời gian tùy thuộc vào thông tin quá khứ. Nếu thị trường vừa trải qua các cú sốc lớn, $`\mathcal{F}_{t - 1}`$ chứa thông tin về các cú sốc đó và phương sai có điều kiện tại thời điểm *t* có thể tăng lên. Nếu thị trường trải qua một giai đoạn yên ổn hơn, phương sai có điều kiện có thể giảm xuống.

Để ước lượng biến động của tỷ lệ sinh lời có điều kiện, thành phần sốc không dự báo của tỷ lệ sinh lời $`\varepsilon_{t}`$ có thể tiếp tục được phân rã thành tích của độ lệch chuẩn có điều kiện và sai số chuẩn hóa:

``` math
\varepsilon_{t} = \ \sigma_{t}z_{t}
```

Trong đó:

- $`\sigma_{t}`$ là độ lệch chuẩn có điều kiện của tỷ lệ sinh lời

- $`z_{t}`$là sai số chuẩn hóa, thường được giả định có kỳ vọng bằng 0, $`E\left( z_{t} \right) = 0`$, và phương sai bằng 1, $`Var\left( z_{t} \right) = 1`$.

Cách phân rã này có ý nghĩa trực giác rất quan trọng. Thành phần $`z_{t}`$ cho biết cú sốc chuẩn hóa là âm hay dương, lớn hay nhỏ sau khi đã loại bỏ quy mô biến động. Thành phần $`\sigma_{t}`$ cho biết quy mô của cú sốc đó tại từng thời điểm. Nếu $`\sigma_{t}`$ cao, cùng một giá trị $`z_{t}`$sẽ tạo ra một cú sốc $`\varepsilon_{t}\`$ớn hơn. Nếu $`\sigma_{t}`$ thấp, cùng một giá trị $`z_{t}`$ sẽ tạo ra một cú sốc $`\varepsilon_{t}\`$thấp hơn. Do đó, khi dự báo biến động của tỷ lệ sinh lời, trọng tâm của mô hình không nằm ở việc dự báo chính xác dấu của $`z_{t}`$, mà nằm ở việc mô tả và dự báo $`\sigma_{t}^{2}`$. Đây là lý do nhóm mô hình này được gọi là mô hình phương sai có điều kiện: phương sai tại thời điểm t được mô hình hóa như một đại lượng phụ thuộc vào tập thông tin có sẵn tại thời điểm t−1, $`\mathcal{F}_{t - 1}`$. Trong cấu trúc này, phương trình trung bình và phương trình phương sai có vai trò khác nhau. Phương trình trung bình mô tả phần có thể dự báo của tỷ suất sinh lời, tức $`\mu_{t}`$. Phương trình phương sai mô tả mức độ bất định quanh phần có thể dự báo đó, tức $`\sigma_{t}^{2}`$. Đối với nhiều chuỗi tỷ suất sinh lời tài chính, đặc biệt là tỷ suất sinh lời ngày, phần trung bình có điều kiện có thể tương đối nhỏ, trong khi phương sai có điều kiện lại thay đổi mạnh theo thời gian. Đây là lý do các mô hình phương sai có điều kiện trở thành công cụ quan trọng trong dự báo biến động và đo lường rủi ro tài chính.

### Hiệu ứng ARCH

Từ phân rã tỷ lệ sinh lời có điều kiện kể trên, phần không dự báo được của tỷ suất sinh lời là $`\varepsilon_{t}`$​. Một cú sốc âm lớn và một cú sốc dương lớn đều làm thị trường biến động mạnh, dù dấu của chúng khác nhau. Vì vậy, để đo quy mô của cú sốc, ta thường xét bình phương của cú sốc thông qua $`\varepsilon_{t}^{2}`$. Nếu các giá trị lớn của $`\varepsilon_{t}^{2}`$ có xu hướng đi cùng nhau theo thời gian, điều đó cho thấy biến động tỷ lệ sinh lời có tính cụm. Nói cách khác, các giai đoạn biến động cao thường nối tiếp các giai đoạn biến động cao, còn các giai đoạn biến động thấp thường nối tiếp các giai đoạn biến động thấp. Đây chính là hiện tượng mà các mô hình phương sai có điều kiện cần mô tả.

**Hình 2.5. Cụm biến động trong chuỗi tỷ lệ sinh lời**

<img src="media/image5.png" style="width:5.94236in;height:4.47126in" />

*Nguồn: Minh họa của tác giả. Chuỗi tỷ lệ sinh lời được minh họa từ một quá trình GARCH (1,1)*

Hiệu ứng ARCH có thể hiểu đơn giản là hiện tượng trong đó phương sai có điều kiện hiện tại phụ thuộc vào bình phương các cú sốc trong quá khứ. Nếu một cú sốc lớn vừa xảy ra, mô hình cho phép phương sai có điều kiện trong kỳ tiếp theo tăng lên. Nếu các cú sốc gần đây nhỏ, phương sai có điều kiện có thể thấp hơn. Điều này cũng phù hợp với thực tế trên thị trường chứng khoán. Sau một phiên thị trường biến động mạnh, nhà đầu tư thường không giả định rằng mức rủi ro ngay lập tức trở lại bình thường. Ngược lại, cú sốc lớn vừa xảy ra có thể là dấu hiệu cho thấy thị trường đang bước vào giai đoạn bất ổn hơn. Khi đó, dự báo biến động cho kỳ tiếp theo cần phản ánh thông tin này. Hiệu ứng ARCH chính là cách diễn đạt ý tưởng đó bằng ngôn ngữ kinh tế lượng. Hình 2.5 minh họa hiệu ứng ARCH bằng một chuỗi tỷ lệ sinh lời mô phỏng từ quá trình có phương sai thay đổi theo thời gian. Ở đồ thị phía trên, các dao động lớn không xuất hiện rải rác hoàn toàn ngẫu nhiên mà có xu hướng tập trung thành từng giai đoạn. Ở đồ thị phía dưới, bình phương tỷ suất sinh lời làm nổi bật quy mô của các cú sốc, qua đó cho thấy các quan sát có biến động lớn thường đi gần nhau theo thời gian.

Trong ứng dụng thực nghiệm, cú sốc thật $`\varepsilon_{t}`$​ không quan sát được mà cần mà ước lượng nó từ phương trình trung bình. Phần dư ước lượng được viết là:

``` math
{\widehat{\varepsilon}}_{t} = r_{t} - \ {\widehat{\mu}}_{t}
```

Trong đó

- $`{\widehat{\varepsilon}}_{t}`$​ là phần dư ước lượng tại thời điểm ttt.

- $`r_{t}`$ là tỷ lệ sinh lời thực tế quan sát được tại thời điểm *t*.

- $`{\widehat{\mu}}_{t}`$ là kỳ vọng có điều kiện của tỷ lệ sinh lời được ước lượng dựa trên tệp thông tin $`\mathcal{F}_{t - 1}`$

Khi đó, bình phương phần dư $`{\widehat{\varepsilon}}_{t}^{2}`$​ thường được dùng như đại lượng quan sát gần đúng cho quy mô cú sốc. Nếu chuỗi $`{\widehat{\varepsilon}}_{t}^{2}`$​ có xu hướng phụ thuộc vào các giá trị trễ của chính nó, điều đó cho thấy phương sai có điều kiện thay đổi theo thời gian mà không cố định. Điều này có nghĩa là nếu bình phương cú sốc quá khứ có thông tin về biến động hiện tại, ta có thể xây dựng một phương trình phương sai trong đó $`\sigma_{t}^{2}`$ phụ thuộc vào $`\varepsilon_{t - 1\ }^{2}`$, $`\varepsilon_{t - 2\ }^{2}`$, …, $`\varepsilon_{t - q\ }^{2}`$.

Cần lưu ý rằng, hiệu ứng ARCH không đồng nghĩa với việc tỷ suất sinh lời có thể dự báo tốt theo mức trung bình. Một chuỗi tỷ suất sinh lời có thể gần như không có tự tương quan tuyến tính đáng kể, nhưng bình phương tỷ suất sinh lời hoặc bình phương phần dư vẫn có phụ thuộc động. Khi đó, hướng tăng hoặc giảm của thị trường có thể khó dự báo, nhưng quy mô dao động của thị trường vẫn có thể dự báo ở một mức độ nhất định. Đây chính là lý do các mô hình phương sai có điều kiện có vai trò đặc biệt trong tài chính khi dự báo về rủi ro của danh mục đầu tư dựa trên biến động của tỷ lệ sinh lời trong kỳ tiếp theo

### Mô hình ARCH

Mô hình ARCH (Autoregressive Conditional Heteroskedasticity) là mô hình tự hồi quy phương sai có điều kiện, theo đó, phương sai có điều kiện tại thời điểm hiện tại được mô tả bằng các bình phương cú sốc trong quá khứ. Nếu cú sốc quá khứ lớn, phương sai dự báo cho hiện tại tăng lên. Nếu cú sốc quá khứ nhỏ, phương sai dự báo có xu hướng thấp hơn. Mô hình này biến giúp lượng hóa cụm biến động thành một phương trình cụ thể.

``` math
\sigma_{t\ }^{2}\  = \omega\  + \alpha_{1}\varepsilon_{t - 1}^{2}\  + \alpha_{2}\varepsilon_{t - 2}^{2}\  + \cdots\  + \alpha_{q}\varepsilon_{t - q}^{2}
```

Trong đó:

- $`\sigma_{t\ }^{2}`$ là phương sai có điều kiện tại thời điểm *t;*

- $`\omega`$ là hằng số dương;

- $`\alpha_{i}\`$là hệ số phản ánh tác động của bình phương cú sốc trễ bậc *i*;

- $`\varepsilon_{t - i}^{2}`$ là bình phương cú sốc tại thời điểm *t - i*;

- *q* là số độ trễ của mô hình ARCH.

Để phương sai có điều kiện luôn dương, các tham số thường cần thỏa mãn các điều kiện cơ bản:

``` math
\omega > 0
```

``` math
\alpha_{i} \geq 0,\ i = 1,\ 2,\ \ldots.,\ q
```

Trong ARCH, mỗi bình phương cú sốc quá khứ đóng vai trò như một tín hiệu về mức biến động hiện tại. Nếu $`\alpha_{1}`$ lớn, phương sai có điều kiện phản ứng mạnh với cú sốc vừa xảy ra ở kỳ trước. Nếu các hệ số $`\alpha_{i}`$ ở độ trễ xa vẫn đáng kể, mô hình cho thấy cú sốc quá khứ có ảnh hưởng kéo dài hơn. Ví dụ, nếu thị trường vừa có một phiên dao động rất mạnh, $`\varepsilon_{t - 1}^{2}\`$sẽ lớn. Trong mô hình ARCH(1), giá trị lớn này làm $`\sigma_{t\ }^{2}`$ tăng. Nếu thị trường tiếp tục có thêm các phiên dao động mạnh, bình phương cú sốc tiếp tục lớn và phương sai có điều kiện tiếp tục duy trì ở mức cao. Đây là cách mô hình mô tả cụm biến động: giai đoạn biến động cao có xu hướng kéo dài vì các cú sốc lớn liên tiếp làm phương sai dự báo tiếp tục cao.

### Mô hình tự hồi quy tổng quát phương sai có điều kiện – GARCH

Mô hình ARCH có có hạn chế khi mô tả hiện tượng biến động kéo dài trong dữ liệu tài chính, mô hình ARCH có thể cần nhiều bậc trễ *q*. Nếu *q* lớn, mô hình có nhiều tham số, khó diễn giải hơn và có thể kém ổn định trong ước lượng. Ví dụ, nếu biến động thị trường có tính dai dẳng trong nhiều phiên, chỉ dùng $`\varepsilon_{t - 1}^{2}\`$​ có thể chưa đủ. Ta có thể cần thêm $`\varepsilon_{t - 2}^{2}`$​, $`\varepsilon_{t - 3}^{2}\`$và nhiều độ trễ khác. Nhưng càng thêm nhiều độ trễ, số lượng tham số $`\alpha_{i}`$​ càng tăng.

Mô hình GARCH mở rộng mô hình ARCH bằng cách đưa thêm phương sai có điều kiện quá khứ vào phương trình phương sai hiện tại. Thay vì chỉ dựa vào bình phương cú sốc quá khứ, mô hình GARCH cho phép phương sai hiện tại phụ thuộc cả vào biến động đã được dự báo trong quá khứ. Dạng đơn giản và được sử dụng phổ biến nhất là mô hình GARCH(1,1) như sau:

``` math
\sigma_{t}^{2} = \omega\  + \alpha\varepsilon_{t - 1}^{2}\  + \beta\sigma_{t - 1}^{2}
```

Trong đó:

- $`\sigma_{t}^{2}`$​ là phương sai có điều kiện tại thời điểm *t*

- $`\omega`$ là hằng số trong phương trình phương sai.

- $`\alpha`$ là hệ số phản ánh tác động của cú sốc mới nhất, thông qua $`\varepsilon_{t - 1}^{2}`$.

- $`\varepsilon_{t - 1}^{2}`$​ là bình phương cú sốc tại thời điểm *t-1*.

- $`\beta`$ là hệ số phản ánh tác động của phương sai có điều kiện quá khứ.

- $`\sigma_{t - 1}^{2}`$là phương sai có điều kiện tại thời điểm *t-1*.

Phương trình trên cho thấy phương sai hôm nay gồm ba thành phần. Thành phần thứ nhất là mức nền $`\omega`$. Thành phần thứ hai là phản ứng với cú sốc mới nhất, $`\alpha\varepsilon_{t - 1}^{2}`$​. Thành phần thứ ba là phần ký ức của biến động quá khứ, $`\beta\sigma_{t - 1}^{2}`$. Nếu $`\alpha`$ lớn, phương sai có điều kiện phản ứng mạnh với cú sốc mới. Nếu $`\beta`$ lớn, phương sai có điều kiện có tính dai dẳng cao, nghĩa là cú sốc biến động mất nhiều thời gian hơn để suy giảm.

Tổng $`\alpha + \beta`$ được dùng để mô tả mức độ dai dẳng của biến động. Nếu $`\alpha + \beta`$ gần 1, biến động có tính dai dẳng cao: cú sốc lớn có thể ảnh hưởng đến dự báo biến động trong nhiều kỳ tiếp theo. Nếu $`\alpha + \beta`$ thấp hơn, tác động của cú sốc suy giảm nhanh hơn.

Để phương sai có điều kiện dương, dạng GARCH(1,1) thường yêu cầu:

``` math
\omega > 0,\ \alpha \geq 0,\ \beta \geq 0
```

``` math
\alpha + \beta < 1
```

So với ARCH, GARCH có ưu điểm là mô tả được biến động dai dẳng bằng ít tham số hơn. Một mô hình GARCH(1,1) với ba tham số trong phương trình phương sai có thể phản ánh mức độ dai dẳng mà mô hình ARCH cần nhiều bậc trễ mới mô tả được. Đây là lý do GARCH thường được xem là mô hình nền tảng trong họ mô hình phương sai có điều kiện.

### Các mô hình mở rộng trong họ mô hình GARCH

Các mô hình mở rộng trong họ GARCH được phát triển để xử lý những đặc điểm mà GARCH cơ bản chưa mô tả đầy đủ. Có ba động cơ chính.

Thứ nhất, thị trường có thể phản ứng bất đối xứng với tin xấu và tin tốt. Trong thị trường cổ phiếu, một cú giảm mạnh thường làm nhà đầu tư lo ngại hơn và có thể kéo theo biến động cao hơn so với một cú tăng cùng độ lớn.

Thứ hai, biến động có thể có tính dai dẳng rất cao. Trong một số giai đoạn, cú sốc lớn dường như có ảnh hưởng kéo dài, khiến phương sai có điều kiện giảm rất chậm.

Thứ ba, biến động có thể không chỉ là đại lượng cần dự báo, mà còn ảnh hưởng ngược lại đến tỷ suất sinh lời kỳ vọng.

#### Mô hình GJR-GARCH

Mô hình GARCH chuẩn là điểm xuất phát quan trọng để mô tả cụm biến động và độ dai dẳng của biến động. Tuy nhiên, mô hình này có một hạn chế lớn: nó xử lý cú sốc âm và cú sốc dương có cùng độ lớn theo cùng một cách. Lý do là trong phương trình GARCH chuẩn, cú sốc quá khứ đi vào phương trình phương sai thông qua bình phương $`\varepsilon_{t - 1}^{2}`$​​. Khi đã bình phương, dấu của cú sốc bị loại bỏ. Do đó, một cú sốc −2% và một cú sốc +2%có cùng bình phương và tạo ra cùng tác động lên phương sai có điều kiện.

Trong nhiều chuỗi tỷ lệ sinh lời cổ phiếu, giả định đối xứng này có thể quá đơn giản. Thực tế thường cho thấy tin xấu hoặc cú sốc âm có thể làm biến động tăng mạnh hơn tin tốt hoặc cú sốc dương có cùng độ lớn. Đây là hiện tượng bất đối xứng trong phản ứng của biến động. Trong tài chính cổ phiếu, hiện tượng này thường được liên hệ với hiệu ứng đòn bẩy: khi giá cổ phiếu giảm, giá trị vốn chủ sở hữu giảm, trong khi nghĩa vụ nợ không giảm tương ứng; tỷ lệ đòn bẩy tài chính của doanh nghiệp vì thế có thể tăng lên, làm cổ phiếu trở nên rủi ro hơn. Ngoài cách giải thích theo đòn bẩy tài chính, cú sốc âm cũng có thể làm nhà đầu tư lo ngại hơn, làm thanh khoản xấu đi hoặc làm bất định thị trường tăng lên. Vì vậy, về mặt thực nghiệm, cú sốc âm thường được kỳ vọng có tác động lớn hơn đến biến động tương lai so với cú sốc dương cùng độ lớn.

Mô hình GJR-GARCH, được đề xuất bởi Glosten, Jagannathan và Runkle (1993), được xây dựng để đưa phản ứng bất đối xứng đó vào mô hình phương sai có điều kiện. Ý tưởng của mô hình rất trực quan: ngoài tác động chung của độ lớn cú sốc, mô hình cộng thêm một phần tác động riêng nếu cú sốc quá khứ là cú sốc âm. Vì vậy, GJR-GARCH có thể được xem là một mở rộng của GARCH chuẩn nhằm phân biệt tác động của “tin xấu” và “tin tốt” lên biến động tương lai. Mô hình GJR-GARCH(1,1) có thể viết như sau:

``` math
\sigma_{t}^{2} = \omega + \alpha\varepsilon_{t - 1}^{2} + \gamma I_{t - 1}\varepsilon_{t - 1}^{2} + \beta\sigma_{t - 1}^{2}\ 
```

Trong đó:

- $`\gamma`$ là tham số đo bổ sung khi cú sốc quá khứ là cú sốc âm (tỷ suất sinh lời âm khi chứng khoán giảm giá)

- $`I_{t - 1} = \ \left\{ \begin{array}{r}
  1\ nếu\ \varepsilon_{t - 1} < 0\ \  \\
  0\ nếu\ \varepsilon_{t - 1} \geq 0
  \end{array} \right.\`$là biến chỉ báo cú sốc tỷ lệ sinh lời âm

Phương trình mô hình GJR-GARCH cho thấy tác động chệch của tỷ lệ sinh lời quá khứ tới ước lượng biến động tỷ lệ sinh lời trong tương lai. Nếu cú sốc tỷ lệ sinh lời kỳ gần nhất là dương hoặc bằng 0, $`\varepsilon_{t - 1} \geq 0`$, khi đó $`I_{t - 1} = 0`$, phương trình phương sai trở thành:

``` math
\sigma_{t}^{2} = \omega + \alpha\varepsilon_{t - 1}^{2} + \beta\sigma_{t - 1}^{2}\ 
```

Trong trường hợp này, tác động của cú sốc quá khứ lên phương sai có điều kiện chỉ là $`\alpha\varepsilon_{t - 1}^{2}`$. Nếu cú sốc tỷ lệ sinh lời kỳ gần nhất là âm, $`\varepsilon_{t - 1} < \ 0`$, khi đó $`I_{t - 1} = 1`$, phương trình phương sai trở thành:

``` math
\sigma_{t}^{2} = \omega + (\alpha + \gamma)\varepsilon_{t - 1}^{2} + \beta\sigma_{t - 1}^{2}\ 
```

Trong trường hợp này, tác động của cú sốc âm lên phương sai có điều kiện là $`(\alpha + \gamma)\varepsilon_{t - 1}^{2}`$. Vì vậy, nếu $`\gamma > 0`$, cú sốc âm làm phương sai có điều kiện tăng mạnh hơn cú sốc dương có cùng độ lớn tuyệt đối. Đây là đặc điểm quan trọng giúp GJR-GARCH mô tả phản ứng bất đối xứng của biến động.

**Hình 2.6. Đường phản ứng tin tức của GARCH và GJR-GARCH**

<img src="media/image6.png" style="width:5.74713in;height:3.09792in" alt="A graph with lines and percentages AI-generated content may be incorrect." />

*Nguồn: Minh họa của tác giả*

Hình 2.6 so sánh đường phản ứng tin tức của mô hình GARCH đối xứng và mô hình GJR-GARCH. Trục ngang biểu diễn cú sốc chuẩn hóa kỳ trước, còn trục dọc biểu diễn mức biến động kỳ sau theo thang minh họa. Với GARCH chuẩn, cú sốc âm và cú sốc dương có cùng độ lớn tạo ra phản ứng giống nhau vì phương trình phương sai chỉ phụ thuộc vào bình phương cú sốc. Ngược lại, GJR-GARCH cho phép phản ứng bất đối xứng: cú sốc âm có thể làm biến động tương lai tăng mạnh hơn cú sốc dương cùng độ lớn.

#### Mô hình EGARCH

Mô hình EGARCH được Nelson (1991) đề xuất nhằm xử lý một số hạn chế của GARCH chuẩn. Thứ nhất, mô hình GARCH chuẩn cần các ràng buộc không âm đối với tham số để bảo đảm phương sai có điều kiện luôn dương. Thứ hai, mô hình GARCH chuẩn phản ứng đối xứng với cú sốc âm và cú sốc dương vì cú sốc đi vào phương trình dưới dạng bình phương. EGARCH giải quyết đồng thời hai vấn đề này bằng cách mô hình hóa ($`ln(\sigma_{t}^{2}`$)) và đưa sai số chuẩn hóa vào phương trình theo dạng cho phép phản ứng bất đối xứng. Mô hình EGARCH(1,1) có thể viết như sau:

``` math
ln(\sigma_{t}^{2})\  = \omega\  + \beta\ ln(\sigma_{t - 1}^{2})\  + \alpha(|z_{t - 1}|\  - \ E|z_{t - 1}|)\  + \gamma\ z_{t - 1}
```

Trong đó:

- $`ln(\sigma_{t}^{2})\`$ là logarit của phương sai có điều kiện tại thời điểm *t*.

- $`\omega`$ là hằng số trong phương trình logarit phương sai.

- $`\beta`$ đo mức độ dai dẳng của logarit phương sai có điều kiện.

- $`z_{t - 1}`$ là sai số chuẩn hóa tại thời điểm *t - 1*.

- $`|z_{t - 1}|`$ là độ lớn tuyệt đối của sai số chuẩn hóa.

- $`E\left| z_{t - 1} \right|`$ là kỳ vọng của độ lớn tuyệt đối của sai số chuẩn hóa.

- $`\alpha`$ đo tác động của độ lớn cú sốc lên logarit phương sai.

- $`\gamma`$ đo tác động bất đối xứng của dấu cú sốc.

Mô hình EGARCH mô hình hóa logarit phương sai nên khi chuyển ngược lại sang phương sai, ta có:

``` math
\sigma_{t}^{2} = exp(\ln\left( \sigma_{t}^{2} \right))
```

Do hàm mũ luôn cho giá trị dương, phương sai có điều kiện luôn dương. Đây là ưu điểm kỹ thuật quan trọng của EGARCH so với GARCH chuẩn. Nói cách khác, EGARCH bảo đảm tính dương của phương sai thông qua cấu trúc logarit, thay vì phải áp đặt trực tiếp nhiều ràng buộc không âm lên các hệ số. Thành phần ($`|z_{t - 1}|\  - \ E|z_{t - 1}|)`$. Nếu cú sốc có độ lớn cao hơn mức thông thường, thành phần này làm logarit phương sai thay đổi. Thành phần $`\gamma z_{t - 1}`$ giữ lại dấu của cú sốc để mô tả phản ứng khác nhau của biến động trước cú sốc âm và cú sốc dương. Một cú sốc âm lớn có thể làm nhà đầu tư lo ngại hơn, làm gia tăng nhu cầu phòng vệ rủi ro, làm thanh khoản thị trường xấu đi, hoặc làm bất định tăng mạnh. Trong khi đó, một cú sốc dương cùng độ lớn có thể không tạo ra cùng mức căng thẳng. Nếu $`\gamma`$ \< 0, cú sốc âm thường làm biến động tăng mạnh hơn cú sốc dương cùng độ lớn. Phương pháp mô hinh tham số của EGARCH trên thang logarit giúp phương sai luôn dương và mô hình hóa phản ứng phi tuyến của biến động tỷ lệ sinh lời với cú sốc của tỷ lệ sinh lời trong kỳ gần nhất. Tuy nhiên, EGARCH cũng có hạn chế. Thứ nhất, công thức khó diễn giải trực tiếp hơm hơn GARCH và GJR-GARCH. Thứ hai, vì mô hình hóa logarit phương sai, dự báo và diễn giải phương sai nhiều bước có thể phức tạp hơn GARCH chuẩn.

#### Mô hình APARCH

Sau GARCH, GJR-GARCH và EGARCH, một hướng mở rộng khác là đặt câu hỏi: liệu phương trình biến động nhất thiết phải được viết theo phương sai $`\sigma_{t}^{2}`$, hay có thể dùng một bậc lũy thừa khác của biến động? Mô hình APARCH do Ding, Granger và Engle (1993) đề xuất nhằm tạo ra một khung tổng quát hơn cho nhiều mô hình biến động. Thay vì cố định phương trình ở dạng phương sai $`\sigma_{t}^{2}`$, mô hình cho phép dữ liệu tự xác định bậc lũy thừa $`\delta`$. Đồng thời, mô hình vẫn giữ khả năng mô tả bất đối xứng thông qua tham số phản ứng khác nhau với cú sốc âm và cú sốc dương. Mô hình APARCH(1,1) có thể viết như sau:

``` math
\sigma_{t}^{\delta}\  = \omega\  + \alpha\ \left( \left| \varepsilon_{t - 1} \right| - \gamma\varepsilon_{t - 1} \right)^{\delta}\ \  + \beta\sigma_{t - 1}^{\delta}
```

Trong đó:

- $`\sigma_{t}^{\delta}`$ là độ lệch chuẩn có điều kiện lũy thừa bậc $`\delta`$ tại thời điểm *t*.

- $`\omega`$ là hằng số trong phương trình biến động.

- $`\alpha`$ đo tác động của cú sốc quá khứ.

- $`\varepsilon_{t - 1}`$ là cú sốc tại thời điểm *t - 1*.

- $`\left| \varepsilon_{t - 1} \right|`$ là độ lớn tuyệt đối của cú sốc quá khứ.

- $`\gamma`$ là tham số bất đối xứng.

- $`\delta`$ là tham số bậc lũy thừa của biến động.

- $`\beta`$ đo tác động của biến động quá khứ.

- $`\sigma_{t - 1}^{\delta}`$ là độ lệch chuẩn có điều kiện quá khứ lũy thừa bậc $`\delta`$.

Điểm mới của APARCH nằm ở hai thành phần: $`\delta`$ và $`\gamma`$. Tham số $`\delta`$ cho phép mô hình quyết định nên mô hình hóa biến động dưới dạng nào. Nếu $`\delta = 2`$, phương trình gần với phương trình GARCH tiêu chuẩn. Nếu $`\delta`$ là một giá trị khác, mô hình cho phép phản ứng biến động linh hoạt hơn so với cách cố định trước bậc lũy thừa. Tsay (2013) lưu ý rằng hàm lũy thừa trong APARCH có thể giúp cải thiện độ phù hợp của mô hình khi mục tiêu là dự báo, nhưng tham số $`\delta`$ không phải lúc nào cũng dễ diễn giải về mặt kinh tế. Tương tự GJR-GARCH và EGARCH, tham số $`\gamma`$ cho phép phản ứng bất đối xứng của biến động tỷ lệ sinh lời với dấu của cú sốc tỷ lệ sinh lời ở kỳ gần nhất. Nếu cú sốc quá khứ là dương, tức $`\varepsilon_{t - 1} > 0`$, thì:

``` math
\left| \varepsilon_{t - 1} \right| - \gamma\varepsilon_{t - 1} = (1 - \gamma)\varepsilon_{t - 1}
```

Nếu cú sốc quá khứ là âm, tức tức $`\varepsilon_{t - 1} < 0`$, thì:

``` math
\left| \varepsilon_{t - 1} \right| - \gamma\varepsilon_{t - 1} = (1 + \gamma){\mid \varepsilon}_{t - 1} \mid
```

Nếu $`\gamma > 0`$, cú sốc âm được khuếch đại mạnh hơn cú sốc dương cùng độ lớn. Khi đó, APARCH có thể mô tả hiện tượng tin xấu làm biến động tăng mạnh hơn tin tốt.

Có thể thấy mô hình APARCH linh hoạt hơn các mô hình riêng lẻ. GARCH chuẩn xử lý độ dai dẳng nhưng đối xứng. GJR-GARCH xử lý bất đối xứng nhưng vẫn chủ yếu làm việc với bình phương cú sốc. EGARCH xử lý bất đối xứng và dùng logarit phương sai, nhưng có cấu trúc riêng. APARCH tạo ra một khung rộng hơn, cho phép nhiều dạng phản ứng biến động được mô tả trong cùng một phương trình. Chính vì vậy, APARCH có giá trị khi nhà đầu tư muốn kiểm tra xem dữ liệu có ủng hộ cách mô hình hóa biến động theo phương sai, độ lệch chuẩn, hay một bậc lũy thừa khác.

Tuy nhiên, sự linh hoạt này cũng tạo ra rủi ro diễn giải. Tham số $`\delta`$ có thể giúp mô hình khớp dữ liệu tốt hơn, nhưng giá trị ước lượng của $`\delta`$ không phải lúc nào cũng có ý nghĩa tài chính trực tiếp. Nếu $`\delta = 1,67`$, chẳng hạn, nhà đầu tư có thể khó giải thích giá trị này bằng luận giải kinh tế thông thường. Do đó, mô hình APARCH thường được sử dụng khi nhà đầu tư muốn ưu tiên thông tin từ dữ liệu nhiều hơn để đưa ra dự báo, thay vì áp dụng cứng các tham số về bậc của biến động tỷ lệ sinh lời. Bên cạnh đó, mô hình APARCH có nhiều tham số hơn, nên có thể khó ước lượng ổn định nếu mẫu dữ liệu không đủ dài hoặc biến động không thể hiện rõ cấu trúc.

#### Mô hình GARCH-M

Các mô hình GARCH, GJR-GARCH, EGARCH và APARCH chủ yếu tập trung vào phương trình phương sai. Chúng trả lời câu hỏi: biến động có điều kiện thay đổi như thế nào theo cú sốc và biến động trong quá khứ? Mô hình GARCH-M đặt thêm một câu hỏi khác: *biến động có điều kiện có ảnh hưởng ngược lại đến tỷ suất sinh lời kỳ vọng hay không?* Câu hỏi này xuất phát từ lý thuyết về sự đánh đổi giữa lợi nhuận và rủi ro. Theo đó, nhà đầu tư thường được giả định là yêu cầu phần bù khi chấp nhận rủi ro cao hơn. Nếu một tài sản có rủi ro có điều kiện cao hơn, nhà đầu tư có thể yêu cầu tỷ suất sinh lời kỳ vọng cao hơn để nắm giữ tài sản đó. Mô hình GARCH-M do Engle, Lilien và Robins (1987) đề xuất đưa phương sai có điều kiện vào phương trình trung bình để mô hình hóa phần bù rủi ro thay đổi theo thời gian. Mô hình GARCH-M đơn giản có thể viết như sau:

``` math
r_{t}\  = \mu\  + \lambda\sigma_{t}^{2}\  + \varepsilon_{t}
```

Trong đó:

- $`r_{t}`$ là tỷ suất sinh lời tại thời điểm *t*.

- $`\mu`$ là hằng số trong phương trình trung bình.

- $`\lambda`$ là hệ số đo tác động của phương sai có điều kiện lên tỷ suất sinh lời kỳ vọng.

- $`\sigma_{t}^{2}`$ là phương sai có điều kiện tại thời điểm *t*.

- $`\varepsilon_{t}`$ là cú sốc không dự báo được tại thời điểm *<u>t</u>*.

Phương trình phương sai đi kèm có thể là GARCH (1,1):

``` math
\sigma_{t}^{2} = \omega + \alpha\varepsilon_{t - 1}^{2} + \beta\sigma_{t - 1}^{2}\ 
```

Một biến thể của GARCH-M khác dùng độ lệch chuẩn có điều kiện, $`\sigma_{t}`$, thay vì phương sai có điều kiện:

``` math
r_{t}\  = \mu\  + \lambda\sigma_{t}\  + \varepsilon_{t}
```

Nếu $`\lambda > 0`$, biến động có điều kiện cao hơn gắn với tỷ suất sinh lời kỳ vọng cao hơn. Khi đó, $`\lambda`$ có thể được diễn giải như một hệ số phần bù rủi ro trong mô hình. Nếu hệ số này dương và có ý nghĩa thống kê, sự gia tăng rủi ro, được đo bằng biến động hoặc phương sai có điều kiện, dẫn đến sự gia tăng của tỷ suất sinh lời trung bình; khi đó hệ số này có thể được diễn giải như phần bù rủi ro.

### Giả định phân phối của sai số chuẩn hóa

Sau khi đã có các phương trình tham số cho $`\sigma_{t}^{2}`$, yêu cầu tiếp theo của các mô hình phương sai có điều kiện là ước lượng phân phối của cú sốc chuẩn hóa $`z_{t}`$. Điều này quan trọng bởi mô hình phương sai có điều kiện không chỉ dự báo một con số biến động mà bản chất là lượng hóa các tham số của phân phối có điều kiện tỷ lệ sinh lời. Phân phối này cho biết tại thời điểm dự báo, với thông tin đã biết đến thời điểm *t−1*, tỷ suất sinh lời ở thời điểm *t* có thể dao động quanh trung bình như thế nào, xác suất xảy ra các cú sốc lớn ra sao, và vùng đuôi trái của phân phối dày hay mỏng. Nếu mục tiêu chỉ là mô tả biến động trung tâm, lựa chọn phân phối có thể chưa tạo khác biệt quá lớn. Nhưng nếu mục tiêu là đo lường rủi ro đuôi, đặc biệt là VaR và ES, giả định phân phối trở thành một thành phần quyết định. Một mô hình GARCH với sai số chuẩn hóa theo phân phối chuẩn có thể tạo ra VaR và ES khác với cùng mô hình GARCH nhưng sai số chuẩn hóa theo phân phối Student-t hoặc Student-t chệch. Lý do là VaR phụ thuộc vào phân vị của phân phối, còn ES phụ thuộc vào toàn bộ phần đuôi sau phân vị.

#### Phân phối có điều kiện của tỷ lệ sinh lời

Từ mô hình phương sai có điều kiện ở mục 2.2, ta có phân phối tỷ lệ sinh lời có điều kiện có thể được biểu diễn như sau:

``` math
r_{t} = \mu_{t} + \ \sigma_{t}z_{t}
```

Trong đó, $`\mu_{t}`$, $`\sigma_{t}`$ và $`z_{t}`$ lần lượt là trung bình, độ lệch chuẩn và quan sát ngẫu nhiên chuẩn hóa theo phân phối có điều kiện của tỷ lệ sinh lời dựa trên tệp thông tin $`\mathcal{F}_{t - 1}`$. Nói cách khác, ba tham số này sẽ tạo nên phân phối của $`r_{t}`$ với điều kiện thông tin tới thời điểm *t – 1*. Trong đó, $`\mu_{t}`$​ xác định vị trí trung tâm của phân phối tỷ suất sinh lời. Nếu $`\mu_{t}`$​ tăng lên, phân phối có điều kiện của $`r_{t}`$​ dịch sang phải; nếu $`\mu_{t}`$​ ​ giảm xuống, phân phối dịch sang trái. Thành phần σt\sigma_tσt​ xác định độ rộng của phân phối. Nếu $`\sigma_{t}`$ ​ lớn, phân phối trải rộng hơn, nghĩa là mức bất định cao hơn. Nếu $`\sigma_{t}`$​ nhỏ, phân phối hẹp hơn, nghĩa là tỷ suất sinh lời kỳ tới được kỳ vọng dao động trong phạm vi hẹp hơn.

Thành phần $`z_{t}`$​ xác định hình dạng của phân phối sau khi đã chuẩn hóa, gồm mức độ đối xứng, độ dày của đuôi, độ nhọn ở trung tâm và khả năng xuất hiện các giá trị cực đoan. Hai mô hình có cùng $`\mu_{t}`$​ và $`\sigma_{t}`$ vẫn có thể cho kết quả ước lượng VaR và ES khác nhau với các giả định phân phối khác nhau cho $`z_{t}`$. Có thể viết giả định phân phối tổng quát cho sai số chuẩn hóa như sau:

``` math
z_{t}\sim\ D(0,1)
```

Trong đó:

- D là giả định về phân phối của $`z_{t}`$, được chuẩn hóa với kỳ vọng bằng 0 và phương sai bằng 1.

Sự lựa chọn phân hối của $`z_{t}`$ cũng ảnh hưởng tới quá trình ước lượng tham số. Mô hình phương sai có điều kiện thường được ước lượng bằng phương pháp hợp lý tối đa (Maximum Likelihood Estimation – MLE), thông qua mật độ xác suất có điều kiện của $`r_{t}`$.

``` math
f_{r}(r_{t} \mid \ \mathcal{F}_{t - 1})\  = \ \frac{1}{\sigma_{t}}\ f_{z}\left( \frac{r_{t} - \ \mu_{t}}{\sigma_{t}};\theta \right)
```

Trong đó:

- $`f_{r}(r_{t} \mid \ \mathcal{F}_{t - 1})`$ là mật độ xác suất có điều kiện của tỷ lệ sinh lời tại thời điểm *t*

- $`f_{z}(.)`$ là mật độ xác suất của sai số chuẩn hóa $`z_{t}`$

- $`\theta`$ là tập hợp tham số thể hiện hình dạng của $`z_{t}`$

Công thức này cho thấy giả định phân phối của $`z_{t}`$​ đi trực tiếp vào cách mô hình mô tả tỷ suất sinh lời. Nếu $`z_{t}`$​ được giả định theo phân phối chuẩn, các cú sốc rất lớn ở vùng đuôi có xác suất xảy ra ít hơn. Nếu giả định $`z_{t}`$ theo các phân phối có độ chệch không cân xứng hoặc độ dày đuôi, mô hình cho phép xác suất cao hơn cho các cú sốc cực đoan. Do đó, lựa chọn phân phối không chỉ là một chi tiết kỹ thuật, mà ảnh hưởng trực tiếp đến phân phối có điều kiện, đến VaR và ES.

#### Các giả định phân phối của sai số chuẩn hóa phổ biến

##### Phân phối chuẩn

Phân phối chuẩn chuẩn hóa là giả định đơn giản nhất cho sai số chuẩn $`z_{t}`$. Theo đó $`z_{t}\ \sim\ N(0,1)`$, với kỳ vọng bằng 0 và phương sai bằng 1.

Mật độ xác suất của phân phối chuẩn hóa là:

``` math
\ \ f(z)\  = \ \frac{1}{\sqrt{2\pi}}exp( - \frac{z^{2}}{2})
```

Phân phối chuẩn có ba ưu điểm lớn. Thứ nhất, công thức đơn giản và quen thuộc. Thứ hai, phân vị của phân phối chuẩn có thể dễ dàng xác định. Thứ ba, phân phối chuẩn tạo ra một chuẩn so sánh tự nhiên cho các mô hình khác. Vì vậy, trong thực nghiệm, mô hình GARCH với sai số chuẩn thường được dùng như mô hình nền.

Tuy nhiên, phân phối chuẩn có hai hạn chế quan trọng khi dùng cho tỷ suất sinh lời tài chính. Thứ nhất, phân phối chuẩn đối xứng. Điều này có nghĩa là cú sốc âm và cú sốc dương cùng độ lớn có xác suất như nhau. Nếu dữ liệu có rủi ro đuôi trái lớn hơn đuôi phải, phân phối chuẩn không thể mô tả đặc điểm đó. Thứ hai, phân phối chuẩn có đuôi tương đối mỏng. Điều này làm xác suất của các cú sốc rất lớn giảm rất nhanh khi đi xa khỏi trung tâm phân phối. Vì vậy, phân phối chuẩn thường được sử dụng như một mô hình tham chiếu khi thực hiện dự báo.

##### Phân phối Student-t

Như đã trình bày ở chương 1, một quan sát thực tế đối với dữ liệu tài chính là phân phối của các quan sát tỷ lệ sinh lời thực tế không theo quy luật phân phối chuẩn thông thường mà có phần đuôi dày hơn, phản ánh thực tế là các quan sát với giá trị cực đoan có tần suất xuất hiện lớn hơn. Do đó, phân phối Student-t được sử dụng rộng rãi trong mô hình biến động tài chính vì cho phép đuôi dày hơn phân phối chuẩn. Vì vậy, phân phối này thường phù hợp hơn khi dữ liệu có nhiều cú sốc lớn như biến động tỷ lệ sinh lời.

Sự khác biệt chính của phấn phối Student-t so với phân phối chuẩn là sự bổ sung của tham số bậc tự do, kiểm soát cho độ dày của đuôi trong phân phối xác suất. Giả sử $`u_{t}\sim t_{v}`$ là biến ngẫu nhiên theo phân phối Student-t với bậc tự do $`v`$. Khi giá trị của $`v`$ thấp, đuôi phân phối dày hơn, nghĩa là xác suất xuất hiện giá trị cực đoan cao hơn. Khi $`v`$ tăng, phân phối Student-t tiến gần hơn đến phân phối chuẩn.

**Hình 2.7. So sánh phân phối chuẩn và Student-t chuẩn hóa**

<img src="media/image7.png" style="width:5.89655in;height:3.18955in" alt="A graph of a function AI-generated content may be incorrect." />

*Nguồn: Minh họa của tác giả*

Nếu giả định sai số chuẩn hóa trong mô hình GARCH tuân theo phân phối Student-t chuẩn hóa, khi đó ta có phương trình như sau:

``` math
z_{t} = u_{t}\sqrt{\frac{v - 2}{v}}\ ,\ \ u_{t}\sim t_{v}\ ,\ \ v > 2
```

Trong đó, $`v > 2`$ là điều kiện để phương sai của phân phối Student-t tồn tại, trong khi hệ số $`\sqrt{\frac{v - 2}{v}}`$ dùng để điều chỉnh phương sai về 1.

So với phân phối chuẩn, phân phối Student-t có khả năng mô tả các cú sốc cực đoan tốt hơn. Với cùng $`\mu_{t}`$​ và $`\sigma_{t}`$​, phân vị trái 1% của Student-t chuẩn hóa thường nằm xa hơn về bên trái so với phân phối chuẩn, đặc biệt khi $`v`$ thấp. Do đó, mô hình GARCH với sai số Student-t thường có thể tạo VaR và ES lớn hơn mô hình GARCH với sai số chuẩn ở các mức tin cậy cao.

##### Phân phối Student-t chệch

Mặc dù phân phối Student-t truyền thống cho phép các quan sát với giá trị cực đoan có xác suất xảy ra lớn hơn, gần hơn với biến động thực tế của tỷ lệ sinh lời của các chuỗi dữ liệu tài chính, phân phối này vẫn là phân phối đối xứng. Điều này có nghĩa là phân phối này vẫn chưa mô hình hóa được quan sát thực tế đã chỉ ra ở chương 1 là xác suất của các giá trị cực đoan với tỷ lệ sinh lời âm có tần suất xảy ra nhiều hơn so với xác suất của các giá trị cực đoan với tỷ lệ sinh lời dương. Bên cạnh đó, tác động bất đối xứng của các cú sốc âm và cú sốc dương tới mức biến động của tỷ lệ sinh lời kỳ tiếp theo cũng làm xô lệch mức đối xứng của phân phối tỷ lệ sinh lời.

**Hình 2.8. Phân phối Student – t chệch chuẩn hóa**

<img src="media/image8.png" style="width:5.925in;height:3.0875in" alt="A graph with lines on it AI-generated content may be incorrect." />

*Nguồn: Minh họa của tác giả*

Để mô hình hóa đồng thời tính chất đuôi dày và bất đối xứng của phân phối tỷ lệ sinh lời, phân phối xác suất Student-t chệch có thể được sử dụng. Sự khác biệt của phân phối Student-t chệch là sự bổ sung của tham số chệch, giả sử được ký hiệu là $`\xi`$, điều khiển mức độ bất đối xứng của phân phối xác suất. Giả sử sai số chuẩn hóa trong mô hình GARCH tuân theo phân phối Student-t chệch chuẩn hóa, khi đó ta có phương trình như sau:

``` math
z_{t} \sim ST(0,\ 1,\ \nu,\ \xi)
```

Trong đó:

- $`ST(0,\ 1,\ \nu,\ \xi)`$ là phân phối Student – t chệch chuẩn hóa

- $`\nu`$ là tham số điều chỉnh mức độ dày đuôi của phân phối

- $`\xi`$ là tham số điều chỉnh mức độ bất đối xứng của phân phối

> Ngoài việc cho phép xác suất cú sốc cực đoan cao hơn phân phối chuẩn, hình dạng phân phối Student- t chệch còn cho phép một phía của phân phối có đuôi có tần suất cao hơn so với phía còn lại. Nếu phân phối lệch trái, vùng tỷ suất sinh lời âm lớn có thể có xác suất cao hơn so với vùng tỷ suất sinh lời dương lớn. Điều này đặc biệt quan trọng khi đo lường rủi ro lỗ lớn.

##### Phân phối t tổng quát chệch

Bên cạnh các phân phối trên, <span class="mark">Theodossiou (1998)</span> giới thiệu phân phối t tổng quát chệch (Skewed Generalized t – SGT) mang tính tổng quát, cho phép phân phối có vị trí trung tâm linh hoạt, quy mô linh hoạt, độ chệch linh hoạt và hình dạng đuôi linh hoạt và bao trùm các phân phối khác tùy thuộc vào điều kiện của các tham số. Phương trình mật độ phân phối của SGT có thể khái quát như sau

$`f_{SGT}(x;\mu,\sigma,\lambda,p,q) = \frac{p}{2\nu\sigma q^{\frac{1}{p}}B\left( \frac{1}{p},q \right)\left\lbrack 1 + \ \frac{\mid x - \mu + m \mid^{p}}{q(\nu\sigma)^{p}\left( 1 + \lambda sgn(x - \mu + m) \right)^{p}} \right\rbrack^{\frac{1}{p + q}}}`$

Trong đó:

- $`\mu`$ là tham số vị trí.

- $`\sigma`$ là tham số quy mô.

- $`\lambda`$ là tham số chệch, thỏa mãn −1 \< λ \<1.

- $`p\`$và $`q`$ là các tham số hình dạng, điều chỉnh độ nhọn và độ dày đuôi.

- B(.) là hàm beta.

- sgn(.) là hàm dấu.

- m và v là các hằng số điều chỉnh vị trí và quy mô, được xác định theo các tham số của phân phối.

SGT là một **họ phân phối bao trùm**, trong đó các tham số khác nhau đóng vai trò như điều chỉnh hình dạng phân phối. Tham số $`\lambda`$ điều chỉnh độ chệch: nếu $`\lambda = 0`$, phân phối trở về dạng đối xứng; nếu $`\lambda < 0`$, phân phối chệch âm; nếu $`\lambda > 0`$ phân phối chệch dương. Hai tham số *p* và *q* điều chỉnh độ nhọn ở trung tâm và độ dày của đuôi. Khi cố định một số tham số hoặc đưa một số tham số về giới hạn, SGT thu hẹp thành các phân phối đơn giản hơn. Chẳng hạn, khi loại bỏ độ chệch bằng cách đặt $`\lambda = 0`$, SGT trở thành phân phối generalized t đối xứng. Khi đặt thêm $`p = 2`$, phân phối thu hẹp về họ Student-t. Khi đưa $`q\  \rightarrow \ \infty`$, phần “đuôi kiểu t” được loại bỏ và họ phân phối chuyển sang dạng phân phối sai số tổng quát (Generalized Error Distribution – GED); nếu vẫn giữ $`\lambda\  \neq 0`$, phân phối thu được là SGED, còn nếu đặt thêm $`\lambda = 0`$, phân phối thu được là GED đối xứng. Khi đặt đồng thời $`\lambda = 0`$, $`p = 2`$ và $`q\  \rightarrow \ \infty`$,, phân phối trở về phân phối chuẩn.

**Hình 2.9. Minh họa phân phối SGT với các tham số khác nhau**

<img src="media/image9.png" style="width:5.975in;height:5.20347in" alt="A graph of a graph of a function AI-generated content may be incorrect." />

*Nguồn: Minh họa của tác giả*

Trong bối cảnh mô hình GARCH, nếu $`z_{t}`$​ được giả định theo một phân phối thuộc họ SGT, mô hình có thể linh hoạt hơn trong việc mô tả phần dư chuẩn hóa: vừa có thể cho phép đuôi dày, hoặc đỉnh nhỏn vừa có thể cho phép bất đối xứng. Điều này phù hợp với dữ liệu tỷ suất sinh lời tài chính, nơi các cú sốc lớn thường xuất hiện nhiều hơn so với phân phối chuẩn và vùng đuôi trái có thể không giống vùng đuôi phải. Tuy nhiên, chính sự linh hoạt của SGT cũng tạo ra hạn chế. SGT có nhiều tham số hơn các phân phối đơn giản như chuẩn, Student-t hoặc Student-t chệch. Khi đưa SGT vào mô hình GARCH, số tham số cần ước lượng tăng lên, hàm hợp lý có thể phức tạp hơn, quá trình tối ưu có thể nhạy hơn với giá trị khởi tạo, và việc diễn giải kết quả cũng khó hơn. Do đó, trong phạm vi cuốn sách này, tác giả sẽ sử dụng biến thể thông dụng hơn của phân phối SGT và đảm bảo tính so sánh với phân phối Student-t chệch đã phân tích ở trên là phân phối sai số tổng quát chệch (Skewed Generalized Error Distribution – SGED). Phương trình mật độ của phân phối SGED có thể được thể hiện như sau:

``` math
f_{SGED}(x;\mu,\sigma,\ \lambda,\ p) = \ \frac{p}{2\nu\sigma\Gamma\left( \frac{1}{p} \right)}\exp\left\lbrack - \left( \frac{\mid x - \mu + m \mid}{\nu\sigma\left( 1 + \lambda\ sgn(x - \mu + m) \right)} \right)^{p} \right\rbrack\ 
```

Trong đó:

- Γ(⋅) là hàm gamma.

- $`\mu`$ là tham số vị trí.

- $`\sigma > 0`$ là tham số quy mô.

- $`\lambda`$ là tham số chệch.

- $`p`$ là tham số hình dạng.

- m và v là các hằng số điều chỉnh để kiểm soát trung bình và phương sai tùy theo cách chuẩn hóa.

Khi dùng SGED cho sai số chuẩn hóa trong mô hình GARCH, có thể ký hiệu gọn hơn:

``` math
z_{t}\  \sim \ SGED(0,1,\kappa,\xi)
```

Trong đó:

- $`SGED(0,1,\kappa,\xi)`$ là phân phối sai số tổng quát chệch đã chuẩn hóa

- $`\kappa`$ là tham số hình dạng, điều chỉnh độ nhọn và độ dày đuôi.

- $`\xi`$ là tham số chệch, điều chỉnh mức độ bất đối xứng.

> **Hình 2.10. Minh họa phân phối SGED với các tham số khác nhau**
>
> <img src="media/image10.png" style="width:5.775in;height:4.375in" />
>
> Phân phối SGED cho phép so sánh tương đối trực tiếp với Student-t chệch. Cả hai đều có thể mô tả bất đối xứng; khác biệt chính nằm ở cách mô hình hóa hình dạng đuôi. Student-t chệch dựa trên cấu trúc Student-t, trong đó tham số bậc tự do kiểm soát độ dày đuôi. SGED dựa trên cấu trúc sai số tổng quát, trong đó tham số hình dạng kiểm soát độ nhọn và độ dày đuôi theo một cách khác.

### Lựa chọn phân phối trong thực nghiệm

Các phân phối của $`z_{t}`$​ không chỉ khác nhau ở hình dạng trung tâm, mà quan trọng hơn là khác nhau ở vùng đuôi. Đây là điểm có ý nghĩa trực tiếp đối với đo lường rủi ro tài chính. Ví dụ, nếu xét một mức phân vị $`\tau`$ ở vùng đuôi trái, phân vị có điều kiện của tỷ lệ sinh lời có thể được thể hiện như sau:

``` math
q_{\tau,t}(r)\  = \mu_{t}\  + \sigma_{t}\ q_{\tau}(z)
```

Công thức này cho thấy, nếu giữ nguyên $`\mu_{t}`$ và $`\sigma_{t}`$, phân vị phần đuôi của $`r_{t}`$ vẫn thay đổi khi phân phối của $`z_{t}`$ thay đổi. Nếu $`z_{t}`$ ​ được giả định theo phân phối chuẩn, các cú sốc rất xa trung tâm có xác suất rất thấp. Nếu $`z_{t}`$ được giả định theo phân phối Student-t, các cú sốc lớn ở vùng đuôi có xác suất cao hơn. Nếu $`z_{t}`$ được giả định theo một phân phối lệch trái, vùng tỷ suất sinh lời âm lớn có thể trở nên quan trọng hơn so với vùng tỷ suất sinh lời dương lớn.

Trong thực nghiệm, không nên mặc định một phân phối là đúng tuyệt đối. Về mặt quy trình, lựa chọn phân phối nên dựa trên bốn nhóm bằng chứng. Thứ nhất là đặc điểm mô tả của dữ liệu và phần dư chuẩn hóa, bao gồm độ lệch, độ nhọn, biểu đồ mật độ và biểu đồ phân vị. Thứ hai là kết quả ước lượng trong mẫu, chẳng hạn hàm hợp lý logarit, AIC và BIC. Thứ ba là kiểm định chẩn đoán sau ước lượng, đặc biệt là phần dư chuẩn hóa và bình phương phần dư chuẩn hóa. Thứ tư là kết quả dự báo ngoài mẫu và kiểm định VaR/ES. Một phân phối làm tăng hàm hợp lý trong mẫu nhưng không cải thiện dự báo rủi ro ngoài mẫu thì chưa chắc là lựa chọn tốt cho quản trị rủi ro. Điều này đặc biệt quan trọng khi cần dự báo rủi ro tài chính với thị trường chứng khoán Việt Nam, việc chọn phân phối cần được xem như một câu hỏi thực nghiệm sẽ được đánh giá ở các chương tiếp theo.

## 2.3. Ước lượng, lựa chọn mô hình và kiểm định chuẩn đoán

Như đã lý giải ở chương 1, biến động tài chính không cố định theo thời gian, mà thường thay đổi theo từng giai đoạn, được điều chỉnh bởi các yếu tố thúc đẩy biến động từ nền tảng của chuỗi dữ liệu tài chính (như nền tảng của doanh nghiệp với giá cổ phiếu, nền tảng của nền kinh tế với chỉ số giá cổ phiếu…) và các biến động bất định do các yếu tố khác như chu kỳ kinh tế, tâm lý nhà đầu tư hay biến động kinh tế vĩ mô… Do đó, có thể hiểu một mô hình ước lượng biến động tỷ lệ sinh lời giống như một bộ lọc dữ liệu tỷ suất sinh lời với những giai đoạn biến động thấp xen kẽ với những giai đoạn biến động cao.

Mục 2.3 đã cho thấy có rất nhiều mô hình có thể được sử dụng để mô hình hóa phân phối có điều kiện của tỷ lệ sinh lời. Với cùng một chuỗi tỷ suất sinh lời ngày của VN-Index có thể được mô hình hóa bằng GARCH-normal, GARCH-Student-t, GJR-GARCH-skewed-t, EGARCH-SGED hoặc APARCH với một phân phối sai số linh hoạt hơn như SGT. Tuy nhiên, không nên chọn mô hình chỉ vì mô hình đó có tên gọi phức tạp hơn hoặc có nhiều tham số hơn. Một mô hình nhiều tham số có thể khớp dữ liệu trong mẫu tốt hơn nhưng lại kém ổn định, khó diễn giải và có nguy cơ mô tả cả phần nhiễu ngẫu nhiên thay vì tín hiệu có ý nghĩa. Bên cạnh đó, Brooks (2019) nhấn mạnh rằng mô hình nhiều tham số cũng dẫn tới rủi ro về tính bất định trong ước lượng tham số. Mô hình quá rộng có thể mô tả rất tốt dữ liệu trong mẫu nhưng dự báo ngoài mẫu kém vì đã khớp cả những đặc điểm ngẫu nhiên không lặp lại.

Vì vậy, để tiến hành ước lượng phân phối có điều kiện của tỷ lệ sinh lời, chúng ta cần một quy tình ước lượng cụ thể, cân bằng giữa đặc tả mức độ phức tạp của mô hình và tính hiệu quả của dự báo rủi ro, cùng với các kiểm định phù hợp để đảm bảo sự phù hợp của mô hình với dữ liệu sử dụng.

### Thiết lập mô hình phương sai có điều kiện

Một mô hình GARCH thực nghiệm đầy đủ thường gồm ba khối. Khối thứ nhất là phương trình trung bình, mô tả kỳ vọng có điều kiện của tỷ suất sinh lời. Khối thứ hai là phương trình phương sai, mô tả sự thay đổi của biến động có điều kiện theo thông tin quá khứ. Khối thứ ba là phân phối của sai số chuẩn hóa, mô tả hình dạng của cú sốc sau khi đã loại bỏ trung bình và chuẩn hóa theo biến động. Mô hình GARCH tổng quát có thể diễn tả qua hệ phương trình như sau:

``` math
r_{t}\  = \mu_{t}\  + \varepsilon_{t}
```

``` math
\varepsilon_{t}\  = \sigma_{t}\ z_{t}
```

``` math
\sigma_{t}^{2}\  = \ g(\mathcal{F}_{t - 1};\Theta_{v})
```

``` math
z_{t} \sim \ D(0,1)
```

Trong đó,

- $`r_{t}`$ là tỷ suất sinh lời tại thời điểm t;

- $`\mu_{t}`$ là trung bình có điều kiện;

- $`\varepsilon_{t}\`$là sai số chưa chuẩn hóa;

- $`\sigma_{t}\`$ là độ lệch chuẩn có điều kiện;

- $`z_{t}`$ là sai số chuẩn hóa.

- Tập thông tin $`\mathcal{F}_{t - 1}\`$bao gồm những thông tin sẵn có đến cuối thời điểm *t - 1*, thường là các giá trị quá khứ của tỷ suất sinh lời, phần dư và phương sai có điều kiện.

- Hàm g(.) là phương trình phương sai, chẳng hạn ARCH, GARCH, GJR-GARCH, EGARCH hoặc APARCH.

- $`\Theta_{v}`$ là tập tham số của phương trình phương sai.

- $`D(0,1)`$ là phân phối chuẩn hóa của $`z_{t}`$ có kỳ vọng bằng 0, phương sai bằng 1 và có thể giả định theo các phân phối linh hoạt như đã trình bày ở mục 2.3.

Mô tả của mô hình phương sai có điều kiện cho thấy mô hình không chỉ dự báo một con số duy nhất cho $`r_{t}`$. Mô hình dự báo cả vị trí, độ rộng và hình dạng của phân phối có điều kiện. $`\mu_{t}`$ quyết định vị trí trung tâm của phân phối; $`\sigma_{t}`$ quyết định độ phân tán; còn lựa chọn phân phối của sai số chuẩn $`D(0,1)`$ quyết định hình dạng của cú sốc chuẩn hóa, đặc biệt là mức độ đuôi dày và bất đối xứng. Nhóm phương trình trên cũng cho thấy để dự báo biến động tỷ lệ sinh lời, chúng ta không chỉ ước lượng các tham số của phương trình phương sai mà cần đồng thời ước lượng tham số của phương trình trung bình, phương trình phương sai và phân phối của $`z_{t}`$. Hai mô hình có cùng GARCH(1,1) nhưng khác phân phối sai số, chẳng hạn normal và Student-t, có thể cho kết quả khác nhau về giá trị log-likelihood, độ dai dẳng biến động, sai số chuẩn hóa và dự báo rủi ro đuôi.

### Nguyên tắc ước lượng tham số

Phần lớn các mô hình GARCH trong thực nghiệm được ước lượng bằng phương pháp hợp lý tối đa (Maximum Likelihood Estimation – MLE) hoặc hợp lý tối đa có điều kiện (Conditional Maximum Likelihood Estimation – CMLE). Nguyên tắc ước lượng của phương pháp này là chọn bộ tham số khiến dữ liệu đã quan sát trở nên hợp lý nhất dưới mô hình đã giả định. Nói cách khác, mô hình tìm bộ tham số làm cho xác suất quan sát được chuỗi dữ liệu thực tế là cao nhất.

Ký hiệu $`\Theta_{v}`$ là toàn bộ tham số của mô hình, bao gồm tham số của phương trình trung bình, tham số của phương trình phương sai và tham số của phân phối $`z_{t}`$. Bộ tham số ước lượng được viết là:

``` math
\widehat{\Theta}\ \  = \ arg\max_{\Theta}{\sum_{t = 1}^{T}{\mathcal{l}_{t}(\Theta)}\ }
```

Trong đó:

- $`\widehat{\Theta}`$ là bộ tham số ước lượng;

- $`\mathcal{l}_{t}(\Theta)`$ là đóng góp của quan sát t vào hàm hợp lý logarit;

- T là số quan sát trong mẫu.

Bộ tham số ước lượng $`\widehat{\Theta}`$ là các giá trị sao cho tổng giá trị log-likelihood của toàn bộ mẫu đạt giá trị lớn nhất với giả định phân phối đã lựa chọn. Với phương pháp MLE, các tham số này được ước lượng đồng thời sử dụng toàn bộ dữ liệu của mẫu. Một điểm rất quan trọng là hàm MLE phụ thuộc vào giả định phân phối của $`z_{t}`$. Mỗi giả định phân phối của $`z_{t}`$ sẽ tương ứng với một phương trình mật độ của phân phối xác suất khác nhau. Nếu $`z_{t}`$ được giả định phân phối chuẩn, mật độ xác suất trong hàm hợp lý sẽ khác so với trường hợp $`z_{t}`$ theo Student-t, skewed-t hoặc SGED. Do đó, lựa chọn phân phối ở mục 2.3 không chỉ ảnh hưởng đến phần diễn giải đuôi dày, mà còn ảnh hưởng trực tiếp đến quá trình ước lượng. Trên cơ sở hàm mật độ của phân phối xác suất được lựa chọn, bộ tham số sẽ được tối ưu hóa để đạt được tổng giá trị log-logarith của hàm mật độ lớn nhất với toàn bộ quan sát của chuỗi dữ liệu.[^1]

### Lựa chọn đặc tả mô hình

Việc lựa chọn mô hình bắt đầu từ phương trình trung bình. Với tỷ suất sinh lời ngày, trung bình có điều kiện thường nhỏ so với biến động có điều kiện. Tuy nhiên, việc lựa chọn phương trình trung bình cũng có thể tác động tới dự báo giá trị biến động bởi phần dư từ phương trình trung bình là đầu vào cho phương trình phương sai.

Về mặt thực hành, phương trình trung bình có thể được bắt đầu bằng mô hình đơn giản:

``` math
r_{t}\  = \mu\  + \varepsilon_{t}
```

hoặc, nếu dữ liệu có tự tương quan tuyến tính đáng kể, có thể dùng một ARMA bậc thấp:

``` math
\phi(B)\left( r_{t}\  - \mu \right) = \psi(B)\varepsilon_{t}\ 
```

Trong đó, B là toán tử trễ; $`\phi(B)`$ và $`\psi(B)`$ lần lượt là đa thức tự hồi quy và trung bình trượt. Mục đích không phải là tìm một phương trình trung bình phức tạp để dự báo tỷ suất sinh lời chính xác, mà là loại bỏ phần phụ thuộc tuyến tính rõ ràng trước khi mô hình hóa phương sai có điều kiện. Với dữ liệu chỉ số chứng khoán ngày, nếu phần tự tương quan của $`r_{t}`$ nhỏ hoặc không ổn định, trung bình hằng số thường là điểm khởi đầu hợp lý. Tuy nhiên, quyết định này cần dựa trên đồ thị, ACF, PACF và kiểm định phần dư, thay vì dựa vào thói quen.

Sau phương trình trung bình, bước tiếp theo là lựa chọn phương trình phương sai. Logic lựa chọn phương trình phương sai nên bắt đầu từ câu hỏi thực nghiệm. Nếu mục tiêu là mô tả cụm biến động, GARCH chuẩn có thể là mô hình nền. Nếu dữ liệu cho thấy phản ứng bất đối xứng của biến động trước cú sốc âm và cú sốc dương, các mô hình như GJR-GARCH, EGARCH hoặc APARCH nên được cân nhắc. Nếu quan tâm đến việc biến động ảnh hưởng ngược lại đến tỷ suất sinh lời kỳ vọng, GARCH-M là một lựa chọn phù hợp hơn về mặt lý thuyết, nhưng cần thận trọng khi diễn giải vì quan hệ rủi ro–lợi suất trong dữ liệu ngày thường không dễ nhận diện.

Bước tiếp theo sau khi đã mô tả phương trình trung bình và phương trình phương sai là lựa chọn giả định phân phối của sai số chuẩn hóa. Như đã trình bày ở trên, việc lựa chọn giả định phân phối cho sai số chuẩn hóa tùy thuộc vào lựa chọn của nhà đầu tư và nhà nghiên cứu, và đặc biệt là phụ thuộc vào tính chất của bộ dữ liệu và mục tiêu ước lượng cũng như dự báo trong mô hình. Thông thường, phân phối chuẩn thường được sử dụng như mô hình tham chiếu bởi tính đơn giản trong mô hình ước lượng. Nếu phần dư có đuôi dày nhưng tương đối đối xứng, phân hối Student-t thường phù hợp hơn. Nếu phần dư vừa đuôi dày vừa lệch, phân phối Student-t chệch là lựa chọn tự nhiên hơn. Nếu cần mô tả đồng thời độ chệch và hình dạng đuôi linh hoạt, SGED có thể được cân nhắc. SGT là khung rất tổng quát, nhưng số tham số nhiều hơn, quá trình ước lượng có thể khó ổn định hơn và diễn giải cũng phức tạp hơn.

Việc lựa chọn giả định phân phối cho sai số chuẩn cũng cần được lưu ý về sự đánh đổi giữa tính mô tả của mô hình và tính ổn định của các ước lượng tham số cũng như sự hiệu quả các các đự báo. Mô hình Student-t hoặc Student-t chệch có thể giúp cải thiện đáng kể giá trị log-likelihood nhưng nếu phân phối phức tạp hơn chỉ cải thiện rất nhỏ nhưng làm tham số thiếu ổn định, mô hình đơn giản hơn có thể phù hợp hơn với mục tiêu dự báo và diễn giải. Để đánh giá và so sánh giữa nhóm các mô hình ứng viên, nhà nghiên cứu có thể sử dụng các tiêu chí như AIC và BIC. Nhóm tiêu chí này cho biết, trên chính bộ dữ liệu đã dùng để ước lượng, mô hình nào cân bằng tốt hơn giữa hai yếu tố: mức độ khớp dữ liệu và độ phức tạp của mô hình.

Log-likelihood càng cao thường cho thấy mô hình làm cho dữ liệu quan sát được trở nên hợp lý hơn dưới giả định mô hình. Tuy nhiên, nếu chỉ nhìn log-likelihood, mô hình nhiều tham số hơn thường có lợi thế vì nó linh hoạt hơn. Vì vậy, AIC và BIC bổ sung phần phạt đối với độ phức tạp của mô hình. Gọi $`\mathcal{l}_{t}(\Theta)`$ là giá trị hàm hợp lý logarit tại bộ tham số ước lượng, k là số tham số được ước lượng và T là số quan sát. Hai tiêu chí có thể viết như sau:

``` math
AIC\  = \  - 2\mathcal{l(}\widehat{\Theta})\  + \ 2k
```

``` math
BIC\  = \  - 2\mathcal{l}\left( \widehat{\Theta} \right) + \ k\ ln(T)
```

Trong đó, phần $`2\mathcal{l(}\widehat{\Theta})`$) phản ánh mức độ khớp dữ liệu trong mẫu, còn phần 2k hoặc $`k\ ln(T)`$ là phần phạt cho số tham số. Mô hình tốt hơn là mô hình có giá trị tiêu chí thấp hơn, vì vậy, mô hình có nhiều tham số hơn chỉ được ưu tiên nếu phần cải thiện về log-likelihood đủ lớn để bù cho phần phạt này. Khi so sánh các mô hình được ước lượng trên cùng một bộ dữ liệu, mô hình có AIC hoặc BIC thấp hơn thường được xem là tốt hơn theo tiêu chí tương ứng. Tuy nhiên, AIC và BIC có xu hướng lựa chọn hơi khác nhau. AIC thường cho phép mô hình linh hoạt hơn, trong khi BIC phạt độ phức tạp mạnh hơn, đặc biệt khi số quan sát lớn. Vì vậy, trong nhiều trường hợp, AIC có thể chọn mô hình phức tạp hơn còn BIC chọn mô hình gọn hơn.

Đây không phải là mâu thuẫn, mà phản ánh hai cách cân bằng khác nhau giữa mức độ khớp dữ liệu và tính đơn giản của mô hình.Các tiêu chí thông tin cũng không nên được hiểu như bằng chứng cuối cùng. Tsay (2013) lưu ý rằng các tiêu chí khác nhau có thể dẫn đến lựa chọn bậc mô hình khác nhau, và trong thực hành không có bằng chứng chắc chắn rằng một tiêu chí luôn vượt trội trong mọi ứng dụng; thông tin thực chất về vấn đề nghiên cứu và tính đơn giản cũng đóng vai trò quan trọng.

Một vấn đề nữa cần nhấn mạnh là là AIC và BIC chỉ là tiêu chí **t**rong mẫu, đánh giá mức độ khớp của dữ liệu với mô tả mô hình đã lựa chọn. Các tiêu chí này trả lời câu hỏi: “Trong các mô hình đã ước lượng, mô hình nào mô tả dữ liệu đã quan sát tốt hơn sau khi đã tính đến số tham số?” Các tiêu chí không trả lời trực tiếp câu hỏi: “Mô hình nào dự báo biến động tương lai tốt hơn?” Vì vậy, trong quy trình thực nghiệm, AIC và BIC nên được dùng như một bước sàng lọc ban đầu. Các tiêu chí này giúp thu hẹp tập mô hình ứng viên trước khi kiểm định phần dư và đánh giá dự báo ngoài mẫu. Một mô hình có AIC/BIC thấp nhưng phần dư chuẩn hóa vẫn còn tự tương quan hoặc bình phương phần dư chuẩn hóa vẫn còn cụm biến động thì chưa nên được chọn ngay. Tương tự, một mô hình có AIC/BIC tốt trong mẫu vẫn có thể dự báo ngoài mẫu kém nếu nó quá khớp dữ liệu quá khứ.

### Kiểm định chuẩn đoán mô hình ước lượng

Sau khi mô hình biến động đã được ước lượng, bước tiếp theo không phải là thực hiện luôn đự báo hoặc so sánh dự báo, mà cần kiểm tra xem mô hình đã hấp thụ được các cấu trúc chính trong dữ liệu hay chưa. Kiểm định chẩn đoán là bước quan trọng nhất trước khi chuyển từ mô hình ước lượng sang mô hình dự báo. Nguyên tắc kiểm định chuẩn đoán với mô hình phương sai có điều kiện là nếu phương trình trung bình đã mô tả được phần có thể dự báo của tỷ suất sinh lời và phương trình phương sai đã mô tả được cụm biến động, thì phần còn lại sau khi chuẩn hóa không nên còn biểu hiện tự tương quan rõ rệt hoặc cụm biến động rõ rệt.

Giả sử, sau khi ước lượng, ta thu được phần dư ước lượng $`{\widehat{\varepsilon}}_{t}`$ và độ lệch chuẩn có điều kiện $`{\widehat{\sigma}}_{t}`$. Phần dư chuẩn hóa được xác định là:

``` math
{\widehat{z}}_{t}\  = \ \frac{{\widehat{\varepsilon}}_{t}}{\ {\widehat{\sigma}}_{t}}
```

Nếu mô hình trung bình có nhiệm vụ loại bỏ cấu trúc dự báo được trong trung bình có điều kiện. Mô hình phương sai có nhiệm vụ loại bỏ cấu trúc dự báo được trong biến động có điều kiện. Vì vậy, nếu mô hình phù hợp, phần dư chuẩn hóa $`{\widehat{z}}_{t}`$ không nên còn tự tương quan rõ rệt, và bình phương phần dư chuẩn hóa $`{\widehat{z}}_{t}^{2}`$ không nên còn cụm biến động rõ rệt. Nói cách khác, mô hình đã thành công nếu phần còn lại sau khi lọc gần giống một chuỗi nhiễu không có cấu trúc động đáng kể. Hyndman và Athanasopoulos (2023) nhấn mạnh rằng một phương pháp dự báo tốt nên để lại phần dư đổi mới không còn tương quan; nếu phần dư còn tương quan, trong dữ liệu vẫn còn thông tin mà mô hình chưa khai thác. Đồng thời, phần dư nên có trung bình xấp xỉ 0 để tránh dự báo bị lệch.

Đối với chuẩn đoán kết quả ước lượng trong mô hình GARCH, $`{\widehat{z}}_{t}`$ và $`{\widehat{z}}_{t}^{2}`$ có vai trò khác nhau. Chuỗi $`{\widehat{z}}_{t}`$ được dùng để kiểm tra xem phương trình trung bình còn bỏ sót phụ thuộc tuyến tính hay không. Nếu $`{\widehat{z}}_{t}`$ còn tự tương quan, điều này hàm ý mô hình trung bình có thể chưa đủ, chẳng hạn cần xem lại trung bình hằng số, thành phần ARMA. Ngược lại, chuỗi $`{\widehat{z}}_{t}^{2}`$ được dùng để kiểm tra xem phương trình phương sai còn bỏ sót hiệu ứng ARCH/GARCH hay không. Nếu $`{\widehat{z}}_{t}^{2}`$ còn tự tương quan, điều đó cho thấy biến động vẫn có cấu trúc động chưa được mô hình hóa đầy đủ.

Về thực hành, bước chẩn đoán nên kết hợp cả đồ thị và kiểm định thống kê. Đồ thị chuỗi $`{\widehat{z}}_{t}`$ giúp quan sát xem phần dư sau chuẩn hóa còn các cụm dao động mạnh hay không. ACF của $`{\widehat{z}}_{t}`$ giúp kiểm tra tự tương quan trong phần dư. ACF hoặc PACF của $`{\widehat{z}}_{t}^{2}`$ giúp kiểm tra hiệu ứng ARCH còn sót. Kiểm định Ljung–Box là phiên bản định lượng của kiểm tra ACF. Thay vì nhìn từng hệ số tự tương quan riêng lẻ, kiểm định này xem xét đồng thời một nhóm độ trễ. Kiểm định Ljung–Box có thể được áp dụng cho cả $`{\widehat{z}}_{t}`$ và $`{\widehat{z}}_{t}^{2}`$. Với kiểm định Ljung–Box, ý tưởng là kiểm tra đồng thời một nhóm hệ số tự tương quan thay vì nhìn từng độ trễ riêng lẻ; giá trị thống kê lớn cho thấy các tự tương quan không phù hợp với giả thuyết nhiễu trắng (white-noise). Gọi $`{\widehat{\rho}}_{k}`$ là hệ số tự tương quan mẫu tại độ trễ k của chuỗi cần kiểm tra, T là số quan sát và m là số độ trễ được xét. Thống kê Ljung–Box có dạng:

``` math
Q^{*} = \ T(T + 2)\sum_{k = 1}^{m}\frac{{\widehat{\rho}}_{k}^{2}}{T - k}
```

Giả thuyết gốc của kiểm định là không có tự tương quan đến độ trễ m. Khi áp dụng cho $`{\widehat{z}}_{t}`$, kiểm định trả lời câu hỏi: phần dư chuẩn hóa còn phụ thuộc tuyến tính hay không. Khi áp dụng cho $`{\widehat{z}}_{t}^{2}`$, kiểm định trả lời câu hỏi: bình phương phần dư chuẩn hóa còn phụ thuộc động hay không. Nếu kiểm định trên $`{\widehat{z}}_{t}^{2}`$ cho kết quả bác bỏ giả thuyết gốc, phương trình phương sai có thể chưa mô tả hết cụm biến động.

ARCH LM test là kiểm định trực tiếp hơn cho hiệu ứng ARCH còn sót. Về trực giác, kiểm định này hồi quy bình phương phần dư lên các độ trễ của chính nó để xem quá khứ của bình phương phần dư còn giải thích được hiện tại hay không. Giả thuyết gốc thường là không còn hiệu ứng ARCH đến bậc kiểm định. Kiểm định này dựa trên hồi quy phụ của $`{\widehat{z}}_{t}^{2}`$ như sau:

``` math
{\widehat{z}}_{t}^{2}\ \ \  = \ c\  + \alpha_{1}{\widehat{z}}_{t - 1\ }^{2}\  + \alpha_{2}{\widehat{z}}_{t - 2\ }^{2}\  + \cdots\  + \alpha_{m}{\widehat{z}}_{t - m\ }^{2} + \ u_{t}\ 
```

Giả thuyết gốc là:

``` math
H_{0}:\ \alpha_{1}\  = \alpha_{2} = \cdots = \alpha_{m} = 0,\ 
```

Nếu bác bỏ $`H_{0}`$, có bằng chứng cho thấy phần dư chuẩn hóa vẫn còn hiệu ứng ARCH, nghĩa là mô hình phương sai hiện tại chưa hấp thụ hết cấu trúc biến động. Khi đó, nhà nghiên cứu có thể cân nhắc thay đổi bậc GARCH, thử mô hình bất đối xứng như GJR-GARCH hoặc EGARCH, hoặc xem lại giả định phân phối của sai số chuẩn hóa.

### Dự báo biến động tỷ lệ sinh lời

#### Các phương pháp dự báo

Sau khi mô hình đã vượt qua bước chẩn đoán ở mức chấp nhận được, mô hình cần được đánh giá bằng dự báo ngoài mẫu. Lý do là một mô hình khớp tốt trong mẫu chưa chắc dự báo tốt trong tương lai. Một mô hình có nhiều tham số có thể mô tả rất tốt dữ liệu đã dùng để ước lượng, nhưng lại hoạt động kém khi gặp dữ liệu mới. Hyndman và Athanasopoulos (2023) nhấn mạnh rằng độ chính xác dự báo chỉ có thể được đánh giá bằng dữ liệu không được dùng để ước lượng mô hình; phần dữ liệu dùng để ước lượng gọi là dữ liệu ước lương trong mẫu *(in-sample – IS)*, còn phần giữ lại để đánh giá gọi là dữ liệu ngoài mẫu (*out-of-sample set – OOS*)

Để dự báo biến động tỷ lệ sinh lời ngoài mẫu, chúng ta cần chia mẫu dữ liệu thành hai phần. Giả sử chuỗi tỷ lệ sinh lời có T quan sát, khi đó $`\{ r_{1},\ r_{2},\ \ldots,\ r_{T_{0}}\}`$ là mẫu ước lượng ban đầu, và: $`\left\{ r_{T_{0} + 1},\ r_{T_{0} + 2},\ \ldots,\ r_{T} \right\}`$ là mẫu kiểm định ngoài mẫu. Tại mỗi thời điểm dự báo t, mô hình được ước lượng bằng dữ liệu sẵn có đến thời điểm t, sau đó tạo dự báo biến động cho kỳ t+1, $`{\widehat{\sigma}}_{t + 1 \mid t}`$, hoặc dự báo phươn sai, $`{\widehat{\sigma}}_{t + 1 \mid t}^{2}`$.

Trên thực tế, hai thiết kế mô hình dự báo phổ biến là phương pháp dự báo cửa sổ trượt (*rolling window forecast*) và mô hình dự báo cửa sổ mở rộng (*recursive window forecast).* Với phương pháp dự báo cửa sổ trượt, độ dài cửa sổ ước lượng được giữ cố định cho mỗi bước dự báo. Ví dụ, nếu dùng W quan sát gần nhất để ước lượng, thì tại thời điểm t mô hình được ước lượng bằng $`\{ r_{t - W + 1},\ r_{t - W + 2},\ \ldots,\ r_{t}\}`$ sau đó tạo dự báo $`{\widehat{\sigma}}_{t + 1 \mid t}`$. Khi chuyển sang thời điểm t+1, cửa sổ dịch lên một quan sát: bỏ quan sát cũ nhất và thêm quan sát mới nhất. Phương pháp này phù hợp khi nghi ngờ cấu trúc thị trường thay đổi theo thời gian, chẳng hạn giai đoạn sau COVID-19 có thể khác đáng kể giai đoạn trước đó. Với phương pháp dự báo cửa sổ mở rộng, số lượng quan sát của cửa số ước lượng tăng dần theo thời gian. Tại thời điểm t, mô hình được ước lượng bằng $`\{ r_{1},\ r_{2},\ \ldots,\ r_{t}\}`$ sau đó tạo dự báo $`{\widehat{\sigma}}_{t + 1 \mid t}`$. Khi có thêm quan sát mới, mẫu ước lượng được mở rộng. Phương pháp dự báo cửa sổ mở rộng tận dụng toàn bộ thông tin quá khứ, do đó có thể ổn định hơn khi tham số không thay đổi mạnh. Tuy nhiên, nếu thị trường có thay đổi cấu trúc, phương pháp dự báo cửa sổ mở rộng có thể phản ứng chậm vì các quan sát rất cũ vẫn có ảnh hưởng đến ước lượng hiện tại.

> **Hình 2.11. Phương pháp dự báo cửa sổ trượt và cửa sổ mở rộng**

<img src="media/image11.png" style="width:6.10278in;height:3.7in" alt="A graph with a number of lines AI-generated content may be incorrect." />

*Nguồn: Minh họa của tác giả*

### Tham chiếu đánh giá các mô hình dự báo

Sau khi đã lựa chọn mô hình, ước lượng tham số và tạo ra chuỗi dự báo biến động ngoài mẫu, câu hỏi tiếp theo là: mô hình nào dự báo tốt hơn? Đây là bước khác với việc so sánh AIC hoặc BIC. AIC và BIC chỉ cho biết mô hình nào khớp dữ liệu trong mẫu ước lượng tốt hơn sau khi tính đến số tham số. Ngược lại, so sánh chất lượng dự báo nhằm trả lời câu hỏi thực tế hơn: khi gặp dữ liệu mới chưa dùng để ước lượng, mô hình nào dự báo biến động sát hơn với biến động thực tế? Để đánh giá dự báo, ta cần đặt cạnh nhau hai đại lượng. Đại lượng thứ nhất là biến động dự báo từ mô hình:

``` math
{\widehat{v}}_{t + 1|t}\  = \ {\widehat{\sigma}}_{t + 1|t}^{2}
```

Đại lượng thứ hai là biến động thực tế hoặc biến động đại diện sau khi ngày t+1 đã kết thúc, được tính toán trên dữ liệu ngoài mẫu OOS $`v_{t + 1}`$, thể hiện biến động tỷ lệ sinh lời thực tế. Khi đó, chất lượng dự báo được đánh giá bằng mức độ chênh lệch giữa $`v_{t + 1}`$ và $`{\widehat{v}}_{t + 1|t}`$ được ước lượng từ mô hình.

Biến động tỷ lệ sinh lời thực tế RV (*Realized Volatility)* đã trình bày ở Chương 1 được sử dụng làm tham chiếu để so sánh dự báo của các mô hình. Thước đo thường được sử dụng nhất là biến động tỷ lệ sinh lời thực tế xây dựng từ dữ liệu tần suất cao trong ngày:

``` math
RV_{t} = \sqrt{\sum_{j = 1}^{M}r_{t,j}^{2}}.
```

Việc sử dụng dữ liệu giao dịch tần suất cao (có thể theo phút, 5 phút hoặc từng khung 10 phút trong ngày) giúp phản ánh chi tiết hơn hơn động giá xảy ra trong ngày giao dịch. Trên thực tế, trong nhiều bối cảnh thực nghiệm, đặc biệt ở các thị trường mới nổi, dữ liệu tần suất cao không phải lúc nào cũng sẵn có, dễ truy cập hoặc đủ sạch để sử dụng trực tiếp. Trong bối cảnh đó, một hướng thay thế là sử dụng các thước đo biến động dựa trên biên độ giá trong ngày, khai thác thông tin từ giá mở cửa, giá cao nhất, giá thấp nhất và giá đóng cửa trong ngày. Ký hiệu $`O_{t},\ H_{t},\ L_{t},\ C_{t}`$ lần lượt là giá mở cửa, giá cao nhất, giá thấp nhất và giá đóng cửa trong ngày *t*. Khi đó, một số thước đo biến động dựa trên dữ liệu ngày có thể được viết như sau.

*Thước đo Parkinson*

Thước đo Parkinson sử dụng biên độ giữa giá cao nhất và giá thấp nhất trong ngày. Ý tưởng là nếu khoảng cách giữa $`H_{t}`$ và$`\ L_{t}`$ càng lớn, mức dao động trong ngày càng cao.

``` math
\sigma_{P,t}^{2} = \frac{\left( \ln\left( \frac{H_{t}}{L_{t}} \right) \right)^{2}}{4ln2}
```

Thước đo này chỉ cần giá cao nhất và giá thấp nhất. Do đó, thước đo này phù hợp khi dữ liệu có đủ giá cao nhất - thấp nhất nhưng không muốn phụ thuộc hoàn toàn vào tỷ suất sinh lời đóng cửa - đóng cửa. Hạn chế của thước đo này là không sử dụng thông tin giá mở cửa và giá đóng cửa, đồng thời dựa trên giả định khá chặt về quá trình giá trong ngày.

*Thước đo Garman–Klass*

Thước đo Garman–Klass sử dụng cả biên độ cao nhất - thấp nhất và biến động từ mở cửa đến đóng cửa. Do đó, thước đo này khai thác nhiều thông tin hơn thước đo Parkinson.

``` math
\sigma_{GK,t}^{2} = \frac{1}{2}\left( \ln\left( \frac{H_{t}}{L_{t}} \right) \right)^{2} - (2ln2 - 1)\left( \ln\left( \frac{C_{t}}{O_{t}} \right) \right)
```

Theo đó, thành phần thứ nhất đo biên độ dao động trong ngày, còn thành phần thứ hai điều chỉnh theo mức thay đổi từ mở cửa đến đóng cửa. Thước đo này thường hiệu quả hơn thước đo chỉ dùng giá đóng cửa trong các điều kiện giả định phù hợp, nhưng có thể kém phù hợp nếu tồn tại biến động qua đêm hoặc xu hướng giá đáng kể trong phiên.

*Thước đo Rogers–Satchell*

Thước đo Rogers–Satchell được thiết kế để xử lý tốt hơn trường hợp quá trình giá có xu hướng trong ngày. Thước đo này sử dụng đồng thời giá mở cửa, cao nhất, thấp nhất và đóng cửa.

``` math
\sigma_{RS,t}^{2} = \ln\left( \frac{H_{t}}{O_{t}} \right)\ln\left( \frac{H_{t}}{C_{t}} \right) + \ln\left( \frac{L_{t}}{O_{t}} \right)\ln\left( \frac{L_{t}}{C_{t}} \right)
```

Thước đo Rogers–Satchell có ưu điểm là khai thác đầy đủ hơn cấu trúc dao động trong ngày, đặc biệt khi giá không chỉ dao động ngẫu nhiên quanh mức mở cửa mà có thể có xu hướng tăng hoặc giảm trong phiên. Tuy nhiên, giống các thước đo OHLC khác, thước đo này vẫn phụ thuộc vào chất lượng dữ liệu giá cao nhất và thấp nhất trong ngày.

*Thước đo Yang–Zhang*

Thước đo Yang–Zhang kết hợp ba nguồn thông tin: biến động qua đêm, biến động từ mở cửa đến đóng cửa và thành phần Rogers–Satchell trong ngày. Cách tiếp cận này hữu ích khi biến động qua đêm có vai trò quan trọng, chẳng hạn khi tin tức xuất hiện ngoài giờ giao dịch.

Ký hiệu tỷ suất sinh lời qua đêm là:

``` math
r_{o,t} = ln\left( \frac{O_{t}}{C_{t - 1}} \right)
```

Ký hiệu tỷ suất sinh lời từ mở cửa đến đóng cửa là:

``` math
r_{c,t} = ln\left( \frac{C_{t}}{O_{t}} \right)
```

Với một cửa sổ gồm *n* quan sát, phương sai Yang–Zhang có thể viết ở dạng tổng quát:

``` math
\sigma_{YZ}^{2} = \sigma_{o}^{2} + k\sigma_{c}^{2} + (1 - k)\sigma_{RS}^{2}
```

Trong đó, $`\sigma_{o}^{2}`$ là phương sai của tỷ suất sinh lời qua đêm, $`\sigma_{c}^{2}\`$là phương sai của tỷ suất sinh lời từ mở cửa đến đóng cửa, $`\sigma_{RS}^{2}`$ là trung bình của thành phần Rogers–Satchell trong cửa sổ ước lượng, và *k* là trọng số điều chỉnh. Một dạng trọng số thường được sử dụng là:

``` math
k = \frac{0.34}{1.34 + \frac{n + 1}{n - 1}}
```

Thước đo Yang–Zhang có ý nghĩa thực nghiệm quan trọng vì nó tách riêng biến động qua đêm và biến động trong phiên. Đối với thị trường chứng khoán Việt Nam, điều này có thể hữu ích vì thông tin vĩ mô, chính sách hoặc tin tức doanh nghiệp có thể xuất hiện ngoài giờ giao dịch và phản ánh vào giá mở cửa ngày hôm sau. Tuy nhiên, khi sử dụng thước đo này, nhà nghiên cứu cần bảo đảm dữ liệu mở cửa, cao nhất, thấp nhất và đóng cửa được xử lý nhất quán, đặc biệt trong các ngày có điều chỉnh kỹ thuật, thay đổi rổ chỉ số hoặc dữ liệu bị thiếu.

### Các tiêu chí so sánh dự báo

Sau khi đã chọn được thang đo biến động tỷ lệ sinh lời thực tế $`v_{t}`$, bước tiếp theo là so sánh giá trị này với dự báo phương sai $`{\widehat{v}}_{t|t - 1}\  = \ {\widehat{\sigma}}_{t|t - 1}^{2}`$ từ các mo hình ước lượng và xác định sai số dự báo như sau:

``` math
e_{t}^{v}\  = \ v_{t}\  - \ {\widehat{v}}_{t|t - 1}
```

Một số tiêu chí so sánh dự báo biến động tỷ lệ sinh lời thường được sử dụng như sau.

``` math
MSE\  = \ \frac{1}{N}\sum_{t = 1}^{N}\left( v_{t}\  - \ {\widehat{v}}_{t|t - 1} \right)^{2}
```

``` math
MAE\  = \ \frac{1}{N}\sum_{t = 1}^{N}|v_{t}\  - \ {\widehat{v}}_{t|t - 1}|
```

``` math
RMSE = \sqrt{MSE}
```

``` math
QLIKE = \ \frac{1}{N}\sum_{t = 1}^{N}\left\lbrack \log\left( {\widehat{v}}_{t|t - 1} \right) + \frac{v_{t}}{{\widehat{v}}_{t|t - 1}} \right\rbrack
```

Các tiêu chí so sánh này cũng có sự khác nhau tương đối. MSE phạt mạnh các sai số lớn. Nếu một mô hình dự báo quá thấp trong những ngày biến động rất mạnh, MSE sẽ tăng đáng kể. Vì vậy, MSE hữu ích khi nhà nghiên cứu muốn nhấn mạnh khả năng dự báo trong giai đoạn thị trường biến động cao. Tuy nhiên, nó cũng nhạy cảm với các quan sát hoặc sai số dự báo ngoại lai. MAE dễ diễn giải hơn vì đo độ lệch tuyệt đối trung bình. So với MSE, MAE ít bị chi phối bởi một vài quan sát cực trị. Nếu MSE và MAE cùng cho kết luận giống nhau, kết quả so sánh dự báo sẽ thuyết phục hơn. Nếu hai tiêu chí cho kết luận khác nhau, cần xem xét mô hình nào xử lý tốt hơn trong giai đoạn bình thường và mô hình nào xử lý tốt hơn trong giai đoạn biến động cực đoan. QLIKE thường được dùng trong đánh giá dự báo phương sai vì nó phù hợp với bản chất dương của phương sai dự báo. Các nghiên cứu dự báo realized volatility vẫn sử dụng QLIKE cùng với MSE để đánh giá chất lượng mô hình dự báo biến động.

Trong diễn giải kết quả, mô hình có MSE, MAE hoặc QLIKE thấp hơn được xem là dự báo tốt hơn theo tiêu chí tương ứng. Tuy nhiên, không nên khẳng định một mô hình “tốt nhất” chỉ dựa trên một tiêu chí. Một mô hình có MSE thấp có thể dự báo tốt hơn trong các giai đoạn biến động mạnh, nhưng MAE lại không thấp nhất. Một mô hình có QLIKE thấp có thể phù hợp hơn về mặt dự báo phương sai, nhưng cần kiểm tra xem kết quả có ổn định khi thay đổi tham chiếu biến động tỷ lệ sinh lời thực tế hay không.

## Kết luận chương 2

Chương 2 đã chuyển trọng tâm từ việc nhận diện và đo lường biến động sang câu hỏi dự báo biến động của tỷ lệ sinh lời. Các phương pháp giản đơn như biến động lịch sử, cửa sổ trượt và EWMA cho thấy biến động có thể được cập nhật theo thông tin quá khứ với mức độ phản ứng khác nhau. Tuy nhiên, các phương pháp này chủ yếu đóng vai trò nền tảng và chuẩn so sánh, do mô hình hóa đầy đủ cấu trúc động của phương sai có điều kiện.

Trên cơ sở đó, chương đã giới thiệu họ mô hình ARCH/GARCH và các mở rộng như GJR-GARCH, EGARCH, APARCH và GARCH-M. Các mô hình này cho phép mô tả những đặc điểm quan trọng của tỷ lệ sinh lời tài chính, bao gồm cụm biến động, độ dai dẳng của biến động, phản ứng bất đối xứng trước cú sốc âm và cú sốc dương, cũng như khả năng biến động có điều kiện ảnh hưởng đến tỷ lệ sinh lời kỳ vọng. Chương cũng nhấn mạnh rằng dự báo rủi ro không chỉ phụ thuộc vào phương trình phương sai, mà còn phụ thuộc vào giả định phân phối của sai số chuẩn hóa $`z_{t}`$. Việc lựa chọn giữa phân phối chuẩn, Student-t, Student-t chệch, SGED hoặc SGT có thể làm thay đổi đáng kể phân vị đuôi và do đó ảnh hưởng trực tiếp đến VaR và ES.

Một điểm quan trọng khác của chương là mô hình biến động không nên được lựa chọn chỉ dựa trên mức độ phức tạp hoặc khả năng khớp dữ liệu trong mẫu. Quy trình ước lượng, lựa chọn mô hình và kiểm định chẩn đoán cần được thực hiện một cách có hệ thống. Một mô hình chỉ nên được sử dụng cho dự báo rủi ro khi phần dư chuẩn hóa không còn tự tương quan đáng kể và bình phương phần dư chuẩn hóa không còn biểu hiện cụm biến động rõ rệt.

[^1]: Các lưu ý ký thuật chi tiết của ước lượng MLE với các hàm phân phối xác suất khác nhau được trình bày ở Phụ lục.
