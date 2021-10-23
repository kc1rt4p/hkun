import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hkun/helpers/size_config.dart';
import 'package:hkun/services/launcher_service.dart';

class CustomDrawer extends StatefulWidget {
  final Function()? onDarkMode;
  final bool darkMode;
  const CustomDrawer(
      {Key? key, required this.onDarkMode, required this.darkMode})
      : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 36.0, horizontal: 16.0),
      width: SizeConfig.screenWidth * 0.55,
      height: SizeConfig.screenHeight * 0.7,
      decoration: BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(34.0),
          bottomLeft: Radius.circular(34.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                child: Image.asset('assets/images/tata_bull_logo.png'),
                width: SizeConfig.screenWidth * 0.3,
              ),
            ),
            SizedBox(height: 36.0),
            Text(
              'Buy HKUN',
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 22.0),
            buildIconButton(
              icon: Image.asset(
                'assets/images/pancakeswap_logo.png',
                height: 21.0,
                width: 21.0,
              ),
              label: 'Pancake',
              onTap: () => LauncherService.launchPancakeSwap(),
            ),
            SizedBox(height: 22.0),
            buildIconButton(
              icon: Image.asset(
                'assets/images/lbank_logo.png',
                height: 21.0,
                width: 21.0,
              ),
              label: 'LBank',
              onTap: () => LauncherService.launchLBank(),
            ),
            SizedBox(height: 36.0),
            Text(
              'Follow Us',
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 22.0),
            buildIconButton(
              iconData: FontAwesomeIcons.telegramPlane,
              label: 'Telegram',
              onTap: () => LauncherService.launchTelegram(),
            ),
            SizedBox(height: 22.0),
            buildIconButton(
              iconData: FontAwesomeIcons.twitter,
              label: 'Twitter',
              onTap: () => LauncherService.launchTwitter(),
            ),
            SizedBox(height: 22.0),
            buildIconButton(
              iconData: FontAwesomeIcons.instagram,
              label: 'Instagram',
              onTap: () => LauncherService.launchInstagram(),
            ),
            SizedBox(height: 22.0),
            buildIconButton(
              iconData: FontAwesomeIcons.globe,
              label: 'Website',
              onTap: () => LauncherService.launchWebsite(),
            ),
            // SizedBox(height: 22.0),
            // Row(
            //   children: [
            //     Text(
            //       'Dark Mode',
            //       style: TextStyle(
            //         fontSize: 17.0,
            //         color: Colors.white,
            //       ),
            //     ),
            //     SizedBox(width: 14.0),
            //     Switch(
            //       onChanged: (val) => widget.onDarkMode,
            //       value: widget.darkMode,
            //       activeColor: Color(0xFFC30080),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildIconButton({
    IconData? iconData,
    required String label,
    required Function() onTap,
    Widget? icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Row(
          children: [
            icon == null
                ? Icon(
                    iconData,
                    color: Colors.white,
                    size: 21,
                  )
                : icon,
            SizedBox(width: 14.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 17.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
