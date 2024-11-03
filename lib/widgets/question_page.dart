import 'package:flutter/material.dart';
import 'package:roommaite/models/profile.dart';
import 'package:roommaite/models/questions.dart';
import 'package:roommaite/widgets/profile_avatar.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key, required this.edit, required this.profile});

  final bool edit;
  final Profile profile;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: widget.edit
              ? EditableQuestions(profile: widget.profile)
              : NonEditableQuestions(profile: widget.profile)),
    );
  }
}

class EditableQuestions extends StatelessWidget {
  const EditableQuestions({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: requiredQuestions.length + optionalQuestions.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final question = index < requiredQuestions.length
            ? requiredQuestions[index]
            : optionalQuestions[index - requiredQuestions.length];

        return ListTile(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(question.question),
          ),
          subtitle: question is OpenEndedQuestion
              ? TextField(
                  decoration: const InputDecoration(
                    hintText: 'Answer',
                  ),
                  onChanged: (value) {
                    question.answer = value;
                  },
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
  const NonEditableQuestions({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: requiredQuestions.length + optionalQuestions.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final question = index < requiredQuestions.length
            ? requiredQuestions[index]
            : optionalQuestions[index - requiredQuestions.length];

        return ListTile(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(question.question),
          ),
          subtitle: question is OpenEndedQuestion
              ? Text('${question.answer}')
              : Text(question is YesNoQuestion
                  ? question.answer != null
                      ? 'Yes'
                      : 'No'
                  : 'Unknown'),
          trailing: ProfileAvatar(profile: profile),
        );
      },
    );
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

final List<Question<dynamic>> optionalQuestions = [
  OpenEndedQuestion('What is your budget?'),
  OpenEndedQuestion('What is your preferred move-in date?'),
  OpenEndedQuestion('What is your preferred lease length?'),
  OpenEndedQuestion('What is your preferred neighborhood?'),
];
