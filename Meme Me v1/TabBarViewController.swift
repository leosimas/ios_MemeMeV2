//
//  TabBarViewController.swift
//  Meme Me v2
//
//  Created by SoSucesso on 24/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sent Memes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createMeme))
    }
    
    func createMeme() {
        MemeEditorViewController.open(controller: self)
    }

}
