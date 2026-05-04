import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppUtils {
  // Keyboard hide karne ke liye
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  // Date ko "24 Mar 2026" format mein badalne ke liye
  static String formatDate(String dateString) {
    try {
      final DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  // File size ko readable banane ke liye (e.g., 2.5 MB)
  static String formatBytes(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (Math.log(bytes) / Math.log(1024)).floor();
    return ((bytes / Math.pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
  }
}