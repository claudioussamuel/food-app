import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
//
import '../../utils/exceptions/exports.dart';

//
/// A generic controller class for managing data tables using GetX state management.
/// This class provides common functionalities for handling data tables, including fetching, updating, and deleting items.
abstract class TBaseRepositoryController<T> extends GetxController {
  final db = FirebaseFirestore.instance;

  // Variable to store the last document fetched for pagination
  QueryDocumentSnapshot? lastFetchedDocument;

  /// Abstract method to be implemented by subclasses for fetching items.
  Future<List<T>> fetchAllItems();

  /// Abstract method to be implemented by subclasses for fetching items.
  Future<T> fetchSingleItem(String id);

  /// Abstract method to be implemented by subclasses for fetching items.
  Future<String> addItem(T item);

  /// Abstract method to be implemented by subclasses for fetching items.
  Future<void> updateItem(T item);

  /// Abstract method to be implemented by subclasses for fetching items.
  Future<void> updateSingleField(String id, Map<String, dynamic> json);

  /// Abstract method to be implemented by subclasses for deleting an item.
  Future<void> deleteItem(T item);

  // Get all items from Firestore
  Future<List<T>> getAllItems() async {
    try {
      return await fetchAllItems();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Get single item from Firestore
  Future<T> getSingleItem(String id) async {
    try {
      return await fetchSingleItem(id);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<String> addNewItem(T item) async {
    try {
      return await addItem(item);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> updateItemRecord(T item) async {
    try {
      return await updateItem(item);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> updateSingleItemRecord(
      String id, Map<String, dynamic> json) async {
    try {
      return await updateSingleField(id, json);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> deleteItemRecord(T item) async {
    try {
      return await deleteItem(item);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Paginated fetching method
  Future<List<T>> getLimitedItems(int limit) async {
    try {
      Query query = fetchLimitedItems(limit);

      // If there's a last fetched document, start after it
      if (lastFetchedDocument != null) {
        query = query.startAfterDocument(lastFetchedDocument!);
      }

      // Fetch the data
      final querySnapshot = await query.get();

      // If there are documents, store the last one for pagination
      if (querySnapshot.docs.isNotEmpty) {
        lastFetchedDocument = querySnapshot.docs.last;
      }

      // Convert to model list
      final items =
          querySnapshot.docs.map((doc) => fromQueryDocSnapshot(doc)).toList();

      return items;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Abstract method to get the collection path
  Query fetchLimitedItems(int limit);

  // Abstract method to convert DocumentSnapshot to model
  T fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc);
}
