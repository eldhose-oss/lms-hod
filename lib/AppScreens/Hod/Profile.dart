import 'dart:ui';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lm_hod/Resources/HodAuthMethods.dart';
import 'package:lm_hod/ReusableUtils/Colors.dart' as color_mode;
import 'package:lm_hod/ReusableUtils/HeightWidth.dart';
import 'package:lm_hod/ReusableUtils/PageView/PageView.dart';
import 'package:lm_hod/ReusableUtils/Profile/alertDialog.dart';
import 'package:lm_hod/ReusableUtils/Responsive.dart';
import 'package:provider/provider.dart';
import '../../Models/Hod/HodModel.dart';
import '../../Providers/Hod provider/HodProvider.dart';
import '../../Resources/ProfileUpdateMethods.dart';
import '../../Resources/StorageMethods.dart';
import '../../ReusableUtils/SnackBar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  bool isLoading = false;
  selectImageGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    File file = File(image!.path); //converting XFile as File
    snackBar(content: 'Image uploading , please stay in screen.', duration: 1800, context: context);
    String photoUrl = await StorageMethods()
        .uploadImageToStorage('Students Bio Picture', file);
    //storing to firestore
    String finalResult = await ProfileUpdate().updateImage(imageUrl: photoUrl);
    snackBar(content: finalResult, duration: 1800, context: context);
  }

  selectImageCamera() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    File file = File(image!.path);
    snackBar(content: 'Image uploading, please stay in screen.', duration: 1800, context: context);
    String photoUrl = await StorageMethods()
        .uploadImageToStorage('HoD profile', file);

    String finalResult = await ProfileUpdate().updateImage(imageUrl: photoUrl);
    snackBar(content: finalResult, duration: 1800, context: context);
  }

  _displayDialog(BuildContext context) async {
    await showDialog(
        barrierColor: Colors.white70,
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              'Choose Location',
              style: TextStyle(
                color: color_mode.tertiaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  selectImageCamera();
                  Navigator.pop(context);
                },
                child: Text(
                  'Camera',
                  style: TextStyle(
                      color: color_mode.secondaryColor2,
                      fontWeight: FontWeight.w500,
                      backgroundColor: color_mode.primaryColor,
                    fontSize: screenLayout(30, context)
                  ),
                ),
              ),
              SizedBox(
                height: screenLayout(20, context),
              ),
              SimpleDialogOption(
                onPressed: () {
                  selectImageGallery();
                  Navigator.pop(context);
                },
                child: Text(
                  'Gallery',
                  style: TextStyle(
                      color: color_mode.secondaryColor2,
                      fontWeight: FontWeight.w500,
                      backgroundColor: color_mode.primaryColor,
                      fontSize: screenLayout(30, context)
                  ),
                ),
              ),
              SizedBox(
                height: screenLayout(20, context),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: color_mode.unImportant,
                      fontWeight: FontWeight.w500,
                      backgroundColor: color_mode.primaryColor,
                      fontSize: screenLayout(28, context)
                  ),
                ),
              ),
            ],
          );
        });
  }
  void updateName({
  required TextEditingController textEditingController,
}) async {
    String finalResult = await ProfileUpdate().updateName(name: _nameController.text);
    if(finalResult == 'success'){
      snackBar(content: 'Name updated updated successfully', duration: 1500, context: context);
    }
    else{
      snackBar(content: finalResult, duration: 1500, context: context);
    }
  }
  void updateContactNumber({
  required TextEditingController textEditingController,
}) async {
    String finalResult = await ProfileUpdate().updateContactNumber(contactNo: _contactNumberController.text);
    if(finalResult == 'success'){
      snackBar(content: 'Contact number updated successfully', duration: 1500, context: context);
    }
    else{
      snackBar(content: finalResult, duration: 1500, context: context);
    }
  }

  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    HodModel _hodModel = Provider
        .of<HodProvider>(context)
        .getHod;
    String contactNumber = ""; // initialise to avoid null value at start
    String name = "";
    String userId = _hodModel.userId;
    final Stream<DocumentSnapshot<Map<String, dynamic>>> profile = FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
    return Scaffold(
      body: StreamBuilder<Object>(
        stream: profile,
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return const Center(
              child:Text('Error 504. Server side issue.'),
            );
          }
          else {
            if(snapshot.hasData) {
              var data = snapshot
                  .data as DocumentSnapshot; // storing the database document snapshot.
              contactNumber = data['contact'];// accessing the field values of the document.
              name = data['name'];
            }
            return SingleChildScrollView(
              physics: (MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom != 0)
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              child: Stack(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: screenLayout(45, context),
                                  left: screenLayout(55, context)),
                              child: Text('My Profile',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: color_mode.tertiaryColor,
                                  letterSpacing: 1.3,
                                  fontSize: screenLayout(43, context),
                                  //add font later
                                  //--//
                                ),
                              ),
                            ),
                          ],
                        ),
                        verticalSpace(40, context),
                        Container(
                          height: getHeight(context) / 3.7,
                          width: getWidth(context) / 1.11,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: color_mode.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(
                                screenLayout(25, context))),
                          ),
                          child: const ScrollPageView(),
                        ),
                        verticalSpace(150, context),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            horizontalSpace(60, context),
                            Text(name,
                              style: TextStyle(
                                color: color_mode.spclColor2,
                                fontSize: screenLayout(50, context),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            horizontalSpace(10, context),
                            IconButton(
                                onPressed: () async {
                                  await dialogBox(
                                    context,
                                    'Name',
                                    updateDetails(
                                      context,
                                      _nameController,
                                      const Icon(Icons.phone_android_rounded),
                                      'Name',
                                      TextInputType.name,
                                      'ex. John Cena',
                                          () {
                                          updateName(
                                              textEditingController: _nameController);
                                          Navigator.pop(context);
                                      }
                                    ),);
                                }, icon: Icon(
                              Icons.edit, size: screenLayout(44, context),)),
                          ],
                        ),
                        verticalSpace(00, context),
                        Text(_hodModel.deptName + " HoD",
                          style: TextStyle(
                            color: color_mode.unImportant,
                            fontSize: screenLayout(40, context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        verticalSpace(80, context),

                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  right: screenLayout(130, context),
                                  left: screenLayout(40, context)),
                              child: Text('E-mail : ' + _hodModel.emailAddress,
                                  style: TextStyle(
                                      fontSize: screenLayout(30, context),
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                            ),
                          ],
                        ),
                        verticalSpace(30, context),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  right: screenLayout(0, context),
                                  left: screenLayout(40, context)),
                              child: Text(
                                  'Contact Number :  ' + contactNumber,
                                  style: TextStyle(
                                      fontSize: screenLayout(30, context),
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                            ),
                            horizontalSpace(70, context),
                            IconButton(
                                onPressed: () async {
                                  await dialogBox(
                                    context,
                                    'Contact Number',
                                    updateDetails(
                                      context,
                                      _contactNumberController,
                                      const Icon(Icons.phone_android_rounded),
                                      'Contact Number',
                                      TextInputType.number,
                                      'ex. 9876543123',
                                          () {
                                          updateContactNumber(
                                              textEditingController: _contactNumberController);
                                          Navigator.pop(context);
                                      }
                                    ),);
                                }, icon: Icon(
                              Icons.edit, size: screenLayout(44, context),)),
                          ],
                        )
                      ],
                    ),

                    //profile image circle avatar
                    Positioned(
                        left: getWidth(context) / screenLayout((getWidth(context) >= 390)?5:5.75, context),
                        top: getHeight(context) / screenLayout(6.5, context),
                        child: GestureDetector(
                          onTap: () => _displayDialog(context),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            maxRadius: screenLayout(130, context),
                            backgroundImage: (_hodModel.imageUrl == "notset")
                                ? null
                                : NetworkImage(_hodModel.imageUrl),
                            child: (_hodModel.imageUrl == "notset") ? Initicon(
                              borderRadius: BorderRadius.circular(
                                  screenLayout(10, context)),
                              text: _hodModel.fullName,
                              size: 160,
                              elevation: 15,
                            ) : null,
                          ),
                        )
                    ),
                  ]
              ),
            );
          }
        }
      ),
    );
  }
}
