import 'dart:ui';

import 'package:flutter/material.dart';
import 'components/build_drawer.dart';
import 'package:dota2_info/enum/attackType.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class TextType extends StatelessWidget {
  final String text;

  const TextType(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      "$text",
      style: TextStyle(
          fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> heroData;
  Iterable<String> ids;
  int stt = 0;

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("https://api.opendota.com/api/constants/heroes"),
        headers: {"Accept": "application/json"});
    heroData = json.decode(response.body);
    ids = heroData.keys;
    return "Success!";
  }

  @override
  initState() {
    super.initState();
  }

  Widget _listHero() {
    return FutureBuilder(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (heroData == null) {
          return Container(child: Center(child: Text("Loading..")));
        } else {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: heroData == null ? 0 : heroData.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage("https://cdn.dota2.com" +
                      heroData[ids.elementAt(index)]["img"]),
                ),
                title: Text(
                  heroData[ids.elementAt(index)]["localized_name"],
                ),
                focusColor: Colors.green,
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => DetailPage(
                              heroData[ids.elementAt(index)]
                                  ["localized_name"])));
                },
                // child: new Image.network(
                //   "https://cdn.dota2.com" +
                //       heroData[ids.elementAt(index)]["img"],
                //   width: 30,
                //   height: 100,
                // ),
              );
            },
          );
        }
      },
    );
  }

  Widget _listHeroAttackTyle(String att) {
    List<String> melee = [];
    for (int i = 0; i < heroData.length; i++) {
      if (heroData[ids.elementAt(i)]["attack_type"] == att) {
        melee.add(heroData[ids.elementAt(i)]["img"]);
      }
    }
    return FutureBuilder(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (melee == null) {
          return Container(child: Center(child: Text("Loading..")));
        } else {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: melee == null ? 0 : melee.length,
            itemBuilder: (BuildContext context, int index) {
              return new Card(
                child: new Image.network(
                  "https://cdn.dota2.com" + melee[index],
                  width: 30,
                  height: 100,
                ),
              );
            },
          );
        }
      },
    );
  }

  toggleSwitchType(int index) {
    setState(() {
      stt = index;
    });
  }

  listViewType(int n) {
    switch (n) {
      case 0:
        return _listHero();
        break;
      case 1:
        return _listHeroAttackTyle(AttackTypeName[AttackType.Melee]);
        break;
      default:
        return _listHeroAttackTyle(AttackTypeName[AttackType.Ranged]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(),
      appBar: AppBar(
        title: Center(
          child: Text("MeePaw", style: TextStyle(fontSize: 40)),
        ),
      ),
      body: Column(
        children: [
          Container(
              child: ToggleSwitch(
                  minHeight: 50,
                  minWidth: 100,
                  activeBgColor: Colors.lightGreen,
                  inactiveBgColor: Colors.red,
                  inactiveFgColor: Colors.white,
                  initialLabelIndex: 0,
                  fontSize: 20,
                  labels: ['All', 'Melee', 'Ranged'],
                  onToggle: (index) {
                    toggleSwitchType(index);
                    print(stt);
                  })),
          Container(height: 628, child: listViewType(stt))
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String name;

  DetailPage(this.name);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
    );
  }
}
