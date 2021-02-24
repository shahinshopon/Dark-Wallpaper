

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:share/share.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class ForFeatured extends StatefulWidget {
  DocumentSnapshot image;
  ForFeatured({this.image});

  @override
  _ForFeaturedState createState() => _ForFeaturedState();
}

class _ForFeaturedState extends State<ForFeatured> {
  MobileAdTargetingInfo targetingInfo;

  InterstitialAd myInterstitial;

  setWallpaperHomeScreen()async{
    String url = widget.image['link'];
    int location = WallpaperManager
        .HOME_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(url);
    final String result =
        await WallpaperManager.setWallpaperFromFile(
        file.path, location);
  }

  setWallpaperLockScreen()async{
    String url = widget.image['link'];
    int location = WallpaperManager
        .LOCK_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(url);
    final String result =
        await WallpaperManager.setWallpaperFromFile(
        file.path, location);
  }

  toastMessageforsetWallpaper(){
    Fluttertoast.showToast(
        msg: "Set Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  toastMessagefordownload(){
    Fluttertoast.showToast(
        msg: "Download Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  Download() async {
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(widget.image['link']);
      if (imageId == null) {
        return;
      }

      // Below is a method of obtaining saved image information.
      var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);
    } on PlatformException catch (error) {
      print(error);
    }
  }
 @override
  void initState() {
   targetingInfo = MobileAdTargetingInfo(
     keywords: <String>['pubg', 'beautiful apps','freefire','popular videos',],
     contentUrl: 'https://flutter.io',
     birthday: DateTime.now(),
     childDirected: false,
     designedForFamilies: false,
     gender: MobileAdGender.unknown, // or MobileAdGender.female, MobileAdGender.unknown
     testDevices: <String>[], // Android emulators are considered test devices
   );
   myInterstitial = InterstitialAd(
     // Replace the testAdUnitId with an ad unit id from the AdMob dash.
     // https://developers.google.com/admob/android/test-ads
     // https://developers.google.com/admob/ios/test-ads
     adUnitId: InterstitialAd.testAdUnitId,
     targetingInfo: targetingInfo,
     listener: (MobileAdEvent event) {
       print("InterstitialAd event is $event");
     },
   );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 1.2,
              decoration: BoxDecoration(color: Colors.black),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Hero(
                    tag: widget.image["link"],
                    child: Image.network(
                      widget.image["link"],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SpeedDial(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            speedDialChildren: [
              SpeedDialChild(
                  child: Icon(Icons.wallpaper),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  label: 'Set Homescreen',
                  onPressed: () {
                  setWallpaperHomeScreen();
                  toastMessageforsetWallpaper();

                  },),
              SpeedDialChild(
                  child: Icon(Icons.lock),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purple,
                  label: 'Set Lockscreen',
                  onPressed: () {
                  setWallpaperLockScreen();
                  toastMessageforsetWallpaper();

                  },),
              SpeedDialChild(
                  child: Icon(Icons.cloud_download),
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.yellow,
                  label: 'Download',
                  onPressed: () {
                    Download();
                    toastMessagefordownload();
                  }),
              SpeedDialChild(
                  child: Icon(Icons.share),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  label: 'Share',
                  onPressed: () {
                    Share.share(widget.image["link"], subject: 'Image Link');
                  }),
            ],
            closedForegroundColor: Colors.black,
            openForegroundColor: Colors.white,
            closedBackgroundColor: Colors.black,
            openBackgroundColor: Colors.black,
          ),
        ),
      ),
    );
  }
}
