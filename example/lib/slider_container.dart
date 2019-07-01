import 'package:flutter/material.dart';

class SliderContainer extends StatefulWidget{
  final String label;
  final int min;
  final int max;
  final int start;
  final bool border;
  final Function(double) onChange;
  const SliderContainer({Key key, @required this.label,@required this.border, @required  this.min, @required  this.max, @required  this.start, @required  this.onChange}) : super(key: key);
  createState()=>_SliderState();
}
class _SliderState extends State<SliderContainer>{
  double value;
  @override
  void initState() {
    value = widget.start.toDouble();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: widget.border?Border(
          bottom: BorderSide(color: Colors.black,width: 3),
        ):null
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.label,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16
                ),
              ),
              IconButton(
                onPressed: (){
                  if(value!=widget.start)
                  setState(() {
                    value = widget.start.toDouble();
                    widget.onChange(value);
                  });
                },
                icon: Icon(Icons.restore,color: Colors.red,size: 30,),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("${widget.min}"),
                Text("${value}"),
                Text("${widget.max}"),
              ],
            ),
          ),
          Slider(
            onChanged: (d){
              setState(() {
                value = d;
              });
            },
            min: widget.min.toDouble(),
            max: widget.max.toDouble(),
            onChangeEnd: (d){
              widget.onChange(d);
            },
            value: value,
          ),
        ],
      ),
    );
  }

}