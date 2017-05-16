//
//  FeedViewController.swift
//  Selfigram
//
//  Created by lighthouselabs on 2017-04-24.
//  Copyright © 2017 lighthouselabs. All rights reserved.
//

import UIKit
import Parse


class FeedViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var posts = [Post]()
    
    
    func getPosts() {
    if let query = Post.query() {
        query.order(byDescending: "createdAt")
        query.includeKey("user")
        
        query.findObjectsInBackground(block: { (posts, error) -> Void in
            self.refreshControl?.endRefreshing()
            
            if let posts = posts as? [Post]{
                self.posts = posts
                self.tableView.reloadData()
            }
        })
        }
    }
    
    @IBAction func doubleTappedSelfie(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: tableView)
                if let indexPathAtTapLocation = tableView.indexPathForRow(at: tapLocation){
                    let cell = tableView.cellForRow(at:indexPathAtTapLocation) as! SelfieCell
                    cell.tapAnimation()
                print("double tapped selfie")
                }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: UIImage(named: "Selfigram-logo"))
        getPosts()
    }
    
    @IBAction func refreshPulled(_ sender: UIRefreshControl) {
        getPosts()
    }
    
    
    
// Old Code:
//        let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=3b03572f61e309a68797eafc4799762f&tags=cat")!
//            
//        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
//        
//            // convert Data to JSON
//            if let jsonUnformatted = try? JSONSerialization.jsonObject(with: data!, options: []) {
//             
//            let json = jsonUnformatted as? [String : AnyObject]
//            let photosDictionary = json?["photos"] as? [String : AnyObject]
//            if let photosArray = photosDictionary?["photo"] as? [[String : AnyObject]] {
//            
//                for photo in photosArray {
//                    
//                    if let farmID = photo["farm"] as? Int,
//                        let serverID = photo["server"] as? String,
//                        let photoID = photo["id"] as? String,
//                        let secret = photo["secret"] as? String {
//                        
//                        let photoURLString = "https://farm\(farmID).staticflickr.com/\(serverID)/\(photoID)_\(secret).jpg"
//                        print(photoURLString)
//                        if let photoURL = URL(string: photoURLString) {
//                            
//                            let me = User(aUsername: "sam", aProfileImage: UIImage(named: "Grumpy-Cat")!)
//                            let post = Post(imageURL: photoURL, user: me, comment: "A Flickr Selfie")
//                            self.posts.append(post)
//                            }
//                        }
//                }
//                
//                    // We use OperationQueue.main because we need update all UI elements on the main thread.
//                    // This is a rule and you will see this again whenever you are updating UI.
//                    OperationQueue.main.addOperation {
//                        self.tableView.reloadData()
//                    }
//                }
//                
//            }else{
//                print("error with response data")
//            }
//        })
//        
//        task.resume()
//        
//        print ("outside dataTaskWithURL")

        // UIImage has an initializer where you can pass in the name of an image in your project to create an UIImage
        // UIImage(named: "Grumpy-Cat") can return nil if there is no image called "grumpy-cat" in your project
        // Our definition of Post did not include the possibility of a nil UIImage
        // so, therefore we have to add a ! at the end of it

//        let me = User(aUsername: "danny", aProfileImage: UIImage(named: "Grumpy-Cat")!)
//        let post0 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 0")
//        let post1 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 1")
//        let post2 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 2")
//        let post3 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 3")
//        let post4 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 4")
//        posts = [post0, post1, post2, post3, post4]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//Old Code

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! SelfieCell
        let post = self.posts[indexPath.row]
        cell.post = post
        
        return cell
    }

    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        if TARGET_OS_SIMULATOR == 1 {
            pickerController.sourceType = .photoLibrary
        } else {
            pickerController.sourceType = .camera
            pickerController.cameraDevice = .front
            pickerController.cameraCaptureMode = .photo
        }
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : Any]) {
        
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                if let imageData = UIImageJPEGRepresentation(image, 0.9),
                    let imageFile = PFFile(data: imageData),
                    let user = PFUser.current() {
                    
                    
                    let post = Post(image: imageFile, user: user, comment: "A Selfie")
                    
                    
                    post.saveInBackground(block: { (success, error) -> Void in
                        if success {
                            print("Post successfully saved in Parse")
                            
                            self.posts.insert(post, at: 0)
                            
                            let indexPath = IndexPath(row: 0, section: 0)
                            self.tableView.insertRows(at: [indexPath], with: .automatic)
                            
                        }
                    })
                }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
        // Notes:
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //photo url - https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
    //example photo url - https://farm5.staticflickr.com/4163/33594881374_51035d9a33.jpg
    //https://www.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=3b03572f61e309a68797eafc4799762f&tags=cats
    
}
