import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darkwallpaperapplication/UI/SetWallpaperPages/ForTop.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Top extends StatefulWidget {
  @override
  _TopState createState() => _TopState();
}

class _TopState extends State<Top> {
  MobileAdTargetingInfo targetingInfo;
  InterstitialAd myInterstitial;
  Future getData() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn =
    await firestore.collection("topWallpapers").getDocuments();
    return qn.documents;
  }

  @override
  void initState() {
    getData();
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


  @override
  Widget build(BuildContext context) {
    myInterstitial
      ..load()
      ..show(
        anchorType: AnchorType.bottom,
        anchorOffset: 0.0,
        horizontalCenterOffset: 0.0,
      );
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: StaggeredGridView.countBuilder(
                    crossAxisCount: 4,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot image = snapshot.data[index];
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              border:
                              Border.all(color: Colors.white70, width: 0.2),
                            ),
                            child: Card(
                              shadowColor: Colors.white,
                              elevation: 2,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  child: Hero(
                                    tag: image["link"],
                                    child: Image.network(
                                      image["link"],
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            ),
                          ),
                          onTap: (){
                            Navigator.push(context, CupertinoPageRoute(
                                builder: (context)=>ForTop(image: image,)
                            ),);
                          },
                        ),
                      );

                    },
                    staggeredTileBuilder: (int index) =>
                    new StaggeredTile.count(2, index.isEven ? 2 :3),
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                );
              }
              else if (snapshot.hasError) {
                return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.orange,
                    ));
              }
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.orange,
                ),
              );
            },
          )),
    );
  }
}
