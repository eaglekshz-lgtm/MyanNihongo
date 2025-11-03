/// Utility functions for the app
library;

/// Format time duration to readable string
String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  if (hours > 0) {
    return '${hours}h ${minutes}m';
  } else if (minutes > 0) {
    return '${minutes}m ${seconds}s';
  } else {
    return '${seconds}s';
  }
}

/// Calculate percentage
double calculatePercentage(int value, int total) {
  if (total == 0) return 0.0;
  return (value / total) * 100;
}

/// Shuffle a list and return a copy
List<T> shuffleList<T>(List<T> list) {
  final newList = List<T>.from(list);
  newList.shuffle();
  return newList;
}

/// Get random items from a list
List<T> getRandomItems<T>(List<T> list, int count) {
  if (list.length <= count) {
    return List<T>.from(list);
  }
  final shuffled = shuffleList(list);
  return shuffled.take(count).toList();
}

/// Validate if string is not empty
bool isNotEmptyString(String? value) {
  return value != null && value.trim().isNotEmpty;
}

/// Get grade based on percentage
String getGrade(double percentage) {
  if (percentage >= 90) return 'A';
  if (percentage >= 80) return 'B';
  if (percentage >= 70) return 'C';
  if (percentage >= 60) return 'D';
  return 'F';
}

/// Format date to readable string
String formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

/// Format date and time to readable string
String formatDateTime(DateTime dateTime) {
  return '${formatDate(dateTime)} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
}

/// Calculate days since date
int daysSince(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);
  return difference.inDays;
}
