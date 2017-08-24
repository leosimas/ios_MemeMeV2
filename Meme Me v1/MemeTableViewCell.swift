//
//  MemeTableViewCell.swift
//  Meme Me v2
//
//  Created by SoSucesso on 23/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var imageMeme: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func setupCellWith(_ meme : Meme) {
        imageMeme.image = meme.memedImage
        label.text = meme.fullText
    }
    
}
