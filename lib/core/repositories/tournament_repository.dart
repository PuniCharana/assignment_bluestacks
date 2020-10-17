import 'package:assignment_bluestacks/core/api/api_client.dart';
import 'package:assignment_bluestacks/core/api/api_response.dart';
import 'package:assignment_bluestacks/core/models/user.dart';

class TournamentRepository {

  Future<User> getUserProfile() async {
    try {
      var client = await ApiClient().getApiClient();
      // TODO extract base url to api client
      final url = 'https://api.mocki.io/v1/299cebe5';
      final response = await client.get(url);
      return User.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  Future<ApiResponse> getTournaments(String cursor) async {
    try {
      var client = await ApiClient().getApiClient();
      // TODO extract base url to api client
      final url =
          'http://tournaments-dot-game-tv-prod.uc.r.appspot.com/tournament/api/tournaments_list_v2?limit=10&status=all&cursor=$cursor';
      final response = await client.get(url);
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }
}
