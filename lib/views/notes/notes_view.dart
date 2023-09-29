import 'package:flutter/material.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/main.dart';
import 'package:learningdart/services/crud/notes_service.dart';
import '../../enums/menu_action.dart';
import '../../services/auth/auth_service.dart';


class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();

    super.initState();
  }

  @override
  void dispose() {

    _notesService.close();

    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your notes'),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(newNoteRoute);
            },
            icon: const Icon(Icons.add)),
        PopupMenuButton<MenuAction>(
          onSelected: (value) async {
            switch (value) {

              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  await AuthService.firebase().logout();
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
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(
            email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {

             case ConnectionState.done:
               return StreamBuilder(
                   stream: _notesService.allNotes,
                   builder: (context, snapshot) {
                     switch (snapshot.connectionState) {

                       case ConnectionState.waiting:
                       case ConnectionState.active:
                         // implicit fallthrough
                       return const Text('Waiting for your notes...');
                        default:
                         return const CircularProgressIndicator();
                     }
                   });

            default:
              return const CircularProgressIndicator();
          }
        },

      )
    );
  }
}
