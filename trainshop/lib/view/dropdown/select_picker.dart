import 'package:flutter/material.dart';

class SelectPicker extends StatefulWidget {
  final List<Map<String, dynamic>> itemlist;
  final String? initialValue;
  final String label;
  final Function onChanged;
  final bool? enabled;
  const SelectPicker({
    Key? key,
     this.initialValue,
    required this.label,
    required this.onChanged,
    required this.itemlist,
    this.enabled,
  }) : super(key: key);

  @override
  _SelectPickerState createState() => _SelectPickerState();
}

class _SelectPickerState extends State<SelectPicker> {
  final TextEditingController _selectedValueController =
      TextEditingController();

  @override
  void initState() {
    _selectedValueController.text = widget.initialValue ?? '';
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _selectedValueController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: _selectedValueController,
      maxLength: 100,
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.expand_more_outlined),
        //hoverColor: Colors.white,
        counter: const SizedBox(),
        //isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 10,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        filled: true,
        label: Text(widget.label),
        //fillColor: Colors.white,
      ),
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
                  selectitems: widget.itemlist,
                  onSelected: (name, value) {
                    _selectedValueController.text = name;
                    widget.onChanged(name, value);
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
  final List<Map<String, dynamic>> selectitems;
  final Function onSelected;
  const SelectOptions({
    Key? key,
    required this.selectitems,
    required this.onSelected,
  }) : super(key: key);

  @override
  _SelectOptionsState createState() => _SelectOptionsState();
}

class _SelectOptionsState extends State<SelectOptions> {
  @override
  void initState() {
    //fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.selectitems);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.selectitems.length,
      itemBuilder: (context, index) {
        // print('index : $index');
        return ListTile(
          onTap: () {
            widget.onSelected(
              widget.selectitems[index]['name'],
              widget.selectitems[index]['value'],
            );
            Navigator.pop(context);
          },
          dense: true,
          title: Text(widget.selectitems[index]['name']),
        );
      },
    );
  }
}
