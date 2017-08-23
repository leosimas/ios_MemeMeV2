//
//  SentMemesViewController.swift
//  Meme Me v2
//
//  Created by SoSucesso on 23/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import UIKit

class SentMemesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sent Memes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createMeme))
    }

    internal func getMemesCount() -> Int {
        return AppDelegate.shared().listMemes().count
    }
    
    internal func getMeme(byIndex index : Int) -> Meme {
        return AppDelegate.shared().listMemes()[index]
    }
    
    internal func openEditor(_ meme : Meme? = nil) {
        let editorVC = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        editorVC.meme = meme
        present(editorVC, animated: true, completion: nil)
    }
    
    func createMeme() {
        openEditor()
    }

}

