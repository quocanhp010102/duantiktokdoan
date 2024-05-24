//
//  PeopleTableViewController.swift
//  tiktokprojectmaxcode
//
//  Created by quocanhppp on 10/05/2024.
//

import UIKit

class PeopleTableViewController: UITableViewController,UISearchResultsUpdating {

    var users: [User] = []
    var searchController:UISearchController = UISearchController(searchResultsController: nil)
    var searchResults:[User] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUser()
        setupSearchController()
    }

    func fetchUser(){
        Api.User.observeUser2 { user in
            self.users.append(user)
            self.tableView.reloadData()
        }
    }
    func setupSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "search user ...."
        searchController.searchBar.barTintColor = UIColor.white
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text)
        if searchController.searchBar.text == nil || searchController.searchBar.text!.isEmpty{
            view.endEditing(true)
            
        }else{
            let textLowercased = searchController.searchBar.text!.lowercased()
            filterContent(for: textLowercased)
        }
        tableView.reloadData()
    }
    func filterContent(for searchText:String){
        
        searchResults = self.users.filter{
            return $0.username?.lowercased().range(of: searchText) != nil
        }
    }
    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if searchController.isActive{
//            return searchResults.count
//        }else{
//            return self.users.count
//        }
        return searchController.isActive ? searchResults.count : self.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath) as! PeopleTableViewCell
         
        let user = searchController.isActive ? searchResults[indexPath.row] : users[indexPath.row]

        cell.user = user
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? PeopleTableViewCell{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileSearchVC = storyboard.instantiateViewController(withIdentifier: "ProfileSearchViewController") as! ProfileSearchViewController
            profileSearchVC.useId = cell.user!.uid!
            self.navigationController?.pushViewController(profileSearchVC, animated: true)
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
