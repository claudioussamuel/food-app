import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  var isDarkMode = false.obs;

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
  }

  var imagePath = ''.obs;
  XFile? imageFile;
  RxString dateOfBirth = 'Date of Birth'.obs;
  RxString dropDownValue = 'Gender'.obs;

  List<String> items = [
    'Gender',
    'Male',
    'Female',
  ];

  Future selectImage() async {
    final ImagePicker imagePicker = ImagePicker();
    imageFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      imagePath.value = imageFile!.path;
    }
  }

  var addresses = <Map<String, dynamic>>[
    {
      'title': 'Home',
      'address': 'Times Square NYC, Manhattan, 27',
      'isDefault': true,
    },
    {
      'title': 'My Office',
      'address': '5259 Blue Bill Park, PC 4627',
      'isDefault': false,
    },
    {
      'title': 'My Apartment',
      'address': '21833 Clyde Gallagher, PC 4662',
      'isDefault': false,
    },
  ].obs;

  void addAddress(String title, String address, {bool isDefault = false}) {
    addresses.add({
      'title': title,
      'address': address,
      'isDefault': isDefault,
    });
  }

  var selectedLanguage = 'English (US)'.obs;

  void changeLanguage(String language) {
    selectedLanguage.value = language;
  }
}
