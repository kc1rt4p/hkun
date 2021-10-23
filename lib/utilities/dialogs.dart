import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hkun/helpers/size_config.dart';
import 'package:hkun/services/validator_service.dart';

class Dialogs {
  static Future<String?> promptUserWalletAddress(BuildContext context) async {
    final addressTextController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    SizeConfig().init(context);
    return await showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: SizeConfig.screenWidth * .9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context, null),
                      child: Container(
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wallet Address',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: addressTextController,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 10.0,
                                  ),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  errorStyle: TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                  hintText: 'Enter wallet address',
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          final clipBoardData =
                                              await Clipboard.getData(
                                                  Clipboard.kTextPlain);
                                          if (clipBoardData == null) return;
                                          addressTextController.text =
                                              clipBoardData.text!;
                                        },
                                        child: Icon(Icons.paste,
                                            color: Colors.white),
                                      ),
                                      SizedBox(width: 8.0),
                                      GestureDetector(
                                        onTap: () {
                                          addressTextController.clear();
                                        },
                                        child: Icon(Icons.clear,
                                            color: Colors.white),
                                      ),
                                      SizedBox(width: 8.0),
                                    ],
                                  ),
                                ),
                                validator: (val) {
                                  if (val == null || val.isEmpty)
                                    return 'Required';

                                  if (!ValidatorService.isAddress(val)) {
                                    return 'Invalid wallet address';
                                  }
                                },
                              ),
                            ),
                          ),
                          // SizedBox(width: 5.0),
                          // InkWell(
                          //   onTap: () async {
                          //     final clipBoardData =
                          //         await Clipboard.getData(Clipboard.kTextPlain);
                          //     if (clipBoardData == null) return;
                          //     addressTextController.text = clipBoardData.text!;
                          //   },
                          //   child: Container(
                          //     padding: EdgeInsets.all(5.0),
                          //     child: Container(
                          //       padding: EdgeInsets.symmetric(
                          //         horizontal: 10.0,
                          //         vertical: 8.0,
                          //       ),
                          //       decoration: BoxDecoration(
                          //         color: Colors.white,
                          //         borderRadius: BorderRadius.circular(10.0),
                          //       ),
                          //       child: FaIcon(
                          //         FontAwesomeIcons.paste,
                          //         color: Colors.black,
                          //         size: 18.0,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(height: 32.0),
                      InkWell(
                        onTap: () {
                          if (!_formKey.currentState!.validate()) return;
                          final address = addressTextController.text.trim();

                          Navigator.pop(context, address);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(color: Colors.grey),
                              BoxShadow(color: Colors.grey),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<Map<String, dynamic>?> showLoginDialog(
      BuildContext context) async {
    final usernameTextController = TextEditingController();
    final passwordTextController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Admin Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Container(
                    margin: EdgeInsets.only(bottom: 14.0),
                    width: double.infinity,
                    child: TextFormField(
                      controller: usernameTextController,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 10.0,
                        ),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                        hintText: 'Enter email address',
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Required';
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: TextFormField(
                      controller: passwordTextController,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 10.0,
                        ),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                        hintText: 'Enter password',
                      ),
                      obscureText: true,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Required';
                      },
                    ),
                  ),
                  SizedBox(height: 24.0),
                  InkWell(
                    onTap: () {
                      if (!_formKey.currentState!.validate()) return;
                      Navigator.pop(context, {
                        'email': usernameTextController.text.trim(),
                        'password': passwordTextController.text.trim(),
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  InkWell(
                    onTap: () => Navigator.pop(context, null),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: FittedBox(
                  child: Image.asset(
                    'assets/gifs/loader.gif',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
