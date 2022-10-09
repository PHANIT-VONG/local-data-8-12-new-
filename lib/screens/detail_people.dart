import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/people_controller.dart';
import '../models/people_model.dart';
import '../widgets/loading_widget.dart';
import 'show_people.dart';

class DetailPeople extends StatefulWidget {
  final PeopleModel peopleModel;
  const DetailPeople({Key? key, required this.peopleModel}) : super(key: key);

  @override
  State<DetailPeople> createState() => _DetailPeopleState();
}

class _DetailPeopleState extends State<DetailPeople> {
  late TextEditingController name;
  late TextEditingController gender;
  late TextEditingController address;
  String? _imageString;
  List<XFile>? _imageFileList;
  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  Image fromImageString(String imageString) {
    return Image.memory(base64Decode(imageString));
  }

  final ImagePicker _picker = ImagePicker();
  void onImagePressed(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: double.maxFinite,
        maxHeight: double.maxFinite,
        imageQuality: 100,
      );
      setState(() {
        _imageFile = pickedFile;
        List<int> imageBytes = File(pickedFile!.path).readAsBytesSync();
        _imageString = base64Encode(imageBytes);
      });
    } catch (e) {
      print('Image Error : $e');
    }
  }

  showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  onImagePressed(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  onImagePressed(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  GestureDetector buildImage(BuildContext context) {
    return GestureDetector(
      onTap: () => showPicker(context),
      child: Container(
        height: 130.0,
        width: 130.0,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 221, 216, 216),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.blue, width: 3.0),
          image: _imageFileList != null || _imageString != null
              ? DecorationImage(
                  fit: BoxFit.cover,
                  image: kIsWeb
                      ? NetworkImage(_imageFileList!.first.path)
                      : _imageString != null
                          ? fromImageString(_imageString!).image
                          : Image.file(File(_imageFileList!.first.path)).image,
                )
              : null,
        ),
        child: _imageString != null
            ? null
            : _imageFileList != null
                ? null
                : const Icon(Icons.camera_alt),
      ),
    );
  }

  @override
  void initState() {
    name = TextEditingController(text: widget.peopleModel.name);
    gender = TextEditingController(text: widget.peopleModel.gender);
    address = TextEditingController(text: widget.peopleModel.address);
    _imageString =
        widget.peopleModel.photo.isEmpty ? null : widget.peopleModel.photo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail People'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              var people = PeopleModel(
                id: widget.peopleModel.id,
                name: name.text,
                gender: gender.text,
                address: address.text,
                photo: _imageString ?? '',
              );
              await PeopleController().updatePeople(people);
              LoadingWidget.showLoading(context);
              await Future.delayed(const Duration(seconds: 1));
              Navigator.pop;
              Navigator.pop;
              Navigator.pop;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ShowPeople()),
              );
            },
            icon: const Icon(Icons.done),
          ),
          const SizedBox(width: 10.0),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildImage(context),
                const SizedBox(height: 20.0),
                TextField(
                  style: Theme.of(context).textTheme.headline6,
                  controller: name,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                TextField(
                  style: Theme.of(context).textTheme.headline6,
                  controller: gender,
                  decoration: const InputDecoration(
                    hintText: 'Gender',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                TextField(
                  style: Theme.of(context).textTheme.headline6,
                  controller: address,
                  decoration: const InputDecoration(
                    hintText: 'Address',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    await PeopleController()
                        .deletePeople(widget.peopleModel.id);
                    LoadingWidget.showLoading(context);
                    await Future.delayed(const Duration(seconds: 1));
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ShowPeople()),
                    );
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
