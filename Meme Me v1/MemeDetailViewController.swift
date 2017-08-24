//
//  MemeDetailViewController.swift
//  Meme Me v2
//
//  Created by SoSucesso on 24/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var meme : Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = meme.memedImage
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editMeme))
    }
    
    static func open(navigation : UINavigationController, meme : Meme) {
        let detailVC = navigation.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailVC.meme = meme
        navigation.pushViewController(detailVC, animated: true)
    }
    
    func editMeme() {
        MemeEditorViewController.open(controller: self, meme: meme)
    }

}
