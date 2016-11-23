//
//  MAXSelectedContentButton.h
//  WhatsAppMessageComposer
//
//  Created by Mathieu Skulason on 12/04/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "MAXFadeBlockButton.h"

@interface MAXSelectedContentButton : MAXFadeBlockButton

/**
 @description The time it takes for the selected content to fade in when you switch the buttons selected state to YES/true. Defaults to 0.2 seconds.
 */
@property (nonatomic) float contentFadeInTime;

/**
 @description The time it takes for the selected content to fade out when you switch the buttons selected state to NO/false. Defaults to 0.2 seconds.
 */
@property (nonatomic) float contentFadeOutTime;


/**
 @description Adds the specified uiview to the button but only shows them when the state of the button is changed to selected.
 */
-(void)addSelectedContent:(UIView *)theSelectedContent;

/**
 @description Remove the specified uiview from the button.
 */
-(void)removeSelectedContent:(UIView *)theSelectedContent;

@end
