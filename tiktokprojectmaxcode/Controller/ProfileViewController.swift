//
//  ProfileViewController.swift
//  tiktokprojectmaxcode
//
//  Created by quocanhppp on 22/04/2024.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class ProfileViewController: UIViewController {
    @IBOutlet weak var profileCollection: UICollectionView!
    
    var user:User!
    var posts:[post] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        profileCollection.delegate = self
        profileCollection.dataSource = self
        fetchUser()
        fetchMyPost()
    }
    func fetchMyPost(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Ref().databaseRoot.child("User-Posts").child(uid).observe(.childAdded) { snapshot in
            Api.Post.observerSinglePost(postId: snapshot.key) { post in
                print(post.postId)
                self.posts.append(post)
                self.profileCollection.reloadData()
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Profile_DetailSegue"{
            let detailVC = segue.destination as! detailViewController
            let postId = sender as! String
            detailVC.postId = postId
        }
    }
    func fetchUser(){
        Api.User.observerProfileUser { user in
            self.user = user
            self.profileCollection.reloadData()
        }
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        Api.User.logOut()
    }
    
    
    @IBAction func editProfileDidTaped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editVC = storyboard.instantiateViewController(identifier: "editProfileViewController") as! editProfileViewController
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
}
extension ProfileViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
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
extension ProfileViewController:PostProfileCollectionViewCellDelegate{
    func goToDetailVC(postId: String) {
        performSegue(withIdentifier: "Profile_DetailSegue", sender: postId)
    }
}
