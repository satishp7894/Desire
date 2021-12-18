import 'package:flutter/material.dart';

import 'constants.dart';

class CustomStepper extends StatefulWidget {
  final int initialValue;
  final int maxValue;
  final ValueChanged<int> onChanged;
  CustomStepper({this.initialValue, this.maxValue, this.onChanged});

  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  int _value;
  int _maxVal;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? 1;
    _maxVal = widget.maxValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: 95, height: 35,
      decoration: BoxDecoration(
        border: Border.all(width: 0.7, color: Colors.black87),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(child: Icon(Icons.remove),
            onTap: () {
              if (_value > 1) {
                setState(() {
                  _value -= 1;
                  _valueChanged();
                });
              }
            },),
          Text('$_value', style: TextStyle(fontSize: 16.5,), textAlign: TextAlign.center,),
          GestureDetector(child: Icon(Icons.add, color: kPrimaryColor),
            onTap: () {
              if (_value < _maxVal) {
                setState(() {
                  _value += 1;
                  _valueChanged();
                });
              }
            },),
        ],
      ),
    );
  }

  _valueChanged() {
    widget.onChanged(_value);
  }

}

