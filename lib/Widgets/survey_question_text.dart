import 'package:flutter/material.dart';
import 'package:survey/colors.dart';

class SurveyQuestionText extends StatefulWidget {
  String title;
  dynamic handle;
  bool isReq;
  Color? textcolorsurvey;
  Color? requiredcolor;
  SurveyQuestionText(
      {required this.title,
      required this.handle,
      required this.isReq,
      this.requiredcolor,
      this.textcolorsurvey,
      super.key});

  @override
  State<SurveyQuestionText> createState() => _SurveyQuestionTextState();
}

class _SurveyQuestionTextState extends State<SurveyQuestionText> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      padding: const EdgeInsets.all(20),
      // margin: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        RichText(
          text: TextSpan(
              text: widget.title,
              style: TextStyle(
                color: widget.textcolorsurvey ?? ConfigConstants.black,
                fontWeight: FontWeight.w900,
              ),
              children: [
                TextSpan(
                  text: " ${widget.isReq ? "*" : ""}",
                  style: TextStyle(
                    color: widget.requiredcolor ?? ConfigConstants.red,
                    fontWeight: FontWeight.w900,
                  ),
                )
              ]),
        ),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            fillColor: Colors.white,
            border: UnderlineInputBorder(),
            hintText: "Type your answer here...",
            // icon:
          ),
          onChanged: (value) {
            widget.handle(value);
          },
        ),
      ]),
    );
  }
}
