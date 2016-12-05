//
//  ExploreTableVC.swift
//  LandScrappers
//
//  Created by Andy Trang on 11/17/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

/*import UIKit
import FBSDKLoginKit
import SwiftKeychainWrapper

class ExploreTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource, GIDSignInUIDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var posts = [ExplorePosts]()
    var filteredPost = [ExplorePosts]()
    var imagePicker: UIImagePickerController!
    var usersArray = [NSDictionary?]()
    var filteredUsers = [NSDictionary?]()
    var inSearchMode = false
    
    let searchController = UISearchController(searchResultsController: nil)
    var databaseRef = FIRDatabase.database().reference()
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Creating search controller manually
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = false
        tableView.tableHeaderView = searchController.searchBar
        
        databaseRef.child("posts").queryOrdered(byChild: "title").observe(.childAdded, with: {(snapshot)
            in self.usersArray.append(snapshot.value as? NSDictionary)
            
            self.tableView.insertRows(at: [IndexPath(row: self.usersArray.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
            
        }) {(error) in
            print(error.localizedDescription)
        }
        
        //Snap allows you to turn collection of data into free objects
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            self.posts = []  //Clear out post array each time its loaded
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot]
            {
                for snap in snapshot
                {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject>
                    {
                        let key = snap.key
                        let post = ExplorePosts(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredUsers.count
        }
        return self.usersArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let user: NSDictionary?
        let post: ExplorePosts! //posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell
        {
            if searchController.isActive && searchController.searchBar.text != "" {
                user = filteredUsers[indexPath.row]
                cell.configureCell(post: post)
            }
            else
            {
                user = self.usersArray[indexPath.row]
                cell.configureCell(post: post)
            }
            
            if let img = ExploreTableVC.imageCache.object(forKey: post.imageURL as NSString){
                cell.configureCell(post: post, img: img)
            }
            else
            {
                cell.configureCell(post: post)
            }
            
            cell.textLabel?.text = user?["title"] as? String
            cell.detailTextLabel?.text = user?["handle"] as? String
            
            return cell
        }
        else {
            //empty cell
            return PostCell ()
        }
    }
    
    @IBAction func logOutPressed(_ sender: AnyObject)
    {
        let keyChainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)  //Remove keychain
        let loginManager = FBSDKLoginManager()  //Logout Facebook
        loginManager.logOut()
        GIDSignIn.sharedInstance().signOut()    //Logout Google
        try! FIRAuth.auth()!.signOut()          //Logout Firebase
        
        //Setting rootcontroller back to LoginVC and communicate with Appdelegate
        let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginVCID") as! LoginVC
        let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.rootViewController = signInPage
        
        print("Andrew: ID removed from keychain \(keyChainResult)")
        dismiss(animated: true, completion: nil)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: self.searchController.searchBar.text!)
    }
    
    func filterContent(searchText: String)
    {
        self.filteredUsers = self.usersArray.filter{ user in
            
            let username = user!["title"] as? String
            
            return(username?.lowercased().contains(searchText.lowercased()))!
        }
        
        tableView.reloadData()
    }
}*/
