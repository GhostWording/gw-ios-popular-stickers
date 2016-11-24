//
//  IntentionPickerViewController.swift
//  StickerBliss
//
//  Created by Mathieu Skulason on 11/07/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit

class IntentionPickerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let viewModel: IntentionPickerViewModel!
    
    var selectedRecipientAndIntentionClosure: ((recipient: GWRecipient, intention: GWIntention) -> Void)?
    
    init(recipient: GWRecipient) {
        
        self.viewModel = IntentionPickerViewModel(recipient: recipient)
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let headerView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64))
        headerView.backgroundColor = UIColor.c_blueColor()
        self.view.addSubview(headerView)
        
        var backButtonImage = UIImage(named: "BackArrow")
        backButtonImage = backButtonImage?.imageWithRenderingMode(.AlwaysTemplate)
        
        
        let backButton = MAXFadeBlockButton(frame: CGRectMake(0, 20, 44 * 1.5, 44))
        backButton.setImage( backButtonImage, forState: UIControlState.Normal)
        backButton.tintColor = UIColor.whiteColor()
        backButton.imageEdgeInsets = UIEdgeInsetsMake(44 * 0.3, 44 * 0.3, 44 * 0.3, 44 * 0.8)
        
        backButton.buttonTouchUpInsideWithCompletion({
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })
        
        headerView.addSubview( backButton )
        
        
        let stickersTitleLabel = UILabel(frame: CGRectMake( CGRectGetMaxX(backButton.frame) + CGRectGetWidth(self.view.frame) * 0.05, 20, CGRectGetWidth(self.view.frame) - CGRectGetMaxX(backButton.frame) - CGRectGetWidth(self.view.frame) * 0.1, 44))
        stickersTitleLabel.textAlignment = .Left
        stickersTitleLabel.textColor = UIColor.whiteColor()
        stickersTitleLabel.text = PopularStickersLocalizedString("<SelectIntentionTitle>", nil)
        stickersTitleLabel.font = UIFont.c_robotoWithSize(Float(CGRectGetHeight(self.view.frame) * 0.03))
        
        headerView.addSubview(stickersTitleLabel)

        
        let tableView = UITableView(frame: CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.clearColor()
        
        self.view.addSubview(tableView)
        
        viewModel.downloadIntentions({
            tableView.reloadData()
        })
        
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numIntentionItems()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 70
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier") as? IntentionCell
        
        if cell == nil {
            cell = IntentionCell(style: UITableViewCellStyle.Default, reuseIdentifier: "reuseIdentifier")
            
            let selectionView = UIView()
            selectionView.backgroundColor = UIColor.c_lightBlueCellHighlightColor()
            
            cell?.selectedBackgroundView = selectionView
            
            
        }
        
        cell?.intentionLabel.text = viewModel.intentionTitle(indexPath.row)
        cell?.intentionLabel.textColor = UIColor.blackColor()
        cell?.intentionLabel.font = UIFont.c_robotoWithSize(17.0)
        
        let image = viewModel.intentionImage(indexPath.row)
        
        if image == nil {
            
            viewModel.downloadImage(indexPath.row, completion: {
                error in
                
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                
            })
            
        }
        else {
            
            cell?.intentionImageView.contentMode = UIViewContentMode.ScaleAspectFill
            cell?.intentionImageView.image = image
            cell?.intentionImageView.layer.cornerRadius = 8.0
            cell?.intentionImageView.layer.masksToBounds = true
        
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if let intention = self.viewModel.intention(indexPath.row) {
            
            self.selectedRecipientAndIntentionClosure?(recipient: self.viewModel.selectedRecipient, intention: intention)
            
        }
        
        
    }
}
