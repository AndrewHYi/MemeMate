//
//  MemeTableViewController.swift
//  MemeMate
//
//  Created by Andrew Yi on 4/18/15.
//  Copyright (c) 2015 AndrewHYi. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI();

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).savedMemes
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let meme = memes[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell!
        
        var imgView = UIImageView(frame: CGRectMake(0,0,90,90));
        imgView.backgroundColor = UIColor.blackColor()
        imgView.layer.masksToBounds = true
        imgView.image = meme.memedImage
        imgView.contentMode = UIViewContentMode.ScaleAspectFit
        
        cell.indentationLevel = 10
        cell.textLabel!.text = meme.combinedText
        cell.contentView.addSubview(imgView)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90;
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let meme = memes[indexPath.row]
        let editViewController = EditMemeViewController()
        editViewController.memeToResend = meme
        navigationController?.title = "Resend Meme"
        navigationController?.pushViewController(editViewController, animated: true)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            (UIApplication.sharedApplication().delegate as! AppDelegate).savedMemes.removeAtIndex(indexPath.row)
            memes = (UIApplication.sharedApplication().delegate as! AppDelegate).savedMemes
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    // MARK: Button Actions
    func showEditView() {
        let editViewController = EditMemeViewController()
        editViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(editViewController, animated: true)
    }
    
    // MARK: UI Setup
    func setupUI() {
        // setup prototype cell
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MemeCell")
        
        let addMemeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "showEditView")
        navigationItem.rightBarButtonItem = addMemeButton
    }

}
