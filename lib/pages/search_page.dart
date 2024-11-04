import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roommaite/models/profile.dart';
import 'package:roommaite/providers/auth_provider.dart';
import 'package:roommaite/util/theme.dart';
import 'package:roommaite/util/vector_data_helper.dart';
import 'package:roommaite/util/widgets.dart';
import 'package:roommaite/widgets/profile_avatar.dart';
import 'package:roommaite/widgets/question_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Profile>? _matches;
  bool _loading = false;
  bool _loadingCheck = false;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() {
    setState(() {
      _loading = true;
    });
    final authService = Provider.of<AuthService>(context, listen: false);
    IrisVectorDataHelper.getMatches(authService).then((value) {
      _matches = value;
      filterMatches();
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
  }

  void filterMatches() async {
    final prefs = await SharedPreferences.getInstance();
    List<Profile> matchesCopy = List.from(_matches!);
    if (mounted) {
      List<Profile> matchesToRemove =
          await Provider.of<AuthService>(context, listen: false).getMatches();

      for (var match in _matches!) {
        if (mounted) {
          final auth = Provider.of<AuthService>(context, listen: false);
          if (match.id == auth.userId) {
            matchesCopy.remove(match);
            continue;
          }

          if (matchesToRemove.any((element) => element.id == match.id)) {
            matchesCopy.remove(match);
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

      if (mounted) {
        _matches = matchesCopy;
      }
    }
  }

  void addMatchToPrefs(Profile match) async {
    final prefs = await SharedPreferences.getInstance();
    final matchPrefsKey = 'match_${match.id}';
    prefs.setBool(matchPrefsKey, true);
  }

  void _handleApprove(Profile match) async {
    setState(() {
      _loadingCheck = true;
    });
    // Handle approve logic here
    final authService = Provider.of<AuthService>(context, listen: false);

    if (await authService.addMatch(match)) {
      // show popup!
      final modal = Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding inside the dialog
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Roommates?', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 16),
              Text('You have matched with ${match.name}.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      );

      if (mounted) {
        await showDialog(context: context, builder: (context) => modal);
      }
    }
    addMatchToPrefs(match);
    if (mounted) {
      setState(() {
        _matches?.remove(match);
        _loadingCheck = false;
      });
    }
  }

  void _handleDeny(Profile match) {
    // Handle deny logic here
    addMatchToPrefs(match);
    setState(() {
      _matches?.remove(match);
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
        title: const Text('Find Roommates'),
      ),
      body: _loading
          ? Widgets.preloader
          : Center(
              child: _matches == null
                  ? const CircularProgressIndicator()
                  : _matches!.isEmpty
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
                          children: _matches!.map((match) {
                            return Card(
                              color: AppColors.darkPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(color: AppColors.purple),
                              ),
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        ProfileAvatar(
                                            profile: match, radius: 40),
                                        Expanded(
                                          child: ListTile(
                                            title: Text(
                                              match.name,
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                            subtitle: Text(
                                              match.location ?? 'No location',
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: QuestionPage(
                                          edit: false, profile: match)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        color: Colors.red,
                                        onPressed: () => _handleDeny(match),
                                      ),
                                      IconButton(
                                        icon: _loadingCheck
                                            ? const CircularProgressIndicator()
                                            : const Icon(Icons.check),
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
