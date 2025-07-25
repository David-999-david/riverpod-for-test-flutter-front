import 'package:dio/dio.dart';
import 'package:riverpod_test/api_url.dart';
import 'package:riverpod_test/data/book/model/book_model.dart';
import 'package:riverpod_test/dio_client.dart';

class BookRemote {
  final Dio _dio = DioClient.dio;

  Future<BookModel> insertBook(InsertBook book) async {
    try {
      final response = await _dio.post(ApiUrl.createBook, data: book.toJson());

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final data = response.data['data'] as Map<String, dynamic>;

        return BookModel.fromJson(data);
      } else {
        throw Exception(
            'Error => status=$status, message : ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('${e.response!.data['message']}');
    }
  }

  Future<List<ReturnBook>> fetchAllBooksAuthor() async {
    try {
      final response = await _dio.get(ApiUrl.fetAllBook);

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final data = response.data['data'] as List<dynamic>;

        return data.map((b) => ReturnBook.fromJson(b)).toList();
      } else {
        throw Exception(
            'Error => status=$status, message : ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('${e.response!.data['message']}');
    }
  }
}
