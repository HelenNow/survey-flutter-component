part of 'post_survey_bloc2.dart';

@immutable
abstract class PostSurvey2Event {}

class PostSurvey2EventRequested extends PostSurvey2Event {
  final dynamic body;
  PostSurvey2EventRequested({this.body});
}
