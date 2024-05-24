//
//  Ref.swift
//  tiktokprojectmaxcode
//
//  Created by quocanhppp on 17/04/2024.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import ProgressHUD
let REF_USER = "users"
let STORAGE_PROFILE = "profile"
let USER_STORAGE_ROOT = "gs://tiktokproject-b81c3.appspot.com"
let EMAIL = "email"
let UID = "uid"
let USERNAME = "username"
let PROFILE_IMAGE_URL = "profileImageUrl"
let STATUS = "status"
let INDENTIFIER_TABBAR = "TabbarVC"
let INDENTIFIER_MAIN = "MainVC"
class Ref{
    let databaseRoot = Database.database(url: "https://tiktokproject-b81c3-default-rtdb.firebaseio.com/").reference()
    var databaseUser:DatabaseReference {
        return databaseRoot.child(REF_USER)
    }
    func databaseSpesificUsers(uid: String) -> DatabaseReference{
        return databaseUser.child(uid)
    }
    //Storage Ref
    let storageRoot = Storage.storage().reference(forURL: USER_STORAGE_ROOT)
    var storageProfile:StorageReference {
        return storageRoot.child(STORAGE_PROFILE)
    }
    func storageSpesificUsers(uid:String) -> StorageReference{
        return storageProfile.child(uid)
    }
}
