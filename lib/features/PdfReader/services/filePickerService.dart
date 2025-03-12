
import 'package:file_picker/file_picker.dart';

class FilePickerService {
  static Future<String?> pickPDF() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      return result.files.single.path;
    }
    return null;
  }
}

