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
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        imageView.backgroundColor = UIColor.c_blue()
        imageView.image = UIImage(named: "LoginBackgroundImage")
        self.view.addSubview(imageView)
        
        
        let appTitleLabel = UILabel(frame: CGRect(x: self.view.frame.width * 0.1, y: self.view.frame.height * 0.37, width: self.view.frame.width * 0.8, height: self.view.frame.height * 0.1))
        appTitleLabel.text = PopularStickersLocalizedString("<AppName>", nil)
        appTitleLabel.textAlignment = NSTextAlignment.center
        appTitleLabel.textColor = UIColor.white
        appTitleLabel.font = UIFont.c_robotoBold(withSize: 28.0)
        appTitleLabel.adjustsFontSizeToFitWidth = true
        appTitleLabel.minimumScaleFactor = 0.8
        
        self.view.addSubview(appTitleLabel)
        
        
        
        let languageBox = UIView(frame: CGRect(x: self.view.frame.width * 0.0625, y: self.view.frame.height * 0.47, width: self.view.frame.width * 0.875, height: self.view.frame.height * 0.25))
        languageBox.backgroundColor = UIColor.white
        languageBox.layer.cornerRadius = 4
        self.view.addSubview(languageBox)
        
        
        let height = languageBox.frame.height / 3.0
        
        englishButton = self.createLanguageSelectButton( "English", width: languageBox.frame.width, height: height)
        languageBox.addSubview(englishButton)
        
        let firstSeparator = UIView(frame: CGRect(x: 0, y: CGFloat(height) - 0.5, width: languageBox.frame.width, height: 1))
        firstSeparator.backgroundColor = UIColor.c_lightGrayIndicator()
        languageBox.addSubview(firstSeparator)
        
        frenchButton = self.createLanguageSelectButton( "Français", width: languageBox.frame.width, height: height)
        frenchButton.c_setOriginY(Float(height))
        languageBox.addSubview(frenchButton)
        
        let secondSeparator = UIView(frame: CGRect(x: 0, y: 2 * CGFloat(height) - 0.5, width: languageBox.frame.width, height: 1))
        secondSeparator.backgroundColor = UIColor.c_lightGrayIndicator()
        languageBox.addSubview(secondSeparator)
        
        spanishButton = self.createLanguageSelectButton( "Español", width: languageBox.frame.width, height: height)
        spanishButton.c_setOriginY(Float(height * 2.0))
        languageBox.addSubview(spanishButton)
        
        
        englishButton.isSelected = GWLocalizedBundle.currentLocaleAPIString() == englishCultureString
        frenchButton.isSelected = GWLocalizedBundle.currentLocaleAPIString() == frenchCultureString
        spanishButton.isSelected = GWLocalizedBundle.currentLocaleAPIString() == spanishCultureString
        
        
        englishButton.buttonTouchDown(completion: {
            if self.englishButton.isSelected == false {
                
                GWLocalizedBundle.setLanguage("en")
                
                AnalyticsManager.shared().postAction( withType: kGASetLanguage, targetType: kGATargetTypeApp, targetId: GWLocalizedBundle.currentLocaleString(), targetParameter: nil, actionLocation: kGALoginScreen)
                
                GWDataManager().downloadAllTextsWithBlock(forArea: "stickers", withCulture: GWLocalizedBundle.currentLocaleAPIString(), withCompletion: {
                    texts, error -> Void in
                    
                    print("english texts downloaded")
                    
                })
                self.updateUILanguage()
                
                self.englishButton.isSelected = true
                self.frenchButton.isSelected = false
                self.spanishButton.isSelected = false
                
            }
        })
        
        frenchButton.buttonTouchDown(completion: {
            if self.frenchButton.isSelected == false {
                
                GWLocalizedBundle.setLanguage("fr")
                
                AnalyticsManager.shared().postAction( withType: kGASetLanguage, targetType: kGATargetTypeApp, targetId: GWLocalizedBundle.currentLocaleString(), targetParameter: nil, actionLocation: kGALoginScreen)
                
                GWDataManager().downloadAllTextsWithBlock(forArea: "stickers", withCulture: GWLocalizedBundle.currentLocaleAPIString(), withCompletion: {
                    texts, error -> Void in
                    
                    print("french texts downloaded")
                    
                })
                self.updateUILanguage()
                
                self.frenchButton.isSelected = true
                self.englishButton.isSelected = false
                self.spanishButton.isSelected = false
                
            }
        })
        
        spanishButton.buttonTouchDown(completion: {
            if self.spanishButton.isSelected == false {
                
                GWLocalizedBundle.setLanguage("es")
                
                AnalyticsManager.shared().postAction( withType: kGASetLanguage, targetType: kGATargetTypeApp, targetId: GWLocalizedBundle.currentLocaleString(), targetParameter: nil, actionLocation: kGALoginScreen)
                
                GWDataManager().downloadAllTextsWithBlock(forArea: "stickers", withCulture: GWLocalizedBundle.currentLocaleAPIString(), withCompletion: {
                    texts, error -> Void in
                    
                    print("spanish texts downloaded")
                    
                })
                self.updateUILanguage()
                
                self.spanishButton.isSelected = true
                self.frenchButton.isSelected = false
                self.englishButton.isSelected = false
                
            }
        })
        
        facebookButton = FBSDKLoginButton(frame: CGRect(x: self.view.frame.midX - 120, y: self.view.frame.height - 160, width: 240, height: 60))
        facebookButton.readPermissions = ["public_profile", "email", "user_friends"]
        facebookButton.delegate = self
        facebookButton.setTitle(PopularStickersLocalizedString("<FacebookButtonTitle>", ""), for: UIControlState())
        //self.view.addSubview(facebookButton)
        
        loginFacebookButton = MAXFadeBlockButton(frame: CGRect(x: languageBox.frame.minX, y: self.view.frame.height - 154, width: languageBox.frame.width, height: 60))
        loginFacebookButton.backgroundColor = UIColor.c_facebookBlue()
        loginFacebookButton.layer.cornerRadius = 4.0
        loginFacebookButton.setTitle(PopularStickersLocalizedString("<FacebookButtonTitle>", nil), for: UIControlState())
        loginFacebookButton.titleLabel?.font = UIFont.c_robotoMedium( withSize: 16.0 )
        
        loginFacebookButton.buttonTouchUpInside(completion: {
            
            self.facebookButton.sendActions( for: UIControlEvents.touchUpInside )
            
        })
        
        
        self.view.addSubview( loginFacebookButton )
        
        startButton = MAXFadeBlockButton()
        startButton.frame = CGRect(x: languageBox.frame.minX, y: self.view.frame.height - 85, width: loginFacebookButton.frame.width, height: 60)
        startButton.setTitle( PopularStickersLocalizedString("<StartAppTitle>", nil), for: UIControlState())
        startButton.setTitleColor(UIColor.white, for: UIControlState())
        startButton.titleLabel?.font = UIFont.c_robotoMedium(withSize: 16.0)
        startButton.layer.backgroundColor = UIColor.clear.cgColor
        startButton.layer.borderWidth = 2.0
        startButton.layer.borderColor = UIColor.white.cgColor
        startButton.layer.cornerRadius = 5.0
        
        startButton.buttonTouchUpInside(completion: {
            
            AnalyticsManager.shared().postAction( withType: kGALoginWithoutFacebook, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: kGALoginScreen)
            
            self.showGenderSelectionView()
        })
        
        self.view.addSubview(startButton);

        
        if self.view.frame.size.height == 480 {
            loginFacebookButton.frame = CGRect(x: loginFacebookButton.frame.minX, y: self.view.frame.height - 130, width: loginFacebookButton.frame.width, height: 50)
            startButton.frame = CGRect(x: startButton.frame.minX, y: self.view.frame.height - 74, width: startButton.frame.width, height: 50)
        }
        else if self.view.frame.size.height == 667 {
            
            loginFacebookButton.frame = CGRect(x: loginFacebookButton.frame.minX, y: self.view.frame.height - 175, width: loginFacebookButton.frame.width, height: loginFacebookButton.frame.height)
            startButton.frame = CGRect(x: startButton.frame.minX, y: self.view.frame.height - 99, width: startButton.frame.width, height: startButton.frame.height)
            
        }
        else if self.view.frame.size.height == 736 {
            
            loginFacebookButton.frame = CGRect(x: loginFacebookButton.frame.minX, y: self.view.frame.height - 185, width: loginFacebookButton.frame.width, height: loginFacebookButton.frame.height)
            startButton.frame = CGRect(x: startButton.frame.minX, y: self.view.frame.height - 106, width: startButton.frame.width, height: startButton.frame.height)
            
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
        
        startButton.setTitle(PopularStickersLocalizedString("<StartAppTitle>", nil), for: UIControlState())
        loginFacebookButton.setTitle(PopularStickersLocalizedString("<FacebookButtonTitle>", ""), for: UIControlState())
        
    }
    
    
    fileprivate func createLanguageSelectButton(_ title: String, width: CGFloat, height: CGFloat) -> MAXSelectedContentButton {
        
        let button = MAXSelectedContentButton(frame: CGRect(x: 0, y: 0, width: width, height: height))
        button.backgroundColor = UIColor.clear
        button.titleLabel?.font = UIFont.c_roboto(withSize: Float(height) / 3.0)
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.c_textDarkGray(), for: UIControlState())
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        button.contentEdgeInsets = UIEdgeInsetsMake(0, width * 0.05, 0, width * 0.15)
        
        
        var image = UIImage(named: "CheckMarkIcon")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        
        let checkMarkImageView = UIImageView(image: image)
        checkMarkImageView.frame = CGRect(x: width * 0.85, y: button.frame.height*0.25, width: button.frame.height * 0.5, height: button.frame.height * 0.5)
        checkMarkImageView.contentMode = UIViewContentMode.scaleAspectFit
        checkMarkImageView.tintColor = UIColor.c_blueCheckMark()
        
        
        button.addSelectedContent(checkMarkImageView)
        
        return button
    }
    
    func showGenderSelectionView() {
        
        let overlayView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        overlayView.backgroundColor = UIColor.c_color(withHexString: UIColor.c_hexValues(from: UIColor.black), alpha: 0.3)
        overlayView.alpha = 1.0
        self.view.addSubview( overlayView )
        
        let backgroundButton = MAXFadeBlockButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        backgroundButton.buttonTouchUpInside(completion: {
            
            UIView.animate(withDuration: 0.2, animations: {
                
                overlayView.alpha = 0.0
                
                }, completion: {
                    finished -> Void in
                    
                    overlayView.removeFromSuperview()
                    
            })
            
        })
        
        overlayView.addSubview( backgroundButton )
        
        let genderSelectionView = UIView(frame: CGRect(x: self.view.frame.width * 0.1, y: self.view.frame.height * 0.3, width: self.view.frame.width * 0.8, height: self.view.frame.height * 0.4))
        genderSelectionView.layer.cornerRadius = 6
        genderSelectionView.backgroundColor = UIColor.white
        genderSelectionView.layer.shadowColor = UIColor.black.cgColor
        genderSelectionView.layer.shadowOpacity = 0.9
        genderSelectionView.layer.shadowRadius = 4.0
        
        overlayView.addSubview(genderSelectionView)
        
        let genderSelectionTitle = UILabel(frame: CGRect(x: 0, y: 0, width: genderSelectionView.frame.width, height: genderSelectionView.frame.height * 0.18))
        genderSelectionTitle.text = PopularStickersLocalizedString("<MyGenderTitle>", nil)
        genderSelectionTitle.textColor = UIColor.black
        genderSelectionTitle.font = UIFont.c_robotoMedium(withSize: 18.0)
        genderSelectionTitle.textAlignment = .center
        genderSelectionView.addSubview(genderSelectionTitle)
        
        let womanButton = MAXFadeBlockButton(frame: CGRect(x: genderSelectionView.frame.width * 0.55, y: genderSelectionView.frame.height * 0.18, width: genderSelectionView.frame.width * 0.4, height: genderSelectionView.frame.height * 0.55))
        womanButton.layer.cornerRadius = 4
        
        let womanImageView = UIImageView(frame: CGRect(x: womanButton.frame.width * 0.16, y: womanButton.frame.height * 0.1, width: womanButton.frame.width * 0.68, height: womanButton.frame.height * 0.45))
        womanImageView.contentMode = UIViewContentMode.scaleAspectFit
        womanImageView.image = UIImage(named: "FemaleIcon")
        womanButton.addSubview(womanImageView)
        
        womanButton.titleEdgeInsets = UIEdgeInsetsMake(womanButton.frame.height * 0.82, 0, 0, 0)
        womanButton.setTitle( PopularStickersLocalizedString("<FemaleString>", nil), for: UIControlState())
        womanButton.titleLabel?.font = UIFont.c_roboto(withSize: 15.0)
        womanButton.setTitleColor(UIColor.black, for: UIControlState())
        womanButton.layer.borderWidth = 1.0
        womanButton.layer.borderColor = UIColor.lightGray.cgColor
        womanButton.layer.cornerRadius = 4.0
        
        genderSelectionView.addSubview(womanButton)
        
        womanButton.buttonTouchUpInside(completion: {
            
            UserDefaults.setUserGender("F")
            
            AnalyticsManager.shared().postAction( withType: kGAGender, targetType: kGATargetTypeApp, targetId: UserDefaults.userGender(), targetParameter: nil, actionLocation: kGALoginScreen)
            
            self.showStickersOverviewController()
        })
        
        let manButton = MAXFadeBlockButton(frame:  CGRect(x: genderSelectionView.frame.width * 0.05, y: genderSelectionView.frame.height * 0.18, width: genderSelectionView.frame.width * 0.4, height: genderSelectionView.frame.height * 0.55))
        manButton.layer.cornerRadius = 4
        
        let manImageView = UIImageView(frame: CGRect(x: manButton.frame.width * 0.16, y: manButton.frame.height * 0.1, width: manButton.frame.width * 0.68, height: manButton.frame.height * 0.45))
        manImageView.contentMode = UIViewContentMode.scaleAspectFit
        manImageView.image = UIImage(named: "MaleIcon")
        manButton.addSubview(manImageView)
        
        manButton.titleEdgeInsets = UIEdgeInsetsMake(manButton.frame.height * 0.82, 0, 0, 0)
        manButton.setTitle( PopularStickersLocalizedString("<MaleString>", nil), for: UIControlState())
        manButton.setTitleColor(UIColor.black, for: UIControlState())
        manButton.titleLabel?.font = UIFont.c_roboto(withSize: 15.0)
        manButton.layer.borderWidth = 1.0
        manButton.layer.borderColor = UIColor.lightGray.cgColor
        manButton.layer.cornerRadius = 4
        
        genderSelectionView.addSubview(manButton)
        
        manButton.buttonTouchUpInside(completion: {
            
            UserDefaults.setUserGender("H")
            
            AnalyticsManager.shared().postAction( withType: kGAGender, targetType: kGATargetTypeApp, targetId: UserDefaults.userGender(), targetParameter: nil, actionLocation: kGALoginScreen)
            
            self.showStickersOverviewController()
        })
        
        let skipButton = MAXFadeBlockButton(frame: CGRect(x: genderSelectionView.frame.width * 0.2, y: genderSelectionView.frame.height * 0.8, width: genderSelectionView.frame.width * 0.6, height: genderSelectionView.frame.height * 0.2))
        
        skipButton.setTitle( PopularStickersLocalizedString("<Skip>", nil), for: UIControlState())
        skipButton.setTitleColor(UIColor.black, for: UIControlState())
        skipButton.titleLabel?.font = UIFont.c_roboto(withSize: 18.0)
        
        skipButton.buttonTouchUpInside(completion: {
            
            AnalyticsManager.shared().postAction( withType: kGAGender, targetType: kGATargetTypeApp, targetId: "Skip", targetParameter: nil, actionLocation: kGALoginScreen)
            
            self.showStickersOverviewController()
        })
        
        genderSelectionView.addSubview(skipButton)
        
        UIView.animate(withDuration: 0.2, animations: {
            
            overlayView.alpha = 1.0
            
        })
        
        
    }
    
    // MARK: Login Button Delegate
    
    // Not being used right now
    func loginWithFacebook()  {
        
        FBSDKLoginManager().logIn( withReadPermissions: ["public_profile", "email", "user_friends"] , from: self, handler: {
            loginResult, error in
            
            
            
        })
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if let _ = FBSDKAccessToken.current() {
            
            AnalyticsManager.shared().postAction( withType: kGALoginWithFacebook, targetType: kGATargetTypeApp, targetId: nil, targetParameter: nil, actionLocation: kGALoginScreen)
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, gender, age_range, email"]).start(completionHandler: {
                connection, result, error -> Void in
                
                
                
                if let dict = result as? NSDictionary, error == nil {
                    
                    if let gender = dict.object(forKey: "gender") as? String {
                        
                        if gender == "male" {
                            UserDefaults.setUserGender("H")
                            AnalyticsManager.shared().postAction( withType: kGAGender, targetType: kGATargetTypeApp, targetId: UserDefaults.userGender(), targetParameter: nil, actionLocation: kGALoginScreen)
                        }
                        else if gender == "female" {
                            UserDefaults.setUserGender("F")
                            AnalyticsManager.shared().postAction( withType: kGAGender, targetType: kGATargetTypeApp, targetId: UserDefaults.userGender(), targetParameter: nil, actionLocation: kGALoginScreen)
                        }
                    }
                    
                    if let facebookId = dict.object(forKey: "id") as? String {
                        UserDefaults.setFacebookId(facebookId)
                        AnalyticsManager.shared().postAction( withType: kGASetFacebookId, targetType: kGATargetTypeApp, targetId: facebookId, targetParameter: nil, actionLocation: kGALoginScreen)
                    }
                    
                    if let email = dict.object(forKey: "email") as? String {
                        
                        AnalyticsManager.shared().postAction(withType: kGAUserEmail, targetType: kGATargetTypeApp, targetId: email, targetParameter: nil, actionLocation: kGALoginScreen)
                        
                    }
                    
                }
                
            })
            
            self.showStickersOverviewController()
            
        }
        else {
            // MARK: Show some error
        }
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }

    
    // MARK: Navigation
    
    func showStickersOverviewController() {
        
        if UserDefaults.isFirstLaunch() == true {
            
            self.present( PersonalityIntroViewController(type: PersonalityViewControllerType.intro), animated: true, completion: nil)
        }
        else {
            
            let stickersOverview = StickersOverviewController()
            
            self.present( stickersOverview, animated: true, completion: nil)
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
