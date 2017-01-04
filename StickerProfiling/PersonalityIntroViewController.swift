//
//  PersonalityIntroViewController.swift
//  StickerBliss
//
//  Created by Mathieu Skulason on 04/10/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit
import MBProgressHUD

enum PersonalityViewControllerType {
    case settings
    case intro
}

class PersonalityIntroViewController: UIViewController {

    let viewModel : PersonalityIntroductionModel
    let pagingScrollView = MAXPagingScrollView()
    let type: PersonalityViewControllerType
    
    init(type: PersonalityViewControllerType) {
        
        self.type = type
        self.viewModel = PersonalityIntroductionModel(type: type)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64))
        headerView.backgroundColor = UIColor.c_blue()
        
        self.view.addSubview(headerView)
        
        let stickersTitleLabel = UILabel(frame: CGRect( x: 10, y: 20, width: self.view.frame.width * 0.92, height: 44))
        stickersTitleLabel.textAlignment = .left
        stickersTitleLabel.textColor = UIColor.white
        stickersTitleLabel.text = "\(PopularStickersLocalizedString("<MyMBTI>", nil)) 1 \(PopularStickersLocalizedString("<Of>", nil)) \(self.pagingScrollView.numPages) "
        stickersTitleLabel.font = UIFont.c_roboto(withSize: Float(self.view.frame.height * 0.03))
        stickersTitleLabel.adjustsFontSizeToFitWidth = true
        stickersTitleLabel.minimumScaleFactor = 0.7
        
        
        // add the back arrow if it is the settings view otherwise leave it as is
        if type == PersonalityViewControllerType.settings {
            
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
            
            
            stickersTitleLabel.frame = CGRect(x: backButton.frame.maxX, y: stickersTitleLabel.frame.minY, width: stickersTitleLabel.frame.width - backButton.frame.maxX, height: stickersTitleLabel.frame.height)
            
        }
        
        
        
        headerView.addSubview(stickersTitleLabel)
        
        
        let backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 64))
        backgroundImageView.image = UIImage(named: "BackgroundRays")
        self.view.addSubview(backgroundImageView)
        
        
        pagingScrollView.frame = CGRect(x: 0, y: headerView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - headerView.frame.maxY)
        pagingScrollView.pageControl.isHidden = true
        pagingScrollView.scrollView.showsHorizontalScrollIndicator = false
        pagingScrollView.disableDrag = true
        
        pagingScrollView.maxScrollViewNumPages({
            
            return self.viewModel.numberOfPages()
        })
        
        pagingScrollView.maxScrollViewWithView(atPageBlock: {
            view, index  in
            
            if index == self.viewModel.numberOfPages() - 1 && self.type == PersonalityViewControllerType.settings {
                
                view.addSubview( self.createEndView( view ) )
                
            }
            else {
                view.addSubview( self.createViewWith(index, textBody: self.viewModel.question(at: index), firstButtonTitle: self.viewModel.answer(at: index, at: 0), secondButtonTitle: self.viewModel.answer(at: index, at: 1), view: view) )
            }
            
        })
        
        pagingScrollView.maxScrollViewDidChangePage({
            newPage in
            
            stickersTitleLabel.text = "\(PopularStickersLocalizedString("<MyMBTI>", nil)) \(self.pagingScrollView.currentPage + 1) \(PopularStickersLocalizedString("<Of>", nil)) \(self.pagingScrollView.numPages)"
            
        })
        
        
        self.view.addSubview( pagingScrollView )
        
        
        let progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHud.mode = MBProgressHUDMode.indeterminate
        
        self.viewModel.downloadPersonalQuestions({
            error -> Void in
            
            self.pagingScrollView.reloadDataBlocks()
            stickersTitleLabel.text = "\(PopularStickersLocalizedString("<MyMBTI>", nil)) \(self.pagingScrollView.currentPage + 1) \(PopularStickersLocalizedString("<Of>", nil)) \(self.pagingScrollView.numPages)"
            
            progressHud.hide( animated: true )
            
        })
        
        if self.type == PersonalityViewControllerType.intro {
            
            let skipButton = MAXFadeBlockButton(frame: CGRect(x: self.view.frame.midX - 80, y: self.view.frame.height - 80, width: 160, height: 80))
            skipButton.setTitle(PopularStickersLocalizedString("<Skip>", nil), for: UIControlState())
            skipButton.setTitleColor( UIColor.darkGray, for: UIControlState())
            skipButton.titleLabel?.font = UIFont.c_robotoMedium( withSize: 18.0 )
            
            skipButton.buttonTouchUpInside(completion: {
                
                self.moveToOverviewVC()
                
            })
            
            self.view.addSubview( skipButton )
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createViewWith(_ index: Int, textBody: String?, firstButtonTitle: String?, secondButtonTitle: String?, view: UIView) -> UIView {
     
        let containerView = UIView(frame:  CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        let rectangleView = UIView(frame: CGRect(x: view.frame.width * 0.03, y: view.frame.height * 0.2, width: view.frame.width * 0.94, height: view.frame.height * 0.65))
        rectangleView.backgroundColor = UIColor.white
        containerView.addSubview( rectangleView )
        
        let circleView = UIView(frame: CGRect(x: view.frame.width * 0.5 - view.frame.height * 0.15, y: view.frame.height * 0.05, width: view.frame.height * 0.3, height: view.frame.height * 0.3))
        circleView.backgroundColor = UIColor.white
        circleView.layer.cornerRadius = circleView.frame.width / 2.0
        containerView.addSubview( circleView )
        
        let circleImageView = UIImageView(frame: CGRect(x: view.frame.width * 0.5 - view.frame.height * 0.13, y: circleView.frame.minY + view.frame.height * 0.02, width: view.frame.height * 0.26, height: view.frame.height * 0.26))
        circleImageView.layer.cornerRadius = circleImageView.frame.width * 0.5
        circleImageView.layer.masksToBounds = true
        circleImageView.contentMode = UIViewContentMode.scaleAspectFit
        containerView.addSubview( circleImageView )
        
        let questionLabel = UILabel(frame: CGRect( x: rectangleView.frame.width * 0.1, y: rectangleView.frame.height * 0.25, width: rectangleView.frame.width * 0.8, height: rectangleView.frame.height * 0.2))
        questionLabel.textAlignment = .center
        questionLabel.text = textBody
        questionLabel.textColor = UIColor.black
        questionLabel.font = UIFont.c_roboto( withSize: Float(self.view.frame.height * 0.035) )
        questionLabel.numberOfLines = 2
        questionLabel.adjustsFontSizeToFitWidth = true
        questionLabel.minimumScaleFactor = 0.7
        rectangleView.addSubview( questionLabel )
        
        
        if self.viewModel.hasAnsweredQuestion(at: index) == false {
            
            let firstAnswerButton = MAXFadeBlockButton(frame: CGRect(x: rectangleView.frame.width * 0.1, y: rectangleView.frame.height * 0.5, width: rectangleView.frame.width * 0.8, height: rectangleView.frame.height * 0.16))
            firstAnswerButton.layer.backgroundColor = UIColor.c_blue().cgColor
            firstAnswerButton.layer.cornerRadius = 5.0
            firstAnswerButton.setTitle(firstButtonTitle, for: UIControlState())
            firstAnswerButton.setTitleColor(UIColor.white, for: UIControlState())
            
            firstAnswerButton.buttonTouchUpInside(completion: {
                
                self.viewModel.sendEventAtQuestionIndex( index, answerIndex: 0)
                
                if self.pagingScrollView.currentPage < self.pagingScrollView.numPages - 1 {
                    self.pagingScrollView.setPage(self.pagingScrollView.currentPage + 1, animated: true, withCompletion: nil)
                }
                else {
                    self.moveToOverviewVC()
                }
                
            })
            
            rectangleView.addSubview( firstAnswerButton )
            
            
            let secondAnswerButton = MAXFadeBlockButton(frame: CGRect(x: rectangleView.frame.width * 0.1, y: rectangleView.frame.height * 0.7, width: rectangleView.frame.width * 0.8, height: rectangleView.frame.height * 0.16))
            secondAnswerButton.layer.backgroundColor = UIColor.c_blue().cgColor
            secondAnswerButton.layer.cornerRadius = 5.0
            secondAnswerButton.setTitle(secondButtonTitle, for: UIControlState())
            secondAnswerButton.setTitleColor(UIColor.white, for: UIControlState())
            
            secondAnswerButton.buttonTouchUpInside(completion: {
                
                self.viewModel.sendEventAtQuestionIndex( index, answerIndex: 1)
                
                if self.pagingScrollView.currentPage < self.pagingScrollView.numPages - 1 {
                    self.pagingScrollView.setPage(self.pagingScrollView.currentPage + 1, animated: true, withCompletion: nil)
                }
                else {
                    self.moveToOverviewVC()
                }
                
                
            })
            
            rectangleView.addSubview( secondAnswerButton )
            
        }
        else {
            
            let topSeparator = UIView(frame: CGRect(x: rectangleView.frame.width * 0.1, y: rectangleView.frame.height * 0.5 - 1, width: rectangleView.frame.width * 0.8, height: 1))
            topSeparator.backgroundColor = UIColor.c_textDarkGray()
            rectangleView.addSubview( topSeparator )
            
            let firstAnswerButton = MAXSelectedContentButton(frame: CGRect(x: rectangleView.frame.width * 0.1, y: rectangleView.frame.height * 0.5, width: rectangleView.frame.width * 0.8, height: rectangleView.frame.height * 0.16))
            firstAnswerButton.setTitle(firstButtonTitle, for: UIControlState())
            firstAnswerButton.setTitleColor(UIColor.black, for: UIControlState())
            firstAnswerButton.titleEdgeInsets = UIEdgeInsetsMake(0, firstAnswerButton.frame.width * 0.1, 0, 0)
            firstAnswerButton.titleLabel?.adjustsFontSizeToFitWidth = true
            firstAnswerButton.titleLabel?.minimumScaleFactor = 0.7
            firstAnswerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            
            let circleOutlineOne = UIView(frame: CGRect(x: 0, y: firstAnswerButton.frame.height / 2.0 - rectangleView.frame.height * 0.02, width: rectangleView.frame.height * 0.04, height: rectangleView.frame.height * 0.04))
            circleOutlineOne.layer.cornerRadius = circleOutlineOne.frame.width / 2.0
            circleOutlineOne.layer.borderWidth = 2.0
            circleOutlineOne.layer.borderColor = UIColor.c_blue().cgColor
            firstAnswerButton.addSubview( circleOutlineOne )
            
            let circleFillOne = UIView(frame: CGRect(x: circleOutlineOne.frame.width * 0.2, y: circleOutlineOne.frame.width * 0.2, width: circleOutlineOne.frame.width * 0.6, height: circleOutlineOne.frame.width * 0.6))
            circleFillOne.layer.cornerRadius = circleFillOne.frame.width / 2.0
            circleFillOne.backgroundColor = UIColor.c_blue()
            circleFillOne.isHidden = self.viewModel.hasAnsweredQuestion( index, answerIndex: 0) == false
            circleOutlineOne.addSubview( circleFillOne )
            
            firstAnswerButton.buttonTouchUpInside(completion: {
                
                self.viewModel.sendEventAtQuestionIndex( index, answerIndex: 0)
                self.pagingScrollView.setPage(self.pagingScrollView.currentPage + 1, animated: true, withCompletion: nil)
                self.pagingScrollView.reloadDataBlocks()
                
                if self.pagingScrollView.currentPage == self.viewModel.numberOfPages() - 1 {
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
            })
            
            rectangleView.addSubview( firstAnswerButton )
            
            
            let middleSeparator = UIView(frame: CGRect(x: rectangleView.frame.width * 0.1, y: firstAnswerButton.frame.maxY, width: rectangleView.frame.width * 0.8, height: 1))
            middleSeparator.backgroundColor = UIColor.c_textDarkGray()
            rectangleView.addSubview( middleSeparator )
            
            let secondAnswerButton = MAXFadeBlockButton(frame: CGRect(x: rectangleView.frame.width * 0.1, y: firstAnswerButton.frame.maxY, width: rectangleView.frame.width * 0.8, height: rectangleView.frame.height * 0.16))
            secondAnswerButton.setTitle(secondButtonTitle, for: UIControlState())
            secondAnswerButton.setTitleColor(UIColor.black, for: UIControlState())
            secondAnswerButton.titleEdgeInsets = UIEdgeInsetsMake(0, secondAnswerButton.frame.width * 0.1, 0, 0)
            secondAnswerButton.titleLabel?.adjustsFontSizeToFitWidth = true
            secondAnswerButton.titleLabel?.minimumScaleFactor = 0.7
            secondAnswerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            
            secondAnswerButton.buttonTouchUpInside(completion: {
                
                self.viewModel.sendEventAtQuestionIndex( index, answerIndex: 1)
                self.pagingScrollView.setPage(self.pagingScrollView.currentPage + 1, animated: true, withCompletion: nil)
                self.pagingScrollView.reloadDataBlocks()
                
                if self.pagingScrollView.currentPage == self.viewModel.numberOfPages() - 1 {
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
            })
            
            rectangleView.addSubview( secondAnswerButton )
            
            
            let circleOutlineTwo = UIView(frame: CGRect(x: 0, y: secondAnswerButton.frame.height / 2.0 - rectangleView.frame.height * 0.02, width: rectangleView.frame.height * 0.04, height: rectangleView.frame.height * 0.04))
            circleOutlineTwo.layer.cornerRadius = circleOutlineTwo.frame.width / 2.0
            circleOutlineTwo.layer.borderWidth = 2.0
            circleOutlineTwo.layer.borderColor = UIColor.c_blue().cgColor
            secondAnswerButton.addSubview( circleOutlineTwo )
            
            
            let circleFillTwo = UIView(frame: CGRect(x: circleOutlineTwo.frame.width * 0.2, y: circleOutlineTwo.frame.width * 0.2, width: circleOutlineTwo.frame.width * 0.6, height: circleOutlineTwo.frame.width * 0.6))
            circleFillTwo.layer.cornerRadius = circleFillTwo.frame.width / 2.0
            circleFillTwo.layer.backgroundColor = UIColor.c_blue().cgColor
            circleFillTwo.isHidden = self.viewModel.hasAnsweredQuestion(index, answerIndex: 1) == false
            circleOutlineTwo.addSubview( circleFillTwo )
            
            let bottomSeparator = UIView(frame: CGRect(x: rectangleView.frame.width * 0.1, y: secondAnswerButton.frame.maxY, width: rectangleView.frame.width * 0.8, height: 1))
            bottomSeparator.backgroundColor = UIColor.c_textDarkGray()
            rectangleView.addSubview( bottomSeparator )
            
        }
        
        
        if self.type == PersonalityViewControllerType.settings {
            
            let nextButton = MAXSelectedContentButton(frame: CGRect( x: rectangleView.frame.width - rectangleView.frame.width * 0.3, y: rectangleView.frame.height - 50, width: rectangleView.frame.width * 0.3, height: 50))
            nextButton.setTitle( PopularStickersLocalizedString("<Next>", nil), for: UIControlState())
            nextButton.setTitleColor(UIColor.c_blue(), for: UIControlState())
            nextButton.titleLabel?.font = UIFont.c_robotoMedium( withSize: 18.0 )
            
            if index == self.viewModel.numberOfPages() - 1 {
                nextButton.setTitle( PopularStickersLocalizedString("<Done>", nil), for: UIControlState())
            }
            
            nextButton.buttonTouchUpInside(completion: {
                
                if self.pagingScrollView.currentPage == self.viewModel.numberOfPages() - 1 {
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    self.pagingScrollView.setPage(self.pagingScrollView.currentPage + 1, animated: true, withCompletion: nil)
                }
                
            })
            
            rectangleView.addSubview( nextButton )
            
        }
        
        
        self.viewModel.image(at: index, completion: {
            image, error in
            
            circleImageView.image = image
        })
        
        return containerView
    }
    
    func createEndView(_ view: UIView) -> UIView {
        
        let endContainerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        endContainerView.backgroundColor = UIColor.white
        
        let titleLabel = UILabel(frame: CGRect(x: view.frame.width * 0.1, y: 0, width: view.frame.width * 0.8, height: view.frame.height * 0.2))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.c_roboto( withSize: Float(self.view.frame.height * 0.03) )
        titleLabel.textColor = UIColor.black
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.7
        titleLabel.text = PopularStickersLocalizedString("<MBTIDoneMessage>", nil)
        titleLabel.numberOfLines = 3
        endContainerView.addSubview( titleLabel )
        
        let imageView = UIImageView(frame: CGRect(x: view.frame.width * 0.1, y: view.frame.height * 0.2, width: view.frame.width * 0.8, height: view.frame.height * 0.8 - view.frame.height * 0.14))
        imageView.image = UIImage(named: "PersonalityEndImage")
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        endContainerView.addSubview( imageView )
        
        let bottomDoneButton = MAXSelectedContentButton(frame: CGRect(x: view.frame.width * 0.1, y: view.frame.height - view.frame.height * 0.12, width: view.frame.width * 0.8, height: view.frame.height * 0.1 ))
        bottomDoneButton.setTitle( PopularStickersLocalizedString("<Done>", nil), for: UIControlState())
        bottomDoneButton.titleLabel?.font = UIFont.c_roboto( withSize: Float(self.view.frame.height * 0.03) )
        bottomDoneButton.setTitleColor(UIColor.white, for: UIControlState())
        bottomDoneButton.titleLabel?.adjustsFontSizeToFitWidth = true
        bottomDoneButton.titleLabel?.minimumScaleFactor = 0.7
        bottomDoneButton.layer.backgroundColor = UIColor.c_blue().cgColor
        bottomDoneButton.layer.cornerRadius = 5.0
        
        bottomDoneButton.buttonTouchUpInside(completion: {
            
            self.dismiss(animated: true, completion: nil)
            
        })
        
        endContainerView.addSubview( bottomDoneButton )
        
        return endContainerView
    }
    
    func moveToOverviewVC() {
        
        if let _ = GWExperiment.variationId(), GWExperiment.experimentId() != nil {
            
            let applicationDelegate = UIApplication.shared.delegate as! AppDelegate
            applicationDelegate.showFirstTimeMainScreenReachedAd()
            
        }
        
        let stickersOverview = StickersOverviewController()        
        
        self.present( stickersOverview, animated: true, completion: nil)
        
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
