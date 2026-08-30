# USER_GUIDE.md - Hướng dẫn sử dụng ứng dụng

Ứng dụng **Học tiếng Nhật N5** giúp học từ vựng, Kanji và luyện đề thi thử JLPT N5 theo giáo
trình Minna no Nihongo Sơ cấp I. Toàn bộ dữ liệu nằm sẵn trong ứng dụng, **chạy hoàn toàn
offline**. Tiến độ học (từ đã thuộc, câu trả lời sai, kết quả đề thi) được lưu trên máy bằng
SQLite — không cần đăng nhập, không đồng bộ đám mây.

> Tài liệu mô tả đúng giao diện hiện tại.

## 1. Điều hướng chính

Thanh điều hướng dưới cùng có 5 mục:

| Tab       | Nội dung                                                    |
| --------- | ---------------------------------------------------------- |
| Trang chủ | Lối tắt tới 3 phần học chính                                |
| Từ vựng   | Từ vựng theo cấp độ (N5 có dữ liệu, N4/N3 sắp có)           |
| Kanji     | Bộ thủ Khang Hy và Kanji JLPT N5                            |
| Đề thi    | 25 bài trắc nghiệm JLPT N5                                  |
| Cài đặt   | Giao diện sáng/tối, giới thiệu                              |

## 2. Trang chủ

Ba thẻ: **Từ vựng tiếng Nhật**, **Kanji tiếng Nhật**, **Đề thi thử JLPT N5**. Chạm vào thẻ để
chuyển sang tab tương ứng.

## 3. Từ vựng

### 3.1 Danh sách cấp độ (`/vocabulary`)

Hiển thị 3 thẻ: **Từ vựng JLPT N5** (kèm số lượng từ), **N4**, **N3** (đánh dấu "Sắp có", không
bấm được). Chạm thẻ N5 để mở danh sách chi tiết.

### 3.2 Chi tiết từ vựng (`/vocabulary/N5`)

- **Ô tìm kiếm**: lọc theo hiragana, kanji hoặc nghĩa tiếng Việt.
- **Chọn bài**: menu thả xuống "Tất cả bài" hoặc một bài cụ thể (Bài 1–25).
- **Nút "Ôn sai (n)"**: chỉ hiện khi đã có câu trả lời sai được ghi nhận; mở trắc nghiệm ở chế
  độ ôn lại câu sai.
- **Nút loa** ở mỗi dòng: phát âm từ tiếng Nhật (TTS).
- Chạm vào một dòng: mở bảng chi tiết (hiragana, Kanji, nghĩa, bài) kèm nút phát âm.
- Biểu tượng ▶ trên thanh tiêu đề: mở màn hình trắc nghiệm.

### 3.3 Trắc nghiệm từ vựng (`/vocabulary/N5/quiz`)

**Màn thiết lập:**

- **Số đáp án**: 2–10.
- **Hình thức**: Trộn lẫn / Việt → Nhật / Nhật → Việt.
- **Chọn bài**: chọn một hay nhiều bài (chip). Nút "Bắt đầu" bật khi đã chọn ≥ 1 bài.

**Màn làm bài:**

- Mỗi lượt 10 câu; hết 10 câu tự sinh bộ câu mới.
- Bấm "Hiển thị đáp án" để lộ các lựa chọn, chọn một đáp án.
- Đáp án đúng tô xanh, đáp án chọn sai tô đỏ; có thẻ kết quả kèm nút phát âm.
- Thanh trên hiển thị: số câu, số đúng/sai, số từ đã thuộc trên tổng số từ đã chọn.
- **Xoá tiến độ**: xoá danh sách "từ đã thuộc" của phạm vi đang chọn (có hỏi xác nhận).
- Trả lời đúng → từ được đánh dấu "đã thuộc" và gỡ khỏi danh sách câu sai; trả lời sai → thêm
  vào danh sách câu sai.

**Chế độ ôn câu sai** (mở từ nút "Ôn sai"): bỏ qua màn thiết lập, chỉ hỏi các từ đang nằm trong
danh sách câu sai (cần ≥ 2 từ).

## 4. Kanji

### 4.1 Danh mục (`/kanji`)

Ba thẻ: **Bộ thủ** (214 bộ thủ Khang Hy), **Kanji JLPT N5** (kèm số lượng), **Kanji JLPT N4**
("Sắp có").

### 4.2 Chi tiết (`/kanji/radicals` hoặc `/kanji/n5`)

- Ô tìm kiếm theo chữ, âm Hán Việt hoặc nghĩa.
- Danh sách: mỗi dòng hiện chữ lớn, âm Hán Việt · nghĩa, và (Kanji) âm On/Kun hoặc (bộ thủ) số
  bộ và số nét.
- Chạm dòng: bảng chi tiết (âm On, âm Kun, ví dụ / số bộ, số nét).
- Biểu tượng ▶: mở trắc nghiệm. Nút "n" (số câu sai): mở trắc nghiệm chế độ ôn câu sai.

> Tính năng **tập viết Kanji** (theo nét) chưa có trong phiên bản này.

### 4.3 Trắc nghiệm Kanji (`/kanji/<id>/quiz`)

- Thiết lập: **Số đáp án** (2–8), **Hình thức** (Trộn lẫn / Chữ → Nghĩa / Nghĩa → Chữ).
- Làm bài giống trắc nghiệm từ vựng: 10 câu mỗi lượt, đánh dấu đã thuộc / câu sai, có nút "Xoá
  tiến độ".

## 5. Đề thi thử JLPT N5

### 5.1 Danh sách bài (`/exam`)

Lưới 25 ô "Bài 1"–"Bài 25", mỗi ô ghi số câu hỏi. Ô không có dữ liệu hiển thị "Chưa có đề" và
không bấm được.

### 5.2 Làm đề (`/exam/<n>/quiz`)

**Màn thiết lập:**

- Hiển thị "Kết quả tốt nhất" nếu đã từng làm.
- **Số câu hỏi**: 10 / 20 / 30.
- **Lọc theo dạng câu** (chip, bỏ trống = tất cả): Từ vựng, Ngữ pháp, Kanji, Đọc hiểu, Hội thoại.
- Nút "Làm bài".

**Màn làm bài:**

- Thanh tiến độ + "Câu x/n · Đúng c · <dạng câu>".
- Câu đọc hiểu hiển thị đoạn văn phía trên câu hỏi.
- Chọn đáp án → đúng tô xanh, sai tô đỏ, hiện **Giải thích**.
- Nút "Câu tiếp theo" / "Xem kết quả".
- Trả lời sai được ghi vào danh sách câu sai của bài đó.

**Màn kết quả:** số câu đúng trên tổng, kết quả tốt nhất, nút "Làm lại". Kết quả tốt nhất chỉ
được cập nhật khi tỉ lệ đúng của lượt này cao hơn.

## 6. Cài đặt

- **Giao diện sáng**: công tắc bật/tắt giữa giao diện sáng và tối; lựa chọn được ghi nhớ.
- **Giới thiệu**: thông tin ứng dụng.
