import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyDataScreen extends StatefulWidget {
  @override
  _MyDataScreenState createState() => _MyDataScreenState();
}

class _MyDataScreenState extends State<MyDataScreen> {
  int cardItem = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CT Store'),
        actions: [
          IconButton(
            onPressed: () {
              openMenu(context);
            },
            icon: Badge(
              label: Text(cardItem.toString()),
              child: const Icon(
                Icons.shopping_basket_sharp,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return const Text('No data available');
          }

          List<Widget> usersInfo = [];
          snapshot.data!.docs.forEach((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            String name = data['name'];
            int price = data['age'];
            String image = data['image'];
            String currency = data['currency'];

            usersInfo.add(
              GestureDetector(
                onTap: () {
                  openDialog(context);
                },
                child: Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image(
                          image: NetworkImage(image),
                          width: 90,
                        ),
                      ),
                      Flexible(
                        child: ListTile(
                          title: Text(name),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(price.toString()),
                              Text(currency),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });

          return GridView.count(
            crossAxisCount: 2,
            children: usersInfo,
          );
        },
      ),
    );
  }

  void openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: MinimizeItem, icon: Icon(Icons.minimize)),
              IconButton(onPressed: AddItem, icon: Icon(Icons.add)),
            ],
          ),
        );
      },
    );
  }
  void openMenu(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Selected Items'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: cardItem, 
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Item ${index + 1}'), 
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: (){
                  Text(cardItem.toString());
                },child: Text('Reset')),
                Text('Close'),
              ],
            ),
          ),
        ],
      );
    },
  );
}


  void AddItem() {
    setState(() {
      cardItem++;
    });
  }

  void MinimizeItem() {
    setState(() {
      cardItem--;
    });
  }
}
// call all data from the object to get in badge

