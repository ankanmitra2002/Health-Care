import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/views/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  List<Map<String, dynamic>> _journals = [];

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
    });
  }

  String dropdownValue = 'Male';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshJournals();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  Future<void> _addItem() async {
    await SQLHelper.createItem(_titleController.text, _nameController.text,
        _aadharController.text, _addressController.text);
    _refreshJournals();
    print("no of items: ${_journals.length}");
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(id, _titleController.text, _nameController.text,
        _aadharController.text, _addressController.text);
    _refreshJournals();
  }

  Future<void> _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    _refreshJournals();
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _nameController.text = existingJournal['name'];
      _aadharController.text = existingJournal['aadhar'];
      _addressController.text = existingJournal['address'];
    }
    showModalBottomSheet(
      context: context,
      builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text('USER DETAILS', style: TextStyle(fontSize: 25)),
            backgroundColor: Color.fromARGB(255, 147, 203, 241),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
              child: Container(
            color: Color.fromARGB(255, 147, 203, 241),
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    // enableSuggestions: false,
                    // autocorrect: false,
                    // keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _nameController,
                    // enableSuggestions: false,
                    // autocorrect: false,
                    // keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _aadharController,
                    decoration: InputDecoration(
                      hintText: 'Adhaar Card Number',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: 'Addressline-1',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 40,
                    width: 200,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (id == null) {
                            await _addItem();
                            var prefs = await SharedPreferences.getInstance();
                            prefs.setBool('saved', true);
                          }
                          if (id != null) {
                            await _updateItem(id);
                          }
                          _titleController.text = '';
                          _nameController.text = '';
                          _addressController.text = '';
                          _aadharController.text = '';
                        },
                        child: Text(id == null ? 'Create New' : 'Update')),
                  ),
                ],
              ),
            ),
          ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.amber,
      ),
      body: ElevatedButton(
        onPressed: () async {
          var prefs = await SharedPreferences.getInstance();

          return prefs.getBool('saved') ?? false
              ? _showForm(_journals[0]['id'])
              : _showForm(null);
        },
        child: const Text('Your Profile'),
      ),
    );
  }
}
