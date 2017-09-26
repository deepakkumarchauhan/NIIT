 //
//  CommunicationViewController.m
//  ParentApp
//
//  Created by Prince Kadian on 18/10/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "Header.h"
#import "ComposeMsgViewController.h"

@interface CommunicationViewController ()<UITableViewDataSource, UITableViewDelegate,backToCommunicationProtocol>
{
    NSMutableArray *messagesArray;
    Pagination *pagination;
    UILabel *noDataLabel;
    
    UIImage *teacherImage;
    UIImage *studentImage;

}

@property (weak, nonatomic) IBOutlet UITableView *communicationTableView;
@property (weak, nonatomic) IBOutlet UIButton *seeMoreButton;

@end

@implementation CommunicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"GetMessage" object:nil];

    [self customInitialization];
    
    pagination.pageNumber = 1;
    [self callAPIForGetMessageList:pagination];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)customInitialization {
    
    //Set navigation
    self.title = @"Messages";
    
    self.seeMoreButton.hidden = YES;

    if (self.fromNotification) {
        self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"back");
    }
    else
        self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"menu");

    
    self.navigationItem.rightBarButtonItem = [self rightBarButtonForController:self andImageStr:@"plus"];
    
    //Table Methods
    [self.communicationTableView registerNib:[UINib nibWithNibName:@"NotificationTVCell" bundle:nil] forCellReuseIdentifier:@"NotificationTVCell"];
    self.communicationTableView.alwaysBounceVertical = NO;
    //self.communicationTableView.editing = YES;
    self.communicationTableView.estimatedRowHeight = 99.0;
    
    //Allocations
    messagesArray = [NSMutableArray array];
    
    // Alloc Modal Class
    pagination = [[Pagination alloc]init];
    pagination.pageNumber = 1;
    

   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"callApi" object:nil];
    
    NSDictionary *studentDict =  [NSUSERDEFAULT valueForKey:@"studentInformation"];
    
    if ([[studentDict objectForKeyNotNull:@"teacherPhoto" expectedObj:@""] length]) {
        
        NSData* data = [[NSData alloc] initWithBase64EncodedString:[studentDict objectForKeyNotNull:@"teacherPhoto" expectedObj:@""] options:0];
         teacherImage = [UIImage imageWithData:data];
    }else
         teacherImage = [UIImage imageNamed:@"dummy"];
    
    
    if ([[studentDict objectForKeyNotNull:pPIStudentPicture expectedObj:@""] length]) {
        
        NSData* data = [[NSData alloc] initWithBase64EncodedString:[studentDict objectForKeyNotNull:pPIStudentPicture expectedObj:@""] options:0];
        studentImage = [UIImage imageWithData:data];
        
    }else
        studentImage = [UIImage imageNamed:@"dummy"];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
   // pagination.pageNumber = 1;
   // [self callAPIForGetMessageList:pagination];
}

#pragma mark - Selector Method

-(void)receiveMessage:(NSNotification*)notification {
    
    pagination.pageNumber = 1;
    [self callAPIForGetMessageList:pagination];
    noDataLabel.hidden = YES;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetMessage" object:nil];
}

-(void)callHeaderApi {
    
    pagination.pageNumber = 1;
    [self callAPIForGetMessageList:pagination];
}

#pragma mark: UITableview Delegates and DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [messagesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationTVCell *cell = (NotificationTVCell *)[tableView dequeueReusableCellWithIdentifier:@"NotificationTVCell"];
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = [UIColor whiteColor];
    else
        cell.backgroundColor = RGBCOLOR(238, 238, 238, 1);
    
    NSDictionary *studentDict =  [NSUSERDEFAULT valueForKey:@"studentInformation"];
    CommunicationModalInfo *communicationModal = [messagesArray objectAtIndex:indexPath.row];
    
     if ([communicationModal.createdByUserId isEqualToString:[studentDict objectForKeyNotNull:cpUserID expectedObj:@""]]) {
         cell.notificationImageView.image = studentImage;
     }
     else {
         cell.notificationImageView.image = teacherImage;
     }
    
    cell.notificationDateWidthConstraint.constant = 50;
    cell.notificationTitlelabel.text = communicationModal.subjectName;
    cell.notificationDescriptionlabel.text = communicationModal.content;
    cell.notificationDateTimelabel.text = communicationModal.entryDate;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CommunicationModalInfo *communicationModal = [messagesArray objectAtIndex:indexPath.row];

    ChatViewController *chatVCObj = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
    chatVCObj.chatModal = communicationModal;
    chatVCObj.delegate = self;
    [self.navigationController pushViewController:chatVCObj animated:YES];
}



-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"          "  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        NSInteger index = indexPath.row;
        [self callAPIToDeleteMessage:index];
        [messagesArray removeObjectAtIndex:index];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationLeft];
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageView *img1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"delete"]];
        img1.frame = CGRectMake(cell.frame.size.width + 22, cell.frame.size.height/2-10, 25, 25);
        img1.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:img1];
    });

    deleteAction.backgroundColor = LDEL_COLOR;
    
    return @[deleteAction];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma MARK: UIButton Action

-(void)leftBarButtonAction:(UIButton*)sender {
    
    if (self.fromNotification) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
        [itrSideMenu presentLeftMenuViewController];
    }
}

- (void)rightBarButtonAction:(id)sender {
    
    NSDictionary *studentDict =  [NSUSERDEFAULT valueForKey:@"studentInformation"];
    
   // Notification Navigation
    if ([[studentDict valueForKey:@"teacherName"] length]) {
        
        ComposeMsgViewController *composeVCObj = [[ComposeMsgViewController alloc]initWithNibName:@"ComposeMsgViewController" bundle:nil];
        //composeVCObj.composeModel =
        //  [messagesArray removeAllObjects];
        [self.navigationController pushViewController:composeVCObj animated:YES];
    }
    else {
        [OPRequestTimeOutView showWithMessage:@"There is no teacter associated with this child."  forTime:3.0 andController:self];

    }

}

-(UIBarButtonItem *) rightBarButtonForController : (id) controller andImageStr:(NSString *)imgStr {
    
    UIImage *buttonImage = [UIImage imageNamed:imgStr];
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    barButton.frame = CGRectMake(0, 0, 22.0f, 30.0f);
    [barButton setImage:buttonImage forState:UIControlStateNormal];
    [barButton setImage:buttonImage forState:UIControlStateSelected];
    [barButton setImage:buttonImage forState:UIControlStateHighlighted];
    
    [barButton addTarget:controller action:@selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    return barButtonItem;
}


#pragma mark - API Method

-(void)callAPIForGetMessageList:(Pagination *)page  {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [params setValue:@"10" forKey:cpPageSize];
    [params setValue:[NSString stringWithFormat:@"%ld",(long)page.pageNumber] forKey:cpPageNumber];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiMessageHeader andController:self cache:NO withprogresHud:[messagesArray count]?ISProgressNotShown:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            if (pagination.pageNumber == 1) {
                [messagesArray removeAllObjects];
                
            }
            pagination = [Pagination getPaginationInfoFromDict:[result objectForKeyNotNull:cpPagination expectedObj:[NSDictionary dictionary]]];
            
            NSArray *messageArray = [result objectForKeyNotNull:pCommunicationHeader expectedObj:[NSArray new]];
            
            for (NSMutableDictionary * messageDict in messageArray) {
                [messagesArray addObject:[CommunicationModalInfo parseMessagesInfo:messageDict]];
                
                if (pagination.pageNumber < pagination.maxPages)
                    self.seeMoreButton.hidden = NO;
                else
                    self.seeMoreButton.hidden = YES;
            }
            [self.communicationTableView reloadData];
            
            if ([messagesArray count] == 0)
                [self setLabelBetweenTable:[result objectForKey:cpResponseMessage]];
            else
                noDataLabel.hidden = YES;
            
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}


-(void)callAPIToDeleteMessage:(NSInteger)indexPath {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    CommunicationModalInfo *communicationModal = [messagesArray objectAtIndex:indexPath];

    [params setValue:communicationModal.appMessageID forKey:pAppMessageId];

    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiToDeleteMessage andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:1.0 andController:self];
            
            if ( pagination.totalRecords == 0)
                self.seeMoreButton.hidden = NO;
            else
                self.seeMoreButton.hidden = YES;
            
            if ([messagesArray count] == 0)
                [self setLabelBetweenTable:@"No data available."];
            else
                noDataLabel.hidden = YES;
            
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}

#pragma mark - UIButton Action

- (IBAction)seeMoreButtonAction:(id)sender {
    

        if (pagination.pageNumber  < pagination.maxPages) {
            
            pagination.pageNumber += 1;
            [self callAPIForGetMessageList:pagination];
        }
}

#pragma mark - Show Message On Data Blank

-(void)setLabelBetweenTable:(NSString *)displayMessage {
    
    noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.communicationTableView.bounds.size.width,  self.communicationTableView.bounds.size.height)];
    noDataLabel.text             = displayMessage;
    noDataLabel.textColor        = [UIColor darkGrayColor];
    noDataLabel.textAlignment    = NSTextAlignmentCenter;
    self.communicationTableView.backgroundView = noDataLabel;
}


@end
