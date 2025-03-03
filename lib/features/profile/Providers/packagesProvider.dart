import 'package:digital_study_room/api/api_controller.dart';
import 'package:flutter/foundation.dart';

import '../datamodels/packagesDataModel.dart';

class PackagesProvider extends ChangeNotifier {
  ApiController _apiService = ApiController();
  int? userId;
  PackagesProvider({this.userId});
  List<Package> _packages = [];
  String _errorMessage = '';

  List<Package> get packages => _packages;
  String get errorMessage => _errorMessage;

  Future<void> fetchPackages() async {
    if (userId != null) {
      try {
        final Map<String, dynamic> data =
        await _apiService.getPackagesList(userId ?? 0);
        if (data.containsKey('packageList')) {
          _packages = (data['packageList'] as List<dynamic>)
              .map((json) => Package.fromJson(json))
              .toList();
          _errorMessage = '';
        } else {
          _errorMessage = data['message'] ?? 'Failed to load packages';
        }
      } catch (e) {
        print("error ${e.toString()}");
        _errorMessage = 'Failed to load data: $e';
      }
    }

    notifyListeners();
  }
}
