import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<FirebaseUser> signInWithGoogle() async {
    GoogleSignInAccount googleUser;
    googleUser = await _googleSignIn.signIn();
    if (googleUser == null)
      return null;
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    AuthCredential authCredential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    
    final FirebaseUser user = await _auth.signInWithCredential(authCredential);

    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    
    return user;
  }