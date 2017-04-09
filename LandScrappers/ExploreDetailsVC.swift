//
//  ExploreDetailsVC.swift
//  LandScrappers
//
//  Created by Andy Trang on 1/17/17.
//  Copyright © 2017 AlwaysOnAlpha. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ExploreDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableSelect: UITableView!
    @IBOutlet weak var imageOther: CircleView!
    @IBOutlet weak var otherTitle: UILabel!
    @IBOutlet weak var otherLocation: UILabel!
    @IBOutlet weak var otherDistance: UILabel!
    
    private var _post: ExplorePosts!
    private var formRequest: FormData!
    private var formData = [FormData]()
    
    private var selectServices = Dictionary<String, FormData>()
    
    var post: ExplorePosts {
        get {
            return _post
        } set {
            _post = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableSelect.delegate = self
        tableSelect.dataSource = self
        tableSelect.allowsMultipleSelection = true
        
        showUserDetails()
        observeServices()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let ref = FIRStorage.storage().reference(forURL: post.imageURL)
        
        ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in  //2mb
            if error != nil
            {
                print("ANDREW: Unable to download image from Firebase storage")
            }
            else
            {
                print("ANDREW: Image downloaded from Firebase storage and saving to cache")
                if let imgData = data
                {
                    if let img = UIImage(data: imgData)
                    {
                        self.imageOther.image = img
                        ExploreTableVC.imageCache.setObject(img, forKey: self.post.imageURL as NSString)
                    }
                }
            }
        })
    }
    
    func showUserDetails()
    {
        otherTitle.text = post.title
        otherLocation.text = post.userlocation
    }
    
    func observeServices() {
        let toID = post.postKey
        let ref = DataService.ds.REF_SERVICE.child(toID)
        
        ref.queryOrdered(byChild: "services").observe(.value, with: { (snapshot) in
            
            self.formData = []
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SnapValue: \(snap)")
                    if let dict = snap.value as? [String: AnyObject] {
                        print("SnapValue: \(dict)")
                        let list = FormData(formKey: snap.key, formData: dict, snapshot: snap)
                        self.formData.append(list)
                    }
                }
            }
            self.tableSelect.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let form = formData[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FormInteract") as? FormCell {
            cell.configureCell(form: form)
            return cell
        } else {
            return FormCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FormInteract
        cell.setCheckMark(selected: true)
        let service = formData[indexPath.row]
        selectServices[service.formKey] = service
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FormInteract
        cell.setCheckMark(selected: false)
    }
    
    @IBAction func blueBtnPressed(_ sender: AnyObject) {
        formRequest.adjustService(sendingTo: self.selectServices)
    }
}
