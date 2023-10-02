import 'package:flutter/cupertino.dart';
import 'package:learningdart/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Do you want to delete?',
    optionBuilder: () => {
      'Cancel' : false,
      'Yes' : true,

    },
  ).then((value) => value ?? false);
}