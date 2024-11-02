import 'package:flutter/material.dart';
import '../utils/colors.dart';

class MyChip extends StatelessWidget {
  final String label;
  final bool hasDropdown;

  const MyChip({required this.label, this.hasDropdown = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (hasDropdown)
              Icon(
                Icons.keyboard_arrow_down_outlined,
                color: AppColors.primary,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}
