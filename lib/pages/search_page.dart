import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roommaite/models/profile.dart';
import 'package:roommaite/providers/auth_provider.dart';
import 'package:roommaite/util/vector_data_helper.dart';
import 'package:roommaite/widgets/question_page.dart';

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
    final authService = Provider.of<AuthService>(context, listen: false);
    IrisVectorDataHelper.getMatches(authService).then((value) {
      setState(() {
        matches = value;
      });
    });
  }

  void _handleApprove(Profile match) {
    // Handle approve logic here
    setState(() {
      matches?.remove(match);
    });
  }

  void _handleDeny(Profile match) {
    // Handle deny logic here
    setState(() {
      matches?.remove(match);
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
                ? const Text('No more matches!')
                : Stack(
                    children: matches!.map((match) {
                      return Card(
                        margin: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text(match.name),
                              subtitle: Text(match.location ?? 'No Location'),
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
