//
//  MenuViewController.swift
//  FarmInvasion
//
//  Created by Evgeny Shishko on 04/12/2018.
//  Copyright © 2018 Evgeny Shishko. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var userLabel: UILabel!
    static var user: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MenuViewController.user = UserDefaults.standard.string(forKey: "user")
        self.userLabel.text = MenuViewController.user

        let registered = UserDefaults.standard.bool(forKey: "registered")
        self.playButton.isEnabled = registered
        self.playButton.backgroundColor = registered ? UIColor(red: 95 / 255.0, green: 88 / 255.0, blue: 80 / 255.0, alpha: 1) : UIColor.gray

        self.playButton.superview!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(inactivePlayTapped)))
	}

    @IBAction func userTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Смени имя", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { nameField in
//            nameField.keyboardType = .alphabet
            nameField.autocapitalizationType = .words
        }

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { _ in
            if let username = alert.textFields?.first?.text {
                MenuViewController.user = username
                self.userLabel.text = MenuViewController.user
                UserDefaults.standard.set(MenuViewController.user, forKey: "user")
            }
        }))

        present(alert, animated: true, completion: nil)

//        self.register(sender)
    }

    @objc func inactivePlayTapped() {
        let alert = UIAlertController(title: "Внимание", message: "Необходимо зарегистрироваться", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Регистрация", style: .default, handler: { _ in
            self.register(self)
        }))

        present(alert, animated: true, completion: nil)
    }
	
	override func viewDidAppear(_ animated: Bool) {
		checkIfNameExists()
	}
	
	private func checkIfNameExists() {
		if let _ = UserDefaults.standard.string(forKey: UserDefaultKeys.playerName) {
			return
		} else {
			//performSegue(withIdentifier: "showChangeName", sender: nil)
		}
	}

    @IBAction func register(_ sender: Any) {
        let webFormVC = UIStoryboard(name: "Authorization", bundle: nil)
            .instantiateViewController(withIdentifier: String(describing: WebFormViewController.self)) as! WebFormViewController
        webFormVC.completeAuthorization = { (isAuthorized: Bool, user: User) in
            //TODO: logic
            print(isAuthorized)
            if !isAuthorized { return }

            MenuViewController.user = user.name + " " + user.surname
            UserDefaults.standard.set(true, forKey: "registered")
            UserDefaults.standard.set(MenuViewController.user, forKey: "user")
            UserDefaults.standard.synchronize()
            self.userLabel.text = MenuViewController.user
            self.playButton.isEnabled = true
            self.playButton.backgroundColor = UIColor(red: 95 / 255.0, green: 88 / 255.0, blue: 80 / 255.0, alpha: 1)
        }

        webFormVC.title = "Регистрация"
        let navController = UINavigationController(rootViewController: webFormVC)
        navController.title = "Регистрация"
        webFormVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(cancel))

        present(navController, animated: true, completion: nil)
    }

    @IBAction func changeName(_ sender: Any) {
		performSegue(withIdentifier: "showChangeName", sender: nil)
	}


    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
