//
//  EditStoryViewController.swift
//  MyTimeLine
//
//  Created by Hans Jiang on 2018/3/5.
//  Copyright © 2018年 Hans Jiang. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import NVActivityIndicatorView

protocol AddStoryDelegate {
    func addStoryComplete()
}

protocol EditStoryDelegate {
    func editStoryComplete()
}

class EditStoryViewController:  UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate ,NVActivityIndicatorViewable, UITextViewDelegate{

    @IBOutlet weak var addStoryButton: UIButton!
    @IBOutlet weak var addStoryCancelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addStoryImageView: UIImageView!
    @IBOutlet weak var addStoryDatePickerLabel: UILabel!
    private var currentTextField: UITextField?
    var tempImageURL: String?
    var refStory: DatabaseReference!
    private var isKeyboardShown = false
    
    var date: Date?
    
    @IBOutlet weak var addStoryContentTexeView: UITextView!
    private var currentTextView: UITextView?
    @IBOutlet weak var datepickerButton: UIButton!
  
    var addStoryDelegate: AddStoryDelegate?
    var editStoryDelegate: EditStoryDelegate?
    
    var EditStory: Story!
    var EditImageView: UIImage!
    var isEditStory = false
    
    
    // 建立一個 UIImagePickerController 的實體
    let imagePickerController = UIImagePickerController()
  
    // 建立一個 UIAlertController 的實體
    // 設定 UIAlertController 的標題與樣式為 動作清單 (actionSheet)
    let imagePickerAlertController = UIAlertController(title: "上傳圖片", message: "請選擇要上傳的圖片", preferredStyle: .actionSheet)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NVActivityIndicatorView.DEFAULT_TYPE = .ballBeat
        NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 100, height: 100)
      
        
        refStory = Database.database().reference().child("story");
        pageInit()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil)
        
    }

    func pageInit(){
        self.startAnimating()
        
        initImagePickerController()
        
        if(EditStory != nil)
        {
            addStoryContentTexeView.text = EditStory.Story
        }
        
        
        
        if(EditImageView != nil){
            addStoryImageView.image = EditStory.StoryImage
        }
        
        if(isEditStory)
        {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy/MM/dd"
            let string1 = EditStory.StoryDate
            addStoryDatePickerLabel.text = string1
            date = dateformatter.date(from: string1!)
            
        }else{
            date = Date()
        }
        
        self.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
         currentTextView = textView
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //取消
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        addStoryDelegate?.addStoryComplete()
    }

    @IBAction func datePickerPressed(_ sender: UIButton) {
        DatePickerView.presentPicker(sender, defaultDate: date, minimum: false) { (date) in
            self.date = date
           
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let dateString = dateFormatter.string(from: date)
            self.addStoryDatePickerLabel.text = dateString
            
        }
    }
    
    //上傳
    @IBAction func okPressed(_ sender: Any) {
        self.startAnimating()
        self.UploadImage(image: addStoryImageView)
        self.stopAnimating()
    }
    
    func initImagePickerController(){
        
        // 委任代理
        imagePickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        // 建立三個 UIAlertAction 的實體
        // 新增 UIAlertAction 在 UIAlertController actionSheet 的 動作 (action) 與標題
        let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (Void) in
            
            // 判斷是否可以從照片圖庫取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.photoLibrary)，並 present UIImagePickerController
                self.imagePickerController.sourceType = .photoLibrary
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
        }
        let imageFromCameraAction = UIAlertAction(title: "相機", style: .default) { (Void) in
            
            // 判斷是否可以從相機取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.camera)，並 present UIImagePickerController
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
        }
        
        // 新增一個取消動作，讓使用者可以跳出 UIAlertController
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (Void) in
            
            self.imagePickerAlertController.dismiss(animated: true, completion: nil)
        }
        
        // 將上面三個 UIAlertAction 動作加入 UIAlertController
        imagePickerAlertController.addAction(imageFromLibAction)
        imagePickerAlertController.addAction(imageFromCameraAction)
        imagePickerAlertController.addAction(cancelAction)
        
    }
    
    //選擇照片按鈕
    @IBAction func SelectImageButton(_ sender: Any) {
        // 當使用者按下 uploadBtnAction 時會 present 剛剛建立好的三個 UIAlertAction 動作與
        present(imagePickerAlertController, animated: true, completion: nil)
    }
    
    
    func UploadImage( image: UIImageView)
    {
        if(image.image == nil)
        {
            print("圖片還沒選")
            return
        }
        
        if(addStoryContentTexeView.text == nil)
        {
            print("故事內容還沒寫")
            return
            
        }

        
        // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
        var uniqueString = NSUUID().uuidString
        if(isEditStory)
        {
            uniqueString = EditStory.id!
        }
        
        let storageRef = Storage.storage().reference().child("AppCodaFireUpload").child("\(uniqueString).jpge")
        if let uploadData = UIImageJPEGRepresentation(image.image!, 0.1) {
            // 這行就是 FirebaseStorage 關鍵的存取方法。
            storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in
                if error != nil {
                    // 若有接收到錯誤，我們就直接印在 Console 就好，在這邊就不另外做處理。
                    print("Error: \(error!.localizedDescription)")
                   
                    return
                }
                
                // 連結取得方式就是：data?.downloadURL()?.absoluteString。
                if let uploadImageUrl = data?.downloadURL()?.absoluteString {
                    self.tempImageURL = uploadImageUrl
                    // 我們可以 print 出來看看這個連結事不是我們剛剛所上傳的照片。
                    print("Photo Url: \(uploadImageUrl)")
                    
                    //上傳Database
                    let databaseRef = Database.database().reference().child("AppCodaFireUpload").child(uniqueString)
                    databaseRef.setValue(uploadImageUrl, withCompletionBlock: { (error, dataRef) in
                        
                        if error != nil {
                            
                            print("Database Error: \(error!.localizedDescription)")
                            
                        }
                        else {
                            
                            print("圖片已儲存")
                            
                            //generating a new key inside artists node
                            //and also getting the generated key
                            var key = self.refStory.childByAutoId().key
                            if(self.isEditStory)
                            {
                                key = self.EditStory.id!
                            }
                            
                            let dateformatter = DateFormatter()
                            dateformatter.dateFormat = "YYYY/MM/dd"
                            let customDate = dateformatter.string(from: self.date!)
                            
                            //creating artist with the given values
                            let story = ["id":key,
                                         "UploadUser": "HansJiang",
                                         "Story": self.addStoryContentTexeView.text! as String,
                                         "ImageURL": uploadImageUrl,
                                         "StoryDate": customDate as String,
                                         ]
                            
                            //adding the artist inside the generated unique key
                            self.refStory.child(key).setValue(story) { (error, ref) in
                                if error != nil{
                                    print(error!)
                                   
                                }else{
                                    print("update OK!")
                                    self.addStoryDelegate?.addStoryComplete()
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }
                        }
                        
                    })
                }
            })
        }
        
      
    }
    
    // MARK: ImagePicker Delegate 选择图片成功后代理  圖片暫存
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let chosenImage =  info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true) {
                self.addStoryImageView.image = chosenImage
            }
        }
    }
    
    

    @objc func keyboardWillShow(note: NSNotification) {
        if isKeyboardShown {
            return
        }
        
        let keyboardAnimationDetail = note.userInfo as! [String: AnyObject]
        let duration = TimeInterval(truncating: keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey]! as! NSNumber)
        let keyboardFrameValue = keyboardAnimationDetail[UIKeyboardFrameBeginUserInfoKey]! as! NSValue
        let keyboardFrame = keyboardFrameValue.cgRectValue
        
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -keyboardFrame.size.height)
        })
        isKeyboardShown = true
    }
    
    @objc func keyboardWillHide(note: NSNotification) {
        let keyboardAnimationDetail = note.userInfo as! [String: AnyObject]
        let duration = TimeInterval(truncating: keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey]! as! NSNumber)
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -self.view.frame.origin.y)
        })
        isKeyboardShown = false
    }
    
}


