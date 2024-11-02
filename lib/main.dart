import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roommaite/pages/auth_wrapper.dart';
import 'package:roommaite/providers/auth_provider.dart';
import 'package:roommaite/util/constants.dart';
import 'package:roommaite/util/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseKey,
  );

  runApp(const RoommaiteApp());
}

class RoommaiteApp extends StatefulWidget {
  const RoommaiteApp({super.key});

  @override
  State<RoommaiteApp> createState() => _RoommaiteAppState();
}

class _RoommaiteAppState extends State<RoommaiteApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: App.title,
        debugShowCheckedModeBanner: false,
        theme: dark,
        home: const AuthenticationWrapper(),
      ),
    );
  }
}
