import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:trainshop/controller/controller.dart';
import 'package:trainshop/controller/network/network.dart';
import 'package:trainshop/view/common/custom_dialogue.dart';

class EditProduct extends StatefulWidget {
  final String productid;
  final Controller controller;
  const EditProduct({
    Key? key,
    required this.productid,
    required this.controller,
  }) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  String category = '';
  Map<String, dynamic> productInfo = {};
  Future<int>? fetchstatus;
  Uint8List? imagebytes;
  String? filename;
  Future<dynamic>? imagedata;
  bool isDeletedNewImage = false;
  bool isDeletedOldImage = false;

  List<String> productCategory = <String>[
    'Snaks',
    'Drinks',
    'Fruits',
    'Dry Food',
    'Meals',
  ];

//Select Product Image
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
      isDeletedNewImage == false;
      return 200;
    } else {
      // User canceled the picker
      print("No image selected");
      return 201;
    }
  }

  //fetch product Image

  /* -------------------------- get image from server ------------------------- */
  Future<dynamic> getImage() async {
    var res = await getimage(
      url: 'getproductimage/${widget.productid}',
    );
    if (res.statusCode == 200) {
      //print(res.bodyBytes);
      return res.bodyBytes;
    } else {
      return null;
    }
  }

  //get single products from database
  Future<int> getsingleproduct() async {
    int statusCode = 0;
    await getdata(
      x: 'getsingleproduct/${widget.productid}',
      jwt: widget.controller.appStates.jwt.value,
    ).then((res) {
      if (res.statusCode == 200) {
        productInfo = jsonDecode(res.body);
        print(productInfo);
        nameController.text = productInfo['name'];
        descriptionController.text = productInfo['description'];
        priceController.text = productInfo['price'].toString();
        stockController.text = productInfo['stock'].toString();
        category = productInfo['category'];
        statusCode = res.statusCode;
      } else {
        statusCode = res.statusCode;
      }
    });
    return statusCode;
  }

  //Update Product
  Future<int> updateproduct() async {
    int status = 0;
    Map<String, String> productInfo = <String, String>{
      "productName": nameController.text,
      'productDescription': descriptionController.text,
      'productPrice': priceController.text,
      'productStock': stockController.text,
      'productCategory': category,
      'productid': widget.productid,
    };

    if (imagebytes != null) {
      await uploadimage(
              url: 'updateProductChangeImage',
              jwt: widget.controller.appStates.jwt.value,
              imageBytes: imagebytes,
              fileName: filename,
              body: productInfo)
          .then((res) {
        if (res.statusCode == 200) {
          status = 200;
        } else {
          status = 500;
        }
      });
    } else {
      if (isDeletedOldImage) {
        //Write code to delete image
        await postdata(
          x: 'updateProductDeleteImage',
          jwt: widget.controller.appStates.jwt.value,
          body: productInfo,
        ).then((res) {
          if (res.statusCode == 200) {
            status = 200;
          } else {
            status = 500;
          }
        });
      } else {
        await postdata(
          x: 'updateOnlyProductInformation',
          jwt: widget.controller.appStates.jwt.value,
          body: productInfo,
        ).then((res) {
          if (res.statusCode == 200) {
            status = 200;
          } else {
            status = 500;
          }
        });
      }
    }
    return status;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    fetchstatus = getsingleproduct();
    imagedata = getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
      ),
      body: FutureBuilder<int>(
          future: fetchstatus,
          builder: (context, snapshot) {
            if (snapshot.data == 200) {
              return Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 30,
                          horizontal: 30,
                        ),
                        width: 700,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          //Main column
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: nameController,
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
                                label: Text('Product Name'),
                                //fillColor: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: descriptionController,
                              maxLength: 300,
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
                            TextFormField(
                              controller: priceController,
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
                                label: Text('Product Price'),
                                //fillColor: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: stockController,
                              maxLength: 100,
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
                            Container(
                              //height: 50,
                              //padding: const EdgeInsets.symmetric(horizontal: 20),
                              width: double.infinity,
                              // decoration: const BoxDecoration(
                              //   color: Colors.white,
                              //   // borderRadius: BorderRadius.all(
                              //   //   Radius.circular(5),
                              //   // ),
                              // ),
                              //margin: const EdgeInsets.only(left: 10),

                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  filled: true,
                                  constraints: BoxConstraints(
                                    maxHeight: 50,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
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
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                items: productCategory
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                            //Image Select Button
                            SizedBox(
                              width: double.infinity,
                              //height: 50,
                              child:
                                  StatefulBuilder(builder: (context, refresh) {
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
                                          ? isDeletedOldImage
                                              ? Image.asset(
                                                  'assets/images/blank_profile.png',
                                                  width: 100,
                                                  height: 80,
                                                  fit: BoxFit.contain,
                                                )
                                              : FutureBuilder<dynamic>(
                                                  future: imagedata,
                                                  builder: (context, snapshot) {
                                                    if (snapshot.data != null) {
                                                      return Image.memory(
                                                        snapshot.data,
                                                        width: 100,
                                                        height: 80,
                                                        fit: BoxFit.contain,
                                                      );
                                                    } else {
                                                      return Image.asset(
                                                        'assets/images/blank_profile.png',
                                                        width: 100,
                                                        height: 80,
                                                        fit: BoxFit.contain,
                                                      );
                                                    }
                                                  },
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
                                      height: 10,
                                    ),
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
                                          child: Text("Change Image"),
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
                                    if (imagebytes != null || imagedata != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: MaterialButton(
                                          onPressed: () {
                                            if (imagebytes != null) {
                                              imagebytes = null;
                                              isDeletedNewImage = true;
                                            } else {
                                              imagedata = null;
                                              isDeletedOldImage = true;
                                            }
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
                            const Divider(
                              height: 20,
                              //color: Colors.grey,
                            ),
                            //Send Button
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: Wrap(
                                alignment: WrapAlignment.end,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  MaterialButton(
                                    onPressed: () {
                                      showDialog<void>(
                                          context: context,
                                          //barrierDismissible: false, // user must tap button!
                                          builder: (BuildContext context) {
                                            return Dialogue(
                                              alertmessage:
                                                  "Do you want to update?",
                                              successmessage:
                                                  "Product Updated Successfully",
                                              errormessage:
                                                  "Update Failed! Try again later!.",
                                              accept: updateproduct,
                                              reject: () {
                                                Navigator.pop(context);
                                              },
                                              back: () {
                                                Navigator.pop(context);
                                              },
                                            );
                                          });
                                    },
                                    color: Colors.yellow,
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      child: Text("Update product"),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: MaterialButton(
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
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text("Data Fetching..."),
              );
            } else {
              return const Center(
                child: Text("Something goes wrong!"),
              );
            }
          }),
    );
  }
}
