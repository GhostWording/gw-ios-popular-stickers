//
//  SingleStickerDetailViewController.swift
//  PopularStickers
//
//  Created by Mathieu Skulason on 08/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit
import MBProgressHUD
import FBSDKMessengerShareKit


class SingleStickerDetailViewController: UIViewController, UIDocumentInteractionControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var imageToShow: UIImage?
    var imageName: String?
    var imageToSend: UIImage?
    var prototypeId : String?
    var indexPath : NSIndexPath?
    
    var selectedStickerTitle: String?
    
    let viewModel = SingleStickerViewModel()
    
    // UI Components
    let tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
    let imageView = UIImageView()
    let bottomButton = MAXFadeBlockButton()
    let infoLabel = UILabel()
    let backButton = MAXFadeBlockButton()
    var rememberMethodSwitch : MBSwitch?
    var overlayView : UIView?
    var backToMessengerButton: MAXBlockButton?

    
    var documentInteractionController: UIDocumentInteractionController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        backToMessengerButton = MAXBlockButton(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40))
        backToMessengerButton?.backgroundColor = UIColor.c_backToMessengerBannerColor()
        backToMessengerButton?.titleEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0)
        backToMessengerButton?.setTitle("Touch to return to messenger", forState: UIControlState.Normal)
        backToMessengerButton?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        backToMessengerButton?.titleLabel?.font = UIFont.c_robotoWithSize(13.0)
        
        backToMessengerButton?.buttonTouchUpInsideWithCompletion({
            
            FBSDKMessengerSharer.openMessenger()
            
        })
        
        
        imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) * 0.6)
        imageView.contentMode = .ScaleAspectFill
        imageView.image = self.imageToShow
        imageView.userInteractionEnabled = true
        imageView.multipleTouchEnabled = true
        imageView.layer.masksToBounds = true
        
        self.view.addSubview(imageView)
        

        bottomButton.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 90, CGRectGetHeight(imageView.frame) - 50 - CGRectGetHeight(imageView.frame) * 0.05, 180, 50)
        bottomButton.setTitle(PopularStickersLocalizedString("<Send>", ""), forState: .Normal)
        bottomButton.backgroundColor = UIColor.c_blueColor()
        bottomButton.layer.shadowColor = UIColor.blackColor().CGColor
        bottomButton.layer.shadowOpacity = 0.6
        bottomButton.layer.shadowOffset = CGSizeMake(2, 2)
        bottomButton.layer.cornerRadius = 5.0

        bottomButton.buttonTouchUpInsideWithCompletion( {
         
            self.indexPath = nil
            self.imageToSend = self.imageToShow
            self.chooseSendMethod()
            
        })
        
        
        self.view.addSubview(bottomButton)
        
        infoLabel.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame), CGRectGetWidth(self.view.frame), 40)
        infoLabel.textColor = UIColor.blackColor()
        infoLabel.font = UIFont.c_robotoMediumWithSize(15.0)
        infoLabel.text = PopularStickersLocalizedString("<SendExplanation>", "")
        infoLabel.textAlignment = .Center
        infoLabel.backgroundColor = UIColor.c_bannerGrayColor()
        self.view.addSubview(infoLabel)
        
        
        
        var backButtonImage = UIImage(named: "BackArrow")
        backButtonImage = backButtonImage?.imageWithRenderingMode(.AlwaysTemplate)
        
        
        backButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) * 0.05, 20 + CGRectGetWidth(self.view.frame) * 0.05, CGRectGetWidth(self.view.frame) * 0.12, CGRectGetWidth(self.view.frame) * 0.12)
        backButton.setImage( backButtonImage, forState: UIControlState.Normal)
        backButton.tintColor = UIColor.whiteColor()
        backButton.imageEdgeInsets = UIEdgeInsetsMake(CGRectGetHeight(backButton.frame) * 0.25, CGRectGetWidth(backButton.frame) * 0.25, CGRectGetHeight(backButton.frame) * 0.25, CGRectGetWidth(backButton.frame) * 0.25)
        backButton.layer.cornerRadius = CGRectGetWidth(backButton.frame) / CGFloat(2.0)
        backButton.layer.backgroundColor = UIColor.c_blueColor().CGColor
        backButton.alpha = CGFloat(backButton.fadeAlphaValue)
        
        backButton.buttonTouchUpInsideWithCompletion({
            
            AnalyticsManager.sharedManager().postActionWithType( kGABackFromImage, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: kGAItemDetailScreen)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        self.view.addSubview(backButton)
        
        
        let addTextButton = MAXFadeBlockButton(frame: CGRectMake(CGRectGetWidth(self.view.frame) - 65, CGRectGetHeight(self.view.frame) - 70, 50, 50))
        addTextButton.layer.cornerRadius = 25
        addTextButton.layer.backgroundColor = UIColor.c_blueColor().CGColor
        addTextButton.layer.shadowColor = UIColor.blackColor().CGColor
        addTextButton.layer.shadowOpacity = 0.6
        addTextButton.layer.shadowOffset = CGSizeMake(2, 2)
        addTextButton.setTitle("+", forState: UIControlState.Normal)
        addTextButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        addTextButton.titleLabel?.font = UIFont.c_robotoMediumWithSize(31)
        
        addTextButton.buttonTouchUpInsideWithCompletion({
            
            let recipientPicker = RecipientPickerViewController(area: "stickers")
            
            recipientPicker.selectedRecipientAndIntentionClosure = {
                recipient, intention in
                
                let filter = GWTextFilter()
                filter.tagIds = [recipient.relationTypeTag!]
                filter.recipientGender = recipient.gender
                filter.senderGender = UserDefaults.userGender()
                filter.intentionId = intention.intentionId
                
                self.viewModel.textFilter = filter
                self.viewModel.reloadTextsAsIntentions()
                self.tableView.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
                
                UIView.animateWithDuration(0.3, animations: {
                    
                    }, completion: {
                        isComplete in
                        
                        if isComplete == true {
                            self.tableView.setContentOffset( CGPointZero, animated: true)
                        }
                        
                })
                
                if self.viewModel.numberOfTexts() == 0 {
                    self.animateButtonDownAndInfoOut()
                }
                else {
                    self.animateButtonUpAndInfoIn()
                }
                
                
                
            }
            
            self.presentViewController( recipientPicker, animated: true, completion: nil)
            
        })
        
        self.view.addSubview(addTextButton)
        
        viewModel.reloadTextsAsIntentions()
        
        // if the image has been viewed for an intention we do not want to show it again
        if UserDefaults.hasViewedImageWithId(self.imageName) == false || self.viewModel.intentionId == nil {
            
            viewModel.downloadPopularTexts(imageName, completion: {
                error -> Void in
                
                self.tableView.reloadData()
                if self.viewModel.textsAndRanking?.count == 0 {
                    
                    self.animateButtonDownAndInfoOut()
                    
                }
                
            })
            
            UserDefaults.setHasViewedImageWithId(self.imageName)
            
        }
        
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(infoLabel.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(infoLabel.frame))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = UIColor.clearColor()
        
        self.view.insertSubview(self.tableView, belowSubview : bottomButton)
        self.tableView.reloadData()
        
        self.addOrRemoveBackToMessengerButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendWithMessenger() {
        
        AnalyticsManager.sharedManager().postActionWithType( kGASendMessenger, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: kGAItemDetailScreen)
        
        
        if let nonNilIndexPath = indexPath {
            // when index path is not nil we sent it with a text
            AnalyticsManager.sharedManager().postActionWithType( kGASendMessenger, targetType: kGATargetTypeText, targetId: self.viewModel.textId(nonNilIndexPath.row), targetParameter: nil, actionLocation: kGAItemDetailScreen)
            
            AnalyticsManager.sharedManager().postActionWithType( kGASendMessenger, targetType: kGATargetTypeText, targetId: self.viewModel.textId(nonNilIndexPath.row), targetParameter: nil, actionLocation: kGAItemDetailScreen)
            
            AnalyticsManager.sharedManager().postActionWithType( kGALinkEvents, targetType: kGATargetTypeApp, targetId: self.viewModel.textId(nonNilIndexPath.row), targetParameter: self.imageName?.imageName(), actionLocation: kGAItemDetailScreen)
        }
        else {
            AnalyticsManager.sharedManager().postActionWithType( kGASendMessenger, targetType: kGATargetTypeImage, targetId: self.imageName?.imageName(), targetParameter: nil, actionLocation: kGAItemDetailScreen)
        }
        
        let progressHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHud.mode = MBProgressHUDMode.Indeterminate
        
        if self.overlayView != nil {
            self.fadeOutOverlayView(nil)
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64( 0.2 ) * Int64( NSEC_PER_SEC )), dispatch_get_main_queue(), {
            self.showMessengerExtension(self.imageToSend, imageId: self.imageName?.imageName(), prototypeId: nil)
            UserDefaults.setHasSentImageOrText( true )
        });
        
    }
    
    func sendWithOS() {
        
        let activityVC = UIActivityViewController(activityItems: [self.imageToSend!], applicationActivities: nil)
        
        if #available(iOS 9.0, *) {
            let excludedActivities = [UIActivityTypeOpenInIBooks]
            activityVC.excludedActivityTypes = excludedActivities
        }
        
        AnalyticsManager.sharedManager().postActionWithType( kGAShareViaIntent, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: kGAItemDetailScreen)
        
        if let nonNilIndexPath = indexPath {
            
            AnalyticsManager.sharedManager().postActionWithType( kGAShareViaIntent, targetType: kGATargetTypeText, targetId: self.viewModel.textId(nonNilIndexPath.row), targetParameter: nil, actionLocation: kGAItemDetailScreen)
            
            AnalyticsManager.sharedManager().postActionWithType( kGAShareViaIntent, targetType: kGATargetTypeText, targetId: self.viewModel.textId(nonNilIndexPath.row), targetParameter: nil, actionLocation: kGAItemDetailScreen)
            
            AnalyticsManager.sharedManager().postActionWithType( kGALinkEvents, targetType: kGATargetTypeApp, targetId: self.viewModel.textId(nonNilIndexPath.row), targetParameter: self.imageName?.imageName(), actionLocation: kGAItemDetailScreen)
            
        }
        else {
            AnalyticsManager.sharedManager().postActionWithType( kGAShareViaIntent, targetType: kGATargetTypeImage, targetId: self.imageName?.imageName(), targetParameter: nil, actionLocation: kGAItemDetailScreen)
        }
        
        
        let progressHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHud.mode = MBProgressHUDMode.Indeterminate
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64( 0.2 ) * Int64( NSEC_PER_SEC )), dispatch_get_main_queue(), {
            self.presentViewController(activityVC, animated: true, completion: {
                progressHud.hideAnimated( true )
                UserDefaults.setHasSentImageOrText( true )
            })
        });
        
    }
    
    func chooseSendMethod() {
        
        if UserDefaults.sendMethodForMessage() == MessageSendMethod.NoMethod {
            
            overlayView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame) , CGRectGetHeight(self.view.frame)))
            overlayView?.backgroundColor = UIColor.c_colorWithHexString(UIColor.c_hexValuesFromUIColor(UIColor.blackColor()), alpha:  0.3)
            overlayView?.alpha = 0.0
            
            let backgroundButton = MAXFadeBlockButton(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)))
            backgroundButton.backgroundColor = UIColor.clearColor()
            backgroundButton.buttonTouchUpInsideWithCompletion({
                self.fadeOutOverlayView(nil)
            })
            
            overlayView?.addSubview( backgroundButton )
            
            self.view.addSubview( overlayView! )
            
            let chooseMethodView = UIView(frame: CGRectMake(CGRectGetWidth(self.view.frame) * 0.15, CGRectGetHeight(self.view.frame) * 0.3, CGRectGetWidth(self.view.frame) * 0.7, CGRectGetWidth(self.view.frame) * 0.7))
            chooseMethodView.layer.backgroundColor = UIColor.whiteColor().CGColor
            chooseMethodView.layer.borderColor = UIColor.c_blueColor().CGColor
            chooseMethodView.layer.borderWidth = 2.0
            chooseMethodView.layer.cornerRadius = 5.0
            chooseMethodView.layer.masksToBounds = true
            
            overlayView!.addSubview( chooseMethodView )
            
            
            let titleLabel = UILabel(frame:  CGRectMake(0, 0, CGRectGetWidth(chooseMethodView.frame), CGRectGetHeight(chooseMethodView.frame) * 0.15))
            titleLabel.font = UIFont.c_robotoBoldWithSize( 16.0 )
            titleLabel.textColor = UIColor.c_textDarkGrayColor()
            titleLabel.textAlignment = .Center
            titleLabel.text = PopularStickersLocalizedString("<ChooseSendMethod>", nil)
            
            chooseMethodView.addSubview( titleLabel )
            
            
            let messengerButtonContainerRow = MAXFadeBlockButton(frame: CGRectMake(0, CGRectGetHeight(chooseMethodView.frame) * 0.16 - CGRectGetWidth(chooseMethodView.frame) * 0.035, CGRectGetWidth(chooseMethodView.frame) , CGRectGetWidth(chooseMethodView.frame) * 0.18 + CGRectGetWidth(chooseMethodView.frame) * 0.07))
            chooseMethodView.addSubview( messengerButtonContainerRow )
            
            
            let messengerButton = FBSDKMessengerShareButton.circularButtonWithStyle( FBSDKMessengerShareButtonStyle.Blue )
            messengerButton.frame = CGRectMake(CGRectGetWidth(chooseMethodView.frame) * 0.06, CGRectGetHeight(chooseMethodView.frame) * 0.035, CGRectGetWidth(chooseMethodView.frame) * 0.18, CGRectGetWidth(chooseMethodView.frame) * 0.18)
            messengerButton.userInteractionEnabled = false
            
            messengerButtonContainerRow.addSubview( messengerButton )
            
            let messengerTitle = UILabel(frame: CGRectMake(CGRectGetMaxX(messengerButton.frame) + 10, CGRectGetMinY(messengerButton.frame), CGRectGetWidth(chooseMethodView.frame) * 0.6, CGRectGetHeight(messengerButton.frame)))
            messengerTitle.textAlignment = .Left
            messengerTitle.textColor = UIColor.c_textDarkGrayColor()
            messengerTitle.font = UIFont.c_robotoMediumWithSize( 15.0 )
            messengerTitle.text = PopularStickersLocalizedString("<MessengerMethod>", nil)
            
            messengerButtonContainerRow.addSubview( messengerTitle )
            
            let otherButtonContainerRow = MAXFadeBlockButton(frame: CGRectMake(0, CGRectGetMaxY(messengerButtonContainerRow.frame) - CGRectGetWidth(chooseMethodView.frame) * 0.02, CGRectGetWidth(chooseMethodView.frame), CGRectGetWidth(chooseMethodView.frame) * 0.18 + CGRectGetWidth(chooseMethodView.frame) * 0.07))
            chooseMethodView.addSubview( otherButtonContainerRow )
            
            let otherButton = MAXFadeBlockButton(frame: CGRectMake(CGRectGetMinX(messengerButton.frame), CGRectGetWidth(chooseMethodView.frame) * 0.035, CGRectGetWidth(chooseMethodView.frame) * 0.18, CGRectGetWidth(chooseMethodView.frame) * 0.18))
            otherButton.backgroundColor = UIColor.c_greenColor()
            otherButton.layer.cornerRadius = CGRectGetWidth(otherButton.frame) / 2.0
            otherButton.userInteractionEnabled = false
            
            
            
            var smsImage = UIImage(named: "SmsIcon")
            smsImage = smsImage?.imageWithRenderingMode( UIImageRenderingMode.AlwaysTemplate )
            
            let smsImageView = UIImageView(frame: CGRectMake(CGRectGetWidth(otherButton.frame) * 0.22, CGRectGetHeight(otherButton.frame) * 0.17, CGRectGetWidth(otherButton.frame) * 0.26, CGRectGetWidth(otherButton.frame) * 0.26))
            smsImageView.image = smsImage
            smsImageView.tintColor = UIColor.whiteColor()
            otherButton.addSubview( smsImageView )
            
            var whatsAppImage = UIImage(named: "WhatsAppIcon")
            whatsAppImage = whatsAppImage?.imageWithRenderingMode( UIImageRenderingMode.AlwaysTemplate )
            
            let whatsAppImageView = UIImageView(frame: CGRectMake(CGRectGetWidth(otherButton.frame) * 0.58, CGRectGetHeight(otherButton.frame) * 0.32, CGRectGetWidth(otherButton.frame) * 0.3, CGRectGetWidth(otherButton.frame) * 0.3))
            whatsAppImageView.image = whatsAppImage
            whatsAppImageView.tintColor = UIColor.whiteColor()
            otherButton.addSubview( whatsAppImageView )
            
            var emailImage = UIImage(named:  "EmailIcon")
            emailImage = emailImage?.imageWithRenderingMode( UIImageRenderingMode.AlwaysTemplate )
            
            let emailImageView = UIImageView(frame: CGRectMake(CGRectGetWidth(otherButton.frame) * 0.2, CGRectGetHeight(otherButton.frame) * 0.55, CGRectGetWidth(otherButton.frame) * 0.33, CGRectGetWidth(otherButton.frame) * 0.33))
            emailImageView.image = emailImage
            emailImageView.tintColor = UIColor.whiteColor()
            otherButton.addSubview( emailImageView )
            
            
            otherButtonContainerRow.addSubview( otherButton )
            
            let otherSendMethodTitleLabel = UILabel(frame: CGRectMake(CGRectGetMaxX(otherButton.frame) + 10, CGRectGetMinY(otherButton.frame), CGRectGetWidth(chooseMethodView.frame) * 0.6, CGRectGetHeight(otherButton.frame)))
            otherSendMethodTitleLabel.textAlignment = .Left
            otherSendMethodTitleLabel.textColor = UIColor.c_textDarkGrayColor()
            otherSendMethodTitleLabel.font = UIFont.c_robotoMediumWithSize( 15.0 )
            otherSendMethodTitleLabel.text = PopularStickersLocalizedString("<OtherMethod>", nil)
            
            otherButtonContainerRow.addSubview( otherSendMethodTitleLabel )
            
            let bottomBlueFooter = UIView(frame: CGRectMake(0, CGRectGetHeight(chooseMethodView.frame) * 0.84, CGRectGetWidth(chooseMethodView.frame) , CGRectGetHeight(chooseMethodView.frame) * 0.16 ))
            bottomBlueFooter.backgroundColor = UIColor.c_blueColor()
            
            chooseMethodView.addSubview( bottomBlueFooter )
            
            if  UserDefaults.hasSentImageOrText() == true {
                
                self.rememberMethodSwitch = MBSwitch(frame: CGRectMake(CGRectGetWidth(chooseMethodView.frame) * 0.08, CGRectGetMaxY(otherButtonContainerRow.frame) + CGRectGetWidth(chooseMethodView.frame) * 0.035, CGRectGetWidth(chooseMethodView.frame) * 0.15, CGRectGetWidth(chooseMethodView.frame) * 0.1))
                self.rememberMethodSwitch!.onTintColor = UIColor.c_blueColor()
                chooseMethodView.addSubview( rememberMethodSwitch! )
                
                let rememberTitleLabel = UILabel(frame: CGRectMake(CGRectGetMaxX(self.rememberMethodSwitch!.frame) + 10, CGRectGetMinY(self.rememberMethodSwitch!.frame), CGRectGetWidth(chooseMethodView.frame) * 0.7, CGRectGetWidth(chooseMethodView.frame) * 0.1))
                rememberTitleLabel.textAlignment = .Left
                rememberTitleLabel.textColor = UIColor.c_textDarkGrayColor()
                rememberTitleLabel.font = UIFont.c_robotoMediumWithSize( 15.0 )
                rememberTitleLabel.text = PopularStickersLocalizedString("<RememberSendMethod>", nil)
                chooseMethodView.addSubview( rememberTitleLabel )
                
            }
            else {
                
                messengerButtonContainerRow.frame = CGRectMake(0, CGRectGetHeight(chooseMethodView.frame) * 0.2, CGRectGetWidth(chooseMethodView.frame) , CGRectGetWidth(chooseMethodView.frame) * 0.18 + CGRectGetWidth(chooseMethodView.frame) * 0.07)
                otherButtonContainerRow.frame = CGRectMake(0, CGRectGetMaxY(messengerButtonContainerRow.frame) + CGRectGetWidth(chooseMethodView.frame) * 0.05, CGRectGetWidth(chooseMethodView.frame), CGRectGetWidth(chooseMethodView.frame) * 0.18 + CGRectGetWidth(chooseMethodView.frame) * 0.07)
                
                
            }
            
            let cancelButton = MAXFadeBlockButton(frame: CGRectMake(0, 0, CGRectGetWidth(bottomBlueFooter.frame), CGRectGetHeight(bottomBlueFooter.frame)))
            cancelButton.setTitle(PopularStickersLocalizedString("<NotificationAlertCancelTitle>", nil), forState: UIControlState.Normal)
            cancelButton.titleLabel!.font = UIFont.c_robotoMediumWithSize( 15.0 )
            cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            
            cancelButton.buttonTouchUpInsideWithCompletion({
                
                self.fadeOutOverlayView(nil)
                
            })
            
            bottomBlueFooter.addSubview( cancelButton )
            
            
            messengerButtonContainerRow.buttonTouchUpInsideWithCompletion({
                
                if UserDefaults.hasSentImageOrText() == true && self.rememberMethodSwitch != nil {
                    if self.rememberMethodSwitch!.on == true {
                        UserDefaults.setSendMethodForMessage( MessageSendMethod.Messenger )
                    }
                }
                
                self.fadeOutOverlayView(nil)
                
                self.sendWithMessenger()
                
            })
            
            otherButtonContainerRow.buttonTouchUpInsideWithCompletion({
                
                if UserDefaults.hasSentImageOrText() == true && self.rememberMethodSwitch != nil {
                    if self.rememberMethodSwitch!.on == true {
                        UserDefaults.setSendMethodForMessage(  MessageSendMethod.OS )
                    }
                }
                
                self.fadeOutOverlayView(nil)
                
                self.sendWithOS()
                
            })
            
            UIView.animateWithDuration(0.1, animations: {
                self.overlayView!.alpha = 1.0
            })
        }
        else if UserDefaults.sendMethodForMessage() == MessageSendMethod.Messenger {
            
            self.sendWithMessenger()
        }
        else if UserDefaults.sendMethodForMessage() == MessageSendMethod.OS {
            
            self.sendWithOS()
        }
        
    }
    
    
    func fadeOutOverlayView(completion: (() -> Void)?) {
        UIView.animateWithDuration(0.1, animations: {
            self.overlayView!.alpha = 0.0
            }, completion: {
                finished -> Void in
                
                self.overlayView!.removeFromSuperview()
                
        })
    }
    
    // MARK: Animate button and info view
    
    func animateButtonDownAndInfoOut() {
        
        UIView.animateWithDuration(0.3, animations: {
            
            self.infoLabel.alpha = 0.0
            self.bottomButton.c_setOriginY( Float(CGRectGetHeight(self.view.frame) - self.backButton.frame.size.height - 20))
            
        })
        
        self.bottomButton.setTitle(PopularStickersLocalizedString("<Send>", ""), forState: .Normal)
        
    }
    
    func animateButtonUpAndInfoIn() {
        
        UIView.animateWithDuration(0.3, animations: {
            
            if self.backToMessengerButton?.superview == nil {
                
                self.bottomButton.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 90, CGRectGetHeight(self.imageView.frame) - 50 - CGRectGetHeight(self.imageView.frame) * 0.05, 180, 50)
            }
            else {
                
                self.bottomButton.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 90, CGRectGetHeight(self.imageView.frame) - 10 - CGRectGetHeight(self.imageView.frame) * 0.05, 180, 50)
            }
            
            self.infoLabel.alpha = 1.0
        
        })
        
        bottomButton.setTitle(PopularStickersLocalizedString("<Send>", ""), forState: .Normal)
        
    }

    // MARK: Table View
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.numberOfTexts()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier") as? PopularTextsTableViewCell
        
        if cell == nil {
            cell = PopularTextsTableViewCell(style: .Default, reuseIdentifier: "cellIdentifier")
            cell?.popularTextLabel.font = UIFont.c_robotoLightWithSize(17.0)
            
            let selectionView = UIView()
            selectionView.backgroundColor = UIColor.c_lightBlueCellHighlightColor()
            
            cell?.selectedBackgroundView = selectionView
            
        }
        
        cell?.popularTextLabel.text = self.viewModel.textContent(indexPath.row)
        
        cell?.nbSharesLabel.text = self.viewModel.textNumberOfShares(indexPath.row)
        cell?.nbSharesLabel.textAlignment = .Right
        cell?.nbSharesLabel.font = UIFont.c_robotoWithSize(15.0)
        
        cell?.nbSharesImageView.image = UIImage(named: "NbSharesIcon")
        cell?.nbSharesImageView.contentMode = UIViewContentMode.ScaleAspectFit
        cell?.nbSharesImageView.hidden = self.viewModel.textIsDisplayedAndShared(indexPath.row) == false
        
        
        return cell!
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return self.viewModel.textHeight(indexPath.row, width: CGRectGetWidth(self.view.frame) * 0.8, font: UIFont.c_robotoLightWithSize(17.0)) + 40
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let text = self.viewModel.textContent(indexPath.row) {
            
            self.indexPath = indexPath
            self.imageToSend = self.createImage(text)
            self.chooseSendMethod()
            
        }
        
    }

    
    func createMetadataJsonString(imageId: String?, prototypeId: String?) -> String? {
        
        let mutableDict = NSMutableDictionary()
        
        mutableDict.setObject(1, forKey: "version")
        
        if let intentionId = self.viewModel.intentionId {
            mutableDict.setObject(intentionId, forKey: "intentionId")
        }
        else {
            mutableDict.setObject(NSNull(), forKey: "intentionId")
        }
        
        if let imagePath = self.viewModel.imagePath {
            mutableDict.setObject(imagePath, forKey: "imagePath")
        }
        
        // not supported yet
        if let nonNilPrototypeId = prototypeId {
            mutableDict.setObject(nonNilPrototypeId, forKey: "prototypeId")
        }
        else {
            mutableDict.setObject(NSNull(), forKey: "prototypeId")
        }
        mutableDict.setObject(NSNull(), forKey: "recipientType")
        
        
        if let imageName = imageId {
            
            if let lastComponent = imageName.componentsSeparatedByString("/").last {
                mutableDict.setObject(lastComponent, forKey: "imageName")
            }
        }
        
        
        
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(mutableDict, options: NSJSONWritingOptions.PrettyPrinted)
            
            let jsonString = String(data: data, encoding: NSUTF8StringEncoding)
            
            return jsonString
            
        }
        catch {
            
        }
        
        return nil
    }
    
    // MARK: Image Creation and Extensions
    
    func showMessengerExtension(image: UIImage?, imageId: String?, prototypeId: String?) {
        
        if let nonNilImage = image, let _ = imageId {
            
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            
            let options = FBSDKMessengerShareOptions()
            
            options.contextOverride = AppFlow.currentContext()
            options.metadata = self.createMetadataJsonString(imageId, prototypeId: prototypeId)
            FBSDKMessengerSharer.shareImage(nonNilImage, withOptions: options)
            
        }
    }
    
    // MARK: Create Image With Text
    
    func createImage(text: String) -> UIImage {
        
        let imageView = UIImageView(image: self.imageToShow)
        
        let biggerSide = imageView.frame.size.width
        
        let fontSize  = biggerSide / 16.0
        let font = UIFont.c_robotoLightWithSize(Float(fontSize))
        
        let fontHeight = NSString.c_findHeightForText(text, havingWidth: imageView.frame.size.width * 0.8, andFont: font)
        
        let label = UILabel(frame: CGRectMake(CGRectGetWidth(imageView.frame) * 0.1, CGRectGetMaxY(imageView.frame) + 40, CGRectGetWidth(imageView.frame) * 0.8, fontHeight + 6))
        label.textAlignment = .Center
        label.numberOfLines = 0
        label.font = font
        label.text = text
        label.textColor = UIColor.blackColor()

        
        let snapshotView = UIView(frame: CGRectMake(0, 0, imageView.frame.size.width, CGRectGetMaxY(label.frame) + 40))
        snapshotView.backgroundColor = UIColor.whiteColor()
        snapshotView.addSubview(imageView)
        snapshotView.addSubview(label)
        
        
        return snapshotView.imageByRenderingView()
        
    }
    
    
    // MARK: Messenger Integration
    
    func addOrRemoveBackToMessengerButton() {
        
        if AppFlow.currentMessengerFlow == MessengerFlow.Send {
            self.backToMessengerButton?.removeFromSuperview()
            self.imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) * 0.6)
            self.backButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) * 0.05, 20 + CGRectGetWidth(self.view.frame) * 0.05, CGRectGetWidth(self.view.frame) * 0.12, CGRectGetWidth(self.view.frame) * 0.12)
        }
        else {
            
            if self.backToMessengerButton?.superview == nil {
                self.view.addSubview(self.backToMessengerButton!)
            }
            
            self.imageView.frame = CGRectMake(0, 40, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) * 0.6 - 40)
            self.backButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) * 0.05, 20 + 40 + CGRectGetWidth(self.view.frame) * 0.05, CGRectGetWidth(self.view.frame) * 0.12, CGRectGetWidth(self.view.frame) * 0.12)
            
        }
        
    }

}
