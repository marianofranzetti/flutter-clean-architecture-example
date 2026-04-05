import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:clean_template/layers/data/dto/character_dto.dart';

abstract class Api {
  Future<List<CharacterDto>> loadCharacters({int page = 0});
}

class ApiImpl implements Api {
  final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://rickandmortyapi.com/api/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  @override
  Future<List<CharacterDto>> loadCharacters({int page = 0}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'character/',
        queryParameters: {'page': page},
      );
      return (response.data!['results'] as List<dynamic>)
          .map((e) => CharacterDto.fromMap(e))
          .toList();
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        if (kDebugMode) {
          debugPrint('API error [${e.response?.statusCode}]: ${e.response?.data}');
        }
        //  API responds with 404 when reached the end
        if (e.response?.statusCode == 404) return [];
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        if (kDebugMode) debugPrint('Network error: $e');
      }
    }

    return [];
  }
}
