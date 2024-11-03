import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Page'),
      ),
      body: Center(
        child: Text('Question Page'),
      ),
    );
  }
}

const List<String> yesNo = ['Yes', 'No'];

// null means open ended question
const Map<String, List<String>?> requiredQuestions = {
  'What is your age?': null,
  'What is your education level?': [
    'High school',
    'Undergraduate',
    'Graduate',
    'Doctorate',
    'No preference'
  ],
  'What is your major?': null,
  'What is your occupation?': null,
  'What is your level of cleanliness?': [
    'Messy',
    'Moderate',
    'Clean',
    'No preference'
  ],
  'What time do you usually go to bed?': null,
  'What time do you usually wake up?': null,
  'Do you have any pets?': yesNo,
  'Do you smoke?': yesNo,
  'Do you drink?': yesNo,
  'Do you have any allergies?': yesNo,
  'Do you have any dietary restrictions? If so, please specify.':
      null, // important for matching? probably not
};

const Map<String, List<String>?> optionalQuestions = {
  'What is your favorite color?': null,
  'What is your favorite food?': null,
  'What is your favorite movie?': null,
  'What is your favorite book?': null,
  'What is your favorite song?': null,
  'What is your favorite animal?': null,
  'What is your favorite hobby?': null,
  'What is your favorite sport?': null,
};
