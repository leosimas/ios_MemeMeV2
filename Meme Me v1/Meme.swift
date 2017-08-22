//
//  Meme.swift
//  Meme Me v1
//
//  Created by SoSucesso on 22/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    
    var topText : String
    var bottomText : String
    var originalImage : UIImage
    var memedImage : UIImage
    
    init(topText : String, bottomText : String, originalImage : UIImage, memedImage : UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
}
