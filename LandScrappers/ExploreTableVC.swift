//
//  ExploreTableVC.swift
//  LandScrappers
//
//  Created by Andy Trang on 11/17/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import SwiftKeychainWrapper

class ExploreTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource, GIDSignInUIDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var posts = [ExplorePosts]()
    private var filteredCompany = [ExplorePosts]()
    private var inSearchMode = false
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        //Closes keyboard
        searchBar.returnKeyType = UIReturnKeyType.done
        
        fetchUsers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    func fetchUsers() {
        //Snap allows you to turn collection of data into free objects
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            self.posts = []  //Clear out post array each time its loaded
            
            //Pull data from firebase
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
                        
                        //this will crash because of background thread, so lets call this on dispatch_async main thread
                        DispatchQueue.main.async(execute: {
                            self.tableView.reloadData()
                        })
                    }
                }
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode
        {
            return filteredCompany.count
        }
        return posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell
        {
            let post = posts[indexPath.row]
            let searchPost: ExplorePosts!
            
            if let img = ExploreTableVC.imageCache.object(forKey: post.imageURL as NSString){
                cell.configureCell(post: post, img: img)
            }
            else{
                cell.configureCell(post: post)
            }
            
            if inSearchMode{
                searchPost = filteredCompany[indexPath.row]
                cell.configureCell(post: searchPost)
            }
            else{
                searchPost = posts[indexPath.row]
                cell.configureCell(post: searchPost)
            }
    
            return cell
        }
        else{
            //empty cell
            return PostCell ()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = posts[indexPath.row]
        self.performSegue(withIdentifier: "ToExploreDetailsVC", sender: user)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ExploreDetailsVC {
            if let selection = sender as? ExplorePosts {
                destination.post = selection
            }
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            inSearchMode = false
            self.tableView.reloadData()
            view.endEditing(true)
        }
        else{
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            filteredCompany = posts.filter({$0.title.localizedStandardRange(of: lower) != nil}) //Needs more research

            self.tableView.reloadData()
        }
    }

}
