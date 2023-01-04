//
//  Backend.swift
//  iOS Getting Started
//
//  Created by Satej Sahu on 04/01/23.
//
import AmplifyPlugins
import UIKit
import Amplify

class Backend {
    static let shared = Backend()
    static func initialize() -> Backend {
        return .shared
    }
    private init() {
      // initialize amplify
      do {
        try Amplify.add(plugin: AWSCognitoAuthPlugin())
        try Amplify.configure()
          _ = Amplify.Hub.listen(to: .auth) { (payload) in

              switch payload.eventName {

              case HubPayload.EventName.Auth.signedIn:
                  print("==HUB== User signed In, update UI")
                  self.updateUserData(withSignInStatus: true)

              case HubPayload.EventName.Auth.signedOut:
                  print("==HUB== User signed Out, update UI")
                  self.updateUserData(withSignInStatus: false)

              case HubPayload.EventName.Auth.sessionExpired:
                  print("==HUB== Session expired, show sign in UI")
                  self.updateUserData(withSignInStatus: false)

              default:
                  //print("==HUB== \(payload)")
                  break
              }
          }
           
          // let's check if user is signedIn or not
           _ = Amplify.Auth.fetchAuthSession { (result) in
               do {
                   let session = try result.get()
                          
          // let's update UserData and the UI
               self.updateUserData(withSignInStatus: session.isSignedIn)
                          
               } catch {
                    print("Fetch auth session failed with error - \(error)")
              }
          }    
        print("Initialized Amplify");
      } catch {
        print("Could not initialize Amplify: \(error)")
      }
    }
    
    // signin with Cognito web user interface
    public func signIn() {
        _ = Amplify.Auth.signInWithWebUI(presentationAnchor: UIApplication.shared.windows.first!) { result in
            switch result {
            case .success(_):
                print("Sign in succeeded")
            case .failure(let error):
                print("Sign in failed \(error)")
            }
        }
    }
    
    // signout
    public func signOut() {
        _ = Amplify.Auth.signOut() { (result) in
            switch result {
            case .success:
                print("Successfully signed out")
            case .failure(let error):
                print("Sign out failed with error \(error)")
            }
        }
    }
    
    func updateUserData(withSignInStatus status : Bool) {
        DispatchQueue.main.async() {
            let userData : UserData = .shared
            userData.isSignedIn = status
        }
    }
}
