import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:roommaite/pages/main_screen.dart';
import 'package:roommaite/providers/auth_provider.dart';
import 'package:roommaite/util/constants.dart';
import 'package:roommaite/util/snackbar.dart';
import 'package:roommaite/util/widgets.dart';

enum LoginDialogType { title, description, toggleText }

String getLoginDialogText(LoginDialogType type, bool isSignUp) {
  switch (type) {
    case LoginDialogType.title:
      return isSignUp ? 'Sign Up' : 'Sign In';
    case LoginDialogType.description:
      return isSignUp
          ? 'Create a ${App.title} account'
          : 'Welcome back to ${App.title}';
    case LoginDialogType.toggleText:
      return isSignUp
          ? 'Already have an account? Sign In'
          : 'Don\'t have an account? Sign Up';
  }
}

class SignInPage extends StatelessWidget {
  final bool isSignUp;

  const SignInPage({super.key, this.isSignUp = false});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    final buttons = {
      'Google': (
        () async {
          final error = await authService.signInWithGoogle();

          if (!context.mounted) return;

          if (error != null) {
            context.showSnackBar(error, isError: true);
            return;
          }

          // context.pushReplacement(const HomePage());
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
          );
        },
        const FaIcon(FontAwesomeIcons.google)
      ),
      'Email': (
        () {
          // context.push(
          //   EmailAuthPage(isSignUp: isSignUp),
          // );
          // TODO
        },
        const FaIcon(FontAwesomeIcons.solidUser)
      ),
    };

    final longestName =
        buttons.keys.reduce((a, b) => a.length > b.length ? a : b);

    return Scaffold(
      appBar: AppBar(
        title: Text(getLoginDialogText(LoginDialogType.title, isSignUp)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              getLoginDialogText(LoginDialogType.description, isSignUp),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              App.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            ...buttons.entries.map((entry) {
              final padding = ' ' * (longestName.length - entry.key.length);
              final name = entry.key;
              final onPressed = entry.value.$1;
              final icon = entry.value.$2;

              return Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                      onPressed: onPressed,
                      icon: icon,
                      label: Text(
                          '$padding${getLoginDialogText(LoginDialogType.title, isSignUp)} with $name'),
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              );
            }),
            TextButton(
              onPressed: () {
                // context.push(
                //   SignInPage(isSignUp: !isSignUp),
                // );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SignInPage(isSignUp: !isSignUp),
                  ),
                );
              },
              child: Text(
                getLoginDialogText(LoginDialogType.toggleText, isSignUp),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('By signing up, you agree to our '),
                TextButton(
                    onPressed: () {
                      // TODO: Implement Terms of Service page
                      // context.push(const TermsPage());
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                    ),
                    child: const Text('Terms of Service')),
              ],
            ),
            Widgets.createBottomPadding(context),
          ],
        ),
      ),
    );
  }
}
