import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter20/note.page.dart';

import 'class.dart';
import 'database.dart';
import 'note.item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _controller = TextEditingController();

  final List<Note> _cachedList = [];
  final List<Note> _noteList = [];

  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => const NotePage())
        );
      },
        backgroundColor: const Color(0xFFefe6dd),
        child: const Icon(CupertinoIcons.add,color: Colors.black,),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("X Note"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SearchBar(
              autoFocus: false,
              controller: _controller,
              onChanged: (value) => _search(value),
              backgroundColor: MaterialStateProperty.all(const Color(0xFFefe6dd)),
              hintText: "Search",
              hintStyle: MaterialStateProperty.all(
                  const TextStyle(
                      color: Colors.black
                  )
              ),
              textStyle: MaterialStateProperty.all(const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              )),
              elevation: MaterialStateProperty.all(2),
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              padding: const EdgeInsets.only(bottom: 1),
              icon: const Icon(CupertinoIcons.delete, color: Colors.red)
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: FutureBuilder(
          future: Database.allNotes(), //
          builder: (context, snapshot) {
            if(snapshot.data != null && snapshot.data?.isNotEmpty == true) {
              if(firstTime) {
                _cachedList.clear();
                _cachedList.addAll(snapshot.data ?? []);
                _noteList.clear();
                _noteList.addAll(snapshot.data ?? []);
                firstTime = false;
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 12, crossAxisSpacing: 12, crossAxisCount: 2),
                itemCount: _noteList.length,
                itemBuilder: (context, index) {
                  return NoteItem(note: _noteList[index], click: () => _showDeleteDialog(_noteList[index].id));
                },
              );
            }
            else {
              return const Center(child: Text("No data."));
            }
          },
        ),
      ),
    );
  }
  void _showDeleteDialog(int? id) async {
    showAdaptiveDialog(context: context, builder: (context) => CupertinoAlertDialog(
      title: const Text("Delete?"),
      actions: [
        CupertinoDialogAction(child: const Text("No"),onPressed: () {
          Navigator.of(context).pop();
        },),
        CupertinoDialogAction(isDestructiveAction: true,onPressed: () {
          Navigator.of(context).pop();
          Database.delete(id);
          setState(() {});
        } ,child: const Text("Yes")),
      ],
    ));
  }

  _search(String value) {
    if(value.isEmpty) {
      _noteList.clear();
      _noteList.addAll(_cachedList);
    } else {
      final filteredList = _cachedList.where((element) => element.title.toLowerCase().contains(value.toLowerCase()) ||
          element.desc.toLowerCase().contains(value.toLowerCase()));
      _noteList.clear();
      _noteList.addAll(filteredList);
    }
    setState(() {});
  }
}