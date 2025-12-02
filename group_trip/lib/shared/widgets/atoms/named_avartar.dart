import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';

/// Avatar sinh từ tên (initials) + có thể hiển thị image nếu cung cấp.
/// Sử dụng:
/// NameAvatar(name: 'Nguyen Van A', size: 48)
class NameAvatar extends StatelessWidget {
  final String? name;
  final double size;
  final String? imageUrl; // network image
  final String? assetImage; // local asset path
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final TextStyle? textStyle;
  final VoidCallback? onTap;
  final bool showTooltip;
  final Color? overrideBackgroundColor;

  const NameAvatar({
    Key? key,
    required this.name,
    this.size = 48,
    this.imageUrl,
    this.assetImage,
    this.borderRadius,
    this.border,
    this.textStyle,
    this.onTap,
    this.showTooltip = false,
    this.overrideBackgroundColor,
  }) : super(key: key);

  // Lấy initials: chữ cái đầu của 2 từ đầu tiên. Ví dụ "Nguyen Van A" -> "NV"
  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      final p = parts[0];
      return p.isEmpty ? '' : p.characters.first.toUpperCase();
    }
    final first = parts[0].characters.first.toUpperCase();
    final second = parts[1].characters.first.toUpperCase();
    return '$first$second';
  }

  // Sinh màu nền cố định từ chuỗi (deterministic)
  Color _colorFromString(String? s) {
    if (overrideBackgroundColor != null) return overrideBackgroundColor!;
    final palette = [
      Color(0xFFEF9A9A),
      Color(0xFFF48FB1),
      Color(0xFFCE93D8),
      Color(0xFFB39DDB),
      Color(0xFF9FA8DA),
      Color(0xFF90CAF9),
      Color(0xFF81D4FA),
      Color(0xFF80DEEA),
      Color(0xFFA5D6A7),
      Color(0xFFFFF59D),
      Color(0xFFFFCC80),
      Color(0xFFFFAB91),
      Color(0xFFBCAAA4),
    ];
    if (s == null || s.isEmpty) return palette[Random().nextInt(palette.length)];
    // hash
    int hash = 0;
    for (int i = 0; i < s.length; i++) {
      hash = s.codeUnitAt(i) + ((hash << 5) - hash);
    }
    final index = (hash.abs()) % palette.length;
    return palette[index];
  }

  @override
  Widget build(BuildContext context) {
    final initials = _initials(name);
    final bgColor = _colorFromString(name ?? initials);

    final content = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: (imageUrl == null && assetImage == null) ? bgColor : null,
        border: border,
        borderRadius: borderRadius ?? BorderRadius.circular(size / 2),
        image: (imageUrl != null || assetImage != null)
            ? DecorationImage(
                image: (() {
                  if (imageUrl != null) {
                    final uri = Uri.tryParse(imageUrl!);
                    final isRemote = uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
                    final isFileUri = uri != null && uri.scheme == 'file';
                    final looksLikeLocalPath = !isRemote && (imageUrl!.startsWith('/') || RegExp(r'^[A-Za-z]:\\').hasMatch(imageUrl!));
                    if (isRemote) {
                      return NetworkImage(imageUrl!);
                    } else if (isFileUri || looksLikeLocalPath) {
                      var path = imageUrl!;
                      if (isFileUri) path = uri.toFilePath();
                      return FileImage(File(path));
                    } else {
                      return NetworkImage(imageUrl!);
                    }
                  }
                  return AssetImage(assetImage!) as ImageProvider<Object>;
                })() as ImageProvider<Object>,
                fit: BoxFit.cover,
              )
            : null,
      ),
      alignment: Alignment.center,
      child: (imageUrl == null && assetImage == null)
          ? Text(
              initials,
              style: textStyle ??
                  TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.4,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
            )
          : null,
    );

    final widget = GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(size / 2),
        child: content,
      ),
    );

    if (showTooltip && (name != null && name!.isNotEmpty)) {
      return Tooltip(message: name!, child: widget);
    }
    return widget;
  }
}
