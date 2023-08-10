import 'package:flutter/material.dart';
import 'package:survey/widgets/colors.dart';
class SurveyQuestionRadio extends StatefulWidget {
  dynamic question;
  List<dynamic> options;
  dynamic answer;
  bool isReq;
  dynamic handle;
  Color? textcolorsurvey;
  Color? requiredcolor;
  SurveyQuestionRadio(
      {required this.question,
      required this.options,
      required this.answer,
      required this.isReq,
      required this.handle,
      this.requiredcolor,
      this.textcolorsurvey,
      super.key});

  @override
  State<SurveyQuestionRadio> createState() => _SurveyQuestionRadioState();
}

class _SurveyQuestionRadioState extends State<SurveyQuestionRadio> {
  @override
  Widget build(BuildContext context) {
    List<Widget> list = [
      RichText(
        text: TextSpan(
            text: widget.question,
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
    ];
    for (int i = 0; i < widget.options.length; i++) {
      list.add(ListTile(
        title: Text(widget.options[i]['answer'].toString()),
        leading: Radio<String>(
          activeColor: ConfigConstants.gradient1,
          value: widget.options[i]['answer'],
          groupValue: widget.answer,
          onChanged: (String? value) {
            setState(() {
              widget.answer = value;
              widget.handle(value);
            });
          },
        ),
      ));
    }
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      padding: const EdgeInsets.all(20),
      // margin: const EdgeInsets.all(20),
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: list),
    );
  }
}
