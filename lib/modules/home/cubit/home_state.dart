part of 'home_cubit.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class TournamentsLoaded extends HomeState {
  final List<Tournament> tournaments;
  final bool hasReachedMax;
  final String cursor;

  const TournamentsLoaded(
    this.tournaments,
    this.hasReachedMax,
    this.cursor,
  );
}

class UserLoaded extends HomeState {
  final User user;
  const UserLoaded(this.user);
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);
}
