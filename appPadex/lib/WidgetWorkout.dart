import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
// import 'package:share_plus/share_plus.dart';

import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'AdsInfo.dart';
import 'ColorCategory.dart';
import 'Constants.dart';
import 'HomeWidget.dart';
import 'SizeConfig.dart';
import 'Widgets.dart';
import 'db/DataHelper.dart';
import 'generated/l10n.dart';
import 'models/ModelExerciseDetail.dart';
import 'models/ModelWorkoutExerciseList.dart';
import 'models/ModelWorkoutList.dart';

// ignore: must_be_immutable
class WidgetWorkout extends StatefulWidget {
  List<ModelWorkoutExerciseList> _modelExerciseList;

  WidgetWorkout(this._modelExerciseList);

  @override
  _WidgetWorkout createState() => _WidgetWorkout();
}

// ignore: must_be_immutable
class WidgetSkipData extends StatefulWidget {
  ModelExerciseDetail _modelExerciseDetail;
  ModelWorkoutExerciseList _modelExerciseList;
  Function() _functionSkip;
  int totalPos;
  int currentPos;

  WidgetSkipData(this._modelExerciseDetail, this._modelExerciseList,
      this._functionSkip, this.currentPos, this.totalPos);

  @override
  _WidgetSkipData createState() => _WidgetSkipData();
}

class _WidgetSkipData extends State<WidgetSkipData>
    with WidgetsBindingObserver {
  int skiptime = 10;
  Timer? _timer;
  String currentTime = "";

  // FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.youtube.com/embed/ml6cT4AZdqI'));
    setState(() {});

    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    super.initState();
  }

  void cancelSkipTimer() {
    _timer!.cancel();
    _timer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("getstate1==$state");

    if (state == AppLifecycleState.paused) {
      pauseSkip();
    } else if (state == AppLifecycleState.resumed) {
      if (!isSkipDialogOpen) {
        resumeSkip();
      }
    }
  }

  void setSkipTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => {
              if (mounted)
                {
                  setState(
                    () {
                      // currentTime = timer.tick.toString();
                      if (skiptime < 1) {
                        cancelSkipTimer();
                        // widget.timerOverCallback();

                        // cancelTimer();
                        // widget.timerOverCallback();
                        widget._functionSkip();
                      } else {
                        skiptime = skiptime - 1;
                      }
                      currentTime = skiptime.toString();
                    },
                  ),
                }
            });
  }

  // BannerAd? _anchoredBanner;
  // bool _loadingAnchoredBanner = false;

  // Future<void> _createAnchoredBanner(BuildContext context) async {
  //   final AnchoredAdaptiveBannerAdSize? size =
  //       await AdSize.getAnchoredAdaptiveBannerAdSize(
  //     Orientation.portrait,
  //     MediaQuery.of(context).size.width.truncate(),
  //   );
  //
  //   if (size == null) {
  //     print('Unable to get height of anchored banner.');
  //     return;
  //   }
  //   final AdRequest request = AdRequest(
  //     keywords: <String>['foo', 'bar'],
  //     contentUrl: 'http://foo.com/bar.html',
  //     nonPersonalizedAds: true,
  //   );
  //
  //   final BannerAd banner = BannerAd(
  //     size: AdSize.mediumRectangle,
  //     request: request,
  //     adUnitId: AdsInfo.getBannerAdUnitId(),
  //     listener: BannerAdListener(
  //       onAdLoaded: (Ad ad) {
  //         print('$BannerAd loaded.');
  //         setState(() {
  //           _anchoredBanner = ad as BannerAd?;
  //         });
  //       },
  //       onAdFailedToLoad: (Ad ad, LoadAdError error) {
  //         print('$BannerAd failedToLoad: $error');
  //         ad.dispose();
  //       },
  //       onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
  //       onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
  //     ),
  //   );
  //   return banner.load();
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timer != null) {
      cancelSkipTimer();
    }

    // if (_anchoredBanner != null) {
    //   _anchoredBanner!.dispose();
    // }
    super.dispose();
  }

  PageController controller = PageController();
  WebViewController? webViewController;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  bool isSkipDialogOpen = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (_timer == null) {
      setSkipTimer();
    }
    // if (!_loadingAnchoredBanner) {
    //   _loadingAnchoredBanner = true;
    //   _createAnchoredBanner(context);
    // }

    return Container(
      key: scaffoldState,
      width: double.infinity,
      height: double.infinity,
      color: Colors.black54,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              margin: EdgeInsets.all(15),

              // child: Container(
              //   height: (_anchoredBanner != null)
              //       ? _anchoredBanner!.size.height.toDouble()
              //       : 0,
              //   // color: Colors.red,
              //   child: (_anchoredBanner != null)
              //       ? AdWidget(ad: _anchoredBanner!)
              //       : Container(),
              // ),
              // child: AdmobBanner(
              //   adUnitId: AdsInfo.getBannerAdUnitId(),
              //   adSize: AdmobBannerSize(
              //       width: MediaQuery.of(context).size.width.toInt(),
              //       height: MediaQuery.of(context).size.width.toInt(),
              //       name: 'MEDIUM_RECTANGLE'),
              //   // name: 'LARGE_BANNER'),
              //   // adSize: AdmobBannerSize(width: 300, height: 250),
              //   listener: (AdmobAdEvent event, Map<String, dynamic> args) {
              //     // handleEvent(event, args, 'Banner');
              //   },
              //   onBannerCreated: (AdmobBannerController controller) {
              //     // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
              //     // Normally you don't need to worry about disposing this yourself, it's handled.
              //     // If you need direct access to dispose, this is your guy!
              //     // controller.dispose();
              //   },
              // ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "DESCANSO",
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: Constants.fontsFamily,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        skiptime = skiptime + 20;
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 15, top: 7, bottom: 7, right: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Colors.grey),
                        child: getSmallBoldTextWithMaxLine(
                            "+ 20 Sec", Colors.black, 1),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: getCustomText(currentTime, Colors.white, 1,
                            TextAlign.center, FontWeight.w700, 40),
                      ),
                    ),
                    InkWell(
                      child: getCustomText("SALTAR", Colors.grey, 1,
                          TextAlign.start, FontWeight.bold, 28),
                      onTap: () {
                        widget._functionSkip();
                      },
                    )
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: getMediumBoldText(
                "Más Adelante:", Colors.white, TextAlign.start),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Colors.white),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin:
                      EdgeInsets.only(left: 7, top: 7, bottom: 7, right: 15),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black12),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Image.asset(
                    "${Constants.assetsGifPath}${widget._modelExerciseDetail.image}",
                    height: 80,
                    width: 80,
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getMediumNormalTextWithMaxLine(
                          widget._modelExerciseDetail.name!,
                          Colors.black,
                          2,
                          TextAlign.start),
                      getExtraSmallNormalTextWithMaxLine(
                          widget._modelExerciseList.duration! + " Seconds",
                          Colors.black45,
                          1,
                          TextAlign.start)
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert_rounded),
                  onPressed: () {
                    ModelExerciseDetail exerciseDetail =
                        widget._modelExerciseDetail;
                    isSkipDialogOpen = true;
                    pauseSkip();
                    showModalBottomSheet<void>(
                      enableDrag: true,
                      isScrollControlled: true,
                      backgroundColor: bgDarkWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                      ),
                      context: context,
                      builder: (context) {
                        return Container(
                          width: double.infinity,
                          height: SizeConfig.safeBlockVertical! * 80,
                          child: ListView(
                            padding: EdgeInsets.all(7),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            primary: false,
                            children: [
                              Container(
                                width: double.infinity,
                                height: SizeConfig.safeBlockVertical! * 40,
                                child: PageView(
                                  controller: controller,
                                  children: <Widget>[
                                    // KeepAlivePage(child:
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Stack(children: [
                                        Image.asset(
                                          "${Constants.assetsGifPath}${exerciseDetail.image}",
                                          height: double.infinity,
                                          width: double.infinity,
                                          fit: BoxFit.none,
                                          // )
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            onPressed: () {
                                              // controller.jumpToPage(1);
                                              controller.animateToPage(1,
                                                  curve: Curves.decelerate,
                                                  duration: Duration(
                                                      milliseconds: 300));
                                            },
                                            padding: EdgeInsets.all(7),
                                            icon: Icon(
                                              Icons.videocam,
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      ]),
                                    ),
                                    // KeepAlivePage(
                                    //     child:
                                    Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Column(children: <Widget>[
                                          Expanded(
                                            child: Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                child: webViewController == null
                                                    ? Container()
                                                    : WebViewWidget(
                                                        controller:
                                                            webViewController!,
                                                      )
                                                // child: InAppWebView(
                                                //   initialUrlRequest:
                                                //   URLRequest(url: Uri.parse("https://www.youtube.com/embed/ml6cT4AZdqI")),
                                                //   // initialUrl:
                                                //   //     "https://www.youtube.com/embed/ml6cT4AZdqI",
                                                //
                                                //   initialOptions: InAppWebViewGroupOptions(
                                                //       crossPlatform: InAppWebViewOptions(
                                                //
                                                //       )),
                                                //   onWebViewCreated:
                                                //       (InAppWebViewController controller) {
                                                //     webView = controller;
                                                //   },
                                                //   onLoadStart: (controller, url) {
                                                //     setState(() {
                                                //
                                                //
                                                //     });
                                                //   },
                                                //
                                                //
                                                //
                                                // ),
                                                ),
                                          ),
                                        ]))
                                    // )
                                    ,
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(7),
                                child: Text(
                                  exerciseDetail.name!,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 20,
                                    fontFamily: Constants.fontsFamily,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              getCustomText("Como Realizarlo", Colors.black, 1,
                                  TextAlign.start, FontWeight.w600, 18),
                              SizedBox(
                                height: 7,
                              ),
                              Html(
                                data: exerciseDetail.detail!,
                              )
                            ],
                          ),
                        );
                      },
                    ).whenComplete(() {
                      isSkipDialogOpen = false;
                      resumeSkip();
                    });
                  },
                  padding: EdgeInsets.all(7),
                )
              ],
            ),
          ),
          StepProgressIndicator(
            totalSteps: widget.totalPos,
            currentStep: widget.currentPos,
            selectedColor: Colors.green,
            unselectedColor: Colors.transparent,
          )
        ],
      ),
    );
  }

  void pauseSkip() {
    if (_timer != null) {
      cancelSkipTimer();
    }
  }

  void resumeSkip() {
    if (_timer == null) {
      setSkipTimer();
    }
  }
}

// ignore: must_be_immutable
class WidgetDetailData extends StatefulWidget {
  // ModelWorkoutExerciseList _modelExerciseList;
  ModelExerciseDetail _modelExerciseDetail;
  bool fromFirst;
  Function() timerOverCallback;

  WidgetDetailData(_modelExerciseList, this._modelExerciseDetail,
      this.timerOverCallback, this.fromFirst);

  @override
  State<StatefulWidget> createState() => _WidgetDetailData();
}

class _WidgetDetailData extends State<WidgetDetailData>
    with WidgetsBindingObserver {
  int totalTimerTime = 0;
  String currentTime = "";
  Timer? _timer;
  WebViewController? webViewController;

  // Timer _timer = null;

  @override
  void initState() {
    _timer = null;
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.youtube.com/embed/ml6cT4AZdqI'));
    setState(() {});
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  showSoundDialog() async {
    showDialog(
        context: context,
        builder: (BuildContext? context) {
          bool isSwitched = false;

          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  width: 300.0,
                  padding:
                      EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      getCustomText("Opciones de Sonido", Colors.black87, 1,
                          TextAlign.start, FontWeight.w600, 20),
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
                                "Silencio", Colors.black, 1),
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
                    Navigator.pop(context!);
                  }),
            ],
          );
        });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('Estado = $state');
    if (state == AppLifecycleState.paused) {
      if (_timer != null) {
        pauseTimer();
      }
    }
  }

  IconData getPlayPauseIcon() {
    if (_timer == null) {
      return Icons.play_arrow_rounded;
    } else {
      return Icons.pause_rounded;
    }
  }

  void cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => {
              if (mounted)
                {
                  setState(
                    () {
                      // currentTime = timer.tick.toString();
                      if (totalTimerTime < 1) {
                        // timer.cancel();
                        // _timer = null;
                        // widget.timerOverCallback();
                        cancelTimer();
                        widget.timerOverCallback();
                      } else {
                        totalTimerTime = totalTimerTime - 1;
                      }
                      currentTime = totalTimerTime.toString();
                    },
                  ),
                }
            });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cancelTimer();
    super.dispose();
  }

  void showBottomDialog(ModelExerciseDetail exerciseDetail) {
    showModalBottomSheet<void>(
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          height: SizeConfig.safeBlockVertical! * 80,
          child: ListView(
            padding: EdgeInsets.all(7),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            primary: false,
            children: [
              Container(
                width: double.infinity,
                height: SizeConfig.safeBlockVertical! * 40,
                child: PageView(
                  controller: controller,
                  children: <Widget>[
                    // KeepAlivePage(child:
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Stack(children: [
                        Image.asset(
                          "${Constants.assetsGifPath}${exerciseDetail.image}",
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          // )
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              // controller.jumpToPage(1);
                              controller.animateToPage(1,
                                  curve: Curves.decelerate,
                                  duration: Duration(milliseconds: 300));
                            },
                            padding: EdgeInsets.all(7),
                            icon: Icon(
                              Icons.videocam,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ]),
                    ),
                    // KeepAlivePage(
                    //     child:
                    Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(children: <Widget>[
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: webViewController == null
                                  ? Container()
                                  : WebViewWidget(
                                      controller: webViewController!,
                                      // initialUrl:
                                      //     'https://www.youtube.com/embed/ml6cT4AZdqI',
                                    ),
                              // child: InAppWebView(
                              //   initialUrlRequest:
                              //   URLRequest(url: Uri.parse("https://www.youtube.com/embed/ml6cT4AZdqI")),
                              //   // initialUrl:
                              //   //     "https://www.youtube.com/embed/ml6cT4AZdqI",
                              //
                              //   initialOptions: InAppWebViewGroupOptions(
                              //       crossPlatform: InAppWebViewOptions(
                              //
                              //       )),
                              //   onWebViewCreated:
                              //       (InAppWebViewController controller) {
                              //     webView = controller;
                              //   },
                              //   onLoadStart: (controller, url) {
                              //     setState(() {
                              //
                              //
                              //     });
                              //   },
                              //
                              //
                              //
                              // ),
                            ),
                          ),
                        ]))
                    // )
                    ,
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(7),
                child: Text(
                  exerciseDetail.name!,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    fontFamily: Constants.fontsFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              getCustomText("Como Realizarlo", Colors.black, 1, TextAlign.start,
                  FontWeight.w600, 18),
              SizedBox(
                height: 7,
              ),

              Html(
                data: exerciseDetail.detail!,
              )
              // HtmlWidget(
              //   exerciseDetail.detail!,
              //   textStyle: TextStyle(
              //       color: Colors.black,
              //       fontSize: 15,
              //       wordSpacing: 2,
              //       fontFamily: Constants.fontsFamily,
              //       fontWeight: FontWeight.normal),
              // )
            ],
          ),
        );
      },
    );
  }

  PageController controller = PageController();
  // InAppWebViewController? webView;

  @override
  Widget build(BuildContext context) {
    // print("fromfirst===${widget.fromFirst}");
    if (widget.fromFirst) {
      widget.fromFirst = false;
      // print("fromfirst2===${widget.fromFirst}");

      currentTime = "10";
      totalTimerTime = 10;
      // print("insetDatas==={totalTimerTime}");
      if (_timer == null) {
        startTimer();
      }
    }
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: bgDarkWhite,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                Center(
                  child: Image.asset(
                    "${Constants.assetsGifPath}${widget._modelExerciseDetail.image}",
                    fit: BoxFit.none,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.videocam),
                        color: Colors.black87,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.volume_up_rounded),
                        color: Colors.black87,
                        onPressed: () {
                          showSoundDialog();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.info),
                        color: Colors.black87,
                        onPressed: () {
                          pauseTimer();
                          showBottomDialog(widget._modelExerciseDetail);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          getCustomText(widget._modelExerciseDetail.name!, Colors.black87, 1,
              TextAlign.center, FontWeight.w600, 22),
          Padding(
            padding: EdgeInsets.all(7),
            child: getLargeBoldTextWithMaxLine(currentTime, Colors.black87, 1),
          ),
          Row(
            children: [
              MaterialButton(
                onPressed: () {},
                color: Colors.grey,
                textColor: Colors.white,
                child: Image.asset(
                  Constants.assetsImagePath + "prev_arrow.png",
                  width: 30,
                  height: 30,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(12),
                shape: CircleBorder(),
              ),
              Expanded(
                flex: 1,
                child: MaterialButton(
                  onPressed: () {
                    pauseTimer();
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Icon(
                    getPlayPauseIcon(),
                    size: 30,
                  ),
                  padding: EdgeInsets.all(18),
                  shape: CircleBorder(),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  cancelTimer();
                  widget.timerOverCallback();
                },
                color: Colors.black54,
                textColor: Colors.white,
                child: Image.asset(
                  Constants.assetsImagePath + "next_arrow.png",
                  width: 30,
                  height: 30,
                  color: Colors.white,
                ),
                // Icon(
                //   Icons.arrow_forward_rounded,
                //   size: 30,
                // ),
                padding: EdgeInsets.all(12),
                shape: CircleBorder(),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  void pauseTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    } else {
      startTimer();
    }
    setState(() {});
  }
}

class _WidgetWorkout extends State<WidgetWorkout> {
  // PausableTimer timer=null;
  // PausableTimer timer = PausableTimer(Duration(seconds: int.parse(widget._modelExerciseList[0].duration)), () => print('Fired!'));
  // Timer _timer;
  DataHelper _dataHelper = DataHelper.instance;
  int pos = 0;
  bool isSkip = false;
  ModelWorkoutList? _modelWorkoutList;
  int getCal = 0;
  int getTotalWorkout = 0;
  List priceList = [];
  int getTime = 0;

  // FlutterTts? flutterTts;

  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;

  void _calcTotal() async {
    priceList = await _dataHelper.calculateTotalWorkout();
    if (priceList.length > 0) {
      getTotalWorkout = priceList.length;
      priceList.forEach((price) {
        getCal = getCal + price['kcal'] as int;
      });
      getTime = getTotalWorkout * 2;

      print("getval=$getCal");
      // setState(() {});
    }
  }

  void setDataByPos() {
    print("getpos===$pos");
    if (pos < widget._modelExerciseList.length) {
      pos++;
      isSkip = true;
    } else {
      isSkip = false;
    }
    setState(() {});
  }

  void setAfterSkip() {
    print("getpos===$pos");
    isSkip = false;
    setState(() {});
  }

  @override
  void dispose() {
    // try {
    //   _voiceController.stop();
    // } catch (e) {
    //   print(e);
    // }
    // flutterTts!.stop();

    super.dispose();
  }

  void initTts() {}

  @override
  void initState() {
    // flutterTts = FlutterTts();

    _dataHelper
        .getWorkoutLevelById(widget._modelExerciseList[0].id!)
        .then((value) {
      _modelWorkoutList = value;
    });

    _calcTotal();

    super.initState();
  }

  Future<void> share() async {
    // Share.share( S.of(context).app_name, subject: 'https://flutter.dev/');
  }

  Future _speak(String txt) async {
    // await flutterTts!.speak(txt);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // if (pos < widget._modelExerciseList.length) {
    //   _dataHelper.addHistoryData(
    //       widget., start_time, total_duration, kcal, date)
    // }
    print("mainrefresh==t=rue${widget._modelExerciseList.length}");
    return WillPopScope(
      child: Scaffold(
          body: SafeArea(
        child: (pos < widget._modelExerciseList.length)
            // body: (!isSkip)
            ? FutureBuilder<ModelExerciseDetail?>(
                future: _dataHelper.getExerciseDetailById(
                    widget._modelExerciseList[pos].exerciseId!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    ModelExerciseDetail _modelExerciseDetail = snapshot.data!;
                    if (isSkip) {
                      _speak("Toma un Descanso");
                      return WidgetSkipData(
                          _modelExerciseDetail,
                          widget._modelExerciseList[pos],
                          setAfterSkip,
                          pos,
                          widget._modelExerciseList.length);
                    } else {
                      _speak(_modelExerciseDetail.name!);

                      return WidgetDetailData(widget._modelExerciseList[pos],
                          _modelExerciseDetail, setDataByPos, true);
                    }
                  } else {
                    return getProgressDialog();
                  }
                },
              )
            : FutureBuilder<ModelWorkoutList>(
                future: _dataHelper.getWorkoutLevelById(
                    widget._modelExerciseList[0].workoutId!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _dataHelper.addHistoryData(
                        snapshot.data!.name!,
                        "10:00 AM",
                        1200,
                        10,
                        Constants.addDateFormat.format(new DateTime.now()));
                  }
                  return Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: bgDarkWhite,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.share,
                              color: Colors.black,
                            ),
                            padding: EdgeInsets.all(10),
                            onPressed: () {
                              share();
                            },
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: SizeConfig.safeBlockVertical! * 30,
                          child: Lottie.asset(
                              Constants.assetsImagePath + "trophy.json",
                              width: double.infinity,
                              height: double.infinity,
                              reverse: false,
                              fit: BoxFit.contain,
                              repeat: false),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical! * 10,
                        ),
                        getMediumBoldItalicText(
                            _modelWorkoutList!.name!, Colors.black),
                        SizedBox(
                          height: 7,
                        ),
                        SvgPicture.asset(
                          Constants.assetsImagePath + "completed_banner.svg",
                          height: SizeConfig.safeBlockHorizontal! * 25,
                          width: SizeConfig.safeBlockHorizontal! * 50,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.safeBlockHorizontal! * 10,
                              right: SizeConfig.safeBlockHorizontal! * 10,
                              bottom: 10),
                          child: Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: SizeConfig.safeBlockHorizontal! * 5,
                            right: SizeConfig.safeBlockHorizontal! * 5,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    getMediumBoldTextWithMaxLine(
                                        widget._modelExerciseList.length
                                            .toString(),
                                        Colors.black,
                                        1),
                                    Padding(
                                      padding: EdgeInsets.all(0),
                                      child: getMediumTextWithWeight(
                                          S.of(context).exercises,
                                          Colors.grey,
                                          1,
                                          FontWeight.w600),
                                    )
                                  ],
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    getMediumBoldTextWithMaxLine(
                                        getCal.toString(), Colors.black, 1),
                                    Padding(
                                      padding: EdgeInsets.all(0),
                                      child: getMediumTextWithWeight(
                                          S.of(context).kcal,
                                          Colors.grey,
                                          1,
                                          FontWeight.w600),
                                    )
                                  ],
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    getMediumBoldTextWithMaxLine(
                                        getTime.toString(), Colors.black, 1),
                                    Padding(
                                      padding: EdgeInsets.all(0),
                                      child: getMediumTextWithWeight(
                                          S.of(context).minutes,
                                          Colors.grey,
                                          1,
                                          FontWeight.w600),
                                    )
                                  ],
                                ),
                                flex: 1,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Center(
                              child: Container(
                                  margin: EdgeInsets.all(7),
                                  width: SizeConfig.safeBlockHorizontal! * 50,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        // onPrimary: Colors.black87,
                                        onPrimary: blueButton,
                                        primary: blueButton,
                                        // minimumSize: Size(88, 36),
                                        padding: EdgeInsets.all(5),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                        ),
                                      ),
                                      // shape: RoundedRectangleBorder(
                                      //     borderRadius: BorderRadius.all(
                                      //         Radius.circular(25.0))),
                                      onPressed: () {
                                        //
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                new HomeWidget(2),
                                          ),
                                        );
                                      },
                                      // textColor: Colors.white,
                                      // color: blueButton,
                                      // padding: EdgeInsets.all(5),
                                      child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 4, 0, 4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                color: blueButton,
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 4, 4, 4),
                                                child:
                                                    getSmallBoldTextWithMaxLine(
                                                        "Continuar",
                                                        Colors.white,
                                                        1),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    4, 0, 10, 0),
                                                child: Icon(
                                                  Icons.chevron_right,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                              ),
                                            ],
                                          )))),
                            ),
                          ),
                          flex: 1,
                        )
                      ],
                    ),
                    // color: Colors.red,
                  );
                },
              ),
      )),
      onWillPop: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext contexts) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: Text('Salir'),
                content: Text('Realmente quieres renunciar?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(contexts).pop();
                      Navigator.of(context).pop();
                    },
                    child:
                        getSmallNormalText("SI", Colors.red, TextAlign.start),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(contexts).pop();
                    },
                    child:
                        getSmallNormalText("N0", Colors.red, TextAlign.start),
                  )
                ],
              ),
            );
          },
        );
        // Navigator.of(context).pop();
        return false;
      },
    );
  }
}
