import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roommaite/models/profile.dart';
import 'package:roommaite/providers/auth_provider.dart';
import 'package:roommaite/util/theme.dart';
import 'package:roommaite/util/vector_data_helper.dart';
import 'package:roommaite/widgets/profile_avatar.dart';
import 'package:roommaite/widgets/question_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Profile>? matches;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() {
    final authService = Provider.of<AuthService>(context, listen: false);
    IrisVectorDataHelper.getMatches(authService).then((value) {
      matches = value;
      filterMatches();
    });
  }

  void filterMatches() async {
    final prefs = await SharedPreferences.getInstance();
    List<Profile> matchesCopy = List.from(matches!);

    for (var match in matches!) {
      if (mounted) {
        final auth = Provider.of<AuthService>(context, listen: false);
        if (match.id == auth.userId) {
          matchesCopy.remove(match);
          continue;
        }
      }

      final matchPrefsKey = 'match_${match.id}';
      final matchPrefsValue = prefs.getBool(matchPrefsKey);

      if (matchPrefsValue == null) {
        continue;
      }

      if (matchPrefsValue) {
        matchesCopy.remove(match);
      }
    }

    setState(() {
      matches = matchesCopy;
    });
  }

  void addMatchToPrefs(Profile match) async {
    final prefs = await SharedPreferences.getInstance();
    final matchPrefsKey = 'match_${match.id}';
    prefs.setBool(matchPrefsKey, true);
  }

  void _handleApprove(Profile match) {
    // Handle approve logic here
    addMatchToPrefs(match);
    setState(() {
      matches?.remove(match);
    });
  }

  void _handleDeny(Profile match) {
    // Handle deny logic here
    addMatchToPrefs(match);
    setState(() {
      matches?.remove(match);
    });
  }

  Future<void> _removeMatchesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getKeys().forEach((key) {
      if (key.startsWith('match_')) {
        prefs.remove(key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
      ),
      body: Center(
        child: matches == null
            ? const CircularProgressIndicator()
            : matches!.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No more profiles to review'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                          onPressed: () async {
                            await _removeMatchesFromPrefs();
                            setState(() {
                              refresh();
                            });
                          },
                          child: const Text('Review seen profiles')),
                    ],
                  )
                : Stack(
                    children: matches!.map((match) {
                      return Card(
                        color: AppColors.darkPurple,
                        margin: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  ProfileAvatar(profile: match, radius: 40),
                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        match.name,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      subtitle: Text(
                                        match.location ?? 'No location',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child:
                                    QuestionPage(edit: false, profile: match)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  color: Colors.red,
                                  onPressed: () => _handleDeny(match),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.check),
                                  color: Colors.green,
                                  onPressed: () => _handleApprove(match),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
      ),
    );
  }
}
