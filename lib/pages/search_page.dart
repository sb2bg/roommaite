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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
      ),
      body: const Center(child: QuestionPage(edit: false)),
    );
  }
}
