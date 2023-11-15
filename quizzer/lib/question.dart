class Question {
  final String question, optionA, optionB, optionC, optionD, answer;

  Question({
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.answer,
  });

  Question.nullQuestion()
      : question = "Question",
        optionA = "Option A",
        optionB = "Option B",
        optionC = "Option C",
        optionD = "Option D",
        answer = "Answer";
}
