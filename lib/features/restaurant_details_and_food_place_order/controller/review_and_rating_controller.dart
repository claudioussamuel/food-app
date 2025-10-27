import 'package:foodu/utils/constants/image_strings.dart';
import 'package:get/get.dart';

class ReviewAndRatingController extends GetxController {
  static ReviewAndRatingController get instance => Get.find();
  var reviews = <Map<String, dynamic>>[
    {
      "userName": "Charlotte Hanlin",
      "userImage": TImages.pic,
      "rating": 5,
      "reviewText": "Excellent food. Menu is extensive and seasonal to a particularly high standard. Definitely fine dining 😍😍",
      "likes": 938,
      "daysAgo": "6 days ago"
    },
    {
      "userName": "John Doe",
      "userImage": TImages.pic,
      "rating": 4,
      "reviewText": "Good food but service was slow.",
      "likes": 150,
      "daysAgo": "2 days ago"
    },
    {
      "userName": "'Lauralee Quintero",
      "userImage": TImages.pic,
      "rating": 4,
      "reviewText":
          "Delicious dishes, beautiful presentation, wide wine list and wonderful dessert. I recommend to everyone! I would like to order here again and again 👌👌",
      "likes": 629,
      "daysAgo": "2 week ago"
    },
  ].obs;
}
