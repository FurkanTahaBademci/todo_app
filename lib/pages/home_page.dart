import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:todo_app/data/local_storege.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/widgets/customSearchDelegate.dart';
import 'package:todo_app/widgets/taskListItem.dart';

import '../helper/translation_helper.dart';
import '../models/task_model.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  late LocalStorage _localStorage;

  @override
  void initState() {

    super.initState();
    _allTasks = <Task>[];
    _localStorage = locator<LocalStorage>();
    _getAllTaskFromDb();

  }

  @override
  Widget build(BuildContext context) {
    TranslationHelper.getDeviceLanguage(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showBottomAddTaskBottom(context);
          },
          child: const Text(
            'title',
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
        centerTitle: false, //ios default ortalıyor
        actions: [
          IconButton(
            onPressed: () {
              _showSearchPage();
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              _showBottomAddTaskBottom(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _allTasks.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                var oAnkiEleman = _allTasks[index];
                return Dismissible(
                  background: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.delete,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text("remove_task",
                          style: TextStyle(fontSize: 15, color: Colors.black38),).tr()
                        ],
                      ),
                    ),
                  ),
                  key: Key(oAnkiEleman.id),
                  onDismissed: (direction) {
                    setState(() {
                      _allTasks.removeAt(index);
                      _localStorage.deleteTask(task: oAnkiEleman);
                      setState(() {});
                    });
                  },
                  child: TaskItem(task: oAnkiEleman),
                );
              },
              itemCount: _allTasks.length,
            )
          : Center(child: Text('empty_task_list').tr()),
    );
  }

  void _showBottomAddTaskBottom(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: Card(
            elevation: 0,
            margin: const EdgeInsets.all(0),
            child: TextField(
              autofocus: true,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: 'add_task'.tr(),
                disabledBorder: InputBorder.none,
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.length > 3) {
                  DatePicker.showTimePicker(
                    locale: TranslationHelper.getDeviceLanguage(context),
                    context,
                    showSecondsColumn: false,
                    onConfirm: (time) async {
                      var yeniEklenecekGorev = Task.create(
                        name: value,
                        createdAt: time,
                      );
                      _allTasks.insert(0, yeniEklenecekGorev);
                      await _localStorage.addTask(task: yeniEklenecekGorev);
                      setState(() {});
                    },
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _getAllTaskFromDb() async {
    _allTasks = await _localStorage.getAllTask();
    setState(() {});
  }

  Future<void> _showSearchPage() async {
    await showSearch(
      context: context,
      delegate: CustomSearchDeletegate(allTasks: _allTasks),
    );
    _getAllTaskFromDb();
  }
}
