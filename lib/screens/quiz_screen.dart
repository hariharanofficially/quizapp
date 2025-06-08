import 'package:flutter/material.dart';

import 'kyc_questions.dart';

class QuizScreen extends StatefulWidget {
  final int level;
  QuizScreen({required this.level});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  List<Map<String, dynamic>> questions = [];
  bool answered = false;
  int? selectedOption;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  void loadQuestions() {
    questions = kycQuestionsByLevel[widget.level] ?? [];
  }

  void nextQuestion() {
    setState(() {
      currentQuestionIndex++;
      answered = false;
      selectedOption = null;
    });
  }

  void checkAnswer(int index) {
    setState(() {
      selectedOption = index;
      answered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];
    final correctAnswerText = question['options'][question['answerIndex']];

    return Scaffold(
      appBar: AppBar(title: Text("Level ${widget.level}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Text(question['question'], style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              ...List.generate(question['options'].length, (index) {
                final isCorrect = index == question['answerIndex'];
                final isSelected = index == selectedOption;

                Color? color;
                if (answered) {
                  if (isSelected) {
                    color = isCorrect
                        ? Colors.green
                        : Colors
                            .red; // Selected option: green if correct, else red
                  } else if (isCorrect) {
                    // Highlight the correct answer, even if not selected, with lighter green
                    color = Colors.green.withOpacity(0.5);
                  } else {
                    color = Colors.blue; // Normal color for other options
                  }
                } else {
                  // Before answer, all options have the default color
                  color = Colors.blue;
                }

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: color ?? Colors.blue),
                    // onPressed: answered ? null : () => checkAnswer(index),
                    onPressed: () {
                      if (!answered) {
                        checkAnswer(index);
                      }
                    },
                    child: Text(question['options'][index]),
                  ),
                );
              }),
              // Show the correct answer text **only after answering**
              if (answered) ...[
                SizedBox(height: 20),
                Text(
                  "Correct Answer: $correctAnswerText",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
              Spacer(),
              ElevatedButton(
                onPressed: answered
                    ? () {
                        if (currentQuestionIndex == 9) {
                          Navigator.pop(context, true); // Mark level complete
                        } else {
                          nextQuestion();
                        }
                      }
                    : null,
                child: Text(currentQuestionIndex == 9 ? "Finish" : "Next"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
