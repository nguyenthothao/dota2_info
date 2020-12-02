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
  List<HeroDetail> rangeds = [];
  List<HeroDetail> melees = [];

  Future<List<HeroDetail>> getData() async {
    var response = await http.get(
        Uri.encodeFull("https://api.opendota.com/api/constants/heroes"),
        headers: {"Accept": "application/json"});
    heroData = json.decode(response.body);
    ids = heroData.keys;
    // for (int i = 0; i < heroData.length; i++) {
    //   listHero.add(heroData[ids.elementAt(i)]["primary_attr"]);
    //   iconHeros.add(heroData[ids.elementAt(i)]["icon"]);
    // }
    // for (int i = 0; i < heroData.length; i++) {
    //   if (heroData[ids.elementAt(i)]["attack_type"] ==
    //       AttackTypeName[AttackType.Ranged]) {
    //     ranged.add(heroData[ids.elementAt(i)]["img"]);
    //     heroNamesRanged.add(heroData[ids.elementAt(i)]["localized_name"]);
    //   }
    // }
    // for (int i = 0; i < heroData.length; i++) {
    //   if (heroData[ids.elementAt(i)]["attack_type"] ==
    //       AttackTypeName[AttackType.Melee]) {
    //     melee.add(heroData[ids.elementAt(i)]["img"]);
    //     heroNamesMelee.add(heroData[ids.elementAt(i)]["localized_name"]);
    //   }
    // }
    List<HeroDetail> heroDetails = [];
    for (int i = 0; i < heroData.length; i++) {
      HeroDetail hero = new HeroDetail(
          heroData[ids.elementAt(i)]["id"],
          heroData[ids.elementAt(i)]["name"],
          heroData[ids.elementAt(i)]["localized_name"],
          heroData[ids.elementAt(i)]["primary_attr"],
          heroData[ids.elementAt(i)]["attack_type"],
          heroData[ids.elementAt(i)]["img"],
          heroData[ids.elementAt(i)]["icon"],
          heroData[ids.elementAt(i)]["legs"]);
      heroDetails.add(hero);
    }
    return heroDetails;
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
        if (snapshot.data == null) {
          return Container(child: Center(child: Text("Loading..")));
        } else {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                subtitle: Text(snapshot.data[index].primaryAttr),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                      "https://cdn.dota2.com" + snapshot.data[index].icon),
                ),
                title: Text(
                  snapshot.data[index].localizedName,
                ),
                focusColor: Colors.green,
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(snapshot.data[index])));
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
        if (snapshot.data == null) {
          return Container(child: Center(child: Text("Loading..")));
        } else {
          for (int i = 0; i < snapshot.data.length; i++) {
            if (snapshot.data[i].attackType ==
                AttackTypeName[AttackType.Melee]) {
              melees.add(snapshot.data[i]);
            }
          }
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: melees == null ? 0 : melees.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Image.network(
                    "https://cdn.dota2.com" + melees[index].img,
                    fit: BoxFit.fitHeight,
                    height: 100,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => DetailPage(melees[index])));
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
          for (int i = 0; i < snapshot.data.length; i++) {
            if (snapshot.data[i].attackType ==
                AttackTypeName[AttackType.Ranged]) {
              rangeds.add(snapshot.data[i]);
            }
          }
          return GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 15,
              children: List.generate(62, (index) {
                return Column(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Image.network(
                        "https://cdn.dota2.com" + rangeds[index].img,
                        height: 80,
                        fit: BoxFit.fitHeight,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(snapshot.data[index])));
                      },
                    ),
                    Text(
                     snapshot.data[index].name,
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
  final HeroDetail heroDetail;

  DetailPage(this.heroDetail);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(heroDetail.name),
        ),
        backgroundColor: Colors.yellow,
        bottomSheet: Text(
          heroDetail.name,
        ),
      ),
    );
  }
}

class HeroDetail {
  final int id;
  final String name;
  final String localizedName;
  final String primaryAttr;
  final String attackType;
  final String img;
  final String icon;
  final int legs;

  HeroDetail(this.id, this.name, this.localizedName, this.primaryAttr,
      this.attackType, this.img, this.icon, this.legs);
}
