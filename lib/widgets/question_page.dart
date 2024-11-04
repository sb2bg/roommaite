import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roommaite/models/profile.dart';
import 'package:roommaite/models/questions.dart';
import 'package:roommaite/providers/auth_provider.dart';
import 'package:roommaite/util/theme.dart';

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

class EditableQuestions extends StatefulWidget {
  const EditableQuestions({super.key, required this.profile});

  final Profile profile;

  @override
  State<EditableQuestions> createState() => _EditableQuestionsState();
}

class _EditableQuestionsState extends State<EditableQuestions> {
  bool waiting = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<AuthService>(context, listen: false).getQuestions(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final questions = snapshot.data!;

        return ListView.separated(
          itemCount: questions.length,
          separatorBuilder: (context, index) =>
              const Divider(color: AppColors.purple),
          itemBuilder: (context, index) {
            final question = questions[index];
            final controller = question is OpenEndedQuestion
                ? TextEditingController(text: question.answer.toString())
                : null;

            return ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(question.question),
                ),
                subtitle: question is OpenEndedQuestion
                    ? Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Answer',
                              ),
                              controller: controller,
                              onChanged: (value) {
                                question.answer = value;
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.save),
                            onPressed: waiting
                                ? null
                                : () async {
                                    question.answer = controller!.text;
                                    setState(() {
                                      waiting = true;
                                    });
                                    await Provider.of<AuthService>(context,
                                            listen: false)
                                        .answerQuestion(question);
                                    setState(() {
                                      waiting = false;
                                    });
                                  },
                          )
                        ],
                      )
                    : Row(
                        children: [
                          const Text('Yes'),
                          Radio(
                            value: true,
                            groupValue: question.answer,
                            onChanged: (value) {
                              setState(() {
                                question.answer = value as bool;
                              });
                            },
                          ),
                          const Text('No'),
                          Radio(
                            value: false,
                            groupValue: question.answer,
                            onChanged: (value) {
                              setState(() {
                                question.answer = value as bool;
                              });
                            },
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.save),
                            onPressed: waiting
                                ? null
                                : () async {
                                    setState(() {
                                      waiting = true;
                                    });
                                    await Provider.of<AuthService>(context,
                                            listen: false)
                                        .answerQuestion(question);
                                    setState(() {
                                      waiting = false;
                                    });
                                  },
                          ),
                        ],
                      ));
          },
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
    final authService = Provider.of<AuthService>(context, listen: false);

    return FutureBuilder<List<Question>>(
      future: authService.getQuestionsFrom(profile),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final questions = snapshot.data!;

        return ListView.separated(
          itemCount: questions.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final question = questions[index];

            return ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(question.question),
              ),
              subtitle: question is OpenEndedQuestion
                  ? Text('${question.answer}')
                  : Text(question is YesNoQuestion
                      ? question.answer != null
                          ? question.answer!
                              ? 'Yes'
                              : 'No'
                          : 'Unknown'
                      : 'Unknown'),
            );
          },
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
