import 'package:flutter/material.dart';

class TimeComponent extends StatefulWidget {
  @override
  _TimeComponentState createState() => _TimeComponentState();
}

class _TimeComponentState extends State<TimeComponent> {
  final List<String> _hours = List.generate(25, (index) => index++)
      .map((h) => '${h.toString().padLeft(2, '0')}')
      .toList();
  final List<String> _min = List.generate(61, (index) => index++)
      .map((h) => '${h.toString().padLeft(2, '0')}')
      .toList();
  final List<String> _sec = List.generate(61, (index) => index++)
      .map((h) => '${h.toString().padLeft(2, '0')}')
      .toList();

  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      _buildBox(_hours),
      _buildBox(_min),
      _buildBox(_sec),
    ]);
  }

  Widget _buildBox(List<String> options) {
    return Container(
      height: 120,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
              spreadRadius: 0,
              blurRadius: 5,
              color: Colors.grey,
              offset: Offset(2, 5))
        ],
      ),
      child: ListWheelScrollView(
        itemExtent: 60,
        perspective: 0.007,
        physics: FixedExtentScrollPhysics(),
        children: options
            .map<Text>((e) => Text(
                  e,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ))
            .toList(),
      ),
    );
  }
}
