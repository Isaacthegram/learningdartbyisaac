import 'package:flutter/cupertino.dart';
import 'package:learningdart/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordRestSentDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Password reset',
      content: 'We have now sent your reset link. Check your email.',
      optionBuilder: () => {
        'Ok' : null,
      },
  );
}