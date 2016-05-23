//
//  CustomDropDown.m
//  NIDropDown
//
//  Created by 許佳豪 on 2016/4/24.
//
//

#import "CustomDropDown.h"
@interface CustomDropDown ()

@property(nonatomic, strong) UITableView *dropDowntableView;
@property(nonatomic, strong) UIButton *currentButton;
@property(nonatomic, strong) NSArray *listData;
@property(nonatomic, assign) AnimationDirection animationDirection;
@property(nonatomic, strong) NSString *buttonTitle;
@property(nonatomic, assign) NSInteger tableViewHeight;
@property (nonatomic,copy)SelectCompleteBlock selectCompleteBlock;
@property(nonatomic,assign)CGRect newFrame;

@end

@implementation CustomDropDown

-(id)initShowCustomDropDownWithButton:(UIButton *)button tableViewDataSource:(NSArray *)listData direction:(AnimationDirection)direction newFrame:(CGRect)newFrame selectCompleteBlock:(SelectCompleteBlock)selectCompleteBlock{
    self = [super init];
    self.currentButton = button;
    self.buttonTitle = self.currentButton.titleLabel.text;
    self.animationDirection = direction;
    self.listData = [NSArray arrayWithArray:listData];
    self.tableViewHeight = [self getTebleViewHeight];
    self.selectCompleteBlock = selectCompleteBlock;
    self.newFrame = newFrame;
    if (self) {
        [self setupView];
        [self setupDropDowntableViewRect:newFrame];
        [self setupTapGestureRecognizer];
        [self showDropDown];
        [self addSubview:self.dropDowntableView];
    }
    return self;
}

#pragma mark - private method

-(void)setupView{
    self.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    self.layer.masksToBounds = NO;
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
}

-(void)setupDropDowntableViewRect:(CGRect)newRect{
    self.dropDowntableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(newRect), CGRectGetMaxY(newRect), self.currentButton.frame.size.width, 0)];
    self.dropDowntableView.delegate = self;
    self.dropDowntableView.dataSource = self;
    self.dropDowntableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dropDowntableView.backgroundColor = [UIColor clearColor];
    
}
-(void)setupTapGestureRecognizer{
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCustomDropDown)];
    singleTapGestureRecognizer.cancelsTouchesInView=NO;
    singleTapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:singleTapGestureRecognizer];
}

-(void)showDropDown{
    [UIView animateWithDuration:0.2 animations:^{
        if (self.animationDirection == AnimationDirectionUp) {
            self.dropDowntableView.frame = CGRectMake(self.newFrame.origin.x, self.newFrame.origin.y-self.tableViewHeight, self.newFrame.size.width, self.tableViewHeight);
        } else if (self.animationDirection == AnimationDirectionDown)  {
            self.dropDowntableView.frame = CGRectMake(self.newFrame.origin.x, self.newFrame.origin.y+self.newFrame.size.height, self.newFrame.size.width, self.tableViewHeight);
        }
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideCustomDropDown{
    CGRect btn = self.newFrame;
    [UIView animateWithDuration:0.2 animations:^{
        if (self.animationDirection == AnimationDirectionUp) {
            self.dropDowntableView.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
        }else if (self.animationDirection == AnimationDirectionDown) {
            self.dropDowntableView.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
        }
    } completion:^(BOOL finished) {
        if (![self.currentButton.titleLabel isEqual:self.buttonTitle]) {
            //[self.delegate didSelectRowWithButton:self.currentButton selectTitleText:self.buttonTitle];
            
        }
        [self removeFromSuperview];
    }];
    
}

-(NSInteger)getTebleViewHeight{
    if (self.listData.count > 8) {
        return 200;
    }
    return self.listData.count*25;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.dropDowntableView]) {
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 25;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];

    cell.textLabel.text = [self.listData objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    
    UIView *v = [[UIView alloc] init];
    cell.selectedBackgroundView = v;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.buttonTitle = cell.textLabel.text;
    [self hideCustomDropDown];
    self.selectCompleteBlock(indexPath.row);
}

@end
