import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/models/driver_registration_model.dart';

class DocumentUploadButton extends StatelessWidget {
  final String title;
  final DocumentField document;
  final VoidCallback onTakePhoto;
  final VoidCallback onUploadDocument;

  const DocumentUploadButton({
    super.key,
    required this.title,
    required this.document,
    required this.onTakePhoto,
    required this.onUploadDocument,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: document.isUploaded ? PinkAppTheme.primaryPink.withValues(alpha: 0.05) : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          if (document.isUploaded)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: document.filePath!.toLowerCase().endsWith('.pdf')
                      ? const Center(child: Icon(Icons.picture_as_pdf, size: 40, color: Colors.red))
                      : (kIsWeb
                          ? Image.network(
                              document.filePath!,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(document.filePath!),
                              fit: BoxFit.cover,
                            )),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Uploaded", style: TextStyle(color: PinkAppTheme.success, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {
                        // Allow replacement, show bottom sheet
                        _showOptions(context);
                      },
                      child: const Text("Replace"),
                    )
                  ],
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera"),
                    onPressed: onTakePhoto,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: PinkAppTheme.primaryPink,
                      side: const BorderSide(color: PinkAppTheme.primaryPink),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.upload_file),
                    label: const Text("Upload"),
                    onPressed: onUploadDocument,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: PinkAppTheme.primaryPink,
                      side: const BorderSide(color: PinkAppTheme.primaryPink),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(ctx);
                onTakePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Upload from Device'),
              onTap: () {
                Navigator.pop(ctx);
                onUploadDocument();
              },
            ),
          ],
        ),
      ),
    );
  }
}
