# Chương 1

# TỔNG QUAN VỀ TỶ LỆ SINH LỜI TÀI SẢN, BIẾN ĐỘNG TỶ LỆ SINH LỜI VÀ RỦI RO ĐUÔI

## 1.1. Sự cần thiết của đo lường biến động và rủi ro đuôi của tỷ lệ sinh lời tài sản

1.  **Rủi ro thị trường trong hoạt động đầu tư**

Trong tài chính hiện đại, rủi ro không chỉ được hiểu là khả năng kết quả thực tế khác với kỳ vọng, mà quan trọng hơn, là khả năng giá trị của một vị thế đầu tư hoặc một danh mục tài chính suy giảm bất lợi trong tương lai. Một nhà đầu tư nắm giữ cổ phiếu có thể chịu lỗ khi giá cổ phiếu giảm; một ngân hàng nắm giữ danh mục trái phiếu có thể chịu lỗ khi lãi suất tăng; một doanh nghiệp có nghĩa vụ thanh toán ngoại tệ có thể chịu lỗ khi tỷ giá biến động bất lợi; một tổ chức tài chính có danh mục kinh doanh chứng khoán có thể chịu lỗ khi thị trường rơi vào trạng thái bán tháo, thanh khoản suy giảm hoặc tương quan giữa các tài sản tăng đột ngột. Các trường hợp này đều phản ánh bản chất của rủi ro thị trường: tổn thất phát sinh từ sự thay đổi bất lợi của các yếu tố thị trường như giá cổ phiếu, lãi suất, tỷ giá, giá hàng hóa và biến động của các tài sản tài chính <span class="mark">\[citation needed: textbook source on market risk, e.g. Jorion; McNeil, Frey & Embrechts; Tsay\]</span>

Lịch sử thị trường tài chính toàn cầu cho thấy rủi ro đuôi thường bộc lộ rõ nhất khi tổn thất tích tụ ngoài phạm vi kiểm soát thông thường. Một ví dụ điển hình như sự sụp đổ của Ngân hàng Barings năm 1995 gắn với các giao dịch trái phép và khoản lỗ không được báo cáo kịp thời; tương tự là trường hợp của quỹ đầu tư Long-Term Capital Management (LTCM) năm 1998 lại cho thấy cách đòn bẩy cao, vị thế phức tạp và biến động thị trường có thể tạo ra rủi ro lan truyền đối với nhiều định chế tài chính <span class="mark">\[citation needed: Jorion or Choudhry or McNeil et al.\]</span> Các sự kiện này không chỉ là những câu chuyện khủng hoảng riêng lẻ, mà còn nhấn mạnh nhu cầu đo lường phần đuôi của phân phối tổn thất, nơi các khoản lỗ hiếm gặp nhưng nghiêm trọng có thể xuất hiện.

Tại Việt Nam, thị trường chứng khoán đã phát triển nhanh về quy mô, sản phẩm và mức độ kết nối, nhưng vẫn cần được phân tích trong bối cảnh một thị trường mới nổi đang hoàn thiện về hạ tầng, thanh khoản, công bố thông tin và cơ sở nhà đầu tư. Việc FTSE Russell thông báo nâng hạng Việt Nam từ thị trường cận biên lên thị trường mới nổi thứ cấp, với hiệu lực dự kiến từ tháng 9 năm 2026 nếu các điều kiện vận hành tiếp tục được đáp ứng, cho thấy trạng thái thị trường đang thay đổi theo thời gian. Vì vậy, các nhận định về rủi ro thị trường Việt Nam cần được đặt trong mốc thời gian cụ thể, thay vì xem đặc điểm thị trường là bất biến.

Với những lý do kể trên, quản trị rủi ro thị trường đã và đang trở thành vấn đề trọng yếu vì các quyết định tài chính luôn được đưa ra trong điều kiện bất định. Khi nắm giữ một tài sản tài chính, nhà đầu tư hoặc tổ chức tài chính không chỉ quan tâm đến khả năng sinh lời, mà còn quan tâm đến khả năng thua lỗ. Nếu giá tài sản tăng, vị thế có thể tạo ra lợi nhuận; nếu giá tài sản giảm, vị thế có thể tạo ra tổn thất. Đối với một danh mục lớn hơn, tổn thất còn phụ thuộc vào mức độ biến động của từng tài sản, tương quan giữa các tài sản, mức độ tập trung danh mục, đòn bẩy và điều kiện thanh khoản của thị trường.

Điểm quan trọng là rủi ro thị trường thường không thể được đánh giá đầy đủ chỉ bằng cách quan sát mức giá hiện tại. Giá hiện tại cho biết tài sản đang được giao dịch ở đâu, nhưng không cho biết giá có thể thay đổi mạnh đến mức nào trong tương lai. Vì vậy, phân tích rủi ro thị trường thường bắt đầu bằng việc chuyển dữ liệu giá thành tỷ suất sinh lời, sau đó nghiên cứu phân phối của tỷ suất sinh lời hoặc phân phối tổn thất tương ứng. Cách tiếp cận này cho phép nhà nghiên cứu đặt ra những câu hỏi định lượng rõ ràng hơn: tỷ suất sinh lời dao động mạnh hay yếu, xác suất lỗ lớn là bao nhiêu, và trong những trường hợp bất lợi, tổn thất có thể nghiêm trọng đến mức nào.

Trong quản trị rủi ro, câu hỏi trung tâm không phải là “tài sản này có chắc chắn sinh lời hay không”, mà là “nếu thị trường diễn biến bất lợi, mức tổn thất có thể lớn đến đâu trong một khoảng thời gian xác định”. Câu hỏi này là nền tảng để hiểu vì sao biến động của tỷ lệ sinh lời (*volatility*), giá trị chịu rủi ro (*Value-at-Risk, VaR*) và tổn thất kỳ vọng trong vùng đuôi (*Expected Shortfall, ES*) trở thành các thước đo quan trọng trong tài chính định lượng và quản trị rủi ro thị trường. \[citation needed: Jorion, 2007; McNeil, Frey & Embrechts, 2015\]. Trên cơ sở đó và trong khuôn khổ cuốn sách này, tác giá tiến hành lượng hóa các ước lượng rủi ro này đối với hoạt động đầu tư chứng khoán trên thị trường Viẹt Nam.

2.  **Biến động tỷ lệ sinh lời (Return Volatility)**

Biến động tỷ lệ sinh lời là một trong những khái niệm trung tâm của tài chính định lượng, phản ánh mức độ dao động của tỷ lệ sinh lời quanh giá trị trung bình. Với tài sản có mức độ biến động tỷ lệ sinh lời thấp, tỷ lệ sinh lời thực tế mà nhà đầu tư có thể nhận được có xu hướng dao động trong biên độ hẹp. Ngược lại, với các tài sản có biến động tỷ lệ sinh lời cao, kết quả đầu tư có thể biến động mạnh hơn, bao gồm cả khả năng lãi lớn và lỗ lớn. Vì nhà đầu tư thường nhạy cảm hơn với tổn thất so với lãi bất thường, tài sản có biến động tỷ lệ sinh lời cao thường được xem là có rủi ro thị trường cao hơn.

Việc đo lường và dự báo biến động của tỷ lệ sinh lời có nhiều ứng dụng quan trọng trong tài chính. Trong quản trị danh mục, biến động là yếu tố đầu vào để đánh giá sự đánh đổi giữa rủi ro và lợi nhuận kỳ vọng. Trong định giá quyền chọn, biến động là biến số then chốt ảnh hưởng đến giá trị hợp đồng. Trong quản trị rủi ro của ngân hàng, công ty chứng khoán và các tổ chức đầu tư, biến động là đầu vào quan trọng của nhiều mô hình đo lường tổn thất tiềm năng. Trong giám sát thị trường, sự gia tăng đột ngột của biến động toàn thị trường có thể phản ánh tâm lý bất ổn, áp lực bán tháo, suy giảm thanh khoản hoặc phản ứng của thị trường trước các thông tin vĩ mô, chính sách và sự kiện bất thường. <span class="mark">\[citation needed: Tsay, 2010; Tsay, 2013; Brooks, 2019\].</span>

Tuy nhiên, biến động tỷ lệ sinh lời không phải là một biến quan sát trực tiếp giống như giá tài sản. Giá cổ phiếu, chỉ số chứng khoán, lãi suất hoặc tỷ giá có thể được quan sát từ dữ liệu thị trường; tỷ lệ sinh lời có thể được tính trực tiếp từ giá; nhưng biến động tỷ lệ sinh lời là một đặc điểm thống kê của tỷ lệ sinh lời và phải được ước lượng từ dữ liệu. Đây là lý do có nhiều cách đo biến động tỷ lệ sinh lời khác nhau như thông độ lệch chuẩn mẫu của chuỗi tỷ lệ sinh lời, độ biến động lịch sử (*historical volatility*), độ biến động theo cửa sổ trượt (*rolling volatility*), độ biến động thực tế (*realized volatility*), độ biến động ẩn (*implied volatility*) và độ biến động có điều kiện (*conditonal volatility*). Trong đó, mỗi cách đo phản ánh một góc nhìn khác nhau về biến động, tùy thuộc vào tần suất dữ liệu, mục tiêu phân tích và giả định mô hình <span class="mark">(Tsay, 2010, 2013).</span>

Một đặc điểm thực nghiệm quan trọng của biến động là nó thay đổi theo thời gian. Trong các giai đoạn thị trường ổn định, biến động có thể duy trì ở mức thấp; trong các giai đoạn khủng hoảng, xuất hiện tin tức bất lợi hoặc thanh khoản suy giảm, biến động có thể tăng mạnh. Nói cách khác, rủi ro thị trường không phải lúc nào cũng ở cùng một mức. Các giai đoạn biến động cao thường có xu hướng đi kèm với nhau, và các giai đoạn biến động thấp cũng có xu hướng kéo dài. Hiện tượng này là cơ sở thực nghiệm quan trọng cho các mô hình phương sai có điều kiện như ARCH và GARCH, sẽ được trình bày ở Chương 2. <span class="mark">\[citation needed: Engle, 1982; Bollerslev, 1986\]</span>

Vì biến động thay đổi theo thời gian, dự báo biến động là bước trung gian quan trọng giữa phân tích tỷ lệ sinh lời và đo lường rủi ro thị trường. Nếu mức biến động được dự báo quá thấp so với thực tế, mô hình rủi ro có thể đánh giá thấp tổn thất tiềm năng, làm cho hạn mức rủi ro hoặc mức vốn dự phòng trở nên thiếu thận trọng. Ngược lại, nếu biến động bị dự báo quá cao, tổ chức có thể phân bổ vốn quá mức cho rủi ro, làm giảm hiệu quả sử dụng nguồn lực. Do đó, dự báo biến động không chỉ có ý nghĩa thống kê, mà còn có ý nghĩa trực tiếp đối với đo lường VaR, ES, quản trị danh mục và đánh giá khả năng chịu đựng rủi ro của tổ chức. <span class="mark">\[citation needed: Ding and Meade, 2010\]</span>

3.  **Rủi ro đuôi (*Tail-risk*)**

Mặc dù biến động tỷ lệ sinh lời cho biết mức độ phân tán chung của tỷ lệ sinh lời, nhưng giá trị này không cho biết đầy đủ hình dạng của phân phối tỷ lệ sinh lời. Hai tài sản có cùng mức biến động tỷ lệ sinh lời vẫn có thể có mức độ rủi ro rất khác nhau nếu một tài sản có phân phối lệch trái hoặc có đuôi dày hơn. Trong trường hợp đó, xác suất xảy ra các khoản lỗ cực đoan của hai tài sản sẽ khác nhau, dù độ lệch chuẩn có thể tương đương.

Vấn đề này đặc biệt quan trọng trong tài chính vì tỷ lệ sinh lời tài sản thường không tuân theo phân phối chuẩn. Nhiều chuỗi tỷ lệ sinh lời có trung bình ngắn hạn gần bằng không, tự tương quan tuyến tính thấp, nhưng lại có phương sai thay đổi theo thời gian, biến động theo cụm với phân phối đuôi dày và bất đối xứng. Khi phân phối tỷ lệ sinh lời có có đuôi dày hơn so với phân phối chuẩn, xác suất xảy ra các khoản lỗ rất lớn cao hơn so với dự báo của phân phối chuẩn. Khi đó, nếu nhà phân tích sử dụng mô hình chuẩn hóa quá đơn giản, rủi ro ở vùng đuôi có thể bị đánh giá thấp. Điều này đặc biệt nghiêm trọng trong giai đoạn khủng hoảng của thị trường. Nhiều nghiên cứu thực nghiệm cho thấy tương quan giữa các tài sản có xu hướng gia tăng trong thời kỳ biến động mạnh, làm suy giảm lợi ích đa dạng hóa danh mục (Longin & Solnik, 2001; Ang & Chen, 2002). Đồng thời, các cú sốc thanh khoản có thể khiến chênh lệch giá mua–bán mở rộng, độ sâu thị trường suy giảm và chi phí giao dịch tăng lên, làm cho việc đóng hoặc tái cơ cấu vị thế trở nên khó khăn hơn (Brunnermeier & Pedersen, 2009; Acharya & Pedersen, 2005). Những hiện tượng này gây ra biến động tỷ lệ sinh lời lớn hơn nhiều so với giả định phân phối chuẩn, tạo ra các phân phối tỷ lệ sinh lời lệch chuẩn, khiến các mô hình dựa trên giả định phân phối chuẩn hoặc tương quan ổn định có nguy cơ đánh giá thấp mức độ rủi ro thực tế (Embrechts, Klüppelberg, & Mikosch, 1997; McNeil, Frey, & Embrechts, 2015). Các bằng chứng từ nhiều thị trường tài chính quốc tế cũng cho thấy hiện tượng đuôi dày và biến động theo cụm là những đặc điểm mang tính phổ quát của dữ liệu tỷ lệ sinh lời, xuất hiện ở cổ phiếu, trái phiếu, tỷ giá và hàng hóa (Mandelbrot, 1963; Fama, 1965; Cont, 2001).

Trong quản trị rủi ro, câu hỏi then chốt không chỉ là “tỷ lệ sinh lời dao động mạnh đến đâu?”, mà còn là “trong các tình huống xấu nhất, danh mục có thể lỗ đến mức nào?”. Rủi ro đuôi (tail risk) hướng tới trả lời câu hỏi này khi đo lường rủi ro thông qua khả năng xảy ra các kết quả rất bất lợi nằm ở phần xa của phân phối, chẳng hạn các phiên giảm mạnh của chỉ số chứng khoán, cú mất giá lớn của đồng tiền, biến động bất thường của giá hàng hóa, hoặc mức lỗ danh mục vượt xa biến động thông thường.

Để lượng hóa rủi ro đuôi, hai thước đo được sử dụng rộng rãi nhất là **giá trị chịu rủi ro** (Value-at-Risk, VaR) và **tổn thất kỳ vọng trong vùng đuôi** (Expected Shortfall, ES). VaR tập trung vào việc xác định một Để lượng hóa rủi ro đuôi, hai thước đo thường được sử dụng là giá trị chịu rủi ro, ký hiệu là VaR, và tổn thất kỳ vọng trong vùng đuôi, ký hiệu là ES. VaR tập trung vào việc xác định một ngưỡng tổn thất tại mức tin cậy cho trước. Chẳng hạn, VaR ở mức 99% cho biết ngưỡng tổn thất mà danh mục chỉ có xác suất khoảng 1% vượt quá trong kỳ hạn được xét. Tuy nhiên, VaR chỉ cho biết vị trí của ngưỡng tổn thất, mà không phản ánh mức độ nghiêm trọng của các khoản lỗ khi ngưỡng đó đã bị vượt qua. Để bổ sung cho hạn chế này, ES đo lường mức tổn thất trung bình trong những trường hợp xấu nhất vượt quá VaR. Nói cách khác, nếu VaR trả lời câu hỏi “ngưỡng lỗ là bao nhiêu?”, thì ES trả lời câu hỏi “nếu đã vượt ngưỡng đó, mức lỗ trung bình là bao nhiêu?” <span class="mark">\[citation needed: Jorion, 2007; McNeil, Frey and Embrechts, 2015\]</span>.

4.  **Vai trò của đo lường biến động tỷ lệ sinh lời và rủi ro đuôi**

Trên thực tế, sự đánh đổi giữa lợi nhuận kỳ vọng và rủi ro là yếu tố tiên quyết trong mọi quyết định đầu tư bởi sự không chắc chắn về kết quả trong tương lai. Nhà đầu tư không chỉ quan tâm đến mức sinh lời kỳ vọng, mà còn quan tâm đến khả năng xảy ra các khoản lỗ và mức độ nghiêm trọng của những khoản lỗ đó. Vì vậy, đo lường biến động và rủi ro đuôi là nền tảng để đánh giá, so sánh và quản lý rủi ro trong hoạt động đầu tư.

Đối với nhà đầu tư cá nhân, biến động tỷ lệ sinh lời cung cấp thông tin về mức độ dao động của tỷ lệ sinh lời, qua đó phản ánh mức độ bất ổn của khoản đầu tư. Hai tài sản có cùng mức sinh lời kỳ vọng nhưng có mức biến động khác nhau sẽ mang lại những trải nghiệm rủi ro khác nhau cho nhà đầu tư. Trong khi đó, VaR và ES giúp trả lời những câu hỏi thực tiễn hơn như: trong điều kiện thị trường bình thường, khoản lỗ tối đa có thể là bao nhiêu với một mức tin cậy nhất định; hoặc nếu xảy ra các tình huống bất lợi vượt quá ngưỡng đó thì mức tổn thất trung bình có thể lớn đến đâu. Những thông tin này hỗ trợ nhà đầu tư xác định quy mô vị thế, thiết lập mức chịu lỗ chấp nhận được và xây dựng chiến lược phân bổ tài sản phù hợp với khẩu vị rủi ro của mình.

Đối với các tổ chức đầu tư chuyên nghiệp như quỹ đầu tư, công ty quản lý quỹ, công ty chứng khoán hoặc doanh nghiệp có hoạt động đầu tư tài chính, đo lường biến động tỷ lệ sinh lời và rủi ro đuôi là một phần quan trọng của quản trị danh mục. Các thước đo này được sử dụng để thiết lập hạn mức rủi ro, giám sát trạng thái đầu tư, đánh giá hiệu quả điều chỉnh theo rủi ro và hỗ trợ quá trình ra quyết định phân bổ vốn. Trong môi trường thị trường biến động mạnh, việc theo dõi rủi ro đuôi đặc biệt quan trọng vì những tổn thất lớn thường phát sinh từ các sự kiện hiếm gặp nhưng có tác động rất lớn đến giá trị danh mục.

Ngân hàng thương mại cũng là một chủ thể đầu tư và kinh doanh tài chính quan trọng trên thị trường. Bên cạnh hoạt động tín dụng truyền thống, nhiều ngân hàng tham gia đầu tư trái phiếu, kinh doanh ngoại hối, chứng khoán hoặc các sản phẩm phái sinh. Trong bối cảnh đó, đo lường volatility, VaR và ES giúp ngân hàng kiểm soát rủi ro thị trường, quản lý trạng thái đầu tư và đánh giá khả năng chịu đựng trước các biến động bất lợi của thị trường. Trên thực tế, các chỉ tiêu này không chỉ được sử dụng cho mục đích quản trị nội bộ mà còn gắn chặt với các yêu cầu giám sát và quản lý vốn của cơ quan quản lý. Đối với ngân hàng, khuôn khổ Basel là chuẩn mực quốc tế quan trọng nhất về quản trị rủi ro thị trường. Trong Basel II, các ngân hàng được phép sử dụng mô hình nội bộ để tính vốn yêu cầu cho rủi ro thị trường dựa trên VaR với mức tin cậy 99% và kỳ hạn nắm giữ 10 ngày giao dịch, với điều kiện mô hình phải được cơ quan giám sát chấp thuận và trải qua quy trình kiểm định ngược (backtesting) nghiêm ngặt (Basel Committee on Banking Supervision, 2006). Sau cuộc khủng hoảng tài chính toàn cầu 2007–2009, nhiều nghiên cứu và cơ quan quản lý nhận thấy VaR không phản ánh đầy đủ rủi ro đuôi trong các giai đoạn thị trường cực đoan. Vì vậy, trong khuôn khổ Basel III, BCBS đã thay thế VaR bằng Expected Shortfall (ES) ở mức tin cậy 97,5% làm thước đo chính để xác định vốn yêu cầu cho rủi ro thị trường (BCBS, 2019). Đây là một trong những thay đổi quan trọng nhất trong quản trị rủi ro thị trường hiện đại, phản ánh xu hướng chuyển từ đo lường phân vị tổn thất sang đo lường tổn thất kỳ vọng trong vùng rủi ro cực đoan.

Đối với ngành bảo hiểm, các yêu cầu về vốn dựa trên rủi ro cũng nhấn mạnh vai trò của biến động tỷ lệ sinh lời và các thước đo rủi ro đuôi. Tại Liên minh châu Âu, Solvency II là khuôn khổ quản lý dựa trên rủi ro, kết hợp yêu cầu vốn, quản trị rủi ro và công bố thông tin. Trong tinh thần đó, doanh nghiệp bảo hiểm cần đánh giá phân phối tổn thất, khả năng chịu đựng vốn và các kịch bản bất lợi có thể ảnh hưởng đến danh mục tài sản và nghĩa vụ bảo hiểm. Mặc dù Solvency II không sử dụng trực tiếp VaR hoặc ES trong mọi cấu phần tính toán, tư duy định lượng rủi ro của khuôn khổ này cho thấy vì sao volatility, VaR và ES là các khái niệm cần thiết đối với quản trị danh mục đầu tư, quản lý tài sản - nợ và đánh giá khả năng thanh toán.

Đối với các quỹ đầu tư, công ty quản lý quỹ và các tổ chức đầu tư chuyên nghiệp, biến động tỷ lệ sinh lời là chỉ tiêu được sử dụng thường xuyên nhất trong quản lý danh mục và đánh giá hiệu quả đầu tư. Nhiều quỹ đầu tư áp dụng các giới hạn nội bộ về độ biến động danh mục, mức độ sai lệch dự báo, VaR hoặc ES nhằm kiểm soát mức độ rủi ro phù hợp với mục tiêu đầu tư đã công bố. Tại Hoa Kỳ, Ủy ban Chứng khoán và Giao dịch Hoa Kỳ (SEC) yêu cầu các quỹ đầu tư công bố đầy đủ các rủi ro trọng yếu liên quan đến chiến lược đầu tư và quản trị thanh khoản. Đối với các quỹ sử dụng công cụ phái sinh, Quy tắc 18f-4 của SEC (2020) yêu cầu nhiều quỹ phải xây dựng chương trình quản lý rủi ro phái sinh, trong đó VaR được sử dụng như một thước đo trung tâm để kiểm soát mức độ đòn bẩy và rủi ro thị trường của danh mục. Tại châu Âu, các quỹ UCITS (Undertakings for Collective Investment in Transferable Securities) được phép sử dụng phương pháp VaR tuyệt đối hoặc VaR tương đối để giám sát rủi ro danh mục khi sử dụng công cụ phái sinh ở mức độ đáng kể. Theo hướng dẫn của Cơ quan Chứng khoán và Thị trường châu Âu (ESMA), VaR phải được tính toán và giám sát thường xuyên, đồng thời kết hợp với stress testing để đánh giá các tình huống thị trường cực đoan.

Những ví dụ trên cho thấy mức độ biến động tỷ lệ sinh lời, VaR và ES không chỉ là các khái niệm học thuật trong tài chính định lượng mà còn là các công cụ được sử dụng rộng rãi trong khuôn khổ quản lý và giám sát thực tế. Mức độ áp dụng có thể khác nhau giữa ngân hàng, doanh nghiệp bảo hiểm và quỹ đầu tư, nhưng xu hướng chung của các chuẩn mực quốc tế là yêu cầu các định chế tài chính phải đo lường rủi ro một cách định lượng, đánh giá các tổn thất cực đoan và duy trì nguồn vốn hoặc nguồn lực tài chính tương xứng với mức độ rủi ro mà họ đang chấp nhận.

5.  **Ý nghĩa của đo lường biến động và rủi ro đuôi trên thị trường chứng khoán Việt Nam**

Cuốn sách này lựa chọn thị trường chứng khoán Việt Nam làm bối cảnh thực nghiệm xuyên suốt. Mục tiêu không chỉ là trình bày các mô hình lý thuyết, mà còn đánh giá khả năng ứng dụng của các mô hình trong điều kiện dữ liệu và đặc điểm thị trường thực tế của Việt Nam. Điều này bởi lẽ thị trường chứng khoán Việt Nam là một môi trường đặc biệt phù hợp để nghiên cứu và đánh giá thực nghiệm các mô hình đo lường biến động và rủi ro đuôi. Trong hơn hai thập kỷ phát triển, thị trường đã trải qua nhiều giai đoạn tăng trưởng mạnh, điều chỉnh sâu, khủng hoảng và phục hồi. So với nhiều thị trường phát triển, thị trường chứng khoán Việt Nam vẫn mang nhiều đặc điểm của một thị trường mới nổi. Thanh khoản không đồng đều giữa các nhóm cổ phiếu, tỷ trọng nhà đầu tư cá nhân lớn, mức độ nhạy cảm với thông tin và tâm lý thị trường cao, cùng với ảnh hưởng của các yếu tố kinh tế vĩ mô trong nước và quốc tế có thể tạo ra những giai đoạn biến động mạnh và các cú sốc giá đáng kể. Những đặc điểm này có thể làm cho tỷ lệ sinh lời của tài sản tài chính tại Việt Nam xuất hiện có phân phối không chuẩn, đuôi dày và bất đối xứng (<span class="mark">Trích dẫn Vinh Võ, Trung Le).</span> Điều này khiến việc đo lường mức độ biến động tỷ lệ sinh lời và rủi ro đuôi trở nên đặc biệt quan trọng đối với cả nhà đầu tư cá nhân lẫn các tổ chức tài chính hoạt động trên thị trường.

Việc áp dụng các mô hình đo lường biến động và VaR/ES tại Việt Nam không nên sao chép máy móc từ các thị trường phát triển. Chất lượng dữ liệu, độ dài chuỗi quan sát, thanh khoản, biên độ dao động giá, cơ chế giao dịch, mức độ phát triển của thị trường và hành vi nhà đầu tư đều có thể ảnh hưởng đến kết quả ước lượng. Một mô hình có thể hoạt động tốt trong bối cảnh này nhưng kém phù hợp trong bối cảnh khác nếu giả định về phân phối, biến động, tương quan hoặc hành vi vùng đuôi không được đáp ứng.

Do đó, trọng tâm của cuốn sách không phải là tìm kiếm một mô hình tốt nhất trong mọi hoàn cảnh. Thay vào đó, cuốn sách hướng tới việc giúp người đọc hiểu bản chất của biến động và rủi ro đuôi, nắm được các phương pháp đo lường phổ biến, nhận diện ưu điểm và hạn chế của từng cách tiếp cận, đồng thời biết cách đánh giá mô hình trên cơ sở dữ liệu, giả định và mục tiêu phân tích. Cách tiếp cận này đặc biệt quan trọng trong bối cảnh Việt Nam, khi dữ liệu thị trường, cấu trúc giao dịch và hành vi nhà đầu tư có thể tạo ra những thách thức riêng cho việc đo lường rủi ro tài chính.

## TỶ LỆ SINH LỜI TÀI SẢN

### Giá tài sản và tỷ lệ sinh lời trong phân tích định lượng tài chính

Trong phân tích định lượng tài chính, đặc biệt trong đo lường rủi ro thị trường, dữ liệu quan sát ban đầu thường là giá tài sản. Giá cổ phiếu, chỉ số chứng khoán, trái phiếu, tỷ giá hoặc giá hàng hóa cho biết tài sản được giao dịch ở mức nào tại một thời điểm cụ thể. Tuy nhiên, khi đánh giá hiệu quả đầu tư và rủi ro thị trường, đối tượng phân tích trung tâm thường không phải là mức giá tuyệt đối, mà là tỷ suất sinh lời của tài sản trong một khoảng thời gian nhất định. Tỷ suất sinh lời cho biết giá trị của một khoản đầu tư thay đổi bao nhiêu so với số vốn ban đầu. Nếu giá tài sản tăng, tỷ suất sinh lời dương phản ánh mức lãi tương đối của vị thế đầu tư. Nếu giá tài sản giảm, tỷ suất sinh lời âm phản ánh mức lỗ tương đối. Vì vậy, tỷ suất sinh lời là cầu nối trực tiếp giữa dữ liệu giá quan sát được trên thị trường và các thước đo rủi ro như biến động, VaR và ES.

Có ít nhất bốn lý do khiến tỷ suất sinh lời được sử dụng rộng rãi hơn chuỗi giá trong phân tích rủi ro tài chính.

Thứ nhất, tỷ lệ sinh lời có ý nghĩa kinh tế trực tiếp hơn so với thay đổi tuyệt đối của giá. Một cổ phiếu tăng từ 20.000 đồng lên 22.000 đồng và một cổ phiếu khác tăng từ 200.000 đồng lên 202.000 đồng đều tăng 2.000 đồng, nhưng kết quả đầu tư là rất khác nhau. Trường hợp thứ nhất tạo ra mức sinh lời 10%, trong khi trường hợp thứ hai chỉ tạo ra mức sinh lời 1%. Vì vậy, nếu chỉ quan sát thay đổi tuyệt đối của giá, nhà phân tích có thể đánh giá sai hiệu quả đầu tư.

**Bảng 1.1. So sánh thay đổi giá và tỷ suất sinh lời của hai tài sản**

| **Tài sản** | **Giá đầu kỳ** | **Giá cuối kỳ** | **Thay đổi giá** | **Tỷ suất sinh lời** |
|:---|---:|---:|---:|---:|
| A | 20.000 | 22.000 | 2.000 | 10% |
| B | 200.000 | 202.000 | 2.000 | 1% |

*Nguồn: Ví dụ minh họa của tác giả.*

Bảng 1.1 cho thấy thay đổi tuyệt đối của giá có thể gây nhầm lẫn khi so sánh các tài sản có mức giá ban đầu khác nhau. Hai tài sản cùng tăng 2.000 đồng, nhưng tỷ suất sinh lời của tài sản A cao gấp mười lần tài sản B. Do đó, tỷ suất sinh lời đưa các tài sản về cùng một thang đo tương đối, giúp so sánh hiệu quả đầu tư giữa các tài sản, giữa các giai đoạn và giữa các danh mục.

Thứ hai, tỷ lệ sinh lời có tính chất thống kê thuận lợi hơn giá tài sản. Chuỗi giá tài sản tài chính thường có xu hướng thay đổi mức nền theo thời gian và thường không dừng.[^1] Nếu mô hình hóa trực tiếp chuỗi giá mà không xử lý đặc điểm không dừng, nhà nghiên cứu có thể gặp hiện tượng hồi quy giả mạo hoặc diễn giải sai quan hệ giữa các biến. Ngược lại, chuỗi tỷ lệ sinh lời, đặc biệt là tỷ lệ sinh lời logarit, thường dao động quanh một mức trung bình nhỏ, gần bằng 0, và có cấu trúc phù hợp hơn cho mô hình chuỗi thời gian tài chính (Brooks, 2019; Tsay, 2013). Điều này không có nghĩa là tỷ lệ sinh lời luôn đơn giản hoặc hoàn toàn ổn định; trên thực tế, tỷ lệ sinh lời vẫn có thể có đuôi dày, bất đối xứng và phương sai thay đổi theo thời gian. Tuy nhiên, xét về mặt mô hình hóa, tỷ lệ sinh lời là điểm khởi đầu phù hợp hơn so với chuỗi giá gốc.

**Hình 1.1. So sánh chuỗi giá và chuỗi tỷ lệ sinh lời của cùng một tài sản**

|                                                                         |
|:-----------------------------------------------------------------------:|
| <img src="media/image1.png" style="width:5.83136in;height:3.27083in" /> |

*Nguồn: Ví dụ minh họa của tác giả.*

Hình 1 minh họa sự khác biệt giữa chuỗi giá và chuỗi tỷ lệ sinh lời. Chuỗi giá ở phhía trên trên thay đổi mức nền theo thời gian và không dao động quanh một trung tâm ổn định. Trong khi đó, chuỗi tỷ lệ sinh lời ở phần hình dưới dao động quanh mức trung bình gần bằng 0, nhưng vẫn xuất hiện các giai đoạn biến động mạnh. Đây chính là lý do các mô hình biến động có điều kiện, chẳng hạn ARCH/GARCH, và các mô hình đo lường VaR thường được xây dựng trên chuỗi tỷ lệ sinh lời thay vì chuỗi giá.

Thứ ba, tỷ lệ sinh lời là đại lượng phù hợp hơn để đo lường rủi ro thị trường. Rủi ro thị trường không gắn với câu hỏi “giá tài sản đang bằng bao nhiêu”, mà gắn với câu hỏi “giá trị vị thế có thể thay đổi bất lợi đến mức nào trong một khoảng thời gian nhất định”. Khi tính biến động, VaR hoặc ES, nhà quản trị rủi ro cần mô tả phân phối của tỷ lệ sinh lời hoặc phân phối tổn thất tương ứng, đặc biệt là vùng phản ánh các khoản lỗ lớn. Vì vậy, tỷ suất sinh lời là đại lượng trung gian cần thiết giữa giá tài sản và các thước đo rủi ro định lượng.

Thứ tư, tỷ lệ sinh lời thuận tiện cho việc tổng hợp theo thời gian và theo danh mục. Với tỷ lệ sinh lời giản đơn, sinh lời nhiều kỳ được liên kết theo nguyên tắc lãi kép, còn sinh lời danh mục là trung bình gia quyền của sinh lời các tài sản thành phần. Với tỷ lệ sinh lời logarit, sinh lời nhiều kỳ có thể cộng trực tiếp qua thời gian. Hai tính chất này làm cho tỷ lệ sinh lời trở thành đại lượng nền tảng trong phân tích hiệu quả đầu tư, phân bổ tài sản, mô hình hóa biến động và đo lường VaR ở cấp độ tài sản đơn lẻ cũng như danh mục.

Từ các lý do trên, cuốn sách này sử dụng chuỗi tỷ lệ sinh lời làm dữ liệu đầu vào chính cho các mô hình đo lường và dự báo biến động, cũng như cho các phương pháp tính giá trị chịu rủi ro. Chuỗi giá vẫn giữ vai trò quan trọng vì là dữ liệu gốc quan sát được trên thị trường, nhưng chuỗi giá cần được chuyển đổi thành tỷ lệ sinh lời trước khi thực hiện phần lớn các phân tích rủi ro định lượng.

### Đo lường tỷ lệ sinh lời

Trong phân tích tài chính, hai thước đo tỷ lệ sinh lời được sử dụng phổ biến nhất là **tỷ lệ sinh lời giản đơn** (*simple return*) và **tỷ lệ sinh lời logarit**, hay còn gọi là **tỷ lệ sinh lời kép liên tục** (*log return* hoặc *continuously compounded return*). Hai thước đo này có quan hệ chặt chẽ với nhau, nhưng phù hợp với các mục tiêu phân tích khác nhau.

Giả sử giá tài sản tại thời điểm $`t`$ là $`P_{t}`$ và tài sản không chi trả cổ tức trong khoảng thời gian từ $`t - 1`$ đến $`t`$. Khi đó, **tỷ lệ sinh lời giản đơn** được xác định bởi:

``` math
R_{t} = \frac{P_{t} - P_{t - 1}}{P_{t - 1}}\  = \frac{P_{t}}{P_{t - 1}} - 1
```

Đây là đại lượng phản ánh trực tiếp mức lãi hoặc lỗ tương đối so với vốn đầu tư ban đầu trong một kỳ nắm giữ. Nếu $`R_{t} = 0,08`$, nhà đầu tư thu được mức sinh lời 8% trong kỳ; nếu $`R_{t} = - 0,08`$, nhà đầu tư chịu khoản lỗ 8%.

Khi tài sản có chi trả dòng tiền trung gian, chẳng hạn cổ tức tiền mặt $`D_{t}`$, công thức tỷ lệ sinh lời giản đơn cần được điều chỉnh thành:

``` math
R_{t} = \frac{P_{t} + D_{t} - P_{t - 1}}{P_{t - 1}}.
```

Nếu tài sản được nắm giữ trong $`k`$ kỳ, tỷ lệ sinh lời giản đơn tích lũy được xác định thông qua tích của các tỷ lệ sinh lời gộp từng kỳ:

``` math
1 + R_{t}\lbrack k\rbrack = \frac{P_{t}}{P_{t - k}} = \prod_{j = 0}^{k - 1}{(1 + R_{t - j})}
```

hay tương đương

``` math
R_{t}\lbrack k\rbrack = \prod_{j = 0}^{k - 1}{\left( 1 + R_{t - j} \right) - 1}
```

Công thức này phản ánh nguyên tắc lãi kép. Ví dụ, nếu tài sản tăng 5% trong kỳ thứ nhất và giảm 5% trong kỳ thứ hai, tỷ lệ sinh lời hai kỳ không bằng 0, vì mức giảm 5% ở kỳ thứ hai được tính trên một giá trị đã thay đổi sau kỳ thứ nhất. Đây là điểm cần đặc biệt lưu ý khi chuyển đổi tỷ suất sinh lời ngày sang tuần, tháng hoặc năm.

Một ưu điểm quan trọng của tỷ lệ sinh lời giản đơn là tính chất cộng gộp theo tỷ trọng danh mục. Giả sử danh mục gồm N tài sản, tỷ trọng đầu tư vào tài sản *i* tại thời điểm *t-1* là $`w_{i,t - 1}`$, và tỷ lệ sinh lời giản đơn của tài sản *i* trong kỳ *t* là $`R_{i,t}`$​. Khi đó, nếu bỏ qua chi phí giao dịch và giả định tỷ trọng được xác định tại đầu kỳ, tỷ suất sinh lời giản đơn của danh mục là:

``` math
R_{p,t} = \sum_{i = 1}^{N}w_{i,t - 1}R_{i,t}.
```

Tính chất này làm cho tỷ lệ sinh lời giản đơn rất hữu ích trong phân tích danh mục, đánh giá đóng góp của từng tài sản vào hiệu quả đầu tư chung và tính toán lãi/lỗ danh mục.

Bên cạnh tỷ lệ sinh lời giản đơn, **tỷ lệ sinh lời logarit** được xác định như sau:

``` math
r_{t} = ln\left( \frac{P_{t}}{P_{t - 1}} \right) = ln(P_{t}) - ln(P_{t - 1}).
```

Trong đó, $`r_{t}`$ là tỷ lệ sinh lời logarit trong kỳ *t.* Vì $`\frac{P_{t}}{P_{t - 1}} = 1 + R_{t}`$, mối quan hệ giữa tỷ suất sinh lời logarit và tỷ suất sinh lời giản đơn là:

``` math
r_{t} = ln(1 + R_{t})
```

Ngược lại, nếu biết tỷ suất sinh lời logarit, tỷ suất sinh lời giản đơn có thể được xác định bởi:

``` math
R_{t} = e^{r_{t}} - 1
```

Ưu điểm nổi bật của tỷ lệ sinh lời logarit là khả năng cộng trực tiếp theo thời gian. Với khoảng nắm giữ $`k`$ kỳ, ta có:

``` math
r_{t}\lbrack k\rbrack = \sum_{j = 0}^{k - 1}r_{t - j}
```

Tính chất này đặc biệt thuận tiện trong phân tích chuỗi thời gian tài chính, vì sinh lời logarit nhiều kỳ có thể được tính bằng tổng các sinh lời logarit một kỳ. <span class="mark">Theo Tsay (2013</span>), tỷ lệ sinh lời logarit thường được sử dụng rộng rãi trong phân tích tài chính vì tính chất cộng theo thời gian và vì các đặc điểm thống kê của nó thuận lợi hơn cho mô hình hóa.

Với tài sản có chi trả dòng tiền trung gian $`D_{t}`$, tỷ lệ sinh lời logarit có thể được điều chỉnh thành:

``` math
r_{t} = ln(P_{t} + D_{t}) - ln(P_{t - 1}).
```

Khi mức sinh lời trong từng kỳ nhỏ, có thể sử dụng xấp xỉ bậc một:

``` math
r_{t} \approx R_{t}.
```

Vì vậy, với dữ liệu tỷ lệ sinh lời ngày của các chỉ số chứng khoán lớn, tỷ lệ sinh lời giản đơn và tỷ lệ sinh lời logarit thường khá gần nhau trong phần lớn quan sát. Tuy nhiên, trong các giai đoạn biến động mạnh hoặc với các tài sản có mức dao động giá lớn, chênh lệch giữa hai thước đo này có thể trở nên đáng kể.

**Bảng 1.2. So sánh tỷ lệ sinh lời giản đơn và tỷ lệ sinh lời logarit**

| Tiêu chí | Tỷ lệ sinh lời giản đơn | Tỷ lệ sinh lời logarit |
|:---|:---|:---|
| Công thức cơ bản | 
``` math
R_{t} = P_{t}/P_{t - 1} - 1
``` | 
``` math
r_{t} = ln(P_{t}) - ln(P_{t - 1})
``` |
| Diễn giải kinh tế | Trực quan, phản ánh lãi/lỗ tương đối trong một kỳ | Ít trực quan hơn, nhưng thuận tiện về mặt toán học |
| Tổng hợp theo thời gian | Tổng hợp bằng phép nhân lãi kép | Có thể cộng trực tiếp qua thời gian |
| Tổng hợp theo danh mục | Danh mục là trung bình gia quyền của return thành phần | Không có tính chất trung bình gia quyền chính xác |
| Phù hợp nhất khi | Phân tích hiệu quả đầu tư, lãi/lỗ danh mục, phân bổ tài sản | Mô hình hóa chuỗi thời gian, volatility, GARCH, VaR |

*Nguồn: Tác giả tổng hợp*

Bảng 1.2 cho thấy lựa chọn giữa hai thước đo phụ thuộc vào mục tiêu phân tích. Nếu mục tiêu là diễn giải lãi/lỗ của một khoản đầu tư hoặc tính tỷ suất sinh lời danh mục theo tỷ trọng, tỷ suất sinh lời giản đơn thường thuận tiện hơn. Nếu mục tiêu là mô hình hóa chuỗi thời gian, phân tích biến động, tổng hợp tỷ suất sinh lời qua nhiều kỳ hoặc ước lượng các mô hình rủi ro động, tỷ suất sinh lời logarit thường phù hợp hơn. Điểm cần nhấn mạnh là hai thước đo này có thể chuyển đổi qua lại với nhau. Do đó, vấn đề không phải là thước đo nào “đúng” tuyệt đối, mà là thước đo nào phù hợp hơn với câu hỏi nghiên cứu, cấu trúc dữ liệu và mô hình được sử dụng.

## CÁC ĐẶC ĐIỂM THỐNG KÊ CỦA TỶ LỆ SINH LỜI

Sau khi chuyển đổi chuỗi giá tài sản thành chuỗi tỷ lệ sinh lời, bước tiếp theo là nhận diện các đặc điểm thống kê cơ bản của chuỗi dữ liệu này để làm cơ sở để lựa chọn mô hình đo lường biến động và giá trị chịu rủi ro phù hợp. Một mô hình rủi ro không nên được lựa chọn chỉ vì tính phổ biến về mặt kỹ thuật; mô hình đó cần phù hợp với những đặc điểm thực nghiệm của dữ liệu đang được phân tích.

Trong phân tích rủi ro thị trường, các câu hỏi nền tảng thường bao gồm: tỷ suất sinh lời dao động quanh mức nào; mức độ phân tán lớn hay nhỏ; phân phối có gần với phân phối chuẩn hay không; có xuất hiện đuôi dày hoặc bất đối xứng hay không; bản thân tỷ suất sinh lời có tự tương quan hay không; và bình phương của tỷ suất sinh lời có thể hiện dấu hiệu phụ thuộc theo thời gian hay không. Các câu hỏi này dẫn trực tiếp đến việc lựa chọn mô hình biến động, giả định phân phối và cách đo lường rủi ro đuôi. Điều này bởi lẽ tỷ suất sinh lời tài sản có nhiều đặc điểm khác biệt so với nhiều chuỗi kinh tế thông thường. Chuỗi tỷ suất sinh lời thường dao động quanh một mức trung bình nhỏ, có phân phối không chuẩn, có thể có đuôi dày và bất đối xứng, ít tự tương quan tuyến tính ở bản thân chuỗi, nhưng lại có phụ thuộc rõ hơn trong bình phương hoặc giá trị tuyệt đối của tỷ suất sinh lời <span class="mark">(Brooks, 2019; Tsay, 2010, 2013).</span>

### Tỷ lệ sinh lời như một biến ngẫu nhiên

Để nghiên cứu biến động và rủi ro trên thị trường chứng khoán, trước hết cần xem tỷ lệ sinh lời như một **biến ngẫu nhiên**. Nói cách khác, tỷ lệ sinh lời tại thời điểm *<u>t</u>* không phải là một con số chắc chắn có thể biết trước, mà là kết quả của nhiều yếu tố ngẫu nhiên: thông tin mới trên thị trường, kỳ vọng của nhà đầu tư, thay đổi chính sách, biến động kinh tế vĩ mô, thanh khoản thị trường và các cú sốc bất thường. Vì vậy, thay vì chỉ quan sát từng giá trị riêng lẻ của tỷ lệ sinh lời, nhà nghiên cứu cần quan tâm đến **phân phối xác suất** của chuỗi tỷ lệ sinh lời.

Giả sử $`r_{t}`$ là tỷ lệ sinh lời tại thời điểm *t*, thì phân phối xác suất của $`r_{t}`$ mô tả toàn bộ các khả năng mà tỷ suất sinh lời có thể nhận, cùng với xác suất tương ứng của từng khả năng đó. Hàm phân phối tích lũy của $`r_{t}`$​ được viết dưới dạng như sau:

``` math
F_{r}(x) = P(r_{t} \leq x).
```

Trong đó, $`F_{r}(x)`$ cho biết xác suất để tỷ suất sinh lời$`\ r_{t}`$ nhận giá trị nhỏ hơn hoặc bằng một mức ($`x`$) bất kỳ. Dưới góc độ trực quan, phân phối của tỷ lệ sinh lời mô tả toàn bộ cấu trúc xác suất của chuỗi: tỷ lệ sinh lời thường tập trung quanh mức nào, mức độ phân tán ra sao, phân phối có cân đối hay không, và khả năng xuất hiện các biến động cực đoan lớn đến mức nào. Đối với đo lường rủi ro, phần đuôi trái của phân phối đặc biệt quan trọng vì đây là vùng phản ánh các khoản lỗ lớn có xác suất thấp nhưng hậu quả nghiêm trọng.

### Các đặc trưng mô tả cơ bản của tỷ lệ sinh lời

Đặc trưng cơ bản đầu tiên của phân phối là **kỳ vọng** hay giá trị trung bình. Kỳ vọng của tỷ lệ sinh lời phản ánh mức sinh lời trung tâm mà nhà đầu tư có thể kỳ vọng trong một khoảng thời gian xác định:

``` math
\mu = E(r_{t}).
```

Trong thực nghiệm, với mẫu gồm *T* quan sát, trung bình mẫu được ước lượng bởi:

``` math
\bar{r} = \frac{1}{T}\sum_{t = 1}^{T}r_{t}.
```

Về mặt kinh tế, $`\bar{r}`$ phản ánh xu hướng sinh lời trung bình của tài sản hoặc chỉ số thị trường trong giai đoạn nghiên cứu. Tuy nhiên, với dữ liệu chứng khoán tần suất ngày, giá trị trung bình thường rất nhỏ so với mức độ dao động của chuỗi. Do đó, trong quản trị rủi ro, câu hỏi quan trọng thường không phải là “tỷ lệ sinh lời trung bình là bao nhiêu”, mà là “tỷ lệ sinh lời có thể dao động bất lợi đến mức nào quanh giá trị trung bình đó”.

Đặc trưng thứ hai là **phương sai**, phản ánh mức độ phân tán của tỷ lệ sinh lời quanh kỳ vọng:

``` math
Var(r_{t}) = E\lbrack(r_{t} - \mu)^{2}\rbrack.
```

Căn bậc hai của phương sai là **độ lệch chuẩn**:

``` math
\sigma = \sqrt{Var(r_{t})}.
```

Trong tài chính, độ lệch chuẩn của tỷ lệ sinh lời thường được dùng như một thước đo cơ bản của **biến động** (*volatility*). Nếu ($`\sigma`$) lớn, tỷ lệ sinh lời dao động mạnh quanh giá trị trung bình; nếu $`(\sigma`$) nhỏ, chuỗi ổn định hơn. Trong thực nghiệm, phương sai mẫu và độ lệch chuẩn mẫu được tính như sau:

``` math
s^{2} = \frac{1}{T - 1}\sum_{t = 1}^{T}(r_{t} - \bar{r})^{2},
```

``` math
s = \sqrt{\frac{1}{T - 1}\sum_{t = 1}^{T}(r_{t} - \bar{r})^{2}}.
```

Tuy nhiên, độ lệch chuẩn mẫu chỉ tóm tắt mức biến động trung bình trong toàn bộ giai đoạn quan sát. Nếu biến động thay đổi mạnh theo thời gian, một độ lệch chuẩn duy nhất có thể không phản ánh đúng trạng thái rủi ro tại từng thời điểm. Trong thực tế, biến động của thị trường thường thay đổi theo thời gian. Vì vậy, độ lệch chuẩn mẫu giúp đánh giá cơ bản và so sánh tương quan tương đối về mức độ biến động của tỷ lệ sinh lời, nhưng chưa đủ để phản ánh tính chất động của rủi ro thị trường.

Đặc trưng thứ ba là **độ lệch** (*skewness*), phản ánh mức độ bất đối xứng của phân phối quanh giá trị trung tâm:

``` math
Skewness = \frac{E\lbrack(r_{t} - \mu)^{3}\rbrack}{\sigma^{3}}.
```

Trong thực nghiệm, độ lệch mẫu có thể được tính xấp xỉ bởi:

``` math
Skewness = \frac{\frac{1}{T}\sum_{t = 1}^{T}(r_{t} - \bar{r})^{3}}{\left\lbrack \frac{1}{T}\sum_{t = 1}^{T}(r_{t} - \bar{r})^{2} \right\rbrack^{3/2}}.
```

Nếu độ lệch bằng 0, phân phối được xem là đối xứng quanh trung tâm. Nếu độ lệch âm, phân phối lệch trái, tức là phần đuôi bên trái dài hơn hoặc dày hơn; nếu độ lệch dương, phân phối lệch phải. Trong bối cảnh thị trường chứng khoán, độ lệch âm có ý nghĩa đặc biệt quan trọng vì nó hàm ý rằng các khoản lỗ lớn có thể xuất hiện với xác suất đáng kể hơn so với các khoản lãi lớn cùng độ lớn tuyệt đối. Đây là đặc điểm liên quan trực tiếp đến đo lường VaR và rủi ro đuôi trái.

Đặc trưng thứ tư là **độ nhọn** (*kurtosis*), phản ánh mức độ tập trung của phân phối quanh trung tâm và độ dày của hai đuôi phân phối:

``` math
Kurtosis = \frac{E\lbrack(r_{t} - \mu)^{4}\rbrack}{\sigma^{4}}.
```

Trong thực nghiệm, độ nhọn mẫu được tính như sau:

``` math
Kurtosis = \frac{\frac{1}{T}\sum_{t = 1}^{T}(r_{t} - \bar{r})^{4}}{\left\lbrack \frac{1}{T}\sum_{t = 1}^{T}(r_{t} - \bar{r})^{2} \right\rbrack^{2}}.
```

Đối với phân phối chuẩn, độ nhọn bằng 3. Nếu độ nhọn lớn hơn 3, phân phối được xem là có **đuôi dày** (*fat tails*) và **đỉnh nhọn hơn** phân phối chuẩn. Khi đó, xác suất xuất hiện các biến động cực đoan có thể cao hơn so với dự báo từ phân phối chuẩn. Trong thực nghiệm, giá trị thường dược sử dụng là **độ nhọn vượt trội** (*excess kurtosis*), được tính bằng (*kurtosis – 3*). Nếu độ nhọn vượt trội lớn hơn 0, phân phối có đuôi dày hơn phân phối chuẩn. Điều này có ý nghĩa trực tiếp đối với VaR và ES: khi phần đuôi của phân phối dày hơn, các khoản lỗ cực đoan có thể xảy ra thường xuyên hơn so với dự báo của mô hình chuẩn.

Đặc trưng thứ năm là **phân vị**, đặc biệt là các phân vị thấp của phân phối tỷ suất sinh lời. Phân vị mức $`\alpha`$ của $`r_{t}`$, ký hiệu $`q_{\alpha}`$, được xác định bởi:

``` math
P\left( r_{t} \leq q_{\left\{ \alpha \right\}} \right) = \alpha
```

Với α = 0,01 hoặc α = 0,05, các phân vị này nằm ở vùng đuôi trái của phân phối tỷ suất sinh lời. Đây là vùng đặc biệt quan trọng trong đo lường rủi ro thị trường, vì VaR có thể được xây dựng từ chính các phân vị thấp này sau khi đã xác định quy ước dấu giữa tỷ suất sinh lời và tổn thất.

**Bảng 1.3. Ý nghĩa của một số thống kê mô tả trong phân tích tỷ lệ sinh lời**

| Thống kê | Ý nghĩa thống kê | Ý nghĩa trong đo lường rủi ro |
|:---|:---|:---|
| Trung bình | Mức sinh lời trung tâm của chuỗi | Cho biết xu hướng sinh lời bình quân, nhưng thường ít quan trọng hơn biến động trong dữ liệu ngày |
| Độ lệch chuẩn | Mức độ phân tán quanh trung bình | Thước đo biến động cơ bản; là đầu vào của nhiều mô hình VaR tham số |
| Độ lệch | Mức độ bất đối xứng của phân phối | Độ lệch âm hàm ý rủi ro đuôi trái lớn hơn |
| Độ nhọn | Mức độ nhọn và độ dày của đuôi phân phối | Độ nhọn lớn hơn 3 hàm ý xác suất biến động cực đoan cao hơn so với phân phối chuẩn |
| Phân vị thấp | Giá trị nằm ở vùng đuôi trái của phân phối | Liên quan trực tiếp đến VaR và ES |

*Nguồn: Tổng hợp của tác giả*

### Những đặc điểm thực nghiệm thường gặp của tỷ lệ sinh lời

Chuỗi tỷ lệ sinh lời tài chính thường thể hiện một số đặc điểm thực nghiệm lặp lại ở nhiều thị trường và nhiều loại tài sản. Các đặc điểm này không phải là các quy luật tuyệt đối, nhưng là những hiện tượng đủ phổ biến để trở thành cơ sở cho việc xây dựng mô hình đo lường biến động và rủi ro đuôi.

Thứ nhất, tỷ suất sinh lời thường có giá trị trung bình nhỏ so với độ lệch chuẩn. Với dữ liệu ngày, trung bình của chuỗi thường gần 0, trong khi độ lệch chuẩn lớn hơn nhiều lần. Điều này giải thích vì sao mô hình hóa rủi ro thường tập trung vào phương sai, biến động và phần đuôi của phân phối, thay vì chỉ tập trung vào kỳ vọng.

Thứ hai, tỷ suất sinh lời thường không tuân theo phân phối chuẩn. Trên đồ thị phân phối thực nghiệm, chuỗi tỷ suất sinh lời tài chính thường có đỉnh cao hơn, đuôi dày hơn và đôi khi lệch trái so với phân phối chuẩn. Điều này có nghĩa là mực dù phân phối chuẩn vẫn là một điểm tham chiếu quan trọng nhưng không nên được sử dụng như mặc định mô tả cho chuỗi dữ liệu tỷ lệ sinh lời trong các mô hình đo lường rủi ro.

**Hình 1.2. Phân phối thực nghiệm của tỷ suất sinh lời logarit với tần suất ngày của chỉ số S&P 500**

<img src="media/image2.png" style="width:5.62222in;height:3.36046in" alt="H:\My Drive\My Vault\03. Research\01. Ongoing Projects\02. Books\outputs\ch01\figures\fig_1_2_sp500_empirical_vs_normal.png" />

*Nguồn: Yahoo Finance, Mã ^GSPC, giai đoạn 2000-01-01 tới 2026-07-02*

Hình 1.2. thể hiện phân phối thực nghiệm của tỷ suất sinh lời logarit với tần suất ngày của chỉ số S&P 500 có thể thấy rõ điều này. Đường đứt nét là phân phối chuẩn có cùng trung bình và độ lệch chuẩn mẫu, trong khi đường nét liền là phân phối thực tế theo tần suất của chuỗi tỷ lệ sinh lời dựa trên chuỗi giá của chỉ số S&P500. Có thể thấy một số đặc điểm không theo quy luật phân phối chuẩn được thể hiện rõ từ đồ thị thực nghiệm này. Đầu tiên là phân phói thực tế của tỷ lệ sinh lời có đuôi dày hơn so với phân phối chuẩn. Điều này có nghĩa là xác suất xuất hiện các biến động cực đoan, cả tăng mạnh lẫn giảm mạnh, có thể lớn hơn so với dự báo từ phân phối chuẩn. Đối với quản trị rủi ro, đuôi trái là vùng đặc biệt quan trọng vì liên quan trực tiếp đến các khoản lỗ lớn. Nếu mô hình giả định chuẩn trong khi dữ liệu thực tế có đuôi dày, VaR có thể đánh giá thấp rủi ro trong những giai đoạn thị trường bất ổn. Tiếp theo là phân phối thực tế của tỷ lệ sinh lời không mang tính đối xứng hoàn hảo như phân phói chuẩn mà có xu hướng lệch trái, phản ánh khả năng xuất hiện các phiên giảm sâu đột ngột. Trong bối cảnh VaR, nếu phân phối lệch trái đáng kể nhưng mô hình lại giả định đối xứng, kết quả ước lượng rủi ro tại các mức xác suất thấp có thể bị sai lệch.

Thứ ba, bản thân chuỗi tỷ lệ sinh lời thường ít tự tương quan tuyến tính, đặc biệt với dữ liệu ngày. Hệ số tự tương quan bậc (k) của chuỗi tỷ lệ sinh lời được xác định bởi:

``` math
\rho_{k} = \frac{\sum_{t = k + 1}^{T}(r_{t} - \bar{r})(r_{t - k} - \bar{r})}{\sum_{t = 1}^{T}(r_{t} - \bar{r})^{2}}.
```

Trong nhiều trường hợp, các hệ số tự tương quan của ($`r_{t}`$) nhỏ và không có ý nghĩa thống kê rõ rệt. Điều này hàm ý rằng việc dự báo trực tiếp dấu hoặc mức sinh lời ngắn hạn là rất khó. Tuy nhiên, nếu xét chuỗi ($`r_{t}^{2}`$) hoặc ($`|r_{t}|`$), tự tương quan thường rõ rệt hơn. Nói cách khác, khó dự báo tỷ lệ sinh lời sẽ tăng hay giảm, nhưng có thể dự báo phần nào mức độ biến động của tỷ lệ sinh lời.

Thứ tư, chuỗi tỷ lệ sinh lời thường có cụm biến động (*volatility clustering*). Các giai đoạn biến động lớn có xu hướng xuất hiện gần nhau, và các giai đoạn biến động nhỏ cũng có xu hướng kéo dài thành cụm. Trên đồ thị chuỗi tỷ suất sinh lời theo thời gian, hiện tượng này thể hiện qua các đoạn thị trường dao động rất mạnh liên tục, xen kẽ với các đoạn tương đối ổn định. Đây là một trong những lý do các mô hình biến động động được phát triển.

Thứ năm, chuỗi tỷ lệ sinh lời thường có phương sai thay đổi có điều kiện. Điều này có nghĩa là mức độ biến động tại thời điểm hiện tại phụ thuộc vào trạng thái thị trường và các cú sốc trong quá khứ. Đây là nền tảng trực giác của các mô hình phương sai có điều kiện, sẽ được trình bày ở Chương 2. Ở Chương 1, chỉ cần ghi nhận rằng biến động của tỷ suất sinh lời không nên được hiểu như một hằng số cố định cho toàn bộ giai đoạn quan sát.

Thứ tám, chuỗi tỷ suất sinh lời thường ổn định hơn chuỗi giá. Giá tài sản thường có xu hướng, mức giá hiện tại phụ thuộc mạnh vào mức giá quá khứ, và nhiều chuỗi giá có đặc điểm gần với bước ngẫu nhiên. Ngược lại, tỷ suất sinh lời thường dao động quanh một mức trung bình tương đối ổn định. Tuy nhiên, cần nhấn mạnh rằng tỷ suất sinh lời ổn định hơn chuỗi giá không đồng nghĩa với phương sai không đổi. Chuỗi $`r_{t}`$ có thể dao động quanh một mức trung bình tương đối ổn định nhưng mức độ phân tán của nó vẫn thay đổi mạnh theo thời gian.

4.  **Phân phối vô điều kiện và phân phối có điều kiện của tỷ lệ sinh lời**

Phần trên xem tỷ lệ sinh lời như một biến ngẫu nhiên có phân phối chung cho toàn bộ giai đoạn quan sát. Đây là cách tiếp cận vô điều kiện (*unconditional volatility*). Theo cách tiếp cận này, nhà nghiên cứu quan tâm đến các đặc trưng chung của chuỗi như trung bình, độ lệch chuẩn, độ lệch, độ nhọn và các phân vị của phân phối.

Tuy nhiên, trong đo lường rủi ro thị trường, câu hỏi thường không chỉ là: “Tỷ suất sinh lời nói chung có phân phối như thế nào trong toàn bộ giai đoạn nghiên cứu?”. Câu hỏi quan trọng hơn là: “Với toàn bộ thông tin hiện có đến thời điểm hiện tại, tỷ suất sinh lời trong kỳ tiếp theo có thể phân phối như thế nào?”. Đây là lý do cần phân biệt giữa phân phối vô điều kiện *(unconditional distribution)* và phân phối có điều kiện *(conditional distribution)*.

Ký hiệu $`\mathcal{F}_{t - 1}`$ là tập thông tin sẵn có tại thời điểm ($`t - 1`$), bao gồm các giá trị quá khứ của tỷ lệ sinh lời, các cú sốc trước đó, trạng thái biến động trước đó và có thể bao gồm thêm thông tin vĩ mô hoặc thông tin thị trường khác. Khi đó, phân phối có điều kiện của tỷ lệ sinh lời được biểu diễn bởi:

``` math
F_{t}(x \mid \mathcal{F}_{t - 1}) = P(r_{t} \leq x \mid \mathcal{F}_{t - 1}).
```

Trong công thức này, $`F_{t}(x \mid \mathcal{F}_{t - 1})`$ cho biết xác suất để tỷ suất sinh lời $`r_{t}`$ nhỏ hơn hoặc bằng một mức$`\ x`$, với điều kiện đã biết toàn bộ thông tin đến thời điểm ($`t - 1`$). Khác với phân phối vô điều kiện, phân phối có điều kiện có thể thay đổi theo thời gian khi trạng thái thị trường thay đổi. Từ phân phối có điều kiện, có thể xác định kỳ vọng có điều kiện:

``` math
\mu_{t} = \ E(r_{t} \mid \mathcal{F}_{t - 1})
```

và phương sai có điều kiện:

``` math
\sigma_{t}^{2} = \ Var(r_{t} \mid \mathcal{F}_{t - 1})
```

Căn bậc hai của phương sai có điều kiện, ($`\sigma_{t}`$), được gọi là **độ biến động có điều kiện** (*conditional volatility*), là đại lượng trung tâm của các mô hình đo lường biến động tỷ lệ sinh lời

``` math
\sigma_{t} = \ \sqrt{Var(r_{t} \mid \mathcal{F}_{t - 1})}
```

Các đại lượng này cho phép chuyển từ cách nhìn tĩnh sang cách nhìn động về rủi ro. Trong giai đoạn thị trường ổn định, phương sai có điều kiện có thể thấp; sau một cú sốc lớn, phương sai có điều kiện có thể tăng mạnh. Vì vậy, cùng một tài sản có thể có mức rủi ro khác nhau ở các thời điểm khác nhau, dù dữ liệu vẫn thuộc cùng một chuỗi tỷ suất sinh lời.

Khái niệm phân phối có điều kiện cũng là nền tảng của VaR và ES có điều kiện. Nếu $`q_{\alpha,t}`$ là phân vị bậc $`\alpha`$ của phân phối có điều kiện của ($`r_{t}`$), thì

``` math
q_{\left\{ \alpha,t \right\}} = F_{t}^{\left\{ - 1 \right\}}(\alpha|\ \mathcal{F}_{t - 1})
```

VaR tại thời điểm *t* được xây dựng từ chính phân vị này. Như vậy, VaR không nhất thiết là một con số cố định cho toàn bộ mẫu, mà có thể thay đổi theo trạng thái thông tin và mức biến động hiện hành của thị trường.

## ĐO LƯỜNG BIẾN ĐỘNG CỦA TỶ LỆ SINH LỜI TÀI SẢN

### Khái niệm biến động tỷ lệ sinh lời

Trong phân tích rủi ro tài chính, tỷ suất sinh lời cho biết giá trị của một tài sản hoặc danh mục thay đổi như thế nào qua thời gian. Tuy nhiên, để đánh giá rủi ro thị trường, chỉ biết tỷ suất sinh lời trung bình là chưa đủ. Nhà nghiên cứu còn cần quan tâm đến mức độ dao động của tỷ suất sinh lời quanh giá trị trung bình. Mức độ dao động này được gọi là biến động của tỷ suất sinh lời.

Biến động tỷ lệ sinh lời thể hiện mức độ dao động của tỷ lệ sinh lời quanh giá trị kỳ vọng. Nếu tỷ suất sinh lời phản ánh kết quả đầu tư, thì biến động phản ánh mức độ bất định của kết quả đó. Đây là lý do biến động thường được xem là một trong những thước đo nền tảng của rủi ro thị trường.

Về mặt thống kê, cách đo đơn giản nhất của biến động là độ lệch chuẩn của tỷ suất sinh lời. Giả sử $`r_{t}`$ là tỷ suất sinh lời của tài sản tại thời điểm *t*, μ là kỳ vọng của tỷ suất sinh lời, khi đó phương sai của $`r_{t}`$ ​được viết là:

``` math
\sigma^{2} = \ E\left. \ \left\lbrack \left( r_{t} - \mu \right)^{2} \right.\  \right\rbrack
```

Độ lệch chuẩn, hay thước đo biến động tương ứng, được xác định bởi:

``` math
\sigma = \ \sqrt{\left\{ E\left. \ \left\lbrack \left( r_{t} - \mu \right)^{2} \right.\  \right\rbrack \right\}}
```

Trong thực nghiệm, với mẫu gồm *T* quan sát, $`r_{1},\ r_{2},\ \ldots.,r_{T}`$, trung bình mẫu được tính bởi:

``` math
\overline{r} = \ \frac{1}{T}\ \sum_{t = 1}^{T}r_{t}
```

Độ lệch chuẩn mẫu được tính bởi:

``` math
s = \sqrt{\left( \frac{1}{T - 1}\sum_{t = 1}^{T}\left( r_{t} - \overline{r}\  \right)^{2}\  \right)}
```

Trong đó, $`s`$ là độ lệch chuẩn mẫu của chuỗi tỷ suất sinh lời. Nếu $`s`$ lớn, tỷ suất sinh lời phân tán mạnh quanh giá trị trung bình; nếu $`s`$ nhỏ, tỷ suất sinh lời dao động trong phạm vi hẹp hơn. Do đó, độ lệch chuẩn mẫu là điểm khởi đầu tự nhiên để mô tả biến động.

Mức độ biến động của tỷ lệ sinh lời không nói cho ta biết tài sản chắc chắn sẽ sinh lời cao hay thấp; nó cho biết kết quả đầu tư khó dự đoán đến mức nào. Một tài sản có thể có tỷ suất sinh lời trung bình tương đối cao nhưng đồng thời cũng có mức biến động lớn, nghĩa là kết quả đầu tư thực tế có thể dao động rất rộng quanh giá trị trung bình. Ngược lại, một tài sản có tỷ suất sinh lời trung bình thấp hơn nhưng biến động nhỏ hơn có thể tạo ra chuỗi kết quả ổn định hơn. Do đó, biến động tỷ lệ sinh lời thể hiện rõ sự đánh đổi căn bản trong đầu tư giữa lợi nhuận kỳ vọng và rủi ro.

Ví dụ, giả sử có hai tài sản A và B đều có tỷ lệ sinh lời bình quân ngày xấp xỉ 0,05%. Nếu tỷ lệ sinh lời của A thường chỉ dao động quanh khoảng từ -0,4% đến 0,5%, còn tỷ lệ sinh lời của B thường dao động trong khoảng từ -2,0% đến 2,2%, thì mặc dù mức sinh lời trung bình tương đương nhau, nhà đầu tư sẽ cảm nhận B rủi ro hơn nhiều. Lý do là kết quả đầu tư vào B khó dự đoán hơn và dễ xuất hiện các phiên lỗ lớn hơn.

Một điểm quan trọng là biến động không phải là một biến quan sát trực tiếp như giá tài sản. Giá cổ phiếu, chỉ số chứng khoán, lãi suất hoặc tỷ giá có thể được ghi nhận trực tiếp từ thị trường. Tỷ suất sinh lời có thể được tính từ giá. Trong khi đó, biến động là một đặc điểm thống kê của chuỗi tỷ suất sinh lời và phải được ước lượng từ dữ liệu. Điều này có nghĩa là cùng một chuỗi tỷ suất sinh lời có thể được mô tả bằng nhiều thước đo biến động khác nhau, tùy thuộc vào mục tiêu phân tích, tần suất dữ liệu và giả định của mô hình. Nếu mục tiêu chỉ là mô tả mức dao động trung bình trong một giai đoạn đã quan sát, độ lệch chuẩn mẫu có thể là một thước đo phù hợp. Nếu mục tiêu là theo dõi biến động thay đổi theo thời gian, biến động theo cửa sổ trượt có thể hữu ích hơn. Nếu mục tiêu là dự báo rủi ro trong kỳ tiếp theo, nhà nghiên cứu cần chuyển sang các mô hình biến động có điều kiện

2.  **Các phương pháp đo lường biến động tỷ lệ sinh lời**

Trong thực nghiệm tài chính, biến động có thể được đo lường theo nhiều cách khác nhau. Điều này bởi biến động tỷ lệ sinh lời không phải là một biến quan sát trực tiếp như giá tài sản. Nhà đầu tư có tể quan sát được giá, từ đó tính tỷ tỷ lệ sinh lời, nhưng biến động phải được ước lượng từ dữ liệu hoặc suy ra từ một mô hình. Vì vậy, mỗi thước đo biến động phản ánh một cách sử dụng thông tin khác nhau: có thước đo chỉ dựa trên dữ liệu quá khứ, có thước đo nhấn mạnh các quan sát gần hiện tại, có thước đo sử dụng dữ liệu tần suất cao, và có thước đo được suy ra từ giá quyền chọn trên thị trường.

Cách tiếp cận đơn giản nhất là **biến động lịch sử (historical volatility),** được tính bằng độ lệch chuẩn của chuỗi tỷ lệ sinh lời trong một giai đoạn quá khứ. Nếu $`r_{1},\ r_{2},\ \ldots.,r_{T}`$ là chuỗi tỷ lệ sinh lời trong mẫu, biến động tỷ lệ sinh lời lịch sử có thể được ước lượng bằng độ lệch chuẩn mẫu.

``` math
\widehat{\sigma}\  = \sqrt{\frac{1}{T}\sum_{t = 1}^{T}{(r_{t} - \overline{r)}}^{2}}\ 
```

trong đó, $`\overline{r}`$ là à tỷ suất sinh lời trung bình trong mẫu. Thước đo này cho biết mức dao động trung bình của tỷ suất sinh lời trong giai đoạn quan sát. Nếu dữ liệu tỷ lệ sinh lời có tần suất ngày thì biến động tỷ lệ sinh lời, $`{\widehat{\sigma}}_{daily}`$, phản ánh biến động bình quân theo ngày. Khi cần quy đổi sang biến động năm, thực hành phổ biến là nhân với căn bậc hai của số ngày giao dịch trong năm:

``` math
{\widehat{\sigma}}_{annual} = {\widehat{\sigma}}_{daily}\sqrt{D}.
```

Trong đó, D là số ngày giao dịch trong năm, thường được lấy xấp xỉ 252 đối với dữ liệu ngày. Tuy nhiên, quy tắc căn bậc hai của thời gian dựa trên giả định mạnh rằng tỷ suất sinh lời độc lập, có cùng phân phối và có phương sai ổn định theo thời gian. Nếu chuỗi tỷ suất sinh lời có cụm biến động hoặc phương sai thay đổi theo thời gian, quy tắc này chỉ nên được xem là xấp xỉ.

Hạn chế chính của biến động lịch sử là nó thường sử dụng toàn bộ mẫu như một giai đoạn đồng nhất. Điều này có thể phù hợp nếu mục tiêu là mô tả mức rủi ro trung bình trong quá khứ, nhưng chưa đủ nếu mục tiêu là theo dõi trạng thái rủi ro thay đổi theo thời gian. Trong thực tế, thị trường có thể trải qua các giai đoạn tương đối ổn định xen kẽ với các giai đoạn biến động cao. Khi đó, một con số biến động tính trên toàn bộ mẫu có thể phản ứng chậm với sự thay đổi của điều kiện thị trường.

Để khắc phục hạn chế này, nhà đầu tư có thể đo lường **biến động tỷ lệ sinh lời theo cửa sổ trượt (rolling volatility).** Thay vì tính độ lệch chuẩn trên toàn bộ mẫu, nhà nghiên cứu chỉ sử dụng m quan sát gần nhất tại mỗi thời điểm. Biến động theo cửa sổ trượt tại thời điểm t có thể được viết là

``` math
{\widehat{\sigma}}_{t,m} = \sqrt{\frac{1}{m - 1}\left( \sum_{j = 0}^{m - 1}\left( r_{t - j} - {\overline{r}}_{t,m} \right)^{2} \right)}\ 
```

trong đó *m* là độ dài cửa sổ và $`{\overline{r}}_{t,m}`$​ là tỷ suất sinh lời trung bình trong cửa sổ gồm *m* quan sát gần nhất. Căn cứ của thước đo này là rủi ro hiện tại nên được đánh giá dựa trên thông tin gần hiện tại hơn là toàn bộ lịch sử rất dài.

**Hình 1.3. Minh họa biến động tỷ lệ sinh lời theo cửa sổ trượt**

<img src="media/image3.emf" style="width:5.37342in;height:2.63235in" />

Hình 1.3 minh họa một đặc điểm thường gặp trong dữ liệu tài chính: biến động tỷ lệ sinh lời không ổn định mà thay đổi theo từng giai đoạn. Khi thị trường bước vào giai đoạn bất ổn, mức độ biến động của giá tài sản tăng lên, dẫn tới mức biến động của tỷ lệ sinh lời cũng tăng lên; khi điều kiện thị trường bình thường trở lại, biến động tỷ lệ sinh lời giảm xuống khi các giao dịch giá có xu hướng thu hoẹp hơn. Xu hướng này thường xuất hiện trong dữ liệu thực tế của chỉ số chứng khoán, tỷ giá, giá hàng hóa và cổ phiếu riêng lẻ.

Tuy nhiên, biến động tỷ lệ sinh lời theo cửa sổ trượt cũng có hạn chế. Kết quả phụ thuộc đáng kể vào độ dài cửa sổ *m.* Cửa sổ ngắn phản ứng nhanh với thông tin mới nhưng có thể tạo ra chuỗi biến động nhiễu; cửa sổ dài tạo ra chuỗi biến động mượt hơn nhưng phản ứng chậm khi thị trường chuyển trạng thái. Ngoài ra, biến động tỷ lệ sinh lời theo cửa sổ trượt thường gán trọng số bằng nhau cho tất cả quan sát trong cửa sổ. Một cú sốc mới xảy ra và một cú sốc ở đầu cửa sổ có thể có cùng ảnh hưởng đến kết quả ước lượng, trong khi các cú sốc vừa rơi ra khỏi cửa sổ lại mất hoàn toàn ảnh hưởng.

Để giải quyết này, các quan sát của tỷ lệ sinh lời trong mẫu có thể được gán các trọng số khác nhau. Một phương pháp phổ biến là xác định mức **biến động theo trung bình trượt hàm mũ** (**Exponentially Weighted Moving Average, EWMA)**. EWMA cho phép các quan sát gần hiện tại có trọng số lớn hơn các quan sát xa hơn trong quá khứ. Một dạng đơn giản của phương trình cập nhật phương sai EWMA là:

``` math
{\widehat{\sigma}}_{t}^{2} = \lambda{\widehat{\sigma}}_{t - 1}^{2} + (1 - \lambda)r_{t - 1}^{2}
```

trong đó, 0 \< $`\lambda`$ \< 1 là hệ số suy giảm. Nếu $`\lambda`$ lớn, ảnh hưởng của biến động quá khứ được duy trì lâu hơn và thước đo phản ứng chậm hơn với cú sốc mới. Nếu $`\lambda`$ nhỏ, cú sốc gần hiện tại có trọng số lớn hơn và thước đo phản ứng nhanh hơn.

Mặc dù EWMA có giá trị thực hành cao, phương pháp này chưa mô hình hóa đầy đủ cơ chế hình thành biến động của tỷ lệ sinh lời cũng như bỏ qua khả năng tồn tại một mức biến động tỷ lệ sinh lời dài hạn do các yếu tố nền tảng của biến động giá tài sản.. Vì vậy, khi mục tiêu là dự báo biến động hoặc xây dựng mô hình rủi ro động, nhà đầu tư thường cần chuyển sang nhóm mô hình biến động có điều kiện.

Về mặt thống kê, biến động tỷ lệ sinh lời có điều kiện được xây dựng từ phương sai có điều kiện của tỷ suất sinh lời. Nếu $`\mathcal{F}_{t - 1}`$​ là tập thông tin sẵn có đến thời điểm *t-1*, phương sai có điều kiện của $`r_{t}`$​ được viết là:

``` math
\sigma_{t}^{2} = Var(r_{t} \mid \mathcal{F}_{t - 1})
```

và biến động có điều kiện là:

``` math
\sigma_{t} = \ \sqrt{Var(r_{t} \mid \mathcal{F}_{t - 1})}
```

Ý nghĩa của công thức này là rủi ro tại thời điểm t không nhất thiết bằng rủi ro trung bình trong toàn bộ giai đoạn quan sát. Khi thông tin thị trường thay đổi, phân phối có điều kiện của tỷ lệ sinh lời cũng có thể thay đổi. Sau một cú sốc lớn, phương sai có điều kiện có thể tăng lên; sau một giai đoạn ổn định kéo dài, phương sai có điều kiện có thể giảm xuống. Nếu $`\sigma_{t}`$ thay đổi theo thời gian, độ rộng của phân phối có điều kiện của $`r_{t}`$​ cũng thay đổi theo thời gian. Đây là lý do các mô hình biến động tỷ lệ sinh lời có điều kiện có vai trò quan trọng trong dự báo VaR và ES động.

Bên cạnh các thước đo dựa trên tỷ suất sinh lời quá khứ, một nhóm thước đo khác là **biến động tỷ lệ sinh lời thực tế (realized volatility)**, thường được xây dựng từ dữ liệu tần suất cao trong ngày. Giả sử trong ngày $`t`$, ta chia thời gian giao dịch thành $`M`$ khoảng nhỏ. Ký hiệu $`r_{t,j}`$ là tỷ lệ sinh lời logarit trong khoảng nhỏ thứ $`j`$, với $`j = 1,2,\ldots,M`$. Khi đó, biến động tỷ lệ sinh lời thực tế trong ngày $`t`$ được viết dưới dạng:

``` math
RV_{t} = \sqrt{\sum_{j = 1}^{M}r_{t,j}^{2}}.
```

Ý tưởng cơ bản của thước đo này là: nếu một ngày giao dịch được chia thành nhiều khoảng thời gian nhỏ, chúng ta có thể tính tỷ suất sinh lời logarit trong từng khoảng và cộng dồn bình phương các tỷ suất sinh lời nội ngày này để đo mức biến động đã thực sự diễn ra trong ngày. Cách tiếp cận này dựa trên cơ sở của biến phân bậc hai trong tài chính liên tục, theo đó tổng bình phương các tỷ suất sinh lời nội ngày, khi khoảng quan sát đủ nhỏ, có thể được dùng để xấp xỉ phương sai tích hợp của quá trình giá trong ngày. <span class="mark">\[ZOTERO: Andersen và Bollerslev về realized volatility; Barndorff-Nielsen và Shephard về realized variance; Tsay về dữ liệu tài chính tần suất cao\]</span>

Điểm khác biệt quan trọng giữa biến động thực tế và biến động tính từ giá đóng cửa hằng ngày là mức độ sử dụng thông tin. Nếu biến động lịch sử dựa trên một tỷ suất sinh lời mỗi ngày, biến động thực tế khai thác nhiều tỷ suất sinh lời nội ngày, qua đó phản ánh chi tiết hơn dao động giá xảy ra trong ngày giao dịch. Vì vậy, biến động thực tế thường được sử dụng như một thước đo thực nghiệm gần với biến động đã xảy ra hơn, đồng thời có thể đóng vai trò chuẩn so sánh khi đánh giá chất lượng dự báo của các mô hình biến động. <span class="mark">\[ZOTERO: Andersen, Bollerslev, Diebold và Labys về realized volatility trong dự báo biến động; Tsay về ứng dụng dữ liệu tần suất cao\]</span>

Trên thực tế, trong nhiều bối cảnh thực nghiệm, đặc biệt ở các thị trường mới nổi, dữ liệu tần suất cao không phải lúc nào cũng sẵn có, dễ truy cập hoặc đủ sạch để sử dụng trực tiếp. Ngoài ra, dữ liệu tần suất cao có thể chịu ảnh hưởng của nhiễu vi cấu trúc thị trường, chẳng hạn chênh lệch giá mua - bán, giao dịch không đồng bộ và sai lệch do cơ chế khớp lệnh; đây là vấn đề được nhấn mạnh trong các nghiên cứu về dữ liệu tài chính tần suất cao. Trong bối cảnh đó, một hướng thay thế là sử dụng các thước đo biến động dựa trên biên độ giá trong ngày. Các thước đo này khai thác thông tin từ giá mở cửa, giá cao nhất, giá thấp nhất và giá đóng cửa trong ngày. So với thước đo chỉ dùng giá đóng cửa, các thước đo dựa trên biên độ giá có thêm thông tin về mức dao động xảy ra bên trong phiên giao dịch. Đây là điểm đặc biệt hữu ích khi nhà nghiên cứu có dữ liệu ngày dạng OHLC nhưng không có dữ liệu nội ngày chi tiết. Các thước đo tiêu biểu gồm thước đo Parkinson, Garman–Klass, Rogers–Satchell và Yang–Zhang.[^2] Các phương pháp này đều thuộc nhóm thước đo biến động dựa trên giá cao nhất - thấp nhất hoặc dữ liệu OHLC, nhưng khác nhau về giả định đối với xu hướng giá, biến động qua đêm và cách sử dụng thông tin mở cửa - đóng cửa.

Một thước đo biến động tỷ lệ sinh lời khác là **biến động tỷ lệ sinh lời hàm ý (implied volatility),** được suy ra từ giá quyền chọn trên thị trường. Khác với biến động lịch sử và biến động thực tế, biến động hàm ý không được tính trực tiếp từ tỷ suất sinh lời quá khứ, mà được suy ra từ mức giá quyền chọn quan sát được thông qua một mô hình định giá quyền chọn. Về ý nghĩa, biến động hàm ý phản ánh kỳ vọng của thị trường về biến động trong tương lai, nhưng đồng thời cũng chịu ảnh hưởng của cung cầu quyền chọn, phần bù rủi ro và cấu trúc thị trường phái sinh. Trong bối cảnh Việt Nam, việc sử dụng biến động hàm ý trong thực nghiệm có thể gặp hạn chế nếu thị trường quyền chọn chưa phát triển đầy đủ hoặc dữ liệu quyền chọn chưa đủ thanh khoản. Vì vậy, trong cuốn sách này, biến động hàm ý có vai trò quan trọng về mặt khái niệm, nhưng không nhất thiết là trọng tâm của phần thực nghiệm.

Tóm lại, có thể thấy không có một thước đo biến động duy nhất phù hợp cho mọi mục tiêu phân tích. Nếu mục tiêu là mô tả nhanh mức dao động bình quân trong quá khứ, biến động lịch sử là một điểm khởi đầu phù hợp. Nếu mục tiêu là theo dõi rủi ro thay đổi theo thời gian, biến động tỷ lệ sinh lời theo cửa sổ trượt và EWMA cung cấp các cách cập nhật trực quan hơn. Nếu mục tiêu là mô hình hóa và dự báo biến động trong kỳ tiếp theo, các mô hình biến động có điều kiện sẽ là điều kiện cần thiết để dự báo. Nếu mục tiêu là đánh giá chất lượng dự báo biến động, biến động tỷ lệ sinh lời thực tế sẽ đóng vai trò tham chiếu thực nghiệm, tùy thuộc vào dữ liệu sẵn có. Nếu thị trường quyền chọn phát triển đủ sâu, biến động hàm ý có thể bổ sung thông tin hướng tới tương lai về kỳ vọng biến động của thị trường.

4.  **ĐO LƯỜNG RỦI RO ĐUÔI CỦA TỶ LỆ SINH LỜI**

    1.  **Rủi ro đuôi trong phân phối tỷ lệ sinh lời**

Mắc dù biến động tỷ lệ sinh lời cho biết mức độ dao động của tỷ suất sinh lời quanh giá trị trung bình, các kết quả bất lợi ở các vùng xa của phân phối tỷ lệ sinh lời mới là những giá trị cần quan tâm chính khi quan trị rủi ro thị trường. Đây là vùng mà các khoản lỗ lớn có xác suất thấp nhưng có thể gây tác động nghiêm trọng đến giá trị danh mục. Rủi ro đuôi phát sinh khi xác suất hoặc mức độ nghiêm trọng của các biến cố cực đoan lớn hơn so với điều mà một mô hình đơn giản có thể dự báo. Trong phân phối tỷ suất sinh lời, rủi ro đuôi thường gắn với phần đuôi trái, nơi phản ánh các mức sinh lời âm lớn đối với nhà đầu tư.

Đối với dữ liệu tài chính, việc tập trung vào vùng đuôi là cần thiết vì nhiều chuỗi tỷ lệ sinh lời không tuân theo phân phối chuẩn, có đuôi dày và có thể lệch trái. Đặc điểm này không chỉ là một hiện tượng thống kê, mà phản ánh các cơ chế kinh tế và thị trường. Khi xuất hiện thông tin xấu, giá tài sản có thể giảm nhanh do phản ứng bán đồng thời, gọi ký quỹ, giảm đòn bẩy, suy giảm thanh khoản và sự gia tăng tương quan giữa các tài sản. Đối với cổ phiếu, hiệu ứng đòn bẩy cũng góp phần tạo ra bất đối xứng: khi giá cổ phiếu giảm, tỷ lệ nợ trên vốn chủ sở hữu tăng, làm rủi ro vốn chủ sở hữu cao hơn và có thể khiến biến động tăng mạnh hơn sau cú sốc âm so với cú sốc dương cùng độ lớn. Một cách giải thích khác là cơ chế phản hồi biến động: khi biến động kỳ vọng tăng, nhà đầu tư yêu cầu mức sinh lời kỳ vọng cao hơn, làm giá hiện tại chịu áp lực giảm nếu dòng tiền kỳ vọng không tăng tương ứng. Vì vậy, các kịch bản giảm mạnh có thể xuất hiện thường xuyên hơn hoặc nghiêm trọng hơn so với dự báo của phân phối chuẩn. Điều này đặc biệt quan trọng trong đo lường rủi ro vì phần đuôi trái của phân phối tỷ suất sinh lời tương ứng với phần đuôi phải của phân phối tổn thất. Nếu mô hình giả định chuẩn trong khi dữ liệu thực tế có đuôi trái dày hoặc lệch trái, VaR và ES có thể bị ước lượng thiếu thận trọng. \[ZOTERO: McNeil, Frey và Embrechts, 2015; Brooks, 2019; Jorion, 2007; Cont, 2001\]

Trên thực tế nhà đầu tư cũng như các tổ chức tài chính thường quan tâm hơn tới mức tổn thất bằng tiền của vị thế đầu tư bởi giá trị này phản ánh chính xác hơn quy mô thua lỗ với danh mục đầu tư hiện có. Khi đó, khi chuyển sang biến tổn thất bằng tiền, rủi ro đuôi thể hiện mức tổn thất ở đuôi phải của phân phối tổn thất. Giả sử một danh mục có tỷ lệ sinh lời của danh mục trong kỳ *t* là $`r_{t}`$. Một quy ước đơn giản là định nghĩa tỷ lệ tổn thất bằng âm của tỷ suất sinh lời:

``` math
L_{t} = \  - r_{t}
```

Theo quy ước này, khi tỷ suất sinh lời âm, biến tổn thất nhận giá trị dương. Chẳng hạn, nếu $`r_{t} = \  - 0.03`$, tức danh mục giảm 3%, thì $`L_{t} = 0.03`$, nghĩa là tỷ lệ tổn thất là 3%. Nếu danh mục có giá trị thị trường tại thời điểm *t-1* là $`V_{t - 1}`$​, tổn thất tính bằng tiền có thể viết là:

``` math
\$ L_{t} = \  - V_{t - 1}r_{t}
```

Trong đó, $`\$ L_{t}`$ là tổn thất bằng tiền của danh mục trong kỳ t. Quy ước này giúp diễn giải rủi ro đuôi rõ ràng hơn: nếu làm việc với tỷ suất sinh lời, rủi ro lỗ lớn nằm ở đuôi trái; nếu làm việc với tổn thất, rủi ro lỗ lớn nằm ở đuôi phải.

2.  **Giá trị chịu rủi ro (VaR)**

Giá trị chịu rủi ro, VaR, giúp trả lời cho câu hỏi: *với một danh mục đầu tư hiện tại, trong một khoảng thời gian nhất định, mức lỗ lớn nhất có thể xảy ra với một xác suất cho trước là bao nhiêu?* Ví dụ, nếu VaR 1 ngày ở mức tin cậy 99% của một danh mục là 2 tỷ đồng, điều này có nghĩa là xác suất để khoản lỗ trong một ngày vượt quá 2 tỷ đồng là khoảng 1%. Về mặt thống kê, VaR là một thước đo phân vị của phân phối tỷ lệ tổn thất. Với mức tin cậy $`\alpha`$, VaR của $`L_{t}`$​ được xác định là phân vị mức $`\alpha`$ của phân phối tổn thất:

``` math
VaR_{\alpha} = q_{\alpha}\left( L_{t} \right)
```

``` math
\Pr\left( L_{t} > VaR_{\alpha} \right) = 1 - \alpha
```

Điều này có nghĩa là nếu $`\alpha = 99\%`$ thì $`VaR_{99\%}`$ là phân vị 99% của phân phối tổn thất và xác suất để tỷ lệ tổn thất lớn hơn $`VaR_{99\%}`$ là 1%.

**Hình 1.4. Giá trị VaR với phân phối tỷ lệ tổn thất**

<img src="media/image4.png" style="width:5.37148in;height:2.45238in" />

*Nguồn: Minh họa của tác giả*

Nếu làm việc trực tiếp với tỷ suất sinh lời $`r_{t}`$, VaR có thể được biểu diễn thông qua phân vị trái của phân phối tỷ suất sinh lời.

``` math
VaR_{\alpha} = q_{(1 - \alpha)}\left( r_{t} \right)
```

``` math
\Pr\left( r_{t} < VaR_{\alpha} \right) = 1 - \alpha
```

Ví dụ, $`VaR_{99\%}`$ là mức phân vị 1% của phân phối tỷ lệ sinh lời và xác suất để tỷ lệ sinh lời âm nhiều hơn mức $`VaR_{99\%}`$ là 1%.

**Hình 1.5. Giá trị VaR với phân phối tỷ lệ sinh lời**

<img src="media/image5.png" style="width:5.68056in;height:2.37391in" />

*Nguồn: Minh họa của tác giả*

VaR có ưu điểm lớn là tóm tắt rủi ro của một vị thế hoặc danh mục thành một con số tương đối dễ truyền đạt. Một báo cáo VaR đầy đủ, nếu nêu rõ danh mục, kỳ nắm giữ, mức tin cậy, đơn vị đo lường và phương pháp ước lượng, có thể hỗ trợ thiết lập hạn mức rủi ro, so sánh mức độ rủi ro giữa các danh mục và kiểm định số lần tổn thất vượt ngưỡng. Đây là lý do VaR từng trở thành một trong những thước đo trung tâm trong quản trị rủi ro thị trường của ngân hàng, công ty chứng khoán, quỹ đầu tư và các tổ chức tài chính.

Tuy nhiên, VaR cũng có những giới hạn quan trọng. Trước hết, VaR phụ thuộc vào mô hình, dữ liệu, cửa sổ ước lượng và giả định phân phối. Nếu phân phối tỷ suất sinh lời có đuôi dày hoặc lệch trái nhưng mô hình giả định phân phối chuẩn, VaR có thể đánh giá thấp xác suất xảy ra các khoản lỗ lớn. Thứ hai, VaR phụ thuộc vào mức tin cậy và kỳ nắm giữ, nên các con số VaR ở các mức tin cậy hoặc kỳ hạn khác nhau không thể so sánh trực tiếp nếu không nêu rõ quy ước tính toán. Quan trọng hơn, VaR chỉ xác định ngưỡng tổn thất tại một phân vị nhất định, nhưng không cho biết mức độ nghiêm trọng của các khoản lỗ khi ngưỡng đó đã bị vượt qua. Hai danh mục có cùng VaR vẫn có thể có mức độ rủi ro đuôi rất khác nhau nếu một danh mục có các khoản lỗ vượt ngưỡng lớn hơn nhiều so với danh mục còn lại.

Vì vậy, VaR là một thước đo nền tảng nhưng chưa đầy đủ của rủi ro đuôi. Nó trả lời câu hỏi “ngưỡng tổn thất là bao nhiêu?”, nhưng chưa trả lời câu hỏi “nếu ngưỡng đó bị vượt qua, tổn thất trung bình trong vùng xấu nhất là bao nhiêu?”.

3.  **Tổn thất kỳ vọng vùng đuôi (ES)**

Tổn thất kỳ vọng trong vùng đuôi, ES, bổ sung cho VaR bằng cách đo lường mức tổn thất trung bình trong những trường hợp tổn thất vượt quá ngưỡng VaR. Nếu VaR trả lời câu hỏi “ngưỡng tổn thất là bao nhiêu?”, thì ES trả lời câu hỏi “khi tổn thất đã vượt ngưỡng đó, mức tổn thất trung bình là bao nhiêu?”.

Với biến tổn thất $`L_{t}`$ và mức tin cậy $`\alpha`$, ES có thể được thể hiện dưới dạng kỳ vọng có điều kiện như sau:

``` math
ES_{\alpha} = E\left( L_{t} \middle| L_{t} \geq VaR_{\alpha}(L_{t}) \right)
```

Tương tự, nếu làm việc với biến tỷ lệ sinh lời $`r_{t}`$, ES được thể hiện như sau:

``` math
ES_{\alpha} = E\left( r_{t} \middle| r_{t} \leq VaR_{1 - \alpha}(r_{t}) \right)
```

Công thức này cho thấy ES không chỉ nhìn vào một điểm phân vị đơn lẻ, mà tổng hợp thông tin của toàn bộ vùng đuôi sau VaR. Vì vậy, ES đặc biệt hữu ích khi phân phối tổn thất có đuôi dày. Trong các tình huống mà tổn thất vượt VaR có thể rất lớn, ES cung cấp thông tin thận trọng hơn về mức độ nghiêm trọng của rủi ro đuôi. Ví dụ, giả sử hai danh mục đều có VaR 99% bằng 2 tỷ đồng. Danh mục thứ nhất có các khoản lỗ vượt VaR chủ yếu quanh mức 2,2–2,5 tỷ đồng; danh mục thứ hai có các khoản lỗ vượt VaR có thể lên tới 5–7 tỷ đồng. Nếu chỉ nhìn vào VaR, hai danh mục có vẻ rủi ro tương đương. Nhưng nếu tính ES, danh mục thứ hai sẽ có ES cao hơn đáng kể, phản ánh mức độ nghiêm trọng lớn hơn trong vùng tổn thất cực đoan.

Từ góc độ đo lường rủi ro đuôi, ES không nên được hiểu đơn giản là một thước đo thay thế cơ học cho VaR. Quan hệ hợp lý hơn là xem VaR và ES như hai thước đo bổ sung. VaR xác định vị trí của ngưỡng tổn thất tại một mức tin cậy cho trước, trong khi ES đo mức độ nghiêm trọng trung bình của các khoản lỗ khi ngưỡng đó bị vượt qua. Vì vậy, VaR phù hợp với việc truyền đạt ngưỡng rủi ro và kiểm định số lần vượt ngưỡng, còn ES phù hợp hơn với việc đánh giá độ sâu của vùng tổn thất cực đoan.

**Hình 1.6 Giá trị ES với phân phối tỷ lệ sinh lời**

<img src="media/image6.png" style="width:5.65529in;height:2.6064in" />

*Nguồn: Minh họa của tác giả*

Sự phát triển của chuẩn mực Basel về rủi ro thị trường phản ánh logic bổ sung này. Trong các khuôn khổ trước đây, VaR giữ vai trò trung tâm trong đo lường rủi ro thị trường theo mô hình nội bộ, đặc biệt trong kiểm định ngược và đánh giá số lần vượt ngưỡng. Các chuẩn mực Basel mới hơn chuyển trọng tâm của mô hình nội bộ sang ES trong một số cấu phần tính vốn rủi ro thị trường, qua đó nhấn mạnh nhu cầu đo lường không chỉ ngưỡng tổn thất mà cả mức độ nghiêm trọng của tổn thất trong vùng đuôi. Đồng thời, VaR vẫn tiếp tục có vai trò trong kiểm định ngược, cho thấy quản trị mô hình rủi ro không loại bỏ VaR mà đặt VaR bên cạnh ES trong một hệ thống kiểm soát rộng hơn. \[SOURCE VERIFICATION NEEDED: BCBS, 2006; BCBS, 2019\]

Do đó, quản trị rủi ro thị trường hiện đại không nên phụ thuộc vào một thước đo đơn lẻ. VaR chuẩn hóa rủi ro thành một ngưỡng tổn thất dễ truyền đạt; ES bổ sung bằng cách đo mức độ nghiêm trọng của các tổn thất vượt ngưỡng. Cả hai thước đo đều cần được đặt trong một quy trình đánh giá rộng hơn, bao gồm kiểm định mô hình, phân tích kịch bản, kiểm tra sức chịu đựng và đánh giá chất lượng dữ liệu.

Acharya, V. V., & Pedersen, L. H. (2005). Asset pricing with liquidity risk. *Journal of Financial Economics, 77*(2), 375–410.

Acerbi, C., & Tasche, D. (2002). On the coherence of expected shortfall. *Journal of Banking & Finance, 26*(7), 1487–1503.

Artzner, P., Delbaen, F., Eber, J.-M., & Heath, D. (1999). Coherent measures of risk. *Mathematical Finance, 9*(3), 203–228.

Choudhry, M. (2013). *An introduction to value-at-risk* (5th ed.). Wiley.

Embrechts, P., Klüppelberg, C., & Mikosch, T. (1997). *Modelling extremal events for insurance and finance*. Springer.

Jorion, P. (2007). *Value at risk: The new benchmark for managing financial risk* (3rd ed.). McGraw-Hill.

McNeil, A. J., Frey, R., & Embrechts, P. (2015). *Quantitative risk management: Concepts, techniques and tools* (Revised ed.). Princeton University Press.

Rockafellar, R. T., & Uryasev, S. (2000). Optimization of conditional value-at-risk. *Journal of Risk, 2*(3), 21–41.

Yamai, Y., & Yoshiba, T. (2005). Value-at-risk versus expected shortfall: A practical perspective. *Journal of Banking & Finance, 29*(4), 997–1015.

**B. Đặc điểm thực nghiệm của tỷ suất sinh lời, đuôi dày và biến động theo cụm**

Cont, R. (2001). Empirical properties of asset returns: Stylized facts and statistical issues. *Quantitative Finance, 1*(2), 223–236.

Fama, E. F. (1965). The behavior of stock-market prices. *The Journal of Business, 38*(1), 34–105.

Mandelbrot, B. (1963). The variation of certain speculative prices. *The Journal of Business, 36*(4), 394–419.

Longin, F., & Solnik, B. (2001). Extreme correlation of international equity markets. *The Journal of Finance, 56*(2), 649–676.

Ang, A., & Chen, J. (2002). Asymmetric correlations of equity portfolios. *Journal of Financial Economics, 63*(3), 443–494.

Brunnermeier, M. K., & Pedersen, L. H. (2009). Market liquidity and funding liquidity. *Review of Financial Studies, 22*(6), 2201–2238.

**C. Mô hình biến động và chuỗi thời gian tài chính**

Bollerslev, T. (1986). Generalized autoregressive conditional heteroskedasticity. *Journal of Econometrics, 31*(3), 307–327.

Brooks, C. (2019). *Introductory econometrics for finance* (4th ed.). Cambridge University Press.

Engle, R. F. (1982). Autoregressive conditional heteroscedasticity with estimates of the variance of United Kingdom inflation. *Econometrica, 50*(4), 987–1007.

Nelson, D. B. (1991). Conditional heteroskedasticity in asset returns: A new approach. *Econometrica, 59*(2), 347–370.

Glosten, L. R., Jagannathan, R., & Runkle, D. E. (1993). On the relation between the expected value and the volatility of the nominal excess return on stocks. *The Journal of Finance, 48*(5), 1779–1801.

Taylor, S. J. (1986). *Modelling financial time series*. Wiley.

Tsay, R. S. (2010). *Analysis of financial time series* (3rd ed.). Wiley.

Tsay, R. S. (2013). *An introduction to analysis of financial data with R*. Wiley.

**D. Realized volatility và thước đo biến động dựa trên dữ liệu OHLC**

Andersen, T. G., & Bollerslev, T. (1998). Answering the skeptics: Yes, standard volatility models do provide accurate forecasts. *International Economic Review, 39*(4), 885–905.

Andersen, T. G., Bollerslev, T., Diebold, F. X., & Labys, P. (2003). Modeling and forecasting realized volatility. *Econometrica, 71*(2), 579–625.

Barndorff-Nielsen, O. E., & Shephard, N. (2002). Econometric analysis of realized volatility and its use in estimating stochastic volatility models. *Journal of the Royal Statistical Society: Series B, 64*(2), 253–280.

Garman, M. B., & Klass, M. J. (1980). On the estimation of security price volatilities from historical data. *The Journal of Business, 53*(1), 67–78.

Parkinson, M. (1980). The extreme value method for estimating the variance of the rate of return. *The Journal of Business, 53*(1), 61–65.

Rogers, L. C. G., & Satchell, S. E. (1991). Estimating variance from high, low and closing prices. *The Annals of Applied Probability, 1*(4), 504–512.

Yang, D., & Zhang, Q. (2000). Drift-independent volatility estimation based on high, low, open, and close prices. *The Journal of Business, 73*(3), 477–491.

**E. Basel, ngân hàng và quy định rủi ro thị trường**

Bank for International Settlements. (2006). *International convergence of capital measurement and capital standards: A revised framework: Comprehensive version*. Basel Committee on Banking Supervision.

Bank for International Settlements. (2019). *Minimum capital requirements for market risk*. Basel Committee on Banking Supervision.

Bank for International Settlements. (2016). *Minimum capital requirements for market risk*. Basel Committee on Banking Supervision. \[OPTIONAL – dùng nếu muốn trình bày quá trình từ FRTB 2016 đến bản 2019\]

**F. Quỹ đầu tư, phái sinh, UCITS và SEC**

Committee of European Securities Regulators. (2010). *CESR’s guidelines on risk measurement and the calculation of global exposure and counterparty risk for UCITS* (Ref. CESR/10-788).

U.S. Securities and Exchange Commission. (2020). *Use of derivatives by registered investment companies and business development companies*. Investment Company Act Release No. 34084.

**G. Bảo hiểm và Solvency II**

European Parliament and Council. (2009). *Directive 2009/138/EC on the taking-up and pursuit of the business of insurance and reinsurance (Solvency II)*.

European Commission. (2015). *Commission Delegated Regulation (EU) 2015/35 supplementing Directive 2009/138/EC on the taking-up and pursuit of the business of insurance and reinsurance (Solvency II)*.

**H. Phân loại thị trường và bối cảnh Việt Nam**

FTSE Russell. (2023). *FTSE equity country classification of markets: September 2023*. FTSE Russell.

FTSE Russell. (2025). *FTSE equity country classification of markets: September 2025*. \[SOURCE VERIFICATION NEEDED – cần kiểm tra bản chính thức từ FTSE Russell/LSEG\]

Financial Times. (2025). *Vietnam upgraded to emerging market status by FTSE Russell*. \[TEMPORARY SECONDARY SOURCE – chỉ dùng tạm nếu chưa lấy được nguồn FTSE/LSEG chính thức\]

Vo, X. V., & Le, T. H. \[ZOTERO CHECK: cần xác minh chính xác bài viết, năm, tiêu đề, tạp chí và DOI về biến động/rủi ro thị trường chứng khoán Việt Nam\].

[^1]: Trong phân tích chuỗi thời gian, một chuỗi được gọi là *dừng* nếu các đặc trưng xác suất cơ bản của nó, như kỳ vọng, phương sai và hiệp phương sai theo độ trễ, không thay đổi theo thời gian. Nói một cách trực quan, chuỗi dừng dao động quanh một mức trung tâm tương đối ổn định; chuỗi không dừng thường có xu hướng, thay đổi mức nền hoặc có cấu trúc phụ thuộc kéo dài theo thời gian. Trong tài chính, chuỗi giá thường gần với quá trình có nghiệm đơn vị, trong khi chuỗi tỷ lệ sinh lời thường ổn định hơn và vì vậy phù hợp hơn cho mô hình hóa thống kê.

[^2]: Các thước đo này sẽ được mô tả cụ thể hơn các chương sau
