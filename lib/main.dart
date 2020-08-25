import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip cost calculator',
      home: new FuelForm(),
    );
  }
}

class FuelForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FuelFormState();
}

class _FuelFormState extends State<FuelForm> {
// Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a `GlobalKey<FormState>`, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  String result = "";
  String _currency = "";
  String _distanceUnit = "";
  String _volumeUnit = "";

  final _currencies = ['Dollars', 'Euro', 'Pounds', 'Yen'];
  //this allows us to control the text in a textField
  TextEditingController distanceController = TextEditingController();
  TextEditingController avgController =  TextEditingController();
  TextEditingController fuelController =  TextEditingController();

  @override
  void initState() {
    this._currency = _currencies[0];
    this._distanceUnit = this._getDistanceUnit(this._currency);
    this._volumeUnit = this._getVolumeUnit(this._currency);
  
  }

  void _reset() {
    distanceController.text = '';
    fuelController.text = '';
    avgController.text = '';
    setState(() {
      result = '';
    });
  }

  String _calculate() {
    // use String.replaceAll to convert , with correct decimal .
    double _distance = double.parse(distanceController.text.replaceAll(',', '.'));
    double _fuelCost = double.parse(fuelController.text.replaceAll(',', '.'));
    double _consumption = double.parse(avgController.text.replaceAll(',', '.'));
    double _totalCost = _distance / _consumption * _fuelCost;
    String _result = "The total cost for your trip is " +
        _totalCost.toStringAsFixed(2) +
        ' ' +
        _currency;
    return _result;
  }

  String _getDistanceUnit(String currency) {
    String _unit = "";
    if ( ['Dollars', 'Pounds'].contains(currency) ) {
      _unit = "mi";
    } else {
      _unit = "km";
    }

    return _unit;
  }

  String _getVolumeUnit(String currency) {
    String _unit = "";
    if ( ['Dollars', 'Pounds'].contains(currency) ) {
      _unit = "gal";
    } else {
      _unit = "lt";
    }

    return _unit;
  }


  @override
  Widget build(BuildContext formContext) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    double _formPadding = 5.0;
    return Scaffold(
        appBar: AppBar(
          title: Text("Trip Cost Calculator"),
          backgroundColor: Color.fromRGBO(66, 165, 245, 1.0),
        ),
        body: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          top: _formPadding, bottom: _formPadding),
                      child: TextField(
                        controller: distanceController,
                        style: textStyle,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "e.g. 124",
                            labelText: "Trip Distance (${this._distanceUnit})",
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: _formPadding, top: _formPadding),
                      child: TextField(
                        controller: avgController,
                        style: textStyle,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "e.g. 17",
                            labelText: "Consumption (${this._distanceUnit} per ${this._volumeUnit} of fuel)",
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: _formPadding, top: _formPadding),
                      child: Row(children: [
                        Expanded(
                            child: TextField(
                          controller: fuelController,
                          style: textStyle,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "e.g. 1.60",
                              labelText: "Fuel Cost",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        )),
                        Container(width: _formPadding * 5),
                        Expanded(
                          child: DropdownButton<String>(
                            items: _currencies.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            value: _currency,
                            style: textStyle,
                            onChanged: (value) {
                              _onDropDownChanged(value);
                            },
                          ),
                        )
                      ])),
                  Container(
                    height: _formPadding,
                  ),
                  Row(children: [
                    Expanded(
                        child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      onPressed: () {
                        setState(() {
                          result = _calculate();
                        });
                      },
                      child: Text(
                        'Submit',
                        textScaleFactor: 1.5,
                      ),
                    )),
                    Expanded(
                        child: RaisedButton(
                      color: Theme.of(context).buttonColor,
                      textColor: Theme.of(context).primaryColorDark,
                      onPressed: () {
                        _reset();
                      },
                      child: Text(
                        'Reset',
                        textScaleFactor: 1.5,
                      ),
                    )),
                  ]),
                  Container(
                      margin: EdgeInsets.only(top: _formPadding * 2),
                      child: Text(
                        result,
                        style: textStyle,
                      )),
                ],
              ),
            )));
  }

  void _onDropDownChanged(String value) {
    setState(() {
      this._currency = value;
      this._distanceUnit = this._getDistanceUnit(this._currency);
      this._volumeUnit = this._getVolumeUnit(this._currency);
    });
  }
}
