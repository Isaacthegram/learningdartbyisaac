import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/main.dart';


class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
      actions: [
        PopupMenuButton<MenuAction>(
          onSelected: (value) async {
            switch (value) {

              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  await FirebaseAuth.instance.signOut(); 
                  Navigator.of(context).pushNamedAndRemoveUntil(loginRoute,
                          (_) => false);
                }
            break;

            }
          },
          itemBuilder: (context) {
            return const [
             PopupMenuItem<MenuAction>(
              value: MenuAction.logout,
              child: Text('Log out'),
    ),
            ];
          },
        )

      ],),
      body: const Text('Hello World'),
    );
  }
}
