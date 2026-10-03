import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';

class AppUserAvatar extends StatelessWidget {
  const AppUserAvatar({super.key, this.imageUrl, this.radius = 20});
  final String? imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    const placeholder = Icon(
      Icons.person_outline,
      color: AppColors.colorOnPrimarioContainer,
    );
    return ExcludeSemantics(
      child: CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.colorPrimarioContainer,
        child: imageUrl == null || imageUrl!.isEmpty
            ? placeholder
            : ClipOval(
                child: Image.network(
                  imageUrl!,
                  width: radius * 2,
                  height: radius * 2,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => placeholder,
                ),
              ),
      ),
    );
  }
}
