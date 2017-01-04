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
    
    var selectedRecipientAndIntentionClosure: ((_ recipient: GWRecipient, _ intention: GWIntention) -> Void)?
    
    init(recipient: GWRecipient) {
        
        self.viewModel = IntentionPickerViewModel(recipient: recipient)
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64))
        headerView.backgroundColor = UIColor.c_blue()
        self.view.addSubview(headerView)
        
        var backButtonImage = UIImage(named: "BackArrow")
        backButtonImage = backButtonImage?.withRenderingMode(.alwaysTemplate)
        
        
        let backButton = MAXFadeBlockButton(frame: CGRect(x: 0, y: 20, width: 44 * 1.5, height: 44))
        backButton.setImage( backButtonImage, for: UIControlState())
        backButton.tintColor = UIColor.white
        backButton.imageEdgeInsets = UIEdgeInsetsMake(44 * 0.3, 44 * 0.3, 44 * 0.3, 44 * 0.8)
        
        backButton.buttonTouchUpInside(completion: {
            
            self.dismiss(animated: true, completion: nil)
            
        })
        
        headerView.addSubview( backButton )
        
        
        let stickersTitleLabel = UILabel(frame: CGRect( x: backButton.frame.maxX + self.view.frame.width * 0.05, y: 20, width: self.view.frame.width - backButton.frame.maxX - self.view.frame.width * 0.1, height: 44))
        stickersTitleLabel.textAlignment = .left
        stickersTitleLabel.textColor = UIColor.white
        stickersTitleLabel.text = PopularStickersLocalizedString("<SelectIntentionTitle>", nil)
        stickersTitleLabel.font = UIFont.c_roboto(withSize: Float(self.view.frame.height * 0.03))
        
        headerView.addSubview(stickersTitleLabel)

        
        let tableView = UITableView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 64))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.clear
        
        self.view.addSubview(tableView)
        
        viewModel.downloadIntentions({
            tableView.reloadData()
        })
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numIntentionItems()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") as? IntentionCell
        
        if cell == nil {
            cell = IntentionCell(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")
            
            let selectionView = UIView()
            selectionView.backgroundColor = UIColor.c_lightBlueCellHighlight()
            
            cell?.selectedBackgroundView = selectionView
            
            
        }
        
        cell?.intentionLabel.text = viewModel.intentionTitle(indexPath.row)
        cell?.intentionLabel.textColor = UIColor.black
        cell?.intentionLabel.font = UIFont.c_roboto(withSize: 17.0)
        
        let image = viewModel.intentionImage(indexPath.row)
        
        if image == nil {
            
            viewModel.downloadImage(indexPath.row, completion: {
                error in
                
                tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                
            })
            
        }
        else {
            
            cell?.intentionImageView.contentMode = UIViewContentMode.scaleAspectFill
            cell?.intentionImageView.image = image
            cell?.intentionImageView.layer.cornerRadius = 8.0
            cell?.intentionImageView.layer.masksToBounds = true
        
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let intention = self.viewModel.intention(indexPath.row) {
            
            self.selectedRecipientAndIntentionClosure?(self.viewModel.selectedRecipient, intention)
            
        }
        
        
    }
}
