import 'package:flutter/material.dart';
import 'package:notekeeper_sqflite/screens/addnote_screen.dart';
import '../modals/note_modal.dart';
import '../helpers/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;
  bool showFab = true;
  void showFoatingActionButton(bool value) {
    setState(() {
      showFab = value;
    });
  }

  Widget noteListTile(BuildContext context, int ind) {
    return Container(
      color: Theme.of(context).primaryColor,
      margin: EdgeInsets.only(bottom: 5, top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 160,
                    child: Text(
                      this.noteList[ind].title,
                      style: TextStyle(
                          color: Colors.white,
                          // fontFamily: "ArchitectsDaughter",
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: MediaQuery.of(context).size.width - 160,
                    child: Text(
                      this.noteList[ind].description,
                      style: TextStyle(
                        color: Colors.white,
                        // fontFamily: "ArchitectsDaughter",
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    this.noteList[ind].date,
                    style: TextStyle(
                      color: Colors.white,
                      // fontFamily: "ArchitectsDaughter",
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _edit(context, noteList[ind]);
                    },
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      _delete(context, noteList[ind]);
                    },
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(color: Colors.white70),
        ],
      ),
    );
  }

  void _edit(BuildContext context, Note note) async {
    openBottomSheet(note);
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          // fontFamily: "ArchitectsDaughter",
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.white,
      duration: Duration(milliseconds: 700),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  final scaffoldState = GlobalKey<ScaffoldState>();

  void openBottomSheet([Note note]) {
    var bottomSheetController;
    if (note == null)
      bottomSheetController = scaffoldState.currentState
          .showBottomSheet((context) => AddNoteScreen());
    else{
      bottomSheetController = scaffoldState.currentState
          .showBottomSheet((context) => AddNoteScreen(note));}
    showFoatingActionButton(false);
    bottomSheetController.closed.then((value) {
      updateListView();
      showFoatingActionButton(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return SafeArea(
      child: Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          toolbarHeight: 90,
          title: Text(
            "Note Keeper",
            style: TextStyle(
              // fontFamily: "ArchitectsDaughter",
              fontSize: 26,
              letterSpacing: 5,
              fontWeight: FontWeight.w600,
              height: 2,
            ),
          ),
          centerTitle: true,
          elevation: 8,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: showFab
            ? FloatingActionButton.extended(
                onPressed: () {
                  openBottomSheet();
                  
                },
                label: Text(
                  "Add note",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    // fontFamily: "ArchitectsDaughter",
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                backgroundColor: Colors.white,
                elevation: 10,
              )
            : Container(),

        body: Container(
          margin: EdgeInsets.fromLTRB(25, 5, 25, 10),
          child: count != 0
              ? ListView.builder(
                  itemCount: count,
                  itemBuilder: (BuildContext context, int index) {
                    return noteListTile(context, index);
                  },
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: Text(
                      "No notes yet! Click on Add note to save your notes...",
                      style: TextStyle(
                        fontFamily: "ArchitectsDaughter",
                        color: Colors.white,
                        fontSize: 18,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}