//
//  UserApi.swift
//  tiktokprojectmaxcode
//
//  Created by quocanhppp on 17/04/2024.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import ProgressHUD
class UserApi {
    func signIn(email: String,password: String,onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void){
        Auth.auth().signIn(withEmail: email, password: password){authData, error in
            if error != nil {
                onError(error!.localizedDescription + "sdfsdfs")
                return
            }
            print(authData?.user.uid)
            onSuccess()
        }
        
    }
    func signUp(withUsername username:String,email:String,password:String,image:UIImage?,onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void){
        guard let imageSelected = image else {
            print("image is nil")
            return
        }
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {return}
        Auth.auth().createUser(withEmail: email, password: password){
            authDataResult, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            if let authData = authDataResult {
                print(authData.user.email)
                var dict:Dictionary<String, Any> = [
                    UID: authData.user.uid,
                    EMAIL: email,
                    PROFILE_IMAGE_URL:"",
                    STATUS:"",
                    USERNAME:username
                    
                ]
//                let storageRef = Storage.storage().reference(forURL: "gs://tiktokproject-b81c3.appspot.com")
                //let storageProfileRef = storageRef.child("profile").child(authData.user.uid)
                let storageProfileRef = Ref().storageSpesificUsers(uid: authData.user.uid)
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpg"
                StorageService.savePhoto(username: username, uid: authData.user.uid, data: imageData, metadata: metaData, StorageProfileRef: storageProfileRef, dict: dict){
                    onSuccess()
                }onError: { errorMessage in
                    ProgressHUD.failed(errorMessage)
                }
             
                
            }
        }
    }
    func saveUserProfile(dict: Dictionary<String,Any>,onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Ref().databaseRoot.child("users").child(uid).updateChildValues(dict){ error, dataRef in
            if error != nil {
                onError(error!.localizedDescription + "sdfsdsdd")
                return
            }
            onSuccess()
            
        }
        
    }
    func observerUser(withId uid:String, completion:@escaping (User) -> Void){
        Ref().databaseRoot.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            if let dict = snapshot.value as? [String:Any]{
                let user = User.transformPostVideo(dict: dict, key: snapshot.key)
                completion(user)
            }
        }
    }
    func observeUser2(completion:@escaping (User) -> Void){
        Ref().databaseRoot.child("users").observe(.childAdded) { snapshot in
            if let dict = snapshot.value as? [String:Any]{
                let user = User.transformPostVideo(dict: dict, key: snapshot.key)
                completion(user)
            }
        }
    }
    func observerProfileUser(completion:@escaping (User) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Ref().databaseRoot.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            if let dict = snapshot.value as? [String:Any]{
                let user = User.transformPostVideo(dict: dict, key: snapshot.key)
                completion(user)
            }
        }
    }
    func logOut(){
        do {
            try Auth.auth().signOut()
        }catch{
            ProgressHUD.failed(error.localizedDescription)
            return
        }
        let scene = UIApplication.shared.connectedScenes.first
        if let sd:SceneDelegate = (scene?.delegate as? SceneDelegate){
            sd.configInitiaViewController()
        }
    }
    func deleteAccount(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let storage = Ref().storageRoot
        let ref = Ref().databaseRoot
        
        ref.child("users").child(uid).removeValue{
            error , ref in
            if error != nil {
                ProgressHUD.failed()
            }
        }
        Auth.auth().currentUser?.delete{ error in
            if error != nil {
                ProgressHUD.failed()
            }
        }
        let profileRef = storage.child("profile").child(uid)
        profileRef.delete{error in
            if error != nil{
                ProgressHUD.failed()
            }else {
                ProgressHUD.succeed()
            }
        }
    }
}
