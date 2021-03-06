import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lm_hod/AppScreens/Hod/Announcement.dart';
import 'package:lm_hod/AppScreens/Hod/LeaveHistory.dart';
import 'package:lm_hod/AppScreens/Hod/MainPage.dart';
import 'package:lm_hod/AppScreens/Hod/Profile.dart';
import 'package:lm_hod/AppScreens/Hod/StaffDismissal.dart';
import 'package:lm_hod/AppScreens/Hod/StaffRecruit.dart';
import 'package:lm_hod/AppScreens/Hod/TodayLeaveApplicants.dart';
import 'package:lm_hod/Models/Hod/HodModel.dart';
import 'package:lm_hod/Providers/Hod%20provider/HodProvider.dart';
import 'package:lm_hod/ReusableUtils/Dialog.dart';
import 'package:lm_hod/ReusableUtils/SidebarListTile.dart';
import 'package:provider/provider.dart';
import '../AppScreens/HOD/LoginScreen.dart';
import '../AppScreens/Hod/TimeTable.dart';
import '../Resources/HodAuthMethods.dart';
import 'Responsive.dart';
import 'Side transition.dart';
import 'package:lm_hod/ReusableUtils/Colors.dart' as color_mode;
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:lm_hod/ReusableUtils/Responsive.dart' as resize;

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  void logoutHod()async{
    String finalResult = await AuthMethods().logoutHod();
    if(finalResult == "success"){
      Navigator.pushReplacement(context, CustomPageRouteSide(child: const LoginScreen()));
    }
  }
  logoutDialog() async{
    await showDialog(
        barrierColor: Colors.white70,
        context: context,
        builder: (BuildContext context){
         return alertDialog(title: 'Do you want to logout?', onPressed: logoutHod, button1: 'Cancel', button2: 'Log out', context: context);
    });
  }
  @override
  Widget build(BuildContext context) {
    final HodModel _hodModel = Provider
        .of<HodProvider>(context)
        .getHod;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: screenLayout(340, context),
            child: UserAccountsDrawerHeader(
                decoration:  BoxDecoration(
                    color: color_mode.spclColor2.withOpacity(.5),
                ),
                accountName: Text(_hodModel.fullName,
                  style: TextStyle(color: color_mode.tertiaryColor,
                      fontWeight: FontWeight.bold
                  ),
                ),
                accountEmail: Text(_hodModel.emailAddress,
                  style: TextStyle(color: color_mode.tertiaryColor,
                      fontWeight: FontWeight.bold
                  ),
                ),
                currentAccountPicture: Padding(
                  padding: EdgeInsets.zero,
                  child: CircleAvatar(
                    backgroundColor: Colors.white10,
                    radius: screenLayout(120, context),
                    backgroundImage: (_hodModel.imageUrl=="notset")?null:NetworkImage(_hodModel.imageUrl),
                    child: (_hodModel.imageUrl=="notset")?Initicon(
                      borderRadius: BorderRadius.circular(50),
                      text: _hodModel.fullName,
                      size: 90,
                    ):null,
                  ),
                ),
            ),
          ),
          Divider(
            color: color_mode.unImportant,
            thickness: 1,
          ),
          sidebarListTile(
              leadingIcon: Icons.home_outlined,
              title: 'Home',
              onTap: (){
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainPage()));
              }),
          sidebarListTile(
              leadingIcon: Icons.sms_failed_outlined,
              title: 'Announcement',
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const Announcement()));
              }),
          sidebarListTile(
              title: "Today's Time Table",
              leadingIcon: FontAwesomeIcons.tableList,
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, CustomPageRouteSide(child: const ViewTimeTable()));
              }),
          sidebarListTile(
              leadingIcon: Icons.person_add_alt_outlined,
              title: 'Recruit Staff',
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const StaffRecruit()));
              }),
          sidebarListTile(
              title: 'Dismiss Staff',
              leadingIcon: Icons.do_disturb_on_outlined,
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const StaffDismissal()));
              }),
          sidebarListTile(
              title: 'Leave Applicants',
              leadingIcon: Icons.newspaper_outlined,
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveApplicants()));
              }),
          sidebarListTile(
              title: 'Staff Leave History',
              leadingIcon: Icons.history,
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, CustomPageRouteSide(child: const LeaveHistory()));
              }),
          Divider(
            color: color_mode.unImportant,
            thickness: 1,
          ),
          sidebarListTile(
              title: 'Logout',
              leadingIcon: Icons.logout_outlined,
              onTap: logoutDialog
          ),
        ],
      ),
    );
  }
}
