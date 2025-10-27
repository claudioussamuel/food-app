import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodu/features/authentication/screens/onboarding/onboarding.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../features/navigation_menu/navigation_menu.dart';
import '../../../features/personalization/screens/profile_form/profile_form_screen.dart';
import '../../../features/personalization/controller/profile_form_controller.dart';
import '../../../utils/exports.dart';
import '../../../utils/popups/loaders.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (user == null) {
      Get.offAll(() => const OnBoardingScreen());
    } else {}
  }

  // Email & Password Sign-In
  Future<UserCredential?> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      var userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAll(() => const ProfileFormScreen());

      return userCredential;
    } on FirebaseAuthException catch (e) {
      TLoaders.errorSnackBar(
        title: e.message ?? TTexts.registrationFailed,
      );

      return null;
    }
  }

  Future<UserCredential?> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      var userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAll(() => const NavigationMenu());

      return userCredential;
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Login failed");
      return null;
    }
  }

  // Smart Google Sign-In - Checks if profile exists and routes accordingly
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final result = await _performGoogleSignInWithUserInfo();
      
      if (result != null) {
        final userCredential = result['userCredential'] as UserCredential;
        final googleUser = result['googleUser'];
        final email = _extractEmail(googleUser);
        
        // Check if profile exists for this email
        final profileExists = await doesProfileExist(email);
        
        if (profileExists) {
          // Profile exists - act as login
          print('Google Sign-In: Profile exists, navigating to main app');
          Get.offAll(() => const NavigationMenu());
        } else {
          // No profile - act as registration
          print('Google Sign-In: No profile found, navigating to profile form');
          Get.offAll(() => const ProfileFormScreen());
          
          // Wait a bit for the screen to load, then populate the fields
          Future.delayed(const Duration(milliseconds: 1000), () {
            _populateFieldsFromGoogle(googleUser);
          });
        }
        
        return userCredential;
      }
      
      return null;
    } on FirebaseAuthException catch (e) {
      TLoaders.errorSnackBar(
        title: e.message ?? "Google Sign-In Failed",
      );
      return null;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print(e.toString());
      return null;
    }
  }

  // Google Sign-In for Registration (explicit registration flow)
  Future<UserCredential?> registerWithGoogle() async {
    try {
      final result = await _performGoogleSignInWithUserInfo();
      
      if (result != null) {
        final userCredential = result['userCredential'] as UserCredential;
        final googleUser = result['googleUser'];
        
        // Always navigate to profile form for registration
        Get.offAll(() => const ProfileFormScreen());
        
        // Wait a bit for the screen to load, then populate the fields
        Future.delayed(const Duration(milliseconds: 1000), () {
          _populateFieldsFromGoogle(googleUser);
        });
        
        return userCredential;
      }
      
      return null;
    } on FirebaseAuthException catch (e) {
      TLoaders.errorSnackBar(
        title: e.message ?? "Google Registration Failed",
      );
      return null;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print(e.toString());
      return null;
    }
  }

  // Google Sign-In for Login (identical to email/password login)
  Future<UserCredential?> loginWithGoogle() async {
    try {
      final result = await _performGoogleSignInWithUserInfo();
      
      if (result != null) {
        final userCredential = result['userCredential'] as UserCredential;
        
        // Always navigate to main app for login flow
        Get.offAll(() => const NavigationMenu());
        
        return userCredential;
      }
      
      return null;
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Google Login failed");
      return null;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print(e.toString());
      return null;
    }
  }


  // Enhanced method that returns both UserCredential and GoogleSignInAccount
  Future<Map<String, dynamic>?> _performGoogleSignInWithUserInfo() async {
    try {
      UserCredential userCredential;
      User? user;
      
      if (kIsWeb) {
        // WEB: Use signInWithPopup for web platform
        print('Google Sign-In: Using web authentication flow');
        
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        
        // Sign in with popup
        userCredential = await _auth.signInWithPopup(googleProvider);
        user = userCredential.user;
        
        if (user == null) {
          print('Google Sign-In: No user returned from popup');
          return null;
        }
        
        print('Google Sign-In: Successfully authenticated user: ${user.email}');
        
        // Create a mock GoogleSignInAccount for web (since we don't use google_sign_in package on web)
        return {
          'userCredential': userCredential,
          'googleUser': _createMockGoogleSignInAccount(user),
        };
        
      } else {
        // MOBILE: Use google_sign_in package for mobile platforms
        print('Google Sign-In: Using mobile authentication flow');
        
        final GoogleSignIn googleSignIn = GoogleSignIn.instance;
        
        // Sign out any existing session to prevent reauth errors
        try {
          await googleSignIn.signOut();
        } catch (e) {
          print('Sign out error (can be ignored): $e');
        }

        // Trigger the authentication flow
        final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();

        // User canceled the sign-in
        if (googleUser == null) {
          print('Google Sign-In: User canceled the sign-in');
          return null;
        }

        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Verify we have the required tokens
        if (googleAuth.idToken == null) {
          print('Google Sign-In: No ID token received');
          TLoaders.errorSnackBar(
            title: 'Google Sign-In Failed',
            message: 'Unable to retrieve authentication token. Please try again.',
          );
          return null;
        }

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        // Sign in with credential
        userCredential = await _auth.signInWithCredential(credential);
        
        print('Google Sign-In: Successfully authenticated user: ${googleUser.email}');
        
        return {
          'userCredential': userCredential,
          'googleUser': googleUser,
        };
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      if (e.code != 'popup-closed-by-user') {
        TLoaders.errorSnackBar(
          title: 'Google Sign-In Error',
          message: e.message ?? 'Authentication failed',
        );
      }
      return null;
    } catch (e) {
      print('Google Sign-In Error: $e');
      TLoaders.errorSnackBar(
        title: 'Sign-In Failed',
        message: 'An unexpected error occurred. Please try again.',
      );
      return null;
    }
  }
  
  // Helper method to create a mock GoogleSignInAccount for web
  dynamic _createMockGoogleSignInAccount(User user) {
    // Return a map with the necessary user info for web
    return {
      'email': user.email ?? '',
      'displayName': user.displayName ?? '',
      'photoUrl': user.photoURL ?? '',
    };
  }
  
  // Helper method to extract email from either GoogleSignInAccount or Map
  String _extractEmail(dynamic googleUser) {
    if (googleUser is GoogleSignInAccount) {
      return googleUser.email;
    } else if (googleUser is Map) {
      return googleUser['email'] ?? '';
    }
    return '';
  }

  // Method to populate name and email fields from Google account information
  void _populateFieldsFromGoogle(dynamic googleUser) {
    try {
      // Get the ProfileFormController if it exists
      if (Get.isRegistered<ProfileFormController>()) {
        final profileController = ProfileFormController.instance;
        
        // Handle both GoogleSignInAccount (mobile) and Map (web)
        String displayName = '';
        String email = '';
        
        if (googleUser is GoogleSignInAccount) {
          // Mobile: GoogleSignInAccount object
          displayName = googleUser.displayName ?? '';
          email = googleUser.email;
        } else if (googleUser is Map) {
          // Web: Mock object (Map)
          displayName = googleUser['displayName'] ?? '';
          email = googleUser['email'] ?? '';
        }
        
        // Use the display name from Google account
        if (displayName.isNotEmpty) {
          profileController.populateNameFromDisplayName(displayName);
        }
        
        // Use the email from Google account (force update to override Firebase Auth email)
        if (email.isNotEmpty) {
          profileController.populateEmailField(email, forceUpdate: true);
        }
        
        print('Google Sign-In: Successfully populated fields - Name: $displayName, Email: $email');
        print('Google Sign-In: Email controller text after population: ${profileController.emailController.text}');
      }
    } catch (e) {
      print('Error populating fields from Google: $e');
    }
  }

  // Other authentication methods
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar("Success", "Password reset email sent");
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Failed to send reset email");
    }
  }

  Future<void> logout() async {
    try {
      // Sign out from both Firebase and Google
      await _auth.signOut();
      await GoogleSignIn.instance.disconnect();
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Logout failed");
    } catch (e) {
      print('Logout error: $e');
    }
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Check if user is logged in
  bool get isLoggedIn => _auth.currentUser != null;

  // Check if profile exists for the given email
  Future<bool> doesProfileExist(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('profiles')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking profile existence: $e');
      return false;
    }
  }
}
