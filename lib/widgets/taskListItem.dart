import 'package:flutter/material.dart';
import 'package:todo_app/data/local_storege.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  const TaskItem({super.key, required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final TextEditingController _taskName = TextEditingController();
  late LocalStorage _localStorage;
  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
    _taskName.text = widget.task.name;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ]),
      child: ListTile(
        subtitle: Align(
          alignment: Alignment.centerRight,
          child: Text(
            DateFormat("dd/mm/yyyy  hh:mm").format(widget.task.createdAt),
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            widget.task.isCompleted = !widget.task.isCompleted;
            _localStorage.updateTask(task: widget.task);
            setState(() {});
          },
          child: Container(
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
                color: widget.task.isCompleted ? Colors.green : Colors.white,
                border: Border.all(color: Colors.grey, width: 0.6),
                shape: BoxShape.circle),
          ),
        ),
        title: widget.task.isCompleted
            ? Text(
                widget.task.name,
                style: const TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.grey),
              )
            : TextField(
                controller: _taskName,
                minLines: 1,
                maxLines: null,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onSubmitted: (value) {
                  if (value.length > 3) {
                    widget.task.name = value;
                    _localStorage.updateTask(task: widget.task);

                    setState(() {});
                  }
                },
              ),
        /*trailing: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              DateFormat("dd/mm/yyyy").format(widget.task.createdAt),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              DateFormat("v").format(widget.task.createdAt),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),*/
      ),
    );
  }
}
