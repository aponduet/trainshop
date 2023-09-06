import 'package:flutter/material.dart';
import 'package:trainshop/controller/controller.dart';
import 'package:trainshop/controller/network/network.dart';
import 'package:trainshop/view/admin/products/edit_product.dart';

class AdminProductItem extends StatefulWidget {
  final Function deleteCurrentProduct;
  final Map<String, dynamic> productInfo;
  final Controller controller;
  const AdminProductItem({
    Key? key,
    required this.productInfo,
    required this.controller,
    required this.deleteCurrentProduct,
  }) : super(key: key);

  @override
  State<AdminProductItem> createState() => _AdminProductItemState();
}

class _AdminProductItemState extends State<AdminProductItem> {
  Future<dynamic>? imagedata;
  /* -------------------------- get image from server ------------------------- */
  Future<dynamic> getImage() async {
    var res = await getimage(
      url: 'getproductimage/${widget.productInfo['_id']}',
    );
    if (res.statusCode == 200) {
      //print(res.bodyBytes);
      return res.bodyBytes;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    //imagedata = getImage();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              FutureBuilder<dynamic>(
                future: getImage(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Image.memory(
                      snapshot.data,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    );
                  } else {
                    return Image.asset(
                      'assets/images/blank_profile.png',
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    );
                  }
                },
              ),
              // Image.asset(
              //   'assets/images/food_image.jpeg',
              //   width: double.infinity,
              //   height: 150,
              //   fit: BoxFit.cover,
              // ),
              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.1),
                  child: PopupMenuButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        child: ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProduct(
                                  productid: widget.productInfo['_id'],
                                  controller: widget.controller,
                                ),
                              ),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          leading: const Icon(Icons.edit),
                          title: const Text('Edit'),
                        ),
                      ),
                      PopupMenuItem(
                        child: ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            widget.deleteCurrentProduct(
                                widget.productInfo['_id']);
                          },
                          leading: const Icon(Icons.delete),
                          title: const Text('Delete'),
                        ),
                      ),
                      const PopupMenuItem(
                        child: ListTile(
                          leading: Icon(Icons.details),
                          title: Text('Out of Stock'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Text(
              widget.productInfo['name'],
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Text(
              widget.productInfo['description'],
              maxLines: 4,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Price : ${widget.productInfo['price']}',
              style: const TextStyle(
                color: Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Stock : ${widget.productInfo['stock']}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
