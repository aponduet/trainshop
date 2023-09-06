import 'package:flutter/material.dart';

class Dialogue extends StatefulWidget {
  //final String? title;
  final String? alertmessage;
  final String? successmessage;
  final String? errormessage;
  final Function? accept; //Future function cal be used normally
  final Function? back;
  final Function? reject;

  const Dialogue({
    Key? key,
    //this.title,
    this.alertmessage,
    this.successmessage,
    this.errormessage,
    this.accept,
    this.back,
    this.reject,
  }) : super(key: key);

  @override
  State<Dialogue> createState() => _DialogueState();
}

class _DialogueState extends State<Dialogue> {
  bool isShowAlert = true;

  @override
  Widget build(BuildContext context) {
    if (isShowAlert) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.all(30),
        // title: Text(
        //   title ?? '',
        //   textAlign: TextAlign.center,
        //   style: const TextStyle(color: Colors.red),
        // ),
        content: SizedBox(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.alertmessage ?? 'Are you Sure?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              //Text('Would you like to approve of this message?'),
            ],
          ),
        ),
        actions: <Widget>[
          if (widget.reject != null)
            TextButton(
              child: const Text('No'),
              onPressed: () {
                //widget.reject!();
                Navigator.pop(context);
              },
            ),
          MaterialButton(
            color: Colors.green,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text('Yes'),
            ),
            onPressed: () {
              //widget.accept!();
              setState(() {
                isShowAlert = false;
              });
            },
          ),
        ],
      );
    } else {
      return FutureBuilder(
        //future: null,
        future: widget.accept!(),
        builder: (context, snapshot) {
          if (snapshot.data == 200) {
            return AlertDialog(
              //title: const Text('Delete station!'),
              contentPadding: const EdgeInsets.all(20),
              actionsPadding: const EdgeInsets.all(30),
              actionsAlignment: MainAxisAlignment.center,
              content: Container(
                // constraints: const BoxConstraints(
                //   maxHeight: 500,
                //   maxWidth: 600,
                //   minWidth: 300,
                //   minHeight: 100,
                // ),
                height: 100,
                //width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.successmessage ?? 'Successfull',
                      //overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //Text('Would you like to approve of this message?'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Back'),
                  onPressed: () {
                    //close the popup menu
                    //Navigator.of(context).pop();
                    //Go back to previous page

                    Navigator.pop(context);
                    widget.back!();
                  },
                ),
                MaterialButton(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                  color: Colors.yellow,
                  child: const Text('Continue'),
                  onPressed: () async {
                    Navigator.pop(context);
                    // resetProductInfo();
                  },
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return AlertDialog(
              //title: const Text('Delete station!'),
              content: SizedBox(
                height: 200,
                //swidth: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Center(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Product Updating...',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //Text('Would you like to approve of this message?'),
                  ],
                ),
              ),
            );
          } else {
            return AlertDialog(
              //title: const Text('Delete station!'),
              //contentPadding: EdgeInsets.all(50),
              actionsPadding: const EdgeInsets.all(30),
              actionsAlignment: MainAxisAlignment.center,
              content: Container(
                // constraints: const BoxConstraints(
                //   maxHeight: 500,
                //   maxWidth: 600,
                //   minWidth: 300,
                //   minHeight: 100,
                // ),
                height: 100,
                //width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.errormessage ?? 'Error found!!',
                      //overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //Text('Would you like to approve of this message?'),
                  ],
                ),
              ),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  hoverElevation: 0,
                  highlightElevation: 0,
                  focusElevation: 0,
                  elevation: 0,
                  color: Colors.green.withOpacity(0.2),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text("Back"),
                  ),
                ),
                // MaterialButton(
                //   // padding: const EdgeInsets.symmetric(
                //   //     vertical: 16, horizontal: 30),
                //   color: Colors.yellow,
                //   child: const Padding(
                //     padding:
                //         EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                //     child: Text('New Product'),
                //   ),
                //   onPressed: () async {
                //     Navigator.pop(context);
                //   },
                // ),
              ],
            );
          }
        },
      );
    }

    // return AlertDialog(
    //   actionsAlignment: MainAxisAlignment.center,
    //   // title: Text(
    //   //   title ?? '',
    //   //   textAlign: TextAlign.center,
    //   //   style: const TextStyle(color: Colors.red),
    //   // ),
    //   content: SingleChildScrollView(
    //     child: ListBody(
    //       children: <Widget>[
    //         Text(
    //           message ?? 'Are you agree?',
    //           textAlign: TextAlign.center,
    //         ),
    //         //Text('Would you like to approve of this message?'),
    //       ],
    //     ),
    //   ),
    //   actions: <Widget>[
    //     if (reject != null)
    //       TextButton(
    //         child: const Text('Cencel'),
    //         onPressed: () {
    //           reject!();
    //         },
    //       ),
    //     MaterialButton(
    //       color: Colors.green,
    //       child: const Padding(
    //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    //         child: Text('OK'),
    //       ),
    //       onPressed: () {
    //         accept!();
    //       },
    //     ),
    //   ],
    // );
  }
}
