//
//  LoginViewController.swift
//  PopularStickers
//
//  Created by Mathieu Skulason on 06/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var appTitle: UILabel!
    var englishButton: MAXFadeBlockButton!
    var frenchButton: MAXFadeBlockButton!
    var spanishButton: MAXFadeBlockButton!
    var loginFacebookButton : MAXFadeBlockButton!
    var startButton: MAXFadeBlockButton!
    var facebookButton : FBSDKLoginButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let imageView = UIImageView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)))
        imageView.backgroundColor = UIColor.c_blueColor()
        imageView.image = UIImage(named: "LoginBackgroundImage")
        self.view.addSubview(imageView)
        
        
        let appTitleLabel = UILabel(frame: CGRectMake(CGRectGetWidth(self.view.frame) * 0.1, CGRectGetHeight(self.view.frame) * 0.37, CGRectGetWidth(self.view.frame) * 0.8, CGRectGetHeight(self.view.frame) * 0.1))
        appTitleLabel.text = PopularStickersLocalizedString("<AppName>", nil)
        appTitleLabel.textAlignment = NSTextAlignment.Center
        appTitleLabel.textColor = UIColor.whiteColor()
        appTitleLabel.font = UIFont.c_robotoBoldWithSize(28.0)
        appTitleLabel.adjustsFontSizeToFitWidth = true
        appTitleLabel.minimumScaleFactor = 0.8
        
        self.view.addSubview(appTitleLabel)
        
        
        
        let languageBox = UIView(frame: CGRectMake(CGRectGetWidth(self.view.frame) * 0.0625, CGRectGetHeight(self.view.frame) * 0.47, CGRectGetWidth(self.view.frame) * 0.875, CGRectGetHeight(self.view.frame) * 0.25))
        languageBox.backgroundColor = UIColor.whiteColor()
        languageBox.layer.cornerRadius = 4
        self.view.addSubview(languageBox)
        
        
        let height = CGRectGetHeight(languageBox.frame) / 3.0
        
        englishButton = self.createLanguageSelectButton( "English", width: CGRectGetWidth(languageBox.frame), height: height)
        languageBox.addSubview(englishButton)
        
        let firstSeparator = UIView(frame: CGRectMake(0, CGFloat(height) - 0.5, CGRectGetWidth(languageBox.frame), 1))
        firstSeparator.backgroundColor = UIColor.c_lightGrayIndicatorColor()
        languageBox.addSubview(firstSeparator)
        
        frenchButton = self.createLanguageSelectButton( "Français", width: CGRectGetWidth(languageBox.frame), height: height)
        frenchButton.c_setOriginY(Float(height))
        languageBox.addSubview(frenchButton)
        
        let secondSeparator = UIView(frame: CGRectMake(0, 2 * CGFloat(height) - 0.5, CGRectGetWidth(languageBox.frame), 1))
        secondSeparator.backgroundColor = UIColor.c_lightGrayIndicatorColor()
        languageBox.addSubview(secondSeparator)
        
        spanishButton = self.createLanguageSelectButton( "Español", width: CGRectGetWidth(languageBox.frame), height: height)
        spanishButton.c_setOriginY(Float(height * 2.0))
        languageBox.addSubview(spanishButton)
        
        
        englishButton.selected = GWLocalizedBundle.currentLocaleAPIString() == englishCultureString
        frenchButton.selected = GWLocalizedBundle.currentLocaleAPIString() == frenchCultureString
        spanishButton.selected = GWLocalizedBundle.currentLocaleAPIString() == spanishCultureString
        
        
        englishButton.buttonTouchDownWithCompletion({
            if self.englishButton.selected == false {
                
                GWLocalizedBundle.setLanguage("en")
                
                AnalyticsManager.sharedManager().postActionWithType( kGASetLanguage, targetType: kGATargetTypeApp, targetId: GWLocalizedBundle.currentLocaleString(), targetParameter: nil, actionLocation: kGALoginScreen)
                
                GWDataManager().downloadAllTextsWithBlockForArea("stickers", withCulture: GWLocalizedBundle.currentLocaleAPIString(), withCompletion: {
                    texts, error -> Void in
                    
                    print("english texts downloaded")
                    
                })
                self.updateUILanguage()
                
                self.englishButton.selected = true
                self.frenchButton.selected = false
                self.spanishButton.selected = false
                
            }
        })
        
        frenchButton.buttonTouchDownWithCompletion({
            if self.frenchButton.selected == false {
                
                GWLocalizedBundle.setLanguage("fr")
                
                AnalyticsManager.sharedManager().postActionWithType( kGASetLanguage, targetType: kGATargetTypeApp, targetId: GWLocalizedBundle.currentLocaleString(), targetParameter: nil, actionLocation: kGALoginScreen)
                
                GWDataManager().downloadAllTextsWithBlockForArea("stickers", withCulture: GWLocalizedBundle.currentLocaleAPIString(), withCompletion: {
                    texts, error -> Void in
                    
                    print("french texts downloaded")
                    
                })
                self.updateUILanguage()
                
                self.frenchButton.selected = true
                self.englishButton.selected = false
                self.spanishButton.selected = false
                
            }
        })
        
        spanishButton.buttonTouchDownWithCompletion({
            if self.spanishButton.selected == false {
                
                GWLocalizedBundle.setLanguage("es")
                
                AnalyticsManager.sharedManager().postActionWithType( kGASetLanguage, targetType: kGATargetTypeApp, targetId: GWLocalizedBundle.currentLocaleString(), targetParameter: nil, actionLocation: kGALoginScreen)
                
                GWDataManager().downloadAllTextsWithBlockForArea("stickers", withCulture: GWLocalizedBundle.currentLocaleAPIString(), withCompletion: {
                    texts, error -> Void in
                    
                    print("spanish texts downloaded")
                    
                })
                self.updateUILanguage()
                
                self.spanishButton.selected = true
                self.frenchButton.selected = false
                self.englishButton.selected = false
                
            }
        })
        
        facebookButton = FBSDKLoginButton(frame: CGRectMake(CGRectGetMidX(self.view.frame) - 120, CGRectGetHeight(self.view.frame) - 160, 240, 60))
        facebookButton.readPermissions = ["public_profile", "email", "user_friends"]
        facebookButton.delegate = self
        facebookButton.setTitle(PopularStickersLocalizedString("<FacebookButtonTitle>", ""), forState: UIControlState.Normal)
        //self.view.addSubview(facebookButton)
        
        loginFacebookButton = MAXFadeBlockButton(frame: CGRectMake(CGRectGetMinX(languageBox.frame), CGRectGetHeight(self.view.frame) - 154, CGRectGetWidth(languageBox.frame), 60))
        loginFacebookButton.backgroundColor = UIColor.c_facebookBlueColor()
        loginFacebookButton.layer.cornerRadius = 4.0
        loginFacebookButton.setTitle(PopularStickersLocalizedString("<FacebookButtonTitle>", nil), forState: UIControlState.Normal)
        loginFacebookButton.titleLabel?.font = UIFont.c_robotoMediumWithSize( 16.0 )
        
        loginFacebookButton.buttonTouchUpInsideWithCompletion({
            
            self.facebookButton.sendActionsForControlEvents( UIControlEvents.TouchUpInside )
            
        })
        
        
        self.view.addSubview( loginFacebookButton )
        
        startButton = MAXFadeBlockButton()
        startButton.frame = CGRectMake(CGRectGetMinX(languageBox.frame), CGRectGetHeight(self.view.frame) - 85, CGRectGetWidth(loginFacebookButton.frame), 60)
        startButton.setTitle( PopularStickersLocalizedString("<StartAppTitle>", nil), forState: UIControlState.Normal)
        startButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        startButton.titleLabel?.font = UIFont.c_robotoMediumWithSize(16.0)
        startButton.layer.backgroundColor = UIColor.clearColor().CGColor
        startButton.layer.borderWidth = 2.0
        startButton.layer.borderColor = UIColor.whiteColor().CGColor
        startButton.layer.cornerRadius = 5.0
        
        startButton.buttonTouchUpInsideWithCompletion({
            
            AnalyticsManager.sharedManager().postActionWithType( kGALoginWithoutFacebook, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: kGALoginScreen)
            
            self.showGenderSelectionView()
        })
        
        self.view.addSubview(startButton);

        
        if self.view.frame.size.height == 480 {
            loginFacebookButton.frame = CGRectMake(CGRectGetMinX(loginFacebookButton.frame), CGRectGetHeight(self.view.frame) - 130, CGRectGetWidth(loginFacebookButton.frame), 50)
            startButton.frame = CGRectMake(CGRectGetMinX(startButton.frame), CGRectGetHeight(self.view.frame) - 74, CGRectGetWidth(startButton.frame), 50)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUILanguage() {
        
        /*
        englishButton.setTitle( PopularStickersLocalizedString("<EnglishTitle>", nil), forState: UIControlState.Normal)
        frenchButton.setTitle( PopularStickersLocalizedString("<FrenchTitle>", nil), forState: UIControlState.Normal)
        spanishButton.setTitle( PopularStickersLocalizedString("<SpanishTitle>", nil), forState: UIControlState.Normal)
        */
        
        startButton.setTitle(PopularStickersLocalizedString("<StartAppTitle>", nil), forState: UIControlState.Normal)
        loginFacebookButton.setTitle(PopularStickersLocalizedString("<FacebookButtonTitle>", ""), forState: UIControlState.Normal)
        
    }
    
    
    private func createLanguageSelectButton(title: String, width: CGFloat, height: CGFloat) -> MAXSelectedContentButton {
        
        let button = MAXSelectedContentButton(frame: CGRectMake(0, 0, width, height))
        button.backgroundColor = UIColor.clearColor()
        button.titleLabel?.font = UIFont.c_robotoWithSize(Float(height) / 3.0)
        button.setTitle(title, forState: UIControlState.Normal)
        button.setTitleColor(UIColor.c_textDarkGrayColor(), forState: UIControlState.Normal)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        button.contentEdgeInsets = UIEdgeInsetsMake(0, width * 0.05, 0, width * 0.15)
        
        
        var image = UIImage(named: "CheckMarkIcon")
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        let checkMarkImageView = UIImageView(image: image)
        checkMarkImageView.frame = CGRectMake(width * 0.85, CGRectGetHeight(button.frame)*0.25, CGRectGetHeight(button.frame) * 0.5, CGRectGetHeight(button.frame) * 0.5)
        checkMarkImageView.contentMode = UIViewContentMode.ScaleAspectFit
        checkMarkImageView.tintColor = UIColor.c_blueCheckMarkColor()
        
        
        button.addSelectedContent(checkMarkImageView)
        
        return button
    }
    
    func showGenderSelectionView() {
        
        let overlayView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)))
        overlayView.backgroundColor = UIColor.c_colorWithHexString(UIColor.c_hexValuesFromUIColor(UIColor.blackColor()), alpha: 0.3)
        overlayView.alpha = 1.0
        self.view.addSubview( overlayView )
        
        let backgroundButton = MAXFadeBlockButton(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)))
        
        backgroundButton.buttonTouchUpInsideWithCompletion({
            
            UIView.animateWithDuration(0.2, animations: {
                
                overlayView.alpha = 0.0
                
                }, completion: {
                    finished -> Void in
                    
                    overlayView.removeFromSuperview()
                    
            })
            
        })
        
        overlayView.addSubview( backgroundButton )
        
        let genderSelectionView = UIView(frame: CGRectMake(CGRectGetWidth(self.view.frame) * 0.1, CGRectGetHeight(self.view.frame) * 0.3, CGRectGetWidth(self.view.frame) * 0.8, CGRectGetHeight(self.view.frame) * 0.4))
        genderSelectionView.layer.cornerRadius = 6
        genderSelectionView.backgroundColor = UIColor.whiteColor()
        genderSelectionView.layer.shadowColor = UIColor.blackColor().CGColor
        genderSelectionView.layer.shadowOpacity = 0.9
        genderSelectionView.layer.shadowRadius = 4.0
        
        overlayView.addSubview(genderSelectionView)
        
        let genderSelectionTitle = UILabel(frame: CGRectMake(0, 0, CGRectGetWidth(genderSelectionView.frame), CGRectGetHeight(genderSelectionView.frame) * 0.18))
        genderSelectionTitle.text = PopularStickersLocalizedString("<MyGenderTitle>", nil)
        genderSelectionTitle.textColor = UIColor.blackColor()
        genderSelectionTitle.font = UIFont.c_robotoMediumWithSize(18.0)
        genderSelectionTitle.textAlignment = .Center
        genderSelectionView.addSubview(genderSelectionTitle)
        
        let womanButton = MAXFadeBlockButton(frame: CGRectMake(CGRectGetWidth(genderSelectionView.frame) * 0.55, CGRectGetHeight(genderSelectionView.frame) * 0.18, CGRectGetWidth(genderSelectionView.frame) * 0.4, CGRectGetHeight(genderSelectionView.frame) * 0.55))
        womanButton.layer.cornerRadius = 4
        
        let womanImageView = UIImageView(frame: CGRectMake(CGRectGetWidth(womanButton.frame) * 0.16, CGRectGetHeight(womanButton.frame) * 0.1, CGRectGetWidth(womanButton.frame) * 0.68, CGRectGetHeight(womanButton.frame) * 0.45))
        womanImageView.contentMode = UIViewContentMode.ScaleAspectFit
        womanImageView.image = UIImage(named: "FemaleIcon")
        womanButton.addSubview(womanImageView)
        
        womanButton.titleEdgeInsets = UIEdgeInsetsMake(CGRectGetHeight(womanButton.frame) * 0.82, 0, 0, 0)
        womanButton.setTitle( PopularStickersLocalizedString("<FemaleString>", nil), forState: UIControlState.Normal)
        womanButton.titleLabel?.font = UIFont.c_robotoWithSize(15.0)
        womanButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        womanButton.layer.borderWidth = 1.0
        womanButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        womanButton.layer.cornerRadius = 4.0
        
        genderSelectionView.addSubview(womanButton)
        
        womanButton.buttonTouchUpInsideWithCompletion({
            
            UserDefaults.setUserGender("F")
            
            AnalyticsManager.sharedManager().postActionWithType( kGAGender, targetType: kGATargetTypeApp, targetId: UserDefaults.userGender(), targetParameter: nil, actionLocation: kGALoginScreen)
            
            self.showStickersOverviewController()
        })
        
        let manButton = MAXFadeBlockButton(frame:  CGRectMake(CGRectGetWidth(genderSelectionView.frame) * 0.05, CGRectGetHeight(genderSelectionView.frame) * 0.18, CGRectGetWidth(genderSelectionView.frame) * 0.4, CGRectGetHeight(genderSelectionView.frame) * 0.55))
        manButton.layer.cornerRadius = 4
        
        let manImageView = UIImageView(frame: CGRectMake(CGRectGetWidth(manButton.frame) * 0.16, CGRectGetHeight(manButton.frame) * 0.1, CGRectGetWidth(manButton.frame) * 0.68, CGRectGetHeight(manButton.frame) * 0.45))
        manImageView.contentMode = UIViewContentMode.ScaleAspectFit
        manImageView.image = UIImage(named: "MaleIcon")
        manButton.addSubview(manImageView)
        
        manButton.titleEdgeInsets = UIEdgeInsetsMake(CGRectGetHeight(manButton.frame) * 0.82, 0, 0, 0)
        manButton.setTitle( PopularStickersLocalizedString("<MaleString>", nil), forState: UIControlState.Normal)
        manButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        manButton.titleLabel?.font = UIFont.c_robotoWithSize(15.0)
        manButton.layer.borderWidth = 1.0
        manButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        manButton.layer.cornerRadius = 4
        
        genderSelectionView.addSubview(manButton)
        
        manButton.buttonTouchUpInsideWithCompletion({
            
            UserDefaults.setUserGender("H")
            
            AnalyticsManager.sharedManager().postActionWithType( kGAGender, targetType: kGATargetTypeApp, targetId: UserDefaults.userGender(), targetParameter: nil, actionLocation: kGALoginScreen)
            
            self.showStickersOverviewController()
        })
        
        let skipButton = MAXFadeBlockButton(frame: CGRectMake(CGRectGetWidth(genderSelectionView.frame) * 0.2, CGRectGetHeight(genderSelectionView.frame) * 0.8, CGRectGetWidth(genderSelectionView.frame) * 0.6, CGRectGetHeight(genderSelectionView.frame) * 0.2))
        
        skipButton.setTitle( PopularStickersLocalizedString("<Skip>", nil), forState: UIControlState.Normal)
        skipButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        skipButton.titleLabel?.font = UIFont.c_robotoWithSize(18.0)
        
        skipButton.buttonTouchUpInsideWithCompletion({
            
            AnalyticsManager.sharedManager().postActionWithType( kGAGender, targetType: kGATargetTypeApp, targetId: "Skip", targetParameter: nil, actionLocation: kGALoginScreen)
            
            self.showStickersOverviewController()
        })
        
        genderSelectionView.addSubview(skipButton)
        
        UIView.animateWithDuration(0.2, animations: {
            
            overlayView.alpha = 1.0
            
        })
        
        
    }
    
    // MARK: Login Button Delegate
    
    // Not being used right now
    func loginWithFacebook()  {
        
        FBSDKLoginManager().logInWithReadPermissions( ["public_profile", "email", "user_friends"] , fromViewController: self, handler: {
            loginResult, error in
            
            
            
        })
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if let _ = FBSDKAccessToken.currentAccessToken() {
            
            AnalyticsManager.sharedManager().postActionWithType( kGALoginWithFacebook, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: kGALoginScreen)
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, gender, age_range, email"]).startWithCompletionHandler({
                connection, result, error -> Void in
                
                
                
                if let dict = result as? NSDictionary where error == nil {
                    
                    if let gender = dict.objectForKey("gender") as? String {
                        
                        if gender == "male" {
                            UserDefaults.setUserGender("H")
                            AnalyticsManager.sharedManager().postActionWithType( kGAGender, targetType: kGATargetTypeApp, targetId: UserDefaults.userGender(), targetParameter: nil, actionLocation: kGALoginScreen)
                        }
                        else if gender == "female" {
                            UserDefaults.setUserGender("F")
                            AnalyticsManager.sharedManager().postActionWithType( kGAGender, targetType: kGATargetTypeApp, targetId: UserDefaults.userGender(), targetParameter: nil, actionLocation: kGALoginScreen)
                        }
                    }
                    
                    if let facebookId = dict.objectForKey("id") as? String {
                        UserDefaults.setFacebookId(facebookId)
                        AnalyticsManager.sharedManager().postActionWithType( kGASetFacebookId, targetType: kGATargetTypeApp, targetId: facebookId, targetParameter: nil, actionLocation: kGALoginScreen)
                    }
                    
                    if let email = dict.objectForKey("email") as? String {
                        
                        AnalyticsManager.sharedManager().postActionWithType(kGAUserEmail, targetType: kGATargetTypeApp, targetId: email, targetParameter: nil, actionLocation: kGALoginScreen)
                        
                    }
                    
                }
                
            })
            
            self.showStickersOverviewController()
            
        }
        else {
            // MARK: Show some error
        }
        
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }

    
    // MARK: Navigation
    
    func showStickersOverviewController() {
        
        if UserDefaults.isFirstLaunch() == true {
            
            self.presentViewController( PersonalityIntroViewController(type: PersonalityViewControllerType.Intro), animated: true, completion: nil)
        }
        else {
            
            let stickersOverview = StickersOverviewController()
            
            self.presentViewController( stickersOverview, animated: true, completion: nil)
        }
        
        UserDefaults.setIsFirstLaunch(false)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
