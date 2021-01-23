import 'package:Leader/providers/customers.dart';
import 'package:Leader/screens/add_lead_screen.dart';
import 'package:Leader/widgets/drawer.dart';
import 'package:Leader/widgets/leads_tile.dart';

import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class Leads extends StatefulWidget {
  static const routeName = '/second';
  final Key key;
  Leads(this.key) : super(key: key);
  @override
  _LeadsState createState() => _LeadsState();
}

class _LeadsState extends State<Leads> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  @override
  Widget build(BuildContext context) {
    final customers = Provider.of<Customers>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          Container(
            height: 140.0,
            child: Stack(
              children: <Widget>[
                Container(
                  color: Theme.of(context).primaryColor,
                  width: MediaQuery.of(context).size.width,
                  height: 100.0,
                  child: Center(
                    child: Text(
                      "LEADS",
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                ),
                Positioned(
                  top: 70.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                              color: Colors.grey.withOpacity(0.5), width: 1.0),
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(1.0, 4.0),
                                blurRadius: 4.0,
                                spreadRadius: -1.0,
                                color: Colors.grey[800]),
                          ]),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: Colors.deepOrange[300],
                            ),
                            onPressed: () {
                              // print("your menu action here");
                              _scaffoldKey.currentState.openDrawer();
                            },
                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Search",
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Colors.deepOrange[300],
                            ),
                            onPressed: () {
                              print("your menu action here");
                            },
                          ),
                          PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(child: Text('Settings')),
                              PopupMenuItem(child: Text('Logout'))
                            ],
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.deepOrange[300],
                            ),
                            onSelected: null,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: customers.customers.isEmpty
                ? Text('Nothing here')
                : AnimatedList(
                    key: listKey,
                    initialItemCount: customers.customers.length,
                    itemBuilder: (context, index, animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                                begin: Offset(-1, 0), end: Offset(0, 0))
                            .animate(animation),
                        child: customers.customers
                            .map((e) => LeadTile(
                                  id: e.customerId,
                                  name: e.name,
                                  labels: e.labels,
                                ))
                            .toList()[index],
                      );
                    },
                  ),
          ),
        ],
      ),
      drawer: SideDrawer(),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: GestureDetector(
        onTap: () {
          pushNewScreen(
            context,
            screen: AddLeadScreen(() {
              if (listKey.currentState != null)
                listKey.currentState
                    .insertItem(0, duration: Duration(milliseconds: 500));
            }),
            pageTransitionAnimation: PageTransitionAnimation.slideRight,
            withNavBar: false,
          ).whenComplete(() {
            // if (listKey.currentState != null)
            //   listKey.currentState
            //       .insertItem(0, duration: Duration(milliseconds: 500));
            // setState(() {});
          });
        },
        child: Container(
          width: 110,
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Lead',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.add_circle,
                color: Colors.white,
                size: 40,
              ),
            ],
          ),
          decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(38)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}