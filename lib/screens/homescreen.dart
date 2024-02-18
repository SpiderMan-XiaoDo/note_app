import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/screens/notescreen.dart';
import 'package:note_app/widgets/homedrawerwidget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic _deviceHeigh;
  dynamic _deviceWidth;
  dynamic _dateTime;
  bool isTappedDrawerHeader = false;
  List<dynamic> _noteWidgets = [];
  List<Widget> noteWigetList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Init state!');
    _loadDayNote();
  }

  Widget _noteItem(noteItemTime, noteItemSubject, noteItemContent, noteItemID) {
    return Padding(
      padding:
          EdgeInsets.fromLTRB(_deviceWidth * 0.05, 0, _deviceWidth * 0.05, 0),
      child: GestureDetector(
        onTap: () {
          _newNoteScreen(context, noteItemTime, noteItemContent,
              noteItemSubject, noteItemID);
          print('Note Item: ' + noteItemID);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: const Color.fromARGB(207, 43, 85, 122),
          ),
          height: _deviceHeigh * 0.12,
          width: _deviceWidth * 0.9,
          child: Column(children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${noteItemTime.day}',
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
                            decorationThickness: 3.0,
                            // Độ dày của gạch dưới
                          ),
                        ),
                        TextSpan(
                          text: 'Th${noteItemTime.month}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        WidgetSpan(
                          child: SizedBox(
                            // height: _deviceHeigh * 0.03,
                            width: _deviceWidth * 0.03,
                          ),
                        ),
                        // const TextSpan(
                        //   text: 'Bản Nháp',
                        //   style: TextStyle(
                        //     color: Color.fromARGB(151, 236, 233, 233),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                // Text('${DateTime.now().day} th ${DateTime.now().month}'),
              ],
            ),
            Text(
              noteItemSubject,
              style: const TextStyle(
                color: Color.fromARGB(222, 248, 246, 246),
                fontSize: 18,
              ),
            ),
            Text(
              noteItemContent,
              style: const TextStyle(
                color: Color.fromARGB(222, 248, 246, 246),
                fontSize: 12,
              ),
            )
          ]),
        ),
      ),
    );
  }

  void _loadDayNote() async {
    try {
      CollectionReference dayNoteCollection =
          FirebaseFirestore.instance.collection('DayNote');
      QuerySnapshot querySnapshot = await dayNoteCollection.get();
      print("start loadDayNote!");

      _noteWidgets = [];
      noteWigetList = [];
      querySnapshot.docs.forEach((element) {
        Map<String, dynamic> item = element.data() as Map<String, dynamic>;
        print(item);
        dynamic noteDateTime = item['createAt'].toDate();
        dynamic subject = item['subject'];
        print('element: ' + element.id);
        dynamic content = item['content'];
        dynamic noteID = element.id;

        _noteWidgets.add(_noteItem(noteDateTime, subject, content, noteID));
        _noteWidgets.add(const SizedBox(height: 8));
      });
      print(_noteWidgets.runtimeType);
      setState(() {
        _noteWidgets.forEach((item) {
          // Xử lý và chuyển đổi từng phần tử sang Widget
          Widget widget =
              item; // Thay 'YourWidget' bằng widget bạn muốn tạo từ phần tử đó
          noteWigetList.add(widget); // Thêm widget vào danh sách
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _newNoteScreen(BuildContext context, noteItemTime, noteItemContent,
      noteItemSubject, noteItemID) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => NoteScreen(
          noteItemContent: noteItemContent,
          noteItemSubject: noteItemSubject,
          noteItemTime: noteItemTime,
          noteItemID: noteItemID,
          // noteItemID: '',
        ),
      ),
    );
    print('new note screen!');
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeigh = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    // TODO: implement build
    _dateTime = DateTime.now();
    int currentYear = _dateTime.year;
    noteWigetList = [];
    print("hello");
    if (_noteWidgets.length == 0) {
      _loadDayNote();
    }
    setState(() {
      _noteWidgets.forEach((item) {
        // Xử lý và chuyển đổi từng phần tử sang Widget
        Widget widget =
            item; // Thay 'YourWidget' bằng widget bạn muốn tạo từ phần tử đó
        noteWigetList.add(widget);
        _noteWidgets = []; // Thêm widget vào danh sách
      });
    });
    return Scaffold(
        drawer: HomeDrawer(),
        body: Stack(
          children: <Widget>[
            _homePageHeader(),
            _gradientBackground(),
            _topLayerWidget(),
            Positioned(
              top: _deviceHeigh * 0.25,
              left: _deviceWidth * 0.05,
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '$currentYear',
                  style: const TextStyle(
                    color: Color.fromARGB(251, 227, 233, 230),
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Positioned(
                top: _deviceHeigh * 0.3,
                height: _deviceHeigh * 0.6,
                width: _deviceWidth * 0.98,
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: noteWigetList,
                )),
            _bottomLayerWidget(),
          ],
        ));
  }

  Widget _homePageHeader() {
    return SizedBox(
      height: _deviceHeigh * 0.4,
      width: _deviceWidth,
      child: Container(
        decoration: const BoxDecoration(
          // borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage('assets/image/background_image.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _gradientBackground() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: _deviceHeigh * 0.6,
        width: _deviceWidth,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromRGBO(8, 19, 39, 1),
          Color.fromRGBO(8, 19, 39, 0.8)
        ], stops: [
          0.4,
          1
        ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
      ),
    );
  }

  Widget _topLayerWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.03,
        vertical: _deviceHeigh * 0.05,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _topBarWidget(),
        ],
      ),
    );
  }

  Widget _topBarWidget() {
    return SizedBox(
      height: _deviceHeigh * 0.05,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Builder(builder: (BuildContext context) {
            return InkWell(
              onTap: () {
                setState(() {
                  // Đảo ngược giá trị trạng thái khi chạm vào
                  isTappedDrawerHeader = !isTappedDrawerHeader;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                  color: isTappedDrawerHeader
                      ? const Color.fromARGB(132, 158, 158, 158)
                      : const Color.fromARGB(132, 158, 158,
                          158), // Thay đổi màu dựa trên trạng thái
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            );
          }),
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        132, 158, 158, 158), // Thay đổi màu dựa trên trạng thái
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: _deviceWidth * 0.03,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        132, 158, 158, 158), // Thay đổi màu dựa trên trạng thái
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _bottomLayerWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.03,
        vertical: _deviceHeigh * 0.03,
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
    return SizedBox(
      height: _deviceHeigh * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                // Thay đổi màu dựa trên trạng thái
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                    132, 158, 158, 158), // Thay đổi màu dựa trên trạng thái
                borderRadius: BorderRadius.circular(100),
              ),
              child: IconButton(
                onPressed: () {
                  // _loadDayNote();
                  _newNoteScreen(context, DateTime.now(), "", "", "");
                  print('tapped add icon!');
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                    132, 158, 158, 158), // Thay đổi màu dựa trên trạng thái
                borderRadius: BorderRadius.circular(100),
              ),
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
