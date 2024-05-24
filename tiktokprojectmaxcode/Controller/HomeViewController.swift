//
//  HomeViewController.swift
//  tiktokprojectmaxcode
//
//  Created by quocanhppp on 07/05/2024.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeCollectionView: UICollectionView!
    var posts = [post]()
    var users = [User]()
    @objc dynamic var currentIndex = 0
    var oldAndNewIndices = (0,0)
    override func viewDidLoad() {
        super.viewDidLoad()
        homeCollectionView.automaticallyAdjustsScrollIndicatorInsets = false
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        loadPosts()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if let cell = homeCollectionView.visibleCells.first as? HomeCollectionViewCell{
            cell.pause()
        }
       
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
        navigationController?.setNavigationBarHidden(false, animated: animated)
      
    }

    func loadPosts(){
//        Api.Post.observerPost { post in
//            guard let postId = post.uid  else {return}
//            self.fetchUser(uid: postId) {
//                self.posts.append(post)
//                self.posts.sort { post1, post2 in
//                    return post1.creationDate! > post2.creationDate!
//                }
//                self.homeCollectionView.reloadData()
//            }
//        }
        Api.Post.observeFeedPosts { post in
            guard let postId = post.uid  else {return}
            self.fetchUser(uid: postId) {
                self.posts.append(post)
                self.posts.sort { post1, post2 in
                    return post1.creationDate! > post2.creationDate!
                }
                self.homeCollectionView.reloadData()
            }
        }
        print("post : ")
        print(posts)
    }
    func fetchUser(uid:String, completed:@escaping () -> Void){
        Api.User.observerUser(withId: uid) { user in
            self.users.append(user)
            completed()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "home_show_profile"{
            let ProfileUserVC = segue.destination as! ProfileSearchViewController
            let userId = sender as! String
            ProfileUserVC.useId = userId
        }
    }

}
extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        let post = posts[indexPath.item]
        let user = users[indexPath.item]
        cell.post = post
        cell.user = user
        cell.delegate = self
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
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? HomeCollectionViewCell{
            oldAndNewIndices.1 = indexPath.item
            currentIndex = indexPath.item
            cell.pause()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? HomeCollectionViewCell{
            cell.stop()
        }
    }
}
extension HomeViewController: UIScrollViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let cell = self.homeCollectionView.cellForItem(at: IndexPath(row: self.currentIndex, section: 0)) as? HomeCollectionViewCell
        cell?.replay()
    }
}
extension HomeViewController:HomeCollectionViewCellDelegate{
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "home_show_profile", sender: userId)
    }
}
