import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roommaite/providers/auth_provider.dart';
import 'package:roommaite/widgets/profile_avatar.dart';

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
                      title: Text(match.name),
                      subtitle: Text(match.location ?? 'No location'),
                      leading: ProfileAvatar(profile: match, radius: 25),
                    );
                  },
                ),
        );
      },
    );
  }
}
