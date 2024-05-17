import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class CustIcon extends StatefulWidget {
  final name;
  final iconname;
  final VoidCallback onTap;
  const CustIcon({super.key, required this.name, required this.iconname,  required this.onTap, });

  @override
  State<CustIcon> createState() => _CustIconState();
}

class _CustIconState extends State<CustIcon> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 8,
        child: Container(
          // height:MediaQuery.of(context).size.width > 600 ? 40 : 85,
          // width:MediaQuery.of(context).size.width > 600 ? 40 : 40,
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.teal
          ),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[

                  Container(
                      height: 50,
                      width: 50,
                      child: Image.asset(widget.iconname,fit: BoxFit.contain,)),
                  SizedBox(height: 5,),
                  Text(widget.name,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600              ),)

                ]),
          ),
        ),
      ),
    );
  }
}
