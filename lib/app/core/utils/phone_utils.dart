class PhoneUtils {
  static const String kuwaitCountryCode = '+965';

  static String formatKuwaitPhone(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'\s+'), '').trim();
    if (cleaned.isEmpty) return cleaned;

    if (cleaned.startsWith('+')) return cleaned;

    if (cleaned.startsWith('965') && cleaned.length > 8) {
      return '+$cleaned';
    }

    return '$kuwaitCountryCode$cleaned';
  }
}
