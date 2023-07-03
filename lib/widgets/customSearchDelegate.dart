import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/data/local_storege.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/widgets/taskListItem.dart';

class CustomSearchDeletegate extends SearchDelegate {
  @override
  final List<Task> allTasks;

  CustomSearchDeletegate({required this.allTasks});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query.isEmpty ? null : query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: const Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var filderedList = allTasks
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return filderedList.isNotEmpty
        ? ListView.builder(
            itemBuilder: (context, index) {
              var oAnkiEleman = filderedList[index];
              return Dismissible(
                background: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text("remove_task").tr()
                    ],
                  ),
                ),
                key: Key(oAnkiEleman.id),
                onDismissed: (direction) async {
                  filderedList.removeAt(index);
                  await locator<LocalStorage>().deleteTask(task: oAnkiEleman);
                },
                child: TaskItem(task: oAnkiEleman),
              );
            },
            itemCount: filderedList.length,
          )
        : Center(
            child: Text('search_not_found').tr(),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
