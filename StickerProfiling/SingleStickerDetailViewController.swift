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
    var indexPath : IndexPath?
    
    var selectedStickerTitle: String?
    
    let viewModel = SingleStickerViewModel()
    
    // UI Components
    let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
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
        
        
        self.view.backgroundColor = UIColor.white
        
        backToMessengerButton = MAXBlockButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        backToMessengerButton?.backgroundColor = UIColor.c_backToMessengerBanner()
        backToMessengerButton?.titleEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0)
        backToMessengerButton?.setTitle("Touch to return to messenger", for: UIControlState())
        backToMessengerButton?.setTitleColor(UIColor.white, for: UIControlState())
        backToMessengerButton?.titleLabel?.font = UIFont.c_roboto(withSize: 13.0)
        
        backToMessengerButton?.buttonTouchUpInside(completion: {
            
            FBSDKMessengerSharer.openMessenger()
            
        })
        
        
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.6)
        imageView.contentMode = .scaleAspectFill
        imageView.image = self.imageToShow
        imageView.isUserInteractionEnabled = true
        imageView.isMultipleTouchEnabled = true
        imageView.layer.masksToBounds = true
        
        self.view.addSubview(imageView)
        

        bottomButton.frame = CGRect(x: self.view.frame.midX - 90, y: imageView.frame.height - 50 - imageView.frame.height * 0.05, width: 180, height: 50)
        bottomButton.setTitle(PopularStickersLocalizedString("<Send>", ""), for: UIControlState())
        bottomButton.backgroundColor = UIColor.c_blue()
        bottomButton.layer.shadowColor = UIColor.black.cgColor
        bottomButton.layer.shadowOpacity = 0.6
        bottomButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        bottomButton.layer.cornerRadius = 5.0

        bottomButton.buttonTouchUpInside( completion: { [weak self] in
         
            self?.indexPath = nil
            self?.imageToSend = self?.imageToShow
            self?.chooseSendMethod()
            
        })
        
        
        self.view.addSubview(bottomButton)
        
        infoLabel.frame = CGRect(x: 0, y: imageView.frame.maxY, width: self.view.frame.width, height: 40)
        infoLabel.textColor = UIColor.black
        infoLabel.font = UIFont.c_robotoMedium(withSize: 15.0)
        infoLabel.text = PopularStickersLocalizedString("<SendExplanation>", "")
        infoLabel.textAlignment = .center
        infoLabel.backgroundColor = UIColor.c_bannerGray()
        self.view.addSubview(infoLabel)
        
        
        
        var backButtonImage = UIImage(named: "BackArrow")
        backButtonImage = backButtonImage?.withRenderingMode(.alwaysTemplate)
        
        
        backButton.frame = CGRect(x: self.view.frame.width * 0.05, y: 20 + self.view.frame.width * 0.05, width: self.view.frame.width * 0.12, height: self.view.frame.width * 0.12)
        backButton.setImage( backButtonImage, for: UIControlState())
        backButton.tintColor = UIColor.white
        backButton.imageEdgeInsets = UIEdgeInsetsMake(backButton.frame.height * 0.25, backButton.frame.width * 0.25, backButton.frame.height * 0.25, backButton.frame.width * 0.25)
        backButton.layer.cornerRadius = backButton.frame.width / CGFloat(2.0)
        backButton.layer.backgroundColor = UIColor.c_blue().cgColor
        backButton.alpha = CGFloat(backButton.fadeAlphaValue)
        
        backButton.buttonTouchUpInside(completion: { [weak self] in
            
            AnalyticsManager.shared().postAction( withType: kGABackFromImage, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: kGAItemDetailScreen)
            
            self?.dismiss(animated: true, completion: nil)
        })
        
        self.view.addSubview(backButton)
        
        
        let addTextButton = MAXFadeBlockButton(frame: CGRect(x: self.view.frame.width - 65, y: self.view.frame.height - 70, width: 50, height: 50))
        addTextButton.layer.cornerRadius = 25
        addTextButton.layer.backgroundColor = UIColor.c_blue().cgColor
        addTextButton.layer.shadowColor = UIColor.black.cgColor
        addTextButton.layer.shadowOpacity = 0.6
        addTextButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        addTextButton.setTitle("+", for: UIControlState())
        addTextButton.setTitleColor(UIColor.white, for: UIControlState())
        addTextButton.titleLabel?.font = UIFont.c_robotoMedium(withSize: 31)
        
        addTextButton.buttonTouchUpInside(completion: { [weak self] in
            
            let recipientPicker = RecipientPickerViewController(area: "stickers")
            
            recipientPicker.selectedRecipientAndIntentionClosure = {
                recipient, intention in
                
                let filter = GWTextFilter()
                filter.tagIds = [recipient.relationTypeTag!]
                filter.recipientGender = recipient.gender
                filter.senderGender = UserDefaults.userGender()
                filter.intentionId = intention.intentionId
                
                self?.viewModel.textFilter = filter
                self?.viewModel.reloadTextsAsIntentions()
                self?.tableView.reloadSections(IndexSet.init(integer: 0), with: UITableViewRowAnimation.fade)
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    }, completion: {
                        isComplete in
                        
                        if isComplete == true {
                            self?.tableView.setContentOffset( CGPoint.zero, animated: true)
                        }
                        
                })
                
                if self?.viewModel.numberOfTexts() == 0 {
                    self?.animateButtonDownAndInfoOut()
                }
                else {
                    self?.animateButtonUpAndInfoIn()
                }
                
                
                
            }
            
            self?.present( recipientPicker, animated: true, completion: nil)
            
        })
        
        self.view.addSubview(addTextButton)
        
        viewModel.reloadTextsAsIntentions()
        
        weak var wSelf = self
        
        // if the image has been viewed for an intention we do not want to show it again
        if UserDefaults.hasViewedImage(withId: self.imageName) == false || self.viewModel.intentionId == nil {
            
            viewModel.downloadPopularTexts(imageName, completion: {
                error -> Void in
                
                wSelf?.tableView.reloadData()
                if wSelf?.viewModel.textsAndRanking?.count == 0 {
                    
                    wSelf?.animateButtonDownAndInfoOut()
                    
                }
                
            })
            
            UserDefaults.setHasViewedImageWithId(wSelf?.imageName)
            
        }
        
        self.tableView.frame = CGRect(x: 0, y: infoLabel.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - infoLabel.frame.maxY)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = UIColor.lightGray
        self.tableView.layoutMargins = UIEdgeInsets.zero
        self.tableView.separatorInset = UIEdgeInsets.zero
        
        self.view.insertSubview(self.tableView, belowSubview : bottomButton)
        self.tableView.reloadData()
        
        self.addOrRemoveBackToMessengerButton()
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendWithMessenger() {
        
        AnalyticsManager.shared().postAction( withType: kGASendMessenger, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: kGAItemDetailScreen)
        
        
        if let nonNilIndexPath = indexPath {
            // when index path is not nil we sent it with a text
            AnalyticsManager.shared().postAction( withType: kGASendMessenger, targetType: kGATargetTypeText, targetId: self.viewModel.textId(nonNilIndexPath.row), targetParameter: nil, actionLocation: kGAItemDetailScreen)
            
            AnalyticsManager.shared().postAction( withType: kGASendMessenger, targetType: kGATargetTypeImage, targetId: self.imageName?.imageName(), targetParameter: nil, actionLocation: kGAItemDetailScreen)
            
            AnalyticsManager.shared().postAction( withType: kGALinkEvents, targetType: kGATargetTypeApp, targetId: self.viewModel.textId(nonNilIndexPath.row), targetParameter: self.imageName?.imageName(), actionLocation: kGAItemDetailScreen)
        }
        else {
            AnalyticsManager.shared().postAction( withType: kGASendMessenger, targetType: kGATargetTypeImage, targetId: self.imageName?.imageName(), targetParameter: nil, actionLocation: kGAItemDetailScreen)
        }
        
        let progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHud.mode = MBProgressHUDMode.indeterminate
        
        if self.overlayView != nil {
            self.fadeOutOverlayView(nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64( 0.2 ) * Int64( NSEC_PER_SEC )) / Double(NSEC_PER_SEC), execute: {
            self.showMessengerExtension(self.imageToSend, imageId: self.imageName?.imageName(), prototypeId: nil)
            UserDefaults.setHasSentImageOrText( true )
        });
        
    }
    
    func sendWithOS() {
        
        let activityVC = UIActivityViewController(activityItems: [self.imageToSend!], applicationActivities: nil)
        
        if #available(iOS 9.0, *) {
            let excludedActivities = [UIActivityType.openInIBooks]
            activityVC.excludedActivityTypes = excludedActivities
        }
        
        AnalyticsManager.shared().postAction( withType: kGAShareViaIntent, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: kGAItemDetailScreen)
        
        if let nonNilIndexPath = indexPath {
            
            AnalyticsManager.shared().postAction( withType: kGAShareViaIntent, targetType: kGATargetTypeText, targetId: self.viewModel.textId(nonNilIndexPath.row), targetParameter: nil, actionLocation: kGAItemDetailScreen)
            
            AnalyticsManager.shared().postAction( withType: kGAShareViaIntent, targetType: kGATargetTypeImage, targetId: self.imageName?.imageName(), targetParameter: nil, actionLocation: kGAItemDetailScreen)
            
            AnalyticsManager.shared().postAction( withType: kGALinkEvents, targetType: kGATargetTypeApp, targetId: self.viewModel.textId(nonNilIndexPath.row), targetParameter: self.imageName?.imageName(), actionLocation: kGAItemDetailScreen)
            
        }
        else {
            AnalyticsManager.shared().postAction( withType: kGAShareViaIntent, targetType: kGATargetTypeImage, targetId: self.imageName?.imageName(), targetParameter: nil, actionLocation: kGAItemDetailScreen)
        }
        
        
        let progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHud.mode = MBProgressHUDMode.indeterminate
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64( 0.2 ) * Int64( NSEC_PER_SEC )) / Double(NSEC_PER_SEC), execute: { [weak self] in
            self?.present(activityVC, animated: true, completion: {
                progressHud.hide( animated: true )
                UserDefaults.setHasSentImageOrText( true )
            })
        });
        
    }
    
    func chooseSendMethod() {
        
        if UserDefaults.sendMethodForMessage() == MessageSendMethod.noMethod {
            
            if let nonNilIndexPath = indexPath {
                AnalyticsManager.shared().postAction(withType: kGASendMenuOpened, targetType: kGATargetTypeApp, targetId: self.viewModel.textId(nonNilIndexPath.row), targetParameter: self.imageName?.imageName(), actionLocation: kGAItemDetailScreen)
            }
            else {
                AnalyticsManager.shared().postAction(withType: kGASendMenuOpened, targetType: kGATargetTypeApp, targetId: self.imageName?.imageName(), targetParameter: nil, actionLocation: kGAItemDetailScreen)
            }
            
            overlayView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width , height: self.view.frame.height))
            overlayView?.backgroundColor = UIColor.c_color(withHexString: UIColor.c_hexValues(from: UIColor.black), alpha:  0.3)
            overlayView?.alpha = 0.0
            
            let backgroundButton = MAXFadeBlockButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            backgroundButton.backgroundColor = UIColor.clear
            backgroundButton.buttonTouchUpInside(completion: { [weak self] in
                self?.fadeOutOverlayView(nil)
            })
            
            overlayView?.addSubview( backgroundButton )
            
            self.view.addSubview( overlayView! )
            
            let chooseMethodView = UIView(frame: CGRect(x: self.view.frame.width * 0.15, y: self.view.frame.height * 0.3, width: self.view.frame.width * 0.7, height: self.view.frame.width * 0.7))
            chooseMethodView.layer.backgroundColor = UIColor.white.cgColor
            chooseMethodView.layer.borderColor = UIColor.c_blue().cgColor
            chooseMethodView.layer.borderWidth = 2.0
            chooseMethodView.layer.cornerRadius = 5.0
            chooseMethodView.layer.masksToBounds = true
            
            overlayView!.addSubview( chooseMethodView )
            
            
            let titleLabel = UILabel(frame:  CGRect(x: 0, y: 0, width: chooseMethodView.frame.width, height: chooseMethodView.frame.height * 0.15))
            titleLabel.font = UIFont.c_robotoBold( withSize: 16.0 )
            titleLabel.textColor = UIColor.c_textDarkGray()
            titleLabel.textAlignment = .center
            titleLabel.text = PopularStickersLocalizedString("<ChooseSendMethod>", nil)
            
            chooseMethodView.addSubview( titleLabel )
            
            
            let messengerButtonContainerRow = MAXFadeBlockButton(frame: CGRect(x: 0, y: chooseMethodView.frame.height * 0.16 - chooseMethodView.frame.width * 0.035, width: chooseMethodView.frame.width , height: chooseMethodView.frame.width * 0.18 + chooseMethodView.frame.width * 0.07))
            chooseMethodView.addSubview( messengerButtonContainerRow )
            
            
            let messengerButton = FBSDKMessengerShareButton.circularButton( with: FBSDKMessengerShareButtonStyle.blue )
            messengerButton?.frame = CGRect(x: chooseMethodView.frame.width * 0.06, y: chooseMethodView.frame.height * 0.035, width: chooseMethodView.frame.width * 0.18, height: chooseMethodView.frame.width * 0.18)
            messengerButton?.isUserInteractionEnabled = false
            
            messengerButtonContainerRow.addSubview( messengerButton! )
            
            let messengerTitle = UILabel(frame: CGRect(x: (messengerButton?.frame.maxX)! + 10, y: (messengerButton?.frame.minY)!, width: chooseMethodView.frame.width * 0.6, height: (messengerButton?.frame.height)!))
            messengerTitle.textAlignment = .left
            messengerTitle.textColor = UIColor.c_textDarkGray()
            messengerTitle.font = UIFont.c_robotoMedium( withSize: 15.0 )
            messengerTitle.text = PopularStickersLocalizedString("<MessengerMethod>", nil)
            
            messengerButtonContainerRow.addSubview( messengerTitle )
            
            let otherButtonContainerRow = MAXFadeBlockButton(frame: CGRect(x: 0, y: messengerButtonContainerRow.frame.maxY - chooseMethodView.frame.width * 0.02, width: chooseMethodView.frame.width, height: chooseMethodView.frame.width * 0.18 + chooseMethodView.frame.width * 0.07))
            chooseMethodView.addSubview( otherButtonContainerRow )
            
            let otherButton = MAXFadeBlockButton(frame: CGRect(x: (messengerButton?.frame.minX)!, y: chooseMethodView.frame.width * 0.035, width: chooseMethodView.frame.width * 0.18, height: chooseMethodView.frame.width * 0.18))
            otherButton.backgroundColor = UIColor.c_green()
            otherButton.layer.cornerRadius = otherButton.frame.width / 2.0
            otherButton.isUserInteractionEnabled = false
            
            
            
            var smsImage = UIImage(named: "SmsIcon")
            smsImage = smsImage?.withRenderingMode( UIImageRenderingMode.alwaysTemplate )
            
            let smsImageView = UIImageView(frame: CGRect(x: otherButton.frame.width * 0.22, y: otherButton.frame.height * 0.17, width: otherButton.frame.width * 0.26, height: otherButton.frame.width * 0.26))
            smsImageView.image = smsImage
            smsImageView.tintColor = UIColor.white
            otherButton.addSubview( smsImageView )
            
            var whatsAppImage = UIImage(named: "WhatsAppIcon")
            whatsAppImage = whatsAppImage?.withRenderingMode( UIImageRenderingMode.alwaysTemplate )
            
            let whatsAppImageView = UIImageView(frame: CGRect(x: otherButton.frame.width * 0.58, y: otherButton.frame.height * 0.32, width: otherButton.frame.width * 0.3, height: otherButton.frame.width * 0.3))
            whatsAppImageView.image = whatsAppImage
            whatsAppImageView.tintColor = UIColor.white
            otherButton.addSubview( whatsAppImageView )
            
            var emailImage = UIImage(named:  "EmailIcon")
            emailImage = emailImage?.withRenderingMode( UIImageRenderingMode.alwaysTemplate )
            
            let emailImageView = UIImageView(frame: CGRect(x: otherButton.frame.width * 0.2, y: otherButton.frame.height * 0.55, width: otherButton.frame.width * 0.33, height: otherButton.frame.width * 0.33))
            emailImageView.image = emailImage
            emailImageView.tintColor = UIColor.white
            otherButton.addSubview( emailImageView )
            
            
            otherButtonContainerRow.addSubview( otherButton )
            
            let otherSendMethodTitleLabel = UILabel(frame: CGRect(x: otherButton.frame.maxX + 10, y: otherButton.frame.minY, width: chooseMethodView.frame.width * 0.6, height: otherButton.frame.height))
            otherSendMethodTitleLabel.textAlignment = .left
            otherSendMethodTitleLabel.textColor = UIColor.c_textDarkGray()
            otherSendMethodTitleLabel.font = UIFont.c_robotoMedium( withSize: 15.0 )
            otherSendMethodTitleLabel.text = PopularStickersLocalizedString("<OtherMethod>", nil)
            
            otherButtonContainerRow.addSubview( otherSendMethodTitleLabel )
            
            let bottomBlueFooter = UIView(frame: CGRect(x: 0, y: chooseMethodView.frame.height * 0.84, width: chooseMethodView.frame.width , height: chooseMethodView.frame.height * 0.16 ))
            bottomBlueFooter.backgroundColor = UIColor.c_blue()
            
            chooseMethodView.addSubview( bottomBlueFooter )
            
            if  UserDefaults.hasSentImageOrText() == true {
                
                self.rememberMethodSwitch = MBSwitch(frame: CGRect(x: chooseMethodView.frame.width * 0.08, y: otherButtonContainerRow.frame.maxY + chooseMethodView.frame.width * 0.035, width: chooseMethodView.frame.width * 0.15, height: chooseMethodView.frame.width * 0.1))
                self.rememberMethodSwitch!.onTintColor = UIColor.c_blue()
                chooseMethodView.addSubview( rememberMethodSwitch! )
                
                let rememberTitleLabel = UILabel(frame: CGRect(x: self.rememberMethodSwitch!.frame.maxX + 10, y: self.rememberMethodSwitch!.frame.minY, width: chooseMethodView.frame.width * 0.7, height: chooseMethodView.frame.width * 0.1))
                rememberTitleLabel.textAlignment = .left
                rememberTitleLabel.textColor = UIColor.c_textDarkGray()
                rememberTitleLabel.font = UIFont.c_robotoMedium( withSize: 15.0 )
                rememberTitleLabel.text = PopularStickersLocalizedString("<RememberSendMethod>", nil)
                chooseMethodView.addSubview( rememberTitleLabel )
                
            }
            else {
                
                messengerButtonContainerRow.frame = CGRect(x: 0, y: chooseMethodView.frame.height * 0.2, width: chooseMethodView.frame.width , height: chooseMethodView.frame.width * 0.18 + chooseMethodView.frame.width * 0.07)
                otherButtonContainerRow.frame = CGRect(x: 0, y: messengerButtonContainerRow.frame.maxY + chooseMethodView.frame.width * 0.05, width: chooseMethodView.frame.width, height: chooseMethodView.frame.width * 0.18 + chooseMethodView.frame.width * 0.07)
                
                
            }
            
            let cancelButton = MAXFadeBlockButton(frame: CGRect(x: 0, y: 0, width: bottomBlueFooter.frame.width, height: bottomBlueFooter.frame.height))
            cancelButton.setTitle(PopularStickersLocalizedString("<NotificationAlertCancelTitle>", nil), for: UIControlState())
            cancelButton.titleLabel!.font = UIFont.c_robotoMedium( withSize: 15.0 )
            cancelButton.setTitleColor(UIColor.white, for: UIControlState())
            
            
            cancelButton.buttonTouchUpInside(completion: { [weak self] in
                
                self?.fadeOutOverlayView(nil)
                
            })
            
            bottomBlueFooter.addSubview( cancelButton )
            
            
            messengerButtonContainerRow.buttonTouchUpInside(completion: { [weak self] in
                
                if UserDefaults.hasSentImageOrText() == true && self?.rememberMethodSwitch != nil {
                    if self?.rememberMethodSwitch!.isOn == true {
                        UserDefaults.setSendMethodForMessage( MessageSendMethod.messenger )
                    }
                }
                
                self?.fadeOutOverlayView(nil)
                
                self?.sendWithMessenger()
                
            })
            
            otherButtonContainerRow.buttonTouchUpInside(completion: { [weak self] in
                
                if UserDefaults.hasSentImageOrText() == true && self?.rememberMethodSwitch != nil {
                    if self?.rememberMethodSwitch!.isOn == true {
                        UserDefaults.setSendMethodForMessage(  MessageSendMethod.OS )
                    }
                }
                
                self?.fadeOutOverlayView(nil)
                
                self?.sendWithOS()
                
            })
            
            UIView.animate(withDuration: 0.1, animations: {
                self.overlayView!.alpha = 1.0
            })
        }
        else if UserDefaults.sendMethodForMessage() == MessageSendMethod.messenger {
            
            self.sendWithMessenger()
        }
        else if UserDefaults.sendMethodForMessage() == MessageSendMethod.OS {
            
            self.sendWithOS()
        }
        
    }
    
    
    func fadeOutOverlayView(_ completion: (() -> Void)?) {
        weak var wSelf = self
        UIView.animate(withDuration: 0.1, animations: {
            wSelf?.overlayView!.alpha = 0.0
            }, completion: {
                finished -> Void in
                
                wSelf?.overlayView!.removeFromSuperview()
                
        })
    }
    
    // MARK: Animate button and info view
    
    func animateButtonDownAndInfoOut() {
        weak var wSelf = self
        UIView.animate(withDuration: 0.3, animations: {
            
            wSelf?.infoLabel.alpha = 0.0
            wSelf?.bottomButton.c_setOriginY( Float(self.view.frame.height - self.backButton.frame.size.height - 20))
            wSelf?.tableView.separatorColor = UIColor.clear
            
        })
        
        self.bottomButton.setTitle(PopularStickersLocalizedString("<Send>", ""), for: UIControlState())
        
    }
    
    func animateButtonUpAndInfoIn() {
        weak var wSelf = self
        UIView.animate(withDuration: 0.3, animations: {
            
            if self.backToMessengerButton?.superview == nil {
                
                wSelf?.bottomButton.frame = CGRect(x: self.view.frame.midX - 90, y: self.imageView.frame.height - 50 - self.imageView.frame.height * 0.05, width: 180, height: 50)
            }
            else {
                
                wSelf?.bottomButton.frame = CGRect(x: self.view.frame.midX - 90, y: self.imageView.frame.height - 10 - self.imageView.frame.height * 0.05, width: 180, height: 50)
            }
            
            wSelf?.infoLabel.alpha = 1.0
            wSelf?.tableView.separatorColor = UIColor.lightGray
        
        })
        
        bottomButton.setTitle(PopularStickersLocalizedString("<Send>", ""), for: UIControlState())
        
    }

    // MARK: Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.numberOfTexts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") as? PopularTextsTableViewCell
        
        if cell == nil {
            cell = PopularTextsTableViewCell(style: .default, reuseIdentifier: "cellIdentifier")
            cell?.popularTextLabel.font = UIFont.c_robotoLight(withSize: 17.0)
            
            let selectionView = UIView()
            selectionView.backgroundColor = UIColor.c_lightBlueCellHighlight()
            
            cell?.selectedBackgroundView = selectionView
            
        }
        
        cell?.popularTextLabel.text = self.viewModel.textContent(indexPath.row)
        
        cell?.nbSharesLabel.text = self.viewModel.textNumberOfShares(indexPath.row)
        cell?.nbSharesLabel.textAlignment = .right
        cell?.nbSharesLabel.font = UIFont.c_roboto(withSize: 15.0)
        
        cell?.nbSharesImageView.image = UIImage(named: "NbSharesIcon")
        cell?.nbSharesImageView.contentMode = UIViewContentMode.scaleAspectFit
        cell?.nbSharesImageView.isHidden = self.viewModel.textIsDisplayedAndShared(indexPath.row) == false
        
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if self.viewModel.textIsDisplayedAndShared( indexPath.row ) == true {
            return self.viewModel.textHeight(indexPath.row, width: self.view.frame.width * 0.8, font: UIFont.c_robotoLight(withSize: 17.0)) + 60
        }
        
        return self.viewModel.textHeight(indexPath.row, width: self.view.frame.width * 0.8, font: UIFont.c_robotoLight(withSize: 17.0)) + 30
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let text = self.viewModel.textContent(indexPath.row) {
            
            self.indexPath = indexPath
            self.imageToSend = self.createImage(text)
            self.chooseSendMethod()
            
        }
        
    }

    
    func createMetadataJsonString(_ imageId: String?, prototypeId: String?) -> String? {
        
        let mutableDict = NSMutableDictionary()
        
        mutableDict.setObject(1, forKey: "version" as NSCopying)
        
        if let intentionId = self.viewModel.intentionId {
            mutableDict.setObject(intentionId, forKey: "intentionId" as NSCopying)
        }
        else {
            mutableDict.setObject(NSNull(), forKey: "intentionId" as NSCopying)
        }
        
        if let imagePath = self.viewModel.imagePath {
            mutableDict.setObject(imagePath, forKey: "imagePath" as NSCopying)
        }
        
        // not supported yet
        if let nonNilPrototypeId = prototypeId {
            mutableDict.setObject(nonNilPrototypeId, forKey: "prototypeId" as NSCopying)
        }
        else {
            mutableDict.setObject(NSNull(), forKey: "prototypeId" as NSCopying)
        }
        mutableDict.setObject(NSNull(), forKey: "recipientType" as NSCopying)
        
        
        if let imageName = imageId {
            
            if let lastComponent = imageName.components(separatedBy: "/").last {
                mutableDict.setObject(lastComponent, forKey: "imageName" as NSCopying)
            }
        }
        
        
        
        do {
            let data = try JSONSerialization.data(withJSONObject: mutableDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            let jsonString = String(data: data, encoding: String.Encoding.utf8)
            
            return jsonString
            
        }
        catch {
            
        }
        
        return nil
    }
    
    // MARK: Image Creation and Extensions
    
    func showMessengerExtension(_ image: UIImage?, imageId: String?, prototypeId: String?) {
        
        if let nonNilImage = image, let _ = imageId {
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            let options = FBSDKMessengerShareOptions()
            
            options.contextOverride = AppFlow.currentContext()
            options.metadata = self.createMetadataJsonString(imageId, prototypeId: prototypeId)
            FBSDKMessengerSharer.share(nonNilImage, with: options)
            
        }
    }
    
    // MARK: Create Image With Text
    
    func createImage(_ text: String) -> UIImage {
        
        let imageView = UIImageView(image: self.imageToShow)
        
        let biggerSide = imageView.frame.size.width
        
        let fontSize  = biggerSide / 16.0
        let font = UIFont.c_robotoLight(withSize: Float(fontSize))
        
        let fontHeight = NSString.c_findHeight(forText: text, havingWidth: imageView.frame.size.width * 0.8, andFont: font)
        
        let label = UILabel(frame: CGRect(x: imageView.frame.width * 0.1, y: imageView.frame.maxY + 40, width: imageView.frame.width * 0.8, height: fontHeight + 6))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = font
        label.text = text
        label.textColor = UIColor.black

        
        let snapshotView = UIView(frame: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: label.frame.maxY + 40))
        snapshotView.backgroundColor = UIColor.white
        snapshotView.addSubview(imageView)
        snapshotView.addSubview(label)
        
        
        return snapshotView.imageByRenderingView()
        
    }
    
    
    // MARK: Messenger Integration
    
    func addOrRemoveBackToMessengerButton() {
        
        if AppFlow.currentMessengerFlow == MessengerFlow.send {
            self.backToMessengerButton?.removeFromSuperview()
            self.imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.6)
            self.backButton.frame = CGRect(x: self.view.frame.width * 0.05, y: 20 + self.view.frame.width * 0.05, width: self.view.frame.width * 0.12, height: self.view.frame.width * 0.12)
        }
        else {
            
            if self.backToMessengerButton?.superview == nil {
                self.view.addSubview(self.backToMessengerButton!)
            }
            
            self.imageView.frame = CGRect(x: 0, y: 40, width: self.view.frame.width, height: self.view.frame.height * 0.6 - 40)
            self.backButton.frame = CGRect(x: self.view.frame.width * 0.05, y: 20 + 40 + self.view.frame.width * 0.05, width: self.view.frame.width * 0.12, height: self.view.frame.width * 0.12)
            
        }
        
    }
    
    deinit {
        print("deinit sticker detail")
    }

}
