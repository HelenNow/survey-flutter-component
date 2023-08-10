import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:survey/survey_repo.dart';

part 'post_survey_event.dart';
part 'post_survey_state.dart';

class PostSurveyBloc extends Bloc<PostSurveyEvent, PostSurveyState> {
  PostSurveyBloc(String url, Map<String, String> headers)
      : super(PostSurveyInitial()) {
    on<PostSurveyEventRequested>((event, emit) async {
      emit(PostSurveyInProgress());
      try {
        var response = await APIRequestSurvey.postSurveyQuestions(
            event.body, url, headers);
        emit(PostSurveySuccess(data: response));
      } catch (e) {
        emit(PostSurveyFailed());
      }
    });
  }
}
