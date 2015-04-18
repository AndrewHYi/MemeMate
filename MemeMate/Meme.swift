//
//  Meme.swift
//  MemeMate
//
//  Created by Andrew Yi on 4/18/15.
//  Copyright (c) 2015 AndrewHYi. All rights reserved.
//

import UIKit

class Meme: NSObject {
    var topText: String
    var bottomText: String
    var image: UIImage
    
    init(topText: String, bottomText: String, image: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
    }
    
    var combinedText: String {
        return topText + "..." + bottomText
    }
}
