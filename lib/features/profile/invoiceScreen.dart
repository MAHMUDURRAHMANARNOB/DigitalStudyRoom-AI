import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
/*
import 'package:shurjopay/models/config.dart';
import 'package:shurjopay/models/payment_verification_model.dart';
import 'package:shurjopay/models/shurjopay_request_model.dart';
import 'package:shurjopay/models/shurjopay_response_model.dart';
import 'package:shurjopay/shurjopay.dart';
import 'package:shurjopay/utilities/functions.dart';*/
import 'package:shurjopay/models/config.dart';
import 'package:shurjopay/models/payment_verification_model.dart';
import 'package:shurjopay/models/shurjopay_request_model.dart';
import 'package:shurjopay/models/shurjopay_response_model.dart';
import 'package:shurjopay/shurjopay.dart';
import 'package:shurjopay/utilities/functions.dart';

import '../../api/api_controller.dart';
import '../../utils/constants/colors.dart';
import '../authentication/providers/AuthProvider.dart';
import 'Providers/coupnDiscountProvider.dart';


class InvoiceScreenMobile extends StatefulWidget {
  final int packageID;
  final String packageName;
  final double packageValue;
  final double discountValue;
  final double payableAmount;

  const InvoiceScreenMobile({
    Key? key,
    required this.packageID,
    required this.packageName,
    required this.packageValue,
    required this.discountValue,
    required this.payableAmount,
  }) : super(key: key);

  @override
  State<InvoiceScreenMobile> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreenMobile> {
  late String status = "nothing";
  late int generatedTransectionId = 0;
  late int userID = 0;
  late int _packageID;
  late String _packageName;
  late double _packageValue;
  late double _discountValue;
  late double _payableAmount;

  late double _mainAmount;
  late double _amount;
  late double _couponDiscountAmount = 0.0;
  late int? _couponPartnerId = null;

  bool _isApplied = false;

  late TextEditingController couponCodeController = TextEditingController();

  CouponDiscountProvider couponDiscountProvider = CouponDiscountProvider();
  late ShurjoPay shurjoPay;
  late ShurjopayConfigs shurjopayConfigs;

  StreamSubscription? _purchaseUpdatedSubscription;



  List<String> _productIds = [
    'starter_pack',
    'monthly_pack',
    'quarterly_pack',
    'semiannual_pack',
    'annual_pack'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _packageID = widget.packageID;
    _packageName = widget.packageName;
    _packageValue = widget.packageValue;
    _discountValue = widget.discountValue;
    _payableAmount = widget.payableAmount;
    _mainAmount = widget.payableAmount;
    _isApplied = false;

    /*initPlatformState();
    setupPurchaseListener();*/

    shurjoPay = ShurjoPay();
    shurjopayConfigs = ShurjopayConfigs(
      /*prefix: "TLH",
      userName: "TalentLensHub",
      password: "talety4r5p8mpz&v",
      clientIP: "127.0.0.1",*/
      prefix: "RIG",
      userName: "Risho.Guru",
      password: "rishyqb8\$ts&\$#dn",
      clientIP: "127.0.0.1",
    );
    // _loadPaymentConfiguration();
  }

  @override
  void dispose() {
    _purchaseUpdatedSubscription?.cancel();
    // FlutterInappPurchase.instance.finalize();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    userID = authProvider.user!.id;

    /*if (Platform.isIOS && defaultApplePayConfig == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }*/

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left),
        ),
        title: const Text(
          "Invoice",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: /*ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          IAPItem product = _products[index];
          return ListTile(
            title: Text(product.title!),
            subtitle: Text("${product.description}\nPrice: ${product.price}"),
            trailing: ElevatedButton(
              onPressed: () => makePurchase(product),
              child: Text("Buy"),
            ),
          );
        },
      ),*/

      SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Purchase Invoice",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: TColors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.white),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("PackageID "),
                      Text("${widget.packageID}"),
                    ],
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "PackageName ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        _packageName,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Base Price ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        _packageValue.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Discount ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        _discountValue.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Main Amount ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        _mainAmount.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Coupon Discount ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        _couponDiscountAmount.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Payable Amount ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        _payableAmount.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: TColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "TransectionId",
                        style: TextStyle(fontSize: 16),
                      ),
                      status == "true"
                          ? Text(
                        "$generatedTransectionId",
                        style: const TextStyle(fontSize: 16),
                      )
                          : const Text(
                        "No transaction yet",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            status == "true"
                ? const SizedBox(width: 2)
                : Visibility(
              visible: !_isApplied,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Coupon Code",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextField(
                      controller: couponCodeController,
                      keyboardType: TextInputType.text,
                      cursorColor: TColors.primaryColor,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          FontAwesomeIcons.ticketAlt,
                          color: Colors
                              .grey[900], // Change the color of the icon
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        hintText: 'Your coupon code here',
                        filled: true,
                        fillColor: Colors.grey[200],
                        // Background color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Border radius
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: TColors
                                  .primaryColor), // Border color when focused
                          borderRadius: BorderRadius.circular(
                              8.0), // Border radius when focused
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 15.0),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 1,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors
                                .primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          onPressed: () {
                            _handleApplyButton(context);
                          },
                          child: const Text(
                            "Apply",
                            style: TextStyle(
                              color: TColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            status == "true"
                ? Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: TColors.secondaryColor,
                  borderRadius: BorderRadius.circular(8)),
              child: const Text(
                "Purchased Successfully,\n Now you can continue your study.",
                textAlign: TextAlign.center,
                style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
                : Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                onPressed: () {
                  generatedTransectionId =
                      DateTime.now().millisecondsSinceEpoch;
                  if (kDebugMode) {
                    print("$generatedTransectionId");
                  }
                  setState(() {
                    generatedTransectionId;
                  });
                  print(
                      "$userID, $_packageID, ${generatedTransectionId.toString()}, $_payableAmount, $_mainAmount, $_couponDiscountAmount, $_couponPartnerId,");
                  ApiController.initiatePayment(
                    userID,
                    _packageID,
                    generatedTransectionId.toString(),
                    _payableAmount,
                    _mainAmount,
                    _couponDiscountAmount,
                    _couponPartnerId,
                  );
                  _initiatePayment();
                },
                child: const Text(
                  "Purchase Subscription",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            /*Visibility(
              visible: Platform.isIOS,
              child: ApplePayButton(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                height: 40,
                onPressed: () async {
                  generatedTransectionId =
                      DateTime.now().millisecondsSinceEpoch;
                  if (kDebugMode) {
                    print("apple g tran id: $generatedTransectionId");
                  }
                  setState(() {
                    generatedTransectionId;
                  });
                  ApiController.initiatePayment(
                    userID,
                    _packageID,
                    generatedTransectionId.toString(),
                    _payableAmount,
                    _mainAmount,
                    _couponDiscountAmount,
                    _couponPartnerId,
                  );
                  print("pressed");
                },
                paymentConfiguration: defaultApplePayConfig,
                paymentItems: [
                  PaymentItem(
                    label: _packageName,
                    amount: _payableAmount.toString(),
                    // Example amount in USD
                    status: PaymentItemStatus.final_price,
                  ),
                ],
                style: ApplePayButtonStyle.white,
                // Button style
                type: ApplePayButtonType.subscribe,
                // Button type
                onPaymentResult: onApplePayResult,
                // Payment result callback
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),*/
            /*Visibility(
              visible: Platform.isIOS,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                child: ElevatedButton(
                  onPressed: () async {
                    generatedTransectionId =
                        DateTime.now().millisecondsSinceEpoch;

                    if (kDebugMode) {
                      print(
                          "Generated Transaction ID: $generatedTransectionId");
                    }
                    // Initiate payment on backend
                    ApiController.initiatePayment(
                      userID,
                      _packageID,
                      generatedTransectionId.toString(),
                      _payableAmount,
                      _mainAmount,
                      _couponDiscountAmount,
                      _couponPartnerId,
                    );

                    // Initiate In-App Purchase using flutter_inapp_purchase
                    */ /*try {
                      print("Pressed");
                      await FlutterInappPurchase.instance
                          .requestPurchase(_packageID.toString());
                      print("Purchase initiated for package: $_packageID");
                    } catch (e) {
                      print("Error initiating purchase: $e");
                    }*/ /*
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    // Similar style to Apple Pay button
                    minimumSize: const Size.fromHeight(40), // Button height
                  ),
                  child: Text(
                    "Purchase $_packageName for $_payableAmount",
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            )*/
          ],
        ),
      ),
    );
  }

  Future<double> convertBdtToUsd(double amountInBdt) async {
    // Call the conversion API and get the rate
    double conversionRate = 0.011; // Example conversion rate BDT to USD
    return amountInBdt * conversionRate;
  }

  void onApplePayResult(paymentResult) {
    if (kDebugMode) {
      print("Amount in USD: ${_payableAmount.toString()}");
      print(paymentResult.toString()); // Handle the successful payment here
    }

    // You can send this paymentResult to your server for verification
    // Assuming paymentResult contains a payment token
    final String? paymentToken = paymentResult['token'];
    print("paymentToken: $paymentToken");
    // Send this token to your server for processing
    // final response = await processPaymentOnServer(paymentToken);
    // Handle the server response
    /*if (response.success) {
      print("Payment Successful");
      // Perform actions on success, e.g., show a confirmation message
    } else {
      print("Payment Failed: ${response.errorMessage}");
      // Handle payment failure, e.g., show an error message
    }*/
  }

  void _handleApplyButton(BuildContext context) async {
    if (couponCodeController.text.isNotEmpty) {
      // Call the function to fetch coupon discount
      showDialog(
        context: context,
        barrierDismissible:
        false, // Prevents dismissing the dialog when tapped outside
        builder: (BuildContext context) {
          return Center(
            child: /*SpinKitDancingSquare(
              color: TColors.primaryColor,
            ),*/
            AlertDialog(
              contentPadding: const EdgeInsets.all(10.0),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/images/risho_guru_icon.png",
                    width: 80,
                    height: 80,
                  ),
                  const SpinKitThreeInOut(
                    color: TColors.primaryColor,
                  ),
                ],
              ),
            ),
          );
        },
      );
      await fetchCouponDiscount(context);
    } else {
      _showAlertDialog(
        context,
        'Oops!',
        'You have to write a valid Coupon code first.',
        const Icon(
          Icons.report_gmailerrorred_rounded,
          color: Colors.red,
          size: 30,
        ),
      );
    }
  }

  void _showAlertDialog(
      BuildContext context, String title, String content, Icon icons) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: icons,
          title: Text(
            title,
            style: title == "Sweet!"
                ? const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 34,
              color: TColors.primaryColor,
            )
                : const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 34,
              color: Colors.redAccent,
            ),
          ),
          content: Text(content),
        );
      },
    );
  }

  Future<void> fetchCouponDiscount(BuildContext context) async {
    try {
      await couponDiscountProvider.fetchCouponDiscountResponse(
        couponCodeController.text,
        widget.payableAmount,
      );

      // Access the response data using the provider
      int errorCode = couponDiscountProvider.couponDiscountResponse!.errorCode;
      String message = couponDiscountProvider.couponDiscountResponse!.message;
      double discountReceivable =
          couponDiscountProvider.couponDiscountResponse!.discountReceivable;
      double discount = couponDiscountProvider.couponDiscountResponse!.discount;
      int? partnerId = couponDiscountProvider.couponDiscountResponse!.partnerId;

      setState(() {
        _payableAmount = _payableAmount - discountReceivable;
        // _discountValue = discountReceivable;
        _couponDiscountAmount = discountReceivable;
        if (partnerId != null) {
          _couponPartnerId = partnerId;
        }
      });
      if (kDebugMode) {
        print(
            "payable amount$_payableAmount - Discount from coupon $_couponDiscountAmount");
      }

      Navigator.of(context).pop();
      if (errorCode == 200) {
        setState(() {
          _isApplied = true;
        });
        _showAlertDialog(
          context,
          "Sweet!",
          "You are going to receive BDT: $discount% discount",
          const Icon(
            FontAwesomeIcons.checkCircle,
            color: TColors.primaryColor,
            size: 30,
          ),
        );
      } else if (errorCode == 400) {
        _showAlertDialog(
          context,
          "Oops!",
          message,
          const Icon(
            Icons.report_gmailerrorred_rounded,
            color: Colors.red,
            size: 30,
          ),
        );
      } else {
        _showAlertDialog(
          context,
          "Oops!",
          message,
          const Icon(
            Icons.report_gmailerrorred_rounded,
            color: Colors.red,
            size: 30,
          ),
        );
      }
    } catch (error) {
      _showAlertDialog(
        context,
        "Error",
        error.toString(),
        const Icon(
          Icons.report_gmailerrorred_rounded,
          color: Colors.red,
          size: 30,
        ),
      );
    }
  }

  void _initiatePayment() async {
    // Initialize shurjopay
    /*ShurjoPay shurjoPay = ShurjoPay();*/
    // ShurjoPay _shurjoPayService = ShurjopayRequestModel(configs: configs, currency: currency, amount: amount, orderID: orderID, customerName: customerName, customerPhoneNumber: customerPhoneNumber, customerAddress: customerAddress, customerCity: customerCity, customerPostcode: customerPostcode, returnURL: returnURL, cancelURL: cancelURL);
    // initializeShurjopay(environment: "live");
    /*ShurjoPay shurjoPay = ShurjoPay();
    ShurjopayConfigs shurjopayConfigs = ShurjopayConfigs(
      */ /*prefix: "TLH",
      userName: "TalentLensHub",
      password: "talety4r5p8mpz&v",
      clientIP: "127.0.0.1",*/ /*
      prefix: "RIG",
      userName: "Risho.Guru",
      password: "rishyqb8\$ts&\$#dn",
      clientIP: "127.0.0.1",
    );*/

    final shurjopayRequestModel = ShurjopayRequestModel(
        configs: shurjopayConfigs,
        currency: "BDT",
        amount: _payableAmount,
        orderID: generatedTransectionId.toString(),
        customerName: "widget.packageName",
        customerPhoneNumber: "01751111111",
        customerAddress: "Bangladesh",
        customerCity: "Dhaka",
        customerPostcode: "1230",
        returnURL: "https://www.sandbox.shurjopayment.com/return_url",
        cancelURL: "https://www.sandbox.shurjopayment.com/cancel_url");

    ShurjopayResponseModel shurjopayResponseModel = ShurjopayResponseModel();

    shurjopayResponseModel = await shurjoPay.makePayment(
      context: context,
      shurjopayRequestModel: shurjopayRequestModel,
    );
    if (kDebugMode) {
      print(shurjopayResponseModel.errorCode);
    }

    ShurjopayVerificationModel shurjopayVerificationModel =
    ShurjopayVerificationModel();
    if (shurjopayResponseModel.status == true) {
      try {
        // Initiate payment
        shurjopayVerificationModel = await shurjoPay.verifyPayment(
          orderID: shurjopayResponseModel.shurjopayOrderID!,
        );
        if (kDebugMode) {
          print(shurjopayVerificationModel.spCode);
        }
        if (kDebugMode) {
          print(shurjopayVerificationModel.spMessage);
        }
        if (shurjopayVerificationModel.spCode == "1000") {
          if (kDebugMode) {
            print(
                "Payment Varified - ${shurjopayVerificationModel.spMessage}, ${shurjopayVerificationModel.spCode}");
          }
        } else {
          if (kDebugMode) {
            print(
                "Payment not Varified - ${shurjopayVerificationModel.spMessage}, ${shurjopayVerificationModel.spCode}");
          }
        }

        // Handle payment response
        if (shurjopayVerificationModel.spCode.toString() == "1000") {
          ApiController.receivePayment(
            userID,
            _packageID,
            generatedTransectionId.toString(),
            shurjopayVerificationModel.spCode == "1000" ? "VALID" : "FAILED",
            //STATUS
            double.tryParse(shurjopayVerificationModel.amount != null
                ? shurjopayVerificationModel.amount!
                : "0")!,
            //amount
            shurjopayVerificationModel.receivedAmount != null
                ? shurjopayVerificationModel.receivedAmount.toString()
                : "0",
            //store amount
            shurjopayVerificationModel.cardNumber != null
                ? shurjopayVerificationModel.cardNumber!
                : "null",
            //cardNumber
            shurjopayVerificationModel.bankTrxId != null
                ? shurjopayVerificationModel.bankTrxId!
                : "null",
            //bankTranId
            shurjopayVerificationModel.currency != null
                ? shurjopayVerificationModel.currency!
                : "null",
            //currencyType
            shurjopayVerificationModel.cardHolderName != null
                ? shurjopayVerificationModel.cardHolderName!
                : "null",
            //cardIssuer
            shurjopayVerificationModel.bankStatus != null
                ? shurjopayVerificationModel.bankStatus!
                : "null",
            //cardBrand
            shurjopayVerificationModel.transactionStatus != null
                ? shurjopayVerificationModel.transactionStatus!
                : "null",
            //cardIssuerCountry
            shurjopayVerificationModel.spCode != null
                ? shurjopayVerificationModel.spCode!
                : "null",
            //riskLevel
            shurjopayVerificationModel.spMessage != null
                ? shurjopayVerificationModel.spMessage!
                : "null", //risk title
          );
          setState(() {
            status = "true";
          });
          Fluttertoast.showToast(
            msg:
            "Transaction successful. Transaction ID: ${shurjopayVerificationModel.bankTrxId}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        } else if (shurjopayVerificationModel.spCode.toString() == "1011" ||
            shurjopayVerificationModel.spCode.toString() == "1002") {
          setState(() {
            status = "false";
          });
          Fluttertoast.showToast(
            msg: "Transaction closed by user.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        } else {
          setState(() {
            status = "false";
          });
          Fluttertoast.showToast(
            msg: "Transaction failed.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
          // Perform any actions after successful payment (e.g., navigate to success screen)
        }
      } catch (e) {
        debugPrint(e.toString());
        Fluttertoast.showToast(
          msg: "Error occurred during payment.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    }
  }
}
