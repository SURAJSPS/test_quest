import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tes/presentation/page3.dart';

class Page2 extends StatefulWidget {
  Page2({Key? key}) : super(key: key);
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final CarouselController buttonCarouselController = CarouselController();
  CollectionReference questions =
      FirebaseFirestore.instance.collection('questions_list');
  Map<int, dynamic> answerMap = {};
  Map<int, dynamic> consoleAns = {};
  solveAgain() {
    answerMap.clear();
    consoleAns.clear();
  }

  @override
  void initState() {
    solveAgain();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            getBackGroundWidgwt(context, size),
            getIconWidget(context),
            Positioned(
              left: 0,
              right: 0,
              top: size.height / 4.7,
              child: Column(
                children: [
                  getHIPAA(),

                  SizedBox(
                    height: 40,
                  ),
                  // streamBilder and Question Card Widget and some other widgwt
                  getStreamBilder(context, size, buttonCarouselController,
                      questions, setState, consoleAns, answerMap),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget getHIPAA() {
  return Container(
    alignment: Alignment.center,
    child: Text(
      'HIPAA Compliances',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    ),
  );
}

/// Icon Widget
Widget getIconWidget(BuildContext context) {
  return Positioned(
    top: 55,
    left: 10,
    child: IconButton(
      icon: Icon(
        Icons.close,
        color: Colors.white,
        size: 35,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );
}

//BackGround Widget
Widget getBackGroundWidgwt(BuildContext context, Size size) {
  return Column(
    children: [
      Container(
        child: Image.asset(
          'assets/Group 963.png',
        ),
      ),
      Container(
        alignment: Alignment.bottomCenter,
        height: size.height / 2.3,
        child: Text(
          'Not Applicable',
          style: TextStyle(
              fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
      ),
      SizedBox(
        height: 49,
      )
    ],
  );
}

// streamBilder and Question Card Widget and some other widgwt
Widget getStreamBilder(BuildContext context, Size size,
    buttonCarouselController, questions, setState, consoleAns, answerMap) {
  return StreamBuilder(
    stream: questions.snapshots(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      }
      return CarouselSlider.builder(
        carouselController: buttonCarouselController,
        itemCount: snapshot.data!.size,
        itemBuilder: (context, index, relat) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                width: size.width,
                height: size.height / 2,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "${snapshot.data!.docs[index]['index']}" +
                                  ' / ' +
                                  "${snapshot.data!.size}",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "${snapshot.data!.docs[index]['question']}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                answerMap[index] = true;
                              });

                              setState(() {
                                consoleAns[index] =
                                    snapshot.data!.docs[index]['answer'];
                              });

                              setState(() {
                                if (snapshot.data!.docs[index]['index'] ==
                                    snapshot.data!.size) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Page3(
                                                answerMap: answerMap,
                                                consoleAns: consoleAns,
                                              )));
                                } else {
                                  buttonCarouselController.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.linear);
                                }
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                  color: answerMap[index] != true
                                      ? Colors.green
                                      : Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              height: size.height * .055,
                              width: size.width * .30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: answerMap[index] != true
                                    ? Colors.white
                                    : Colors.green,
                                border: Border.all(color: Colors.green),
                              ),
                            ),
                          ),

                          /// No

                          InkWell(
                            onTap: () {
                              setState(() {
                                answerMap[index] = false;
                              });

                              setState(() {
                                consoleAns[index] =
                                    snapshot.data!.docs[index]['answer'];
                              });

                              setState(() {
                                if (snapshot.data!.docs[index]['index'] ==
                                    snapshot.data!.size) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Page3(
                                                answerMap: answerMap,
                                                consoleAns: consoleAns,
                                              )));
                                } else {
                                  buttonCarouselController.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.linear);
                                }
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                'No',
                                style: TextStyle(
                                  color: answerMap[index] != false
                                      ? Colors.red
                                      : Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              height: size.height * .055,
                              width: size.width * .30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: answerMap[index] != false
                                    ? Colors.white
                                    : Colors.red,
                                border: Border.all(color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        options: CarouselOptions(
          height: size.height / 2,
        ),
      );
    },
  );
}
