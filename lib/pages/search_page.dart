import 'package:flutter/material.dart';
import 'package:roommaite/widgets/question_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
      ),
      body: const Center(
        child: QuestionPage(edit: false)
      ),
    );
  }
}
