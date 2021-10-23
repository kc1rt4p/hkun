import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hkun/bloc/bloc/auth_bloc.dart';
import 'package:hkun/helpers/size_config.dart';
import 'package:hkun/models/news_model.dart';
import 'package:hkun/screens/news/bloc/news_bloc.dart';
import 'package:hkun/utilities/dialogs.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late NewsBloc _newsBloc;
  List<NewsModel> _newsList = [];
  late AuthBloc _authBloc;

  NewsModel? _selectedNews;

  bool _isAuthenticated = false;

  List<NewsModel> _toDeleteList = [];

  final _refController = RefreshController();

  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _newsBloc = BlocProvider.of<NewsBloc>(context);
    _authBloc.add(AuthInitialize());
    _newsBloc.add(NewsGetList());
    super.initState();
  }

  @override
  void dispose() {
    _toDeleteList.clear();
    _newsBloc.add(AddDeleteItem(_toDeleteList));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MultiBlocListener(
      listeners: [
        BlocListener(
          bloc: _newsBloc,
          listener: (context, state) {
            print('news screen state: $state');
            if (state is LoadingNews) {
              Dialogs.showLoadingDialog(context);
            } else {
              Navigator.pop(context);
            }

            if (state is NewsGetListSuccess) {
              setState(() {
                _newsList = state.list;
                if (_newsList.isNotEmpty) {
                  _selectedNews = _newsList[0];
                }
              });
            }

            if (state is NewsDeleteSuccess) {
              _newsBloc.add(NewsGetList());
              setState(() {
                _toDeleteList.clear();
              });
            }
          },
        ),
        BlocListener(
          bloc: _authBloc,
          listener: (context, state) {
            if (state is AuthLoginSuccess) {
              setState(() {
                _isAuthenticated = true;
              });
            }

            if (state is AuthLogoutSuccess) {
              setState(() {
                _isAuthenticated = false;
              });
            }
          },
        ),
      ],
      child: SmartRefresher(
        controller: _refController,
        onRefresh: () {
          _newsBloc.add(NewsGetList());
          _refController.refreshCompleted();
        },
        child: SingleChildScrollView(
          child: _newsList.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._buildNewsList(),
                  ],
                )
              : Container(
                  margin: EdgeInsets.only(top: SizeConfig.screenHeight * .25),
                  child: Text(
                    'No news found',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  List<Widget> _buildNewsList() {
    List<Widget> widgetList = [];

    _newsList.asMap().forEach((key, value) {
      if (value == _selectedNews) {
        widgetList.add(
          Row(
            children: [
              Visibility(
                visible: _isAuthenticated,
                child: Row(
                  children: [
                    _customCheckbox(value),
                    SizedBox(width: 12.0),
                  ],
                ),
              ),
              Expanded(child: _buildMainNewsItem(value)),
            ],
          ),
        );
      } else {
        widgetList.add(
          Row(
            children: [
              Visibility(
                visible: _isAuthenticated,
                child: Row(
                  children: [
                    _customCheckbox(value),
                    SizedBox(width: 12.0),
                  ],
                ),
              ),
              Expanded(child: _buildNewsItem(value)),
            ],
          ),
        );
      }
    });

    return widgetList;
  }

  Container _buildMainNewsItem(NewsModel news) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Color(0xFF1C1C1E),
      ),
      child: Column(
        children: [
          Container(
            height: SizeConfig.screenHeight * .25,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,
              image: DecorationImage(
                image: NetworkImage(news.imgUrl!),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title!,
                  style: TextStyle(
                    height: 1.2,
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.0),
                Text(
                  news.content!,
                  style: TextStyle(
                    color: Color(0xFFBDBDBD),
                  ),
                ),
                SizedBox(height: 12.0),
                Text(
                  DateFormat('dd MMM yyyy hh:mm a').format(news.date!),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      if (_selectedNews == news) {
                        setState(() => _selectedNews = null);
                      } else {
                        setState(() => _selectedNews = news);
                      }
                    },
                    child: Text(
                      _selectedNews != news ? 'View all details' : 'View less',
                      style: TextStyle(
                        color: Color(0xFF828282),
                        decoration: TextDecoration.underline,
                        fontSize: 11.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildNewsItem(NewsModel news) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
      padding: EdgeInsets.all(10.0),
      height: SizeConfig.screenHeight * .12,
      decoration: BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                Text(
                  DateFormat('dd').format(news.date!),
                  style: TextStyle(
                    color: Color(0xFFBDBDBD),
                    fontWeight: FontWeight.w700,
                    fontSize: 26.0,
                    height: 1.5,
                  ),
                ),
                Text(
                  DateFormat('MMM').format(news.date!),
                  style: TextStyle(
                    color: Color(0xFFBDBDBD),
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    height: 1.0,
                  ),
                ),
                Text(
                  DateFormat('hh:mm').format(news.date!),
                  style: TextStyle(
                    color: Color(0xFFBDBDBD),
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: VerticalDivider(
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      height: 1.2,
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    news.content!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: Color(0xFFBDBDBD),
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        if (_selectedNews == news) {
                          setState(() => _selectedNews = null);
                        } else {
                          setState(() => _selectedNews = news);
                        }
                      },
                      child: Text(
                        _selectedNews != news
                            ? 'View all details'
                            : 'View less',
                        style: TextStyle(
                          color: Color(0xFF828282),
                          decoration: TextDecoration.underline,
                          fontSize: 11.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customCheckbox(NewsModel news) {
    return InkWell(
      onTap: () {
        setState(() {
          if (_toDeleteList.contains(news)) {
            _toDeleteList.remove(news);
          } else {
            _toDeleteList.add(news);
          }
        });
        _newsBloc.add(AddDeleteItem(_toDeleteList));
      },
      child: Container(
        padding: EdgeInsets.all(3.0),
        height: 25.0,
        width: 25.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.black,
          border: Border.all(color: Colors.white),
        ),
        child: _toDeleteList.contains(news)
            ? Center(
                child: Icon(
                  Icons.check,
                  color: Color(0xFFBDBDBD),
                  size: 14.0,
                ),
              )
            : null,
      ),
    );
  }
}
