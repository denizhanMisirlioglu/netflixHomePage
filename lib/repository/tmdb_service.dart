import 'dart:convert';
import 'package:http/http.dart' as http;

class TMDbService {
  final String apiKey = 'aca0016392736389eef8a38c4d72c918';
  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<String?> fetchPosterByTitle(String title) async {
    final url = Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$title');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final posterPath = data['results'][0]['poster_path'];
          if (posterPath != null) {
            return 'https://image.tmdb.org/t/p/w500$posterPath';
          }
        }
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching poster for $title: $e');
    }
    return null;
  }

  Future<String?> fetchTvShowPoster(String title) async {
    final url = Uri.parse('$baseUrl/search/tv?api_key=$apiKey&query=$title');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final posterPath = data['results'][0]['poster_path'];
          if (posterPath != null) {
            return 'https://image.tmdb.org/t/p/w500$posterPath';
          }
        }
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching TV show poster for $title: $e');
    }
    return null;
  }
}
