import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// PHẢI IMPORT file main.dart để lấy navigatorKey
import 'package:ghepxenew/main.dart';

class PushNotificationSystem {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // BỎ BuildContext context ở đây
  static Future<void> initialize() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // 1. Xin quyền
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // 2. Lấy Token
    String? token = await messaging.getToken();
    debugPrint("FCM TOKEN: $token");

    // 3. Xử lý Foreground (Đang mở App)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Nhận thông báo Foreground: ${message.notification?.title}");

      String? type = message.data['type'];

      // Lấy context từ navigatorKey toàn cục
      final context = navigatorKey.currentContext;
      if (context == null) return;

      if (type == 'NEW_BOOKING_REQUEST') {
        _showBookingDialog(context, message);
      } else {
        _showTopNotification(context, message);
      }
    });

    // 4. Xử lý khi nhấn vào thông báo
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Người dùng nhấn vào thông báo!");
    });
  }

  // CÁC HÀM HIỂN THỊ DƯỚI ĐÂY GIỮ NGUYÊN NHƯ HÀO ĐÃ VIẾT
  static void _showBookingDialog(BuildContext context, RemoteMessage message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.directions_car, color: Colors.green),
            SizedBox(width: 10),
            Text("Chuyến đi mới!"),
          ],
        ),
        content: Text(message.notification?.body ?? "Bạn có một yêu cầu đặt xe mới."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("BỎ QUA", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(context);
              // Hào điều hướng ở đây:
              // navigatorKey.currentState?.pushNamed('/trip_detail', arguments: ...);
            },
            child: const Text("XEM NGAY", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  static void _showTopNotification(BuildContext context, RemoteMessage message) {
    // Hàm này Hào giữ nguyên code cũ
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${message.notification?.title}\n${message.notification?.body}"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blueAccent,
        )
    );
  }
}