import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../features/ToolsContent/datamodel/studyToolsDataModel.dart';
import '../features/Tutor/datamodels/TutorChapterListDataModel.dart';
import '../features/Tutor/datamodels/TutorDataModel.dart';
import '../features/authentication/models/LoginResponseDataModel.dart';
import '../features/authentication/models/SelectClassDataModel.dart';
import '../features/authentication/models/UserDataModel.dart';
import '../features/profile/datamodels/SubscriptionStatusDataModel.dart';

class ApiController {
  // static const String baseUrl = 'https://api.risho.guru';
  static const String baseUrl = 'https://studyroom.risho.guru';

  /*LOGIN*/
  /*static Future<LoginResponse> loginApi(
      String username, String password) async {
    const apiUrl = '$baseUrl/loginuser/';

    *//*for query type url*//*
    final Uri uri = Uri.parse('$apiUrl?userid=$username&password=$password');
    *//*Query type url*//*
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    try {
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the response body
        return LoginResponse.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception or handle the error as needed
        // Handle specific HTTP error codes
        print("HTTP Error: ${response.statusCode}");
        print("Response Body: ${response.body}");
        throw Exception('Failed to login. HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other types of errors
      print("Error during loginApi: $error");
      throw Exception('Failed to login. Error: $error');
    }
  }*/

  /*CREATE USER*/
  Future<bool> createUser(
      String userId,
      String username,
      String name,
      String email,
      String mobile,
      String password,
      String userType,
      String school,
      String address,
      String marketingSource,
      String classId) async {
    const apiUrl = '$baseUrl/creatuser/';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': userId.toString(),
          'username': username.toString(),
          'name': name.toString(),
          'email': email.toString(),
          'mobile': mobile.toString(),
          'password': password.toString(),
          'usertype': userType.toString(),
          'school': school.toString(),
          'address': address.toString(),
          'marketingSource': marketingSource.toString(),
          'classId': classId.toString(),
        }),
      );

      if (response.statusCode == 200) {
        // Parse successful response
        final responseData = jsonDecode(response.body);
        if (responseData["errorcode"] == 200) {
          print("Success Response: ${response.body}");
          /*SuccessfulResponse.fromJson(jsonDecode(response.body));*/
          return true;
        } else if (responseData["errorcode"] == 400) {
          print("Failed to create user: ${responseData["message"]}");
          /*ErrorResponse.fromJson(jsonDecode(response.body));*/
          return false;
        } else {
          print("Failed to create user: ${response.body}");
          return false;
        }
      } else {
        // Parse error response
        print("Failed to create user: StatusCode ${response.statusCode}");
        return false;
      }
    } catch (e) {
      // Exception occurred
      print('Exception creating user: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> loginUser(
      String userId, String password) async {
    try {
      final apiUrl = '$baseUrl/loginuser/';
      final Uri uri = Uri.parse('$apiUrl?userid=$userId&password=$password');
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      }

      print("Login failed: Invalid response");
      return null;
    } catch (e) {
      print("Error in login: $e");
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> _saveUserSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', user.userId);
    prefs.setString('username', user.username);
    prefs.setString('email', user.email);
    prefs.setString('password', user.password);
  }

  Future<User?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) return null;

    return User(
      id: 1,
      userId: userId,
      username: prefs.getString('username') ?? '',
      name: '',
      email: prefs.getString('email') ?? '',
      mobile: '',
      password: '',
      userType: '',
      classId: null,
    );
  }

  Future<List<ClassModel>> fetchClasses() async {
    final response = await http.post(Uri.parse("$baseUrl/getClassList/"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data["errorcode"] == 200) {
        return (data["classes"] as List)
            .map((json) => ClassModel.fromJson(json))
            .toList();
      }
    }
    throw Exception("Failed to load classes");
  }

  /*GET OTP*/
  static Future<Map<String, dynamic>> getOTP(
      String emailAddress,String phoneNo) async {
    const apiUrl = '$baseUrl/getOTP/';
    final Uri uri = Uri.parse(apiUrl);

    try {
      final response = await http.post(
        uri,
        body: {
          'emailAddress': emailAddress.toString(),
          'phoneNo': phoneNo.toString(),
        },
      );
      final responseCheck = json.decode(response.body);
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        print("Response in getOTP " + response.body);
        return json.decode(response.body);
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /*FORGET PASS -> NEW PASSWORD*/
  static Future<Map<String, dynamic>> resetPassword(
      String emailAddress, String password) async {
    // const apiUrl = '$baseUrl/resetpassword/';
    final apiUrl =
        '$baseUrl/resetpassword/?userid=$emailAddress&newpassword=$password';
    final Uri uri = Uri.parse(apiUrl);

    try {
      final response = await http.post(
          /*uri,
        body: {
          'userid': emailAddress.toString(),
          'newpassword': password.toString(),
        },*/
          uri);
      final responseCheck = json.decode(response.body);
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        print("Response in resetPassword " + response.body);
        return responseCheck;
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('${response.body}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /*SUBSCRIPTION STATUS*/
  static Future<SubscriptionStatusDataModel> fetchSubscriptionStatus(
      int userId) async {
    const apiUrl = '$baseUrl/getsubscriptionDetails/';
    final Uri uri = Uri.parse('$apiUrl');
    final response = await http.post(
      uri,
      body: {'userid': userId.toString()},
      /*headers: {'Content-Type': 'application/json'},*/
    );
    /*print("Response $response");*/

    if (response.statusCode == 200) {
      print(SubscriptionStatusDataModel.fromJson(jsonDecode(response.body)));
      return SubscriptionStatusDataModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Sub status');
    }
  }

  static Future<List<StudyToolsDataModel>> fetchTools(int userId) async {
    const apiUrl = '$baseUrl/gettoolslist/';
    /*if (kDebugMode) {
      print(apiUrl);
    }*/
    final Uri uri = Uri.parse(apiUrl);

    final response = await http.post(
      uri,
      body: {'userid': userId.toString()},
    );

    try {
      if (response.statusCode == 200) {
        final dynamic responseData =
            jsonDecode(Utf8Decoder().convert(response.bodyBytes));
        // print("response $responseData");

        if (responseData != null && responseData['studytools'] != null) {
          final List<dynamic> toolsData = responseData['studytools'];
          return toolsData
              .map((data) => StudyToolsDataModel.fromJson(data))
              .toList();
        } else {
          throw Exception('Invalid response format');
        }

        /*final List<dynamic> responseData =
          jsonDecode(response.body)['StudyToolsDataModels'];
      return responseData.map((data) => StudyToolsDataModel.fromJson(data)).toList();*/
      } else {
        throw Exception(
            'Failed to load study tools. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load study tools. Error: $error');
    }
  }

  /*Tools Response*/
  Future<Map<String, dynamic>> getToolsResponse(
    int userid,
    String questiontext,
    String subject,
    String gradeclass,
    String toolscode,
    String maxline,
    String isMobile,
  ) async {
    final url = '$baseUrl/gettoolsresponse/';
    print(
        "Posting in api service $url, $userid, $questiontext, $subject, $gradeclass, $toolscode");
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'userid': userid.toString(),
          'questiontext': questiontext.toString(),
          'subject': subject.toString(),
          'gradeclass': gradeclass.toString(),
          'toolscode': toolscode.toString(),
          // 'maxSentence': maxline.toString(),
          'isMobileApp': "Y",
        },
      );
      print(
          "Response  ${response.statusCode} -- ${json.decode(response.body)}");
      return json.decode(response.body);
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        print("Response in getToolsResponse " + json.decode(response.body));
        if (kDebugMode) {
          print("Response in getToolsResponse " + json.decode(response.body));
        }
        return json.decode(response.body);
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load data in getToolsResponse');
      }
    } catch (e) {
      throw Exception("Failed getToolsResponse $e");
    }
  }

  /*IMAGE TOOLS RESPONSE*/
  Future<Map<String, dynamic>> getImageToolsResponse(
      File questionImage,
      int userid,
      String questiontext,
      String subject,
      String gradeclass,
      String toolscode,
      String maxline,
      String isMobile) async {
    final url = '$baseUrl/getimagetoolsresponse/';
    print(
        "Posting in api service $url $questionImage ,$userid, $questiontext, $subject, $gradeclass, $toolscode");

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['userid'] = userid.toString();
    request.fields['questiontext'] = questiontext.toString();
    request.fields['subject'] = subject.toString();
    request.fields['gradeclass'] = gradeclass.toString();
    request.fields['toolscode'] = toolscode.toString();
    request.fields['maxSentence'] =
        isMobile.toString() == null ? isMobile.toString() : "50";
    request.fields['isMobileApp'] = "Y";
    request.files.add(
        await http.MultipartFile.fromPath('questionimage', questionImage.path));
    print("QUESTIONIMAGEPATH: ${questionImage.path}");

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
      final responseString =
          await response.stream.transform(utf8.decoder).join();
      final responseCheck = json.decode(responseString);
      // final responseCheck = json.decode(await response.stream.bytesToString());
      print("Response check -> $responseCheck");
      /*if (responseCheck["errorcode"] == 200) {
        print('200');*/
      return responseCheck;
      /*} else {
        print('else msg');
        throw Exception(responseCheck["message"]);
      }*/
      /*print("Response in getImageToolsResponse " +
          await response.stream.bytesToString());*/
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
      throw ("Failed getImageToolsResponse ${response.statusCode}");
    }
  }

  /*TOOLS REPLY*/
  Future<Map<String, dynamic>> getToolsReply(
      int userid, int ticketid, String questions, String isMobileApp) async {
    final url = '$baseUrl/gettoolsreply/';
    print(
        "Posting in api service $url, $userid, $ticketid, $questions, $isMobileApp");
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'userid': userid.toString(),
          'ticketid': ticketid.toString(),
          'questions': questions.toString(),
          'isMobileApp': "Y",
        },
      );
      print("Response  $response");
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        print("Response in getToolsReply " + response.body);
        return json.decode(response.body);
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        print("Response in getToolsReply ${response.body}");
        throw Exception('Failed to load data in getToolsReply');
      }
    } catch (e) {
      throw Exception("Failed getToolsReply $e");
    }
  }

  /*GET TOOLS DATA*/
  Future<Map<String, dynamic>> getToolsData(int userid, int ToolsID) async {
    final url = '$baseUrl/gettoolsdata/';
    print("Posting in api service $url, $userid, $ToolsID");
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'userid': userid.toString(),
          'ToolsID': ToolsID.toString(),
        },
      );
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        // if (kDebugMode) {
        //   print("Response in getToolsData " + Utf8Decoder().convert(response.bodyBytes));
        // }
        return json.decode(Utf8Decoder().convert(response.bodyBytes));
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load data in getToolsData');
      }
    } catch (e) {
      throw Exception("Failed getToolsData $e");
    }
  }

  /*GET TOOLS DATA BY CODE*/
  Future<Map<String, dynamic>> getToolsDataByCode(
      int userid, String toolsCode) async {
    final url = '$baseUrl/gettoolsdatabycode/';
    print("Posting in api service $url, $userid, $toolsCode");
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'userid': userid.toString(),
          'ToolsCode': toolsCode.toString(),
        },
      );
      print("Response  $response");
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        // print("Response in getToolsDataByCode " + response.body);
        return json.decode(response.body);
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load data in getToolsDataByCode');
      }
    } catch (e) {
      throw Exception("Failed getToolsDataByCode $e");
    }
  }

  Future<Map<String, dynamic>> getSubmitReaction(int userid, int reactingid,
      String reactiontype, String reactionfor) async {
    final url = '$baseUrl/submitreaction/';
    print(
        "Posting in api service $url, $userid, $reactingid, $reactiontype, $reactionfor");
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'vuserid': userid.toString(),
          'reactingid': reactingid.toString(),
          'reactiontype': reactiontype.toString(),
          'reactionfor': reactionfor.toString(),
        },
      );
      print("Response  $response");
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        print("Response in getSubmitReaction " + response.body);
        return json.decode(response.body);
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<TutorResponse> getTutors() async {
    final url = '$baseUrl/getTutors/';
    final uri = Uri.parse(url); // Adjust endpoint as needed
    // print(uri);

    try {
      final response = await http.post(uri);
      // print(response.body);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return TutorResponse.fromJson(jsonData);
      } else {
        return TutorResponse(
          errorCode: response.statusCode,
          message: "Error: Unable to fetch tutors",
          tutors: [],
        );
      }
    } catch (e) {
      return TutorResponse(
        errorCode: 500,
        message: "Exception: ${e.toString()}",
        tutors: [],
      );
    }
  }

  static Future<ChapterListDataModel?> getTutorsChapters(
      String classId, String subjectId) async {
    final url = Uri.parse("$baseUrl/getChapters/");
    final request = http.MultipartRequest("POST", url);
    request.fields["classId"] = classId;
    request.fields["SubjectID"] = subjectId;

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return ChapterListDataModel.fromJson(
            Utf8Decoder().convert(response.bodyBytes));
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<Map<String, dynamic>> getTutorResponse(
    int userid,
    String userName,
    String nextLesson,
    String TutorId,
    String className,
    String SubjectName,
    String courseTopic,
    String? sessionId,
    File? audioFile,
    String? answerText,
  ) async {
    print(
        "testing $userid , $userName , $TutorId, $className ,$SubjectName, $courseTopic, $audioFile, $answerText");
    try {
      final uri = Uri.parse("$baseUrl/Tutor/");

      // Build the request body dynamically
      var request = http.MultipartRequest('POST', uri)
        ..fields['userid'] = userid.toString()
        ..fields['userName'] = userName.toString()
        ..fields['TutorId'] = TutorId.toString()
        ..fields['className'] = className.toString()
        ..fields['SubjectName'] = SubjectName.toString()
        ..fields['courseTopic'] = courseTopic.toString();

      if (audioFile != null) {
        request.files.add(
            await http.MultipartFile.fromPath('audioFile', audioFile.path));
      }
      if (sessionId != null && sessionId.isNotEmpty) {
        request.fields['sessionID'] = sessionId.toString();
      }
      if (answerText != null && answerText.isNotEmpty) {
        request.fields['answerText'] = answerText.toString();
      }

      var response = await request.send();
      print("hello ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        // print(json.decode(responseBody));
        return json.decode(responseBody);
      } else {
        // Handle error
        return {'error': 'Failed to make API call'};
      }
      /*final response = await http.post(
        uri,
        body: body,
      );
      // print(response.body.toString());

      // var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.body;
        // print("hello course lesson list:${json.decode(responseBody)}");
        var finalResponse = Utf8Decoder().convert(response.bodyBytes);
        return json.decode(finalResponse);
      } else {
        throw Exception('Failed to load Data');
      }*/
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> getMathSolutionResponse(
    int userid,
    String gradeClass,
    String problemText,
  ) async {
    final url = '$baseUrl/SolvebanglaMath/';
    print("Posting in api service $url, $userid, $gradeClass, $problemText");
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'userid': userid.toString(),
          'gradeclass': gradeClass.toString(),
          'questiontext': problemText.toString(),
        },
      );
      print("Response  $response");
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        print("Response in getMathSolutionResponse " + response.body);
        return json.decode(response.body);
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load data in getMathSolutionResponse');
      }
    } catch (e) {
      throw Exception("Failed getMathSolutionResponse $e");
    }
  }

  Future<Map<String, dynamic>> getMathImageResponse(
    File questionImage,
    int userid,
    String gradeClass,
    String? questiontext,
  ) async {
    const url = '$baseUrl/SolvebanglaMath/';
    print(
        "Posting in api service $url $questionImage ,$userid, $gradeClass, $questiontext");

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['userid'] = userid.toString();
    request.fields['gradeclass'] = gradeClass.toString();
    request.fields['questiontext'] = questiontext.toString();
    request.files.add(
        await http.MultipartFile.fromPath('mathPhoto', questionImage!.path));
    print("QUESTIONIMAGEPATH: ${questionImage.path}");

    final response = await request.send();

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
      final responseString =
          await response.stream.transform(utf8.decoder).join();
      final responseCheck = json.decode(responseString);
      // final responseCheck = json.decode(await response.stream.bytesToString());
      print("Response check -> $responseCheck");
      /*if (responseCheck["errorcode"] == 200) {
        print('200');*/
      return responseCheck;
      /*} else {
        print('else msg');
        throw Exception(responseCheck["message"]);
      }*/
      /*print("Response in getImageToolsResponse " +
          await response.stream.bytesToString());*/
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
      throw ("Failed getImageToolsResponse ${response.statusCode}");
    }
  }
  Future<Map<String, dynamic>> getPackagesList(int userid) async {
    final url = '$baseUrl/getPackageList/';
    print("Posting in api service $url, $userid");
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'userId': userid.toString(),
          'subscriptionType': "A",
        },
      );
      print("Response:   ${response.body}");
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Response in getPackagesList else" + response.body);
        throw Exception('Failed to load data in getPackagesList');
      }
    } catch (e) {
      print("Response in getPackagesList Catch" + e.toString());
      throw Exception("Failed getPackagesList $e");
    }
  }
  Future<Map<String, dynamic>> getCouponDiscount({
    required String couponcode,
    required double amount,
  }) async {
    final url = '$baseUrl/getCouponDiscount';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'couponcode': couponcode.toString(),
          'amount': amount.toString(),
        },
      );
      print("Response  $response");
      if (response.statusCode == 200) {
        print("Response in api: ${json.decode(response.body)}");
        return json.decode(Utf8Decoder().convert(response.bodyBytes));
      } else {
        // Handle error
        return {'error': 'Failed to make API call'};
      }
    } catch (e) {
      // Handle exception
      return {'error': e.toString()};
    }
  }

  static Future<void> initiatePayment(
      int userId,
      int subscriptionid,
      String transactionid,
      double amount,
      double mainAmout,
      double couponDiscountAmt,
      int? CouponPartnerID,
      ) async {
    final url = '$baseUrl/initiatepayment';
    print("Posting in api service $url");
    try {
      /*final response = await http.post(
        Uri.parse(url),
        body: {
          'userid': userId.toString(),
          'subscriptionid': subscriptionid.toString(),
          'transactionid': transactionid.toString(),
          'amount': amount.toString(),
          'mainAmout': mainAmout.toString(),
          'couponDiscountAmt': couponDiscountAmt.toString(),
          'CouponPartnerID': CouponPartnerID.toString(),
        },
      );*/
      final Map<String, String> body = {
        'userid': userId.toString(),
        'subscriptionid': subscriptionid.toString(),
        'transactionid': transactionid,
        'amount': amount.toString(),
        'mainAmout': mainAmout.toString(),
        'couponDiscountAmt': couponDiscountAmt.toString(),
      };

      // Add CouponPartnerID only if it's not null
      if (CouponPartnerID != null) {
        body['CouponPartnerID'] = CouponPartnerID.toString();
      }

      final response = await http.post(
        Uri.parse(url),
        body: body,
      );

      print("Response:   ${response.statusCode}");
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Response in initiatePayment else" + response.body);
        throw Exception('Failed to load data in getPackagesList');
      }
    } catch (e) {
      print("Response in initiatePayment Catch" + e.toString());
      throw Exception("Failed getPackagesList $e");
    }
  }

  static Future<void> receivePayment(
      int userId,
      int subscriptionid,
      String transactionid,
      String transStatus,
      double amount,
      String storeamount,
      String cardno,
      String banktran_id,
      String currency,
      String card_issuer,
      String card_brand,
      String card_issuer_country,
      String risk_level,
      String risk_title,
      ) async {
    final url = '$baseUrl/receivepayment';
    print("Posting in api service $url");
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'userid': userId.toString(),
          'subscriptionid': subscriptionid.toString(),
          'paytransid': transactionid.toString(),
          'transStatus': transStatus.toString(),
          'amount': amount.toString(),
          'storeamount': storeamount.toString(),
          'cardno': cardno.toString(),
          'banktran_id': banktran_id.toString(),
          'currency': currency.toString(),
          'card_issuer': card_issuer.toString(),
          'card_brand': card_brand.toString(),
          'card_issuer_country': card_issuer_country.toString(),
          'risk_level': risk_level.toString(),
          'risk_title': risk_title.toString(),
        },
      );
      print("Response:   ${response.statusCode}");
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Response in receivePayment else" + response.body);
        throw Exception('Failed to load data in getPackagesList');
      }
    } catch (e) {
      print("Response in receivePayment Catch" + e.toString());
      throw Exception("Failed getPackagesList $e");
    }
  }

  Future<Map<String, dynamic>> getDeleteResponse(
      int userid,
      String reason,
      ) async {
    final url = '$baseUrl/deleteuser/';
    print("Posting in api service $url");
    print("$userid , $reason");
    try {
      final Map<String, dynamic> body = {
        'id': userid.toString(),
      };
      final response = await http.post(
        Uri.parse(url),
        body: body,
      );
      print("Response: ${response.body}");
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Response in getDeleteResponse else" + response.body);
        throw Exception('Failed to load data in getPackagesList');
      }
    } catch (e) {
      print("Response in getPackagesList Catch" + e.toString());
      throw Exception("Failed getPackagesList $e");
    }
  }
}
