import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class ImageToText extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImageToTextState();
  }
}

class _ImageToTextState extends State<ImageToText> {
  late String s = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Column(
      children: [
        Container(
          height: 250,
          width: 250,
          child: Center(
            child: GestureDetector(
                onTap: () async {
                  // PickedFile picker;
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  String a = await getImageTotext(image!.path);
                  setState(() {
                    s = a;
                    print(s);
                  });
                },
                child: const Icon(
                  Icons.file_copy,
                )),
          ),
        ),
        Text(
          s,
          style: TextStyle(color: Colors.black, fontSize: 20),
        )
      ],
    ));
  }

  Future getImageTotext(final imagePath) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(InputImage.fromFilePath(imagePath));
    String text = recognizedText.text.toString();
    return text;
  }
}
