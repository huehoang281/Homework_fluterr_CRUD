import 'package:btvnflutter/ojbect.dart';
import 'package:btvnflutter/teacher.dart';
import 'package:flutter/material.dart';
import './student.dart';
import './teacher.dart';
import './class.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Homeworks'),

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Image(
              width: 300,
              height: 300,
              image: NetworkImage(
                  'https://banner2.cleanpng.com/20190530/ysb/kisspng-classroom-clip-art-image-reading-education-5ceffea78dbf86.3578015615592321675806.jpg'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Hoang Thi Hue',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Student()));
              },
              child: const Text('Student'),
              color: Colors.pink,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Teacher()));
              },
              child: const Text('Teacher '),
              color: Colors.pink,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
            ),
            const SizedBox(
              height: 10,
            ),MaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Class()));
              },
              child: const Text('Class '),
              color: Colors.pink,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Ojbect()));
              },
              child: const Text('Ojbect '),
              color: Colors.pink,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}