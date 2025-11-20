import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';
import '../models/user_role.dart';

//auth for firebase
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  //current user
  User? get currentUser => _auth.currentUser;

  //Register new
  Future<AppUser> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
    required UserRole role,
  }) async {
    try{
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null){
        throw Exception('User creation failed');
      }

      final appUser = AppUser(
        uid:user.uid,
        email: email,
        username: username,
        role: role,
        createdAt: DateTime.now(),
      );

      //save to - users collection
      await _firestore.collection('users').doc(user.uid).set(appUser.toJson());

      //role-specific document
      if(role == UserRole.musician){
        await _firestore.collection('musicians') .doc(user.uid).set({
          'uid': user.uid,
          'createdAt': Timestamp.now(),
        });
      } else {
        await _firestore.collection('organizers').doc(user.uid).set({
          'uid': user.uid,
          'createdAt': Timestamp.now(),
        });
      }

      return appUser;
    } on FirebaseAuthException catch (e){
      throw _handleAuthException(e);
    } catch (e){
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  //sign in with email & password
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('Sign in failed');
      }

      //get user data
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        throw Exception('User not found');
      }

      return AppUser.fromJson(doc.data()!);
    }
    on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  //Sign out
  Future<void> signOut() async{
    try{
      await _auth.signOut();
    } catch(e){
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  Future<AppUser?> getUserData(String uid) async{
    try{
      final doc = await _firestore.collection('users').doc(uid).get();
      if(!doc.exists) return null;
      return AppUser.fromJson(doc.data()!);
    } catch (e){
      return null;
    }
  }

  String _handleAuthException(FirebaseAuthException e){
    switch (e.code){
      case 'weak-password':
        return 'The password is too weak';
      case 'email-already-in-use':
        return 'The email is already in use';
      case 'invalid-email':
        return 'The email is invalid';
      case 'user-not-found':
        return 'The user is not found';
      case 'wrong-password':
        return 'The password is wrong';
      case 'user-disabled':
        return 'The user is disabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'operation-not-allowed':
        return 'Operation not allowed';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}
