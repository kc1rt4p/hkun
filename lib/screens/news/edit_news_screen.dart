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

class EditNewsScreen extends StatefulWidget {
  final NewsModel news;
  const EditNewsScreen({
    Key? key,
    required this.news,
  }) : super(key: key);

  @override
  _EditNewsScreenState createState() => _EditNewsScreenState();
}

class _EditNewsScreenState extends State<EditNewsScreen> {
  final _newsBloc = NewsBloc();
  final titleTextController = TextEditingController();
  final contentTextController = TextEditingController();
  final dateTextController = TextEditingController();
  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormState>();
  File? _selectedFile;
  late NewsModel _news;

  @override
  void initState() {
    _news = widget.news;
    titleTextController.text = _news.title!;
    contentTextController.text = _news.content!;
    dateTextController.text =
        DateFormat('MMM. dd, yyyy hh:mm a').format(_news.date!);
    _selectedDate = _news.date;
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
                    'Edit News',
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

                  if (state is NewsUpdateSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'News item has been updated',
                        style: TextStyle(color: Colors.green.shade400),
                      ),
                    ));
                    Navigator.pop(context);
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
                            image: _selectedFile == null
                                ? DecorationImage(
                                    image: NetworkImage(_news.imgUrl!),
                                    fit: BoxFit.fill,
                                  )
                                : DecorationImage(
                                    image: FileImage(_selectedFile!),
                                    fit: BoxFit.fill,
                                  ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Image.file(_selectedFile!),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: InkWell(
                                  onTap: () => _handleSelectImage(context),
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Container(
                                    height: 40.0,
                                    width: 40.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(50.0),
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
                              Visibility(
                                visible: _selectedFile != null,
                                child: Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedFile = null;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(50.0),
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
                                      child: Icon(Icons.undo),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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

  _handleSubmit() {
    final _newsUpdate = NewsModel(
      id: _news.id,
      title: titleTextController.text.trim(),
      content: contentTextController.text.trim(),
      date: _selectedDate,
      imgUrl: _news.imgUrl,
    );

    if (!_formKey.currentState!.validate()) return;

    _newsBloc.add(NewsUpdate(_newsUpdate, _selectedFile));
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
