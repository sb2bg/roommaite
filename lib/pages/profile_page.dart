import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roommaite/pages/matches_page.dart';
import 'package:roommaite/widgets/question_page.dart';

import 'package:provider/provider.dart';
import 'package:roommaite/models/profile.dart';
import 'package:roommaite/providers/auth_provider.dart';
import 'package:roommaite/widgets/profile_avatar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return FutureBuilder(
      future: Future.wait([authService.getProfile(), authService.getMatches()]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final profile = snapshot.data![0] as Profile;

        return _ProfileInfo(
            profile: profile, matches: snapshot.data![1] as List<Profile>);
      },
    );
  }
}

class _ProfileInfo extends StatefulWidget {
  final Profile profile;
  final List<Profile> matches;

  const _ProfileInfo({required this.profile, required this.matches});

  @override
  State<_ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<_ProfileInfo>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profile.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ProfileAvatar(
                          profile: widget.profile,
                          radius: 40,
                          onClick: () {
                            // TODO: pop up a dialog to change profile picture
                          }),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          Text(' ${widget.profile.name}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          _buildStatColumn(
                              'Matches', widget.matches.length.toString()),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              )),
          TabBar(
            dividerColor: Colors.transparent,
            controller: _tabController,
            tabs: const [
              Tab(
                // about this user's habits
                icon: Icon(CupertinoIcons.person),
              ),
              Tab(
                // our matches
                icon: Icon(CupertinoIcons.heart),
              )
            ],
          ),
          const Divider(),
          Expanded(
            // Make sure TabBarView is flexible to fit the remaining space
            child: TabBarView(
              controller: _tabController,
              children: [
                // Replace with your actual widgets or pages
                QuestionPage(edit: true, profile: widget.profile),
                const MatchesPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String count) {
    return Row(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16))
      ],
    );
  }
}
