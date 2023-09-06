import 'package:flutter/material.dart';
import 'package:trainshop/controller/responsive/responsive.dart';

class HorizontalAdItem extends StatelessWidget {
  const HorizontalAdItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Image.asset(
                    'assets/images/food_image.jpeg',
                    width: Responsive.value(
                      Responsive.width(context),
                      MediaQuery.of(context).size.width < 800
                          ? (Responsive.width(context) - 250.0)
                          : (Responsive.width(context) - 350.0),
                      650.0,
                      context,
                    ),
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const Text(
                    "Description : Get 70% Discount offer on every product, Stock Limited.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const Text(
                    "Validity : 10/12/2023 to 30/12/2023",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const Text(
                    "Total Views : 12023",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const Text(
                    "Average Daily Views : 1200",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const Text(
                    "Total Click : 235",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 20,
              top: 20,
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.1),
                child: PopupMenuButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    const PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Edit'),
                      ),
                    ),
                    const PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Delete'),
                      ),
                    ),
                    const PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.details),
                        title: Text('Shop : Close'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
