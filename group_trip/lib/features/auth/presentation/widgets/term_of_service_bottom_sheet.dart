import 'package:flutter/material.dart';

void showTravellerTermsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const Text(
                  'TERMS OF SERVICE – Traveller',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Áp dụng cho người dùng đăng ký và sử dụng ứng dụng với vai trò Traveller.\n'
                  'Vui lòng đọc kỹ trước khi tạo tài khoản.\n',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: const Text(
                      '''
1. Điều kiện sử dụng

Ứng dụng chỉ hỗ trợ giao diện Tiếng Việt.
Mỗi người dùng chỉ được có một vai trò hoạt động tại một thời điểm (Traveler hoặc Travel Representative).
Tài khoản bị khóa, tạm khóa hoặc bị cấm sẽ không thể đăng nhập hoặc thực hiện bất kỳ giao dịch nào trên nền tảng.
Người dùng phải cung cấp thông tin chính xác, chính chủ; thông tin ngân hàng phải trùng khớp chủ tài khoản.

2. Quyền truy cập & hiển thị thông tin

Traveler chỉ có thể xem:
- Các chuyến đi đã được công bố (Published).
- Các chuyến đi mình đã tham gia.
- Các đề xuất tùy chỉnh (Custom Trip) do chính mình tạo.
- Các cuộc trò chuyện mà mình là thành viên.
- Các giao dịch tài chính thuộc tài khoản của mình.
- Các blog công khai và hồ sơ Travel Representative công khai.

Không thể xem thông tin tài khoản của người dùng khác (trừ hồ sơ public của đại diện tour).

3. Đăng ký & tham gia chuyến đi

Traveler chỉ có thể tham gia chuyến đi khi trạng thái là Ready.
Mỗi chuyến đi phải có số lượng tối thiểu & tối đa. Nếu không đạt số tối thiểu khi hết hạn đăng ký, chuyến đi sẽ bị hủy tự động.
Traveler chỉ có thể xem chi tiết các chuyến đi mình tham gia.

4. Thanh toán & Ví nền tảng

Mọi thanh toán & rút tiền đều được thực hiện thông qua ví của nền tảng.
Số tiền đặt cọc = 50% giá tour.
Thời hạn thanh toán:
- Hạn đặt cọc: 7 ngày trước ngày khởi hành.
- Hạn thanh toán còn lại: 3 ngày trước ngày khởi hành.

Nếu ví đủ tiền → hệ thống tự động trừ đặt cọc.
Nếu không đủ → hệ thống thông báo và cho 24 giờ để hoàn tất. Không thanh toán đúng hạn → Travel Representative có quyền xóa Traveler khỏi nhóm.

5. Hủy & Hoàn tiền

Nếu Traveler bị xóa khỏi nhóm nhưng nhóm vẫn đạt số tối thiểu → chuyến đi vẫn tiếp tục.
Nếu dưới số tối thiểu:
- Traveler còn lại có thể chọn tiếp tục (tạo chuyến mới mở lại đăng ký) hoặc dừng.
- Nếu dừng → hệ thống hoàn 100% đặt cọc.
Nếu Travel Representative hủy chuyến sau khi đã thu cọc → Traveler nhận lại 70%.
Nếu Traveler hủy sau hạn thanh toán đầy đủ → KHÔNG được hoàn tiền đặt cọc.
Mọi hoàn tiền do tranh chấp hoặc chính sách đều được hệ thống xử lý tự động; Travel Representative không thể tự hoàn tiền.

6. Custom Trip (Tùy chỉnh chuyến đi)

Traveler có thể tạo đề xuất chuyến đi tùy chỉnh dựa trên một chuyến đi có sẵn.
Không giới hạn số lượng đề xuất.
Chỉ có thể tùy chỉnh ngày và hoạt động.
Mỗi đề xuất chỉ có một vòng chỉnh sửa từ Travel Representative.
Khi cho phép chỉnh sửa, hệ thống tự tạo bản sao để Representative chỉnh sửa.
Khi được duyệt, bản chỉnh sửa trở thành một chuyến đi độc lập thuộc đại diện tour.
Nếu Traveler không phản hồi chỉnh sửa trong vòng 7 ngày trước ngày khởi hành, đề xuất sẽ bị hủy tự động.

7. Khiếu nại, hỗ trợ và hoàn tiền

Có 3 loại gửi yêu cầu:
- Complaint (khiếu nại) → gửi đến Travel Representative.
- Refund (yêu cầu hoàn tiền) → gửi Admin.
- Support (hỗ trợ) → gửi Admin.

Trạng thái xử lý:
- Traveler: chỉ có thể Cancel khiếu nại đang chờ xử lý.
- Người nhận (Representative/Admin): có thể Approve hoặc Reject.
- Hệ thống đặt trạng thái tự động: Pending và Resolved.

Khi khiếu nại được giải quyết, Traveler không thể gửi tin nhắn thêm hoặc đánh giá về kết quả.
Mỗi khiếu nại chỉ có một người nhận chính.
File đính kèm (nếu có) sẽ được lưu trữ trong hệ thống.
Traveler chỉ xem được danh sách khiếu nại của chính mình.
Admin có quyền ra quyết định cuối cùng trong các tranh chấp.

8. Blog & Nội dung cộng đồng

Chỉ Traveler đang hoạt động mới có thể tạo blog.
Tiêu chuẩn bài đăng:
- Tiêu đề ≤150 ký tự
- Nội dung ≥50 ký tự
- Tối đa 10 thẻ tag
- Hình ảnh phải là URL hợp lệ

9. Đánh giá chuyến đi

Traveler chỉ có thể đánh giá và để lại review sau khi chuyến đi đã hoàn thành.

10. Bảo mật & Quyền riêng tư

Traveler chỉ có thể xem giao dịch, khiếu nại, thông tin và cuộc trò chuyện thuộc về chính tài khoản của mình.
Email đã xác minh không thể thay đổi.
Nền tảng chỉ gửi thông báo liên quan đến tài khoản và các chuyến đi mà Traveler tham gia hoặc tạo yêu cầu.

11. Cam kết của người dùng

Khi đăng ký tài khoản, Traveler đồng ý:
- Tuân thủ mọi chính sách, quy định và quy trình của nền tảng.
- Không thực hiện các hành vi gian lận, gây rối, vi phạm pháp luật hoặc chính sách.
- Chấp nhận mọi thay đổi chính sách khi nền tảng cập nhật trong tương lai.
                      ''',
                      style: TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
               
              ],
            ),
          );
        },
      );
    },
  );
}
