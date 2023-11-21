import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_mailer/flutter_mailer.dart';

import 'package:flutter_svg/svg.dart';
// import 'package:launch_review/launch_review.dart';
import 'package:percent_indicator/percent_indicator.dart';
// import 'package:share_plus/share_plus.dart';

import 'package:table_calendar/table_calendar.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:wakelock/wakelock.dart';

import 'ColorCategory.dart';
import 'Constants.dart';
import 'MyAssetsBar.dart';
import 'PrefData.dart';
import 'SizeConfig.dart';
import 'WidgetChallengesExerciseList.dart';
import 'WidgetHealthInfo.dart';
import 'WidgetWorkoutExerciseList.dart';
import 'Widgets.dart';
import 'db/DataHelper.dart';
import 'generated/l10n.dart';
import 'models/ModelChallengesMainCat.dart';
import 'models/ModelDiscover.dart';
import 'models/ModelHistory.dart';
import 'models/ModelPopularWorkout.dart';
import 'models/ModelQuickWorkout.dart';
import 'models/ModelWorkoutList.dart';

// ignore: must_be_immutable
class HomeWidget extends StatefulWidget {
  int indexSend = 0;

  HomeWidget(this.indexSend);

  @override
  State<StatefulWidget> createState() => _HomeWidget(this.indexSend);
}

class Destination {
  final String title;
  final String toolbarTitle;
  final IconData icon;
  final MaterialColor color;

  const Destination(this.title, this.toolbarTitle, this.icon, this.color);
}

class TabSettings extends StatefulWidget {
  @override
  _TabSettings createState() => _TabSettings();
}

class _TabSettings extends State<TabSettings> {
  int getRestTime = 0;
  String dropdownValue = '10 Sec';
  final myController = TextEditingController();

  bool isScreenOn = false;

  List<String> spinnerItems = [
    '10 Sec',
    '20 Sec',
    '30 Sec',
    '40 Sec',
    '50 Sec'
  ];

  _isScreenOn() async {
    // isScreenOn = await Wakelock.enabled;
    setState(() {});
  }

  @override
  void initState() {
    myController.text = "200";
    _getRestTimes();
    _isScreenOn();
    // spinnerItems = json[spinnerItems1.toString()].map((el) => el.toString()).toList()
    // spinnerItems =spinnerItems1.cast<String>();

    super.initState();
  }

  _getRestTimes() async {
    getRestTime = await PrefData().getRestTime();
    dropdownValue = "$getRestTime Sec";
    print("fontsizes==$_getRestTimes");
  }

  openReminderDialog() {
    bool isSwitchOn = false;
    double dialogWidth = 300;
    // var dialogWidth=MediaQuery.of(context).size.width-50;
    var checkDialogWidth = dialogWidth - 30;
    List<String> selectedList = [];
    List<String> daysList = ["Dom", "Lun", "Mar", "X", "Jue", "Vie", "Sab"];
    return showDialog(
        context: context,
        useSafeArea: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                contentPadding: EdgeInsets.only(top: 10.0),
                content: Container(
                  width: dialogWidth,
                  // width: 350.0,
                  padding:
                      EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      getCustomText("Poner Recordatorio", Colors.black, 1,
                          TextAlign.start, FontWeight.normal, 20),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          getLargeBoldTextWithMaxLine(
                              "5:30", Colors.black87, 1),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: getSmallNormalText(
                                "AM", Colors.black87, TextAlign.start),
                            flex: 1,
                          ),
                          Switch(
                            value: isSwitchOn,
                            onChanged: (value) {
                              setState(() {
                                isSwitchOn = value;
                              });
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Container(
                        width: double.infinity,
                        height: (checkDialogWidth / 7),
                        // height: (300 / 7.8) + 20,
                        alignment: Alignment.center,
                        child: ListView.builder(
                          itemCount: 7,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            String getName = daysList[index];
                            bool isSelected = selectedList.contains(getName);
                            return InkWell(
                              onTap: () {
                                if (isSwitchOn) {
                                  setState(() {
                                    if (selectedList.contains(getName)) {
                                      selectedList.remove(getName);
                                    } else {
                                      selectedList.add(getName);
                                    }
                                  });
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.all(1),
                                width: (checkDialogWidth / 7) - 2,
                                height: (checkDialogWidth / 7) - 2,
                                decoration: BoxDecoration(
                                    color: isSelected
                                        ? accentColor
                                        : Colors.black12,
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: getExtraSmallNormalTextWithMaxLine(
                                      "${getName[0]}",
                                      isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                      1,
                                      TextAlign.center),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                actions: [
                  new TextButton(
                      child: Text(
                        'CANCELAR',
                        style: TextStyle(
                            fontFamily: Constants.fontsFamily,
                            fontSize: 15,
                            color: accentColor,
                            fontWeight: FontWeight.normal),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  new TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(lightPink)),
                      child: Text(
                        'OK',
                        style: TextStyle(
                            fontFamily: Constants.fontsFamily,
                            fontSize: 15,
                            color: accentColor,
                            fontWeight: FontWeight.normal),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              );
            },
          );
        });
  }

  openAlertBox() {
    bool isValidate = true;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                contentPadding: EdgeInsets.only(top: 10.0),
                content: Container(
                  width: 300.0,
                  padding:
                      EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      getCustomText("Pon Tu Meta Diaria", Colors.black87, 1,
                          TextAlign.start, FontWeight.w600, 20),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              cursorColor: accentColor,
                              decoration: InputDecoration(
                                  errorText: !isValidate
                                      ? "kcal no puede ser menor a ${myController.text}?"
                                      : null,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor),
                                  )),
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  color: Colors.black,
                                  decorationColor: accentColor,
                                  fontFamily: Constants.fontsFamily),
                              controller: myController,
                            ),
                            flex: 1,
                          ),
                          getMediumNormalTextWithMaxLine(
                              "Kcal", Colors.grey, 1, TextAlign.start)
                        ],
                      ),
                      SizedBox(
                        height: 7,
                      ),
                    ],
                  ),
                ),
                actions: [
                  new TextButton(
                      child: Text(
                        'CANCELAR',
                        style: TextStyle(
                            fontFamily: Constants.fontsFamily,
                            fontSize: 15,
                            color: accentColor,
                            fontWeight: FontWeight.normal),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  new TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(lightPink)),
                      child: Text(
                        'AGREGAR',
                        style: TextStyle(
                            fontFamily: Constants.fontsFamily,
                            fontSize: 15,
                            color: accentColor,
                            fontWeight: FontWeight.normal),
                      ),
                      onPressed: () {
                        if (myController.text.isNotEmpty) {
                          double val = double.parse(myController.text);
                          if (val > 5000) {
                            setState(() {
                              isValidate = false;
                            });
                          } else {
                            isValidate = true;
                          }
                          Navigator.pop(context);
                        } else {
                          myController.text = "200";
                        }
                        Navigator.pop(context);
                      })
                ],
              );
            },
          );
        }).then((value) {
      setState(() {});
    });
  }

  Future<void> share() async {
    // Share.share( S.of(context).app_name, subject: 'https://flutter.dev/');
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double textMargin = SizeConfig.safeBlockHorizontal! * 2.5;
    // double textMargin = SizeConfig.safeBlockHorizontal * 1.5;
    return Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(textMargin),
        child: ListView(scrollDirection: Axis.vertical, children: [
          Padding(
            padding: EdgeInsets.all(textMargin),
            child: getSettingTabTitle(S.of(context).workout),
          ),
          Container(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        Icons.free_breakfast_outlined, "Descansos"),
                    flex: 1,
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black54,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                        color: blueButton,
                        fontSize: 17,
                        fontFamily: Constants.fontsFamily),
                    underline: Container(
                      height: 2,
                      color: Colors.black12,
                    ),
                    onChanged: (value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: spinnerItems
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
                ],
              )),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        Icons.adjust_outlined, "Meta Diaria"),
                    flex: 1,
                  ),
                  getCustomText("${myController.text} kcal", blueButton, 1,
                      TextAlign.start, FontWeight.normal, 18)
                ],
              ),
            ),
            onTap: () {
              openAlertBox();
            },
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        Icons.volume_up_rounded, "Opciones de Sonido"),
                    flex: 1,
                  ),
                ],
              ),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    bool isSwitched = false;

                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      contentPadding: EdgeInsets.only(top: 10.0),
                      content: StatefulBuilder(
                        builder: (context, setState) {
                          return Container(
                            width: 300.0,
                            padding: EdgeInsets.only(
                                top: 15, bottom: 15, left: 15, right: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                getCustomText(
                                    "Opciones de Sonido",
                                    Colors.black87,
                                    1,
                                    TextAlign.start,
                                    FontWeight.w600,
                                    20),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.volume_up,
                                      color: Colors.black54,
                                    ),
                                    Expanded(
                                      child: getSmallNormalTextWithMaxLine(
                                          "SILENCIAR", Colors.black, 1),
                                      flex: 1,
                                    ),
                                    Switch(
                                      value: isSwitched,
                                      onChanged: (value) {
                                        setState(() {
                                          isSwitched = value;
                                        });
                                      },
                                      activeTrackColor: accentColor,
                                      activeColor: accentColor,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      actions: [
                        new TextButton(
                            child: Text(
                              'GUARDAR',
                              style: TextStyle(
                                  fontFamily: Constants.fontsFamily,
                                  fontSize: 15,
                                  color: accentColor,
                                  fontWeight: FontWeight.normal),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ],
                    );
                  });
            },
          ),
          Padding(
            padding: EdgeInsets.all(textMargin),
            child: getSettingTabTitle("GENERAL"),
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingMultiLineText(
                        Icons.alarm, "Poner Recordatorio", "5:30 AM"),
                    flex: 1,
                  ),
                ],
              ),
            ),
            onTap: () {
              openReminderDialog();
            },
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        Icons.add_box_outlined, "Tu Información"),
                    flex: 1,
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new HealthInfo(),
                ),
              );
            },
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingMultiLineText(Icons.ac_unit,
                        "Cambiar sistema de Unidades", "Metros y Kilogramos"),
                    flex: 1,
                  ),
                ],
              ),
            ),
            onTap: () {
              showUnitDialog(context);
            },
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        Icons.mobile_screen_share_outlined,
                        "Mantener Pantalla Encendida"),
                    flex: 1,
                  ),
                  Switch(
                    value: isScreenOn,
                    onChanged: (value) {
                      setState(() {
                        isScreenOn = value;
                        // Wakelock.toggle(enable: isScreenOn);
                      });
                    },
                    activeTrackColor: accentColor,
                    activeColor: accentColor,
                  )
                ],
              ),
            ),
            onTap: () {},
          ),
          Padding(
            padding: EdgeInsets.all(textMargin),
            child: getSettingTabTitle("APOYANOS"),
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        Icons.share, "Compartir con amigos"),
                    flex: 1,
                  ),
                ],
              ),
            ),
            onTap: () {
              share();
            },
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(Icons.mail, "Feedback"),
                    flex: 1,
                  ),
                ],
              ),
            ),
            onTap: () async {
              // final MailOptions mailOptions = MailOptions(
              //   body: 'a long body for the email <br> with a subset of HTML',
              //   subject: 'the Email Subject',
              //   recipients: ['example@example.com'],
              //   isHTML: true,
              //
              // );
              //
              //  await FlutterMailer.send(mailOptions);
            },
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        Icons.star_rate, "Calificanos"),
                    flex: 1,
                  ),
                ],
              ),
            ),
            onTap: () {
              // LaunchReview.launch();
            },
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(textMargin),
              child: Row(
                children: [
                  Expanded(
                    child: getSettingSingleLineText(
                        Icons.policy_rounded, "Politicas de Privacidad"),
                    flex: 1,
                  ),
                ],
              ),
            ),
            onTap: () {
              _launchURL();
            },
          ),
        ]));
  }
}

_launchURL() async {
  // const url = 'https://www.google.com';
  const url = 'https://flutter.dev';

  // if (await canLaunch(url)) {
  //   await launch(url);
  // } else {
  //   throw 'Could not launch $url';
  // }
}

Future<dynamic> showUnitDialog(BuildContext contexts) async {
  List<String> ringTone = ['Metros y kilogramos', 'Libras,Pies y Pulgadas'];
  int _currentIndex = 0;

  return showDialog(
    context: contexts,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: getMediumBoldTextWithMaxLine(
                "Cambiar sistema de Medidas", Colors.black87, 1),
            content: Container(
              width: 400,
              height: 100,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: ringTone.length,
                itemBuilder: (context, index) {
                  return RadioListTile(
                    value: index,
                    groupValue: _currentIndex,
                    title: getSmallNormalTextWithMaxLine(
                        ringTone[index], Colors.black87, 1),
                    onChanged: (value) {
                      setState(() {
                        _currentIndex = value as int;
                      });
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, ringTone[_currentIndex]);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    },
  );
}

class TabHome extends StatefulWidget {
  @override
  _TabHome createState() => _TabHome();
}

class _TabHome extends State<TabHome> with TickerProviderStateMixin {
  List<ModelChallengesMainCat> challengesList = [];
  List<Widget> progressWidget = [];
  DataHelper _dataHelper = DataHelper.instance;
  AnimationController? animationController;
  int getCal = 0;
  int getTotalWorkout = 0;
  List priceList = [];
  int getTime = 0;
  double listLength = 1;

  // final AnimationController animationController;
  Animation<dynamic>? animation;

  void _calcTotal() async {
    priceList = await _dataHelper.calculateTotalWorkout();
    if (priceList.length > 0) {
      getTotalWorkout = priceList.length;
      priceList.forEach((price) {
        getCal = (price['kcal']) + getCal;
        // getCal = (getCal + (price['kcal']);
      });
      getTime = getTotalWorkout * 2;

      // print("getval=$getCal");
      setState(() {});
    }
  }

  @override
  void initState() {
    progressWidget.add(getProgressDialog());
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _calcTotal();
    _dataHelper.getAllChallengesList().then((value) {
      challengesList = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double sliderHeight = SizeConfig.safeBlockVertical! * 35;
    int interval = challengesList.length;
    final Animation<double> animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(
      // Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController!,
        // curve: Interval((1 /challengesList.length) * 1, 1.0,
        curve: Interval((1 / interval) * 1, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );
    animationController!.forward();
    List<Widget> imageSliders = challengesList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: AnimatedBuilder(
                    animation: animationController!,
                    builder: (context, child) {
                      return FadeTransition(
                          opacity: animation,
                          child: Transform(
                              transform: Matrix4.translationValues(
                                  0.0, 50 * (1.0 - animation.value), 0.0),
                              child: InkWell(
                                onTap: () {
                                  //
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          new WidgetChallengesExerciseList(
                                              item),
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: item.title!,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10)),
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                height: double.infinity,
                                                width: double.infinity,
                                                padding: EdgeInsets.only(
                                                    left: 12, right: 12),
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(Constants
                                                            .assetsImagePath +
                                                        item.background!),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  // borderRadius: BorderRadius.all(
                                                  //     Radius.circular(10)
                                                  // ),
                                                  // color: Colors.green,
                                                ),
                                                child: Image.asset(
                                                  Constants.assetsImagePath +
                                                      item.image!,
                                                  fit: BoxFit.scaleDown,
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0.0,
                                                left: 0.0,
                                                right: 0.0,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 20.0),
                                                  child: Text(
                                                    item.title!,
                                                    // 'No. ${imgList.indexOf(item)} image',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          sliderHeight * 0.070,
                                                      fontFamily:
                                                          Constants.fontsFamily,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      // fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        flex: 1,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.all(7),
                                          child: getCustomText(
                                              item.description!,
                                              Colors.black,
                                              2,
                                              TextAlign.start,
                                              FontWeight.normal,
                                              14)),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 7, right: 7, bottom: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: getCustomText(
                                                    "${item.weeks} ${S.of(context).week}",
                                                    // "${item.weeks} Week",
                                                    Colors.grey,
                                                    1,
                                                    TextAlign.start,
                                                    FontWeight.normal,
                                                    15),
                                              ),
                                              getCustomText(
                                                  "0%",
                                                  Colors.grey,
                                                  1,
                                                  TextAlign.start,
                                                  FontWeight.normal,
                                                  15)
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                              )));
                    }),
              ),
            ))
        .toList();

    double startMargin = SizeConfig.safeBlockHorizontal! * 7;
    double topMargin = SizeConfig.safeBlockHorizontal! * 3;
    double textMargin = SizeConfig.safeBlockHorizontal! * 3.5;
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: bgDarkWhite,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            padding: EdgeInsets.all(15),
            width: double.infinity,
            margin: EdgeInsets.only(
                left: startMargin,
                right: startMargin,
                top: topMargin,
                bottom: topMargin),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.black12),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      getMediumBoldItalicText(
                          getTotalWorkout.toString(), Colors.black87),
                      getCustomText(S.of(context).workouts, Colors.black87, 1,
                          TextAlign.center, FontWeight.w600, 12)
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      getMediumBoldItalicText(
                          getCal.toString(), Colors.black87),
                      getCustomText(S.of(context).kcal, Colors.black87, 1,
                          TextAlign.center, FontWeight.w600, 12)
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      getMediumBoldItalicText(
                          getTime.toString(), Colors.black87),
                      getCustomText(S.of(context).minutes, Colors.black87, 1,
                          TextAlign.center, FontWeight.w600, 12)
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.all(textMargin),
              child: getTitleTexts(S.of(context).challenges)),
          CarouselSlider(
              items: imageSliders,
              options: CarouselOptions(
                  height: sliderHeight,
                  autoPlay: false,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false)),
          FutureBuilder<List<ModelWorkoutList>>(
            future: _dataHelper.getWorkoutList(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                List<ModelWorkoutList> workoutList = snapshot.data!;
                return ListView.builder(
                    itemCount: workoutList.length,
                    primary: false,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                        // Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animationController!,
                          curve: Interval((1 / workoutList.length) * index, 1.0,
                              curve: Curves.fastOutSlowIn),
                        ),
                      );
                      animationController!.forward();

                      ModelWorkoutList _modelWorkoutList = workoutList[index];
                      return AnimatedBuilder(
                        animation: animationController!,
                        builder: (context, child) {
                          return FadeTransition(
                              opacity: animation,
                              child: Transform(
                                transform: Matrix4.translationValues(
                                    0.0, 50 * (1.0 - animation.value), 0.0),
                                child: InkWell(
                                  child: Hero(
                                      tag: _modelWorkoutList.id!,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 18,
                                            top: 12,
                                            bottom: 12,
                                            right: 12),
                                        width: double.infinity,
                                        height:
                                            SizeConfig.safeBlockHorizontal! *
                                                30,
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                // color: Colors.white,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey,
                                                        offset: Offset(
                                                            0.0, 1.0), //(x,y)
                                                        blurRadius: 1.0,
                                                      ),
                                                    ],
                                                    color: Colors.white),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(12),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      12)),
                                                      child: Image(
                                                        image: AssetImage(
                                                            "${Constants.assetsImagePath}${_modelWorkoutList.image}"),
                                                        width: SizeConfig
                                                                .safeBlockHorizontal! *
                                                            38,
                                                        height: double.infinity,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        margin: EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 10),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 15,
                                                                right: 15,
                                                                top: 7,
                                                                bottom: 7),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  getMediumBoldTextWithMaxLine(
                                                                      "${_modelWorkoutList.name} ${S.of(context).workout_small}",
                                                                      Colors
                                                                          .black,
                                                                      1),
                                                                  getExtraSmallNormalTextWithMaxLine(
                                                                      S
                                                                          .of(
                                                                              context)
                                                                          .transformation,
                                                                      Colors
                                                                          .black87,
                                                                      3,
                                                                      TextAlign
                                                                          .start)
                                                                ],
                                                              ),
                                                              flex: 1,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      flex: 1,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                  onTap: () {
                                    sendToWorkoutList(
                                        context, _modelWorkoutList);
                                  },
                                ),
                              ));
                        },
                      );
                    });
              } else {
                return getProgressDialog();
              }
            },
          ),
        ],
      ),
    );
  }
}

void sendToWorkoutList(
    BuildContext context, ModelWorkoutList modelWorkoutList) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) {
      return WidgetWorkoutExerciseList(modelWorkoutList);
    },
  ));
}

class TabActivity extends StatefulWidget {
  @override
  _TabActivity createState() => _TabActivity();
}

class _TabActivity extends State<TabActivity> {
  DateTime selectedDateTime = DateTime.now();
  String height = "0";
  String weight = "0";
  int bmi = 0;

  DataHelper _dataHelper = DataHelper.instance;
  var myController = TextEditingController();
  var myControllerWeight = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void showWeightHeightDialog(BuildContext contexts) async {
    return showDialog(
      context: contexts,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: getMediumBoldTextWithMaxLine(
                  "Ingresa tu altura y peso", Colors.black87, 1),
              content: Container(
                width: 300.0,
                padding:
                    EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    getCustomText("Altura", Colors.black87, 1, TextAlign.start,
                        FontWeight.w600, 20),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            cursorColor: accentColor,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: accentColor),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: accentColor),
                                )),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Colors.black,
                                decorationColor: accentColor,
                                fontFamily: Constants.fontsFamily),
                            controller: myController,
                          ),
                          flex: 1,
                        ),
                        getMediumNormalTextWithMaxLine(
                            "CM", Colors.grey, 1, TextAlign.start)
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    getCustomText("Peso", Colors.black87, 1, TextAlign.start,
                        FontWeight.w600, 20),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            cursorColor: accentColor,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: accentColor),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: accentColor),
                                )),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Colors.black,
                                decorationColor: accentColor,
                                fontFamily: Constants.fontsFamily),
                            controller: myControllerWeight,
                          ),
                          flex: 1,
                        ),
                        getMediumNormalTextWithMaxLine(
                            "KG", Colors.grey, 1, TextAlign.start)
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                new TextButton(
                    child: Text(
                      'CANCELAR',
                      style: TextStyle(
                          fontFamily: Constants.fontsFamily,
                          fontSize: 15,
                          color: accentColor,
                          fontWeight: FontWeight.normal),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                new TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(lightPink)),
                    child: Text(
                      'GUARDAR',
                      style: TextStyle(
                          fontFamily: Constants.fontsFamily,
                          fontSize: 15,
                          color: accentColor,
                          fontWeight: FontWeight.normal),
                    ),
                    onPressed: () {
                      if (myController.text.isNotEmpty) {
                        height = myController.text;
                      }
                      if (myControllerWeight.text.isNotEmpty) {
                        weight = myControllerWeight.text;
                      }
                      Navigator.pop(context, weight);
                    }),
              ],
            );
          },
        );
      },
    ).then((value) => {
          setState(() {
            getBmiVal();
          })
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getBmiVal() {
    double weightKg = double.parse(weight);
    double heightCm = double.parse(height);

    double meterHeight = heightCm / 100;
    double bmiGet = weightKg / (meterHeight * meterHeight);
    print(
        "getbmival---$bmiGet---${(bmiGet == double.nan)}--$meterHeight--$weightKg");

    setState(() {
      if (bmiGet.isNaN) {
        bmi = 0;
      } else {
        bmi = bmiGet.toInt();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double textMargin = SizeConfig.safeBlockHorizontal! * 3.5;
    SizeConfig().init(context);
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.all(textMargin),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              getSmallBoldText("Estadisticas |", Colors.black),
              getSmallNormalText(" HOY", Colors.black, TextAlign.start),
            ],
          ),
          new CircularPercentIndicator(
            radius: SizeConfig.safeBlockHorizontal! * 32,
            lineWidth: 13,
            percent: 0.5,
            center: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_fire_department,
                  size: 40,
                ),
                Container(
                  width: SizeConfig.safeBlockHorizontal! * 30,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      "55/200 KCAL",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: Constants.fontsFamily,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
            backgroundColor: greyWhite,
            progressColor: Colors.green,
          ),
          SizedBox(
            height: 5,
          ),
          getMediumBoldTextWithMaxLine("Meta Diaria", Colors.black, 1),
          SizedBox(
            height: 5,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 3, right: 4, top: 5, bottom: 5),
            color: Colors.black12,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getMediumBoldTextWithMaxLine("1", Colors.black, 1),
                      SizedBox(
                        width: 2,
                      ),
                      getSmallNormalText(
                          " Entrenamientos", Colors.black, TextAlign.start)
                    ],
                  ),
                ),
                getSmallBoldText(" | ", Colors.black),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getMediumBoldTextWithMaxLine("4", Colors.black, 1),
                      SizedBox(
                        width: 2,
                      ),
                      getSmallNormalText(
                          S.of(context).minutes, Colors.black, TextAlign.start)
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 12),
            width: double.infinity,
            height: SizeConfig.safeBlockVertical! * 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: bmiBgColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Image.asset(
                        Constants.assetsImagePath + "path.png",
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            child: getMediumBoldTextWithMaxLine(
                                "BMI", Colors.white, 1),
                            padding: EdgeInsets.all(5),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: getCustomText("$bmi kg/m²", Colors.white, 1,
                                TextAlign.center, FontWeight.bold, 22),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Obesidad Severa",
                                style: TextStyle(
                                    color: Constants.getColorFromHex("FBC02D"),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    fontStyle: FontStyle.italic),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              )
                              // , 1,
                              // TextAlign.center, , 22),
                              ),
                          Expanded(
                            child: Center(
                              child: Container(
                                child: MyAssetsBar(
                                  // width: 200,
                                  width: SizeConfig.safeBlockHorizontal! * 90,
                                  background:
                                      Constants.getColorFromHex("CFD8DC"),
                                  //height: 50,
                                  height: 5,
                                  radius: 5,
                                  pointer: bmi,
                                  //radius: 10,
                                  assetsLimit: 50,
                                  order: OrderType.None,
                                  // order: OrderType.Ascending,
                                  assets: [
                                    MyAsset(
                                        size: 15,
                                        color:
                                            Constants.getColorFromHex("D0E2E2"),
                                        title: "0"),
                                    MyAsset(
                                        size: 3,
                                        color:
                                            Constants.getColorFromHex("9ADF9C"),
                                        title: "16"),
                                    MyAsset(
                                        size: 7,
                                        color:
                                            Constants.getColorFromHex("1EDC3E"),
                                        title: "18"),
                                    MyAsset(
                                        size: 5,
                                        color:
                                            Constants.getColorFromHex("DCE683"),
                                        title: "25"),
                                    MyAsset(
                                        size: 5,
                                        color:
                                            Constants.getColorFromHex("FF9A00"),
                                        title: "30"),
                                    MyAsset(
                                        size: 5,
                                        color:
                                            Constants.getColorFromHex("E26F76"),
                                        title: "35"),
                                    MyAsset(
                                        size: 10,
                                        color:
                                            Constants.getColorFromHex("EF3737"),
                                        title: "40"),
                                  ],
                                ),
                              ),
                            ),
                            flex: 1,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.white,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: bmiDarkBgColor,
                  ),
                  padding: EdgeInsets.all(7),
                  child: InkWell(
                    onTap: () {
                      showWeightHeightDialog(context);
                    },
                    child: Stack(
                      children: [
                        Center(
                          child: getMediumNormalTextWithMaxLine(
                              "Check Now", Colors.white, 1, TextAlign.center),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1), //(x,y)
                    blurRadius: 2)
              ],
              color: Colors.white,
            ),
            child: TableCalendar(
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                // selectedColor: (Colors.deepOrange[400]),

                outsideDaysVisible: false,
                // weekdayStyle: TextStyle(
                //     color: Colors.black, fontFamily: Constants.fontsFamily),
              ),
              headerStyle: HeaderStyle(
                formatButtonTextStyle: TextStyle()
                    .copyWith(color: Colors.transparent, fontSize: 0),
                formatButtonDecoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),

              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  selectedDateTime = selectedDay;
                });
              },

              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              // onDaySelected: (day, events, holidays) {
              //   selectedDateTime = day;
              //   print("getcheckedday==${day.day}-${day.month}-${day.year}");
              //   setState(() {});
              // },
              // onVisibleDaysChanged: (first, last, format) {},
              // onCalendarCreated: (first, last, format) {},
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            color: Colors.white,
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(7),
                  child: getCustomText("RESUMÉN", Colors.black, 1,
                      TextAlign.start, FontWeight.bold, 18),
                ),
                Align(
                    alignment: Alignment.center,
                    child: getCustomText(
                        Constants.historyTitleDateFormat
                            .format(selectedDateTime),
                        Colors.black,
                        1,
                        TextAlign.center,
                        FontWeight.w600,
                        15)),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    getCustomText("3 Entrenos", Colors.black, 1,
                        TextAlign.start, FontWeight.w400, 15),
                    Expanded(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(Icons.timer,
                                  color: Colors.blueAccent, size: 20),
                            ),
                            WidgetSpan(
                                child: SizedBox(
                              width: 10,
                            )),
                            TextSpan(
                                text: "20:55",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: Constants.fontsFamily,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(Icons.local_fire_department_outlined,
                                  color: Colors.red, size: 20),
                            ),
                            WidgetSpan(
                                child: SizedBox(
                              width: 10,
                            )),
                            TextSpan(
                                text: "245 Kcal",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: Constants.fontsFamily,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                      flex: 1,
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.safeBlockHorizontal! * 4,
                      right: SizeConfig.safeBlockHorizontal! * 4),
                  child: Divider(
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                FutureBuilder<List<ModelHistory>>(
                  future: _dataHelper.getHistoryByDate(
                      Constants.addDateFormat.format(selectedDateTime)),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      List<ModelHistory> modelHistory = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: modelHistory.length,
                        itemBuilder: (context, index) {
                          ModelHistory _modelHistory = modelHistory[index];
                          return Container(
                            width: double.infinity,
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)),
                                border:
                                    Border.all(color: Colors.grey, width: 0.5)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: SizeConfig.safeBlockHorizontal! * 3,
                                ),
                                Image.asset(
                                  Constants.assetsImagePath + "dumbbell.png",
                                  width: SizeConfig.safeBlockHorizontal! * 12,
                                  height: SizeConfig.safeBlockHorizontal! * 12,
                                ),
                                SizedBox(
                                  width: SizeConfig.safeBlockHorizontal! * 5,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getSmallBoldTextWithMaxLine(
                                          _modelHistory.title!,
                                          Colors.black87,
                                          1),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      getSmallNormalTextWithMaxLine(
                                        _modelHistory.startTime!,
                                        Colors.grey,
                                        1,
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: [
                                              WidgetSpan(
                                                child: Icon(Icons.timer,
                                                    color: Colors.blueAccent,
                                                    size: 15),
                                              ),
                                              WidgetSpan(
                                                  child: SizedBox(
                                                width: 10,
                                              )),
                                              TextSpan(
                                                  text: _modelHistory
                                                      .totalDuration
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily:
                                                          Constants.fontsFamily,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              WidgetSpan(
                                                  child: SizedBox(
                                                width: 10,
                                              )),
                                              WidgetSpan(
                                                child: Icon(
                                                    Icons
                                                        .local_fire_department_outlined,
                                                    color: Colors.redAccent,
                                                    size: 15),
                                              ),
                                              WidgetSpan(
                                                  child: SizedBox(
                                                width: 10,
                                              )),
                                              TextSpan(
                                                  text:
                                                      "${_modelHistory.kCal} Kcal",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily:
                                                          Constants.fontsFamily,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400))
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  flex: 1,
                                )
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return Container(
                          padding: EdgeInsets.all(10),
                          child: Align(
                            alignment: Alignment.center,
                            child: getSmallNormalTextWithMaxLine(
                                "Sin Resumen", Colors.black, 1),
                          ));
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TabDiscover extends StatefulWidget {
  @override
  _TabDiscover createState() => _TabDiscover();
}

var cardAspectRatio = 16.0 / 20.0;
// var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

// ignore: must_be_immutable
class CardScrollWidget extends StatelessWidget {
  var currentPage;
  var padding = 20.0;
  var verticalInset = 20.0;
  List<ModelDiscover> _discoverList;

  CardScrollWidget(this.currentPage, this._discoverList);

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, contraints) {
        var width = contraints.maxWidth;
        var height = contraints.maxHeight;

        var safeWidth = width - 2 * padding;
        var safeHeight = height - 2 * padding;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = [];

        for (var i = 0; i < 4; i++) {
          var delta = i - currentPage;
          bool isOnRight = delta > 0;

          var start = padding +
              max(
                  primaryCardLeft -
                      horizontalInset * -delta * (isOnRight ? 15 : 1),
                  0.0);

          var cardItem = Positioned.directional(
            top: padding + verticalInset * max(-delta, 0.0),
            bottom: padding + verticalInset * max(-delta, 0.0),
            start: start,
            textDirection: TextDirection.rtl,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      Constants.getColorFromHex(_discoverList[i].background!),
                ),
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.asset(
                          Constants.assetsImagePath + "pattern_discover.png",
                          fit: BoxFit.fill),
                      Padding(
                        padding: EdgeInsets.all(7),
                        child: Image.asset(
                            Constants.assetsImagePath + _discoverList[i].image!,
                            fit: BoxFit.scaleDown),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                // List: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(100, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 0),
                                child: Text(
                                  _discoverList[i].title!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontFamily: Constants.fontsFamily,
                                    fontStyle: FontStyle.italic,
                                    // fontSize: 20.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0,
                                      top: 3.0,
                                      bottom: 10.0),
                                  child: Text(
                                    _discoverList[i].description!,
                                    style: TextStyle(
                                        fontFamily: Constants.fontsFamily,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w200,
                                        color: Colors.white,
                                        height: 1.5,
                                        letterSpacing: 1),
                                    maxLines: 4,
                                    textAlign: TextAlign.start,
                                  ))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // ),
              ),
            ),
          );

          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
  }
}

class _TabDiscover extends State<TabDiscover> {
  DataHelper _dataHelper = DataHelper.instance;
  List<ModelWorkoutList> _workoutList = [];
  List<ModelDiscover> _discoverList = [];

  void sendToWorkoutList(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return WidgetWorkoutExerciseList(_workoutList[0]);
      },
    ));
  }

  // var currentPage = ;
  var currentPage = 2 - 1.0;

  @override
  void initState() {
    _dataHelper.getWorkoutList().then((value) {
      _workoutList = value;
      setState(() {});
    });
    _dataHelper.getAllDiscoverWorkouts().then((value) {
      if (value.length > 0) {
        setState(() {
          _discoverList = value;
          currentPage = _discoverList.length - 1.0;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    PageController controller =
        PageController(initialPage: _discoverList.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page!;
      });
    });

    double textMargin = SizeConfig.safeBlockHorizontal! * 3.5;
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: bgDarkWhite,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (_discoverList.isNotEmpty)
                ? Stack(
                    children: <Widget>[
                      CardScrollWidget(currentPage, _discoverList),
                      Positioned.fill(
                        child: PageView.builder(
                          itemCount: _discoverList.length,
                          controller: controller,
                          reverse: true,
                          itemBuilder: (context, index) {
                            // return Container();
                            return InkWell(
                              onTap: () {
                                sendToWorkoutList(context);
                                print("Seleccionado");
                              },
                              child: Container(),
                            );
                          },
                        ),
                      )
                    ],
                  )
                : getProgressDialog(),
            Padding(
                padding: EdgeInsets.all(textMargin),
                child: getTitleTexts(S.of(context).quickWorkouts)),
            FutureBuilder<List<ModelQuickWorkout>>(
              future: _dataHelper.getAllQuickWorkoutList(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  List<ModelQuickWorkout> _quickWorkoutList = snapshot.data!;
                  // print("getsize====${_quickWorkoutList.length}");
                  return Container(
                    margin: EdgeInsets.all(5),
                    height: SizeConfig.safeBlockHorizontal! * 28,
                    child: ListView.builder(
                      itemCount: _quickWorkoutList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        ModelQuickWorkout _modelQuickWorkout =
                            _quickWorkoutList[index];
                        return InkWell(
                          child: Container(
                            width: SizeConfig.safeBlockHorizontal! * 28,
                            height: double.infinity,
                            padding: EdgeInsets.all(7),
                            margin: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.5), //(x,y)
                                  blurRadius: 2.5,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  Constants.assetsImagePath +
                                      _modelQuickWorkout.image!,
                                  height: SizeConfig.safeBlockHorizontal! * 14,
                                  width: SizeConfig.safeBlockHorizontal! * 14,
                                  fit: BoxFit.contain,
                                ),
                                Expanded(
                                  child: SizedBox(),
                                  flex: 1,
                                ),
                                getCustomText(
                                    _modelQuickWorkout.name!,
                                    quickSvgColor,
                                    1,
                                    TextAlign.center,
                                    FontWeight.bold,
                                    14)
                              ],
                            ),
                          ),
                          onTap: () {
                            sendToWorkoutList(context);
                          },
                        );
                      },
                    ),
                  );
                } else {
                  return getProgressDialog();
                }
              },
            ),
            Padding(
                padding: EdgeInsets.all(textMargin),
                child: getTitleTexts(S.of(context).stretches)),
            FutureBuilder<List<ModelPopularWorkout>>(
              future: _dataHelper.getAllStretchesList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ModelPopularWorkout> _quickWorkoutList = snapshot.data!;
                  // print("getsize====${_quickWorkoutList.length}");
                  return Container(
                    margin: EdgeInsets.all(5),
                    child: ListView.builder(
                      itemCount: _quickWorkoutList.length,
                      primary: false,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        ModelPopularWorkout _modelQuickWorkout =
                            _quickWorkoutList[index];
                        return InkWell(
                          onTap: () {
                            sendToWorkoutList(context);
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.only(left: 7, right: 7),
                            width: double.infinity,
                            height: SizeConfig.safeBlockHorizontal! * 18,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                // color: Constants.getColorFromHex(
                                //     _modelQuickWorkout.color),
                                gradient: new LinearGradient(
                                    colors: [
                                      Constants.darken(
                                          Constants.getColorFromHex(
                                              _modelQuickWorkout.color!)),
                                      Constants.brighten(
                                          Constants.getColorFromHex(
                                              _modelQuickWorkout.color!)),
                                      // darken(Color(0xFF3366FF)),
                                      // const Color(0xFF00CCFF),
                                    ],
                                    begin: const FractionalOffset(0.0, 0.0),
                                    end: const FractionalOffset(1.0, 0.0),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp)),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SvgPicture.asset(
                                    Constants.assetsImagePath +
                                        _modelQuickWorkout.image!,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: SizeConfig.safeBlockHorizontal! *
                                            25),
                                    child: getCustomText(
                                        _modelQuickWorkout.name!,
                                        Colors.white,
                                        2,
                                        TextAlign.start,
                                        FontWeight.bold,
                                        18),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return getProgressDialog();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeWidget extends State<HomeWidget> {
  int _currentIndex = 0;

  _HomeWidget(this._currentIndex);

  List<Destination> allDestinations = [];

  static List<Widget> _widgetOptions = <Widget>[
    TabHome(),
    TabDiscover(),
    TabActivity(),
    TabSettings()
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    allDestinations = <Destination>[
      Destination(S.of(context).home, S.of(context).homeWorkouts,
          CupertinoIcons.home, Colors.teal),
      Destination(S.of(context).discover, S.of(context).discover,
          CupertinoIcons.search, Colors.cyan),
      Destination(S.of(context).activity, S.of(context).activity,
          CupertinoIcons.chart_bar_square, Colors.orange),
      // Destination('School', CupertinoIcons.chart_bar_square, Colors.orange),
      Destination(S.of(context).settings, S.of(context).settings,
          Icons.settings, Colors.blue)
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: new AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: bgDarkWhite,
            title: getCustomText(allDestinations[_currentIndex].toolbarTitle,
                accentColor, 1, TextAlign.start, FontWeight.w500, 20),
          ),
          body: SafeArea(
            top: false,
            child: _widgetOptions[this._currentIndex],
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: accentColor,
            unselectedItemColor: Colors.black87,
            currentIndex: _currentIndex,
            selectedLabelStyle: TextStyle(
                fontFamily: Constants.fontsFamily,
                fontWeight: FontWeight.w600,
                fontSize: 12),
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: allDestinations.map((Destination destination) {
              return BottomNavigationBarItem(
                  icon: Icon(destination.icon),
                  backgroundColor: Colors.white,
                  // backgroundColor: destination.color,
                  // activeIcon: Icon(destination.icon,color: accentColor,),
                  label: destination.title);
            }).toList(),
          ),
        ),
        onWillPop: () async {
          if (_currentIndex != 0) {
            setState(() {
              _currentIndex = 0;
            });
          } else {
            Future.delayed(const Duration(milliseconds: 100), () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            });
          }
          return false;
        });
  }
}
