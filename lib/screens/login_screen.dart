// import 'package:flutter/material.dart';
// import '../auth_service.dart';
// import 'level_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final AuthService _authService = AuthService();
//   @override
//   void initState() {
//     super.initState();
//     _checkIfAlreadyLoggedIn();
//   }

//   void _checkIfAlreadyLoggedIn() async {
//     bool loggedIn = await _authService.isLoggedIn();
//     if (loggedIn) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => LevelScreen()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton.icon(
//           icon: Icon(Icons.login),
//           label: Text("Login with Google"),
//           onPressed: () async {
//             final user = await _authService.signInWithGoogle();
//             if (user != null) {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => LevelScreen()),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../auth_service.dart';
import 'level_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyLoggedIn();
  }

  Future<void> _checkIfAlreadyLoggedIn() async {
    setState(() => _isLoading = true);
    bool loggedIn = await _authService.isLoggedIn();
    setState(() => _isLoading = false);

    if (loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LevelScreen()),
      );
    }
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      final success = await _authService.signInWithGoogle();
      setState(() => _isLoading = false);

      if (success != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LevelScreen()),
        );
      } else {
        _showError("Login failed. Please try again.");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError("An error occurred. Please try again.");
    }
  }

  void _showError(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome to KYC Quiz',
                      style: theme.textTheme.headline5?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Please login with your Google account to continue',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.login,
                        size: 24,
                        color: Colors.white,
                      ),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          "Login with Google",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                      ),
                      onPressed: _handleLogin,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
