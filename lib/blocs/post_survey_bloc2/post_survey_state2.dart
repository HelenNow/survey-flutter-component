part of 'post_survey_bloc2.dart';

@immutable
abstract class PostSurvey2State {}

class PostSurvey2Initial extends PostSurvey2State {}

class PostSurvey2InProgress extends PostSurvey2State {}

class PostSurvey2Success extends PostSurvey2State {
  final dynamic data;
  PostSurvey2Success({this.data});
}

class PostSurvey2Failed extends PostSurvey2State {}
