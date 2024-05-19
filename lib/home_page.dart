import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter20/database.dart';
import 'package:flutter20/note.page.dart';

import 'class.dart';
import 'note.item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Note> _cachedList = [];
  final List<Note> _noteList = [];

  bool firstT = false;
  final _controller = TextEditingController();

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
        title: const Text('X Note'),
        actions: [
          IconButton(
              onPressed: () {
                Database.deleteAll();
              },
              icon: const Icon(
                CupertinoIcons.delete,
                color: Colors.red,
              )
          )
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: SearchBar(
              onChanged: (v) => _search(v),
              controller: _controller,
              hintText: 'Search',
              hintStyle: MaterialStateProperty.all(
                const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              elevation: MaterialStateProperty.all(2),
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: FutureBuilder(
          future: Database.allNotes(), //
          builder: (context, snapshot) {
            if(snapshot.data != null && snapshot.data?.isNotEmpty == true) {
              if(firstT) {
                _cachedList.clear();
                _cachedList.addAll(snapshot.data ?? []);
                _noteList.clear();
                _noteList.addAll(snapshot.data ?? []);
                firstT = false;
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 12, crossAxisSpacing: 12, crossAxisCount: 2),
                itemCount: _noteList.length,
                itemBuilder: (context, index) {
                  return NoteItem(note: _noteList[index], click: () => _dialog(_noteList[index].id));
                },
              );
            }  else if(snapshot.data?.isEmpty == true) {
              return const Center(child: Text("No data."));
            }
            else {
              return const Center(child: Text('No data'));
            }
          },
        ),
      ),
    );
  }

  _search(String text) {
    if (text.isEmpty) {
      _noteList.clear();
      _noteList.addAll(_cachedList);
    } else {
      final filteredList = _cachedList.where((element) =>
          element.title.toLowerCase().contains(text.toLowerCase()) ||
          element.desc.toLowerCase().contains(text.toLowerCase()));
      _noteList.clear();
      _noteList.addAll(filteredList);
    }
    setState(() {});
  }

  _dialog(int? id) async {
    showAdaptiveDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text('Delete ?'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('No'),
                  onPressed: () => Navigator.of(context).pop,
                ),
                CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: const Text('Yes'),
                    onPressed: () {
                      Database.delete(id!).then((v) {
                        setState(() {});
                      });
                    }),
              ],
            ));
  }
}
