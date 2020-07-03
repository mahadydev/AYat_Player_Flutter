import '../provider/eq.dart';
import '../util/constants.dart';
import '../util/theme_constants.dart';
import 'package:equalizer/equalizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:provider/provider.dart';

class EqualizerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _eq = Provider.of<Eq>(context);
    final _pref = Provider.of<ThemeConstants>(context);

    return Scaffold(
      appBar: AppBar(
        brightness: _pref.isDarkModeON ? Brightness.light : Brightness.dark,
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          'Equalizer',
          maxLines: 1,
          style: Constants.kAppBarTitleTextStyle.copyWith(
              color:
                  _pref.navbarAppvarColor ?? Theme.of(context).backgroundColor),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: _pref.navbarAppvarColor ?? Theme.of(context).backgroundColor,
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 10.0),
          ListTile(
            title: Text(
              'Aura Equalizer',
              style: Constants.kListTileTitle,
            ),
            trailing: Switch(
              value: _eq.enableCustomEQ,
              onChanged: (value) {
                _eq.switchEqualizer(value);
                Equalizer.setEnabled(_eq.enableCustomEQ);
              },
            ),
          ),
          FutureBuilder<List<int>>(
            future: Equalizer.getBandLevelRange(),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.done
                  ? CustomEQ(_eq.enableCustomEQ, snapshot.data)
                  : CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}

class CustomEQ extends StatefulWidget {
  const CustomEQ(this.enabled, this.bandLevelRange);

  final bool enabled;
  final List<int> bandLevelRange;

  @override
  _CustomEQState createState() => _CustomEQState();
}

class _CustomEQState extends State<CustomEQ> {
  double min, max;
  Future<List<String>> fetchPresets;

  @override
  void initState() {
    super.initState();
    min = widget.bandLevelRange[0].toDouble();
    max = widget.bandLevelRange[1].toDouble();
    fetchPresets = Equalizer.getPresetNames();
  }

  @override
  Widget build(BuildContext context) {
    int bandId = 0;

    return FutureBuilder<List<int>>(
      future: Equalizer.getCenterBandFreqs(),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.done
            ? Column(
                children: [
                  Row(
                    children: snapshot.data
                        .map((freq) => _buildSliderBand(freq, bandId++))
                        .toList(),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildPresets(),
                  ),
                ],
              )
            : CircularProgressIndicator();
      },
    );
  }

  Widget _buildSliderBand(int freq, int bandId) {
    return Column(
      children: [
        SizedBox(
          height: 250.0,
          child: FutureBuilder<int>(
            future: Equalizer.getBandLevel(bandId),
            builder: (context, snapshot) {
              return FlutterSlider(
                trackBar: FlutterSliderTrackBar(
                    activeTrackBar: BoxDecoration(
                        color: Theme.of(context).accentColor ?? Colors.blue)),
                disabled: !widget.enabled,
                axis: Axis.vertical,
                handlerAnimation: FlutterSliderHandlerAnimation(
                    curve: Curves.elasticOut,
                    reverseCurve: null,
                    duration: Duration(milliseconds: 700),
                    scale: 1.4),
                rtl: true,
                min: min,
                max: max,
                values: [snapshot.hasData ? snapshot.data.toDouble() : 0],
                onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                  Equalizer.setBandLevel(bandId, lowerValue.toInt());
                },
              );
            },
          ),
        ),
        Text(freq ~/ 1000 > 1000
            ? '${freq ~/ 1000000}KHz'
            : '${freq ~/ 1000} Hz'),
      ],
    );
  }

  Widget _buildPresets() {
    final _eq = Provider.of<Eq>(context);
    return FutureBuilder<List<String>>(
      future: fetchPresets,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final presets = snapshot.data;
          if (presets.isEmpty) return Text('No presets available!');
          return DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: 'Available Presets',
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).accentColor ?? Colors.white,
                      width: 1)),
            ),
            value: _eq.selectedPresetEq,
            onChanged: widget.enabled
                ? (String value) {
                    Equalizer.setPreset(value);
                    _eq.setSelectedEq(value);
                  }
                : null,
            items: presets.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          );
        } else if (snapshot.hasError)
          return Text(snapshot.error);
        else
          return CircularProgressIndicator();
      },
    );
  }
}
