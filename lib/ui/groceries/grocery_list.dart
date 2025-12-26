import 'package:flutter/material.dart';
import '../../data/mock_grocery_repository.dart';
import '../../models/grocery.dart';
import 'grocery_form.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {

  int _selectedIndex = 0;
  String _searchText = '';

  void onCreate() async {
    // Navigate to the form screen using the Navigator push
    Grocery? newGrocery = await Navigator.push<Grocery>(
      context,
      MaterialPageRoute(builder: (context) => const GroceryForm()),
    );
    if (newGrocery != null) {
      setState(() {
        dummyGroceryItems.add(newGrocery);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_selectedIndex == 0) {
      content = dummyGroceryItems.isEmpty
        ? const Center(child: Text('No items added yet.'))
        : ListView.builder(
          itemCount: dummyGroceryItems.length,
          itemBuilder: (context, index) => 
              GroceryTile(grocery: dummyGroceryItems[index])
          );
    } else {
      final filteredItems = _searchText.isEmpty
        ? <Grocery>[]
        : dummyGroceryItems
            .where((item) => item.name
                .toLowerCase()
                .startsWith(_searchText.toLowerCase()))
            .toList();

      content = Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value.trim();
                });
              },
            ),
          ),
          Expanded(
            child: _searchText.isEmpty
                ? const Center(child: Text('Type to search'))
                : filteredItems.isEmpty
                    ? const Center(child: Text('No items found.'))
                    : ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) =>
                            GroceryTile(grocery: filteredItems[index]),
                      ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(onPressed: onCreate, icon: const Icon(Icons.add)),
        ]
      ),
      body: content,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _searchText = '';
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store),
            label: 'Groceries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
    );
  }

    // if (dummyGroceryItems.isNotEmpty) {
    //   //  Display groceries with an Item builder and  LIst Tile
    //   content = ListView.builder(
    //     itemCount: dummyGroceryItems.length,
    //     itemBuilder: (context, index) =>
    //         GroceryTile(grocery: dummyGroceryItems[index]),
    //   );
    // }

    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Your Groceries'),
    //     actions: [IconButton(onPressed: onCreate, icon: const Icon(Icons.add))],
    //   ),
    //   body: content,
    // );
}


class GroceryTile extends StatelessWidget {
  const GroceryTile({super.key, required this.grocery});

  final Grocery grocery;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(width: 15, height: 15, color: grocery.category.color),
      title: Text(grocery.name),
      trailing: Text(grocery.quantity.toString()),
    );
  }
}
