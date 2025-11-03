import 'dart:io';

import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController bioCtrl;
  final File? avatarFile;
  final VoidCallback onEditAvatar; // open picker
  final VoidCallback onSaveAvatarBio;
  final bool isEditing;
  const ProfileHeader({
    Key? key,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.bioCtrl,
    required this.avatarFile,
    required this.onEditAvatar,
    required this.onSaveAvatarBio,
    required this.isEditing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(7),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7F7FD5), Color(0xFF86A8E7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              if (avatarFile != null)
                ClipOval(
                  child: Image.file(avatarFile!, width: 80, height: 80, fit: BoxFit.cover),
                )
              else
                CircleAvatar(backgroundColor: Colors.white24, radius: 40, child: Text(_initials(nameCtrl.text))),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onEditAvatar,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: const Icon(Icons.edit, size: 18, color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // name / email
          if (isEditing) ...[
            TextField(
              controller: nameCtrl,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              decoration: const InputDecoration(border: InputBorder.none, hintText: 'Name', hintStyle: TextStyle(color: Colors.white70)),
            ),
            TextField(
              controller: emailCtrl,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
              decoration: const InputDecoration(border: InputBorder.none, hintText: 'Email', hintStyle: TextStyle(color: Colors.white70)),
            ),
          ] else ...[
            Text(nameCtrl.text, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(emailCtrl.text, style: const TextStyle(color: Colors.white70)),
          ],

          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Icon(Icons.check_circle, color: Colors.greenAccent, size: 18),
            SizedBox(width: 6),
            Text('Active', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          ]),

          const SizedBox(height: 8),

          if (isEditing)
            Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(controller: bioCtrl, maxLines: 3, decoration: const InputDecoration(border: InputBorder.none, hintText: 'Bio', hintStyle: TextStyle(color: Colors.white70))),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: onSaveAvatarBio,
                icon: const Icon(Icons.save),
                label: const Text('Lưu ảnh & Bio'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white24, foregroundColor: Colors.white),
              ),
            ])
          else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(bioCtrl.text, style: const TextStyle(color: Colors.white), maxLines: 3, overflow: TextOverflow.ellipsis),
            ),
        ],
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0][0] + parts.last[0]).toUpperCase();
  }
}
