import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:riverpod_test/data/book/model/book_model.dart';
import 'package:riverpod_test/data/book/remote/book_remote.dart';

class BookFormNotifier extends StateNotifier<AsyncValue<BookModel?>> {
  BookFormNotifier() : super(AsyncValue.data(null));

  Future<void> createBook(InsertBook book, XFile? image) async {
    state = AsyncValue.loading();

    try {
      final Map<String, dynamic> map = book.toJson();

      if (image != null) {
        final mimeType = lookupMimeType(image.path) ?? 'image/jpeg';

        final part = mimeType.split('/');

        map['image'] = await MultipartFile.fromFile(image.path,
            filename: image.name, contentType: MediaType(part[0], part[1]));
      }

      final FormData form = FormData.fromMap(map);

      final inserted = await BookRemote().insertBook(form);

      state = AsyncValue.data(inserted);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
