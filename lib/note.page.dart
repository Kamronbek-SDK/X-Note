import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter20/class.dart';
import 'package:intl/intl.dart';

import 'database.dart';
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
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text("New Note"),
          actions: [
            AnimatedOpacity(
              opacity: _controller2.text.isNotEmpty ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: IconButton(
                  onPressed: _controller2.text.isNotEmpty ? _save : null,
                  icon: const Icon(
                    CupertinoIcons.check_mark,
                    color: Colors.white,
                  )),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                controller: _controller1,
                maxLines: null,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Title",
                  hintStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() {}),
                  controller: _controller2,
                  maxLines: null,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "Description"
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showColorPicker,
          backgroundColor: const Color(0xFFefe6dd),
          child: const Icon(
            Icons.palette_outlined,
            color: Colors.black,
          ),
        )
    );
  }

  void _save() {
    String title = _controller1.text;
    if (_controller1.text.isEmpty) {
      final indexOfSpace = _controller2.text.indexOf(" ");
      final word =
          _controller2.text.substring(0, indexOfSpace);
      title = word;
    }
    final formatter = DateFormat("dd/MM/yyyy");
    Database.saveNote(Note(
            id: null,
            title: title,
            desc: _controller2.text,
            time: formatter.format(DateTime.now()),
            colorId: colorInt
    )
    )
        .then((value) {
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    });
  }

  _showColorPicker() {
    showModalBottomSheet(
        context: context,
        builder: (context) => SizedBox(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: SizedBox(
                    height: 40,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 12,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: NoteColors.colors.length,
                      itemBuilder: (context, index) {
                        return _dot(() {
                          Navigator.of(context).pop();
                          setState(() {
                            colorInt = index;
                          });
                        }, NoteColors.colors[index], index);
                      },
                    ),
                  ),
                ),
              ),
            ));
  }

  _dot(VoidCallback onClick, Color color, int index) {
    return SizedBox(
      height: 40,
      width: 40,
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(50),
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                  width: 2,
                  color: colorInt == index
                      ? Colors.white
                      : Colors.transparent)
          ),
        ),
      ),
    );
  }
}
