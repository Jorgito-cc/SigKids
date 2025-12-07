import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

/// Avatar de niño con indicador de estado
class ChildAvatar extends StatelessWidget {
  final String name;
  final bool isOnline;
  final bool isInsideArea;
  final double size;
  final VoidCallback? onTap;

  const ChildAvatar({
    Key? key,
    required this.name,
    this.isOnline = false,
    this.isInsideArea = true,
    this.size = 60,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name);
    final statusColor =
        isInsideArea ? AppTheme.successColor : AppTheme.dangerColor;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Avatar principal
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: statusColor.withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Indicador de estado (dentro/fuera del área)
          if (isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.3,
                height: size * 0.3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: statusColor,
                  border: Border.all(
                    color: AppTheme.backgroundColor,
                    width: 2,
                  ),
                ),
                child: Icon(
                  isInsideArea ? Icons.check : Icons.warning,
                  size: size * 0.18,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
