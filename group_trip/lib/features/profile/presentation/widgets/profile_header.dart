import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/profile/providers/profile_provider.dart';
import 'package:group_trip/shared/widgets/atoms/named_avartar.dart';

class ProfileHeader extends ConsumerWidget {
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController bioCtrl;
  final File? avatarFile;
  final String? avatarUrl;
  final VoidCallback onEditAvatar; // open picker
  final VoidCallback onSaveAvatarBio;
  final bool isEditing;
  const ProfileHeader({
    Key? key,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.bioCtrl,
    required this.avatarFile,
    required this.avatarUrl,
    required this.onEditAvatar,
    required this.onSaveAvatarBio,
    required this.isEditing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewProvider);
    return Container(
      margin: const EdgeInsets.all(7),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      decoration: BoxDecoration(),
      child: Column(
        children: [
          Stack(
            children: [
              if (avatarFile != null)
                ClipOval(
                  child: Image.file(
                    avatarFile!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                )
              else if (avatarUrl != null && avatarUrl!.trim().isNotEmpty)
                // avatarUrl may be a remote http(s) URL or a local file path (file:// or absolute path).
                // Prefer NetworkImage for http(s), otherwise use FileImage to avoid passing file:/// to Image.network.
                () {
                  final uri = Uri.tryParse(avatarUrl!);
                  final isRemote =
                      uri != null &&
                      (uri.scheme == 'http' || uri.scheme == 'https');
                  final isFileUri = uri != null && uri.scheme == 'file';
                  final looksLikeLocalPath =
                      !isRemote &&
                      (avatarUrl!.startsWith('/') ||
                          RegExp(r'^[A-Za-z]:\\').hasMatch(avatarUrl!));

                  final trimmed = avatarUrl!.trim();
                  // ignore: avoid_print
                  print('🖼️ header avatar url="$trimmed"');
                  if (isRemote) {
                    return ClipOval(
                      child: Image.network(
                        trimmed,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, st) {
                          // ignore: avoid_print
                          print(
                            '❌ Image.network(header) failed for $trimmed: $err',
                          );
                          return NameAvatar(name: nameCtrl.text, size: 80);
                        },
                      ),
                    );
                  } else if (isFileUri || looksLikeLocalPath) {
                    String path = trimmed;
                    if (isFileUri) {
                      // remove file:// scheme
                      path = uri.toFilePath();
                    }
                    try {
                      return ClipOval(
                        child: Image.file(
                          File(path),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      );
                    } catch (e) {
                      // ignore: avoid_print
                      print('❌ Image.file(header) failed for $path: $e');
                      return NameAvatar(name: nameCtrl.text, size: 80);
                    }
                  } else {
                    return NameAvatar(name: nameCtrl.text, size: 80);
                  }
                }()
              else
                NameAvatar(name: state?.displayName ?? nameCtrl.text, size: 80),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onEditAvatar,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
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
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: state?.displayName ?? 'Name',
                hintStyle: const TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
              ),
            ),
            TextField(
              controller: emailCtrl,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: state?.displayName ?? 'Email',
                hintStyle: const TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
              ),
            ),
          ] else ...[
            Text(
              state?.displayName ?? nameCtrl.text,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              state?.displayName ?? emailCtrl.text,
              style: const TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
            ),
          ],

          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.check_circle, color: Colors.greenAccent, size: 18),
              SizedBox(width: 6),
              Text(
                'Active',
                style: TextStyle(
                  color: Color.fromARGB(255, 12, 12, 12),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          if (isEditing)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: bioCtrl,
                    minLines: 3,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      // show server bio as hint only when controller is empty
                      hintText: bioCtrl.text.trim().isEmpty
                          ? (state?.bio ?? 'Giới thiệu bản thân')
                          : null,
                      hintStyle: const TextStyle(color: Color.fromARGB(153, 0, 0, 0)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if(state?.isUpdated == false) 
                ElevatedButton.icon(
                  onPressed: onSaveAvatarBio,
                  icon: const Icon(Icons.save),
                  label: const Text('Lưu ảnh & Bio'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(57, 7, 41, 193),
                    foregroundColor: Color.fromARGB(255, 255, 255, 255),
                  ),
                )
                else ElevatedButton.icon(
                  onPressed: onSaveAvatarBio,
                  icon: const Icon(Icons.save),
                  label: const Text('Cập nhật'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(57, 7, 41, 193),
                    foregroundColor: Color.fromARGB(255, 255, 255, 255),
                  ),
                )
              ],
            )
          else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                state?.bio ?? bioCtrl.text,
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}
