//
//  PersonalityIntroductionModel.swift
//  StickerBliss
//
//  Created by Mathieu Skulason on 04/10/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class PersonalityIntroductionModel: NSObject {
    
    var personalQuestions: [GWPersonalityQuestion]?
    var personalQuestionIds : [String]?
    let questionType: PersonalityViewControllerType
    
    init(type: PersonalityViewControllerType) {
        
        self.questionType = type
        
        super.init()
        
    }
    
    func downloadPersonalQuestions(_ completion: @escaping (NSError?) -> Void ) {
        
        if self.questionType == PersonalityViewControllerType.intro {
            
            ServerCommunication.downloadPersonalityQuestionsToAsk(withPath: nil, completion: {
                questionIds, error in
                
                self.personalQuestionIds = questionIds
                
                GWDataManager().downloadPersonalityQuestions(withPath: nil, completion: {
                    questions, error in
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.personalQuestions = GWDataManager().fetchPersonalityQuestions( withIds: self.personalQuestionIds )
                        print("personal questions \(self.personalQuestions)")
                        self.orderQuestionsById( questionIds )
                        completion(error as NSError?)
                        
                    })
                    
                })
                
                
            })
            
        }
        else {
            
            GWDataManager().downloadPersonalityQuestions(withPath: nil, completion: {
                questions, error in
                
                DispatchQueue.main.async(execute: {
                    
                    if error == nil && questions != nil {
                        
                        var personalityQuestionsOrder = [String]()
                        for currentQuestion in questions! {
                            personalityQuestionsOrder.append(currentQuestion.personalityQuestionId!)
                        }
                        
                        self.personalQuestions = GWDataManager().fetchPersonalityQuestions( withIds: nil )
                        self.orderQuestionsById( personalityQuestionsOrder )
                        completion( nil )
                        
                        
                    }
                    else {
                        // error occurred
                        completion( error as NSError? )
                    }
                    
                })
                
            })
            
        }
        
    }
    
    func orderQuestionsById(_ ids: [String]?) {
        
        if let nonNilIds = ids, let nonNilPersonalQuesitons = self.personalQuestions {
            
            var newOrder = [GWPersonalityQuestion]()
            
            for currentId in nonNilIds {
                
                for currentPersonalityQuestion in nonNilPersonalQuesitons {
                    
                    if currentId == currentPersonalityQuestion.personalityQuestionId {
                        
                        newOrder.append( currentPersonalityQuestion )
                        break
                    }
                    
                }
                
            }
            
            self.personalQuestions = newOrder
        }
        
        
    }
    
    func numberOfPages() -> Int {
        
        if self.personalQuestions != nil {
            
            if self.questionType == PersonalityViewControllerType.settings {
                
                return self.personalQuestions!.count + 1
            }
            
            return self.personalQuestions!.count
        }
        
        return 0
    }
    
    func question(at index: Int) -> String? {
        
        if index < self.personalQuestions?.count {
            
            let question = self.personalQuestions![index];
            
            return question.question( withCulture: GWLocalizedBundle.currentLocaleAPIString() )
            
        }
        
        return nil
    }
    
    func answer(at index: Int,at questionIndex: Int) -> String? {
        
        if index < self.personalQuestions?.count {
            
            let question = self.personalQuestions![index]
            
            return question.answer( withCulture: GWLocalizedBundle.currentLocaleAPIString(), at: questionIndex, completion: nil)
            
        }
        
        return nil
        
    }
    
    func image(at index: Int, completion: @escaping (UIImage?, NSError?) -> Void) {
        
        if index < self.personalQuestions?.count {
        
            let question = self.personalQuestions![index]
            
            if let nonNilImagePath = question.defaultImage {
                
                GWImageManager.downloadImageIfNotExists(withPath: nonNilImagePath, imageDataCompletion: {
                    imageId, imageData, error in
                    
                    if let nonNilImageData = imageData {
                        completion(UIImage(data:  nonNilImageData), nil)
                    }
                    else {
                        completion(nil, error as NSError?)
                    }
                    
                })
                
            }
            
        }
        
    }
    
    func hasAnsweredQuestion(at index: Int) -> Bool {
        
        let question = self.personalQuestions![index]
        
        let answerOne = question.answers![0] as! NSDictionary
        let answerTwo = question.answers![1] as! NSDictionary
        
        return self.hasAnswered( answerOne.object( forKey: "Id" ) as! String, answerIdTwo: answerTwo.object( forKey: "Id" ) as! String )
    }
    
    func hasAnswered(_ answerIdOne: String, answerIdTwo: String) -> Bool {
        
        
        return (UserDefaults.hasPersonalityAnswer( answerIdOne ) || UserDefaults.hasPersonalityAnswer( answerIdTwo ) )
    }
    
    func hasAnsweredQuestion(_ questionIndex: Int, answerIndex: Int) -> Bool {
        
        let question = self.personalQuestions![questionIndex]
        
        let answer = question.answers![answerIndex] as! NSDictionary
        
        return UserDefaults.hasPersonalityAnswer( answer.object(forKey: "Id") as! String )
        
    }
    
    func sendEventAtQuestionIndex(_ questionIndex: Int, answerIndex: Int) {
        
        if questionIndex < self.personalQuestions?.count {
            
            let question = self.personalQuestions![questionIndex]
            
            var otherAnswerIndex = 0
            
            if answerIndex == 0 {
                otherAnswerIndex = 1
            }
            
            question.answer( withCulture: GWLocalizedBundle.currentLocaleAPIString(), at: answerIndex, completion: {
                answer, answerId in
                
                if answer != nil && answerId != nil {
                    
                    AnalyticsManager.shared().postAction(withType: question.personalityQuestionId, targetType: kGATargetTypeApp, targetId: answerId, targetParameter: nil, actionLocation: kGAPersonalityScreen)
                    UserDefaults.addPersonalityAnswer( answerId! )
                    
                }
                
            })
            
            question.answer( withCulture: GWLocalizedBundle.currentLocaleAPIString(), at: otherAnswerIndex, completion: {
                answer, answerId in
                
                if answer != nil && answerId != nil {
                    UserDefaults.removePersonalityAnswer( answerId! )
                }
                
            })
            
        }
        
    }
    
}
