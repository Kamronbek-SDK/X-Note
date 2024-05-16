import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'class.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({super.key, required this.note, required this.click});
  final Note note;
  final VoidCallback click;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: click,
      child: Ink(
        decoration: BoxDecoration(
          color: NoteColors.colors[note.colorId],
          borderRadius: BorderRadius.circular(15)
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(note.title, style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
            Text(note.desc),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.calendar, size: 17,),
                  const Gap(6),
                  Text(note.time, style: const TextStyle(fontSize: 12),),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
