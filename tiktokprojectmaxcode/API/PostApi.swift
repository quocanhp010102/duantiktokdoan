//
//  PostApi.swift
//  tiktokprojectmaxcode
//
//  Created by quocanhppp on 07/05/2024.
//

import Foundation
import ProgressHUD
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SDWebImage
class PostApi{
    func sharePost(encodedVideoURL: URL?, selectedPhoto: UIImage?, textView: UITextView, onSuccess:@escaping() -> Void,onError:@escaping(_ errorMessage:String) -> Void){
        let creadationData = Date().timeIntervalSince1970
        guard let uid = Auth.auth().currentUser?.uid else {return}
        if let encodedVideoURLUnwrapped = encodedVideoURL{
            let videoIdString = "\(NSUUID().uuidString).mp4"
            let storageRef = Ref().storageRoot.child("posts").child(videoIdString)
            let metadata = StorageMetadata()
            storageRef.putFile(from: encodedVideoURLUnwrapped,metadata: metadata){metadata , error in
                if error != nil{
                    ProgressHUD.failed(error!.localizedDescription)
                    return
                }
                storageRef.downloadURL(completion: {[self] videoUrl, error in
                    if error != nil{
                        ProgressHUD.failed(error!.localizedDescription)
                        return
                    }
                    guard let videoUrlString = videoUrl?.absoluteString else {return}
                    upLoadThumbnailImageToStorage(selectedPhoto: selectedPhoto) { postImageUrl in
                        let values = ["creationDate": creadationData,
                                   "imageUrl": postImageUrl,
                                   "videoUrl": videoUrlString,
                                      "description": textView.text!,
                                   "likes": 0,
                                    "view": 0,
                                      "commentCount": 0,
                                      "uid": uid] as [String:Any]
                        let postId = Ref().databaseRoot.child("Posts").childByAutoId()
                        postId.updateChildValues(values,withCompletionBlock: {err, ref in
                            if err != nil{
                                onError(err!.localizedDescription + "dsfsdfs")
                                return
                            }
                            guard let postKey = postId.key else {return}
                            Ref().databaseRoot.child("User-Posts").child(uid).updateChildValues([postKey: 1])
                            onSuccess()
                        })
                    }
                })
            }
            
        }
    }
    func upLoadThumbnailImageToStorage(selectedPhoto: UIImage?, completion: @escaping (String) -> ()){
        if let thumbnailImage = selectedPhoto, let imageData = thumbnailImage.jpegData(compressionQuality: 0.3){
            let photoIdString = NSUUID().uuidString
            let storageRef = Ref().storageRoot.child("post_images").child(photoIdString)
            storageRef.putData(imageData, completion: {metaData, error in
                if error != nil{
                    ProgressHUD.failed(error!.localizedDescription)
                    return
                }
                storageRef.downloadURL(completion: {imageUrl,error in
                    if error != nil{
                        ProgressHUD.failed(error!.localizedDescription)
                        return
                    }
                    guard let postImageUrl = imageUrl?.absoluteString else {return}
                    completion(postImageUrl)
                })
            })
        }
    }
    func observerSinglePost(postId id : String, completion: @escaping (post) -> Void){
        Ref().databaseRoot.child("Posts").child(id).observeSingleEvent(of: .value) { snapshot in
            if let dict = snapshot.value as? [String:Any]{
                let newPost = post.transformPostVideo(dict: dict, key: snapshot.key)
                completion(newPost)
            }
        }
    }
    func observerPost(completion: @escaping (post) -> Void){
        Ref().databaseRoot.child("Posts").observe(.childAdded) { snapshot in
            if let dict = snapshot.value as? [String:Any]{
                let newPost = post.transformPostVideo(dict: dict, key: snapshot.key)
                completion(newPost)
            }
        }
    }
//    func observerDetailPost(withId id:String,completion: @escaping (post) -> Void){
//        Ref().databaseRoot.child("Posts").child(id).observeSingleEvent(of: .value) { snapshot in
//            <#code#>
//        }
//    }
    
    func observeFeedPosts(completion: @escaping (post) -> Void){
        Ref().databaseRoot.child("Posts").observeSingleEvent(of: .value) { snapshot in
            let arraySnapshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            arraySnapshot.forEach { child in
                if let dict = child.value as? [String: Any]{
                    let post = post.transformPostVideo(dict: dict, key: child.key)
                    completion(post)
                }
            }
            
        }
    }
}
extension UIImageView{
    func loadImage(_ urlString:String?,onSuccess:((UIImage) -> Void)? = nil){
        self.image = UIImage()
        guard let string = urlString else {return}
        guard let url = URL(string: string) else {return}
        
        self.sd_setImage(with: url){image, error, type, url in
            if onSuccess != nil, error == nil {
                onSuccess!(image!)
            }
            
        }
    }
}
