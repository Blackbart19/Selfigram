//
//  ProfileViewController.swift
//  Selfigram
//
//  Created by lighthouselabs on 2017-04-12.
//  Copyright © 2017 lighthouselabs. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,
UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var profileimageview: UIImageView!

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        // 1: Create an ImagePickerController
        let pickerController = UIImagePickerController()
        
        // 2: Self in this line refers to this View Controller
        //    Setting the Delegate Property means you want to receive a message
        //    from pickerController when a specific event is triggered.
        pickerController.delegate = self
        
        if TARGET_OS_SIMULATOR == 1 {
            // 3. We check if we are running on a Simulator
            //    If so, we pick a photo from the simulator’s Photo Library
            // We need to do this because the simulator does not have a camera
            pickerController.sourceType = .photoLibrary
        } else {
            // 4. We check if we are running on an iPhone or iPad (ie: not a simulator)
            //    If so, we open up the pickerController's Camera (Front Camera, for selfies!)
            pickerController.sourceType = .camera
            pickerController.cameraDevice = .front
            pickerController.cameraCaptureMode = .photo
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            
            // 1. When the delegate method is returned, it passes along a dictionary called info.
            //    This dictionary contains multiple things that maybe useful to us.
            //    We are getting an image from the UIImagePickerControllerOriginalImage key in that dictionary
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                //2. To our imageView, we set the image property to be the image the user has chosen
                profileimageview.image = image
            
            //3. We remember to dismiss the Image Picker from our screen.
            dismiss(animated: true, completion: nil)
            }
        }
            
        // Preset the pickerController on screen
        self.present(pickerController, animated: true, completion: nil)    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = "yourName"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
