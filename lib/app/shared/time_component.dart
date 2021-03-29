import 'package:flutter/material.dart';

class TimeComponent extends StatefulWidget {
  late DateTime date;
  ValueChanged<DateTime> onSelectedTime;
  TimeComponent({
    Key? key,
    required this.date,
    required this.onSelectedTime,
  }) : super(key: key);

  @override
  _TimeComponentState createState() => _TimeComponentState();
}

class _TimeComponentState extends State<TimeComponent> {
  final List<String> _hours = List.generate(24, (index) => index++)
      .map((h) => '${h.toString().padLeft(2, '0')}')
      .toList();
  final List<String> _min = List.generate(60, (index) => index++)
      .map((h) => '${h.toString().padLeft(2, '0')}')
      .toList();
  final List<String> _sec = List.generate(60, (index) => index++)
      .map((h) => '${h.toString().padLeft(2, '0')}')
      .toList();

  String _hourSelected = DateTime.now().hour.toString();
  String _minSelected = DateTime.now().minute.toString();
  String _secSelected = DateTime.now().second.toString();

  void invokeCallback() {
    var newDate = DateTime(
      widget.date.year,
      widget.date.month,
      widget.date.day,
      int.parse(_hourSelected),
      int.parse(_minSelected),
      int.parse(_secSelected),
    );
    widget.onSelectedTime(newDate);
  }

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildBox(_hours, (String value) {
          setState(() {
            _hourSelected = value;
            invokeCallback();
          });
        }),
        _buildBox(_min, (String value) {
          setState(() {
            _minSelected = value;
            invokeCallback();
          });
        }),
        _buildBox(_sec, (String value) {
          setState(() {
            _secSelected = value;
            invokeCallback();
          });
        }),
      ],
    );
  }

  Widget _buildBox(List<String> options, ValueChanged<String> onChange) {
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
        onSelectedItemChanged: (value) =>
            onChange(value.toString().padLeft(2, '0')),
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
