import 'package:flutter/material.dart';
import 'package:home_dashboard/services/formatClasses.dart';
import 'package:flutter_svg/flutter_svg.dart';

// class CustomCard extends StatefulWidget {
//
//   final Widget child;
//   final String title;
//   const CustomCard({Key? key, required this.child, required this.title}) : super(key: key);
//
//   @override
//   _CustomCardState createState() => _CustomCardState(child: child, title: title);
// }
//
// class _CustomCardState extends State<CustomCard> {
//
//
//   Widget child;
//   String title;
//   _CustomCardState({required this.child, required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
//         elevation: 5.0,
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Stack(
//                 children: [
//                   Container(
//                     height: 35,
//                     width: title.length.toDouble() * 40,
//                     decoration: BoxDecoration(
//                         color: MyColors().lightColor1,
//                         borderRadius: BorderRadius.circular(20)),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
//                     child: Text(title, style: MyTextStyle().title),
//                   )
//                 ],
//               ),
//               Expanded(
//                 child: child,
//               )
//             ],
//           ),
//         ),
//         color: MyColors().color1
//     );
//   }
// }

class CustomCard extends StatelessWidget {

  final Widget child;
  final String title;
  const CustomCard({required this.child, required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Container(
                    height: 35,
                    width: title.length.toDouble() * 40,
                    decoration: BoxDecoration(
                        color: MyColors().lightColor1,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(title, style: MyTextStyle().title),
                  )
                ],
              ),
              Expanded(
                child: child,
              )
            ],
          ),
        ),
        color: MyColors().color1
    );
  }
}