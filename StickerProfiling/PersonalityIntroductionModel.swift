//
//  PersonalityIntroductionModel.swift
//  StickerBliss
//
//  Created by Mathieu Skulason on 04/10/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit

class PersonalityIntroductionModel: NSObject {
    
    var personalQuestions: [GWPersonalityQuestion]?
    var personalQuestionIds : [String]?
    let questionType: PersonalityViewControllerType
    
    init(type: PersonalityViewControllerType) {
        
        self.questionType = type
        
        super.init()
        
    }
    
    func downloadPersonalQuestions(completion: (NSError?) -> Void ) {
        
        if self.questionType == PersonalityViewControllerType.Intro {
            
            ServerCommunication.downloadPersonalityQuestionsToAskWithPath(nil, completion: {
                questionIds, error in
                
                self.personalQuestionIds = questionIds
                
                GWDataManager().downloadPersonalityQuestionsWithPath(nil, completion: {
                    questions, error in
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.personalQuestions = GWDataManager().fetchPersonalityQuestionsWithIds( self.personalQuestionIds )
                        print("personal questions \(self.personalQuestions)")
                        self.orderQuestionsById( questionIds )
                        completion(error)
                        
                    })
                    
                })
                
                
            })
            
        }
        else {
            
            GWDataManager().downloadPersonalityQuestionsWithPath(nil, completion: {
                questions, error in
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if error == nil && questions != nil {
                        
                        var personalityQuestionsOrder = [String]()
                        for currentQuestion in questions! {
                            personalityQuestionsOrder.append(currentQuestion.personalityQuestionId!)
                        }
                        
                        self.personalQuestions = GWDataManager().fetchPersonalityQuestionsWithIds( nil )
                        self.orderQuestionsById( personalityQuestionsOrder )
                        completion( nil )
                        
                        
                    }
                    else {
                        // error occurred
                        completion( error )
                    }
                    
                })
                
            })
            
        }
        
    }
    
    func orderQuestionsById(ids: [String]?) {
        
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
            
            if self.questionType == PersonalityViewControllerType.Settings {
                
                return self.personalQuestions!.count + 1
            }
            
            return self.personalQuestions!.count
        }
        
        return 0
    }
    
    func question(at index: Int) -> String? {
        
        if index < self.personalQuestions?.count {
            
            let question = self.personalQuestions![index];
            
            return question.questionWithCulture( GWLocalizedBundle.currentLocaleAPIString() )
            
        }
        
        return nil
    }
    
    func answer(at index: Int,at questionIndex: Int) -> String? {
        
        if index < self.personalQuestions?.count {
            
            let question = self.personalQuestions![index]
            
            return question.answerWithCulture( GWLocalizedBundle.currentLocaleAPIString(), atIndex: questionIndex, completion: nil)
            
        }
        
        return nil
        
    }
    
    func image(at index: Int, completion: (UIImage?, NSError?) -> Void) {
        
        if index < self.personalQuestions?.count {
        
            let question = self.personalQuestions![index]
            
            if let nonNilImagePath = question.defaultImage {
                
                GWImageManager.downloadImageIfNotExistsWithPath(nonNilImagePath, imageDataCompletion: {
                    imageId, imageData, error in
                    
                    if let nonNilImageData = imageData {
                        completion(UIImage(data:  nonNilImageData), nil)
                    }
                    else {
                        completion(nil, error)
                    }
                    
                })
                
            }
            
        }
        
    }
    
    func hasAnsweredQuestion(at index: Int) -> Bool {
        
        let question = self.personalQuestions![index]
        
        let answerOne = question.answers![0] as! NSDictionary
        let answerTwo = question.answers![1] as! NSDictionary
        
        return self.hasAnswered( answerOne.objectForKey( "Id" ) as! String, answerIdTwo: answerTwo.objectForKey( "Id" ) as! String )
    }
    
    func hasAnswered(answerIdOne: String, answerIdTwo: String) -> Bool {
        
        
        return (UserDefaults.hasPersonalityAnswer( answerIdOne ) || UserDefaults.hasPersonalityAnswer( answerIdTwo ) )
    }
    
    func hasAnsweredQuestion(questionIndex: Int, answerIndex: Int) -> Bool {
        
        let question = self.personalQuestions![questionIndex]
        
        let answer = question.answers![answerIndex] as! NSDictionary
        
        return UserDefaults.hasPersonalityAnswer( answer.objectForKey("Id") as! String )
        
    }
    
    func sendEventAtQuestionIndex(questionIndex: Int, answerIndex: Int) {
        
        if questionIndex < self.personalQuestions?.count {
            
            let question = self.personalQuestions![questionIndex]
            
            var otherAnswerIndex = 0
            
            if answerIndex == 0 {
                otherAnswerIndex = 1
            }
            
            question.answerWithCulture( GWLocalizedBundle.currentLocaleAPIString(), atIndex: answerIndex, completion: {
                answer, answerId in
                
                if answer != nil && answerId != nil {
                    CustomAnalytics().postActionWithType(question.personalityQuestionId, actionLocation: "Intro", targetType: nil, targetId: answerId, targetParameter: nil)
                    UserDefaults.addPersonalityAnswer( answerId! )
                    
                }
                
            })
            
            question.answerWithCulture( GWLocalizedBundle.currentLocaleAPIString(), atIndex: otherAnswerIndex, completion: {
                answer, answerId in
                
                if answer != nil && answerId != nil {
                    UserDefaults.removePersonalityAnswer( answerId! )
                }
                
            })
            
        }
        
    }
    
}
