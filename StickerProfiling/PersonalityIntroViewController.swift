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
    case Settings
    case Intro
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
        
        let headerView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64))
        headerView.backgroundColor = UIColor.c_blueColor()
        
        self.view.addSubview(headerView)
        
        let stickersTitleLabel = UILabel(frame: CGRectMake( 10, 20, CGRectGetWidth(self.view.frame) * 0.92, 44))
        stickersTitleLabel.textAlignment = .Left
        stickersTitleLabel.textColor = UIColor.whiteColor()
        stickersTitleLabel.text = "\(PopularStickersLocalizedString("<MyMBTI>", nil)) 1 \(PopularStickersLocalizedString("<Of>", nil)) \(self.pagingScrollView.numPages) "
        stickersTitleLabel.font = UIFont.c_robotoWithSize(Float(CGRectGetHeight(self.view.frame) * 0.03))
        stickersTitleLabel.adjustsFontSizeToFitWidth = true
        stickersTitleLabel.minimumScaleFactor = 0.7
        
        
        // add the back arrow if it is the settings view otherwise leave it as is
        if type == PersonalityViewControllerType.Settings {
            
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
            
            
            stickersTitleLabel.frame = CGRectMake(CGRectGetMaxX(backButton.frame), CGRectGetMinY(stickersTitleLabel.frame), CGRectGetWidth(stickersTitleLabel.frame) - CGRectGetMaxX(backButton.frame), CGRectGetHeight(stickersTitleLabel.frame))
            
        }
        
        
        
        headerView.addSubview(stickersTitleLabel)
        
        
        let backgroundImageView = UIImageView(frame: CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64))
        backgroundImageView.image = UIImage(named: "BackgroundRays")
        self.view.addSubview(backgroundImageView)
        
        
        pagingScrollView.frame = CGRectMake(0, CGRectGetMaxY(headerView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(headerView.frame))
        pagingScrollView.pageControl.hidden = true
        pagingScrollView.scrollView.showsHorizontalScrollIndicator = false
        pagingScrollView.disableDrag = true
        
        pagingScrollView.MAXScrollViewNumPagesWithBlock({
            
            return self.viewModel.numberOfPages()
        })
        
        pagingScrollView.MAXScrollViewWithViewAtPageBlock({
            view, index  in
            
            if index == self.viewModel.numberOfPages() - 1 && self.type == PersonalityViewControllerType.Settings {
                
                view.addSubview( self.createEndView( view ) )
                
            }
            else {
                view.addSubview( self.createViewWith(index, textBody: self.viewModel.question(at: index), firstButtonTitle: self.viewModel.answer(at: index, at: 0), secondButtonTitle: self.viewModel.answer(at: index, at: 1), view: view) )
            }
            
        })
        
        pagingScrollView.MAXScrollViewDidChangePage({
            newPage in
            
            stickersTitleLabel.text = "\(PopularStickersLocalizedString("<MyMBTI>", nil)) \(self.pagingScrollView.currentPage + 1) \(PopularStickersLocalizedString("<Of>", nil)) \(self.pagingScrollView.numPages)"
            
        })
        
        
        self.view.addSubview( pagingScrollView )
        
        
        let progressHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHud.mode = MBProgressHUDMode.Indeterminate
        
        self.viewModel.downloadPersonalQuestions({
            error -> Void in
            
            self.pagingScrollView.reloadDataBlocks()
            stickersTitleLabel.text = "\(PopularStickersLocalizedString("<MyMBTI>", nil)) \(self.pagingScrollView.currentPage + 1) \(PopularStickersLocalizedString("<Of>", nil)) \(self.pagingScrollView.numPages)"
            
            progressHud.hideAnimated( true )
            
        })
        
        if self.type == PersonalityViewControllerType.Intro {
            
            let skipButton = MAXFadeBlockButton(frame: CGRectMake(CGRectGetMidX(self.view.frame) - 80, CGRectGetHeight(self.view.frame) - 80, 160, 80))
            skipButton.setTitle(PopularStickersLocalizedString("<Skip>", nil), forState: UIControlState.Normal)
            skipButton.setTitleColor( UIColor.darkGrayColor(), forState: UIControlState.Normal)
            skipButton.titleLabel?.font = UIFont.c_robotoMediumWithSize( 18.0 )
            
            skipButton.buttonTouchUpInsideWithCompletion({
                
                self.moveToOverviewVC()
                
            })
            
            self.view.addSubview( skipButton )
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createViewWith(index: Int, textBody: String?, firstButtonTitle: String?, secondButtonTitle: String?, view: UIView) -> UIView {
     
        let containerView = UIView(frame:  CGRectMake(0, 0, view.frame.size.width, view.frame.size.height))
        
        let rectangleView = UIView(frame: CGRectMake(CGRectGetWidth(view.frame) * 0.03, CGRectGetHeight(view.frame) * 0.2, CGRectGetWidth(view.frame) * 0.94, CGRectGetHeight(view.frame) * 0.65))
        rectangleView.backgroundColor = UIColor.whiteColor()
        containerView.addSubview( rectangleView )
        
        let circleView = UIView(frame: CGRectMake(CGRectGetWidth(view.frame) * 0.5 - CGRectGetHeight(view.frame) * 0.15, CGRectGetHeight(view.frame) * 0.05, CGRectGetHeight(view.frame) * 0.3, CGRectGetHeight(view.frame) * 0.3))
        circleView.backgroundColor = UIColor.whiteColor()
        circleView.layer.cornerRadius = CGRectGetWidth(circleView.frame) / 2.0
        containerView.addSubview( circleView )
        
        let circleImageView = UIImageView(frame: CGRectMake(CGRectGetWidth(view.frame) * 0.5 - CGRectGetHeight(view.frame) * 0.13, CGRectGetMinY(circleView.frame) + CGRectGetHeight(view.frame) * 0.02, CGRectGetHeight(view.frame) * 0.26, CGRectGetHeight(view.frame) * 0.26))
        circleImageView.layer.cornerRadius = CGRectGetWidth(circleImageView.frame) * 0.5
        circleImageView.layer.masksToBounds = true
        circleImageView.contentMode = UIViewContentMode.ScaleAspectFit
        containerView.addSubview( circleImageView )
        
        let questionLabel = UILabel(frame: CGRectMake( CGRectGetWidth(rectangleView.frame) * 0.1, CGRectGetHeight(rectangleView.frame) * 0.25, CGRectGetWidth(rectangleView.frame) * 0.8, CGRectGetHeight(rectangleView.frame) * 0.2))
        questionLabel.textAlignment = .Center
        questionLabel.text = textBody
        questionLabel.textColor = UIColor.blackColor()
        questionLabel.font = UIFont.c_robotoWithSize( Float(CGRectGetHeight(self.view.frame) * 0.035) )
        questionLabel.numberOfLines = 2
        questionLabel.adjustsFontSizeToFitWidth = true
        questionLabel.minimumScaleFactor = 0.7
        rectangleView.addSubview( questionLabel )
        
        
        if self.viewModel.hasAnsweredQuestion(at: index) == false {
            
            let firstAnswerButton = MAXFadeBlockButton(frame: CGRectMake(CGRectGetWidth(rectangleView.frame) * 0.1, CGRectGetHeight(rectangleView.frame) * 0.5, CGRectGetWidth(rectangleView.frame) * 0.8, CGRectGetHeight(rectangleView.frame) * 0.16))
            firstAnswerButton.layer.backgroundColor = UIColor.c_blueColor().CGColor
            firstAnswerButton.layer.cornerRadius = 5.0
            firstAnswerButton.setTitle(firstButtonTitle, forState: UIControlState.Normal)
            firstAnswerButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            firstAnswerButton.buttonTouchUpInsideWithCompletion({
                
                self.viewModel.sendEventAtQuestionIndex( index, answerIndex: 0)
                
                if self.pagingScrollView.currentPage < self.pagingScrollView.numPages - 1 {
                    self.pagingScrollView.setPage(self.pagingScrollView.currentPage + 1, animated: true, withCompletion: nil)
                }
                else {
                    self.moveToOverviewVC()
                }
                
            })
            
            rectangleView.addSubview( firstAnswerButton )
            
            
            let secondAnswerButton = MAXFadeBlockButton(frame: CGRectMake(CGRectGetWidth(rectangleView.frame) * 0.1, CGRectGetHeight(rectangleView.frame) * 0.7, CGRectGetWidth(rectangleView.frame) * 0.8, CGRectGetHeight(rectangleView.frame) * 0.16))
            secondAnswerButton.layer.backgroundColor = UIColor.c_blueColor().CGColor
            secondAnswerButton.layer.cornerRadius = 5.0
            secondAnswerButton.setTitle(secondButtonTitle, forState: UIControlState.Normal)
            secondAnswerButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            secondAnswerButton.buttonTouchUpInsideWithCompletion({
                
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
            
            let topSeparator = UIView(frame: CGRectMake(CGRectGetWidth(rectangleView.frame) * 0.1, CGRectGetHeight(rectangleView.frame) * 0.5 - 1, CGRectGetWidth(rectangleView.frame) * 0.8, 1))
            topSeparator.backgroundColor = UIColor.c_textDarkGrayColor()
            rectangleView.addSubview( topSeparator )
            
            let firstAnswerButton = MAXSelectedContentButton(frame: CGRectMake(CGRectGetWidth(rectangleView.frame) * 0.1, CGRectGetHeight(rectangleView.frame) * 0.5, CGRectGetWidth(rectangleView.frame) * 0.8, CGRectGetHeight(rectangleView.frame) * 0.16))
            firstAnswerButton.setTitle(firstButtonTitle, forState: UIControlState.Normal)
            firstAnswerButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            firstAnswerButton.titleEdgeInsets = UIEdgeInsetsMake(0, CGRectGetWidth(firstAnswerButton.frame) * 0.1, 0, 0)
            firstAnswerButton.titleLabel?.adjustsFontSizeToFitWidth = true
            firstAnswerButton.titleLabel?.minimumScaleFactor = 0.7
            firstAnswerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            
            let circleOutlineOne = UIView(frame: CGRectMake(0, CGRectGetHeight( firstAnswerButton.frame ) / 2.0 - CGRectGetHeight(rectangleView.frame) * 0.02, CGRectGetHeight(rectangleView.frame) * 0.04, CGRectGetHeight(rectangleView.frame) * 0.04))
            circleOutlineOne.layer.cornerRadius = CGRectGetWidth( circleOutlineOne.frame ) / 2.0
            circleOutlineOne.layer.borderWidth = 2.0
            circleOutlineOne.layer.borderColor = UIColor.c_blueColor().CGColor
            firstAnswerButton.addSubview( circleOutlineOne )
            
            let circleFillOne = UIView(frame: CGRectMake(CGRectGetWidth(circleOutlineOne.frame) * 0.2, CGRectGetWidth(circleOutlineOne.frame) * 0.2, CGRectGetWidth(circleOutlineOne.frame) * 0.6, CGRectGetWidth(circleOutlineOne.frame) * 0.6))
            circleFillOne.layer.cornerRadius = CGRectGetWidth(circleFillOne.frame) / 2.0
            circleFillOne.backgroundColor = UIColor.c_blueColor()
            circleFillOne.hidden = self.viewModel.hasAnsweredQuestion( index, answerIndex: 0) == false
            circleOutlineOne.addSubview( circleFillOne )
            
            firstAnswerButton.buttonTouchUpInsideWithCompletion({
                
                self.viewModel.sendEventAtQuestionIndex( index, answerIndex: 0)
                self.pagingScrollView.setPage(self.pagingScrollView.currentPage + 1, animated: true, withCompletion: nil)
                self.pagingScrollView.reloadDataBlocks()
                
                if self.pagingScrollView.currentPage == self.viewModel.numberOfPages() - 1 {
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }
                
            })
            
            rectangleView.addSubview( firstAnswerButton )
            
            
            let middleSeparator = UIView(frame: CGRectMake(CGRectGetWidth(rectangleView.frame) * 0.1, CGRectGetMaxY(firstAnswerButton.frame), CGRectGetWidth(rectangleView.frame) * 0.8, 1))
            middleSeparator.backgroundColor = UIColor.c_textDarkGrayColor()
            rectangleView.addSubview( middleSeparator )
            
            let secondAnswerButton = MAXFadeBlockButton(frame: CGRectMake(CGRectGetWidth(rectangleView.frame) * 0.1, CGRectGetMaxY(firstAnswerButton.frame), CGRectGetWidth(rectangleView.frame) * 0.8, CGRectGetHeight(rectangleView.frame) * 0.16))
            secondAnswerButton.setTitle(secondButtonTitle, forState: UIControlState.Normal)
            secondAnswerButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            secondAnswerButton.titleEdgeInsets = UIEdgeInsetsMake(0, CGRectGetWidth(secondAnswerButton.frame) * 0.1, 0, 0)
            secondAnswerButton.titleLabel?.adjustsFontSizeToFitWidth = true
            secondAnswerButton.titleLabel?.minimumScaleFactor = 0.7
            secondAnswerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            
            secondAnswerButton.buttonTouchUpInsideWithCompletion({
                
                self.viewModel.sendEventAtQuestionIndex( index, answerIndex: 1)
                self.pagingScrollView.setPage(self.pagingScrollView.currentPage + 1, animated: true, withCompletion: nil)
                self.pagingScrollView.reloadDataBlocks()
                
                if self.pagingScrollView.currentPage == self.viewModel.numberOfPages() - 1 {
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }
                
            })
            
            rectangleView.addSubview( secondAnswerButton )
            
            
            let circleOutlineTwo = UIView(frame: CGRectMake(0, CGRectGetHeight( secondAnswerButton.frame ) / 2.0 - CGRectGetHeight(rectangleView.frame) * 0.02, CGRectGetHeight(rectangleView.frame) * 0.04, CGRectGetHeight(rectangleView.frame) * 0.04))
            circleOutlineTwo.layer.cornerRadius = CGRectGetWidth(circleOutlineTwo.frame) / 2.0
            circleOutlineTwo.layer.borderWidth = 2.0
            circleOutlineTwo.layer.borderColor = UIColor.c_blueColor().CGColor
            secondAnswerButton.addSubview( circleOutlineTwo )
            
            
            let circleFillTwo = UIView(frame: CGRectMake(CGRectGetWidth( circleOutlineTwo.frame ) * 0.2, CGRectGetWidth(circleOutlineTwo.frame) * 0.2, CGRectGetWidth(circleOutlineTwo.frame) * 0.6, CGRectGetWidth(circleOutlineTwo.frame) * 0.6))
            circleFillTwo.layer.cornerRadius = CGRectGetWidth(circleFillTwo.frame) / 2.0
            circleFillTwo.layer.backgroundColor = UIColor.c_blueColor().CGColor
            circleFillTwo.hidden = self.viewModel.hasAnsweredQuestion(index, answerIndex: 1) == false
            circleOutlineTwo.addSubview( circleFillTwo )
            
            let bottomSeparator = UIView(frame: CGRectMake(CGRectGetWidth(rectangleView.frame) * 0.1, CGRectGetMaxY(secondAnswerButton.frame), CGRectGetWidth(rectangleView.frame) * 0.8, 1))
            bottomSeparator.backgroundColor = UIColor.c_textDarkGrayColor()
            rectangleView.addSubview( bottomSeparator )
            
        }
        
        
        if self.type == PersonalityViewControllerType.Settings {
            
            let nextButton = MAXSelectedContentButton(frame: CGRectMake( CGRectGetWidth(rectangleView.frame) - CGRectGetWidth(rectangleView.frame) * 0.3, CGRectGetHeight(rectangleView.frame) - 50, CGRectGetWidth(rectangleView.frame) * 0.3, 50))
            nextButton.setTitle( PopularStickersLocalizedString("<Next>", nil), forState: UIControlState.Normal)
            nextButton.setTitleColor(UIColor.c_blueColor(), forState: UIControlState.Normal)
            nextButton.titleLabel?.font = UIFont.c_robotoMediumWithSize( 18.0 )
            
            if index == self.viewModel.numberOfPages() - 1 {
                nextButton.setTitle( PopularStickersLocalizedString("<Done>", nil), forState: UIControlState.Normal)
            }
            
            nextButton.buttonTouchUpInsideWithCompletion({
                
                if self.pagingScrollView.currentPage == self.viewModel.numberOfPages() - 1 {
                    self.dismissViewControllerAnimated(true, completion: nil)
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
    
    func createEndView(view: UIView) -> UIView {
        
        let endContainerView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, view.frame.size.height))
        endContainerView.backgroundColor = UIColor.whiteColor()
        
        let titleLabel = UILabel(frame: CGRectMake(CGRectGetWidth(view.frame) * 0.1, 0, CGRectGetWidth(view.frame) * 0.8, CGRectGetHeight(view.frame) * 0.2))
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.c_robotoWithSize( Float(CGRectGetHeight(self.view.frame) * 0.03) )
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.7
        titleLabel.text = PopularStickersLocalizedString("<MBTIDoneMessage>", nil)
        titleLabel.numberOfLines = 3
        endContainerView.addSubview( titleLabel )
        
        let imageView = UIImageView(frame: CGRectMake(CGRectGetWidth(view.frame) * 0.1, CGRectGetHeight(view.frame) * 0.2, CGRectGetWidth(view.frame) * 0.8, CGRectGetHeight(view.frame) * 0.8 - CGRectGetHeight(view.frame) * 0.14))
        imageView.image = UIImage(named: "PersonalityEndImage")
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        endContainerView.addSubview( imageView )
        
        let bottomDoneButton = MAXSelectedContentButton(frame: CGRectMake(CGRectGetWidth(view.frame) * 0.1, CGRectGetHeight(view.frame) - CGRectGetHeight(view.frame) * 0.12, CGRectGetWidth(view.frame) * 0.8, CGRectGetHeight(view.frame) * 0.1 ))
        bottomDoneButton.setTitle( PopularStickersLocalizedString("<Done>", nil), forState: UIControlState.Normal)
        bottomDoneButton.titleLabel?.font = UIFont.c_robotoWithSize( Float(CGRectGetHeight(self.view.frame) * 0.03) )
        bottomDoneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        bottomDoneButton.titleLabel?.adjustsFontSizeToFitWidth = true
        bottomDoneButton.titleLabel?.minimumScaleFactor = 0.7
        bottomDoneButton.layer.backgroundColor = UIColor.c_blueColor().CGColor
        bottomDoneButton.layer.cornerRadius = 5.0
        
        bottomDoneButton.buttonTouchUpInsideWithCompletion({
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })
        
        endContainerView.addSubview( bottomDoneButton )
        
        return endContainerView
    }
    
    func moveToOverviewVC() {
        
        let stickersOverview = StickersOverviewController()        
        
        self.presentViewController( stickersOverview, animated: true, completion: nil)
        
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
