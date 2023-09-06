import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:trainshop/controller/controller.dart';
import 'package:trainshop/controller/localstorage.dart';
import 'package:trainshop/controller/network/network.dart';
import 'package:trainshop/view/common/custom_dialogue.dart';

class Addproduct extends StatefulWidget {
  final Controller controller;
  const Addproduct({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _AddproductState createState() => _AddproductState();
}

class _AddproductState extends State<Addproduct> {
  final TextEditingController _productName = TextEditingController();
  final TextEditingController _productDescription = TextEditingController();
  final TextEditingController _productPrice = TextEditingController();
  final TextEditingController _productStock = TextEditingController();
  Uint8List? imagebytes;
  String? filename;
  List<String> productCategory = <String>[
    'Snaks',
    'Drinks',
    'Fruits',
    'Meals',
    'Dry foods'
  ];
  String category = 'Snaks';

  //Add Product
  Future<int> addproduct() async {
    int status;
    Map<String, String> productInfo = <String, String>{
      "productName": _productName.text,
      'productDescription': _productDescription.text,
      'productPrice': _productPrice.text,
      'productStock': _productStock.text,
      'productCategory': category,
      'shopid': widget.controller.appStates.userid.value,
    };
    //print(productInfo);
    dynamic response = await postdata(
      x: 'addproduct',
      jwt: widget.controller.appStates.jwt.value,
      body: productInfo,
    );

    if (response.statusCode == 200) {
      dynamic responsebody = jsonDecode(response.body);
      if (imagebytes != null) {
        //Upload Product Image Now
        dynamic result = await uploadimage(
          url: 'uploadproductimage',
          jwt: widget.controller.appStates.jwt.value,
          imageBytes: imagebytes,
          fileName: filename,
          body: <String, String>{
            'productid': responsebody['_id'],
          },
        );
        status = result.statusCode;
      } else {
        status = response.statusCode;
      }
      print('Image Upload Status : $status');
    } else {
      if (response.statusCode == 203) {
        //logout if invalid / Expired token or User not found
        LocalStorage.logoutHandler(widget.controller);
        status = response.statusCode;
      } else {
        status = response.statusCode;
      }
    }
    return status;
  }

  /* ------------------ Upload Single Product Image so Server ----------------- */

  Future<int> selectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      //use withData: true, If null is returned in desktop ,
      //follow https://github.com/miguelpruivo/flutter_file_picker/issues/817
      type: FileType.image,
      //allowedExtensions: ['jpg', 'pdf', 'doc'],
    );
    if (result != null) {
      //imagePath = result.files.single.path;
      imagebytes = result.files.single.bytes;
      filename = result.files.single.name;
      return 200;
    } else {
      // User canceled the picker
      print("No image selected");
      return 201;
    }
  }

  //Go back to Product page
  goback() {
    Navigator.pop(context);
  }

  resetProductInfo() {
    _productName.text = "";
    _productDescription.text = "";
    _productPrice.text = "";
    _productStock.text = "";
    category = "Drinks";
    imagebytes = null;
    filename = null;
    setState(() {});
  }

  //Add Product

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: Center(
        child: Card(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 30,
            ),
            width: 700,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //Main column
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    /* -------------------------- //Inpur Product Name -------------------------- */
                    TextFormField(
                      controller: _productName,
                      maxLength: 100,
                      decoration: const InputDecoration(
                        counter: SizedBox(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 10,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        filled: true,
                        label: Text('Product Name'),
                        //fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    /* -------------------------- //Product Description ------------------------- */
                    TextFormField(
                      controller: _productDescription,
                      maxLength: 100,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        //hoverColor: Colors.white,
                        counter: SizedBox(),
                        //isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 10,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        filled: true,
                        label: Text('Product Description'),
                        //fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    /* ----------------------------- //Product Price ---------------------------- */
                    TextFormField(
                      controller: _productPrice,
                      maxLength: 100,
                      // keyboardType: TextInputType.multiline,
                      // maxLines: null,
                      decoration: const InputDecoration(
                        //hoverColor: Colors.white,
                        counter: SizedBox(),
                        //isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 10,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        filled: true,
                        label: Text('Product Price'),
                        //fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    /* ---------------------------- //Product Stocks ---------------------------- */
                    TextFormField(
                      controller: _productStock,
                      maxLength: 100,
                      keyboardType: TextInputType.number,
                      // maxLines: null,
                      decoration: const InputDecoration(
                        //hoverColor: Colors.white,
                        counter: SizedBox(),
                        //isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 10,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        filled: true,
                        label: Text('Product Stock'),
                        //fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    /* -------------------------- //Product Categories -------------------------- */
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        filled: true,
                        constraints: BoxConstraints(maxHeight: 50),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                      ),
                      iconEnabledColor: Colors.grey,
                      //dropdownColor: Colors.white,
                      elevation: 0,
                      value: category,
                      isExpanded: true,
                      onChanged: (String? value) {
                        setState(() {
                          category = value!;
                        });
                      },
                      // style: const TextStyle(
                      //   color: Colors.grey,
                      //   fontSize: 16,
                      // ),
                      items: productCategory
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    //Image Select Button
                    SizedBox(
                      width: double.infinity,
                      //height: 50,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: StatefulBuilder(builder: (context, refresh) {
                          return Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: imagebytes == null
                                    ? Image.asset(
                                        'assets/images/blank_profile.png',
                                        width: 100,
                                        height: 80,
                                        fit: BoxFit.contain,
                                      )
                                    : Image.memory(
                                        imagebytes!,
                                        width: 100,
                                        height: 80,
                                        fit: BoxFit.contain,
                                      ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              // Expanded(
                              //   child: Container(
                              //     padding: const EdgeInsets.symmetric(
                              //         horizontal: 20, vertical: 5),
                              //     decoration: BoxDecoration(
                              //       //color: Colors.white,
                              //       border: Border.all(
                              //           color: Colors.grey.withOpacity(0.5)),
                              //       borderRadius: BorderRadius.all(
                              //         Radius.circular(5),
                              //       ),
                              //     ),
                              //     width: double.infinity,
                              //     height: 50,
                              //     child: const Text("sohelrana.png"),
                              //   ),
                              // ),
                              // const SizedBox(
                              //   width: 20,
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: MaterialButton(
                                  onPressed: () {
                                    //Navigator.pop(context);
                                    selectImage().then((res) {
                                      if (res == 200) {
                                        refresh(() => {});
                                      } else {
                                        print(
                                            'I am called before image selecting');
                                      }
                                    });
                                  },
                                  hoverElevation: 0,
                                  highlightElevation: 0,
                                  focusElevation: 0,
                                  elevation: 0,
                                  color: Colors.green.withOpacity(0.2),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Select Image"),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                                height: 10,
                              ),
                              // Expanded(
                              //   child: Container(
                              //     padding: const EdgeInsets.symmetric(
                              //         horizontal: 20, vertical: 5),
                              //     decoration: BoxDecoration(
                              //       //color: Colors.white,
                              //       border: Border.all(
                              //           color: Colors.grey.withOpacity(0.5)),
                              //       borderRadius: BorderRadius.all(
                              //         Radius.circular(5),
                              //       ),
                              //     ),
                              //     width: double.infinity,
                              //     height: 50,
                              //     child: const Text("sohelrana.png"),
                              //   ),
                              // ),
                              // const SizedBox(
                              //   width: 20,
                              // ),
                              if (imagebytes != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: MaterialButton(
                                    onPressed: () {
                                      imagebytes = null;
                                      //Navigator.pop(context);
                                      refresh(() => {});
                                    },
                                    hoverElevation: 0,
                                    highlightElevation: 0,
                                    focusElevation: 0,
                                    elevation: 0,
                                    color: Colors.green.withOpacity(0.2),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Delete"),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }),
                      ),
                    ),
                    const Divider(
                      height: 20,
                      //color: Colors.grey,
                    ),
                    //Send Button
                    SizedBox(
                      width: double.infinity,
                      //height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text("Cancel"),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          MaterialButton(
                            onPressed: () {
                              //addproduct();
                              //statusDialogue();
                              showDialog<void>(
                                  context: context,
                                  //barrierDismissible: false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return Dialogue(
                                      alertmessage: "Do you want to Add?",
                                      successmessage:
                                          "Product Added Successfully",
                                      errormessage:
                                          "Failed to Add new Product!.",
                                      accept: addproduct,
                                      reject: () {
                                        Navigator.pop(context);
                                      },
                                      back: () {
                                        Navigator.pop(context);
                                      },
                                    );
                                  });
                            },
                            color: Colors.green,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Text("Add Product"),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
