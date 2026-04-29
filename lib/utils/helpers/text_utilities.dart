class TextUtilities {
  static String capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  static String splitCamelCase(String text) {
    bool isFirst = true;
    return text.split('').fold('', (prev, current) {
      if (current.toUpperCase() == current && !isFirst) {
        return '$prev ${current.toLowerCase()}';
      } else {
        isFirst = false;
        return '$prev$current';
      }
    });
  }
}
