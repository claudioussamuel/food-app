import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Firebase Storage Test Utility
/// Use this to diagnose upload issues
class FirebaseStorageTest {
  /// Test basic Firebase Storage connectivity
  static Future<void> testConnection() async {
    try {
      print('🔍 Testing Firebase Storage Connection...');
      
      // 1. Check Authentication
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('❌ User not authenticated');
        print('   Please log in first');
        return;
      }
      print('✅ User authenticated: ${user.email}');
      print('   User ID: ${user.uid}');
      
      // 2. Check Storage Instance
      final storage = FirebaseStorage.instance;
      print('✅ Firebase Storage instance created');
      print('   Bucket: ${storage.bucket}');
      
      // 3. Create Test Reference
      final testRef = storage.ref().child('test/${DateTime.now().millisecondsSinceEpoch}.txt');
      print('✅ Test reference created: ${testRef.fullPath}');
      
      // 4. Upload Test Data
      print('📤 Uploading test data...');
      final testData = 'Firebase Storage Test - ${DateTime.now()}';
      
      if (kIsWeb) {
        await testRef.putString(testData);
      } else {
        await testRef.putString(testData);
      }
      
      print('✅ Upload successful!');
      
      // 5. Get Download URL
      final downloadUrl = await testRef.getDownloadURL();
      print('✅ Download URL obtained');
      print('   URL: $downloadUrl');
      
      // 6. Delete Test File
      await testRef.delete();
      print('✅ Test file deleted');
      
      print('\n🎉 All tests passed! Firebase Storage is working correctly.');
      
    } on FirebaseException catch (e) {
      print('\n❌ Firebase Error:');
      print('   Code: ${e.code}');
      print('   Message: ${e.message}');
      print('   Plugin: ${e.plugin}');
      
      _printSolution(e.code);
      
    } catch (e) {
      print('\n❌ Unexpected Error: $e');
    }
  }
  
  /// Print solution based on error code
  static void _printSolution(String errorCode) {
    print('\n💡 Solution:');
    
    switch (errorCode) {
      case 'unauthorized':
      case 'permission-denied':
        print('   1. Check Firebase Storage Rules');
        print('   2. Go to Firebase Console → Storage → Rules');
        print('   3. Temporarily set: allow read, write: if true;');
        print('   4. Make sure user is authenticated');
        break;
        
      case 'unauthenticated':
        print('   1. User is not logged in');
        print('   2. Please authenticate before uploading');
        break;
        
      case 'network-request-failed':
        print('   1. Check internet connection');
        print('   2. Try again with stable network');
        break;
        
      case 'timeout':
        print('   1. Upload timed out');
        print('   2. Try with smaller file');
        print('   3. Check network speed');
        break;
        
      case 'object-not-found':
        print('   1. Storage bucket not found');
        print('   2. Check Firebase configuration');
        break;
        
      default:
        print('   Check Firebase Storage documentation for error: $errorCode');
    }
  }
  
  /// Test image upload with progress tracking
  static Future<void> testImageUpload(Uint8List imageBytes, String fileName) async {
    try {
      print('🔍 Testing Image Upload...');
      print('   File: $fileName');
      print('   Size: ${imageBytes.length} bytes');
      
      // Check file size
      if (imageBytes.length > 5 * 1024 * 1024) {
        print('❌ File too large (> 5MB)');
        return;
      }
      print('✅ File size OK');
      
      // Create reference
      final ref = FirebaseStorage.instance
          .ref()
          .child('test_images/${DateTime.now().millisecondsSinceEpoch}_$fileName');
      
      // Upload with progress tracking
      final uploadTask = ref.putData(imageBytes);
      
      uploadTask.snapshotEvents.listen((snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        print('📤 Upload progress: ${(progress * 100).toStringAsFixed(1)}%');
      });
      
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      print('✅ Image uploaded successfully!');
      print('   URL: $downloadUrl');
      
      // Clean up
      await ref.delete();
      print('✅ Test image deleted');
      
    } on FirebaseException catch (e) {
      print('❌ Upload failed: ${e.code} - ${e.message}');
      _printSolution(e.code);
    } catch (e) {
      print('❌ Error: $e');
    }
  }
  
  /// Check current Firebase Storage rules
  static Future<void> checkStorageRules() async {
    print('📋 Firebase Storage Rules Check:');
    print('   1. Go to: https://console.firebase.google.com/');
    print('   2. Select project: food-9d1af');
    print('   3. Navigate to: Storage → Rules');
    print('   4. Verify rules allow write access');
    print('\n   Current user: ${FirebaseAuth.instance.currentUser?.email ?? "Not logged in"}');
  }
}
