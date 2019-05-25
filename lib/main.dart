import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
void main() {  
  // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
  if(Platform.isWindows)
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> todo = ['社課簡報', '論文筆記'];
  List<String> processing = ['進度報告'];
  List<String> finished = ['社課範例', '產學合作'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              CardListBody(
                title: '待辦事項',
                list: todo,
              ),
              CardListBody(
                title: '進行中',
                list: processing,
              ),
              CardListBody(
                title: '已完成',
                list: finished,
              ),
            ],
          ),
        ),
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class CardListBody extends StatefulWidget {
  final String title;
  final List<String> list;

  const CardListBody({Key key, this.title, this.list}) : super(key: key);

  @override
  _CardListBodyState createState() => _CardListBodyState();
}

class _CardListBodyState extends State<CardListBody> {
  TextEditingController controller = TextEditingController();
  double width = 600;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width * 0.6;
    return Container(
      width: width,
      child: DragTarget(
        builder: (context, data, rejectData) {
          return Card(
            child: Column(
              children: <Widget>[
                Container(
                  child: Text(widget.title),
                  alignment: Alignment(0, 0),
                  padding: EdgeInsets.symmetric(vertical: 8),
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey[300],
                    padding: EdgeInsets.all(4.0),
                    child: ListView.builder(
                      itemBuilder: (_, index) {
                        return ItemCard(
                          index: index,
                          text: widget.list[index],
                          onDragCompleted: () {
                            setState(() {
                              widget.list.removeAt(index);
                            });
                          },
                          width: width,
                        );
                      },
                      itemCount: widget.list.length,
                    ),
                  ),
                ),
                InkWell(
                  onTap: _showDialog,
                  child: Container(
                    child: Text('新增卡片'),
                    alignment: Alignment(0, 0),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          );
        },
        onAccept: (String data) {
          setState(() {
            widget.list.add(data);
          });
        },
      ),
    );
  }

  _showDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('請輸入'),
          content: TextField(
            controller: controller,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('完成'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  widget.list.add(controller.text);
                });
              },
            )
          ],
        );
      },
    );
  }
}

class ItemCard extends StatelessWidget {
  final int index;
  final String text;
  final Function onDragCompleted;
  final double width;

  const ItemCard(
      {Key key, this.index, this.text, this.onDragCompleted, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      data: text,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(text),
        ),
      ),
      feedback: Container(
        width: width - 8,
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(text),
          ),
        ),
      ),
      childWhenDragging: Container(),
      onDragCompleted: onDragCompleted,
    );
  }
}
