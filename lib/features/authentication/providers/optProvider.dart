import 'package:flutter/material.dart';

import '../../../api/api_controller.dart';
import '../models/optResponseDataModel.dart';

class OtpProvider extends ChangeNotifier {
  ApiController _apiService = ApiController();
  OtpResponse? _otpResponseModel;

  OtpResponse? get otpResponseModel => _otpResponseModel;

  Future<void> fetchOtp(String emailAddress,String phoneNo) async {
    try {
      final response = await ApiController.getOTP(emailAddress,phoneNo);
      _otpResponseModel = OtpResponse.fromJson(response);
      print("Response from OtpResponse: $response");
      notifyListeners();
    } catch (e) {
      notifyListeners();
      print('Error in OtpResponse: $e');
    }
  }
}
