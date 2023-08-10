import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:survey/widgets/colors.dart';

class SurveyQuestionRating extends StatefulWidget {
  String title;
  dynamic handle;
  bool isReq;
  Color? textcolorsurvey;
  Color? requiredcolor;
  SurveyQuestionRating(
      {required this.title,
      required this.handle,
      required this.isReq,
      this.requiredcolor,
      this.textcolorsurvey,
      super.key});

  @override
  State<SurveyQuestionRating> createState() => _SurveyQuestionRatingState();
}

class _SurveyQuestionRatingState extends State<SurveyQuestionRating> {
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
        Center(
          child: RatingBar.builder(
            initialRating: 0,
            minRating: 0,
            direction: Axis.horizontal,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              widget.handle(rating);
            },
          ),
        )
      ]),
    );
  }
}
