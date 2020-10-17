import 'package:assignment_bluestacks/core/models/tournament.dart';
import 'package:assignment_bluestacks/core/models/user.dart';
import 'package:assignment_bluestacks/core/utils/app_localization.dart';
import 'package:assignment_bluestacks/modules/home/cubit/home_cubit.dart';
import 'package:assignment_bluestacks/modules/home/view/stats_view.dart';
import 'package:assignment_bluestacks/modules/home/view/tournament_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../views/loading_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeCubit homeCubit;

  User _user;
  List<Tournament> _tournaments = [];
  bool _hasReachedMax = false;
  final _scrollThreshold = 600;
  String _cursor;
  ScrollController _scrollController = ScrollController();

  void _onScrollListener() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    print(maxScroll - currentScroll);
    if (maxScroll - currentScroll <= _scrollThreshold && !_hasReachedMax) {
      if (homeCubit.state is! HomeLoading) {
        homeCubit.getTournaments(_cursor);
      }
    }
  }

  @override
  void initState() {
    _scrollController.addListener(_onScrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.addListener(_onScrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf9f9f9),
      appBar: AppBar(
        backgroundColor: Color(0xFFf9f9f9),
        elevation: 0,
        centerTitle: true,
        leading: Icon(
          Icons.menu,
          color: Colors.black,
        ),
        title: Text("Flyingwolf",
            style: TextStyle(
              color: Colors.black,
            )),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          homeCubit = context.bloc<HomeCubit>();
          if (state is TournamentsLoaded) {
            // Update tournaments
            _tournaments = _tournaments + state.tournaments;
            _cursor = state.cursor;
            _hasReachedMax = state.hasReachedMax;
          } else if (state is UserLoaded) {
            _user = state.user;
          } else if (state is HomeError) {
            // Display error message
            final snackBar = SnackBar(content: Text(state.message));
            Scaffold.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) => Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: ListView.builder(
              itemCount: _tournaments.length + 1,
              controller: _scrollController,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      getProfileView(),
                      const SizedBox(height: 24),
                      getStatsViews(),
                      const SizedBox(height: 24),
                      Text(
                        AppLocalizations.of(context)
                            .translate('recommended_for_you'),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      (state is HomeLoading && _tournaments.length == 0)
                          ? LoadingView()
                          : SizedBox.shrink()
                    ],
                  );
                } else if (index == _tournaments.length) {
                  return (homeCubit?.state is HomeLoading)
                      ? LoadingView()
                      : SizedBox.shrink();
                } else {
                  return TournamentView(_tournaments[index - 1]);
                }
              }),
        ),
      ),
    );
  }

  Widget getProfileView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 80,
          width: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl:
                  (_user != null) ? _user.avatar : "https://picsum.photos/200",
              height: 80,
              width: 80,
              alignment: Alignment.topCenter,
              placeholder: (context, string) {
                return Container(
                  color: Colors.red,
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 4, top: 8, bottom: 16),
                  child: Text(
                    (_user != null) ? _user.name : "",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            (_user != null) ? "${_user.points}" : "0",
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Elo rating',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget getStatsViews() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Row(
        children: [
          StatsView(
            (_user != null) ? "${_user.tournamentsPlayed}" : "0",
            AppLocalizations.of(context).translate('tournaments_played'),
            LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[Colors.deepOrangeAccent, Colors.orange],
            ),
          ),
          StatsView(
            (_user != null) ? "${_user.tournamentsWon}" : "0",
            AppLocalizations.of(context).translate('tournaments_won'),
            LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: <Color>[Colors.purple, Colors.deepPurpleAccent],
            ),
          ),
          StatsView(
            (_user != null) ? "${_user.winningPercentage}%" : "0%",
            AppLocalizations.of(context).translate('winning_percentage'),
            LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[Colors.red, Colors.redAccent],
            ),
          )
        ],
      ),
    );
  }

}
