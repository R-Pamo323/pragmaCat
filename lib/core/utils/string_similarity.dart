import 'dart:math';

class StringSimilarity {
  const StringSimilarity._internal();

  static int levenshteinDistance(String a, String b) {
    final int m = a.length;
    final int n = b.length;

    if (m == 0) return n;
    if (n == 0) return m;

    List<int> previous = List<int>.generate(n + 1, (int i) => i);
    List<int> current = List<int>.filled(n + 1, 0);

    for (int i = 1; i <= m; i++) {
      current[0] = i;
      for (int j = 1; j <= n; j++) {
        final int insertCost = current[j - 1] + 1;
        final int deleteCost = previous[j] + 1;
        final int substituteCost =
            previous[j - 1] + (a[i - 1] == b[j - 1] ? 0 : 1);
        current[j] = min(min(insertCost, deleteCost), substituteCost);
      }
      final List<int> swap = previous;
      previous = current;
      current = swap;
    }

    return previous[n];
  }

  static String? findClosestMatch(String query, List<String> candidates) {
    if (candidates.isEmpty) return null;

    final String queryLower = query.toLowerCase();
    String? closest;
    int closestDistance = max(query.length, 256);

    for (final String candidate in candidates) {
      final String candidateLower = candidate.toLowerCase();
      if (candidateLower == queryLower) return candidate;

      final int distance = levenshteinDistance(queryLower, candidateLower);
      final double similarityThreshold = (candidateLower.length / 2)
          .clamp(1, 4)
          .toDouble();

      if (distance < closestDistance && distance <= similarityThreshold) {
        closest = candidate;
        closestDistance = distance;
      }
    }

    return closest;
  }
}
