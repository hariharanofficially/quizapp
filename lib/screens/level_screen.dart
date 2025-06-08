// import 'package:flutter/material.dart';
// import 'package:quizapp/auth_service.dart';
// import 'package:quizapp/screens/login_screen.dart';
// import 'quiz_screen.dart';

// class LevelScreen extends StatefulWidget {
//   @override
//   _LevelScreenState createState() => _LevelScreenState();
// }

// class _LevelScreenState extends State<LevelScreen> {
//   Set<int> completedLevels = {};

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Select Level"),
//         actions: [
//           IconButton(
//               icon: const Icon(Icons.logout),
//               tooltip: 'Logout',
//               onPressed: () => AuthService().signOut().then(
//                     (_) => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => LoginScreen(),
//                       ),
//                     ),
//                   ))
//         ],
//       ),
//       body: GridView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: 10,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2, childAspectRatio: 2),
//         itemBuilder: (_, index) {
//           final level = index + 1;
//           return ElevatedButton.icon(
//             onPressed: () async {
//               final completed = await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => QuizScreen(level: level),
//                 ),
//               );
//               if (completed == true) {
//                 setState(() {
//                   completedLevels.add(level);
//                 });
//               }

//               if (completedLevels.length == 10) {
//                 showDialog(
//                   context: context,
//                   builder: (_) => AlertDialog(
//                     title: Text("🎉 All Levels Completed"),
//                     content: Text("Restarting from Level 1"),
//                     actions: [
//                       TextButton(
//                         onPressed: () {
//                           setState(() => completedLevels.clear());
//                           Navigator.pop(context);
//                         },
//                         child: Text("OK"),
//                       )
//                     ],
//                   ),
//                 );
//               }
//             },
//             icon: completedLevels.contains(level)
//                 ? Icon(Icons.check_circle, color: Colors.green)
//                 : Icon(Icons.lock_open),
//             label: Text("Level $level"),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:quizapp/auth_service.dart';
import 'package:quizapp/screens/login_screen.dart';
import 'quiz_screen.dart';

class LevelScreen extends StatefulWidget {
  @override
  _LevelScreenState createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  Set<int> completedLevels = {};

  void _showMustCompletePreviousLevelMessage(int level) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please complete Level ${level - 1} first!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Level"),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () => AuthService().signOut().then(
                    (_) => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginScreen(),
                      ),
                    ),
                  ))
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 10,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 2),
        itemBuilder: (_, index) {
          final level = index + 1;

          // Check if user can access this level:
          final canAccess = level == 1 || completedLevels.contains(level - 1);

          return ElevatedButton.icon(
            onPressed: canAccess
                ? () async {
                    final completed = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizScreen(level: level),
                      ),
                    );
                    if (completed == true) {
                      setState(() {
                        completedLevels.add(level);
                      });
                    }

                    if (completedLevels.length == 10) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text("🎉 All Levels Completed"),
                          content: Text("Restarting from Level 1"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() => completedLevels.clear());
                                Navigator.pop(context);
                              },
                              child: Text("OK"),
                            )
                          ],
                        ),
                      );
                    }
                  }
                : () {
                    // Show message if previous level not completed
                    _showMustCompletePreviousLevelMessage(level);
                  },
            icon: completedLevels.contains(level)
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(canAccess ? Icons.lock_open : Icons.lock),
            label: Text("Level $level"),
            style: ElevatedButton.styleFrom(
              backgroundColor: canAccess ? null : Colors.grey, // Disabled look
            ),
          );
        },
      ),
    );
  }
}
