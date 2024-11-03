import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roommaite/providers/auth_provider.dart';
import 'package:roommaite/widgets/profile_avatar.dart';
import 'package:roommaite/widgets/question_page.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return FutureBuilder(
      future: authService.getMatches(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final matches = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Matches'),
          ),
          body: matches.isEmpty
              ? const Center(
                  child: Text('No matches yet! Check back later!'),
                )
              : ListView.builder(
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final match = matches[index];
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: Text(match.name),
                              actions: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    authService.removeMatch(match);
                                    Navigator.of(context).pop();
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                            body: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child:
                                      ProfileAvatar(profile: match, radius: 70),
                                ),
                                Expanded(
                                  child: QuestionPage(
                                    edit: false,
                                    profile: match,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                      },
                      title: Text(match.name),
                      subtitle: Text(match.location ?? 'No location'),
                      leading: ProfileAvatar(profile: match, radius: 25),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          authService.removeMatch(match);
                          setState(() {});
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
