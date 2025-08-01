import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:riverpod_test/data/book/remote/book_remote.dart';

class ChangeBookImageNotifier extends StateNotifier<AsyncValue<String?>> {
  ChangeBookImageNotifier(this.ref, this.bookId) : super(AsyncValue.data(null));

  final Ref ref;
  final int bookId;

  Future<void> changeImage(XFile pickedImage) async {
    state = AsyncValue.loading();

    final mimeType = lookupMimeType(pickedImage.path) ?? 'image/jpeg';

    final part = mimeType.split('/');

    final form = FormData.fromMap({
      'image': await MultipartFile.fromFile(pickedImage.path,
          filename: pickedImage.name, contentType: MediaType(part[0], part[1]))
    });

    state = await AsyncValue.guard(
        () => BookRemote().updateBookImage(bookId, form));
  }
}
