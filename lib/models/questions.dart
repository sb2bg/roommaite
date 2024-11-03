abstract class Question<T> {
  final String _question;
  final T? _answer;

  Question(this._question, [this._answer]);

  String get question => _question;
  T? get answer => _answer;

  void toMap();
}

class YesNoQuestion extends Question<bool> {
  YesNoQuestion(super.question, [super.answer]);

  @override
  Map<String, bool?> toMap() {
    return {
      question: answer,
    };
  }
}

class OpenEndedQuestion extends Question<String> {
  OpenEndedQuestion(super.question, [super.answer]);

  @override
  Map<String, String?> toMap() {
    return {
      question: answer,
    };
  }
}
