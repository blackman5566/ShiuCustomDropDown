//
//  CustomDropDown.h
//  NIDropDown
//
//  Created by 許佳豪 on 2016/4/24.
//
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    AnimationDirectionUp,
    AnimationDirectionDown
} AnimationDirection;

typedef void(^SelectCompleteBlock)(NSInteger selectIndex);

@protocol CustomDropDownDelegate;

@interface CustomDropDown : UIView<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, weak) id <CustomDropDownDelegate> delegate;

-(void)hideCustomDropDown;
-(id)initShowCustomDropDownWithButton:(UIButton *)button tableViewDataSource:(NSArray *)listData direction:(AnimationDirection)direction newFrame:(CGRect)newFrame selectCompleteBlock:(SelectCompleteBlock)selectCompleteBlock;

@end

@protocol CustomDropDownDelegate
- (void)didSelectRowWithButton:(UIButton *)button selectTitleText:(NSString*)titleText;
@end