import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> todo = ['社課簡報', '論文筆記'];
  List<String> processing = ['進度報告'];
  List<String> finished = ['社課範例', '產學合作'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              CardListBody(
                title: '待辦事項',
                list: todo,
                onAddPressed: () {
                  setState(() {
                    showInputDialog((text) {
                      setState(() {
                        todo.add(text);
                      });
                    });
                  });
                },
                onDragCompleted: (index) {
                  setState(() {
                    todo.removeAt(index);
                  });
                },
                onAccept: (String data) {
                  setState(() {
                    todo.add('$data');
                  });
                },
              ),
              CardListBody(
                title: '進行中',
                list: processing,
                onAddPressed: () {
                  showInputDialog((text) {
                    setState(() {
                      processing.add(text);
                    });
                  });
                },
                onDragCompleted: (index) {
                  setState(() {
                    processing.removeAt(index);
                  });
                },
                onAccept: (String data) {
                  setState(() {
                    processing.add('$data');
                  });
                },
              ),
              CardListBody(
                title: '已完成',
                list: finished,
                onAddPressed: () {
                  showInputDialog((text) {
                    setState(() {
                      finished.add(text);
                    });
                  });
                },
                onDragCompleted: (index) {
                  setState(() {
                    finished.removeAt(index);
                  });
                },
                onAccept: (String data) {
                  setState(() {
                    finished.add('$data');
                  });
                },
              ),
            ],
          ),
        ),
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  showInputDialog(Function onCompleted) {
    showDialog(
      context: context,
      builder: (_) {
        return InputDialog(
          controller: TextEditingController(),
          onCompleted: onCompleted,
        );
      },
    );
  }
}

class InputDialog extends StatelessWidget {
  final TextEditingController controller;
  final Function onCompleted;

  const InputDialog({Key key, this.onCompleted, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            onCompleted(controller.text);
          },
        )
      ],
    );
  }
}

class CardListBody extends StatelessWidget {
  final String title;
  final List<String> list;
  final Function onAddPressed;
  final Function onDragCompleted;
  final Function onAccept;

  const CardListBody({
    Key key,
    this.title,
    this.list,
    this.onAddPressed,
    this.onDragCompleted,
    this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: DragTarget(
        builder: (context, data, rejectData) {
          return Card(
            child: Column(
              children: <Widget>[
                CardListTitle(text: title),
                CardListContent(
                  list: list,
                  onDragCompleted: onDragCompleted,
                ),
                CardListAddButton(
                  text: '新增卡片',
                  onPressed: onAddPressed,
                ),
              ],
            ),
          );
        },
        onAccept: (String data) {
          onAccept(data);
        },
      ),
    );
  }
}

class CardListTitle extends StatelessWidget {
  final String text;

  const CardListTitle({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Text(text),
        width: double.infinity,
        alignment: Alignment(0, 0),
        padding: EdgeInsets.symmetric(vertical: 8),
      ),
      margin: EdgeInsets.all(0),
    );
  }
}

class CardListContent extends StatelessWidget {
  final List<String> list;
  final Function onDragCompleted;

  const CardListContent({Key key, this.list, this.onDragCompleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.grey[300],
        padding: EdgeInsets.all(4.0),
        child: ListView.builder(
          itemBuilder: (_, index) {
            return ItemCard(
              index: index,
              text: list[index],
              onDragCompleted: () {
                onDragCompleted(index);
              },
            );
          },
          itemCount: list.length,
        ),
      ),
    );
  }
}

class CardListAddButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const CardListAddButton({Key key, this.text, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: FlatButton(
          onPressed: onPressed,
          child: Text(text),
        ),
        width: double.infinity,
        alignment: Alignment(0, 0),
        padding: EdgeInsets.symmetric(vertical: 8),
      ),
      margin: EdgeInsets.all(0),
    );
  }
}

class ItemCard extends StatelessWidget {
  final int index;
  final String text;
  final Function onDragCompleted;

  const ItemCard({Key key, this.index, this.text, this.onDragCompleted})
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
        width: MediaQuery.of(context).size.width * 0.4,
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
