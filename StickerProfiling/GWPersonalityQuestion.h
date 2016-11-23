//
//  GWPersonalityQuestion.h
//  
//
//  Created by Mathieu Grettir Skulason on 11/23/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MNFJsonAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface GWPersonalityQuestion : NSManagedObject <MNFJsonAdapterDelegate>

// Insert code here to declare functionality of your managed object subclass
// Insert code here to declare functionality of your managed object subclass
+(GWPersonalityQuestion *)createGWPersonalityQuestionOnMainThread;
+(GWPersonalityQuestion *)createGWPersonalityQuestion;

-(void)updateWithJsonDict:(NSDictionary *)theJsonDict;

-(nullable NSString *)questionWithCulture:(NSString *)theCulture;

-(NSUInteger)numAnswers;
-(nullable NSString *)answerWithCulture:(NSString *)theCulture atIndex:(NSInteger)index completion:(nullable void (^)(NSString * _Nullable answer, NSString * _Nullable answerId))completion;


@end

NS_ASSUME_NONNULL_END

#import "GWPersonalityQuestion+CoreDataProperties.h"
