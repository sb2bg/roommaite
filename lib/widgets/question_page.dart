import 'package:flutter/material.dart';
import 'package:roommaite/models/questions.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key, required this.edit});

  final bool edit;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: widget.edit ? EditableQuestions() : NonEditableQuestions()),
    );
  }
}

class EditableQuestions extends StatelessWidget {
  const EditableQuestions({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: requiredQuestions.length + _optionalQuestions.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final question = index < requiredQuestions.length
            ? requiredQuestions[index]
            : _optionalQuestions[index - requiredQuestions.length];

        return ListTile(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(question.question),
          ),
          subtitle: question is OpenEndedQuestion
              ? const TextField(
                  decoration: InputDecoration(
                    hintText: 'Answer',
                  ),
                )
              : const Row(
                  children: [
                    Text('Yes'),
                    Radio(
                      value: true,
                      groupValue: null,
                      onChanged: null,
                    ),
                    Text('No'),
                    Radio(
                      value: false,
                      groupValue: null,
                      onChanged: null,
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class NonEditableQuestions extends StatelessWidget {
  const NonEditableQuestions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// null means open ended question
final List<Question<dynamic>> requiredQuestions = [
  OpenEndedQuestion('What is your age?'),
  OpenEndedQuestion('What is your education level?'),
  OpenEndedQuestion('What is your occupation?'),
  OpenEndedQuestion('What is your major?'),
  OpenEndedQuestion('What is your level of cleanliness?'),
  OpenEndedQuestion('What is your level of noise tolerance?'),
  OpenEndedQuestion('What time do you usually go to bed?'),
  OpenEndedQuestion('What time do you usually wake up?'),
  YesNoQuestion('Do you smoke?'),
  YesNoQuestion('Do you drink?'),
  YesNoQuestion('Do you have any pets?'),
  YesNoQuestion('Do you have any dietary restrictions?'),
  OpenEndedQuestion('What is your preferred number of roommates?'),
];

final List<Question<dynamic>> _optionalQuestions = [
  OpenEndedQuestion('What is your budget?'),
  OpenEndedQuestion('What is your preferred move-in date?'),
  OpenEndedQuestion('What is your preferred lease length?'),
  OpenEndedQuestion('What is your preferred neighborhood?'),
];
