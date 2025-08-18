/// Helper utility functions for common operations
class Helpers {
  Helpers._();

  /// Generate unique ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Generate UUID-like string
  static String generateUuid() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp * 1000 + (timestamp % 1000)).toString();
    return '${random.substring(0, 8)}-${random.substring(8, 12)}-${random.substring(12, 16)}-${random.substring(16, 20)}-${random.substring(20)}';
  }

  /// Capitalize first letter of string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Capitalize each word in string
  static String capitalizeWords(String text) {
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  /// Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Format currency
  static String formatCurrency(double amount, {String symbol = '\$'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  /// Format number with commas
  static String formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  /// Get initials from full name
  static String getInitials(String fullName) {
    final names = fullName.trim().split(' ');
    if (names.isEmpty) return '';
    if (names.length == 1) return names[0][0].toUpperCase();
    return '${names[0][0]}${names[names.length - 1][0]}'.toUpperCase();
  }

  /// Check if string is null or empty
  static bool isNullOrEmpty(String? text) {
    return text == null || text.isEmpty;
  }

  /// Check if string is not null or empty
  static bool isNotNullOrEmpty(String? text) {
    return !isNullOrEmpty(text);
  }

  /// Remove HTML tags from string
  static String removeHtmlTags(String htmlString) {
    final regex = RegExp(r'<[^>]*>');
    return htmlString.replaceAll(regex, '');
  }

  /// Get file extension from path
  static String getFileExtension(String filePath) {
    return filePath.split('.').last.toLowerCase();
  }

  /// Check if file is image
  static bool isImageFile(String filePath) {
    final extension = getFileExtension(filePath);
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'].contains(extension);
  }

  /// Check if file is video
  static bool isVideoFile(String filePath) {
    final extension = getFileExtension(filePath);
    return ['mp4', 'avi', 'mov', 'mkv', 'webm'].contains(extension);
  }

  /// Convert bytes to readable format
  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Generate random color hex
  static String randomColorHex() {
    final random = DateTime.now().millisecond;
    return '#${(random * 16777215 ~/ 1000).toRadixString(16).padLeft(6, '0')}';
  }

  /// Clean phone number (remove non-digits)
  static String cleanPhoneNumber(String phone) {
    return phone.replaceAll(RegExp(r'[^\d+]'), '');
  }

  /// Mask email (show only first 2 chars and domain)
  static String maskEmail(String email) {
    if (!email.contains('@')) return email;
    final parts = email.split('@');
    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) return email;

    final maskedUsername =
        username.substring(0, 2) + '*' * (username.length - 2);
    return '$maskedUsername@$domain';
  }

  /// Mask phone number
  static String maskPhoneNumber(String phone) {
    if (phone.length < 4) return phone;
    final visible = phone.substring(phone.length - 4);
    final masked = '*' * (phone.length - 4);
    return '$masked$visible';
  }

  /// Debounce function calls
  static void debounce(Function function, Duration delay) {
    // Note: In a real implementation, you'd use Timer
    // This is a simplified version
    function();
  }

  /// Create slug from text
  static String createSlug(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'[-\s]+'), '-')
        .trim();
  }

  /// Get percentage
  static double getPercentage(double value, double total) {
    if (total == 0) return 0;
    return (value / total) * 100;
  }

  /// Clamp value between min and max
  static T clamp<T extends num>(T value, T min, T max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
}
