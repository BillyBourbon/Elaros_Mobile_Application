import 'package:flutter/material.dart';
import '/../models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  Color getColor() {
    switch (notification.type) {
      case "info":
        return Colors.blue;
      case "success":
        return Colors.green;
      case "warning":
        return Colors.orange;
      case "error":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: Icon(Icons.notifications, color: getColor()),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 4),
            Text(
              "${notification.time.hour}:${notification.time.minute}",
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 233, 121, 121),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
