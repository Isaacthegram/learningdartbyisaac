import 'package:flutter/cupertino.dart';
import 'package:learningdart/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Sharing',
      content: 'You cannot share an empty note!',
      optionBuilder: () => {
        'Ok' : null,
      }
      );
}
