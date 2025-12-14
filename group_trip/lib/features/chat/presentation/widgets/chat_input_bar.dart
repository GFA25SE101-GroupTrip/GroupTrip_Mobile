import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatInputBar extends StatefulWidget {
  final String senderId;
  final VoidCallback onSendMessage;
  final Function(File) onImagePicked;
  final Function(String) onTextChanged;
  final TextEditingController textController;
  final File? pickedImage;
  final VoidCallback onRemoveImage;

  const ChatInputBar({
    super.key,
    required this.senderId,
    required this.onSendMessage,
    required this.onImagePicked,
    required this.onTextChanged,
    required this.textController,
    required this.pickedImage,
    required this.onRemoveImage,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null) {
      widget.onImagePicked(File(file.path));
    }
  }

  Future<void> _pickImageFromCamera() async {
    final file = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (file != null) {
      widget.onImagePicked(File(file.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            // 📸 Image picker button
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _buildImageSourceOptions(),
                );
              },
              icon: const Icon(Icons.image_outlined, color: Colors.blue),
            ),
            
            // 📝 Text input field
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🖼️ Image preview
                  if (widget.pickedImage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              widget.pickedImage!,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: widget.onRemoveImage,
                              child: const CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.black54,
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // 📝 Text field
                  TextField(
                    controller: widget.textController,
                    onChanged: widget.onTextChanged,
                    decoration: InputDecoration(
                      hintText: "Nhập tin nhắn...",
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => widget.onSendMessage(),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 8),
            
            // ✉️ Send button
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: widget.onSendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                mini: true,
                backgroundColor: Colors.blue,
                onPressed: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
                child: const Icon(Icons.camera_alt),
              ),
              const SizedBox(height: 8),
              const Text("Camera"),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                mini: true,
                backgroundColor: Colors.blue,
                onPressed: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
                child: const Icon(Icons.image),
              ),
              const SizedBox(height: 8),
              const Text("Gallery"),
            ],
          ),
        ],
      ),
    );
  }
}
