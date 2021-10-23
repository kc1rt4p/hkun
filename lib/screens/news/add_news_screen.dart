import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hkun/helpers/size_config.dart';
import 'package:hkun/models/news_model.dart';
import 'package:hkun/screens/news/bloc/news_bloc.dart';
import 'package:hkun/services/image_service.dart';
import 'package:hkun/utilities/dialogs.dart';
import 'package:intl/intl.dart';

class AddNewsScreen extends StatefulWidget {
  const AddNewsScreen({Key? key}) : super(key: key);

  @override
  _AddNewsScreenState createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends State<AddNewsScreen> {
  final _newsBloc = NewsBloc();
  File? _selectedFile;

  final titleTextController = TextEditingController();
  final contentTextController = TextEditingController();
  final dateTextController = TextEditingController();

  DateTime? _selectedDate;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        margin: EdgeInsets.only(top: SizeConfig.paddingTop),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      child: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 40.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    'Add News',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocListener(
                bloc: _newsBloc,
                listener: (context, state) {
                  if (state is LoadingNews) {
                    Dialogs.showLoadingDialog(context);
                  } else {
                    Navigator.pop(context);
                  }

                  if (state is NewsAddSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'New entry added to News List',
                        style: TextStyle(color: Colors.green.shade400),
                      ),
                    ));
                    titleTextController.clear();
                    contentTextController.clear();
                    dateTextController.clear();
                    setState(() {
                      _selectedFile = null;
                    });
                  }
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 16.0),
                          height: SizeConfig.screenHeight * .25,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            image: _selectedFile != null
                                ? DecorationImage(
                                    image: FileImage(_selectedFile!),
                                    fit: BoxFit.fill,
                                  )
                                : null,
                          ),
                          child: _selectedFile != null
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Image.file(_selectedFile!),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: InkWell(
                                        onTap: () =>
                                            _handleSelectImage(context),
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        child: Container(
                                          height: 40.0,
                                          width: 40.0,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 2.0,
                                                spreadRadius: 1.0,
                                              ),
                                            ],
                                          ),
                                          child: Icon(Icons.image),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : InkWell(
                                  onTap: () => _handleSelectImage(context),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey,
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image,
                                          size: 55.0,
                                        ),
                                        SizedBox(height: 15.0),
                                        Text(
                                          'Tap to select an image',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildTextFormField(
                                label: 'Title',
                                controller: titleTextController,
                                hintText: 'Enter news title',
                                minLines: 1,
                                maxLines: 1,
                              ),
                              _buildTextFormField(
                                label: 'Content',
                                controller: contentTextController,
                                hintText: 'Enter news content',
                                keyboardType: TextInputType.multiline,
                              ),
                              _buildTextFormField(
                                label: 'Date',
                                controller: dateTextController,
                                hintText: 'Tap to select date',
                                keyboardType: TextInputType.multiline,
                                isDate: true,
                                readOnly: true,
                                onTap: _selectDate,
                              ),
                              SizedBox(height: 32.0),
                              InkWell(
                                onTap: _handleSubmit,
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
                                        fontWeight: FontWeight.bold,
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select an image',
            style: TextStyle(color: Colors.red.shade300),
          ),
        ),
      );
      return;
    }

    _newsBloc.add(NewsAdd(
        NewsModel(
          title: titleTextController.text.trim(),
          content: contentTextController.text.trim(),
          date: _selectedDate,
        ),
        _selectedFile!));
  }

  _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: (365 * 5))),
    );

    if (date == null) return;

    final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: false,
            ),
            child: child!,
          );
        });

    if (time == null) return;

    _selectedDate = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    dateTextController.text =
        DateFormat('MMM. dd, yyyy hh:mm a').format(_selectedDate!);
  }

  Container _buildTextFormField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    bool readOnly = false,
    Function()? onTap,
    bool isDate = false,
    TextInputType? keyboardType,
    int? maxLines,
    int? minLines,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5.0),
          TextFormField(
            maxLines: maxLines,
            minLines: minLines,
            keyboardType: keyboardType ?? TextInputType.text,
            onTap: onTap,
            controller: controller,
            readOnly: readOnly,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14.0,
              ),
              isDense: true,
              isCollapsed: true,
              errorStyle: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.red.shade300,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 0.6,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 0.6,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 0.6,
                ),
              ),
              suffixIcon: isDate
                  ? Column(
                      children: [
                        Icon(
                          FontAwesomeIcons.calendar,
                          color: Colors.white,
                        ),
                      ],
                    )
                  : null,
              suffixIconConstraints: BoxConstraints(
                maxHeight: 30.0,
              ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (val) => val!.isEmpty ? 'Required' : null,
          ),
        ],
      ),
    );
  }

  _handleSelectImage(BuildContext context) async {
    final file = await ImageService().pickImage(context);
    if (file == null) return;

    setState(() {
      _selectedFile = file;
    });
  }
}
