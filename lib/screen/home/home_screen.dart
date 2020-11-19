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
  int stt = 1;
  List<String> listHero = [];
  List<String> ranged = [];
  List<String> heroNamesRanged = [];
  List<String> heroNamesMelee = [];
  List<String> melee = [];
  List<String> iconHeros = [];

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("https://api.opendota.com/api/constants/heroes"),
        headers: {"Accept": "application/json"});
    heroData = json.decode(response.body);
    ids = heroData.keys;
    for (int i = 0; i < heroData.length; i++) {
      listHero.add(heroData[ids.elementAt(i)]["primary_attr"]);
      iconHeros.add(heroData[ids.elementAt(i)]["icon"]);
    }
    for (int i = 0; i < heroData.length; i++) {
      if (heroData[ids.elementAt(i)]["attack_type"] ==
          AttackTypeName[AttackType.Ranged]) {
        ranged.add(heroData[ids.elementAt(i)]["img"]);
        heroNamesRanged.add(heroData[ids.elementAt(i)]["localized_name"]);
      }
    }
    for (int i = 0; i < heroData.length; i++) {
      if (heroData[ids.elementAt(i)]["attack_type"] ==
          AttackTypeName[AttackType.Melee]) {
        melee.add(heroData[ids.elementAt(i)]["img"]);
        heroNamesMelee.add(heroData[ids.elementAt(i)]["localized_name"]);
      }
    }
    return "Hero Data";
  }

  // List<String> listHeroess(Map<String, dynamic> data) {
  //   List<String> listHero = [];
  //   for (int i = 0; i < heroData.length; i++) {
  //     listHero.add(heroData[ids.elementAt(i)]["primary_attr"]);
  //   }
  //   return listHero;
  // }

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
                subtitle: Text(heroData[ids.elementAt(index)]["primary_attr"]),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage("https://cdn.dota2.com" +
                      heroData[ids.elementAt(index)]["icon"]),
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
              );
            },
          );
        }
      },
    );
  }

  Widget _listHeroMelee() {
    return FutureBuilder(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (heroData == null) {
          return Container(child: Center(child: Text("Loading..")));
        } else {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: melee == null ? 0 : melee.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Image.network(
                    "https://cdn.dota2.com" + melee[index],
                    fit: BoxFit.fitHeight,
                    height: 100,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => DetailPage(
                              heroNamesMelee[index])));
                },
              );
            },
          );
        }
      },
    );
  }

  Widget _listHeroRanged() {
    return FutureBuilder(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (heroData == null) {
          return Container(child: Center(child: Text("Loading..")));
        } else {
          return GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 15,
              children: List.generate(ranged.length, (index) {
                return Column(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Image.network(
                        "https://cdn.dota2.com" + ranged[index],
                        height: 80,
                        fit: BoxFit.fitHeight,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(heroNamesRanged[index])));
                      },
                    ),
                    Text(
                      heroNamesRanged[index],
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }));
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
        return _listHeroMelee();
        break;
      default:
        return _listHeroRanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: buildDrawer(),
        appBar: AppBar(
          title: Center(
            child: Text("MeePaw", style: TextStyle(fontSize: 40)),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: ToggleSwitch(
                  minHeight: 50,
                  minWidth: 100,
                  activeBgColor: Colors.lightGreen,
                  inactiveBgColor: Colors.red,
                  inactiveFgColor: Colors.white,
                  fontSize: 20,
                  initialLabelIndex: 1,
                  changeOnTap: true,
                  labels: ['All', 'Melee', 'Ranged'],
                  onToggle: (index) {
                    toggleSwitchType(index);
                  }),
            ),
            Flexible(flex: 10, child: listViewType(stt))
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String name;

  DetailPage(this.name);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        backgroundColor: Colors.yellow,
        bottomSheet: Text(
          name,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
