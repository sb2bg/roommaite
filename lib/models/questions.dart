abstract class Question<T> {
  final String _question;
  T? answer;

  Question(this._question, [this.answer]);

  String get question => _question;

  Map<String, String?> toMap();

  static Question fromMap(Map<String, dynamic> map) {
    if (map['answer'] is String && map['answer'] != null) {
      if (map['answer'] == 'Yes' || map['answer'] == 'No') {
        return YesNoQuestion(map['question'], map['answer'] == 'Yes');
      } else {
        return OpenEndedQuestion(map['question'], map['answer']);
      }
    } else {
      return OpenEndedQuestion(map['question']);
    }
  }
}

class YesNoQuestion extends Question<bool> {
  YesNoQuestion(super.question, [super.answer]);

  @override
  Map<String, String?> toMap() {
    return {
      'question': question,
      'answer': answer == null
          ? null
          : answer == true
              ? 'Yes'
              : 'No',
    };
  }
}

class OpenEndedQuestion extends Question<String> {
  OpenEndedQuestion(super.question, [super.answer]);

  @override
  Map<String, String?> toMap() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}
