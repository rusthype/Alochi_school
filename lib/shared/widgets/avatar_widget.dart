import 'package:flutter/material.dart';
import '../../core/utils/avatar_color.dart';
import '../constants/colors.dart';

class AvatarWidget extends StatelessWidget {
  final String name;
  final double size;
  final String? imageUrl;

  const AvatarWidget({
    super.key,
    required this.name,
    this.size = 40,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: kBgBorder,
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: avatarColor(name),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          avatarInitials(name),
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.35,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
