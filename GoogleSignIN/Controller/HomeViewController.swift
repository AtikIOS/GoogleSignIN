//
//  HomeViewController.swift
//  GoogleSignIN
//
//  Created by Atik Hasan on 8/25/25.
//

import UIKit
import Firebase
import GoogleSignIn

class HomeViewController: UIViewController {

   // @IBOutlet weak var signInBtn : GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func googleSignInTapped(_ sender: Any) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

           let config = GIDConfiguration(clientID: clientID)
           GIDSignIn.sharedInstance.configuration = config

        // hint nil diyechi for device a koto gulu google accout add kora ache oi gulu show hobe.
        GIDSignIn.sharedInstance.signIn(withPresenting: self, hint: nil) { result, error in
               if let error = error {
                   print("Google Sign-In error: \(error)")
                   return
               }

               guard let user = result?.user,
                     let idToken = user.idToken else { return }

               // User profile info
               let fullName = user.profile?.name
               let givenName = user.profile?.givenName      // First name
               let familyName = user.profile?.familyName    // Last name
               let email = user.profile?.email

               print("Full Name: \(fullName ?? "")")
               print("First Name: \(givenName ?? "")")
               print("Last Name: \(familyName ?? "")")
               print("Email: \(email ?? "")")

               // Profile picture URL (if available)
               if user.profile?.hasImage == true {
                   let picURL = user.profile?.imageURL(withDimension: 200)  // 200px size
                   print("Profile Pic URL: \(picURL?.absoluteString ?? "")")
               }

               // ✅ Firebase credential
               let accessToken = user.accessToken
               let credential = GoogleAuthProvider.credential(
                   withIDToken: idToken.tokenString,
                   accessToken: accessToken.tokenString
               )

               Auth.auth().signIn(with: credential) { authResult, error in
                   if let error = error {
                       print("Firebase sign-in error: \(error)")
                   } else {
                       print("Firebase UID: \(authResult?.user.uid ?? "")")
                   }
               }
           }
      }
    
}
