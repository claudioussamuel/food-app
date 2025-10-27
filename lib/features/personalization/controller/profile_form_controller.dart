import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/repositories/personalization/profile_repository.dart';
import '../models/profile_model.dart';
import '../../../utils/popups/loaders.dart';

class ProfileFormController extends ProfileRepository {
  static ProfileFormController get instance => Get.find();

  // Form controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final imageUrl = ''.obs;

  // Observable variables for UI
  var imagePath = ''.obs;
  XFile? imageFile;
  RxString dateOfBirth = 'Date of Birth'.obs;
  RxString dropDownValue = 'Gender'.obs;
  var isLoading = false.obs;
  var isUploadingImage = false.obs;
  var currentProfile = Rxn<ProfileModel>();

  // Gender options
  List<String> items = [
    'Gender',
    'Male',
    'Female',
  ];

  @override
  void onInit() {
    super.onInit();
    _populateEmailFromAuth();
    loadCurrentUserProfile();
    
    // Add a small delay to ensure Firebase Auth is fully initialized
    Future.delayed(const Duration(milliseconds: 500), () {
      if (emailController.text.trim().isEmpty) {
        _populateEmailFromAuth();
      }
      // Also try to populate name fields from Firebase Auth if available
      _populateNameFromFirebaseAuth();
    });
  }

  /// Populate email from Firebase Auth current user
  void _populateEmailFromAuth() {
    final user = FirebaseAuth.instance.currentUser;
    if (user?.email != null && user!.email!.isNotEmpty) {
      emailController.text = user.email!;
      print('Email populated from Firebase Auth: ${user.email}');
    } else {
      print('Warning: No email found in Firebase Auth current user');
    }
  }

  /// Populate name and email fields from Firebase Auth current user if available
  void _populateNameFromFirebaseAuth() {
    final user = FirebaseAuth.instance.currentUser;
    
    // Populate name fields from display name
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      // Only populate if the fields are currently empty to avoid overwriting existing data
      if (firstNameController.text.trim().isEmpty && lastNameController.text.trim().isEmpty) {
        populateNameFromDisplayName(user.displayName!);
        print('Name fields populated from Firebase Auth display name: ${user.displayName}');
      }
    }
    
    // Populate email field
    if (user?.email != null && user!.email!.isNotEmpty) {
      populateEmailField(user.email!);
    }
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  /// Load current user's profile if exists
  Future<void> loadCurrentUserProfile() async {
    try {
      isLoading.value = true;
      final profile = await fetchCurrentUserProfile();

      if (profile != null) {
        currentProfile.value = profile;
        populateFormFields(profile);
      }
    } catch (e) {
      // Profile doesn't exist yet - this is normal for new users
      print('No existing profile found: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Populate form fields with profile data
  void populateFormFields(ProfileModel profile) {
    firstNameController.text = profile.firstName;
    lastNameController.text = profile.lastName;
    // Only set email if it's not already populated from auth
    if (emailController.text.isEmpty) {
      emailController.text = profile.email;
    }
    phoneController.text = profile.phoneNumber;

    if (profile.dateOfBirth != null) {
      dateOfBirth.value = DateFormat('dd/MM/yyyy').format(profile.dateOfBirth!);
    }

    if (profile.gender != null && profile.gender!.isNotEmpty) {
      dropDownValue.value = profile.gender!;
    }

    if (profile.profileImagePath != null &&
        profile.profileImagePath!.isNotEmpty) {
      imagePath.value = profile.profileImagePath!;
      // Also set imageUrl for network images
      if (profile.profileImagePath!.startsWith('http')) {
        imageUrl.value = profile.profileImagePath!;
      }
    }
  }

  /// Select image from gallery and upload to Firebase Storage
  Future<void> selectImage() async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      imageFile = await imagePicker.pickImage(source: ImageSource.gallery);

      if (imageFile != null) {
        // Show local path immediately for preview
        imagePath.value = imageFile!.path;

        // Upload to Firebase Storage
        await uploadImageToFirebase();
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to select image: $e',
      );
    }
  }

  /// Select image from camera and upload to Firebase Storage
  Future<void> selectImageFromCamera() async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      imageFile = await imagePicker.pickImage(source: ImageSource.camera);

      if (imageFile != null) {
        // Show local path immediately for preview
        imagePath.value = imageFile!.path;

        // Upload to Firebase Storage
        await uploadImageToFirebase();
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to capture image: $e',
      );
    }
  }

  /// Upload image to Firebase Storage
  Future<void> uploadImageToFirebase() async {
    if (imageFile == null) return;

    try {
      isUploadingImage.value = true;

      // Get Firebase Storage instance
      final FirebaseStorage storage = FirebaseStorage.instance;

      // Create a unique filename
      final String fileName =
          'profile_images/${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile!.path)}';

      // Create reference to the file location
      final Reference ref = storage.ref().child(fileName);

      // Upload the file
      final UploadTask uploadTask = ref.putFile(File(imageFile!.path));

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrl.value = downloadUrl;

      // Update image path with Firebase Storage URL
      // imagePath.value = downloadUrl;

      // TLoaders.successSnackBar(
      //   title: 'Success',
      //   message: 'Image uploaded successfully!',
      // );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Upload Error',
        message: 'Failed to upload image: $e',
      );
    } finally {
      isUploadingImage.value = false;
    }
  }

  /// Create profile from form data
  ProfileModel createProfileFromForm() {
    DateTime? parsedDateOfBirth;
    if (dateOfBirth.value != 'Date of Birth') {
      try {
        parsedDateOfBirth = DateFormat('dd/MM/yyyy').parse(dateOfBirth.value);
      } catch (e) {
        throw 'Invalid date format';
      }
    }

    return ProfileModel(
      id: currentProfile.value?.id,
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      profileImagePath: imageUrl.value,
      dateOfBirth: parsedDateOfBirth,
      gender: dropDownValue.value != 'Gender' ? dropDownValue.value : null,
      createdAt: currentProfile.value?.createdAt,
    );
  }

  /// Save profile using base repository methods
  Future<bool> saveProfile() async {
    try {
      isLoading.value = true;

      // Always ensure email is populated from Firebase Auth
      _populateEmailFromAuth();
      
      // Validate required fields
      if (firstNameController.text.trim().isEmpty) {
        TLoaders.errorSnackBar(
            title: 'Error', message: 'First name is required');
        return false;
      }

      if (lastNameController.text.trim().isEmpty) {
        TLoaders.errorSnackBar(
            title: 'Error', message: 'Last name is required');
        return false;
      }

      // Validate email is available from Firebase Auth
      if (emailController.text.trim().isEmpty) {
        TLoaders.errorSnackBar(
          title: 'Authentication Error', 
          message: 'Unable to retrieve email from authentication. Please try logging in again.'
        );
        return false;
      }

      if (phoneController.text.trim().isEmpty) {
        TLoaders.errorSnackBar(
            title: 'Error', message: 'Phone number is required');
        return false;
      }

      if (dateOfBirth.value == 'Date of Birth') {
        TLoaders.errorSnackBar(
            title: 'Error', message: 'Date of birth is required');
        return false;
      }

      if (dropDownValue.value == 'Gender') {
        TLoaders.errorSnackBar(
            title: 'Error', message: 'Gender selection is required');
        return false;
      }

      final profile = createProfileFromForm();

      // Use base repository method to save
      await saveCurrentUserProfile(profile);
      currentProfile.value = profile;

      TLoaders.successSnackBar(
        title: 'Success',
        message: 'Profile saved successfully',
      );

      return true;
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to save profile: $e',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update profile using base repository methods
  Future<bool> updateProfile() async {
    try {
      isLoading.value = true;

      if (currentProfile.value == null) {
        TLoaders.errorSnackBar(title: 'Error', message: 'No profile to update');
        return false;
      }

      final profile = createProfileFromForm();

      // Use base repository method to update
      await updateItemRecord(profile);
      currentProfile.value = profile;

      TLoaders.successSnackBar(
        title: 'Success',
        message: 'Profile updated successfully',
      );

      return true;
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to update profile: $e',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete current profile using base repository methods
  Future<bool> deleteProfile() async {
    try {
      isLoading.value = true;

      if (currentProfile.value == null) {
        TLoaders.errorSnackBar(title: 'Error', message: 'No profile to delete');
        return false;
      }

      // Use base repository method to delete
      await deleteItemRecord(currentProfile.value!);

      // Clear form and current profile
      clearForm();
      currentProfile.value = null;

      TLoaders.successSnackBar(
        title: 'Success',
        message: 'Profile deleted successfully',
      );

      return true;
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to delete profile: $e',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Get all profiles using base repository methods
  Future<List<ProfileModel>> getAllProfiles() async {
    try {
      isLoading.value = true;
      return await getAllItems();
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to load profiles: $e',
      );
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Get limited profiles with pagination
  Future<List<ProfileModel>> getProfilesPaginated(int limit) async {
    try {
      isLoading.value = true;
      return await getLimitedItems(limit);
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to load profiles: $e',
      );
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Update only the profile image using base repository methods
  Future<void> updateProfileImageOnly() async {
    try {
      if (imagePath.value.isEmpty) {
        TLoaders.errorSnackBar(
            title: 'Error', message: 'Please select an image first');
        return;
      }

      isLoading.value = true;
      await updateProfileImage(imagePath.value);

      TLoaders.successSnackBar(
        title: 'Success',
        message: 'Profile image updated successfully',
      );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to update profile image: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear form fields
  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    dateOfBirth.value = 'Date of Birth';
    dropDownValue.value = 'Gender';
    imagePath.value = '';
    imageFile = null;
  }

  /// Check if form has been modified
  bool get isFormModified {
    return firstNameController.text.isNotEmpty ||
        lastNameController.text.isNotEmpty ||
        emailController.text.isNotEmpty ||
        phoneController.text.isNotEmpty ||
        dateOfBirth.value != 'Date of Birth' ||
        dropDownValue.value != 'Gender' ||
        imagePath.value.isNotEmpty;
  }

  /// Check if profile exists
  Future<bool> profileExists() async {
    return await hasProfile();
  }

  /// Populate name fields from external source (e.g., Google Sign-In)
  void populateNameFields({String? firstName, String? lastName}) {
    if (firstName != null && firstName.isNotEmpty) {
      firstNameController.text = firstName;
    }
    if (lastName != null && lastName.isNotEmpty) {
      lastNameController.text = lastName;
    }
    print('ProfileFormController: Name fields populated - First: $firstName, Last: $lastName');
  }

  /// Populate email field from external source (e.g., Google Sign-In)
  void populateEmailField(String email, {bool forceUpdate = false}) {
    if (email.trim().isNotEmpty) {
      // Populate if field is empty OR if this is a forced update (e.g., from Google Sign-in)
      if (emailController.text.trim().isEmpty || forceUpdate) {
        emailController.text = email.trim();
        print('ProfileFormController: Email field populated - Email: $email (forceUpdate: $forceUpdate)');
      } else {
        print('ProfileFormController: Email field already has data, skipping population');
      }
    }
  }

  /// Parse and populate name from full display name
  void populateNameFromDisplayName(String displayName) {
    if (displayName.trim().isEmpty) return;
    
    final nameParts = displayName.trim().split(' ');
    
    if (nameParts.isNotEmpty) {
      // Set first name
      firstNameController.text = nameParts.first;
      
      // Set last name (everything after first name)
      if (nameParts.length > 1) {
        lastNameController.text = nameParts.skip(1).join(' ');
      }
    }
    
    print('ProfileFormController: Parsed display name "$displayName" - First: ${firstNameController.text}, Last: ${lastNameController.text}');
  }
}
