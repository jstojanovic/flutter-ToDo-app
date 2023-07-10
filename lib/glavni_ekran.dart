import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pametan_pise_tudu/naglasen_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pametan_pise_tudu/model_zadatka.dart';
import 'dart:math';

class GlavniEkran extends StatefulWidget {
  @override
  _GlavniEkranState createState() => _GlavniEkranState();
}

class _GlavniEkranState extends State<GlavniEkran> {
  //  globalni podaci koji se mjenjaju
  List<Zadatak> _listaSvihZadataka = []; // Initialize an empty list
  TextEditingController _nazivZadatkaController = TextEditingController();
  TextEditingController _opisZadatkaController = TextEditingController();
  TextEditingController _uredivanjeZadatkaController = TextEditingController();
  late SharedPreferences _prefs;
  IconData _defaultIcon = Icons.work;
  //Modificira se unutar showPopup
  Zadatak _noviZadatak = Zadatak(
    naslov: "xd",
    opis: "xd",
    ikona: Icons.work,
  );

  Random _random = Random();
  Color _randomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );
  }

  // Uvozi zadatke iz pohrane
  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  void initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      final taskList = _prefs.getStringList('listaZadataka');
      if (taskList != null) {
        _listaSvihZadataka = taskList.map((taskJson) {
          final taskMap = jsonDecode(taskJson);
          //vrati zadatak za svaki dekodirani string iz sharedPreferences
          return Zadatak(
            naslov: taskMap['naslov'],
            opis: taskMap['opis'],
            ikona: IconData(taskMap['ikona'], fontFamily: 'MaterialIcons'),
          );
        }).toList();
      } else {
        _listaSvihZadataka = [];
      }
    });
  }

  void iskocniProzor_za_dodavanjeZ() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ovdje opišite zadaću'),
          content: Column(
            children: [
              Column(
                children: [
                  TextField(
                    controller: _opisZadatkaController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Opis zadatka',
                    ),
                    maxLines: 8,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  DropdownButtonFormField<IconData>(
                    value: _defaultIcon,
                    onChanged: (newValue) {
                      _defaultIcon = newValue!;
                    },
                    items: [
                      DropdownMenuItem(
                        value: Icons.home,
                        child: Row(
                          children: [
                            Icon(Icons.home),
                            SizedBox(width: 8.0),
                            Text('Kuća'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: Icons.work,
                        child: Row(
                          children: [
                            Icon(Icons.work),
                            SizedBox(width: 8.0),
                            Text('Poso'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: Icons.label_important,
                        child: Row(
                          children: [
                            Icon(Icons.label_important),
                            SizedBox(width: 16.0),
                            Text('Hitno!'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Zatvori'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Spremi'),
              onPressed: () {
                _noviZadatak = Zadatak(
                    naslov: _nazivZadatkaController.text,
                    opis: _opisZadatkaController.text,
                    ikona: _defaultIcon);

                dodajZadatak();
                _opisZadatkaController.clear();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void iskocniProzor_za_uredivanjeZ(index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Unesite novi opis zadaće'),
          content: Column(
            children: [
              Column(
                children: [
                  TextField(
                    controller: _uredivanjeZadatkaController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Novi naslov',
                    ),
                    maxLines: 8,
                  ),
                  TextField(
                    controller: _opisZadatkaController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Novi opis zadatka',
                    ),
                    maxLines: 8,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  DropdownButtonFormField<IconData>(
                    value: _defaultIcon,
                    onChanged: (newValue) {
                      _defaultIcon = newValue!;
                    },
                    items: [
                      DropdownMenuItem(
                        value: Icons.home,
                        child: Row(
                          children: [
                            Icon(Icons.home),
                            SizedBox(width: 8.0),
                            Text('Kuća'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: Icons.work,
                        child: Row(
                          children: [
                            Icon(Icons.work),
                            SizedBox(width: 8.0),
                            Text('Poso'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: Icons.label_important,
                        child: Row(
                          children: [
                            Icon(Icons.label_important),
                            SizedBox(width: 16.0),
                            Text('Hitno!'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Zatvori'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Spremi'),
              onPressed: () {
                _noviZadatak = Zadatak(
                    naslov: _uredivanjeZadatkaController.text,
                    opis: _opisZadatkaController.text,
                    ikona: _defaultIcon);

                updateZadatak(index, _noviZadatak);
                _opisZadatkaController.clear();
                _uredivanjeZadatkaController.clear();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void updateZadatak(int index, Zadatak _noviZadatak) {
    setState(() {
      _listaSvihZadataka[index] = _noviZadatak;

      final listaZadatakaJson = _listaSvihZadataka.map((zadatak) {
        final zadatakMap = {
          'naslov': zadatak.naslov,
          'opis': zadatak.opis,
          'ikona': zadatak.ikona.codePoint,
        };
        return jsonEncode(zadatakMap);
      }).toList();
      _prefs.setStringList('listaZadataka', listaZadatakaJson);
    });
  }

  void dodajZadatak() {
    setState(() {
      _listaSvihZadataka.add(_noviZadatak);
      _nazivZadatkaController.clear();
      // Save the updated todo items
      final listaZadatakaJson = _listaSvihZadataka.map((zadatak) {
        final zadatakMap = {
          'naslov': zadatak.naslov,
          'opis': zadatak.opis,
          'ikona': zadatak.ikona.codePoint,
        };
        return jsonEncode(zadatakMap);
      }).toList();
      _prefs.setStringList('listaZadataka', listaZadatakaJson);
    });
  }

  void obrisiZadatak(int index) {
    setState(() {
      _listaSvihZadataka.removeAt(index);

      final listaZadatakaJson = _listaSvihZadataka.map((zadatak) {
        final zadatakMap = {
          'naslov': zadatak.naslov,
          'opis': zadatak.opis,
          'ikona': zadatak.ikona.codePoint,
        };
        return jsonEncode(zadatakMap);
      }).toList();
      _prefs.setStringList('listaZadataka', listaZadatakaJson);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Napomena: Swipe briše zadatak. Tap uređuje.'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _listaSvihZadataka.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    obrisiZadatak(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Zadatak obrisan!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                        onPressed: () {
                          iskocniProzor_za_uredivanjeZ(index);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: _randomColor()),
                        child: ListTile(
                          title: OutlinedText(
                              text: _listaSvihZadataka[index].naslov),
                          subtitle: Text(_listaSvihZadataka[index].opis),
                          leading: Icon(_listaSvihZadataka[index].ikona),
                        )),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nazivZadatkaController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Unesi naslov novog zadataka',
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: iskocniProzor_za_dodavanjeZ,
                  child: Text('Dodaj'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
