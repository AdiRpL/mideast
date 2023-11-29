import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mideast Destination',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: SplashScreen(), // Menampilkan SplashScreen terlebih dahulu
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.home,
                size: 80,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              'Mideast Destinations',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Explore the Beauty of Middle East',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomeScreen(),
    CategoryScreen(),
    DataScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        title: Center(
          child: Image.network(
            "https://cdn.discordapp.com/attachments/1161332892220268594/1179240968185188392/Mideast__1_-removebg-preview.png?ex=657910bc&is=65669bbc&hm=598c13f0d45c7af3f232793fc26ce5727c1c8d5922b42116f98e77590860e3d0&", // Replace with your image asset path
            height: 40, // Adjust the height as needed
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Add your menu icon action here
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Add your search icon action here
            },
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_usage),
            label: 'Data',
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.tealAccent, Colors.teal],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.home,
                size: 80,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Mideast Destinations',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Explore the Beauty of Middle East',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CategoryScreen extends StatelessWidget {
  final List<Category> categories = [
    Category(name: 'Forest', icon: Icons.park),
    Category(name: 'Beach', icon: Icons.beach_access),
    Category(name: 'Mountain', icon: Icons.terrain),
    // Tambahkan jenis tempat wisata lainnya sesuai kebutuhan
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            print('Category clicked: ${categories[index].name}');
          },
          child: Card(
            margin: EdgeInsets.all(16),
            color: Colors.white, // Sesuaikan warna tema
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 200,
                  child: Icon(
                    categories[index].icon,
                    size: 120,
                    color: Colors.green, // Sesuaikan warna ikon
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.teal, // Sesuaikan warna tema
                  child: Text(
                    categories[index].name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Category {
  final String name;
  final IconData icon;

  Category({required this.name, required this.icon});
}


class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  List<Map<String, dynamic>> _dataList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Fungsi untuk memuat data dari shared preferences
  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? dataStringList = prefs.getStringList('dataList');

    if (dataStringList != null) {
      setState(() {
        _dataList = dataStringList.map((dataString) {
          Map<String, dynamic> dataMap = Map<String, dynamic>.from(json.decode(dataString));
          return dataMap;
        }).toList();
      });
    }
  }

  // Fungsi untuk menyimpan data ke shared preferences
  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> dataStringList = _dataList.map((dataMap) => json.encode(dataMap)).toList();
    prefs.setStringList('dataList', dataStringList);
  }

  void addData(String name, String description, String major, String rating, String waktupost, String imagePath) {
    String formattedDate = DateTime.parse(waktupost).toLocal().toString().split(' ')[0];

    setState(() {
      _dataList.add({
        'name': name,
        'description': description,
        'major': major,
        'rating': rating,
        'waktupost': formattedDate,
        'imagePath': imagePath,
      });
    });

    // Simpan data ke shared preferences setiap kali ada perubahan
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _dataList.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayDataScreen(
                      name: _dataList[index]['name'],
                      className: _dataList[index]['description'],
                      major: '', // Ganti dengan field yang sesuai
                      phoneNumber: _dataList[index]['rating'].toString(),
                      waktupost: _dataList[index]['waktupost'],
                      imagePath: _dataList[index]['imagePath'],
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(
                    _dataList[index]['imagePath'] ?? 'https://via.placeholder.com/150',
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _dataList[index]['name'],
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _dataList[index]['description'],
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rating: ${_dataList[index]['rating']}/10',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '${_dataList[index]['waktupost']}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDataScreen(
                onDataAdded: addData,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddDataScreen extends StatefulWidget {
  final Function(String, String, String, String, String, String) onDataAdded;

  AddDataScreen({required this.onDataAdded});

  @override
  _AddDataScreenState createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  final _nameController = TextEditingController();
  final _classController = TextEditingController();
  final _majorController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  String _imagePath = '';
  ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        title: Center(
          child: Image.network(
            "https://cdn.discordapp.com/attachments/1161332892220268594/1179240968185188392/Mideast__1_-removebg-preview.png?ex=657910bc&is=65669bbc&hm=598c13f0d45c7af3f232793fc26ce5727c1c8d5922b42116f98e77590860e3d0&", // Replace with your image asset path
            height: 40, // Adjust the height as needed
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous screen
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Add your search icon action here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                _pickImage();
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _imagePath.isNotEmpty
                    ? Image.network(
                        _imagePath,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.add_photo_alternate,
                        size: 50,
                        color: Colors.grey[500],
                      ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _classController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _majorController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Rating'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String name = _nameController.text;
                String className = _classController.text;
                String major = _majorController.text;
                String phoneNumber = _phoneNumberController.text;

                // Tambahkan field waktu post
                String waktupost = DateTime.now().toString();

                // Validasi: Pastikan semua field tidak kosong
                if (name.trim().isEmpty ||
                    className.trim().isEmpty ||
                    major.trim().isEmpty ||
                    phoneNumber.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('All fields must be filled'),
                    ),
                  );
                  return;
                }

                widget.onDataAdded(
                  name,
                  className,
                  major,
                  phoneNumber,
                  waktupost,
                  _imagePath,
                );

                // Pindah ke halaman kedua dengan membawa data yang telah diinputkan
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataDetailScreen(
                      name: name,
                      className: className,
                      major: major,
                      phoneNumber: phoneNumber,
                      waktupost: waktupost,
                      imagePath: _imagePath,
                    ),
                  ),
                );
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class DataDetailScreen extends StatelessWidget {
  final String name;
  final String className;
  final String major;
  final String phoneNumber;
  final String waktupost;
  final String imagePath;

  DataDetailScreen({
    required this.name,
    required this.className,
    required this.major,
    required this.phoneNumber,
    required this.waktupost,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DisplayDataScreen(
        name: name,
        className: className,
        major: major,
        phoneNumber: phoneNumber,
        waktupost: waktupost,
        imagePath: imagePath,
      ),
    );
  }
}

class DisplayDataScreen extends StatelessWidget {
  final String name;
  final String className;
  final String major;
  final String phoneNumber;
  final String waktupost;
  final String imagePath;

  DisplayDataScreen({
    required this.name,
    required this.className,
    required this.major,
    required this.phoneNumber,
    required this.waktupost,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           appBar: AppBar(
        title: Center(
          child: Image.network(
            "https://cdn.discordapp.com/attachments/1161332892220268594/1179240968185188392/Mideast__1_-removebg-preview.png?ex=657910bc&is=65669bbc&hm=598c13f0d45c7af3f232793fc26ce5727c1c8d5922b42116f98e77590860e3d0&", // Replace with your image asset path
            height: 40, // Adjust the height as needed
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous screen
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Add your search icon action here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name : $name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '$className',
              style: TextStyle(fontSize: 18),
            ),
          
            Text(
              '$major',
              style: TextStyle(fontSize: 18),
            ),
           
            Text(
              'Rating : $phoneNumber/10',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Post Time : $waktupost',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(imagePath.isNotEmpty
                      ? imagePath
                      : 'https://via.placeholder.com/150'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}