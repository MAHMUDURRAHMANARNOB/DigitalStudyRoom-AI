import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

import '../../../api/api_controller.dart';
import '../datamodels/coupnDiscountModel.dart';

class CouponDiscountProvider extends ChangeNotifier {
  ApiController _apiService = ApiController();

  CouponDiscountDataModel? _couponDiscountDataModel;

  CouponDiscountDataModel? get couponDiscountResponse =>
      _couponDiscountDataModel;

  Future<Map<String, dynamic>> fetchCouponDiscountResponse(
    String couponcode,
    double amount,
  ) async {
    print("inside fetchCouponDiscountResponse $couponcode");
    try {
      // Use default audio file if audioFile is null
      // File selectedAudioFile = audioFile;

      Map<String, dynamic> response = await _apiService.getCouponDiscount(
        couponcode: couponcode,
        amount: amount,
      );
      _couponDiscountDataModel = CouponDiscountDataModel.fromJson(response);
      print("Response from fetchCouponDiscountResponse: $response");
      notifyListeners();
      return response;
    } catch (error) {
      print('Error in fetchCouponDiscountResponse: $error');
      throw Exception('Failed to load data. Check your network connection.');
    }
  }
}
