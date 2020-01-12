import 'dart:async';
import 'package:redux_testing/data/network_common.dart';

class NowPlayingRepository {
  const NowPlayingRepository();

  Future<Map> getNowPlayingsList(int page,String type) {
    return new NetworkCommon().dio.get("movie/$type?api_key=f55fbda0cb73b855629e676e54ab6d8e", queryParameters: {
      "page": page,
    }).then((d) {
      var results = new NetworkCommon().decodeResp(d) as Map;
      print('++++++++++++++++++++ : $results');
      return results;
    });
  }
}
