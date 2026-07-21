import 'dart:typed_data';
import 'package:http/http.dart' as http;

/// Uploads image bytes to a public Supabase Storage bucket and returns the
/// public URL. This talks to Supabase's REST Storage API directly over
/// http rather than pulling in the full supabase_flutter SDK, since this is
/// the only Supabase interaction the client needs to make.
///
/// Fill in [supabaseUrl] and [supabaseAnonKey] (Supabase dashboard ->
/// Project Settings -> API), and make sure a PUBLIC bucket named [bucket]
/// exists (Storage -> New bucket -> toggle "Public").
class AvatarUploadService {
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String bucket;

  const AvatarUploadService({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    this.bucket = 'avatars',
  });

  Future<String> uploadAvatar({
    required String userId,
    required Uint8List bytes,
    required String fileExtension, // e.g. 'jpg', 'png'
  }) async {
    final objectPath =
        '$userId/avatar_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
    final uploadUrl = Uri.parse('$supabaseUrl/storage/v1/object/$bucket/$objectPath');

    final response = await http.post(
      uploadUrl,
      headers: {
        'Authorization': 'Bearer $supabaseAnonKey',
        'apikey': supabaseAnonKey,
        'Content-Type': _contentTypeFor(fileExtension),
        'x-upsert': 'true',
      },
      body: bytes,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Avatar upload failed (${response.statusCode}): ${response.body}');
    }

    return '$supabaseUrl/storage/v1/object/public/$bucket/$objectPath';
  }

  String _contentTypeFor(String ext) {
    switch (ext.toLowerCase()) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}