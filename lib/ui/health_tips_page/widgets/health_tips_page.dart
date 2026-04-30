import 'package:elaros_mobile_app/config/constants/constants.dart';
import 'package:flutter/material.dart';

class HealthTipsScreen extends StatelessWidget {
  const HealthTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colourScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colourScheme.primary,
      appBar: AppBar(
        title: Text(
          'Health Tips',
          style: DefaultTextStyles.defaultTextStyleAppBar,
        ),
        centerTitle: true,
        titleTextStyle: DefaultTextStyles.defaultTextStyleAppBar,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8,
        children: [
          const SizedBox(height: 8),
          ...HealthTips.healthTips.entries.map(
            (e) =>
                _buildTip(context: context, title: e.key, description: e.value),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTip({
    required BuildContext context,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);
    final colourScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colourScheme.secondary,
        border: BoxBorder.all(color: Colors.grey.shade800),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(title, style: DefaultTextStyles.defaultTextStyleTitleBold),
                const SizedBox(height: 8),
                Text(description, style: DefaultTextStyles.defaultTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
