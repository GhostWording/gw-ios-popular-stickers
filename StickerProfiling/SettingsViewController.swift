//
//  SettingsViewController.swift
//  WhatsAppMessageComposer
//
//  Created by Mathieu Skulason on 03/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SettingsViewController: RootViewController, FBSDKLoginButtonDelegate {

    // MARK: Gloabl Label
    var stickersTitleLabel: UILabel!
    var languageTitle: UILabel!
    var notificationTitle: UILabel!
    var genderTitle: UILabel!
    var sendMethodLabel : UILabel!
    var livingSituationTitle: UILabel!
    var ageTitle: UILabel!
    
    // MARK: Gloabal buttons
    var maleButton: MAXFadeBlockButton!
    var femaleButton: MAXFadeBlockButton!
    
    var frenchButton: MAXFadeBlockButton!
    var englishButton: MAXFadeBlockButton!
    var spanishButton: MAXFadeBlockButton!
    
    var notifOnceADayButton: MAXFadeBlockButton!
    var notifEveryOtherDayButton: MAXFadeBlockButton!
    var notifOnceAWeekButton: MAXFadeBlockButton!
    
    var personalityTypeButton : MAXFadeBlockButton!
    
    var messengerSendMethodButton : MAXFadeBlockButton!
    var otherSendMethodButton : MAXFadeBlockButton!
    
    var liveAloneButton: MAXFadeBlockButton!
    var liveWithSomeoneButton: MAXFadeBlockButton!
    
    var under17Button: MAXFadeBlockButton!
    var between18And35Button: MAXFadeBlockButton!
    var between35And65Button: MAXFadeBlockButton!
    var over65Button: MAXFadeBlockButton!
    
    var facebookLoginButton : FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64))
        headerView.backgroundColor = UIColor.c_blue()
        
        self.view.addSubview(headerView)
        
        
        let stickersTitleLabel = UILabel(frame: CGRect( x: 20, y: 20, width: self.view.frame.width - 20 - self.view.frame.width * 0.1, height: 44))
        stickersTitleLabel.textAlignment = .left
        stickersTitleLabel.textColor = UIColor.white
        stickersTitleLabel.text = PopularStickersLocalizedString("<SettingsTitle>", nil)
        stickersTitleLabel.font = UIFont.c_roboto(withSize: Float(self.view.frame.height * 0.03))
        
        headerView.addSubview(stickersTitleLabel)
        
        let tabBarHeight = self.tabBarController != nil ? self.tabBarController!.tabBar.frame.size.height : 0
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: headerView.frame.height, width: self.view.frame.width, height: self.view.frame.height - headerView.frame.height))
        scrollView.backgroundColor = UIColor.white
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, tabBarHeight * 1.4, 0)
        
        self.view.addSubview(scrollView)
        
        let leftOffset = self.view.frame.width * 0.05
        let heightOffset = CGFloat(0)
        
        let controlStandardHeight: CGFloat = 32
        let titleOffset: CGFloat = 14
        
        
        languageTitle = self.createTitle(PopularStickersLocalizedString("<ChooseLanguageTitle>", nil), xOffset: leftOffset, yOffset: heightOffset + self.view.frame.width * 0.03 , height: controlStandardHeight)
        scrollView.addSubview(languageTitle);
        
        let heightButton: CGFloat = 48;
        
        englishButton = self.createButton(PopularStickersLocalizedString("<EnglishTitle>", nil), titleInset: leftOffset, frame: CGRect(x: 0, y: languageTitle.frame.maxY + heightOffset, width: self.view.frame.width, height: heightButton), parentView: scrollView)
        frenchButton = self.createButton(PopularStickersLocalizedString("<FrenchTitle>", nil), titleInset: leftOffset, frame: CGRect(x: 0, y: englishButton.frame.maxY, width: self.view.frame.width, height: heightButton), parentView: scrollView)
        spanishButton = self.createButton(PopularStickersLocalizedString("<SpanishTitle>", nil), titleInset: leftOffset, frame: CGRect(x: 0, y: frenchButton.frame.maxY, width: self.view.frame.width, height: heightButton), parentView: scrollView)
        
        
        notificationTitle = self.createTitle(PopularStickersLocalizedString("<ReceiveNotificationTitle>", nil), xOffset: leftOffset, yOffset: spanishButton.frame.maxY + titleOffset
            , height: controlStandardHeight)
        notificationTitle.c_setWidth( Float(self.view.frame.width) - Float( leftOffset ) - Float( self.view.frame.width ) * 0.2)
        
        let notificationSwitch = MAXBlockSwitch()
        notificationSwitch.onTintColor = UIColor.c_blue()
        notificationSwitch.isOn = UserDefaults.wantsNotification()
        
        let notificationSwitchHeight = Float(notificationSwitch.frame.height) / 2.0
        notificationSwitch.c_setOriginY( (Float( notificationTitle.frame.maxY ) - Float(notificationTitle.frame.height) / 2.0) - notificationSwitchHeight)
        notificationSwitch.c_setOriginX( Float( self.view.frame.width ) * 0.82)
        
        var switchTapCounter = 0
        
        notificationSwitch.switchValueChanged(completion: { [weak self] in
            
            switchTapCounter += 1
            
            if notificationSwitch.isOn == true {
                
                if UserDefaults.isNotificationRegistered() == false {
                    let application = UIApplication.shared
                    application.registerUserNotificationSettings( UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound] , categories: nil))
                }
                UserDefaults.setWantsNotification(true)
            }
            else {
                UserDefaults.setWantsNotification(false)
            }
            
            if switchTapCounter % 10 == 0 {
                
                var developerModeString = ""
                if UserDefaults.developerModeEnabled() == false {
                    UserDefaults.setDeveloperMode( true )
                    developerModeString = "Developer Mode Enabled"
                }
                else {
                    UserDefaults.setDeveloperMode( false )
                    developerModeString = "Developer Mode Disabled"
                }
                
                let developerModeLabel = UILabel(frame: CGRect(x: self!.view.frame.width * 0.1, y: self!.view.frame.height - self!.view.frame.width * 0.4, width: self!.view.frame.width * 0.8, height: self!.view.frame.height * 0.2))
                developerModeLabel.textAlignment = .center
                developerModeLabel.layer.cornerRadius = 5
                developerModeLabel.layer.backgroundColor = UIColor.darkGray.cgColor
                developerModeLabel.textColor = UIColor.white
                developerModeLabel.font = UIFont.c_robotoMedium( withSize: 14.0 )
                developerModeLabel.text = developerModeString
                developerModeLabel.sizeToFit()
                developerModeLabel.frame = CGRect(x: self!.view.frame.midX - developerModeLabel.frame.width * 0.7, y: self!.view.frame.height * 0.6 , width: developerModeLabel.frame.width * 1.4, height: developerModeLabel.frame.height * 1.7)
                self?.view.addSubview( developerModeLabel )
                
                UIView.animate(withDuration: 2.5, animations: {
                    
                    developerModeLabel.alpha = 0.0
                    
                    }, completion: {
                        succeeded in
                        
                        if succeeded == true {
                            developerModeLabel.removeFromSuperview()
                        }
                        
                })
                
                
            }

            
        })
        
        scrollView.addSubview(notificationSwitch)
        
        
        scrollView.addSubview(notificationTitle)
        
        
        notifOnceADayButton = self.createButton(PopularStickersLocalizedString("<OnceNotificationPerDay>", nil), titleInset: leftOffset, frame: CGRect(x: 0, y: notificationTitle.frame.maxY + heightOffset, width: self.view.frame.width, height: heightButton), parentView: scrollView)
        notifEveryOtherDayButton = self.createButton(PopularStickersLocalizedString("<OneNotificationEveryOtherDay>", nil), titleInset: leftOffset, frame: CGRect(x: 0, y: notifOnceADayButton.frame.maxY, width: self.view.frame.width, height: heightButton), parentView: scrollView)
        notifOnceAWeekButton = self.createButton(PopularStickersLocalizedString("<OneNotificationEveryWeek>", nil), titleInset: leftOffset, frame: CGRect(x: 0, y: notifEveryOtherDayButton.frame.maxY, width: self.view.frame.width, height: heightButton), parentView: scrollView)
        
        
        personalityTypeButton = MAXFadeBlockButton(frame: CGRect(x: 0, y: notifOnceAWeekButton.frame.maxY, width: self.view.frame.width, height: self.view.frame.width * 0.06 + controlStandardHeight ))
        personalityTypeButton.setTitle(PopularStickersLocalizedString("<MyMBTI>", nil), for: UIControlState())
        personalityTypeButton.setTitleColor(UIColor.black, for: UIControlState())
        personalityTypeButton.titleEdgeInsets = UIEdgeInsetsMake(0, leftOffset, 0, 0)
        personalityTypeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        personalityTypeButton.titleLabel?.font = UIFont.c_roboto( withSize: 18.0 )
        
        var arrowImage = UIImage(named: "BackArrowIcon")
        arrowImage = arrowImage?.withRenderingMode( UIImageRenderingMode.alwaysTemplate )
        
        let arrowImageView = UIImageView(frame: CGRect(x: personalityTypeButton.frame.width - personalityTypeButton.frame.height * 0.4, y: personalityTypeButton.frame.height * 0.3, width: personalityTypeButton.frame.height * 0.4, height: personalityTypeButton.frame.height * 0.4))
        arrowImageView.image = arrowImage
        arrowImageView.tintColor = UIColor.darkGray
        arrowImageView.transform = CGAffineTransform( rotationAngle: CGFloat(M_PI) )
        personalityTypeButton.addSubview( arrowImageView )
        
        personalityTypeButton.buttonTouchUpInside(completion: { [weak self] in
            
            let personalityPicker = PersonalityIntroViewController(type: PersonalityViewControllerType.settings)
            self?.present( personalityPicker, animated: true, completion: nil)
            
        })
        
        scrollView.addSubview( personalityTypeButton )
        
        let personalitySeparator = UIView(frame: CGRect( x: 0, y: personalityTypeButton.frame.maxY, width: self.view.frame.width, height: 1))
        personalitySeparator.backgroundColor = UIColor.c_textLightGray()
        scrollView.addSubview( personalitySeparator )
        
        
        
        sendMethodLabel = self.createTitle(PopularStickersLocalizedString("<ChooseSendMethodSettings>", nil), xOffset: leftOffset, yOffset: personalitySeparator.frame.maxY + titleOffset, height: controlStandardHeight)
        
        scrollView.addSubview( sendMethodLabel )
        
        messengerSendMethodButton = self.createButton(PopularStickersLocalizedString("<MessengerMethod>", nil), titleInset: leftOffset, frame: CGRect(x: 0, y: sendMethodLabel.frame.maxY + heightOffset, width: self.view.frame.width, height: heightButton), parentView: scrollView)
        
        otherSendMethodButton = self.createButton(PopularStickersLocalizedString("<OtherMethod>", nil), titleInset: leftOffset, frame: CGRect(x: 0, y: messengerSendMethodButton.frame.maxY, width: self.view.frame.width, height: heightButton), parentView: scrollView)
        
        
        
        genderTitle = self.createTitle(PopularStickersLocalizedString("<MyGenderTitle>", nil), xOffset: leftOffset, yOffset: otherSendMethodButton.frame.maxY + titleOffset, height: controlStandardHeight)
        
        scrollView.addSubview(genderTitle)
        
        maleButton = self.createButton(PopularStickersLocalizedString("<MaleString>", nil), titleInset: leftOffset, frame: CGRect(x: 0, y: genderTitle.frame.maxY + heightOffset, width: self.view.frame.width, height: heightButton), parentView: scrollView)
        femaleButton = self.createButton(PopularStickersLocalizedString("<FemaleString>", nil), titleInset: leftOffset, frame: CGRect(x: 0, y: maleButton.frame.maxY, width: self.view.frame.width, height: heightButton), parentView: scrollView)
        
        livingSituationTitle = self.createTitle(PopularStickersLocalizedString("<RelationshipStatusTitle>", nil), xOffset: leftOffset, yOffset: femaleButton.frame.maxY + titleOffset, height: controlStandardHeight)
        
        scrollView.addSubview(livingSituationTitle)
        
        liveAloneButton = self.createButton(PopularStickersLocalizedString("<LiveOnMyOwnTitle>", nil), titleInset: leftOffset, frame: CGRect(x: 0, y: livingSituationTitle.frame.maxY + heightOffset, width: self.view.frame.width, height: heightButton), parentView: scrollView)
        liveWithSomeoneButton = self.createButton(PopularStickersLocalizedString("<LiveWithSomeoneTitle>", nil), titleInset: leftOffset, frame: CGRect(x: 0, y: liveAloneButton.frame.maxY, width: self.view.frame.width, height: heightButton), parentView: scrollView)
        
        
        ageTitle = self.createTitle(PopularStickersLocalizedString("<MyAgeTitle>", nil), xOffset: leftOffset, yOffset: liveWithSomeoneButton.frame.maxY + titleOffset, height: controlStandardHeight)
        
        scrollView.addSubview(ageTitle)
        
        under17Button = self.createButton(PopularStickersLocalizedString("<17>", nil), titleInset: leftOffset, frame: CGRect(x: 0, y: ageTitle.frame.maxY + heightOffset, width: self.view.frame.width, height: heightButton), parentView: scrollView)
        between18And35Button = self.createButton(PopularStickersLocalizedString("<18-39>", nil), titleInset: leftOffset, frame: CGRect(x: 0, y: under17Button.frame.maxY, width: self.view.frame.width, height: heightButton), parentView: scrollView)
        between35And65Button = self.createButton(PopularStickersLocalizedString("<40-64>", nil), titleInset: leftOffset, frame: CGRect(x: 0, y: between18And35Button.frame.maxY, width: self.view.frame.width, height: heightButton), parentView: scrollView)
        over65Button = self.createButton(PopularStickersLocalizedString("<65>", nil), titleInset: leftOffset, frame: CGRect(x: 0, y: between35And65Button.frame.maxY, width: self.view.frame.width, height: heightButton), parentView: scrollView)
        
        
        facebookLoginButton = FBSDKLoginButton(frame: CGRect(x: self.view.frame.midX - 120, y: over65Button.frame.maxY + 20, width: 240, height: 60))
        facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        facebookLoginButton.delegate = self
        scrollView.addSubview(facebookLoginButton)
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: facebookLoginButton.frame.maxY + 20)
        
        self.updateSelectedStateOfButtons()
        
        
        // MARK: Button touches and User Defaults Update
        
        englishButton.buttonTouchUpInside(completion: { [weak self] in
            
            if GWLocalizedBundle.currentLocaleAPIString() != englishCultureString {
                
                GWLocalizedBundle.setLanguage("en")
                
                AnalyticsManager.shared().postAction( withType: kGASetLanguage, targetType: kGATargetTypeApp, targetId: GWLocalizedBundle.currentLocaleString(), targetParameter: nil, actionLocation: kGAUserProfileScreen)
                
                GWDataManager().downloadAllTextsWithBlock(forArea: "stickers", withCulture: GWLocalizedBundle.currentLocaleAPIString(), withCompletion: {
                    texts, error -> Void in
                    
                    print("french texts downloaded")
                    
                })
                
                if let presentedVC = self?.presentingViewController as? StickersOverviewController {
                    
                    presentedVC.reloadData()
                    
                }
            }
            
            self?.updateSelectedStateOfButtons()
            self?.updateUIWithNewLanguage()
        })
        
        frenchButton.buttonTouchUpInside(completion: { [weak self] in
            
            if GWLocalizedBundle.currentLocaleAPIString() != frenchCultureString {
                
                GWLocalizedBundle.setLanguage("fr")
                
                AnalyticsManager.shared().postAction( withType: kGASetLanguage, targetType: kGATargetTypeApp, targetId: GWLocalizedBundle.currentLocaleString(), targetParameter: nil, actionLocation: kGAUserProfileScreen)
                
                GWDataManager().downloadAllTextsWithBlock(forArea: "stickers", withCulture: GWLocalizedBundle.currentLocaleAPIString(), withCompletion: {
                    texts, error -> Void in
                    
                    print("french texts downloaded")
                    
                })
                
                if let presentedVC = self?.presentingViewController as? StickersOverviewController {
                    
                    presentedVC.reloadData()
                    
                }
            }
            
            self?.updateSelectedStateOfButtons()
            self?.updateUIWithNewLanguage()
        })
        
        spanishButton.buttonTouchUpInside(completion: { [weak self] in
            
            if GWLocalizedBundle.currentLocaleAPIString() != spanishCultureString {
                
                GWLocalizedBundle.setLanguage("es")
                
                AnalyticsManager.shared().postAction( withType: kGASetLanguage, targetType: kGATargetTypeApp, targetId: GWLocalizedBundle.currentLocaleString(), targetParameter: nil, actionLocation: kGAUserProfileScreen)
                
                GWDataManager().downloadAllTextsWithBlock(forArea: "stickers", withCulture: GWLocalizedBundle.currentLocaleAPIString(), withCompletion: {
                    texts, error -> Void in
                    
                    print("french texts downloaded")
                    
                })
                
                if let presentedVC = self?.presentingViewController as? StickersOverviewController {
                    
                    presentedVC.reloadData()
                    
                }
            }
            
            self?.updateSelectedStateOfButtons()
            self?.updateUIWithNewLanguage()
        })
        
        
        notifOnceADayButton.buttonTouchUpInside(completion: { [weak self] in
            
            UserDefaults.setUserNotificationFrequency( NSNumber(value: Int32( UserNotifications.OneMessageADay.rawValue ) as Int32))
            
            AnalyticsManager.shared().postAction( withType: kGANotificationFrequency, targetType: kGATargetTypeApp, targetId: "OnceADay", targetParameter: nil, actionLocation: kGAUserProfileScreen)
        
            self?.updateSelectedStateOfButtons()
        })
        
        notifEveryOtherDayButton.buttonTouchUpInside(completion: { [weak self] in
            
            UserDefaults.setUserNotificationFrequency( NSNumber(value: Int32( UserNotifications.OneMessageEveryOtherDay.rawValue ) as Int32))
            
            AnalyticsManager.shared().postAction( withType: kGANotificationFrequency, targetType: kGATargetTypeApp, targetId: "EveryOtherDay", targetParameter: nil, actionLocation: kGAUserProfileScreen)
            
            self?.updateSelectedStateOfButtons()
        })
        
        notifOnceAWeekButton.buttonTouchUpInside(completion: { [weak self] in
            
            UserDefaults.setUserNotificationFrequency( NSNumber(value: Int32( UserNotifications.OneMessageAWeek.rawValue ) as Int32))
            
            AnalyticsManager.shared().postAction( withType: kGANotificationFrequency, targetType: kGATargetTypeApp, targetId: "OnceAWeek", targetParameter: nil, actionLocation: kGAUserProfileScreen)
            
            self?.updateSelectedStateOfButtons()
        })
        
        
        messengerSendMethodButton.buttonTouchUpInside(completion: { [weak self] in
            
            UserDefaults.setSendMethodForMessage( MessageSendMethod.messenger )
            self?.updateSelectedStateOfButtons()
            
        })
        
        otherSendMethodButton.buttonTouchUpInside(completion: { [weak self] in
            
            UserDefaults.setSendMethodForMessage( MessageSendMethod.OS )
            self?.updateSelectedStateOfButtons()
            
        })
        
        
        maleButton.buttonTouchUpInside(completion: { [weak self] in
            
            UserDefaults.setUserGender( maleGender )
            
            AnalyticsManager.shared().postAction( withType: kGAGender, targetType: kGATargetTypeApp, targetId: UserDefaults.userGender(), targetParameter: nil, actionLocation: kGAUserProfileScreen)
            
            self?.updateSelectedStateOfButtons()
        })
        
        femaleButton.buttonTouchUpInside(completion: { [weak self] in
            
            UserDefaults.setUserGender( femaleGender )
            
            AnalyticsManager.shared().postAction( withType: kGAGender, targetType: kGATargetTypeApp, targetId: UserDefaults.userGender(), targetParameter: nil, actionLocation: kGAUserProfileScreen)
            
            self?.updateSelectedStateOfButtons()
        })
        
        
        liveAloneButton.buttonTouchUpInside(completion: { [weak self] in
            
            UserDefaults.setUserLivingSituation( NSNumber(value: Int32( UserLivingSituation.LiveAlone.rawValue ) as Int32))
            
            AnalyticsManager.shared().postAction( withType: kGAConjugalSituation, targetType: kGATargetTypeApp, targetId: "Single", targetParameter: nil, actionLocation: kGAUserProfileScreen)
            
            self?.updateSelectedStateOfButtons()
        })
        
        liveWithSomeoneButton.buttonTouchUpInside(completion: { [weak self] in
            
            UserDefaults.setUserLivingSituation( NSNumber(value: Int32( UserLivingSituation.LiveWithSomeone.rawValue ) as Int32))
            
            AnalyticsManager.shared().postAction( withType: kGAConjugalSituation, targetType: kGATargetTypeApp, targetId: "InACouple", targetParameter: nil, actionLocation: kGAUserProfileScreen)
            
            self?.updateSelectedStateOfButtons()
        })
        
        
        under17Button.buttonTouchUpInside(completion: { [weak self] in
            UserDefaults.setUserAge( NSNumber(value: Int32( UserAge.LessThan17.rawValue ) as Int32))
            self?.updateSelectedStateOfButtons()
        })
        between18And35Button.buttonTouchUpInside(completion: { [weak self] in
            UserDefaults.setUserAge( NSNumber(value: Int32( UserAge.Between18And39.rawValue ) as Int32))
            self?.updateSelectedStateOfButtons()
        })
        between35And65Button.buttonTouchUpInside(completion: { [weak self] in
            UserDefaults.setUserAge( NSNumber(value: Int32( UserAge.Between40And64.rawValue ) as Int32))
            self?.updateSelectedStateOfButtons()
        })
        over65Button.buttonTouchUpInside(completion: { [weak self] in
            UserDefaults.setUserAge( NSNumber(value: Int32( UserAge.Over65.rawValue ) as Int32))
            self?.updateSelectedStateOfButtons()
        })
        
    }
    
    
    func updateUIWithNewLanguage() {
        
        self.updateTabBarLocalizedStrings()
        
        languageTitle.text = PopularStickersLocalizedString("<ChooseLanguageTitle>", nil)
        
        englishButton.setTitle(PopularStickersLocalizedString("<EnglishTitle>", nil), for: UIControlState())
        frenchButton.setTitle(PopularStickersLocalizedString("<FrenchTitle>", nil), for: UIControlState())
        spanishButton.setTitle(PopularStickersLocalizedString("<SpanishTitle>", nil), for: UIControlState())
        
        
        notificationTitle.text = PopularStickersLocalizedString("<ReceiveNotificationTitle>", nil)
        
        notifOnceADayButton.setTitle(PopularStickersLocalizedString("<OnceNotificationPerDay>", nil), for: UIControlState())
        notifEveryOtherDayButton.setTitle(PopularStickersLocalizedString("<OneNotificationEveryOtherDay>", nil), for: UIControlState())
        notifOnceAWeekButton.setTitle(PopularStickersLocalizedString("<OneNotificationEveryWeek>", nil), for: UIControlState())
        
        sendMethodLabel.text = PopularStickersLocalizedString("<ChooseSendMethodSettings>", nil)
        
        messengerSendMethodButton.setTitle(PopularStickersLocalizedString("<MessengerMethod>", nil), for: UIControlState())
        otherSendMethodButton.setTitle(PopularStickersLocalizedString("<OtherMethod>", nil), for: UIControlState())
        
        
        personalityTypeButton.setTitle(PopularStickersLocalizedString("<MyMBTI>", nil), for: UIControlState())
        
        
        genderTitle.text = PopularStickersLocalizedString("<MyGenderTitle>", nil)
        
        maleButton.setTitle(PopularStickersLocalizedString("<MaleString>", nil), for: UIControlState())
        femaleButton.setTitle(PopularStickersLocalizedString("<FemaleString>", nil), for: UIControlState())
        
        
        livingSituationTitle.text = PopularStickersLocalizedString("<RelationshipStatusTitle>", nil)
        
        liveAloneButton.setTitle(PopularStickersLocalizedString("<LiveOnMyOwnTitle>", nil), for: UIControlState())
        liveWithSomeoneButton.setTitle(PopularStickersLocalizedString("<LiveWithSomeoneTitle>", nil), for: UIControlState())
        
        
        ageTitle.text = PopularStickersLocalizedString("<MyAgeTitle>", nil)
        
        under17Button.setTitle(PopularStickersLocalizedString("<17>", nil), for: UIControlState())
        
        between18And35Button.setTitle(PopularStickersLocalizedString("<18-39>", nil), for: UIControlState())
        
        between35And65Button.setTitle(PopularStickersLocalizedString("<40-64>", nil), for: UIControlState())
        over65Button.setTitle(PopularStickersLocalizedString("<65>", nil), for: UIControlState())
        
    }
    
    
    // MARK: Login Button Delegate
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if let _ = FBSDKAccessToken.current() {
            
            AnalyticsManager.shared().postAction( withType: kGALoginWithFacebook, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: kGAUserProfileScreen)
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, email, name, gender, age_range"]).start(completionHandler: {
                connection, result, error -> Void in
                
                
                if let dict = result as? NSDictionary, error == nil {
                    
                    if let gender = dict.object(forKey: "gender") as? String {
                        
                        if gender == "male" {
                            UserDefaults.setUserGender("H")
                            AnalyticsManager.shared().postAction( withType: kGAGender, targetType: kGATargetTypeApp, targetId: UserDefaults.userGender(), targetParameter: nil, actionLocation: kGAUserProfileScreen)
                        }
                        else if gender == "female" {
                            UserDefaults.setUserGender("F")
                            AnalyticsManager.shared().postAction( withType: kGAGender, targetType: kGATargetTypeApp, targetId: UserDefaults.userGender(), targetParameter: nil, actionLocation: kGAUserProfileScreen)
                        }
                    }
                    
                    if let identifier = dict.object(forKey: "id") as? String {
                        AnalyticsManager.shared().postAction( withType: kGASetFacebookId, targetType: kGATargetTypeApp, targetId: identifier, targetParameter: nil, actionLocation: kGAUserProfileScreen)
                    }
                    
                    if let email = dict.object(forKey: "email") as? String {
                        
                        AnalyticsManager.shared().postAction(withType: kGAUserEmail, targetType: kGATargetTypeApp, targetId: email, targetParameter: nil, actionLocation: kGAUserProfileScreen)
                        
                    }
                    
                }
                
            })
            
            
        }
        else {
            // MARK: Show some error
        }
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        AnalyticsManager.shared().postAction( withType: kGALogoutWithFacebook, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: kGAUserProfileScreen)
        
    }

    
    
    // MARK: Selected State of Buttons
    
    func updateSelectedStateOfButtons() {
        
        frenchButton.isSelected = GWLocalizedBundle.currentLocaleAPIString() == frenchCultureString
        englishButton.isSelected = GWLocalizedBundle.currentLocaleAPIString() == englishCultureString
        spanishButton.isSelected = GWLocalizedBundle.currentLocaleAPIString() == spanishCultureString
        
        maleButton.isSelected = UserDefaults.userGender() == maleGender
        femaleButton.isSelected = UserDefaults.userGender() == femaleGender
        
        notifOnceADayButton.isSelected = UserDefaults.userNotificationFrequency()?.int32Value == Int32( UserNotifications.OneMessageADay.rawValue )
        notifEveryOtherDayButton.isSelected = UserDefaults.userNotificationFrequency()?.int32Value == Int32( UserNotifications.OneMessageEveryOtherDay.rawValue )
        notifOnceAWeekButton.isSelected = UserDefaults.userNotificationFrequency()?.int32Value == Int32( UserNotifications.OneMessageAWeek.rawValue )
        
        messengerSendMethodButton.isSelected = UserDefaults.sendMethodForMessage() == MessageSendMethod.messenger
        otherSendMethodButton.isSelected = UserDefaults.sendMethodForMessage() == MessageSendMethod.OS
        
        liveAloneButton.isSelected = UserDefaults.userLivingSituation()?.int32Value == Int32( UserLivingSituation.LiveAlone.rawValue )
        liveWithSomeoneButton.isSelected = UserDefaults.userLivingSituation()?.int32Value == Int32( UserLivingSituation.LiveWithSomeone.rawValue )
        
        under17Button.isSelected = UserDefaults.userAge()?.int32Value == Int32( UserAge.LessThan17.rawValue )
        between18And35Button.isSelected = UserDefaults.userAge()?.int32Value == Int32( UserAge.Between18And39.rawValue )
        between35And65Button.isSelected = UserDefaults.userAge()?.int32Value == Int32( UserAge.Between40And64.rawValue )
        over65Button.isSelected = UserDefaults.userAge()?.int32Value == Int32( UserAge.Over65.rawValue )
        
    }
    
    func createTitle(_ title: String?, xOffset: CGFloat, yOffset: CGFloat, height: CGFloat) -> UILabel {
        
        let titleLabel = UILabel(frame: CGRect(x: xOffset, y: yOffset, width: self.view.frame.width - xOffset, height: height))
        
        titleLabel.textAlignment = NSTextAlignment.left
        titleLabel.textColor = UIColor.black
        titleLabel.text = title
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.8
        titleLabel.font = UIFont.c_roboto(withSize: 18.0)
        
        return titleLabel
    }
    
    func createButton(_ title: String?, titleInset: CGFloat, frame: CGRect, parentView: UIScrollView) -> MAXSelectedContentButton {
        
        let button = MAXSelectedContentButton(frame: frame)
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.c_textLightGray(), for: UIControlState())
        button.titleEdgeInsets = UIEdgeInsetsMake(0, titleInset, 0, 0)
        button.titleLabel?.font = UIFont.c_roboto(withSize: 15.0)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        
        var image = UIImage(named: "CheckMarkIcon")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        let checkMarkImageView = UIImageView(image: image)
        checkMarkImageView.frame = CGRect(x: frame.width * 0.86, y: button.frame.height*0.3, width: button.frame.height * 0.4, height: button.frame.height * 0.4)
        checkMarkImageView.contentMode = UIViewContentMode.scaleAspectFit
        checkMarkImageView.tintColor = UIColor.darkGray
        
        button.addSelectedContent(checkMarkImageView)
        
        let separator = UIView(frame: CGRect(x: 0, y: button.frame.height - 1, width: button.frame.width, height: 1))
        separator.backgroundColor = UIColor.c_textLightGray()
        
        button.addSubview(separator)
        
        parentView.addSubview(button)
        parentView.contentSize = CGSize(width: self.view.frame.width, height: button.frame.maxY)
        
        return button
    }
    
    deinit {
        print("deinit Settings View Controller")
    }
    
}
