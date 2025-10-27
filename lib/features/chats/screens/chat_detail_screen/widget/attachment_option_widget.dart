import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/helpers/helper_function.dart';

class AttachmentOptionsWidget extends StatelessWidget {
  final void Function(String) onOptionSelected;

  const AttachmentOptionsWidget({super.key, required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? TColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
        ),
        children: [
          _buildOption(context, Icons.insert_drive_file, "Document", TColors.greenGradient, isDark),
          _buildOption(context, Icons.camera_alt, "Camera", TColors.redGradient, isDark),
          _buildOption(context, Icons.photo, "Gallery", TColors.blueGradient, isDark),
          _buildOption(context, Icons.audiotrack, "Audio", TColors.orangeGradient, isDark),
          _buildOption(context, Icons.location_on, "Location", TColors.greenGradient, isDark),
          _buildOption(context, Icons.contacts, "Contact", TColors.redGradient, isDark),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String label, Gradient gredient, bool isDark) {
    return GestureDetector(
      onTap: () => onOptionSelected(label),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60, // Same as radius * 2
            height: 60, // Same as radius * 2
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gredient,
            ),
            child: Icon(icon, size: 30, color: Colors.white),
          ),
          const SizedBox(height: 8.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? TColors.textWhite : TColors.textblack,
            ),
          ),
        ],
      ),
    );
  }
}
