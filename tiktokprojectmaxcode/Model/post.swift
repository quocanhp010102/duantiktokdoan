//
//  post.swift
//  tiktokprojectmaxcode
//
//  Created by quocanhppp on 08/05/2024.
//

import Foundation

class post{
    var uid:String?
    var postId:String?
    var imageUrl:String?
    var videoUrl:String?
    var description:String?
    var creationDate:Date?
    var likes:Int?
    var view:Int?
    var commentCount:Int?
    
    static func transformPostVideo(dict: Dictionary<String,Any>, key:String) -> post{
        let post = post()
        post.postId = key
        post.uid = dict["uid"] as? String
        post.imageUrl = dict["imageUrl"] as? String
        post.videoUrl = dict["videoUrl"] as? String
        post.description = dict["description"] as? String
        
        post.likes = dict["likes"] as? Int
        post.view = dict["view"] as? Int
        post.commentCount = dict["commentCount"] as? Int
        let creationDate = dict["creationDate"] as? Double ?? 0
        post.creationDate = Date(timeIntervalSince1970: creationDate)
        return post
    }
}
