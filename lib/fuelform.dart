import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; //listEquals

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
  String _consumption = "";
  String _distanceUnit = "";
  String _volumeUnit = "";
  List<String> _validationElement = [""];

  final _currencies = ['Dollars', 'Euro', 'Pounds', 'Yen'];
  final _consumptionChoices = <String>[
    // if you change the sequence of choices here update
    // _isConsumptionDistancePerFuel() function
    'Distance per Fuel',
    'Fuel per 100 Distance'
  ];

  //this allows us to control the text in a textField
  TextEditingController distanceController = TextEditingController();
  TextEditingController consumptionController = TextEditingController();
  TextEditingController fuelController = TextEditingController();

  @override
  void initState() {
    this._currency = _currencies[0];
    this._distanceUnit = this._getDistanceUnit(this._currency);
    this._volumeUnit = this._getVolumeUnit(this._currency);
    this._consumption = _consumptionChoices[0];
  }

  void _reset() {
    distanceController.text = '';
    fuelController.text = '';
    consumptionController.text = '';
    setState(() {
      result = '';
    });
  }

  void _validate() {
    setState(() {
      _validationElement = []; //initialize validation stack
    });

    if (distanceController.text == '') {
      setState(() {
        _validationElement.add('distance');
      });
    }

    if (fuelController.text == '') {
      setState(() {
        _validationElement.add('fuel');
      });
    }

    if (consumptionController.text == '') {
      setState(() {
        _validationElement.add('consumption');
      });
    }
  }

  String _calculate() {

    if ( listEquals( _validationElement, [""]) == true ) { return "";}
    
    // use String.replaceAll to convert , with correct decimal .
    double _distance =
        double.parse(distanceController.text.replaceAll(',', '.'));

    double _fuelCost = double.parse(fuelController.text.replaceAll(',', '.'));

    double _consumption =
        double.parse(consumptionController.text.replaceAll(',', '.'));

    double _totalCost = 0.0;
    if (_isConsumptionDistancePerFuel()) {
      _totalCost = _distance / _consumption * _fuelCost; // Distance per Fuel
    } else {
      _totalCost =
          _consumption / 100 * _distance * _fuelCost; // Fuel per 100 km /mi
    }

    String _result = "The total cost for your trip is " +
        _totalCost.toStringAsFixed(2) +
        ' ' +
        _currency;
    return _result;
  }

  String _getDistanceLabel() {
    return "Trip Distance (${this._distanceUnit})";
  }

  String _getConsumptionLabel() {
    String res = "";
    if (_isConsumptionDistancePerFuel()) {
      // Distance per Fuel
      res = "${this._distanceUnit} per ${this._volumeUnit} of fuel";
    } else {
      // Fuel per 100 km /mi
      res = "${this._volumeUnit} per 100 ${this._distanceUnit}";
    }

    return res;
  }

  String _getConsumptionHint() {
    String res = "";
    if (_isConsumptionDistancePerFuel()) {
      // Distance per Fuel
      res = "e.g. 17";
    } else {
      // Fuel per 100 km /mi
      res = "e.g. 7.5";
    }

    return res;
  }

  bool _isConsumptionDistancePerFuel() {
    // Assuming "Distance per Fuel' is the first option in the list
    return _consumption == _consumptionChoices[0];
  }

  String _getDistanceUnit(String currency) {
    String _unit = "";
    if (['Dollars', 'Pounds'].contains(currency)) {
      _unit = "mi";
    } else {
      _unit = "km";
    }

    return _unit;
  }

  String _getVolumeUnit(String currency) {
    String _unit = "";
    if (['Dollars', 'Pounds'].contains(currency)) {
      _unit = "gal";
    } else {
      _unit = "lt";
    }

    return _unit;
  }

  @override
  Widget build(BuildContext formContext) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
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
              child: ListView(
                // Column(  /*Replaced column with ListView to fix landscape rotation */
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
                            labelText:
                                _getDistanceLabel(), // "Trip Distance (${this._distanceUnit})",
                            labelStyle: textStyle,
                            errorText: _validationElement.contains('distance')
                                ? 'Value Can\'t Be Empty'
                                : null,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: _formPadding, top: _formPadding),
                      child: Row(children: [
                        Expanded(
                            child: TextField(
                          controller: consumptionController,
                          style: textStyle,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: _getConsumptionHint(),
                              labelText:
                                  _getConsumptionLabel(), // "${this._distanceUnit} per ${this._volumeUnit} of fuel",
                              labelStyle: textStyle,
                              errorText:
                                  _validationElement.contains('consumption')
                                      ? 'Value Can\'t Be Empty'
                                      : null,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        )),
                        Container(width: _formPadding * 5),
                        Expanded(
                          child: DropdownButton<String>(
                            isExpanded: true, //
                            items: _consumptionChoices.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    overflow: TextOverflow.ellipsis),
                              );
                            }).toList(),
                            value: _consumption,
                            style: textStyle,
                            onChanged: (value) {
                              _onDropDownConsumptionChanged(value);
                            },
                          ),
                        )
                      ])),
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
                              errorText: _validationElement.contains('fuel')
                                  ? 'Value Can\'t Be Empty'
                                  : null,
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
                              _onDropDownCurrencyChanged(value);
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
                        _validate();
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

  void _onDropDownConsumptionChanged(String value) {
    setState(() {
      this._consumption = value;
    });
  }

  void _onDropDownCurrencyChanged(String value) {
    setState(() {
      this._currency = value;
      this._distanceUnit = this._getDistanceUnit(this._currency);
      this._volumeUnit = this._getVolumeUnit(this._currency);
    });
  }
}
