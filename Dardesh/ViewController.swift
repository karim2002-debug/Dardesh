//
//  ViewController.swift
//  Dardsha
//
//  Created by Macbook on 15/09/2024.
//

import UIKit
//import FirebaseAuth
//import FirebaseFirestore
//import FirebaseDatabase
//import Firebase
import Firebase
import FirebaseAuth
class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
}

extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fromCell", for: indexPath) as! FormCell
        
        if indexPath.row == 0{ // sign in
            
            cell.userNameContainer.isHidden = true
            cell.actionButton.setTitle("Login", for: .normal)
            cell.slideButton.setTitle("Sign up 👉🏻", for: .normal)
            cell.slideButton.addTarget(self, action: #selector(slideToSignUp), for: .touchUpInside)
            cell.actionButton.addTarget(self, action: #selector(didTapedLoginButton), for: .touchUpInside)
            
        }else if indexPath.row == 1{ // sign up
            cell.userNameContainer.isHidden = false
            cell.actionButton.setTitle("Sign up", for: .normal)
            cell.slideButton.setTitle("Sign In 👈🏻", for: .normal)
            cell.slideButton.addTarget(self, action: #selector(slideToSignIn), for: .touchUpInside)
            cell.actionButton.addTarget(self, action: #selector(didTapedSignUpButton), for: .touchUpInside)
            
        }
        return cell
    }
    @objc func didTapedLoginButton(){
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = collectionView.cellForItem(at: indexPath)as! FormCell
        
        guard let email = cell.emailTextField.text , let password = cell.passwordTextField.text else{
            return
        }
        if email.isEmpty == true || password.isEmpty == true{
            displayError(error: "Email or Password is empty")
        }else{
            
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error{
                    print(error)
                }else{
                    self.dismiss(animated: true)
                    print(result?.user.uid)
                    
                }
            }
        }
        
    }
   private func displayError(error : String){
        
       let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
       let action = UIAlertAction(title: "Done", style: .default)
       alert.addAction(action)
       present(alert, animated: true)
    }
    @objc func didTapedSignUpButton(){
        
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = collectionView.cellForItem(at: indexPath)as! FormCell
        
        guard let userEmail = cell.emailTextField.text , let userPassword = cell.passwordTextField.text else{
            return
        }
        
        if userEmail.isEmpty == true || userPassword.isEmpty == true || cell.userNameTextField.text?.isEmpty == true {
            displayError(error: "Email or Password is empty")
        }else{
            
            Auth.auth().createUser(withEmail: userEmail, password: userPassword) { result, error in
                if let error = error{
                    print(error)
                }
                self.dismiss(animated: true)
                guard let userID = result?.user.uid , let userName = cell.userNameTextField.text else{
                    return
                    
                }
                let ref = Database.database().reference()
                let user = ref.child("users").child(userID)
                let dataArray : [String : Any] = ["userName" : userName]
                user.setValue(dataArray)
                
            }
        }
    }
    @objc func slideToSignUp(){
        let indexPath = IndexPath(row: 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
    }
    @objc func slideToSignIn(){
        let indexPath = IndexPath(row: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    
}
