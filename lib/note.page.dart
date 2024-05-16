import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter20/class.dart';
import 'package:flutter20/database.dart';

import 'home_page.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {

  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();

  int colorInt = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NoteColors.colors[colorInt],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('New Note',),
        actions: [
          AnimatedOpacity(
              opacity: _controller2.text.isNotEmpty ? 1 : 0,
              duration: const Duration(milliseconds: 450),
            child: IconButton(
              onPressed: _controller2.text.isNotEmpty ? _done() : null,
              icon: const Icon(Icons.done, color: Colors.white,),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _picker(),
        backgroundColor: const Color(0xFFefe6dd),
        child: const Icon(Icons.color_lens_outlined, color: Colors.black,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _controller1,
              maxLines: null,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Title',
                hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
              ),
            ),
            Expanded(
                child: TextField(
                  controller: _controller2,
                  maxLines: null,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (v) => setState(() {}),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Note'
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
  void _save() {
    String title = _controller1.text; // ""
    if(_controller1.text.isEmpty) {
      final indexOfSpace = _controller2.text.indexOf(" "); // 2
      final word = _controller2.text.substring(0, indexOfSpace); // My name is Teshavoy // 0, 2
      title = word;
    }
   // final formatter = DateFormat("dd/mm/yyyy");
    Database.saveNote(Note(
        id: null,
        title: title,
        desc: _controller2.text,
        time: formatter.format(DateTime.now().day),
        colorId: colorInt)).then((value) {
      Navigator.of(context)
          .pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => const HomePage()), (route) => false);
    });
  }
  picker(){}
}