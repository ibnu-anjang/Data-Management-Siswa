import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

/// Centralized service for uploading student photos to Cloudinary Image CDN.
/// Uses Unsigned Upload Preset for secure client-side upload without exposing API secrets.
class CloudinaryService {
  static final CloudinaryService _instance = CloudinaryService._internal();
  factory CloudinaryService() => _instance;
  CloudinaryService._internal();

  // Cloudinary Credentials configured by user
  static const String cloudName = 'tyxmoxst';
  static const String uploadPreset = 'sekolahku_siswa';

  static String get uploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

  /// Uploads an [XFile] to Cloudinary using the unsigned upload preset.
  /// Returns the HTTPS `secure_url` on success, or `null` on failure.
  Future<String?> uploadImage(XFile imageFile) async {
    try {
      final uri = Uri.parse(uploadUrl);
      final request = http.MultipartRequest('POST', uri);

      // Form fields
      request.fields['upload_preset'] = uploadPreset;

      // File attachment
      final bytes = await imageFile.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: imageFile.name.isNotEmpty ? imageFile.name : 'student_photo.jpg',
      );
      request.files.add(multipartFile);

      // Execute request with a timeout
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final secureUrl = data['secure_url'] as String?;
        return secureUrl;
      } else {
        // Failed response
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
