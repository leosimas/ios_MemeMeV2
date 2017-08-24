//
//  CollectionMemesViewController.swift
//  Meme Me v2
//
//  Created by SoSucesso on 24/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import UIKit

class CollectionMemesViewController : SentMemesViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        collectionView.reloadData()
        
        let space:CGFloat = 3.0
        let dimension  = (view.frame.size.width - (2 * space)) / 3.0
            
            
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getMemesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let meme = getMeme(byIndex: indexPath.row)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        cell.setupCellWith(meme)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = getMeme(byIndex: indexPath.row)
        openDetail(meme)
    }
    
}
