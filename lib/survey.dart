import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey/blocs/post_survey_bloc/post_survey_bloc.dart';
import 'package:survey/blocs/post_survey_bloc2/post_survey_bloc2.dart';
import 'package:survey/blocs/survey_bloc/survey_bloc.dart';
import 'package:survey/widgets/loading_indication.dart';
import 'package:survey/widgets/survey_question_radio.dart';
import 'package:survey/widgets/survey_question_rating.dart';
import 'package:survey/widgets/survey_question_text.dart';
import 'package:survey/widgets/button.dart';
import 'package:survey/widgets/colors.dart';
import 'package:survey/widgets/dialog.dart';
import 'package:survey/widgets/survey_model.dart';
import 'package:survey/widgets/toast.dart';

class SurveyPage extends StatefulWidget {
  final String? scrg;
  final String? rbrg;
  final Decoration? decoration;
  final Color? backArrowColor;
  final Color? submitButtonDisabledColor;
  final Color? submitButtonenabledColor;
  final Color? submitButtonTextColor;
  final EdgeInsets? paddingGeneral;
  final int? submitButtonTextSize;
  final Color? radioActiveColor;
  final Color? radioTextcoLOR;
  final String? uuid;
  final Color? requiredStarColor;
  final VoidCallback? goBackOnSubmit;
  final Color? loadingIndicatorColor;
  final bool isRtl;

  const SurveyPage({
    this.scrg,
    this.backArrowColor,
    this.decoration,
    this.rbrg,
    this.submitButtonDisabledColor,
    this.submitButtonTextColor,
    this.submitButtonenabledColor,
    this.isRtl = true,
    this.paddingGeneral,
    this.goBackOnSubmit,
    this.submitButtonTextSize,
    this.radioActiveColor,
    this.radioTextcoLOR,
    this.requiredStarColor,
    this.loadingIndicatorColor,
    this.uuid,
    super.key,
  });

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  var answers = {};
  ValueNotifier<bool> submitActive = ValueNotifier(false);
  dynamic body;
  Map<String, dynamic> postBody = {};
  @override
  void initState() {
    BlocProvider.of<SurveyBloc>(context)
        .add(SurveyEventRequested(scrg: widget.scrg));
    super.initState();
  }

  var validation = [];
  var valTF = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration:
            widget.decoration ?? ConfigConstants.loginGradientBackground,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                iconSize: 24,
                color: widget.backArrowColor ?? ConfigConstants.white,
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              BlocConsumer<SurveyBloc, SurveyState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is SurveyInProgress) {
                    return const LoadingIndicator();
                  } else if (state is SurveyFailed ||
                      (state is SurveySuccess &&
                          !(state.data != null &&
                              state.data['survey'] != null))) {
                    const Center(child: Text('Something went wrong'));
                  } else if (state is SurveySuccess) {
                    postBody = {
                      'rbrg': widget.rbrg,
                      "uuid": widget.uuid,
                      "scrg": widget.scrg ?? state.data['survey']['scrg'],
                      'answers': []
                    };
                    body = state.data;
                    List<ModelSurvey> result = [];

                    try {
                      validation = [];
                      valTF = [];
                      for (var element
                          in (state.data!['survey']['questions'] as List)) {
                        result.add(
                          ModelSurvey(
                              type: element['type'],
                              prompt: element['prompt'],
                              options: element['options'],
                              isReq: element['isRequired']),
                        );

                        postBody['answers'].add({
                          "rowGuid": element['rowGuid'],
                          "type": element['type'],
                          "answer": ''
                        });
                        validation.add({
                          "isReq": element["isRequired"],
                          "type": element['type'],
                          "answer": ""
                        });
                        if (element["isRequired"]) {
                          valTF.add(false);
                        } else {
                          valTF.add(true);
                        }
                      }
                    } catch (e) {
                      PatientToast.showToast(message: e.toString());
                    }
                    return Column(
                      children: [
                        Container(
                          padding: widget.paddingGeneral ??
                              const EdgeInsets.symmetric(
                                horizontal: ConfigConstants.paddingGeneral,
                              ),
                          alignment: widget.isRtl
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Text(
                            state.data['survey']['title'].toString(),
                            textDirection: widget.isRtl
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: ConfigConstants.fontHomeGreeting,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.all(30),
                          itemCount: result.length,
                          shrinkWrap: true,
                          // list item builder
                          itemBuilder: (BuildContext ctx, index) {
                            var answer = '';

                            if (result[index].type == 'radio') {
                              return SurveyQuestionRadio(
                                  question: result[index].prompt,
                                  options: result[index].options,
                                  answer: answer,
                                  isReq: result[index].isReq,
                                  handle: (value) {
                                    for (int j = 0;
                                        j <
                                            body['survey']['questions'][index]
                                                    ['options']
                                                .length;
                                        j++) {
                                      if (body['survey']['questions'][index]
                                                  ['options'][j]['answer']
                                              .toString()
                                              .toLowerCase() ==
                                          value.toString().toLowerCase()) {
                                        body['survey']['questions'][index]
                                            ['options'][j]['value'] = true;
                                        validation[index]["answer"] = "true";
                                        postBody['answers'][index]["answer"] =
                                            body['survey']['questions'][index]
                                                ['options'][j]['answer'];
                                      } else {
                                        body['survey']['questions'][index]
                                            ['options'][j]['value'] = false;
                                      }
                                    }
                                    for (var i = 0;
                                        i < validation.length;
                                        i++) {
                                      if (validation[i]['isReq']) {
                                        if (validation[i]['answer'] != "") {
                                          valTF[i] = true;
                                        } else {
                                          valTF[i] = false;
                                        }
                                      }
                                    }
                                    var x = [];
                                    x.add(valTF
                                        .where((e) => e == false)
                                        .toList());
                                    if (x[0].isEmpty) {
                                      submitActive.value = true;
                                    } else {
                                      submitActive.value = false;
                                    }
                                  });
                            } else if (result[index].type == 'text') {
                              return SurveyQuestionText(
                                title: result[index].prompt,
                                handle: (value) {
                                  body['survey']['questions'][index]['answer'] =
                                      value;
                                  validation[index]["answer"] = value;
                                  postBody['answers'][index]["answer"] = value;
                                  for (var i = 0; i < validation.length; i++) {
                                    if (validation[i]['isReq']) {
                                      if (validation[i]['answer'] != "") {
                                        valTF[i] = true;
                                      } else {
                                        valTF[i] = false;
                                      }
                                    }
                                  }
                                  var x = [];
                                  x.add(
                                      valTF.where((e) => e == false).toList());
                                  if (x[0].isEmpty) {
                                    submitActive.value = true;
                                  } else {
                                    submitActive.value = false;
                                  }
                                },
                                isReq: result[index].isReq,
                              );
                            } else if (result[index].type == '5star') {
                              return SurveyQuestionRating(
                                title: result[index].prompt,
                                handle: (rating) {
                                  body['survey']['questions'][index]['stars'] =
                                      rating.toInt();
                                  postBody['answers'][index]["answer"] =
                                      rating.toInt();
                                  if (rating.toInt() == 0) {
                                    validation[index]["answer"] = "";
                                  } else {
                                    validation[index]["answer"] =
                                        rating.toString();
                                  }

                                  for (var i = 0; i < validation.length; i++) {
                                    if (validation[i]['isReq']) {
                                      if (validation[i]['answer'] != "") {
                                        valTF[i] = true;
                                      } else {
                                        valTF[i] = false;
                                      }
                                    }
                                  }

                                  var x = [];
                                  x.add(
                                      valTF.where((e) => e == false).toList());
                                  if (x[0].isEmpty) {
                                    submitActive.value = true;
                                  } else {
                                    submitActive.value = false;
                                  }
                                },
                                isReq: result[index].isReq,
                              );
                            } else {
                              return Container();
                            }
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: 20,
                            );
                          },
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
              const SizedBox(
                height: 12,
              ),
              BlocConsumer<PostSurveyBloc, PostSurveyState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is PostSurveyInProgress) {
                      return const LoadingIndicator();
                    } else if (state is PostSurveySuccess) {
                      if (state.data == 'ok') {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _showDialog(context: context);
                        });
                      }
                    }
                    return ValueListenableBuilder(
                        valueListenable: submitActive,
                        builder:
                            (BuildContext context, dynamic val, Widget? child) {
                          return Container(
                            height: 60,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 40),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: submitActive.value
                                    ? MaterialStateProperty.all<Color>(
                                        ConfigConstants.white,
                                      )
                                    : MaterialStateProperty.all<Color>(
                                        ConfigConstants.greyLight,
                                      ),
                                overlayColor: MaterialStateProperty.all<Color>(
                                  ConfigConstants.red.withOpacity(0.4),
                                ),
                                elevation: MaterialStateProperty.all<double>(
                                  0,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: submitActive.value
                                  ? () {
                                      BlocProvider.of<PostSurveyBloc>(context)
                                          .add(PostSurveyEventRequested(
                                              body: postBody));
                                    }
                                  : () {},
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                  color: ConfigConstants.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: ConfigConstants.fontLarge,
                                ),
                              ),
                            ),
                          );
                        });
                  }),
              const SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog({
    required BuildContext context,
  }) async {
    final s = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => RequestDialog(
        title:
            "Thank you for completing the survey. We appretiate you spending the time!",
        bottomWidget: PatientButton(
          text: "Okay",
          backgroundColor: ConfigConstants.red,
          padding: const EdgeInsets.symmetric(
            horizontal: ConfigConstants.paddingGeneral,
            vertical: 8,
          ),
          fontSize: ConfigConstants.fontLarge,
          handleTap: () {
            Navigator.of(context).pop(true);
          },
        ),
      ),
    );
    if (s) {
      widget.goBackOnSubmit!();
    }
  }
}

showSurvey({
  required BuildContext context,
  required String getUrl,
  required String postUrl,
  required Map<String, String> headers,
  required String uuid,
  String? scrg,
  String? rbrg,
  Decoration? decoration,
  Color? backArrowColor,
  Color? submitButtonDisabledColor,
  Color? submitButtonenabledColor,
  Color? submitButtonTextColor,
  EdgeInsets? paddingGeneral,
  int? submitButtonTextSize,
  Color? radioActiveColor,
  Color? radioTextcoLOR,
  Color? requiredStarColor,
  VoidCallback? goBackOnSubmit,
  Color? loadingIndicatorColor,
  bool? isRtl,
}) {
  Navigator.push(
    context,
    MaterialPageRoute<SurveyPage>(
      builder: (BuildContext context) {
        return MultiBlocProvider(
            providers: [
              BlocProvider<SurveyBloc>(
                  create: (BuildContext context) =>
                      SurveyBloc(getUrl, headers, uuid, scrg: scrg)),
              BlocProvider<PostSurveyBloc>(
                create: (BuildContext context) =>
                    PostSurveyBloc(postUrl, headers),
              ),
            ],
            child: SurveyPage(
              scrg: scrg,
              rbrg: rbrg,
              decoration: decoration,
              backArrowColor: backArrowColor,
              submitButtonDisabledColor: submitButtonDisabledColor,
              submitButtonenabledColor: submitButtonenabledColor,
              submitButtonTextColor: submitButtonTextColor,
              paddingGeneral: paddingGeneral,
              submitButtonTextSize: submitButtonTextSize,
              radioActiveColor: radioActiveColor,
              radioTextcoLOR: radioTextcoLOR,
              uuid: uuid,
              requiredStarColor: requiredStarColor,
              goBackOnSubmit: goBackOnSubmit,
              loadingIndicatorColor: loadingIndicatorColor,
              isRtl: isRtl ?? true,
            ));
      },
    ),
  );
}

class SurveyPage2 extends StatefulWidget {
  final String? scrg;
  final Decoration? decoration;
  final Color? backArrowColor;
  final Color? submitButtonDisabledColor;
  final Color? submitButtonenabledColor;
  final Color? submitButtonTextColor;
  final EdgeInsets? paddingGeneral;
  final int? submitButtonTextSize;
  final Color? radioActiveColor;
  final Color? radioTextcoLOR;
  final String? uuid;
  final Color? requiredStarColor;
  final VoidCallback? goBackOnSubmit;
  final Color? loadingIndicatorColor;
  final bool isRtl;

  const SurveyPage2({
    this.scrg,
    this.backArrowColor,
    this.decoration,
    this.submitButtonDisabledColor,
    this.submitButtonTextColor,
    this.submitButtonenabledColor,
    this.isRtl = true,
    this.paddingGeneral,
    this.goBackOnSubmit,
    this.submitButtonTextSize,
    this.radioActiveColor,
    this.radioTextcoLOR,
    this.requiredStarColor,
    this.loadingIndicatorColor,
    this.uuid,
    super.key,
  });

  @override
  State<SurveyPage2> createState() => _SurveyPage2State();
}

class _SurveyPage2State extends State<SurveyPage2> {
  var answers = {};
  ValueNotifier<bool> submitActive = ValueNotifier(false);
  dynamic body;
  Map<String, dynamic> postBody = {};
  @override
  void initState() {
    BlocProvider.of<SurveyBloc>(context)
        .add(SurveyEventRequested(scrg: widget.scrg));
    super.initState();
  }

  var validation = [];
  var valTF = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration:
            widget.decoration ?? ConfigConstants.loginGradientBackground,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                iconSize: 24,
                color: widget.backArrowColor ?? ConfigConstants.white,
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              BlocConsumer<SurveyBloc, SurveyState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is SurveyInProgress) {
                    return const LoadingIndicator();
                  } else if (state is SurveyFailed ||
                      (state is SurveySuccess &&
                          !(state.data != null &&
                              state.data['survey'] != null))) {
                    const Center(child: Text('Something went wrong'));
                  } else if (state is SurveySuccess) {
                    postBody = {
                      "uuid": widget.uuid,
                      "scrg": widget.scrg ?? state.data['survey']['scrg'],
                      'answers': []
                    };
                    body = state.data;
                    List<ModelSurvey> result = [];

                    try {
                      validation = [];
                      valTF = [];
                      for (var element
                          in (state.data!['survey']['questions'] as List)) {
                        result.add(
                          ModelSurvey(
                              type: element['type'],
                              prompt: element['prompt'],
                              options: element['options'],
                              isReq: element['isRequired']),
                        );

                        postBody['answers'].add({
                          "rowGuid": element['rowGuid'],
                          "type": element['type'],
                          "answer": ''
                        });
                        validation.add({
                          "isReq": element["isRequired"],
                          "type": element['type'],
                          "answer": ""
                        });
                        if (element["isRequired"]) {
                          valTF.add(false);
                        } else {
                          valTF.add(true);
                        }
                      }
                    } catch (e) {
                      PatientToast.showToast(message: e.toString());
                    }
                    return Column(
                      children: [
                        Container(
                          padding: widget.paddingGeneral ??
                              const EdgeInsets.symmetric(
                                horizontal: ConfigConstants.paddingGeneral,
                              ),
                          alignment: widget.isRtl
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Text(
                            state.data['survey']['title'].toString(),
                            textDirection: widget.isRtl
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: ConfigConstants.fontHomeGreeting,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.all(30),
                          itemCount: result.length,
                          shrinkWrap: true,
                          // list item builder
                          itemBuilder: (BuildContext ctx, index) {
                            var answer = '';

                            if (result[index].type == 'radio') {
                              return SurveyQuestionRadio(
                                  question: result[index].prompt,
                                  options: result[index].options,
                                  answer: answer,
                                  isReq: result[index].isReq,
                                  handle: (value) {
                                    for (int j = 0;
                                        j <
                                            body['survey']['questions'][index]
                                                    ['options']
                                                .length;
                                        j++) {
                                      if (body['survey']['questions'][index]
                                                  ['options'][j]['answer']
                                              .toString()
                                              .toLowerCase() ==
                                          value.toString().toLowerCase()) {
                                        body['survey']['questions'][index]
                                            ['options'][j]['value'] = true;
                                        validation[index]["answer"] = "true";
                                        postBody['answers'][index]["answer"] =
                                            body['survey']['questions'][index]
                                                ['options'][j]['answer'];
                                      } else {
                                        body['survey']['questions'][index]
                                            ['options'][j]['value'] = false;
                                      }
                                    }
                                    for (var i = 0;
                                        i < validation.length;
                                        i++) {
                                      if (validation[i]['isReq']) {
                                        if (validation[i]['answer'] != "") {
                                          valTF[i] = true;
                                        } else {
                                          valTF[i] = false;
                                        }
                                      }
                                    }
                                    var x = [];
                                    x.add(valTF
                                        .where((e) => e == false)
                                        .toList());
                                    if (x[0].isEmpty) {
                                      submitActive.value = true;
                                    } else {
                                      submitActive.value = false;
                                    }
                                  });
                            } else if (result[index].type == 'text') {
                              return SurveyQuestionText(
                                title: result[index].prompt,
                                handle: (value) {
                                  body['survey']['questions'][index]['answer'] =
                                      value;
                                  validation[index]["answer"] = value;
                                  postBody['answers'][index]["answer"] = value;
                                  for (var i = 0; i < validation.length; i++) {
                                    if (validation[i]['isReq']) {
                                      if (validation[i]['answer'] != "") {
                                        valTF[i] = true;
                                      } else {
                                        valTF[i] = false;
                                      }
                                    }
                                  }
                                  var x = [];
                                  x.add(
                                      valTF.where((e) => e == false).toList());
                                  if (x[0].isEmpty) {
                                    submitActive.value = true;
                                  } else {
                                    submitActive.value = false;
                                  }
                                },
                                isReq: result[index].isReq,
                              );
                            } else if (result[index].type == '5star') {
                              return SurveyQuestionRating(
                                title: result[index].prompt,
                                handle: (rating) {
                                  body['survey']['questions'][index]['stars'] =
                                      rating.toInt();
                                  postBody['answers'][index]["answer"] =
                                      rating.toInt();
                                  if (rating.toInt() == 0) {
                                    validation[index]["answer"] = "";
                                  } else {
                                    validation[index]["answer"] =
                                        rating.toString();
                                  }

                                  for (var i = 0; i < validation.length; i++) {
                                    if (validation[i]['isReq']) {
                                      if (validation[i]['answer'] != "") {
                                        valTF[i] = true;
                                      } else {
                                        valTF[i] = false;
                                      }
                                    }
                                  }

                                  var x = [];
                                  x.add(
                                      valTF.where((e) => e == false).toList());
                                  if (x[0].isEmpty) {
                                    submitActive.value = true;
                                  } else {
                                    submitActive.value = false;
                                  }
                                },
                                isReq: result[index].isReq,
                              );
                            } else {
                              return Container();
                            }
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: 20,
                            );
                          },
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
              const SizedBox(
                height: 12,
              ),
              BlocConsumer<PostSurvey2Bloc, PostSurvey2State>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is PostSurvey2InProgress) {
                      return const LoadingIndicator();
                    } else if (state is PostSurvey2Success) {
                      if (state.data == 'ok') {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _showDialog(context: context);
                        });
                      }
                    }
                    return ValueListenableBuilder(
                        valueListenable: submitActive,
                        builder:
                            (BuildContext context, dynamic val, Widget? child) {
                          return Container(
                            height: 60,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 40),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: submitActive.value
                                    ? MaterialStateProperty.all<Color>(
                                        ConfigConstants.white,
                                      )
                                    : MaterialStateProperty.all<Color>(
                                        ConfigConstants.greyLight,
                                      ),
                                overlayColor: MaterialStateProperty.all<Color>(
                                  ConfigConstants.red.withOpacity(0.4),
                                ),
                                elevation: MaterialStateProperty.all<double>(
                                  0,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: submitActive.value
                                  ? () {
                                      BlocProvider.of<PostSurvey2Bloc>(context)
                                          .add(PostSurvey2EventRequested(
                                              body: postBody));
                                    }
                                  : () {},
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                  color: ConfigConstants.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: ConfigConstants.fontLarge,
                                ),
                              ),
                            ),
                          );
                        });
                  }),
              const SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog({
    required BuildContext context,
  }) async {
    final s = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => RequestDialog(
        title:
            "Thank you for completing the survey. We appretiate you spending the time!",
        bottomWidget: PatientButton(
          text: "Okay",
          backgroundColor: ConfigConstants.red,
          padding: const EdgeInsets.symmetric(
            horizontal: ConfigConstants.paddingGeneral,
            vertical: 8,
          ),
          fontSize: ConfigConstants.fontLarge,
          handleTap: () {
            Navigator.of(context).pop(true);
          },
        ),
      ),
    );
    if (s) {
      widget.goBackOnSubmit!();
    }
  }
}

showSurvey2({
  required BuildContext context,
  required String getUrl,
  required Function postFunction,
  required Map<String, String> headers,
  required String uuid,
  String? scrg,
  Decoration? decoration,
  Color? backArrowColor,
  Color? submitButtonDisabledColor,
  Color? submitButtonenabledColor,
  Color? submitButtonTextColor,
  EdgeInsets? paddingGeneral,
  int? submitButtonTextSize,
  Color? radioActiveColor,
  Color? radioTextcoLOR,
  Color? requiredStarColor,
  VoidCallback? goBackOnSubmit,
  Color? loadingIndicatorColor,
  bool? isRtl,
}) {
  Navigator.push(
    context,
    MaterialPageRoute<SurveyPage2>(
      builder: (BuildContext context) {
        return MultiBlocProvider(
            providers: [
              BlocProvider<SurveyBloc>(
                  create: (BuildContext context) =>
                      SurveyBloc(getUrl, headers, uuid, scrg: scrg)),
              BlocProvider<PostSurvey2Bloc>(
                create: (BuildContext context) => PostSurvey2Bloc(postFunction),
              ),
            ],
            child: SurveyPage2(
              scrg: scrg,
              decoration: decoration,
              backArrowColor: backArrowColor,
              submitButtonDisabledColor: submitButtonDisabledColor,
              submitButtonenabledColor: submitButtonenabledColor,
              submitButtonTextColor: submitButtonTextColor,
              paddingGeneral: paddingGeneral,
              submitButtonTextSize: submitButtonTextSize,
              radioActiveColor: radioActiveColor,
              radioTextcoLOR: radioTextcoLOR,
              uuid: uuid,
              requiredStarColor: requiredStarColor,
              goBackOnSubmit: goBackOnSubmit,
              loadingIndicatorColor: loadingIndicatorColor,
              isRtl: isRtl ?? true,
            ));
      },
    ),
  );
}
