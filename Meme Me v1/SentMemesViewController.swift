//
//  SentMemesViewController.swift
//  Meme Me v2
//
//  Created by SoSucesso on 23/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import UIKit

class SentMemesViewController: UIViewController {

    internal func getMemesCount() -> Int {
        return AppDelegate.shared().listMemes().count
    }
    
    internal func getMeme(byIndex index : Int) -> Meme {
        return AppDelegate.shared().listMemes()[index]
    }
    
    internal func openEditor(_ meme : Meme? = nil) {
        MemeEditorViewController.open(controller: self, meme : meme)
    }
    
    internal func openDetail(_ meme : Meme) {
        MemeDetailViewController.open(navigation: navigationController!, meme: meme)
    }

}

