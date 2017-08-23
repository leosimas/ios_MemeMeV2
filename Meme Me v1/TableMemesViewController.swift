//
//  TableMemesTableViewController.swift
//  Meme Me v2
//
//  Created by SoSucesso on 23/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import UIKit

class TableMemesViewController: SentMemesViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 126
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMemesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meme = getMeme(byIndex: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell") as! MemeTableViewCell
        cell.imageMeme.image = meme.memedImage
        cell.label.text = meme.fullText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = getMeme(byIndex: indexPath.row)
        openEditor(meme)
    }

}
