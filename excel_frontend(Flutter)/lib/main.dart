import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Excel App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class ExcelData {
  final int id;
  final String name;
  final String email;
  final String projectLink;

  ExcelData({
    required this.id,
    required this.name,
    required this.email,
    required this.projectLink,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'projectLink': projectLink,
    };
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String baseUrl = 'http://localhost:8080/excel';
  Dio dio = Dio();
  List<ExcelData> dataList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await dio.get('$baseUrl/data');
      if (response.statusCode == 200) {
        setState(() {
          dataList = (response.data as List)
              .map((item) => ExcelData(
            id: item['id'],
            name: item['name'],
            email: item['email'],
            projectLink: item['projectLink'],
          ))
              .toList();
        });
      } else {
        // Handle API error
      }
    } catch (e) {
      // Handle network or other errors
    }
  }

  Future<void> uploadExcelFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(
          result.files.single.bytes!,
          filename: result.files.single.name,
        ),
      });
      await Dio().post('$baseUrl/upload', data: formData);
      fetchData();
    }
  }

  Future<void> addExcelData(ExcelData excelData) async {
    try {
      final response = await dio.post('$baseUrl/add', data: excelData.toJson());
      if (response.statusCode == 200) {
        fetchData();
      } else {
        print('error');
      }
    } catch (e) {
      print('error');
    }
  }

  Future<void> removeExcelData(int id) async {
    try {
      final response = await dio.delete('$baseUrl/remove/$id');
      if (response.statusCode == 200) {
        fetchData();
      } else {
        print('error');
      }
    } catch (e) {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excel App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: uploadExcelFile,
              child: Text('Upload Excel File'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return DataListItem(
                    data: dataList[index],
                    onRemove: () => removeExcelData(dataList[index].id),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ExcelDataForm(
              onSubmit: addExcelData,
            ),
          ],
        ),
      ),
    );
  }
}

class DataListItem extends StatelessWidget {
  final ExcelData data;
  final VoidCallback onRemove;

  DataListItem({required this.data, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Name: ${data.name}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('id: ${data.id}'),
          Text('Email: ${data.email}'),
          Text('Project Link: ${data.projectLink}'),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: onRemove,
      ),
    );
  }
}

class ExcelDataForm extends StatefulWidget {
  final Function(ExcelData) onSubmit;

  ExcelDataForm({required this.onSubmit});

  @override
  _ExcelDataFormState createState() => _ExcelDataFormState();
}

class _ExcelDataFormState extends State<ExcelDataForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController projectLinkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: idController,
            decoration: InputDecoration(labelText: 'id'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your id';
              }
              return null;
            },
          ),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter an email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: projectLinkController,
            decoration: InputDecoration(labelText: 'Project Link'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter a project link';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                final newExcelData = ExcelData(
                  id: idController.hashCode, // Set a temporary ID
                  name: nameController.text,
                  email: emailController.text,
                  projectLink: projectLinkController.text,
                );
                widget.onSubmit(newExcelData);
                nameController.clear();
                idController.clear();
                emailController.clear();
                projectLinkController.clear();
              }
            },
            child: Text('Add Data'),
          ),
        ],
      ),
    );
  }
}
