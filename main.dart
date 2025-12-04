import 'package:flutter/material.dart';

void main() => runApp(TDAHApp());

class TDAHApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TDAH Tasks',
      home: TaskPage(),
    );
  }
}

class Task {
  String name;
  DateTime deadline;
  bool done;
  Task(this.name, this.deadline, {this.done = false});
}

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final List<Task> tasks = [];
  final nameController = TextEditingController();
  DateTime? selectedDate;

  void addTask() {
    if (nameController.text.isNotEmpty && selectedDate != null) {
      setState(() {
        tasks.add(Task(nameController.text, selectedDate!));
        nameController.clear();
        selectedDate = null;
      });
    }
  }

  void markDone(int index) {
    setState(() {
      tasks[index].done = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("🎉 Tarefa concluída!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gerenciador TDAH')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Nome da tarefa'),
          ),
          ElevatedButton(
            onPressed: () async {
              selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
            },
            child: Text('Selecionar prazo'),
          ),
          ElevatedButton(onPressed: addTask, child: Text('Adicionar tarefa')),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, i) {
                if (!tasks[i].done) {
                  return ListTile(
                    title: Text(tasks[i].name),
                    subtitle: Text(
                      'Prazo: ${tasks[i].deadline.toLocal()}'.split(' ')[0],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () => markDone(i),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          )
        ]),
      ),
    );
  }
}
