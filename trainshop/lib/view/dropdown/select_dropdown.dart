import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trainshop/controller/controller.dart';
import 'package:trainshop/controller/network/network.dart';

class SelectDropDown extends StatefulWidget {
  final bool? filled;
  final Color? filledcolor;
  final EdgeInsetsGeometry? contentpadding;
  final BoxConstraints? constraints;
  final IconData? prefixicon;
  final IconData? suffixicon;
  final Color? suffixIconColor;
  final Color? prefixIconColor;
  final Color? focusBorderColor;
  final Color? bordercolor;
  final double? borderradius;
  final String? label;
  final String? hinstText;
  final String itemname;
  final String url;
  final String? initialValue;
  final Function onChanged;
  final Controller controller;
  final bool? enabled;
  final TextStyle? style;
  const SelectDropDown({
    Key? key,
    this.filled,
    this.filledcolor,
    this.constraints,
    this.contentpadding,
    this.suffixicon,
    this.prefixicon,
    this.suffixIconColor,
    this.prefixIconColor,
    this.focusBorderColor,
    this.bordercolor,
    this.borderradius,
    this.initialValue,
    required this.url,
    this.label,
    this.hinstText,
    required this.itemname,
    required this.onChanged,
    required this.controller,
    this.enabled,
    this.style,
  }) : super(key: key);

  @override
  _SelectDropDownState createState() => _SelectDropDownState();
}

class _SelectDropDownState extends State<SelectDropDown> {
  List<dynamic> selectitems = [];
  Future<int>? _searchStatus;
  final TextEditingController _selectedValueController =
      TextEditingController();
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    _selectedValueController.text = widget.initialValue ?? '';
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _selectedValueController.dispose();
    _inputController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled ?? true,
      readOnly: true,
      //initialValue: 'Bangladesh',
      controller: _selectedValueController,
      maxLength: 100,
      //keyboardType: TextInputType.multiline,
      //maxLines: null,
      decoration: InputDecoration(
        fillColor: widget.filledcolor,
        constraints: widget.constraints,
        prefixIcon: Icon(widget.prefixicon ?? Icons.select_all),
        suffixIcon: const Icon(Icons.expand_more_outlined),
        //hoverColor: Colors.white,
        counter: const SizedBox(),
        //isDense: true,
        contentPadding: widget.contentpadding,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.bordercolor ?? Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderradius ?? 5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.focusBorderColor ?? Colors.blue,
            width: 1,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(widget.borderradius ?? 5),
          ),
        ),
        prefixIconColor: widget.prefixIconColor,
        suffixIconColor: widget.suffixIconColor,
        filled: widget.filled,
        label: widget.label != null ? Text(widget.label!) : null,
        hintText: widget.hinstText,
      ),
      style: widget.style,
      onTap: () {
        //_searchStatus = fetch();
        showDialog<void>(
          context: context,
          barrierDismissible: true, // user must tap button!
          builder: (BuildContext context) {
            print('I am in builder');
            return AlertDialog(
              content: SizedBox(
                height: 500,
                width: 400,
                child: SelectOptions(
                  itemname: widget.itemname,
                  url: widget.url,
                  controller: widget.controller,
                  onSelected: (value, id) {
                    _selectedValueController.text = value;
                    widget.onChanged(value, id);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class SelectOptions extends StatefulWidget {
  final String url;
  final String itemname;
  final Function onSelected;
  final Controller controller;
  const SelectOptions({
    Key? key,
    required this.itemname,
    required this.controller,
    required this.onSelected,
    required this.url,
  }) : super(key: key);

  @override
  _SelectOptionsState createState() => _SelectOptionsState();
}

class _SelectOptionsState extends State<SelectOptions> {
  List<dynamic> selectitems = [];
  Future<int>? _searchStatus;
  final TextEditingController _inputController = TextEditingController();
  String? searchvalue;

  Future<int> fetch() async {
    int status;
    dynamic response = await getdata(
      x: widget.url,
      //x: '${widget.url}/$searchvalue',
      y: _inputController.text,
      jwt: widget.controller.appStates.jwt.value,
    );

    if (response.statusCode == 200) {
      selectitems = jsonDecode(response.body);
      print(jsonDecode(response.body));
      if (selectitems.isNotEmpty) {
        status = 200;
      } else {
        status = 201;
      }
    } else {
      print(response.body);
      status = 201;
      //_searchStatus = response.statusCode;
    }
    return status;
  }

  @override
  void initState() {
    //fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Search item input box
        TextFormField(
          controller: _inputController,
          onChanged: (value) {
            setState(
              () {
                searchvalue = value;
              },
            );
          },
          onEditingComplete: () {
            setState(() {
              searchvalue = _inputController.text;
            });
          },
          autofocus: true,
          decoration: const InputDecoration(
              suffixIcon: Icon(Icons.search_rounded),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 30,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 1,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              filled: true,
              hintText: 'Type item name',
              hintStyle: TextStyle(color: Colors.grey)
              //label: Text('Serach Country'),
              //fillColor: Colors.white,
              ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: FutureBuilder<int>(
              future: fetch(),
              //future: _searchStatus,
              builder: (context, snapshot) {
                print('Hello Sohel');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.data == 200) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: selectitems.length,
                    itemBuilder: (context, index) {
                      // print('index : $index');
                      return ListTile(
                        onTap: () {
                          widget.onSelected(selectitems[index][widget.itemname],
                              selectitems[index]['_id']);
                          // _selectedValueController.text =
                          //     selectitems[index]['${widget.itemname}'];
                          Navigator.pop(context);
                        },
                        dense: true,
                        //leading: Text(selectitems[index]['dialcode']),
                        // title: Text(
                        //   selectitems[index]['${widget.itemname}'],
                        //   style: const TextStyle(
                        //     overflow: TextOverflow.ellipsis,
                        //   ),
                        // ),
                        title: Row(
                          children: [
                            Text(selectitems[index][widget.itemname]),
                            // const SizedBox(
                            //   width: 20,
                            // ),
                            // Text(selectitems[index][widget.itemname]),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text("No Data Found"),
                  );
                }
              }),
        ),
      ],
    );
  }
}
