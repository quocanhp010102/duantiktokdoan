//
//  ProfileSearchViewController.swift
//  tiktokprojectmaxcode
//
//  Created by quocanhppp on 10/05/2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class ProfileSearchViewController: UIViewController {
    var user:User!
    var posts:[post] = []
    var useId = ""
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchUser()
        fetchMyPost()
        // Do any additional setup after loading the view.
    }
    func fetchMyPost(){
        //guard let uid = Auth.auth().currentUser?.uid else {return}
        Ref().databaseRoot.child("User-Posts").child(useId).observe(.childAdded) { snapshot in
            Api.Post.observerSinglePost(postId: snapshot.key) { post in
                print(post.postId)
                self.posts.append(post)
                self.collectionView.reloadData()
            }
        }
    }

    func fetchUser(){
        Api.User.observerUser(withId: useId) { user in
            self.user = user
            self.collectionView.reloadData()
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotodetail"{
            let detailVC = segue.destination as! detailViewController
            let postId = sender as! String
            detailVC.postId = postId
        }
    }

}
extension ProfileSearchViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostProfileCollectionViewCell", for: indexPath) as! PostProfileCollectionViewCell
        let post = posts[indexPath.item]
        cell.postt = post
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader{
            let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileHeaderCollectionReusableView", for: indexPath) as! ProfileHeaderCollectionReusableView
            if let user = self.user{
                headerViewCell.user = self.user
            }
            
            headerViewCell.setupView()
            return headerViewCell
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width / 3 - 2, height: size.height / 3 - 2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
extension ProfileSearchViewController:PostProfileCollectionViewCellDelegate{
    func goToDetailVC(postId: String) {
        performSegue(withIdentifier: "gotodetail", sender: postId)
    }
}
