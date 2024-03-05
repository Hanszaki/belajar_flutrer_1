import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Anggota Kelompok 4'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<TodoData> _todoList = [];

  void _incrementCounter() {
    // Show the bottom sheet to input data
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AddTodoBottomSheet(
          onAddTodo: (name, nim) {
            // Add the new todo to the list
            setState(() {
              _todoList.add(TodoData(name: name, nim: nim));
            });
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(TodoData todo) {
    late OverlayEntry overlayEntry;

    // Show delete confirmation overlay
    overlayEntry = OverlayEntry(
      builder: (context) => DeleteConfirmationOverlay(
        onConfirm: () {
          // Handle delete action here
          setState(() {
            _todoList.remove(todo);
          });

          // Remove the overlay
          overlayEntry.remove();
        },
        onCancel: () {
          // Remove the overlay
          overlayEntry.remove();
        },
      ),
    );

    // Insert overlay to the overlay entry
    Overlay.of(context)?.insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: ListView(
        children: _todoList.map((todo) {
          return CardWidget(
            name: todo.name,
            nim: todo.nim,
            onDelete: () {
              _showDeleteConfirmation(todo);
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_comment_rounded),
      ),
    );
  }
}

class TodoData {
  final String name;
  final int nim;

  TodoData({required this.name, required this.nim});
}

class AddTodoBottomSheet extends StatefulWidget {
  final Function(String name, int nim) onAddTodo;

  const AddTodoBottomSheet({Key? key, required this.onAddTodo})
      : super(key: key);

  @override
  State<AddTodoBottomSheet> createState() => _AddTodoBottomSheetState();
}

class _AddTodoBottomSheetState extends State<AddTodoBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _nimController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nimController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Tambah Data',
            style: Theme.of(context).textTheme.headline6,
          ),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nama'),
          ),
          TextField(
            controller: _nimController,
            decoration: const InputDecoration(labelText: 'NIM'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Validate and add todo
                  final String name = _nameController.text;
                  final int nim = int.tryParse(_nimController.text) ?? 0;
                  if (name.isNotEmpty && nim > 0) {
                    widget.onAddTodo(name, nim);
                    Navigator.pop(context); // Close the bottom sheet
                  } else {
                    // Show an error message or handle invalid input
                    // For simplicity, we just print a message here
                    print('Invalid input');
                  }
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    super.dispose();
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({
    Key? key,
    required this.name,
    required this.nim,
    required this.onDelete,
  }) : super(key: key);

  final String name;
  final int nim;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'NIM: $nim',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteConfirmationOverlay extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const DeleteConfirmationOverlay({
    Key? key,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background overlay
        GestureDetector(
          onTap: onCancel,
          child: Container(
            color: const Color.fromARGB(183, 0, 0, 0),
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        // Delete confirmation card
        Center(
          child: Container(
            width: 250,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Anda yakin menghapus data ini?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: Checkbox.width,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: onConfirm,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0, // Remove shadow
                      ),
                      child: const Text('OK',
                          style: TextStyle(
                              color: Color.fromARGB(255, 138, 71, 71))),
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: onCancel,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0, // Remove shadow
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(
                              color: Color.fromARGB(255, 117, 67, 67))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
