//
//  ComposeMsgViewController.m
//  ParentApp
//
//  Created by Deepak Chauhan on 01/12/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "ComposeMsgViewController.h"
#import "Header.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface ComposeMsgViewController ()<UITextViewDelegate> {
    
    CommunicationModalInfo *communicationInfo;
    NSMutableArray *typeArray;
    NSMutableArray *subjectTypeArray;
}

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet CATextField *toTextField;

@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *toErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectErrorLabel;


@end

@implementation ComposeMsgViewController

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Method

-(void)initialSetup {
    
    // Set Title
    self.title = @"Compose Message";
    
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");
    
    // Set TextFields Border and Corner Radius
    
    self.toTextField.layer.borderWidth = 1.0;
    self.toTextField.layer.borderColor = [[UIColor colorWithRed:220.0/255.0 green:218.0/255.0 blue:219.0/255.0 alpha:1.0] CGColor];
    self.toTextField.userInteractionEnabled = NO;
    
    self.textView.layer.cornerRadius = 2.0;
    self.textView.layer.borderWidth = 1.0;
    
    self.typeButton.layer.cornerRadius = 2.0;
    self.typeButton.layer.borderWidth = 1.0;
    self.sendButton.layer.cornerRadius = 5.0;

    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.bounces = NO;
    
    self.typeButton.contentEdgeInsets = UIEdgeInsetsMake(5.0f, 4.0f, 5.0f, 30.0f);
    
    // Alloc Array
    
    typeArray = [NSMutableArray array];
    subjectTypeArray = [NSMutableArray array];
    
    // Set Text on Type Button
    [self.typeButton setTitle:@"Type" forState:UIControlStateNormal];
    [self.typeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    // Set Teacher Name
    
    NSDictionary *studentDict =  [NSUSERDEFAULT valueForKey:@"studentInformation"];
    self.toTextField.text = [studentDict valueForKey:@"teacherName"];
    
    // Alloc Modal Class
    communicationInfo = [[CommunicationModalInfo alloc]init];
    //[self callAPIToGetType];

}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    self.textView.text = @"";
    [self.typeButton setTitle:@"Type" forState:UIControlStateNormal];
    self.toErrorLabel.hidden = YES;
    self.typeErrorLabel.hidden = YES;
    self.subjectErrorLabel.hidden = YES;
}

#pragma mark - Selector Method

-(void)leftBarButtonAction:(UIButton*)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    self.subjectErrorLabel.hidden = YES;
    
    self.textView.layer.borderColor = [[UIColor colorWithRed:219.0/255.0 green:218.0/255.0 blue:220.0/255.0 alpha:1.0] CGColor];
    self.textView.layer.cornerRadius = 2.0;
    self.textView.layer.borderWidth = 1.0;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if([self.textView.text isEqualToString:@""])
        self.placeholderLabel.hidden = NO;
    else
        self.placeholderLabel.hidden = YES;
    
    communicationInfo.subject = textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage])
    {
        return NO;
    }
    NSString *str = [self.textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if (str.length == 201)
        return NO;
    
    if (!str.length)
        self.placeholderLabel.hidden = NO;
    else
        self.placeholderLabel.hidden = YES;

    return YES;
}

#pragma mark - Touch Method

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark - UIButton Action

- (IBAction)typeButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    
    self.typeErrorLabel.hidden = YES;
    self.typeButton.layer.cornerRadius = 2.0;
    self.typeButton.layer.borderWidth = 1.0;
    self.typeButton.layer.borderColor = [[UIColor colorWithRed:219.0/255.0 green:218.0/255.0 blue:220.0/255.0 alpha:1.0] CGColor];

    if ([subjectTypeArray count]) {
        [[OptionsPickerSheetView sharedPicker] showPickerSheetWithOptions:subjectTypeArray andselectedIndex:(([TRIMSPACE(self.typeButton.titleLabel.text) isEqualToString:@"Type"]))?0:[subjectTypeArray indexOfObject:self.typeButton.titleLabel.text] AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex) {
            
            communicationInfo  = [typeArray objectAtIndex:selectedIndex];
            communicationInfo.subjectTypeId = communicationInfo.typeId;
            communicationInfo.type = selectedText;
            communicationInfo.subject = self.textView.text;
            [self.typeButton setTitle:selectedText forState:UIControlStateNormal];
            [self.typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }];
    }
    else {
        [self callAPIToGetType];
    }
}

- (IBAction)sendButtonAction:(id)sender {
    [self.view endEditing:YES];
    
//    if (!self.toTextField.text.length) {
//        self.toErrorLabel.text = @"No teacher name.";
//        self.toErrorLabel.hidden = NO;
//        self.toTextField.layer.borderColor =  AppRedColor.CGColor;
//    }
  // else
       if (!communicationInfo.type.length) {
        self.typeErrorLabel.text = @"Please select type.";
        self.typeErrorLabel.hidden = NO;
        self.typeButton.layer.borderColor =  AppRedColor.CGColor;
    }
    else if (!self.textView.text.length) {
        self.subjectErrorLabel.text = @"Please enter subject.";
        self.subjectErrorLabel.hidden = NO;
        self.textView.layer.borderColor =  AppRedColor.CGColor;
    }
    else
    [self callAPIForSaveSubject];
}


#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForSaveSubject {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSDictionary *studentDict =  [NSUSERDEFAULT valueForKey:@"studentInformation"];
    
    communicationInfo.createdForUserId = [studentDict valueForKey:@"teacherId"];
    communicationInfo.appMessageID = @"1";
    
    [params setValue:[studentDict valueForKey:@"teacherId"] forKey:pCreatedForUserId];
    [params setValue: communicationInfo.subjectTypeId forKey:pMessageTypeId];
    [params setValue:self.textView.text forKey:pSubjectName];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiForMessageSubject andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
           [[NSNotificationCenter defaultCenter] postNotificationName:@"callApi" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}


-(void)callAPIToGetType {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiForToGetType andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            NSArray *typeArr = [result objectForKeyNotNull:@"listCommunicationMsgType" expectedObj:[NSArray array]];
            
            for (NSDictionary *dict in typeArr) {
                [typeArray addObject:[CommunicationModalInfo parseComposeType:dict]];
                [subjectTypeArray addObject:[dict objectForKeyNotNull:@"messageTypeName" expectedObj:@""]];
            }
            
            if ([subjectTypeArray count]) {
                [[OptionsPickerSheetView sharedPicker] showPickerSheetWithOptions:subjectTypeArray andselectedIndex:(([TRIMSPACE(self.typeButton.titleLabel.text) isEqualToString:@"Type"]))?0:[subjectTypeArray indexOfObject:self.typeButton.titleLabel.text] AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex) {
                    
                    communicationInfo  = [typeArray objectAtIndex:selectedIndex];
                    communicationInfo.subjectTypeId = communicationInfo.typeId;
                    communicationInfo.type = selectedText;
                    [self.typeButton setTitle:selectedText forState:UIControlStateNormal];
                    [self.typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }];
            }else {
                [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
            }

            //NSLog(@"%lu",(long)[TRIMSPACE(self.typeButton.titleLabel.text) length]);
            
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}



@end
