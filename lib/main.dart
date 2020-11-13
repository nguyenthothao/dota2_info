import 'package:flutter/material.dart';
import 'package:dota2_info/screen/home/components/build_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import './enum/attackType.dart';
import 'package:toggle_switch/toggle_switch.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> heroData;
  Iterable<String> ids;
  int stt = 0;

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("https://api.opendota.com/api/constants/heroes"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      heroData = json.decode(response.body);
      ids = heroData.keys;
    });
  }

  toggleSwitchType(int index) {
    setState(() {
      stt = index;
    });
  }

  listViewType(int n) {
    switch (n) {
      case 0:
        return ListHeroes(heroData);
        break;
      case 1:
        return ListHeroesAttackType(
            heroData, AttackTypeName[AttackType.Melee]);
        break;
      default:
        return ListHeroesAttackType(
            heroData, AttackTypeName[AttackType.Ranged]);
    }
  }

  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        drawer: buildDrawer(),
        appBar: AppBar(
          title: Center(
            child: Text("MeePaw", style: TextStyle(fontSize: 40)),
          ),
        ),
        body:
            // ListHeroesAttackType(heroData,AttackTypeName[AttackType.Ranged])
            Column(
          children: [
            // Container(
            //     color: Colors.yellow,
            //     height: 50,q
            //     child: Center(
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceAround,
            //         children: [
            //           TextType("All"),
            //           TextType("Melee"),
            //           TextType("Ranged")
            //         ],
            //       ),
            //     )),
            Container(
                child: ToggleSwitch(
                    minHeight: 50,
                    minWidth: 100,
                    activeBgColor: Colors.lightGreen,
                    inactiveBgColor: Colors.red,
                    inactiveFgColor: Colors.white,
                    initialLabelIndex: 1,
                    fontSize: 20,
                    labels: ['All', 'Melee', 'Ranged'],
                    onToggle: (index) {
                      toggleSwitchType(index);
                      print("So thu tu: $index");
                    })),

            Container(height: 628, child: listViewType(stt))
            // ListHeroesAttackType(heroData,AttackTypeName[AttackType.Ranged]),
          ],
        ),
      ),
    );
  }
}

class ListHeroes extends StatelessWidget {
  final Map<String, dynamic> heroData;

  const ListHeroes(this.heroData);

  @override
  Widget build(BuildContext context) {
    Iterable<String> ids = heroData.keys;

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: heroData == null ? 0 : heroData.length,
      itemBuilder: (BuildContext context, int index) {
        return new Card(
          child: new Image.network(
            "https://cdn.dota2.com" + heroData[ids.elementAt(index)]["img"],
            width: 30,
            height: 100,
          ),
        );
      },
    );
  }
}

class ListHeroesAttackType extends StatelessWidget {
  final Map<String, dynamic> heroData;
  final String attackType;

  const ListHeroesAttackType(this.heroData, this.attackType);

  @override
  Widget build(BuildContext context) {
    Iterable<String> ids = heroData.keys;
    List<String> melee = [];

    for (int i = 0; i < heroData.length; i++) {
      if (heroData[ids.elementAt(i)]["attack_type"] == "$attackType") {
        melee.add(heroData[ids.elementAt(i)]["img"]);
      }
    }
    return ListView.builder(
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
