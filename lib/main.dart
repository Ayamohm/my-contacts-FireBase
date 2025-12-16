import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_contacts_fire/fire_base_msg_config.dart';
import 'package:my_contacts_fire/firebase_options.dart' show DefaultFirebaseOptions;

import 'features/contacts/presentation/bloc/contacts_bloc.dart';
import 'features/contacts/presentation/pages/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FireBaseMsgConfig().configure();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ContactsBloc()..add(LoadContactsEvent()),
        child: MaterialApp(
            title: 'Contacts App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            debugShowCheckedModeBanner: false,
            home: HomeScreen()
        )
        );

  }
}
