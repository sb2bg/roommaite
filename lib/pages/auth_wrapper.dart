import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roommaite/models/profile.dart';
import 'package:roommaite/pages/finish_profile_page.dart';
import 'package:roommaite/pages/main_screen.dart';
import 'package:roommaite/pages/sign_in_page.dart';
import 'package:roommaite/providers/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return StreamBuilder<AuthState>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // authService.signOut();
        if (!snapshot.hasData || snapshot.data!.session?.user == null) {
          return const SignInPage();
        }

        return FutureBuilder<Profile?>(
          future: authService.getProfile(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.data!.location == null) {
              return const FinishProfilePage();
            }

            return const MainScreen();
          },
        );
      },
    );
  }
}
