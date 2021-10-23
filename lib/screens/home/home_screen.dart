import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hkun/bloc/bloc/auth_bloc.dart';
import 'package:hkun/bloc/wallet/wallet_bloc.dart';
import 'package:hkun/helpers/size_config.dart';
import 'package:hkun/models/news_model.dart';
import 'package:hkun/screens/dashboard/dashboard_screen.dart';
import 'package:hkun/screens/markets/markets_screen.dart';
import 'package:hkun/screens/my_hkun/my_hkun_screen.dart';
import 'package:hkun/screens/news/add_news_screen.dart';
import 'package:hkun/screens/news/bloc/news_bloc.dart';
import 'package:hkun/screens/news/edit_news_screen.dart';
import 'package:hkun/screens/news/news_screen.dart';
import 'package:hkun/utilities/dialogs.dart';
import 'package:hkun/widgets/drawer.dart';
import 'package:hkun/widgets/gradient_text.dart';

final gradientColor = LinearGradient(
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  tileMode: TileMode.mirror,
  colors: [
    Color(0xFFC30080),
    Color(0xFFF17737),
  ],
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isAuthenticated = false;
  int _currentIndex = 0;
  bool _loadingOut = false;

  List<Widget> _screens = [
    DashboardScreen(),
    MarketsScreen(),
    MyHKUNScreen(),
    NewsScreen(),
  ];

  bool _darkMode = false;

  List<NewsModel> _toDeleteList = [];

  final _authBloc = AuthBloc();
  final _newsBloc = NewsBloc();
  final _walletBloc = WalletBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => _newsBloc),
            BlocProvider(create: (context) => _authBloc),
            BlocProvider(create: (context) => _walletBloc),
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener(
                bloc: _walletBloc,
                listener: (context, state) {
                  print('current state home wallet: $state');
                  // TODO: implement listener
                },
                child: Container(),
              ),
              BlocListener(
                bloc: _authBloc,
                listener: (context, state) {
                  print('current state home auth: $state');
                  if (state is AuthLoading) {
                    _loadingOut = true;
                    Dialogs.showLoadingDialog(context);
                  } else {
                    _loadingOut = false;
                    Navigator.pop(context);
                  }

                  if (state is ShowNewsScreen) {
                    setState(() {
                      _currentIndex = 3;
                    });
                  }

                  if (state is ShowHkunScreen) {
                    setState(() {
                      _currentIndex = 2;
                    });
                  }

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

                  if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Invalid email or password',
                          style: TextStyle(color: Colors.red.shade400)),
                    ));
                  }
                },
              ),
              BlocListener(
                bloc: _newsBloc,
                listener: (context, state) {
                  print('current state home news: $state');
                  if (state is AddedDeleteItem) {
                    setState(() {
                      _toDeleteList = state.newsList;
                    });
                  }

                  if (state is NewsDeleteSuccess) {
                    setState(() {
                      _toDeleteList.clear();
                    });
                  }
                },
              ),
            ],
            child: Container(
              color: Colors.black,
              height: SizeConfig.screenHeight,
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    width: double.infinity,
                    height: kToolbarHeight,
                    child: Row(
                      children: [
                        Container(
                          height: 30.0,
                          margin: EdgeInsets.only(right: 10.0),
                          child: Image.asset(
                            'assets/images/tata_logo.png',
                          ),
                        ),
                        GradientText(
                          'HKUN',
                          gradient: gradientColor,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                        Spacer(),
                        Visibility(
                          visible: _currentIndex == 3 && !_isAuthenticated,
                          child: GestureDetector(
                            onLongPress: () => _handleLogin(context),
                            child: Icon(FontAwesomeIcons.signInAlt),
                          ),
                        ),
                        Visibility(
                          visible: _currentIndex == 3 && _isAuthenticated,
                          child: IconButton(
                            tooltip: 'Logout',
                            onPressed: () => _handleLogout(context),
                            icon: Icon(
                              FontAwesomeIcons.signOutAlt,
                              color: Color(0xFF757575),
                              size: 20.0,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _currentIndex == 2,
                          child: IconButton(
                            onPressed: () {
                              _walletBloc.add(EnterWalletAddress());
                            },
                            icon: Icon(
                              FontAwesomeIcons.wallet,
                              color: Color(0xFF757575),
                              size: 20.0,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              _scaffoldKey.currentState!.openEndDrawer(),
                          icon: Icon(
                            FontAwesomeIcons.bars,
                            color: Color(0xFF757575),
                            size: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {},
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      margin: EdgeInsets.only(top: 16.0),
                      child: _screens[_currentIndex],
                    ),
                  )),
                  Visibility(
                    visible: _isAuthenticated && _currentIndex == 3,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                setState(() {
                                  _currentIndex = 0;
                                });
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddNewsScreen(),
                                  ),
                                );
                                setState(() {
                                  _currentIndex = 3;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 18.0,
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'Add',
                                          style: TextStyle(
                                            color: Color(0xFFBDBDBD),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: InkWell(
                              onTap: _deleteSelectedNews,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _toDeleteList.isNotEmpty
                                        ? Color(0xFFBDBDBD)
                                        : Colors.grey.shade700,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: _toDeleteList.isNotEmpty
                                          ? Colors.red.shade400
                                          : Colors.grey.shade700,
                                      size: 18.0,
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: _toDeleteList.isNotEmpty
                                                ? Color(0xFFBDBDBD)
                                                : Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: InkWell(
                              onTap: _editSelectedNews,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _toDeleteList.isNotEmpty &&
                                            _toDeleteList.length == 1
                                        ? Color(0xFFBDBDBD)
                                        : Colors.grey.shade700,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: _toDeleteList.isNotEmpty &&
                                              _toDeleteList.length == 1
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                      size: 18.0,
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'Edit',
                                          style: TextStyle(
                                            color: _toDeleteList.isNotEmpty
                                                ? Color(0xFFBDBDBD)
                                                : Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
            ),
          ),
        ),
      ),
      endDrawer: CustomDrawer(
        onDarkMode: () {
          setState(() {
            _darkMode = !_darkMode;
          });
        },
        darkMode: _darkMode,
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        color: Color(0xFF1b1b1b),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFF1b1b1b),
          selectedItemColor: Colors.pink.shade600,
          unselectedItemColor: Colors.grey.shade700,
          showSelectedLabels: true,
          currentIndex: _currentIndex,
          selectedLabelStyle:
              TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600),
          unselectedFontSize: 10.0,
          selectedFontSize: 12.0,
          iconSize: 24.0,
          elevation: 0.0,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.white),
              activeIcon: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return gradientColor.createShader(bounds);
                },
                child: Icon(Icons.home, color: Colors.white),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.chartBar, color: Colors.white),
              activeIcon: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return gradientColor.createShader(bounds);
                },
                child: Icon(FontAwesomeIcons.chartBar, color: Colors.white),
              ),
              label: 'Markets',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.wallet, color: Colors.white),
              activeIcon: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return gradientColor.createShader(bounds);
                },
                child: Icon(FontAwesomeIcons.wallet, color: Colors.white),
              ),
              label: 'My HKUN',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.newspaper, color: Colors.white),
              activeIcon: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return gradientColor.createShader(bounds);
                },
                child: Icon(FontAwesomeIcons.newspaper, color: Colors.white),
              ),
              label: 'News',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_loadingOut) Navigator.pop(context);
    super.dispose();
  }

  _editSelectedNews() async {
    if (_toDeleteList.length != 1) return;
    setState(() {
      _currentIndex = 0;
    });
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNewsScreen(
          news: _toDeleteList[0],
        ),
      ),
    );

    setState(() {
      _currentIndex = 3;
    });
  }

  _deleteSelectedNews() {
    if (_toDeleteList.isEmpty) return;

    _newsBloc.add(NewsDelete(_toDeleteList.map((news) => news.id!).toList()));
  }

  _handleLogout(BuildContext pContext) {
    showDialog(
      context: pContext,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'You are about to logout.',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 12.0),
              Text(
                'Do you want to continue?',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _authBloc.add(AuthLogout());
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Center(
                          child: Text(
                            'YES',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        child: Center(
                          child: Text(
                            'NO',
                            style: TextStyle(
                              color: Colors.red.shade400,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _handleLogin(BuildContext context) async {
    final result = await Dialogs.showLoginDialog(context);
    if (result == null) return;
    print(result);
    _authBloc.add(AuthLogin(result['email'], result['password']));
  }
}
