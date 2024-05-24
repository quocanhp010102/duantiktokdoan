//
//  detail2ViewController.swift
//  tiktokprojectmaxcode
//
//  Created by quocanhppp on 10/05/2024.
//

import UIKit

class detail2ViewController: UIViewController {

    @IBOutlet weak var collectionDetailView: UICollectionView!
    var postId = ""
    var postt = post()
    var user = User()
    override func viewDidLoad() {
        super.viewDidLoad()
 
        collectionDetailView.delegate = self
        collectionDetailView.dataSource = self
        loadPost()
        // Do any additional setup after loading the view.
    }
    func loadPost(){
        Api.Post.observerSinglePost(postId: postId) { post in
            guard let postUID = post.uid else {return}
            self.fetch(uid: postUID) {
                self.postt = post
                self.collectionDetailView.reloadData()
                
            }
        }
    }
    func fetch(uid:String, completion: @escaping () -> Void){
        Api.User.observerUser(withId: uid) { user in
            self.user = user
            completion()
        }
    }

   

}
extension detail2ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.post = postt
        cell.user = user
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
