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
        
        // If we don't have any memes, show the EditMemeController
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).savedMemes
        if(memes.count == 0) {
            navigationController?.pushViewController(EditMemeViewController(), animated: false)
            return
        }
        
        setupUI();
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
        
        let editButton = UIButton()
        editButton.frame = CGRectMake(0, 0, 50, 90)
        editButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        editButton.setTitle("Edit", forState: UIControlState.Normal)
        editButton.addTarget(self, action: "edit:", forControlEvents: UIControlEvents.TouchUpInside)
        editButton.tag = indexPath.row
        
        cell.indentationLevel = 10
        cell.textLabel!.text = meme.combinedText
        cell.contentView.addSubview(imgView)
        cell.accessoryView = editButton
        
        return cell
    }
    
    @IBAction func edit(sender: UIButton) {
        let indexPathRow = sender.tag
        let meme = memes[indexPathRow]
        let editViewController = EditMemeViewController()
        editViewController.meme = meme
        editViewController.index = indexPathRow
        editViewController.mode = EditMemeViewController.Mode.Edit
        navigationController?.pushViewController(editViewController, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90;
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let meme = memes[indexPath.row]
        let resendViewController = EditMemeViewController()
        resendViewController.meme = meme
        resendViewController.mode = EditMemeViewController.Mode.Resend
        navigationController?.pushViewController(resendViewController, animated: true)
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
        self.title = "Sent Memes (Table)"
        // setup prototype cell
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MemeCell")
        
        let addMemeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "showEditView")
        navigationItem.rightBarButtonItem = addMemeButton
    }

}
