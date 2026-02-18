import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/notification_view_model.dart';
import 'widgets/notification_card.dart';

class NotificationPage extends StatelessWidget {
  // ✅ Must match this exactly
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationViewModel(),
      child: Consumer<NotificationViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(title: const Text("Notifications")),
            body: ListView.builder(
              itemCount: viewModel.notifications.length,
              itemBuilder: (context, index) {
                final notification = viewModel.notifications[index];
                return NotificationCard(
                  notification: notification,
                  onTap: () {
                    notification.isRead = true;
                    viewModel.notifyListeners();
                  },
                );s
              },
            ),
          );
        },
      ),
    );
  }
}
