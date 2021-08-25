import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tes/presentation/page2.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference category =
        FirebaseFirestore.instance.collection('category');
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            getBackGroundImage(context, size),
            Positioned(
              left: 0,
              right: 0,
              top: size.height / 3.1,
              child: Column(
                children: [
                  getCategory(),
                  SizedBox(
                    height: 40,
                  ),
                  getStreamBuilder(category, size),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget  getCategory() { 
  return Container(
    alignment: Alignment.center,
    child: Text(
      'Select a Category',
      style: TextStyle(
        color: Colors.white,
        fontSize: 30,
      ),
    ),
  );
}

Widget getBackGroundImage(BuildContext context, Size size) {
  return Container(
    width: size.width,
    child: Image.asset(
      'assets/Group 9634.png',
    ),
  );
}

// ListView

Widget getStreamBuilder(category, size) {
  return StreamBuilder(
    stream: category.snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      }
      return ListView(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        children: snapshot.data!.docs.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: size.height * .10,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Page2()));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      Icon(
                        IconData(e['icon'], fontFamily: 'MaterialIcons'),
                        size: 35,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Text(
                          e['name'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    },
  );
}

// Custam Curve But Not Use

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 35;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
