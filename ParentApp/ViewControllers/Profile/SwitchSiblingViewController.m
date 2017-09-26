//
//  SwitchSiblingViewController.m
//  ParentApp
//
//  Created by Prince Kadian on 09/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//

#import "SwitchSiblingViewController.h"
#import "SwitchSiblingInfo.h"
#import "PAUtility.h"

@interface SwitchSiblingViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    NSMutableArray        *siblingsArray;
}

@property (weak, nonatomic) IBOutlet UICollectionView *siblingsCollectionView;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewLeftConstraint;

@end

@implementation SwitchSiblingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customInitialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    if (IS_IPHONE_5) {
        [self.collectionViewLeftConstraint setConstant:20];
        [self.collectionViewRightConstraint setConstant:20];
    }else{
        [self.collectionViewLeftConstraint setConstant:45];
        [self.collectionViewRightConstraint setConstant:45];
    }
}

#pragma MARK: Helper Methods

-(void)customInitialization {

    //Navigation Bar
    self.title = @"Siblings";
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"menu");

    //Register collection cell
    [self.siblingsCollectionView registerNib:[UINib nibWithNibName:@"SwitchSiblingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SwitchSiblingCollectionViewCell"];
    self.siblingsCollectionView.alwaysBounceVertical = NO;
    
    siblingsArray = [NSMutableArray array];
    
    //Call For API
    [self callAPIForSwitchSibling];
}

#pragma mark: UICollectionView Delegate and Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [siblingsArray count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SwitchSiblingCollectionViewCell* cell = [self.siblingsCollectionView  dequeueReusableCellWithReuseIdentifier:@"SwitchSiblingCollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor=[UIColor whiteColor];

    SwitchSiblingInfo *siblingObj = [siblingsArray objectAtIndex:indexPath.item];
    
    cell.nameLabel.text = siblingObj.studentName;
    cell.studentImageView.image = [UIImage imageWithData:siblingObj.studentPictureData];
    
    if ([siblingObj.studentPictureData length]) {
        cell.studentImageView.image = [UIImage imageWithData:siblingObj.studentPictureData];
    }else
        cell.studentImageView.image = [UIImage imageNamed:@"dummy"];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    SwitchSiblingInfo *siblingObj = [siblingsArray objectAtIndex:indexPath.item];

    NSDictionary *studentDict = [[NSUSERDEFAULT valueForKey:@"studentInformation"] mutableCopy];
    
    [studentDict setValue:siblingObj.studentID forKey:cpStudentID];
    [studentDict setValue:siblingObj.studentName forKey:pPIStudentName];
    [studentDict setValue:siblingObj.studentPicture forKey:pPIStudentPicture];
    
    [studentDict setValue:siblingObj.teacherName forKey:@"teacherName"];
    [studentDict setValue:siblingObj.teacherID forKey:@"teacherId"];
    [studentDict setValue:siblingObj.teacherPhoto forKey:@"teacherPhoto"];
    
    [NSUSERDEFAULT setValue:studentDict forKey:@"studentInformation"];
    [NSUSERDEFAULT synchronize];
    
    for (UIViewController *viewController  in [APPDELEGATE navController].viewControllers) {
        if ([viewController isKindOfClass:[PALoginViewController class]]) {
            [APPDELEGATE navController].hidesBarsWhenKeyboardAppears = YES;
            [[APPDELEGATE navController] popToViewController:viewController animated:NO];
        }
    }
}


#pragma mark:UIButton Actions

-(void)leftBarButtonAction:(UIButton*)sender{
    
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
}

#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForSwitchSibling {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiSwitchSibling andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            
            //For Presenting data instantly
            self.logoImageView.hidden = NO;
            self.siblingsCollectionView.delegate = self;
            self.siblingsCollectionView.dataSource = self;
            
            NSArray *siblingArray = [result objectForKeyNotNull:pSwitchSiblingList expectedObj:[NSArray array]];
            
            for (NSDictionary *siblingDict in siblingArray)
                [siblingsArray addObject:[SwitchSiblingInfo parseSiblingInfo:siblingDict]];

            [self.siblingsCollectionView reloadData];
            
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}

@end
