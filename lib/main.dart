import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import './enum/attackType.dart' as attactType;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> heroData;
  Iterable<String> ids;

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("https://api.opendota.com/api/constants/heroes"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      heroData = json.decode(response.body);
      ids = heroData.keys;
    });
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
        appBar: AppBar(
          title: Center(
            child: Text("Dota 2 Hero", style: TextStyle(fontSize: 40)),
          ),
        ),
        body:
            // ListHeroesAttackType(heroData,attactType.attackTpyeStr(attactType.AttackType.Ranged))
            Column(
          children: [
            Container(
                color: Colors.yellow,
                height: 50,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextType("All"),
                      TextType("Melee"),
                      TextType("Ranged")
                    ],
                  ),
                )),
            Container(
                height: 620, color: Colors.brown, child: ListHeroes(heroData)
                // ListHeroesAttackType(heroData,attactType.attackTpyeStr(attactType.AttackType.Ranged)),
                )
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
      itemCount: heroData == null ? 0 : heroData.length,
      itemBuilder: (BuildContext context, int index) {
        return new Card(
          borderOnForeground: true,
          color: Colors.black,
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
