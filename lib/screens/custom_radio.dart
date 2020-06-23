import '../data/sharedpref.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomRadio extends StatefulWidget {
  @override
  createState() {
    return CustomRadioState();
  }
}

class CustomRadioState extends State<CustomRadio> {
  List<RadioModel> sampleData = List<RadioModel>();

  @override
  void initState() {
    super.initState();
    sampleData.add(RadioModel(false, 'C', 'CLASSIC'));
    sampleData.add(RadioModel(false, 'M', 'MODERN'));
  }

  @override
  Widget build(BuildContext context) {
    final _pref = Provider.of<SharedPersistantSettings>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Now Playing Screen"),
      ),
      body: ListView.builder(
        itemCount: sampleData.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            //highlightColor: Colors.red,
            splashColor: Colors.blueAccent,
            onTap: () {
              setState(() {
                sampleData.forEach((element) => element.isSelected = false);
                sampleData[index].isSelected = true;
              });
              if (sampleData[index].buttonText == 'C') {
                _pref.setNowPlayingScreen('C');
              } else if (sampleData[index].buttonText == 'M') {
                _pref.setNowPlayingScreen('M');
              }
            },
            child: RadioItem(sampleData[index]),
          );
        },
      ),
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 50.0,
            width: 50.0,
            child: Center(
              child: Text(
                _item.buttonText,
                style: TextStyle(
                    color: _item.isSelected ? Colors.white : Colors.black,
                    //fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
            ),
            decoration: BoxDecoration(
              color: _item.isSelected ? Colors.blueAccent : Colors.grey,
              border: Border.all(
                  width: 1.0,
                  color: _item.isSelected ? Colors.blueAccent : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0),
            child: Text(_item.text),
          )
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;

  RadioModel(this.isSelected, this.buttonText, this.text);
}
