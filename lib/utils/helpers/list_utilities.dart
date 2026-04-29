class ListUtilities {
  static List<T> takeEvenSpreadSample<T>(List<T> data, int sampleSize) {
    if (sampleSize <= 0) return [];
    if (sampleSize >= data.length) return List.from(data);

    final sampled = <T>[];
    final step = (data.length - 1) / (sampleSize - 1);

    for (int i = 0; i < sampleSize; i++) {
      final index = (i * step).round();
      sampled.add(data[index]);
    }

    return sampled;
  }
}
