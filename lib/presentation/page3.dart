import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tes/presentation/page1.dart';

// ignore: must_be_immutable
class Page3 extends StatefulWidget {
  Page3({Key? key, this.answerMap, this.consoleAns}) : super(key: key);
  Map<int, dynamic>? answerMap;
  Map<int, dynamic>? consoleAns;

  @override
  _Page3State createState() => _Page3State();
}

var per;
var score = 0;
var result;

class _Page3State extends State<Page3> {
  CollectionReference quickRecap =
      FirebaseFirestore.instance.collection('quick_recap');
  @override
  void initState() {
    getResult();
    super.initState();
  }

  @override
  // ignore: override_on_non_overriding_member
  resetData() {
    widget.answerMap!.clear();
    widget.consoleAns!.clear();
    score = 0;
    result = null;
    per = null;
  }

  getResult() {
    for (var i = 0; i <= widget.consoleAns!.length; i++) {
      if (widget.answerMap![i] == widget.consoleAns![i]) {
        score = score + 1;
      }
    }
    per = (((score - 1) / widget.answerMap!.length) * 100).toString();
    result = per.split('.');
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                //get the image
                getbackImage(size),
                //getting data from firebase usinf stream
                getListView(context, size, quickRecap),
                const SizedBox(height: 49),
              ],
            ),
            getCloseIcon(context, resetData),
            getResultWidget(context, size),
          ],
        ),
      ),
    );
  }
}

Widget getResultWidget(BuildContext context, Size size) {
  return Positioned(
    left: 0,
    right: 0,
    top: size.height / 4.7,
    child: Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            'Results',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        //result card Widget
        getCardWidget(size),
      ],
    ),
  );
}

Widget getCloseIcon(BuildContext context, Function() resetData) {
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
        resetData();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Page1()));
      },
    ),
  );
}

Widget getbackImage(Size size) {
  return Container(
    child: Image.asset(
      'assets/Group 963.png',
    ),
  );
}

Widget getListView(BuildContext context, Size size, quickRecap) {
  return ListView(
    physics: NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    children: [
      Container(
        alignment: Alignment.bottomCenter,
        height: size.height * .42,
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'Quick Recap',
          style: TextStyle(
              color: Colors.indigo[900],
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      StreamBuilder(
        stream: quickRecap.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            padding: EdgeInsets.all(0),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          snapshot.data!.docs[index]['head'],
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider(
                          endIndent: 0,
                          height: 2,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.feed_outlined,
                              color: Colors.indigo[900],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Insight',
                              style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          snapshot.data!.docs[index]['sub_head'],
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: snapshot.data!.size,
          );
        },
      ),
    ],
  );
}

//card widget
Widget getCardWidget(size) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: size.height * .40,
                  child: Image.asset(
                    'assets/Layer 2.png',
                  ),
                ),
                Container(
                  height: size.height * .40,
                  width: size.width,
                  // color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.catching_pokemon_outlined,
                            size: 30,
                            color: Colors.indigo[900],
                          ),
                        ],
                      ),
                      const Text(
                        'HIPAA Compliance',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                      const Text(
                        'Awesome!',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Your Scored',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "${result[0]}%",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
            CupertinoButton(
                color: Colors.indigo[900],
                child: Text(
                  'Email Report',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {})
          ],
        ),
      ),
      height: size.height * .52,
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
