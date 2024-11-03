import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

    return FutureBuilder<Profile?>(
      future: authService.getProfile(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return _ProfileInfo(profile: snapshot.data!);
      },
    );
  }
}

class _ProfileInfo extends StatefulWidget {
  final Profile profile;

  const _ProfileInfo({required this.profile});

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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ProfileAvatar(
                          profile: widget.profile,
                          radius: 40,
                          onClick: () {
                            // TODO: pop up a dialog to change profile picture
                          }),
                      const Spacer(),
                      _buildStatColumn('Matches', '0'),
                      const Spacer(),
                      _buildStatColumn('Opps', '3'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(widget.profile.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold))
                ],
              )),
          TabBar(
            dividerColor: Colors.transparent,
            controller: _tabController,
            tabs: const [
              Tab(
                // about this user's roommate habits
                icon: Icon(CupertinoIcons.person),
              ),
              Tab(
                // THEIR preferences for a roommate
                icon: Icon(CupertinoIcons.slider_horizontal_3),
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
                const Center(child: Text('Preferences')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String count) {
    return TextButton(
        onPressed: () {},
        child: Column(
          children: [
            Text(
              count,
              style: const TextStyle(fontSize: 16),
            ),
            Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 16))
          ],
        ));
  }
}
