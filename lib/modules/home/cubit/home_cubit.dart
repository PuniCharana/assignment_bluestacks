import 'package:assignment_bluestacks/core/models/tournament.dart';
import 'package:assignment_bluestacks/core/models/user.dart';
import 'package:assignment_bluestacks/core/repositories/tournament_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({this.repository}) : super(HomeInitial()) {
    getUserProfile();
    String cursor =
        'CmMKGQoMcmVnX2VuZF9kYXRlEgkIgLTH_rqS7AISQmoOc35nYW1lLXR2LXByb2RyMAsSClRvdXJuYW1lbnQiIDIxMDQ5NzU3N2UwOTRmMTU4MWExMDUzODEwMDE3NWYyDBgAIAE=';
    getTournaments(cursor);
  }

  final TournamentRepository repository;

  void getUserProfile() {
    emit(HomeLoading());
    repository.getUserProfile().then((response) {
      emit(UserLoaded(response));
    }).catchError((onError) {
      emit(HomeError("Something went wrong"));
    });
  }

  void getTournaments(String cursor) async {
    emit(HomeLoading());
    repository.getTournaments(cursor).then((response) {
      emit(TournamentsLoaded(
        response.data.tournaments,
        response.data.isLastBatch,
        response.data.cursor,
      ));
    }).catchError((onError) {
      emit(HomeError("Something went wrong"));
    });
  }
}
