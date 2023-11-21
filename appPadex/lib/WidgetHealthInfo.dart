import 'package:flutter/material.dart';

import 'ColorCategory.dart';
import 'Constants.dart';
import 'Widgets.dart';

class HealthInfo extends StatefulWidget {
  @override
  _HealthInfo createState() => _HealthInfo();
}

class _HealthInfo extends State<HealthInfo> {
  String selectedGender = "Femenino";
  String weight = "50";
  String height = "100";
  var myController = TextEditingController();

  var selectedDate = Constants.addDateFormat
      .format(DateTime.now().subtract(Duration(days: 5)));

  void onBackClicked() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    myController.text = weight;
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: bgDarkWhite,
          appBar: AppBar(
            leading: new IconButton(
                icon: new Icon(Icons.chevron_left),
                onPressed: () {
                  onBackClicked();
                }),
            title: getCustomText("Información sobre tu salud", accentColor, 1,
                TextAlign.start, FontWeight.w500, 20),
          ),
          body: Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  getMultiLineText("Genero", selectedGender, () {
                    showGenderSelectionDialog(context);
                  }),
                  getMultiLineText("Dia de nacimiento", selectedDate, () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), // Refer step 1
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    // if (picked != null && picked != selectedDate)
                    if (picked != null &&
                        Constants.addDateFormat.format(picked) != selectedDate)
                      setState(() {
                        selectedDate = Constants.addDateFormat.format(picked);
                      });
                  }),
                  getMultiLineText("Peso", weight, () {
                    myController.text = weight;
                    showWeightKGDialog(true, context);
                  }),
                  getMultiLineText("Altura", height, () {
                    myController.text = height;
                    showWeightKGDialog(false, context);
                  }),
                ],
              )),
        ),
        onWillPop: () async {
          onBackClicked();
          return false;
        });
  }

  void showGenderSelectionDialog(BuildContext contexts) async {
    List<String> ringTone = ['Femenino', 'Masculino'];
    int _currentIndex = ringTone.indexOf(selectedGender);

    return showDialog(
      context: contexts,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: getMediumBoldTextWithMaxLine(
                  "Selecciona Genero", Colors.black87, 1),
              content: Container(
                width: 300,
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
                    selectedGender = ringTone[_currentIndex];
                    Navigator.pop(context, ringTone[_currentIndex]);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    ).then((value) => {setState(() {})});
  }

  void showWeightKGDialog(bool isWeight, BuildContext contexts) async {
    return showDialog(
      context: contexts,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: getMediumBoldTextWithMaxLine(
                  isWeight ? "Seleccionar peso" : "Seleccionar altura",
                  Colors.black87,
                  1),
              content: Container(
                width: 300.0,
                padding:
                    EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    getCustomText(
                        isWeight ? "Ingresa el peso" : "Ingresa el peso",
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
                        getMediumNormalTextWithMaxLine(isWeight ? "KG" : "CM",
                            Colors.grey, 1, TextAlign.start)
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
                        backgroundColor: MaterialStateProperty.all(lightPink)),
                    child: Text(
                      'INGRESAR',
                      style: TextStyle(
                          fontFamily: Constants.fontsFamily,
                          fontSize: 15,
                          color: accentColor,
                          fontWeight: FontWeight.normal),
                    ),
                    // textColor: accentColor,
                    onPressed: () {
                      if (myController.text.isNotEmpty) {
                        if (isWeight) {
                          weight = myController.text;
                          Navigator.pop(context, weight);
                        } else {
                          height = myController.text;
                          Navigator.pop(context, height);
                        }
                      } else {
                        print("Recibir Peso===$weight");
                        Navigator.pop(context, "");
                      }
                    }),
              ],
            );
          },
        );
      },
    ).then((value) => {
          setState(() {
            // selectedGender=value;
          })
        });
  }
}
