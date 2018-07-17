////
////  AccountCreationView.swift
////  firetail
////
////  Created by Aaron Halvorsen on 7/16/18.
////  Copyright © 2018 Aaron Halvorsen. All rights reserved.
////
//
//import UIKit
//
//protocol AccountCreationViewAPI: class {
//    func showCreateAccount()
//    func showLogin()
//    func showAddEmail()
//    func showAddPhone()
//    func showChangePassword()
//}
//
//
//final class AccountCreationView: UIView {
//
//    var loginBaseView = UIView()
//    var createAccountBaseView = UIView()
//    var addEmailBaseView = UIView()
//    var addPhoneBaseView = UIView()
//    var changePasswordBaseView = UIView()
//
//    var login = UIButton()
//    var username = UILabel()
//    var continueButton = UIButton()
//    var createAccount = UILabel()
//    var textFields = [UITextField]()
//    let logo = UIImageView(image: #imageLiteral(resourceName: "logo98x95"))
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//
//
//        setupConstraints()
//    }
//
//    func setupConstraints() {
//
//        [loginBaseView, createAccountBaseView, addEmailBaseView, addPhoneBaseView, changePasswordBaseView].forEach { view in
//            addSubview(view)
//            view.translatesAutoresizingMaskIntoConstraints = false
//            view.topAnchor.constraint(equalTo: topAnchor).isActive = true
//            view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//            view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//            view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//            view.layoutMargins = UIEdgeInsets(top: 0, left: 38, bottom: 0, right: 38)
//            view.isHidden = true
//        }
//
//        createAccountBaseView.addSubview(logo)
//        logo.translatesAutoresizingMaskIntoConstraints = false
//        logo.centerXAnchor.constraint(equalTo: centerXAnchor)
//        logo.centerYAnchor.constraint(equalTo: topAnchor, constant: 100)
//
//
//
//
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
