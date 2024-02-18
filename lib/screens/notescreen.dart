import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({
    super.key,
    this.noteUpdate = true,
    required this.noteItemTime,
    required this.noteItemSubject,
    required this.noteItemContent,
    required this.noteItemID,
  });
  final DateTime noteItemTime;
  final String noteItemSubject;
  final String noteItemContent;
  final String noteItemID;
  final bool noteUpdate;
  @override
  State<StatefulWidget> createState() {
    return _NoteScreenState();
  }
}

class _NoteScreenState extends State<NoteScreen> {
  dynamic _deviceHeigh;
  dynamic _deviceWidth;
  DateTime _selectedDate = DateTime.now();

  dynamic _subject;
  dynamic _content;
  dynamic _isUpdate;
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _contentController = TextEditingController();
  void _saveItem() {
    // print('hello');
    _formKey.currentState!.validate();
  }

  void _resetItem() {
    _formKey.currentState!.reset();
  }

  _saveButton(BuildContext context) {
    print('on tapped save button!');

    // _saveItem();
    if (_formKey.currentState!.validate()) {
      _subjectController.clear();
      _contentController.clear();
      if (widget.noteItemID == '') {
        try {
          FirebaseFirestore.instance.collection("DayNote").add({
            'createAt': Timestamp.now(),
            'subject': _subject,
            'content': _content,
          });
        } catch (e) {
          print(e.toString());
        }
      } else {
        FirebaseFirestore.instance
            .collection("DayNote")
            .doc(widget.noteItemID)
            .update({
          'subject': _subject,
          'content': _content,
        });
      }

      Navigator.of(context).pop();
    }
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 10, now.month, now.day);
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDate = widget.noteItemTime;
    _subject = widget.noteItemSubject;
    _content = widget.noteItemContent;
    print("content: " + _content);
    print("subject: " + _subject);
    if (_subject != '') {
      _isUpdate = true;
    } else {
      _isUpdate = false;
    }

    _contentController.text = _content;
    _subjectController.text = _subject;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('Goi ham dispose!');
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeigh = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    Widget navbar;
    if (widget.noteUpdate == false) {
      navbar = _navbarCreateWidget();
    } else if (_isUpdate == true) {
      navbar = _navbarUpdateWidget();
    } else {
      navbar = _navbarCreateWidget();
    }
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _background(),
          navbar,
          Positioned(
            top: _deviceHeigh * 0.04,
            child: _tableCalender(),
          ),
          Positioned(
            top: _deviceHeigh * 0.1,
            child: _noteInputForm(),
          ),
          _bottomLayerWidget(),
        ],
      ),
    );
  }

  Widget _background() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: _deviceHeigh,
        width: _deviceWidth,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromRGBO(12, 29, 60, 1),
          Color.fromRGBO(12, 29, 60, 1),
        ], stops: [
          0.4,
          1
        ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
      ),
    );
  }

  Widget _navbarCreateWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(_deviceWidth * 0.03, _deviceHeigh * 0.03,
          _deviceWidth * 0.03, _deviceHeigh * 0.03),
      // child: SizedBox(
      //   height: _deviceHeigh * 0.03,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.close,
              size: 20,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Row(
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              TextButton(
                  onPressed: () {
                    _saveButton(context);
                  },
                  child: const Text('Lưu'))
            ],
          )
        ],
        // ),
      ),
    );
  }

  Widget _navbarUpdateWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(_deviceWidth * 0.03, _deviceHeigh * 0.03,
          _deviceWidth * 0.03, _deviceHeigh * 0.03),
      // child: SizedBox(
      //   height: _deviceHeigh * 0.03,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.close,
              size: 20,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Row(
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => NoteScreen(
                        noteUpdate: false,
                        noteItemContent: _content,
                        noteItemSubject: _subject,
                        noteItemTime: widget.noteItemTime,
                        noteItemID: widget.noteItemID,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.create_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Lưu'))
            ],
          )
        ],
        // ),
      ),
    );
  }

  Widget _tableCalender() {
    return Padding(
      padding: EdgeInsets.all(_deviceHeigh * 0.03),
      child: SizedBox(
          height: _deviceHeigh * 0.06,
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextButton(
                  onPressed: _presentDatePicker,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${_selectedDate.day}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            shadows: [
                              Shadow(
                                color: Color.fromARGB(255, 255, 3, 7),
                                offset: Offset(1.0,
                                    1.0), // Điều chỉnh vị trí đổ bóng (dx, dy)
                                blurRadius: 5.0, // Điều chỉnh độ mờ
                              ),
                            ],
                            decoration:
                                TextDecoration.underline, // Thêm gạch dưới
                            decorationColor: Color.fromARGB(
                                90, 150, 206, 249), // Màu của gạch dưới
                            decorationThickness: 3.0, // Độ dày của gạch dưới
                          ),
                        ),
                        TextSpan(
                          text:
                              'Th${_selectedDate.month}  ${_selectedDate.year}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        const WidgetSpan(
                          child: Padding(
                            padding: EdgeInsets.only(
                                right:
                                    4.0), // Điều chỉnh khoảng cách giữa icon và văn bản
                            child: Icon(
                              Icons
                                  .expand_circle_down, // Chọn biểu tượng mà bạn muốn sử dụng
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          )),
    );
  }

  Widget _bottomLayerWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _deviceHeigh * 0.03,
        vertical: _deviceWidth * 0.02,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _bottomBarWidget(),
        ],
      ),
    );
  }

  Widget _bottomBarWidget() {
    return Container(
      height: _deviceHeigh * 0.06,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 2, 72, 118),
      ),
      child: SizedBox(
        height: _deviceHeigh * 0.04,
        child: const Row(children: <Widget>[
          Icon(
            Icons.image,
            size: 20,
            color: Colors.white,
          )
        ]),
      ),
    );
  }

  Widget _noteInputForm() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, _deviceWidth * 0.09),
      child: SizedBox(
        width: _deviceWidth * 0.95,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                enabled: !(_isUpdate == true && widget.noteUpdate == true),
                controller: _subjectController,
                decoration: const InputDecoration(
                    fillColor: Colors.white,
                    hintText: 'Tiêu đề',
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 227, 245, 137))),
                style: const TextStyle(
                    color: Color.fromARGB(255, 227, 245, 137), fontSize: 20),
                validator: (value) {
                  // print('hello1');

                  if (value == null || value.isEmpty) {
                    // print('hello3');

                    return "Subject does not null!";
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  _subject = value;
                },
              ),
              TextFormField(
                enabled: !(_isUpdate == true && widget.noteUpdate == true),
                controller: _contentController,
                maxLines: 15, // Đặt số dòng cho TextArea (ví dụ: 3 dòng)
                decoration: const InputDecoration(
                    fillColor: Colors.white,
                    hintText: 'Hãy viết một thứ gì đó...',
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 227, 245, 137))),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  // print('hello2');
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 10) {
                    // print('hello4');

                    return "Must be at least 20 characters";
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  _content = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
