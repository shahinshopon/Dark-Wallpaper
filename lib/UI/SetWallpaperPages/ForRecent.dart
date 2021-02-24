

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:share/share.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class ForRecent extends StatelessWidget {
  DocumentSnapshot image;
  ForRecent({this.image});
  setWallpaperHomeScreen()async{
    String url = image['link'];
    int location = WallpaperManager
        .HOME_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(url);
    final String result =
        await WallpaperManager.setWallpaperFromFile(
        file.path, location);
  }
  setWallpaperLockScreen()async{
    String url = image['link'];
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
      var imageId = await ImageDownloader.downloadImage(image['link']);
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
                    tag: image["link"],
                    child: Image.network(
                      image["link"],
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
                    Share.share(image["link"], subject: 'Image Link');
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
