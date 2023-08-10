import 'package:flutter/material.dart';
import 'package:survey/colors.dart';

class RequestDialog extends StatelessWidget {
  final String title;
  final String? description;
  final String? bottomText;
  final Widget? bottomWidget;

  const RequestDialog({
    required this.title,
    this.description,
    this.bottomText,
    this.bottomWidget,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: ConfigConstants.fontDialogTitle,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 12,
          ),
          if (description != null)
            Text(
              description!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: ConfigConstants.fontDialogDescription,
                height: 1.3,
              ),
            ),
          if (description != null)
            const SizedBox(
              height: 24,
            ),
          if (bottomWidget != null) bottomWidget!,
          if (bottomText != null)
            Text(
              bottomText!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: ConfigConstants.fontDialogDescription,
                height: 1.8,
              ),
            ),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            16,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.fromLTRB(24, 15, 24, 24),
    );
  }
}
