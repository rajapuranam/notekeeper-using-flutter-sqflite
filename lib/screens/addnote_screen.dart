import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/database_helper.dart';
import '../modals/note_modal.dart';

class AddNoteScreen extends StatefulWidget {
  final Note note;
  AddNoteScreen([this.note]);
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState(note);
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  bool isUpdate = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Note note;
  DatabaseHelper helper = DatabaseHelper();
  String datehere;
  int result;

  _AddNoteScreenState(this.note) {
    if (note != null) {
      titleController.text = note.title;
      descriptionController.text = note.description;
      isUpdate = true;
    }
  }

  void _update() async {
    isUpdate = false;
    if (titleController.text.length <= 0)
      _showAlertDialog('error', 'Title can\'t be empty');
    else {
      datehere = DateFormat.yMd().add_jm().format(DateTime.now());
      int tempId = note.id;
      note = Note.withID(tempId, titleController.text, datehere, descriptionController.text);
      Navigator.pop(context, 'saved');
      result = await helper.updateNote(note);

      if (result != 0)
        _showAlertDialog('success', 'Note Updated Successfully');
      else
        _showAlertDialog('error', 'Problem in Saving Note');
    }
  }

  void _save() async {
    if (titleController.text.length <= 0)
      _showAlertDialog('error', 'Title can\'t be empty');
    else {
      datehere = DateFormat.yMd().add_jm().format(DateTime.now());
      note = Note(titleController.text, datehere, descriptionController.text);
      Navigator.pop(context, 'saved');
      result = await helper.insertNote(note);

      if (result != 0)
        _showAlertDialog('success', 'Note Saved Successfully');
      else
        _showAlertDialog('error', 'Problem in Saving Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0, top: 40),
                    child: Image.asset(
                      title == "success"
                          ? "assets/images/success.png"
                          : "assets/images/error.png",
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 25, 20, 40),
                    child: Text(
                      message,
                      style: TextStyle(
                        // fontFamily: "ArchitectsDaughter",
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.5,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
            child: TextField(
              controller: titleController,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                // fontFamily: "ArchitectsDaughter",
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
                fontSize: 16.5,
              ),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 1.5),
                ),
                labelText: 'Title',
                labelStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  // fontFamily: "ArchitectsDaughter",
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
            child: TextField(
              maxLines: 2,
              controller: descriptionController,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                // fontFamily: "ArchitectsDaughter",
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
                fontSize: 16.5,
              ),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 1.5),
                ),
                labelText: 'Description',
                labelStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  // fontFamily: "ArchitectsDaughter",
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(
                      color: Theme.of(context).primaryColor, width: 1.5),
                ),
                color: Colors.grey[50],
                textColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    // fontFamily: "ArchitectsDaughter",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 15),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 43, vertical: 10),
                onPressed: () {
                  isUpdate ? _update() : _save();
                  
                },
                child: Text(
                  isUpdate ? "Update Note" : "Save Note",
                  style: TextStyle(
                    // fontFamily: "ArchitectsDaughter",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}
