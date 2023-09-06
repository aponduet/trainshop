import 'package:flutter/material.dart';

class PaymentOption extends StatefulWidget {
  const PaymentOption({Key? key}) : super(key: key);

  @override
  _PaymentOptionState createState() => _PaymentOptionState();
}

class _PaymentOptionState extends State<PaymentOption> {
  @override
  Widget build(BuildContext context) {
    return Column(
      //Container Column
      children: [
        Card(
          child: Column(
            //Item
            children: [
              ListTile(
                selected: true,
                selectedColor: Colors.white,
                selectedTileColor: Colors.green,
                title: const Text(
                  "Payment Options",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: MaterialButton(
                  onPressed: () {},
                  color: Colors.yellow,
                  child: const Text("Add"),
                ),
              ),
              ListTile(
                leading: Image.asset(
                  'assets/images/nagad.png',
                  width: 100,
                  height: 70,
                  fit: BoxFit.cover,
                ),
                title: const Text("Nagad"),
                subtitle: const Text("A/C : 01478457124"),
                trailing: PopupMenuButton(
                  tooltip: "Edit",
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.grey,
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
              Divider(
                indent: 20,
                endIndent: 20,
                color: Colors.grey.withOpacity(0.1),
              ),
              ListTile(
                leading: Image.asset(
                  'assets/images/rocket.png',
                  width: 100,
                  height: 70,
                  fit: BoxFit.cover,
                ),
                title: const Text("Rocket"),
                subtitle: const Text("A/C : 01478457124"),
                trailing: PopupMenuButton(
                  tooltip: "Edit",
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.grey,
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
              Divider(
                indent: 20,
                endIndent: 20,
                color: Colors.grey.withOpacity(0.1),
              ),
              ListTile(
                leading: Image.asset(
                  'assets/images/bkash.jpeg',
                  width: 100,
                  height: 70,
                  fit: BoxFit.cover,
                ),
                title: const Text("Bkash"),
                subtitle: const Text("A/C : 01478457124"),
                trailing: PopupMenuButton(
                  tooltip: 'Edit',
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.grey,
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
            ],
          ),
        ),
      ],
    );
  }
}
