import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roommaite/models/profile.dart';
import 'package:roommaite/models/questions.dart';
import 'package:roommaite/pages/main_screen.dart';
import 'package:roommaite/providers/auth_provider.dart';
import 'package:roommaite/widgets/question_page.dart';

class FinishProfilePage extends StatefulWidget {
  const FinishProfilePage({super.key});

  @override
  State<FinishProfilePage> createState() => _FinishProfilePageState();
}

class _FinishProfilePageState extends State<FinishProfilePage> {
  final List<Question> unansweredQuestions = [];

  refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return FutureBuilder(
      future: Future.wait([
        authService.getProfile(),
        authService.getQuestions(),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final profile = snapshot.data?[0] as Profile;
        final questions = snapshot.data?[1] as List<Question>;

        unansweredQuestions.clear();
        for (final question in requiredQuestions) {
          if (!questions.any((q) => q.question == question.question)) {
            unansweredQuestions.add(question);
          }
        }

        bool needsLocation = false;

        if (profile.location == null) {
          needsLocation = true;
        }

        return QuestionAnswerer(
          profile: profile,
          unansweredQuestions: unansweredQuestions,
          authService: authService,
          parentState: this,
          needsLocation: needsLocation,
        );
      },
    );
  }
}

class QuestionAnswerer extends StatefulWidget {
  const QuestionAnswerer({
    super.key,
    required this.profile,
    required this.unansweredQuestions,
    required this.authService,
    required this.parentState,
    required this.needsLocation,
  });

  final Profile profile;
  final List<Question> unansweredQuestions;
  final AuthService authService;
  final _FinishProfilePageState parentState;
  final bool needsLocation;

  @override
  State<QuestionAnswerer> createState() => _QuestionAnswererState();
}

class _QuestionAnswererState extends State<QuestionAnswerer> {
  final Set<Question> markedQuestions = {};

  bool unansweredQuestionsExist() {
    if (widget.needsLocation && locationController.text.isEmpty) {
      return true;
    }

    for (final question in widget.unansweredQuestions) {
      if (question.answer == null) {
        return true;
      }
    }
    return false;
  }

  final TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finish Profile'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Welcome, ${widget.profile.name}!',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                'Please answer the following questions to complete your profile. Once you have answered all the questions, you will be able to find matches.',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          if (widget.needsLocation)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'Please provide your location to find matches near you.',
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Location',
            ),
            controller: locationController,
          ),
          for (final question in widget.unansweredQuestions)
            ListTile(
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
                      ],
                    ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                for (final question in widget.unansweredQuestions) {
                  bool shownMessage = false;
                  if (question.answer == null) {
                    if (!shownMessage) {
                      shownMessage = true;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Progress saved. Please answer all questions to finish profile.'),
                        ),
                      );
                    }
                  } else {
                    await widget.authService.answerQuestion(question);
                    markedQuestions.add(question);
                  }
                }

                if (widget.needsLocation &&
                    locationController.text.isNotEmpty) {
                  await widget.authService
                      .updateLocation(locationController.text);
                }

                widget.unansweredQuestions.removeWhere(
                    (question) => markedQuestions.contains(question));
                markedQuestions.clear();
                widget.parentState.refresh();

                if (!unansweredQuestionsExist()) {
                  await widget.authService.finishProfile();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                    );
                  }
                }
              },
              child: Text(unansweredQuestionsExist()
                  ? 'Save Progress'
                  : 'Finish Profile'),
            ),
          ),
        ],
      ),
    );
  }
}
