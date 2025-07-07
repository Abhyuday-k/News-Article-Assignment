//
//  DynmaicTextField.swift
//  Assignment-String-Calculator
//
//  Created by abh on 30/06/25.
//

import UIKit

protocol DynamicTextFieldDelegate:NSObjectProtocol{
    func userUpdatedInput(value:String)
    func clickedOnLogin()
    func clickedOnSyncData()
}


class DynamicTextField: UITableViewCell {

    @IBOutlet weak var btnSync: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var lblFieldTitle: UILabel!
    @IBOutlet weak var txtField: UITextField!
    weak var vwParentForController:UIView?
    weak var delegate:DynamicTextFieldDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.txtField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func configureCell(){
        self.lblFieldTitle.text = "User Name"
        self.txtField.isHidden = false
        self.txtField.keyboardType = .numbersAndPunctuation
        self.lblError.isHidden = true
        self.buttonForKeyboardDismisal()
        self.btnLogin.layer.cornerRadius = 12
        self.btnLogin.layer.masksToBounds = true
        self.btnSync.layer.cornerRadius = 12
        self.btnSync.layer.masksToBounds = true
    }
    
    func buttonForKeyboardDismisal() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let doneButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelButtonTapped))

        toolbar.items = [flexSpace, doneButton]
        self.txtField.inputAccessoryView = toolbar
    }

    @objc func cancelButtonTapped() {
        self.vwParentForController?.endEditing(true)
    }
    
    func isShowError(){
        self.lblError.isHidden = true
        if (self.txtField.text ?? "").isEmpty{
            self.lblError.text = "User name field cannot be empty"
            self.lblError.isHidden = false
        }
    }
    
    @IBAction func clickedOnSync(_ sender: Any) {
        self.delegate?.clickedOnSyncData()
    }
    @IBAction func clickedOnLogin(_ sender: Any) {
        self.delegate?.clickedOnLogin()
    }
    @objc func textFieldDidChange(_ textField: UITextField){
        self.delegate?.userUpdatedInput(value: textField.text ?? "")
    }
}


