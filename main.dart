import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
await Hive.initFlutter();
await Hive.openBox('harcamalar');
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
  title: 'Harcama Takip',
theme: ThemeData(primarySwatch: Colors.green),
home: const HomePage(),
);
}
}

class HomePage extends StatefulWidget {
const HomePage({super.key});

@override
State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
final _formKey = GlobalKey<FormState>();
final TextEditingController _isimController = TextEditingController();
final TextEditingController _miktarController = TextEditingController();
final Box harcamaBox = Hive.box('harcamalar');

void _ekle() {
if (_formKey.currentState!.validate()) {
harcamaBox.add({
'isim': _isimController.text,
'miktar': double.parse(_miktarController.text),
'tarih': DateTime.now().toString()
});
_isimController.clear();
_miktarController.clear();
setState(() {});
  }
}

void _sil(int index) {
harcamaBox.deleteAt(index);
setState(() {});
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text('Harcama Takip')),
body: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
children: [
Form(
key: _formKey,
  child: Row(
children: [
Expanded(
child: TextFormField(
controller: _isimController,
decoration: const InputDecoration(labelText: 'Harcama İsmi'),
validator: (value) => value!.isEmpty ? 'İsim girin' : null,
),
),
const SizedBox(width: 10),
Expanded(
child: TextFormField(
controller: _miktarController,
decoration: const InputDecoration(labelText: 'Miktar'),
keyboardType: TextInputType.number,
validator: (value) => value!.isEmpty ? 'Miktar girin' : null,
),
  ),
IconButton(icon: const Icon(Icons.add), onPressed: _ekle),
],
),
),
const SizedBox(height: 20),
Expanded(
child: ValueListenableBuilder(
valueListenable: harcamaBox.listenable(),
builder: (context, Box box, _) {
if (box.isEmpty) return const Center(child: Text('Hiç harcama yok'));
return ListView.builder(
itemCount: box.length,
itemBuilder: (context, index) {
final item = box.getAt(index) as Map;
return Card(
child: ListTile(
  title: Text(item['isim']),
subtitle: Text('₺${item['miktar']} - ${item['tarih'].split(' ')[0]}'),
trailing: IconButton(
icon: const Icon(Icons.delete, color: Colors.red),
onPressed: () => _sil(index),
),
),
);
},
);
},
),
),
],
),
),
);
}
}  
