import 'package:flutter/material.dart';
import 'package:survey/colors.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? loadingIndicatorColor;

  /// Returns a ```CircularProgressIndicator``` centered inside its parent widget.
  const LoadingIndicator({
    Key? key,
    this.loadingIndicatorColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: loadingIndicatorColor ?? ConfigConstants.purpleDark,
        strokeWidth: 2.0,
      ),
    );
  }
}
