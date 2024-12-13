import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:greenpoint/main.dart';
import 'package:greenpoint/models/notifikasi_model.dart';
import 'dart:convert';

class NotifikasiProvider extends ChangeNotifier {
  // Inisialisasi FlutterSecureStorage
  final _storage = const FlutterSecureStorage();

  List<NotifikasiModel> _notifications = [];

  List<NotifikasiModel> get notifications => _notifications;

  // Jumlah notifikasi yang belum dibaca
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  NotifikasiProvider() {
    // Muat notifikasi yang tersimpan saat inisialisasi
    _loadNotifications();
  }

  // Tambah notifikasi baru
  void addNotification(NotifikasiModel notification) async {
    _notifications.insert(0, notification);
    showNotification(notification);

    // Simpan ke penyimpanan aman
    await _saveNotifications();
    notifyListeners();
  }

  // Tandai notifikasi sebagai sudah dibaca
  void markAsRead(String id) async {
    final index = _notifications.indexWhere((notif) => notif.id == id);
    if (index != -1) {
      _notifications[index] = NotifikasiModel(
        id: _notifications[index].id,
        title: _notifications[index].title,
        message: _notifications[index].message,
        timestamp: _notifications[index].timestamp,
        isRead: true,
        type: _notifications[index].type,
      );

      // Simpan perubahan
      await _saveNotifications();
      notifyListeners();
    }
  }

  // Hapus notifikasi
  void removeNotification(String id) async {
    _notifications.removeWhere((notif) => notif.id == id);
    await _saveNotifications();
    notifyListeners();
  }

  // Simpan notifikasi ke penyimpanan aman
  Future<void> _saveNotifications() async {
    final notificationList = _notifications.map((n) => n.toMap()).toList();
    final encodedNotifications = json.encode(notificationList);

    await _storage.write(key: 'notifications', value: encodedNotifications);
  }

  // Muat notifikasi dari penyimpanan aman
  Future<void> _loadNotifications() async {
    final savedNotifications = await _storage.read(key: 'notifications');

    if (savedNotifications != null) {
      final decodedNotifications = json.decode(savedNotifications) as List;
      _notifications = decodedNotifications.map((n) {
        return NotifikasiModel.fromMap(n);
      }).toList();
    }

    notifyListeners();
  }

  // Bersihkan semua notifikasi
  void clearAllNotifications() async {
    _notifications.clear();
    await _storage.delete(key: 'notifications');
    notifyListeners();
  }

  void showNotification(NotifikasiModel notification) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_id', // ID channel unik
      'General Notifications', // Nama channel
      channelDescription: 'Notifications for the app',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // ID notifikasi
      notification.title, // Judul notifikasi
      notification.message, // Pesan notifikasi
      notificationDetails,
    );
  }
}
