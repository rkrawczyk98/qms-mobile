import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InfoCard extends StatelessWidget {
  final String title; // Main value
  final String titleLabel; // Label above the title
  final Map<String, String?> fields; // Field-value pairs for rows
  final Icon? icon; // Optional customizable icon
  final bool showTabButtons;
  final VoidCallback? onRightTap;
  final VoidCallback? onLeftTap;
  final Color? leadingColor;
  final String? leftTapText;
  final String? rightTapText;

  const InfoCard({
    super.key,
    required this.title,
    required this.titleLabel,
    required this.fields,
    this.icon,
    this.onRightTap,
    this.onLeftTap,
    this.leadingColor,
    this.leftTapText,
    this.rightTapText,
    this.showTabButtons = true,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    // Split fields into two groups for left and right alignment
    final leftFields = fields.entries
        .toList()
        .asMap()
        .entries
        .where((entry) => entry.key % 2 == 0) // Even index for left side
        .map((entry) => entry.value)
        .toList();

    final rightFields = fields.entries
        .toList()
        .asMap()
        .entries
        .where((entry) => entry.key % 2 != 0) // Odd index for right side
        .map((entry) => entry.value)
        .toList();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: leadingColor ?? Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                icon ??
                    Icon(
                      Icons.info,
                      color: leadingColor ?? Colors.blue,
                      size: 35,
                    ), // Default icon
              ],
            ),
            const SizedBox(height: 16),

            // Fields Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: leftFields.map((entry) {
                      final fieldName = entry.key;
                      final fieldValue = entry.value ?? localization.unknown;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fieldName,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              fieldValue,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Right column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: rightFields.map((entry) {
                      final fieldName = entry.key;
                      final fieldValue = entry.value ?? localization.unknown;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              fieldName,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              fieldValue,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            showTabButtons
                ? Column(
                    children: [
                      const SizedBox(height: 16),
                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (onLeftTap != null)
                            TextButton(
                              onPressed: onLeftTap,
                              style: TextButton.styleFrom(
                                foregroundColor: leadingColor ?? Colors.blue,
                              ),
                              child: Text(leftTapText ?? localization.edit),
                            ),
                          if (onRightTap != null)
                            TextButton(
                              onPressed: onRightTap,
                              style: TextButton.styleFrom(
                                foregroundColor: leadingColor ?? Colors.blue,
                              ),
                              child: Text(rightTapText ?? localization.manage),
                            ),
                        ],
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
