import 'dart:async';

class ProfileRefreshService {
  static final ProfileRefreshService _instance = ProfileRefreshService._internal();
  factory ProfileRefreshService() => _instance;
  ProfileRefreshService._internal();

  final StreamController<void> _refreshController = StreamController<void>.broadcast();
  
  Stream<void> get refreshStream => _refreshController.stream;
  
  void notifyProfileUpdated() {
    if (!_refreshController.isClosed) {
      _refreshController.add(null);
    }
  }
  
  void dispose() {
    _refreshController.close();
  }
}
