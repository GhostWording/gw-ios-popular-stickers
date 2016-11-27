//
//  SettingsViewController.swift
//  WhatsAppMessageComposer
//
//  Created by Mathieu Skulason on 03/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SettingsViewController: UIViewController, FBSDKLoginButtonDelegate {

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
        
        headerView.addSubview(backButton)
        
        let stickersTitleLabel = UILabel(frame: CGRectMake( CGRectGetMaxX(backButton.frame), 20, CGRectGetWidth(self.view.frame) - CGRectGetMaxX(backButton.frame) - CGRectGetWidth(self.view.frame) * 0.1, 44))
        stickersTitleLabel.textAlignment = .Left
        stickersTitleLabel.textColor = UIColor.whiteColor()
        stickersTitleLabel.text = PopularStickersLocalizedString("<SettingsTitle>", nil)
        stickersTitleLabel.font = UIFont.c_robotoWithSize(Float(CGRectGetHeight(self.view.frame) * 0.03))
        
        headerView.addSubview(stickersTitleLabel)
        
        let scrollView = UIScrollView(frame: CGRectMake(0, CGRectGetHeight(headerView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetHeight(headerView.frame)))
        scrollView.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(scrollView)
        
        let leftOffset = CGRectGetWidth(self.view.frame) * 0.05
        let heightOffset = CGFloat(0)
        
        let controlStandardHeight: CGFloat = 32
        let titleOffset: CGFloat = 14
        
        
        languageTitle = self.createTitle(PopularStickersLocalizedString("<ChooseLanguageTitle>", nil), xOffset: leftOffset, yOffset: heightOffset + CGRectGetWidth(self.view.frame) * 0.03 , height: controlStandardHeight)
        scrollView.addSubview(languageTitle);
        
        let heightButton: CGFloat = 48;
        
        englishButton = self.createButton(PopularStickersLocalizedString("<EnglishTitle>", nil), titleInset: leftOffset, frame: CGRectMake(0, CGRectGetMaxY(languageTitle.frame) + heightOffset, CGRectGetWidth(self.view.frame), heightButton), parentView: scrollView)
        frenchButton = self.createButton(PopularStickersLocalizedString("<FrenchTitle>", nil), titleInset: leftOffset, frame: CGRectMake(0, CGRectGetMaxY(englishButton.frame), CGRectGetWidth(self.view.frame), heightButton), parentView: scrollView)
        spanishButton = self.createButton(PopularStickersLocalizedString("<SpanishTitle>", nil), titleInset: leftOffset, frame: CGRectMake(0, CGRectGetMaxY(frenchButton.frame), CGRectGetWidth(self.view.frame), heightButton), parentView: scrollView)
        
        
        notificationTitle = self.createTitle(PopularStickersLocalizedString("<ReceiveNotificationTitle>", nil), xOffset: leftOffset, yOffset: CGRectGetMaxY(spanishButton.frame) + titleOffset
            , height: controlStandardHeight)
        notificationTitle.c_setWidth( Float(CGRectGetWidth(self.view.frame)) - Float( leftOffset ) - Float( CGRectGetWidth(self.view.frame) ) * 0.2)
        
        let notificationSwitch = MAXBlockSwitch()
        notificationSwitch.onTintColor = UIColor.c_blueColor()
        notificationSwitch.on = UserDefaults.wantsNotification()
        
        let notificationSwitchHeight = Float(CGRectGetHeight(notificationSwitch.frame)) / 2.0
        notificationSwitch.c_setOriginY( (Float( CGRectGetMaxY(notificationTitle.frame) ) - Float(CGRectGetHeight(notificationTitle.frame)) / 2.0) - notificationSwitchHeight)
        notificationSwitch.c_setOriginX( Float( CGRectGetWidth(self.view.frame) ) * 0.82)
        
        notificationSwitch.switchValueChangedWithCompletion({
            
            if notificationSwitch.on == true {
                
                if UserDefaults.isNotificationRegistered() == false {
                    let application = UIApplication.sharedApplication()
                    application.registerUserNotificationSettings( UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound] , categories: nil))
                }
                UserDefaults.setWantsNotification(true)
            }
            else {
                UserDefaults.setWantsNotification(false)
            }
            
        })
        
        scrollView.addSubview(notificationSwitch)
        
        
        scrollView.addSubview(notificationTitle)
        
        
        notifOnceADayButton = self.createButton(PopularStickersLocalizedString("<OnceNotificationPerDay>", nil), titleInset: leftOffset, frame: CGRectMake(0, CGRectGetMaxY(notificationTitle.frame) + heightOffset, CGRectGetWidth(self.view.frame), heightButton), parentView: scrollView)
        notifEveryOtherDayButton = self.createButton(PopularStickersLocalizedString("<OneNotificationEveryOtherDay>", nil), titleInset: leftOffset, frame: CGRectMake(0, CGRectGetMaxY(notifOnceADayButton.frame), CGRectGetWidth(self.view.frame), heightButton), parentView: scrollView)
        notifOnceAWeekButton = self.createButton(PopularStickersLocalizedString("<OneNotificationEveryWeek>", nil), titleInset: leftOffset, frame: CGRectMake(0, CGRectGetMaxY(notifEveryOtherDayButton.frame), CGRectGetWidth(self.view.frame), heightButton), parentView: scrollView)
        
        
        personalityTypeButton = MAXFadeBlockButton(frame: CGRectMake(0, CGRectGetMaxY(notifOnceAWeekButton.frame), CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame) * 0.06 + controlStandardHeight ))
        personalityTypeButton.setTitle(PopularStickersLocalizedString("<MyMBTI>", nil), forState: UIControlState.Normal)
        personalityTypeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        personalityTypeButton.titleEdgeInsets = UIEdgeInsetsMake(0, leftOffset, 0, 0)
        personalityTypeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        personalityTypeButton.titleLabel?.font = UIFont.c_robotoWithSize( 18.0 )
        
        var arrowImage = UIImage(named: "BackArrowIcon")
        arrowImage = arrowImage?.imageWithRenderingMode( UIImageRenderingMode.AlwaysTemplate )
        
        let arrowImageView = UIImageView(frame: CGRectMake(CGRectGetWidth(personalityTypeButton.frame) - CGRectGetHeight(personalityTypeButton.frame) * 0.4, CGRectGetHeight(personalityTypeButton.frame) * 0.3, CGRectGetHeight(personalityTypeButton.frame) * 0.4, CGRectGetHeight(personalityTypeButton.frame) * 0.4))
        arrowImageView.image = arrowImage
        arrowImageView.tintColor = UIColor.darkGrayColor()
        arrowImageView.transform = CGAffineTransformMakeRotation( CGFloat(M_PI) )
        personalityTypeButton.addSubview( arrowImageView )
        
        personalityTypeButton.buttonTouchUpInsideWithCompletion({
            
            let personalityPicker = PersonalityIntroViewController(type: PersonalityViewControllerType.Settings)
            self.presentViewController( personalityPicker, animated: true, completion: nil)
            
        })
        
        scrollView.addSubview( personalityTypeButton )
        
        let personalitySeparator = UIView(frame: CGRectMake( 0, CGRectGetMaxY(personalityTypeButton.frame), CGRectGetWidth(self.view.frame), 1))
        personalitySeparator.backgroundColor = UIColor.c_textLightGrayColor()
        scrollView.addSubview( personalitySeparator )
        
        
        
        sendMethodLabel = self.createTitle(PopularStickersLocalizedString("<ChooseSendMethodSettings>", nil), xOffset: leftOffset, yOffset: CGRectGetMaxY(personalitySeparator.frame) + titleOffset, height: controlStandardHeight)
        
        scrollView.addSubview( sendMethodLabel )
        
        messengerSendMethodButton = self.createButton(PopularStickersLocalizedString("<MessengerMethod>", nil), titleInset: leftOffset, frame: CGRectMake(0, CGRectGetMaxY(sendMethodLabel.frame) + heightOffset, CGRectGetWidth(self.view.frame), heightButton), parentView: scrollView)
        
        otherSendMethodButton = self.createButton(PopularStickersLocalizedString("<OtherMethod>", nil), titleInset: leftOffset, frame: CGRectMake(0, CGRectGetMaxY(messengerSendMethodButton.frame), CGRectGetWidth(self.view.frame), heightButton), parentView: scrollView)
        
        
        
        genderTitle = self.createTitle(PopularStickersLocalizedString("<MyGenderTitle>", nil), xOffset: leftOffset, yOffset: CGRectGetMaxY(otherSendMethodButton.frame) + titleOffset, height: controlStandardHeight)
        
        scrollView.addSubview(genderTitle)
        
        maleButton = self.createButton(PopularStickersLocalizedString("<MaleString>", nil), titleInset: leftOffset, frame: CGRectMake(0, CGRectGetMaxY(genderTitle.frame) + heightOffset, CGRectGetWidth(self.view.frame), heightButton), parentView: scrollView)
        femaleButton = self.createButton(PopularStickersLocalizedString("<FemaleString>", nil), titleInset: leftOffset, frame: CGRectMake(0, CGRectGetMaxY(maleButton.frame), CGRectGetWidth(self.view.frame), heightButton), parentView: scrollView)
        
        livingSituationTitle = self.createTitle(PopularStickersLocalizedString("<RelationshipStatusTitle>", nil), xOffset: leftOffset, yOffset: CGRectGetMaxY(femaleButton.frame) + titleOffset, height: controlStandardHeight)
        
        scrollView.addSubview(livingSituationTitle)
        
        liveAloneButton = self.createButton(PopularStickersLocalizedString("<LiveOnMyOwnTitle>", nil), titleInset: leftOffset, frame: CGRectMake(0, CGRectGetMaxY(livingSituationTitle.frame) + heightOffset, CGRectGetWidth(self.view.frame), heightButton), parentView: scrollView)
        liveWithSomeoneButton = self.createButton(PopularStickersLocalizedString("<LiveWithSomeoneTitle>", nil), titleInset: leftOffset, frame: CGRectMake(0, CGRectGetMaxY(liveAloneButton.frame), CGRectGetWidth(self.view.frame), heightButton), parentView: scrollView)
        
        
        ageTitle = self.createTitle(PopularStickersLocalizedString("<MyAgeTitle>", nil), xOffset: leftOffset, yOffset: CGRectGetMaxY(liveWithSomeoneButton.frame) + titleOffset, height: controlStandardHeight)
        
        scrollView.addSubview(ageTitle)
        
        under17Button = self.createButton(PopularStickersLocalizedString("<17>", nil), titleInset: leftOffset, frame: CGRectMake(0, CGRectGetMaxY(ageTitle.frame) + heightOffset, CGRectGetWidth(self.view.frame), heightButton), parentView: scrollView)
        between18And35Button = self.createButton(PopularStickersLocalizedString("<18-39>", nil), titleInset: leftOffset, frame: CGRectMake(0, CGRectGetMaxY(under17Button.frame), CGRectGetWidth(self.view.frame), heightButton), parentView: scrollView)
        between35And65Button = self.createButton(PopularStickersLocalizedString("<40-64>", nil), titleInset: leftOffset, frame: CGRectMake(0, CGRectGetMaxY(between18And35Button.frame), CGRectGetWidth(self.view.frame), heightButton), parentView: scrollView)
        over65Button = self.createButton(PopularStickersLocalizedString("<65>", nil), titleInset: leftOffset, frame: CGRectMake(0, CGRectGetMaxY(between35And65Button.frame), CGRectGetWidth(self.view.frame), heightButton), parentView: scrollView)
        
        
        facebookLoginButton = FBSDKLoginButton(frame: CGRectMake(CGRectGetMidX(self.view.frame) - 120, CGRectGetMaxY(over65Button.frame) + 20, 240, 60))
        facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        facebookLoginButton.delegate = self
        scrollView.addSubview(facebookLoginButton)
        
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(facebookLoginButton.frame) + 20)
        
        self.updateSelectedStateOfButtons()
        
        
        // MARK: Button touches and User Defaults Update
        
        englishButton.buttonTouchUpInsideWithCompletion({
            
            if GWLocalizedBundle.currentLocaleAPIString() != englishCultureString {
                
                GWLocalizedBundle.setLanguage("en")
                
                AnalyticsManager.sharedManager().postActionWithType( kGASetLanguage, targetType: kGATargetTypeApp, targetId: GWLocalizedBundle.currentLocaleString(), targetParameter: nil, actionLocation: kGAUserProfileScreen)
                
                GWDataManager().downloadAllTextsWithBlockForArea("stickers", withCulture: GWLocalizedBundle.currentLocaleAPIString(), withCompletion: {
                    texts, error -> Void in
                    
                    print("french texts downloaded")
                    
                })
                
                if let presentedVC = self.presentingViewController as? StickersOverviewController {
                    
                    presentedVC.reloadData()
                    
                }
            }
            
            self.updateSelectedStateOfButtons()
            self.updateUIWithNewLanguage()
        })
        
        frenchButton.buttonTouchUpInsideWithCompletion({
            
            if GWLocalizedBundle.currentLocaleAPIString() != frenchCultureString {
                
                GWLocalizedBundle.setLanguage("fr")
                
                AnalyticsManager.sharedManager().postActionWithType( kGASetLanguage, targetType: kGATargetTypeApp, targetId: GWLocalizedBundle.currentLocaleString(), targetParameter: nil, actionLocation: kGAUserProfileScreen)
                
                GWDataManager().downloadAllTextsWithBlockForArea("stickers", withCulture: GWLocalizedBundle.currentLocaleAPIString(), withCompletion: {
                    texts, error -> Void in
                    
                    print("french texts downloaded")
                    
                })
                
                if let presentedVC = self.presentingViewController as? StickersOverviewController {
                    
                    presentedVC.reloadData()
                    
                }
            }
            
            self.updateSelectedStateOfButtons()
            self.updateUIWithNewLanguage()
        })
        
        spanishButton.buttonTouchUpInsideWithCompletion({
            
            if GWLocalizedBundle.currentLocaleAPIString() != spanishCultureString {
                
                GWLocalizedBundle.setLanguage("es")
                
                AnalyticsManager.sharedManager().postActionWithType( kGASetLanguage, targetType: kGATargetTypeApp, targetId: GWLocalizedBundle.currentLocaleString(), targetParameter: nil, actionLocation: kGAUserProfileScreen)
                
                GWDataManager().downloadAllTextsWithBlockForArea("stickers", withCulture: GWLocalizedBundle.currentLocaleAPIString(), withCompletion: {
                    texts, error -> Void in
                    
                    print("french texts downloaded")
                    
                })
                
                if let presentedVC = self.presentingViewController as? StickersOverviewController {
                    
                    presentedVC.reloadData()
                    
                }
            }
            
            self.updateSelectedStateOfButtons()
            self.updateUIWithNewLanguage()
        })
        
        
        notifOnceADayButton.buttonTouchUpInsideWithCompletion({
            
            UserDefaults.setUserNotificationFrequency( NSNumber(int: Int32( UserNotifications.OneMessageADay.rawValue ) ))
            
            AnalyticsManager.sharedManager().postActionWithType( kGANotificationFrequency, targetType: kGATargetTypeApp, targetId: "OnceADay", targetParameter: nil, actionLocation: kGAUserProfileScreen)
            
            self.updateSelectedStateOfButtons()
        })
        
        notifEveryOtherDayButton.buttonTouchUpInsideWithCompletion({
            
            UserDefaults.setUserNotificationFrequency( NSNumber(int: Int32( UserNotifications.OneMessageEveryOtherDay.rawValue ) ))
            
            AnalyticsManager.sharedManager().postActionWithType( kGANotificationFrequency, targetType: kGATargetTypeApp, targetId: "EveryOtherDay", targetParameter: nil, actionLocation: kGAUserProfileScreen)
            
            self.updateSelectedStateOfButtons()
        })
        
        notifOnceAWeekButton.buttonTouchUpInsideWithCompletion({
            
            UserDefaults.setUserNotificationFrequency( NSNumber(int: Int32( UserNotifications.OneMessageAWeek.rawValue ) ))
            
            AnalyticsManager.sharedManager().postActionWithType( kGANotificationFrequency, targetType: kGATargetTypeApp, targetId: "OnceAWeek", targetParameter: nil, actionLocation: kGAUserProfileScreen)
            
            self.updateSelectedStateOfButtons()
        })
        
        
        messengerSendMethodButton.buttonTouchUpInsideWithCompletion({
            
            UserDefaults.setSendMethodForMessage( MessageSendMethod.Messenger )
            self.updateSelectedStateOfButtons()
            
        })
        
        otherSendMethodButton.buttonTouchUpInsideWithCompletion({
            
            UserDefaults.setSendMethodForMessage( MessageSendMethod.OS )
            self.updateSelectedStateOfButtons()
            
        })
        
        
        maleButton.buttonTouchUpInsideWithCompletion({
            
            UserDefaults.setUserGender( maleGender )
            
            AnalyticsManager.sharedManager().postActionWithType( kGAGender, targetType: kGATargetTypeApp, targetId: UserDefaults.userGender(), targetParameter: nil, actionLocation: kGAUserProfileScreen)
            
            self.updateSelectedStateOfButtons()
        })
        
        femaleButton.buttonTouchUpInsideWithCompletion({
            
            UserDefaults.setUserGender( femaleGender )
            
            AnalyticsManager.sharedManager().postActionWithType( kGAGender, targetType: kGATargetTypeApp, targetId: UserDefaults.userGender(), targetParameter: nil, actionLocation: kGAUserProfileScreen)
            
            self.updateSelectedStateOfButtons()
        })
        
        
        liveAloneButton.buttonTouchUpInsideWithCompletion({
            
            UserDefaults.setUserLivingSituation( NSNumber(int: Int32( UserLivingSituation.LiveAlone.rawValue ) ))
            
            AnalyticsManager.sharedManager().postActionWithType( kGAConjugalSituation, targetType: kGATargetTypeApp, targetId: "Single", targetParameter: nil, actionLocation: kGAUserProfileScreen)
            
            self.updateSelectedStateOfButtons()
        })
        
        liveWithSomeoneButton.buttonTouchUpInsideWithCompletion({
            
            UserDefaults.setUserLivingSituation( NSNumber(int: Int32( UserLivingSituation.LiveWithSomeone.rawValue ) ))
            
            AnalyticsManager.sharedManager().postActionWithType( kGAConjugalSituation, targetType: kGATargetTypeApp, targetId: "InACouple", targetParameter: nil, actionLocation: kGAUserProfileScreen)
            
            self.updateSelectedStateOfButtons()
        })
        
        
        under17Button.buttonTouchUpInsideWithCompletion({
            UserDefaults.setUserAge( NSNumber(int: Int32( UserAge.LessThan17.rawValue ) ))
            self.updateSelectedStateOfButtons()
        })
        between18And35Button.buttonTouchUpInsideWithCompletion({
            UserDefaults.setUserAge( NSNumber(int: Int32( UserAge.Between18And39.rawValue ) ))
            self.updateSelectedStateOfButtons()
        })
        between35And65Button.buttonTouchUpInsideWithCompletion({
            UserDefaults.setUserAge( NSNumber(int: Int32( UserAge.Between40And64.rawValue ) ))
            self.updateSelectedStateOfButtons()
        })
        over65Button.buttonTouchUpInsideWithCompletion({
            UserDefaults.setUserAge( NSNumber(int: Int32( UserAge.Over65.rawValue ) ))
            self.updateSelectedStateOfButtons()
        })
        
    }
    
    
    func updateUIWithNewLanguage() {
        
        languageTitle.text = PopularStickersLocalizedString("<ChooseLanguageTitle>", nil)
        
        englishButton.setTitle(PopularStickersLocalizedString("<EnglishTitle>", nil), forState: UIControlState.Normal)
        frenchButton.setTitle(PopularStickersLocalizedString("<FrenchTitle>", nil), forState: UIControlState.Normal)
        spanishButton.setTitle(PopularStickersLocalizedString("<SpanishTitle>", nil), forState: UIControlState.Normal)
        
        
        notificationTitle.text = PopularStickersLocalizedString("<ReceiveNotificationTitle>", nil)
        
        notifOnceADayButton.setTitle(PopularStickersLocalizedString("<OnceNotificationPerDay>", nil), forState: UIControlState.Normal)
        notifEveryOtherDayButton.setTitle(PopularStickersLocalizedString("<OneNotificationEveryOtherDay>", nil), forState: UIControlState.Normal)
        notifOnceAWeekButton.setTitle(PopularStickersLocalizedString("<OneNotificationEveryWeek>", nil), forState: UIControlState.Normal)
        
        sendMethodLabel.text = PopularStickersLocalizedString("<ChooseSendMethodSettings>", nil)
        
        messengerSendMethodButton.setTitle(PopularStickersLocalizedString("<MessengerMethod>", nil), forState: UIControlState.Normal)
        otherSendMethodButton.setTitle(PopularStickersLocalizedString("<OtherMethod>", nil), forState: UIControlState.Normal)
        
        
        personalityTypeButton.setTitle(PopularStickersLocalizedString("<MyMBTI>", nil), forState: UIControlState.Normal)
        
        
        genderTitle.text = PopularStickersLocalizedString("<MyGenderTitle>", nil)
        
        maleButton.setTitle(PopularStickersLocalizedString("<MaleString>", nil), forState: UIControlState.Normal)
        femaleButton.setTitle(PopularStickersLocalizedString("<FemaleString>", nil), forState: UIControlState.Normal)
        
        
        livingSituationTitle.text = PopularStickersLocalizedString("<RelationshipStatusTitle>", nil)
        
        liveAloneButton.setTitle(PopularStickersLocalizedString("<LiveOnMyOwnTitle>", nil), forState: UIControlState.Normal)
        liveWithSomeoneButton.setTitle(PopularStickersLocalizedString("<LiveWithSomeoneTitle>", nil), forState: UIControlState.Normal)
        
        
        ageTitle.text = PopularStickersLocalizedString("<MyAgeTitle>", nil)
        
        under17Button.setTitle(PopularStickersLocalizedString("<17>", nil), forState: UIControlState.Normal)
        
        between18And35Button.setTitle(PopularStickersLocalizedString("<18-39>", nil), forState: UIControlState.Normal)
        
        between35And65Button.setTitle(PopularStickersLocalizedString("<40-64>", nil), forState: UIControlState.Normal)
        over65Button.setTitle(PopularStickersLocalizedString("<65>", nil), forState: UIControlState.Normal)
        
    }
    
    
    // MARK: Login Button Delegate
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if let _ = FBSDKAccessToken.currentAccessToken() {
            
            AnalyticsManager.sharedManager().postActionWithType( kGALoginWithFacebook, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: kGAUserProfileScreen)
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, email, name, gender, age_range"]).startWithCompletionHandler({
                connection, result, error -> Void in
                
                
                if let dict = result as? NSDictionary where error == nil {
                    
                    if let gender = dict.objectForKey("gender") as? String {
                        
                        if gender == "male" {
                            UserDefaults.setUserGender("H")
                            AnalyticsManager.sharedManager().postActionWithType( kGAGender, targetType: kGATargetTypeApp, targetId: UserDefaults.userGender(), targetParameter: nil, actionLocation: kGAUserProfileScreen)
                        }
                        else if gender == "female" {
                            UserDefaults.setUserGender("F")
                            AnalyticsManager.sharedManager().postActionWithType( kGAGender, targetType: kGATargetTypeApp, targetId: UserDefaults.userGender(), targetParameter: nil, actionLocation: kGAUserProfileScreen)
                        }
                    }
                    
                    if let identifier = dict.objectForKey("id") as? String {
                        AnalyticsManager.sharedManager().postActionWithType( kGASetFacebookId, targetType: kGATargetTypeApp, targetId: identifier, targetParameter: nil, actionLocation: kGAUserProfileScreen)
                    }
                    
                    if let email = dict.objectForKey("email") as? String {
                        
                        AnalyticsManager.sharedManager().postActionWithType(kGAUserEmail, targetType: kGATargetTypeApp, targetId: email, targetParameter: nil, actionLocation: kGAUserProfileScreen)
                        
                    }
                    
                }
                
            })
            
            
        }
        else {
            // MARK: Show some error
        }
        
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        AnalyticsManager.sharedManager().postActionWithType( kGALogoutWithFacebook, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: kGAUserProfileScreen)
        
    }

    
    
    // MARK: Selected State of Buttons
    
    func updateSelectedStateOfButtons() {
        
        frenchButton.selected = GWLocalizedBundle.currentLocaleAPIString() == frenchCultureString
        englishButton.selected = GWLocalizedBundle.currentLocaleAPIString() == englishCultureString
        spanishButton.selected = GWLocalizedBundle.currentLocaleAPIString() == spanishCultureString
        
        maleButton.selected = UserDefaults.userGender() == maleGender
        femaleButton.selected = UserDefaults.userGender() == femaleGender
        
        notifOnceADayButton.selected = UserDefaults.userNotificationFrequency()?.intValue == Int32( UserNotifications.OneMessageADay.rawValue )
        notifEveryOtherDayButton.selected = UserDefaults.userNotificationFrequency()?.intValue == Int32( UserNotifications.OneMessageEveryOtherDay.rawValue )
        notifOnceAWeekButton.selected = UserDefaults.userNotificationFrequency()?.intValue == Int32( UserNotifications.OneMessageAWeek.rawValue )
        
        messengerSendMethodButton.selected = UserDefaults.sendMethodForMessage() == MessageSendMethod.Messenger
        otherSendMethodButton.selected = UserDefaults.sendMethodForMessage() == MessageSendMethod.OS
        
        liveAloneButton.selected = UserDefaults.userLivingSituation()?.intValue == Int32( UserLivingSituation.LiveAlone.rawValue )
        liveWithSomeoneButton.selected = UserDefaults.userLivingSituation()?.intValue == Int32( UserLivingSituation.LiveWithSomeone.rawValue )
        
        under17Button.selected = UserDefaults.userAge()?.intValue == Int32( UserAge.LessThan17.rawValue )
        between18And35Button.selected = UserDefaults.userAge()?.intValue == Int32( UserAge.Between18And39.rawValue )
        between35And65Button.selected = UserDefaults.userAge()?.intValue == Int32( UserAge.Between40And64.rawValue )
        over65Button.selected = UserDefaults.userAge()?.intValue == Int32( UserAge.Over65.rawValue )
        
    }
    
    func createTitle(title: String?, xOffset: CGFloat, yOffset: CGFloat, height: CGFloat) -> UILabel {
        
        let titleLabel = UILabel(frame: CGRectMake(xOffset, yOffset, CGRectGetWidth(self.view.frame) - xOffset, height))
        
        titleLabel.textAlignment = NSTextAlignment.Left
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.text = title
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.8
        titleLabel.font = UIFont.c_robotoWithSize(18.0)
        
        return titleLabel
    }
    
    func createButton(title: String?, titleInset: CGFloat, frame: CGRect, parentView: UIScrollView) -> MAXSelectedContentButton {
        
        let button = MAXSelectedContentButton(frame: frame)
        button.setTitle(title, forState: UIControlState.Normal)
        button.setTitleColor(UIColor.c_textLightGrayColor(), forState: UIControlState.Normal)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, titleInset, 0, 0)
        button.titleLabel?.font = UIFont.c_robotoWithSize(15.0)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        
        var image = UIImage(named: "CheckMarkIcon")
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        let checkMarkImageView = UIImageView(image: image)
        checkMarkImageView.frame = CGRectMake(CGRectGetWidth(frame) * 0.86, CGRectGetHeight(button.frame)*0.3, CGRectGetHeight(button.frame) * 0.4, CGRectGetHeight(button.frame) * 0.4)
        checkMarkImageView.contentMode = UIViewContentMode.ScaleAspectFit
        checkMarkImageView.tintColor = UIColor.darkGrayColor()
        
        button.addSelectedContent(checkMarkImageView)
        
        let separator = UIView(frame: CGRectMake(0, CGRectGetHeight(button.frame) - 1, CGRectGetWidth(button.frame), 1))
        separator.backgroundColor = UIColor.c_textLightGrayColor()
        
        button.addSubview(separator)
        
        parentView.addSubview(button)
        parentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(button.frame))
        
        return button
    }
    
    
}
