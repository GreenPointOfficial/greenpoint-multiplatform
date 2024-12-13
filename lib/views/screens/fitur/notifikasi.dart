// notification_page.dart
import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:greenpoint/assets/constants/screen_utils.dart';
import 'package:greenpoint/providers/notifikasi_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        double screenHeight = ScreenUtils.screenHeight(context);
        double screenWidth = ScreenUtils.screenWidth(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      backgroundColor: GreenPointColor.secondary,
      leading: 
          
          IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
              iconSize: screenWidth * 0.06,
            ),
      title: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Notifikasi",
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
           
          ],
        ),
      ),
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      actions: [
        Consumer<NotifikasiProvider>(
          builder: (context, notifikasiProvider, child) {
            return notifikasiProvider.notifications.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.delete_sweep, color: Colors.white),
                    onPressed: () {
                      // Konfirmasi sebelum menghapus
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Hapus Semua Notifikasi'),
                          content: const Text('Apakah Anda yakin ingin menghapus semua notifikasi?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Batal'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                notifikasiProvider.clearAllNotifications();
                                Navigator.pop(context);
                              },
                              child: const Text('Hapus'),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const SizedBox.shrink();
          },
        ),
      ],
      ),
  

      body: Consumer<NotifikasiProvider>(
        builder: (context, NotifikasiProvider, child) {
          final notifications = NotifikasiProvider.notifications;
          
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined, 
                    size: 100, 
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tidak ada notifikasi',
                    style: GoogleFonts.dmSans(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Dismissible(
                key: Key(notification.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  // Hapus notifikasi
                  NotifikasiProvider.removeNotification(notification.id);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: !notification.isRead ? GreenPointColor.abu : GreenPointColor.secondary,
                      ), borderRadius: BorderRadius.circular(10)
                    ),
                    child: ListTile(
                  
                      leading: _getNotificationIcon(notification.type),
                      title: Text(
                        notification.title,
                        style: GoogleFonts.dmSans(
                          fontWeight: 
                            notification.isRead ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.message,
                            style: GoogleFonts.dmSans(),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _formatTimestamp(notification.timestamp),
                            style: GoogleFonts.dmSans(
                              color: Colors.grey, 
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: !notification.isRead
                          ? Icon(Icons.circle, color: Colors.blue, size: 10)
                          : null,
                      onTap: () {
                        // Tandai sebagai sudah dibaca
                        NotifikasiProvider.markAsRead(notification.id);
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Helper untuk mendapatkan ikon berdasarkan tipe notifikasi
  Widget _getNotificationIcon(String? type) {
    switch (type) {
      case 'payout':
        return Image.asset('lib/assets/imgs/poin.png', height: 40, width: 40);
      case 'reward':
        return Icon(Icons.card_giftcard, color: Colors.purple);
      case 'achievement':
        return Icon(Icons.stars, color: Colors.orange);
      default:
        return Icon(Icons.notifications, color: Colors.blue);
    }
  }

  // Format timestamp dengan terjemahan Indonesia
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (timestamp.isAfter(today)) {
      return 'Hari ini, ${DateFormat('HH:mm').format(timestamp)}';
    } else if (timestamp.isAfter(yesterday)) {
      return 'Kemarin, ${DateFormat('HH:mm').format(timestamp)}';
    } else {
      return DateFormat('dd MMM yyyy, HH:mm').format(timestamp);
    }
  }
}
