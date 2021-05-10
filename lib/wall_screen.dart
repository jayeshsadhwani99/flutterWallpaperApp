import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'fullscreen_image.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = '';

class WallScreen extends StatefulWidget {
  @override
  _WallScreenState createState() => _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {
  static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: <String>[],
    keywords: <String>['wallpapers', 'walls', 'amoled'],
    childDirected: true,
  );

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> wallpapersList;

  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("wallpaper");

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: 'ca-app-pub-2562922579673715/7615995247',
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("Banner event: $event");
        });
  }

  InterstitialAd createInterstetialAd() {
    return InterstitialAd(
        adUnitId: "ca-app-pub-2562922579673715/5536626813",
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("Intertestial event: $event");
        });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-2562922579673715~5084845452");
    _bannerAd = createBannerAd()
      ..load()
      ..show();
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        wallpapersList = datasnapshot.docs;
      });
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd.dispose();
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallpaper App"),
      ),
      body: wallpapersList != null
          ? StaggeredGridView.countBuilder(
              padding: const EdgeInsets.all(8.0),
              crossAxisCount: 4,
              itemCount: wallpapersList.length,
              itemBuilder: (context, index) {
                String imgSrc = wallpapersList[index].get("url");
                return new Material(
                  elevation: 8.0,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImagePage(imgSrc),
                        )),
                    child: Hero(
                      tag: imgSrc,
                      child: FadeInImage(
                        image: NetworkImage(imgSrc),
                        fit: BoxFit.cover,
                        placeholder: AssetImage("assets/images/ispiner.jpg"),
                      ),
                    ),
                  ),
                );
              },
              staggeredTileBuilder: (index) =>
                  StaggeredTile.count(2, index.isEven ? 2 : 3),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
