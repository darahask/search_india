import 'package:flutter/material.dart';
import 'package:search_india/add_mid.dart';
import 'package:easy_localization/easy_localization.dart';

class CreateAdd extends StatefulWidget {
  @override
  _CreateAddState createState() => _CreateAddState();
}

class _CreateAddState extends State<CreateAdd> {
  int a = 0;
  int b = 0;
  bool val = false;
  String cityname;
  String selectedCurrency = 'Select a Category'.tr();
  final currenciesList = [
    // ignore: top_level_instance_method
    'Select a Category'.tr(),
    // ignore: top_level_instance_method
    'MOBILE'.tr(),
    // ignore: top_level_instance_method
    'PEOPLE'.tr(),
    // ignore: top_level_instance_method
    'BAGS'.tr(),
    // ignore: top_level_instance_method
    'PETS'.tr(),
    // ignore: top_level_instance_method
    'VEHICLES'.tr(),
    // ignore: top_level_instance_method
    'DOCUMENTS'.tr()
  ];

  DropdownButton<String> androidDropdown(currenciesList) {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      isExpanded: true,
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
       if(mounted)setState(() {
          selectedCurrency = value;
        });
      },
    );
  }

  String subcategory = 'Select a SubCategory';
  final ist = ['Select a SubCategory', 'car', 'bike', 'cycle', 'scooty'];

  final ist1 = [
    'Select a SubCategory',
    'girl',
    'boy',
    'child',
    'senior citizen'
  ];

  DropdownButton<String> androidDropdown2(currenciesList) {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      isExpanded: true,
      value: subcategory,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          subcategory = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent.withAlpha(255),
      appBar: AppBar(
        title: Center(
          child: Text('create_report').tr(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 10.0),
              child: Text(
                'category',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ).tr(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: androidDropdown(currenciesList),
            ),
            (selectedCurrency == 'VEHICLES'.tr())
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: androidDropdown2(ist),
                  )
                : Container(),
            (selectedCurrency == 'PEOPLE'.tr())
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: androidDropdown2(ist1),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
              ),
              child: Text(
                'post_type',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ).tr(),
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 0,
                  activeColor: Colors.black,
                  onChanged: (i) {
                    setState(() {
                      a = i;
                    });
                  },
                  groupValue: a,
                ),
                Text(
                  'lost',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ).tr(),
                SizedBox(
                  width: 30,
                ),
                Radio(
                  value: 1,
                  activeColor: Colors.black,
                  onChanged: (i) {
                    setState(() {
                      a = i;
                    });
                  },
                  groupValue: a,
                ),
                Text(
                  'found',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ).tr(),
              ],
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
              ),
              child: Text(
                'emergency',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ).tr(),
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 0,
                  activeColor: Colors.black,
                  onChanged: (i) {
                    setState(() {
                      b = i;
                    });
                  },
                  groupValue: b,
                ),
                Text(
                  'yes',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ).tr(),
                SizedBox(
                  width: 30,
                ),
                Radio(
                  value: 1,
                  activeColor: Colors.black,
                  onChanged: (i) {
                    setState(() {
                      b = i;
                    });
                  },
                  groupValue: b,
                ),
                Text(
                  'no',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ).tr(),
              ],
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
              ),
              child: Text(
                'title',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ).tr(),
            ),
            TextField(
              style: TextStyle(fontSize: 16, color: Colors.black),
              textCapitalization: selectedCurrency == "VEHICLES".tr()
                  ? TextCapitalization.characters
                  : TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'word_limit'.tr(),
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Text(
                'desc',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ).tr(),
            ),
            TextField(
              style: TextStyle(fontSize: 16, color: Colors.black),
              decoration: InputDecoration(
                hintText: 'important_info'.tr(),
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
              ),
              child: Text(
                'reward',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ).tr(),
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  checkColor: Colors.white,
                  activeColor: Colors.black,
                  value: val,
                  onChanged: (vary) {
                    setState(() {
                      val = vary;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                  ),
                  child: Text(
                    'negotiable',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ).tr(),
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Text(
                'city',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ).tr(),
            ),
            TextField(
              style: TextStyle(fontSize: 16, color: Colors.black),
              onChanged: (val) {
                cityname = val;
              },
              decoration: InputDecoration(
                hintText: 'city'.tr(),
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MakeAdd(
                      map: {
                        'category': selectedCurrency,
                        'subcategory': subcategory,
                        'posttype': a.toString(),
                        'city': cityname,
                      },
                    ),
                  ),
                );
              },
              child: Center(
                child: Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.black),
                  child: Center(
                    child: Text(
                      'next',
                      style: TextStyle(color: Colors.white),
                    ).tr(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
