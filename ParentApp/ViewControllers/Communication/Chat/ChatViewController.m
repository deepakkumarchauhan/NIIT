//
//  ChatViewController.m
//  ParentApp
//
//  Created by Prince Kadian on 19/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "Header.h"

static NSString *SenderCellIdentifier = @"SenderTVCell";
static NSString *ReceiverCellIdentifier = @"ReciverTVCell";
static NSString *SenderImageCellIdentifier = @"MTSenderImageCell";
static NSString *ReceiverImageCellIdentifier = @"MTRecieverImageCell";

@interface ChatViewController () {
    NSMutableArray *chatHistoryArray;
    Pagination *chatPagination;
    NSInteger arrayCount;
    NSString *chatText;
}

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet UITextView *replyTextview;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonConstraint;
@property (strong, nonatomic) IBOutlet UIRefreshControl *refreshControl;


@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"GetMessage" object:nil];
    self.chatTableView.estimatedRowHeight = 80.0;
    
    [self customInitialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Selector Method

-(void)receiveMessage:(NSNotification*)notification {
    
    [self callAPIForGetChatList:chatPagination];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetMessage" object:nil];
}


-(void)viewWillAppear:(BOOL)animated {
    //Notification For Keyboard Up and Down
    
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


-(void)customInitialization {
    
    // Set Teacher Name
    NSDictionary *studentDict =  [NSUSERDEFAULT valueForKey:@"studentInformation"];
    if ([[studentDict valueForKey:@"teacherName"] length]) {
        self.title = [studentDict valueForKey:@"teacherName"];
    }else
        self.title = @"Unknown";

    //Set navigation
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");
    self.navigationItem.rightBarButtonItem = rightBarButtonForController(self, @"refreshIcon");

    chatHistoryArray = [NSMutableArray new];
    
    _chatTableView.estimatedRowHeight = 68.0;
    _chatTableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.chatTableView registerNib:[UINib nibWithNibName:SenderCellIdentifier bundle:nil] forCellReuseIdentifier:SenderCellIdentifier];
    [self.chatTableView registerNib:[UINib nibWithNibName:ReceiverCellIdentifier bundle:nil] forCellReuseIdentifier:ReceiverCellIdentifier];
    
    [self.sendButton setEnabled:NO];
    [self.sendButton setAlpha:0.5];
    
    self.placeHolderLabel.text = @"Write Text..";
    self.placeHolderLabel.hidden = NO;
    
    // Alloc Modal Class
    chatPagination = [[Pagination alloc]init];
    chatPagination.pageNumber = 1;
    
    // Refresh Control
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.chatTableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    [self callAPIForGetChatList:chatPagination];
}

#pragma mark - Notification Methods

- (void)keyboardWillShow:(NSNotification *)note {
    
    CGSize kbSize = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:[[[note userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.buttonConstraint.constant = kbSize.height;
        [self.view layoutSubviews];
        
    } completion:^(BOOL finished) {
        if ([chatHistoryArray count]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[chatHistoryArray count]-1 inSection:0];
            [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)note {
    
    [UIView animateWithDuration:[[[note userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.buttonConstraint.constant = 0;
        [self.view layoutSubviews];
    } completion:^(BOOL finished) {
        if ([chatHistoryArray count]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[chatHistoryArray count]-1 inSection:0];
            [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - Selector Method

- (void)refreshTable {
    
    if (chatPagination.pageNumber  < chatPagination.maxPages) {
        
        chatPagination.pageNumber += 1;
        [self callAPIForGetChatList:chatPagination];
    }
    [self.refreshControl endRefreshing];
}


#pragma mark - UITextView delegates

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeHolderLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    self.placeHolderLabel.hidden = NO;
    chatText = TRIMSPACE(textView.text);
}


#pragma mark TextView Delegate Method

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    
    if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage])
    {
        return NO;
    }
    
    chatText = TRIMSPACE([textView.text stringByReplacingCharactersInRange:range withString:text]);

    
    if ([chatText length ]> 1000)
        return NO;
    
    self.placeHolderLabel.hidden = YES;
    
    if ([TRIMSPACE(chatText) length]) {
        [self.sendButton setEnabled:YES];
        [self.sendButton setAlpha:1.0];
        
    }else {
        [self.sendButton setEnabled:NO];
        [self.sendButton setAlpha:0.5];
    }
    
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}
#pragma mark - UITableView Datasource Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [chatHistoryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommunicationModalInfo *obj = [chatHistoryArray objectAtIndex:indexPath.row];
    NSDictionary *studentDict =  [NSUSERDEFAULT valueForKey:@"studentInformation"];
    
    if ([obj.createdByUserId isEqualToString:[studentDict objectForKeyNotNull:cpUserID expectedObj:@""]]) {
        
        SenderTVCell *senderCell = (SenderTVCell *)[tableView dequeueReusableCellWithIdentifier:SenderCellIdentifier];
        senderCell.senderTimeLabel.text = obj.createdDate;
        [senderCell.senderTextLabel setText:obj.content];
        
        return senderCell;
        
    }else{
        ReciverTVCell *receiverCell = (ReciverTVCell *)[tableView dequeueReusableCellWithIdentifier:ReceiverCellIdentifier];
        receiverCell.reciverTimeLabel.text = obj.createdDate;
        [receiverCell.reciverTextLabel setText:obj.content];
        
        return receiverCell;
    }
}


#pragma mark: UIButton Actions

- (IBAction)sendButtonAction:(id)sender {
    
    [self.sendButton setEnabled:NO];
    [self.sendButton setAlpha:0.5];
    [self callAPIForSaveChat];
}

- (void)leftBarButtonAction:(id)sender {
    
    if (arrayCount == [chatHistoryArray count]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self.delegate callHeaderApi];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightBarButtonAction:(id)sender {
    chatPagination.pageNumber = 1;
    [self callAPIForGetChatList:chatPagination];
}

#pragma mark - API Method

-(void)callAPIForGetChatList:(Pagination *)page  {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSDictionary *studentDict =  [NSUSERDEFAULT valueForKey:@"studentInformation"];

    [params setValue:[studentDict valueForKey:@"teacherId"] forKey:pCreatedForUserId];

//      [params setValue:_chatModal.createdForUserId forKey:pCreatedForUserId];
     [params setValue:_chatModal.appMessageID forKey:pAppMessageId];
    
    [params setValue:@"20" forKey:cpPageSize];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)page.pageNumber] forKey:cpPageNumber];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiGetMessageDetail andController:self cache:NO withprogresHud:(chatHistoryArray.count)?ISProgressNotShown:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            if (chatPagination.pageNumber == 1) {
                [chatHistoryArray removeAllObjects];
            }
            
            chatPagination = [Pagination getPaginationInfoFromDict:[result objectForKeyNotNull:cpPagination expectedObj:[NSDictionary dictionary]]];
            
            NSArray *messageArray = [result objectForKeyNotNull:pMessageDetail expectedObj:[NSArray new]];
            NSMutableArray *arr = [NSMutableArray array];
            for (NSMutableDictionary * messageDict in messageArray) {
                
                [arr addObject:[CommunicationModalInfo parseMessagesInfo:messageDict]];
            }
            if ([arr count])
                chatHistoryArray = [[arr arrayByAddingObjectsFromArray:chatHistoryArray] mutableCopy];
            
            arrayCount = [arr count];
            
            if ([chatHistoryArray count]) {
                [self.chatTableView reloadData];

                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[chatHistoryArray count]-1 inSection:0];
                [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
        
        [self.refreshControl endRefreshing];
    }];
}


-(void)callAPIForSaveChat {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSDictionary *studentDict =  [NSUSERDEFAULT valueForKey:@"studentInformation"];

    [params setValue:[studentDict valueForKey:@"teacherId"] forKey:pCreatedForUserId];

//    [params setValue:_chatModal.createdForUserId forKey:pCreatedForUserId];
    [params setValue:_chatModal.appMessageID forKey:pAppMessageId];
    
    //[params setValue:[TRIMSPACE(chatText) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]] forKey:pContent];
    
    [params setValue:chatText forKey:pContent];

    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiSaveMsgDetail andController:self cache:NO withprogresHud:ISProgressNotShown WithComptionBlock:^(id result, NSError *error) {
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            CommunicationModalInfo *modalObj = [CommunicationModalInfo new];
            NSDictionary *studentDict =  [NSUSERDEFAULT valueForKey:@"studentInformation"];

            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd MMM yyyy h:mma"];
            
            modalObj.createdDate = [dateFormatter stringFromDate:[NSDate date]];
            modalObj.content = chatText;
            modalObj.createdByUserId = [studentDict objectForKeyNotNull:cpUserID expectedObj:@""];

            [chatHistoryArray addObject:modalObj];
            
//            [self.sendButton setEnabled:NO];
//            [self.sendButton setAlpha:0.5];
            [self.replyTextview setText:[NSString string]];
            self.placeHolderLabel.hidden = NO;
            
            if ([chatHistoryArray count]) {
                [self.chatTableView reloadData];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[chatHistoryArray count]-1 inSection:0];
                [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }

        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}


@end
