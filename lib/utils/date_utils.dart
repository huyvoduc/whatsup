class DateUtils {
  static String getTimeBeforeNow(DateTime dateTime) {

    try {
      var diffNo = DateTime.now().difference(dateTime);
      if (diffNo.inDays > 365) {
            return '${diffNo.inDays % 365} năm trước';
          } else if (diffNo.inDays > 30) {
            return '${diffNo.inDays % 30} tháng trước';
          } else if (diffNo.inDays < 30 && diffNo.inDays > 0) {
            return '${diffNo.inDays} ngày trước';
          } else if (diffNo.inHours < 24 && diffNo.inHours > 0) {
            return '${diffNo.inHours} giờ trước';
          } else if (diffNo.inMinutes < 60 && diffNo.inMinutes > 0) {
            return '${diffNo.inMinutes} phút trước';
          } else {
            return 'vừa mới';
          }
    } catch (e) {
      return '';
    }
  }

}
