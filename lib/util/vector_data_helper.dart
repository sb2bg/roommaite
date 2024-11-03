import 'dart:convert';

import 'package:roommaite/models/profile.dart';
import 'package:roommaite/models/questions.dart';
import 'package:roommaite/providers/auth_provider.dart';
import 'package:http/http.dart' as http;

const url = 'http://127.0.0.1:8000';

class IrisVectorDataHelper {
  static Future<List<Profile>> getMatches(AuthService service) async {
    final profile = await service.getProfile();
    final questions = service.getQuestions();
    final matches = await http
        .get(Uri.parse('$url/find_matches/$questions/30/${profile.location}'));
    final json = jsonDecode(matches.body);
    final List<Profile> profiles = [];

    for (final match in json) {
      final uuid = match[0];
      final profile = await service.getProfileById(uuid);
      if (profile != null) {
        profiles.add(profile);
      }
    }

    return profiles;
  }

  static Future<void> createProfile(
      String id, List<Question> questions, String location) async {
    final questionString =
        questions.map((q) => '${q.question} ${q.answer}').join(';');
    await http.get(Uri.parse(
        '$url/create_user/$id/$questionString/$questionString/$location/'));
  }
}
