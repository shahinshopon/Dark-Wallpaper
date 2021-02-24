import 'package:darkwallpaperapplication/UI/Tabs/recent.dart';
import 'package:darkwallpaperapplication/UI/Tabs/featured.dart';
import 'package:darkwallpaperapplication/UI/Tabs/mostviewed.dart';
import 'package:darkwallpaperapplication/UI/Tabs/popular.dart';
import 'package:darkwallpaperapplication/UI/Tabs/mixed.dart';
import 'package:darkwallpaperapplication/UI/Tabs/top.dart';
import 'package:darkwallpaperapplication/UI/Tabs/weeklypopular.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Dark Wallpapers",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
                onPressed: () {}),
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {}),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 4.0,
            isScrollable: true,
            labelStyle: TextStyle(fontSize: 18),
            tabs: [
              Tab(
                text: "Recent",
              ),
              Tab(
                text: "Top",
              ),
              Tab(
                text: "Mixed",
              ),
              Tab(
                text: "Popular",
              ),
              Tab(
                text: "Weekly Popular",
              ),
              Tab(
                text: "Most Viewed",
              ),
              Tab(
                text: "Featured",
              ),
            ],
          ),
        ),

        body: TabBarView(children: [
          Recent(),
          Top(),
          Mixed(),
          Popular(),
          WeeklyPopular(),
          MostViewed(),
          Featured(),
        ],),
        drawer: Drawer(
          child: SafeArea(

              child: Scaffold(
                backgroundColor: Colors.black,
                body: Center(
                  child: SizedBox(
                  width: MediaQuery.of(context).size.height/4,
                  height: MediaQuery.of(context).size.height/8,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Shimmer.fromColors(
                          baseColor: Colors.black,
                          highlightColor: Colors.purple,
                          child: Text(
                            'Dark Wallpapers',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height/30,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Shimmer.fromColors(
                            baseColor: Colors.white,
                            highlightColor: Colors.purple,
                            child: Text(
                              'Developed by Afran Sarkar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ),
                ),

          )),
        ),
      ),
    );
  }
}
