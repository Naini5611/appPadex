import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';

// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:share_plus/share_plus.dart';

import 'package:webview_flutter/webview_flutter.dart';

import 'AdsInfo.dart';
import 'ColorCategory.dart';
import 'Constants.dart';
import 'SizeConfig.dart';
import 'WidgetWorkout.dart';
import 'Widgets.dart';
import 'db/DataHelper.dart';
import 'generated/l10n.dart';
import 'models/ModelExerciseDetail.dart';
import 'models/ModelWorkoutExerciseList.dart';
import 'models/ModelWorkoutList.dart';

// ignore: must_be_immutable
class WidgetWorkoutExerciseList extends StatefulWidget {
  ModelWorkoutList _modelWorkoutList;

  WidgetWorkoutExerciseList(this._modelWorkoutList);

  @override
  _WidgetWorkoutExerciseList createState() => _WidgetWorkoutExerciseList();
}

class _WidgetWorkoutExerciseList extends State<WidgetWorkoutExerciseList> {
  ScrollController? _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;
  List<ModelWorkoutExerciseList> _list = [];
  DataHelper _dataHelper = DataHelper.instance;
  int getCal = 0;
  int getTime = 0;
  int getTotalWorkout = 0;
  List priceList = [];
  // AdmobInterstitial? interstitialAd;

  // InterstitialAd? _interstitialAd;
  //
  // void _createInterstitialAd() {
  //   InterstitialAd.load(
  //       adUnitId: AdsInfo.getInterstitialAdUnitId(),
  //       request: request,
  //       adLoadCallback: InterstitialAdLoadCallback(
  //         onAdLoaded: (InterstitialAd ad) {
  //           print('$ad loaded');
  //           _interstitialAd = ad;
  //         },
  //         onAdFailedToLoad: (LoadAdError error) {
  //           print('InterstitialAd failed to load: $error.');
  //           _interstitialAd = null;
  //         },
  //       ));
  // }

  void _showInterstitialAd() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return WidgetWorkout(_list);
      },
    ));
    // if(_interstitialAd == null){
    //   if (_list.length > 0) {
    //     Navigator.of(context).push(MaterialPageRoute(
    //       builder: (context) {
    //         return WidgetWorkout(_list);
    //       },
    //     ));
    //   }
    // }else {
    //
    //   _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    //     onAdShowedFullScreenContent: (InterstitialAd ad) =>
    //         print('ad onAdShowedFullScreenContent.'),
    //     onAdDismissedFullScreenContent: (InterstitialAd ad) {
    //       print('$ad onAdDismissedFullScreenContent.');
    //       ad.dispose();
    //
    //       if (_list.length > 0) {
    //         Navigator.of(context).push(MaterialPageRoute(
    //           builder: (context) {
    //             return WidgetWorkout(_list);
    //           },
    //         ));
    //       }
    //
    //       _createInterstitialAd();
    //     },
    //     onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
    //       print('$ad onAdFailedToShowFullScreenContent: $error');
    //       ad.dispose();
    //       _createInterstitialAd();
    //     },
    //   );
    //   _interstitialAd!.show();
    //   _interstitialAd = null;
    // }
  }

  // AnimationController animationController;
  WebViewController? webViewController;

  @override
  void initState() {
    _calcTotal();
    super.initState();
    // _createInterstitialAd();
    if (Platform.isAndroid)
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

    _scrollViewController = new ScrollController();
    _scrollViewController!.addListener(() {
      if (_scrollViewController!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          setState(() {});
        }
      }

      if (_scrollViewController!.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          setState(() {});
        }
      }
    });
  }

  void _calcTotal() async {
    priceList = await _dataHelper.calculateTotalWorkout();
    if (priceList.length > 0) {
      getTotalWorkout = priceList.length;
      priceList.forEach((price) {
        getCal = getCal + price['kcal'] as int;
      });

      getTime = getTotalWorkout * 2;
      setState(() {});
    }
  }

  @override
  void dispose() {
    // if (_anchoredBanner != null) {
    //   _anchoredBanner!.dispose();
    // }
    // if (_interstitialAd != null) {
    // _interstitialAd!.dispose();}
    _scrollViewController!.removeListener(() {});

    _scrollViewController!.dispose();
    super.dispose();
  }

  Future<void> share() async {
    // Share.share( S.of(context).app_name, subject: 'https://flutter.dev/');
  }

  void handleClick(String value) {
    switch (value) {
      case 'Share':
        share();
        break;
    }
  }

  // BannerAd? _anchoredBanner;
  // bool _loadingAnchoredBanner = false;

  // Future<void> _createAnchoredBanner(BuildContext context) async {
  //   final AnchoredAdaptiveBannerAdSize? size =
  //   await AdSize.getAnchoredAdaptiveBannerAdSize(
  //     Orientation.portrait,
  //     MediaQuery
  //         .of(context)
  //         .size
  //         .width
  //         .truncate(),
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
  //     size: size,
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

  PageController controller = PageController();
  // late InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // if (!_loadingAnchoredBanner) {
    //   _loadingAnchoredBanner = true;
    //   _createAnchoredBanner(context);
    // }
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: greyWhite,
                  child: Stack(
                    children: [
                      Column(
                        children: <Widget>[
                          AnimatedContainer(
                            height: _showAppbar ? 56.0 : 0.0,
                            duration: Duration(milliseconds: 200),
                            child: AppBar(
                              backgroundColor: greyWhite,
                              elevation: 0,
                              actions: <Widget>[
                                PopupMenuButton<String>(
                                  onSelected: handleClick,
                                  itemBuilder: (BuildContext context) {
                                    return {'Compartir'}.map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  },
                                )
                                //add buttons here
                              ],
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              controller: _scrollViewController,
                              child: Column(
                                children: <Widget>[
                                  Hero(
                                      tag: widget._modelWorkoutList.id!,
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(10),
                                        height:
                                            SizeConfig.safeBlockVertical! * 22,
                                        color: greyWhite,
                                        // color: greyWhite,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: 7,
                                                ),
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child:
                                                        getMediumBoldTextWithMaxLine(
                                                      widget._modelWorkoutList
                                                          .name!,
                                                      Colors.black,
                                                      1,
                                                    )),
                                              ),
                                              flex: 1,
                                            ),
                                            Card(
                                              color: darkGrey,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 3,
                                                    bottom: 3),
                                                child: getCustomText(
                                                    S
                                                        .of(context)
                                                        .transformation,
                                                    Colors.black87,
                                                    1,
                                                    TextAlign.start,
                                                    FontWeight.w600,
                                                    15),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(
                                                      children: [
                                                        WidgetSpan(
                                                          child: Icon(
                                                              Icons
                                                                  .chevron_right,
                                                              size: 20),
                                                        ),
                                                        WidgetSpan(
                                                            child: SizedBox(
                                                          width: 10,
                                                        )),
                                                        TextSpan(
                                                            text: S
                                                                .of(context)
                                                                .beginner,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontFamily:
                                                                    Constants
                                                                        .fontsFamily,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
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
                                                          child: Icon(
                                                              Icons.whatshot,
                                                              size: 20),
                                                        ),
                                                        WidgetSpan(
                                                            child: SizedBox(
                                                          width: 10,
                                                        )),
                                                        TextSpan(
                                                            text:
                                                                "$getCal ${S.of(context).calories}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontFamily:
                                                                    Constants
                                                                        .fontsFamily,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
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
                                                          child: Icon(
                                                              Icons.timer,
                                                              size: 20),
                                                        ),
                                                        WidgetSpan(
                                                            child: SizedBox(
                                                          width: 10,
                                                        )),
                                                        TextSpan(
                                                            text:
                                                                "$getTime ${S.of(context).minutes}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black87,
                                                                fontFamily:
                                                                    Constants
                                                                        .fontsFamily,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                      ],
                                                    ),
                                                  ),
                                                  flex: 1,
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 7,
                                            )
                                          ],
                                        ),
                                      )),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30)),
                                        color: Colors.white),
                                    child: FutureBuilder<
                                        List<ModelWorkoutExerciseList>>(
                                      future: _dataHelper
                                          .getWorkoutExerciseListById(
                                              widget._modelWorkoutList.id!),
                                      builder: (context, snapshot) {
                                        print("datasize===${snapshot.hasData}");
                                        if (snapshot.hasData) {
                                          _list = snapshot.data!;
                                          List<ModelWorkoutExerciseList>
                                              _exerciseList = snapshot.data!;
                                          // print("workoutlistsize===${_exerciseList.length}");
                                          return ListView.builder(
                                            itemCount: _exerciseList.length,
                                            padding: EdgeInsets.only(
                                                bottom: 25, top: 15),
                                            primary: false,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              ModelWorkoutExerciseList
                                                  _modelExerciseList =
                                                  _exerciseList[index];
                                              return FutureBuilder<
                                                  ModelExerciseDetail?>(
                                                future: _dataHelper
                                                    .getExerciseDetailById(
                                                        _modelExerciseList
                                                            .exerciseId!),
                                                builder: (context, snapshot) {
                                                  if (snapshot.data == null) {
                                                    return Container();
                                                  }
                                                  ModelExerciseDetail
                                                      exerciseDetail =
                                                      snapshot.data!;
                                                  // print(
                                                  //     "getDatas==--${exerciseDetail.image}");
                                                  if (snapshot.hasData) {
                                                    return InkWell(
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.all(5),
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            7)),
                                                            color:
                                                                Colors.white),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 7,
                                                                      top: 7,
                                                                      bottom: 7,
                                                                      right:
                                                                          15),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      width: 1,
                                                                      color: Colors
                                                                          .black12),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              12))),
                                                              child:
                                                                  Image.asset(
                                                                "${Constants.assetsGifPath}${exerciseDetail.image}",
                                                                height: SizeConfig
                                                                        .safeBlockHorizontal! *
                                                                    20,
                                                                width: SizeConfig
                                                                        .safeBlockHorizontal! *
                                                                    20,
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  getSmallBoldTextWithMaxLine(
                                                                      exerciseDetail
                                                                          .name!,
                                                                      Colors
                                                                          .black87,
                                                                      1),
                                                                  getExtraSmallNormalTextWithMaxLine(
                                                                      "${_modelExerciseList.duration} ${S.of(context).seconds}",
                                                                      Colors
                                                                          .grey,
                                                                      1,
                                                                      TextAlign
                                                                          .start)
                                                                ],
                                                              ),
                                                              flex: 1,
                                                            ),
                                                            IconButton(
                                                              onPressed: () {
                                                                showBottomDialog(
                                                                    exerciseDetail);
                                                              },
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(7),
                                                              icon: Icon(
                                                                Icons
                                                                    .more_vert_rounded,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        showBottomDialog(
                                                            exerciseDetail);
                                                      },
                                                    );
                                                  } else {
                                                    return getProgressDialog();
                                                  }
                                                },
                                              );
                                            },
                                          );
                                        } else {
                                          return getProgressDialog();
                                        }
                                      },
                                    ),
                                  )

                                  //add your screen content here
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.all(7),
                          width: SizeConfig.safeBlockHorizontal! * 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              // onPrimary: Colors.black87,
                              onPrimary: greenButton,
                              primary: greenButton,

                              // minimumSize: Size(88, 36),
                              padding: EdgeInsets.only(top: 12, bottom: 12),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)),
                              ),
                            ),

                            // shape: RoundedRectangleBorder(
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(7.0))),
                            //

                            onPressed: () async {
                              _showInterstitialAd();
                            },

                            // textColor: Colors.white,
                            // color: greenButton,
                            // padding: EdgeInsets.only(top: 12, bottom: 12),

                            child: getCustomText(
                                "EMPEZAR ENTRENAMIENTO",
                                Colors.white,
                                1,
                                TextAlign.center,
                                FontWeight.w600,
                                17),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                flex: 1,
              ),

              // Container(
              //
              //   height: (_anchoredBanner!=null)?_anchoredBanner!.size.height.toDouble():0,
              //   // color: Colors.red,
              //   child: (_anchoredBanner!=null)?AdWidget(ad: _anchoredBanner!):Container(),
              //
              // ),
              // AdmobBanner(
              //   adUnitId: AdsInfo.getBannerAdUnitId(),
              //   adSize: AdmobBannerSize.BANNER,
              //   // name: 'LARGE_BANNER'),
              //   // adSize: AdmobBannerSize(width: 300, height: 250),
              //   listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
              //   onBannerCreated: (AdmobBannerController controller) {
              //     // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
              //     // Normally you don't need to worry about disposing this yourself, it's handled.
              //     // If you need direct access to dispose, this is your guy!
              //     // controller.dispose();
              //   },
              // ),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        onBackClicked();
        return false;
      },
    );
  }

  void onBackClicked() {
    Navigator.of(context).pop();
  }

  void showBottomDialog(ModelExerciseDetail exerciseDetail) {
    showModalBottomSheet<void>(
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: bgDarkWhite,
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
                                //   )),
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
            ],
          ),
        );
      },
    );
  }
}
