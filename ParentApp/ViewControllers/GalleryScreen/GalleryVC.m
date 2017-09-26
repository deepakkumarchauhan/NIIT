//
//  GalleryVC.m
//  ParentApp
//
//  Created by PRIYANKA JAISWAL on 05/09/16.
//  Copyright © 2016 Yogesh Pal. All rights reserved.
//


#import "GalleryVC.h"
#import "MWPhotoBrowser.h"
#import "PAUtility.h"

static NSString *cellIdentifier = @"GalleryTVCell";

@interface GalleryVC ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource,MWPhotoBrowserDelegate,UITabBarControllerDelegate>
{
    NSMutableArray   *_photos;
    NSMutableArray   *sectionInfo;
}

@property (strong, nonatomic) IBOutlet UITableView *galleryTableView;

@end

@implementation GalleryVC

#pragma mark - View life Cycle Methods.

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initialSetUp];
}

#pragma mark - Helper Methods.

-(void)initialSetUp {
    
    //UINavigation
    self.title = @"Gallery";
    self.navigationItem.leftBarButtonItem = leftBarButtonForController(self, @"menu");

    //UITableView
    [self.galleryTableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.galleryTableView.alwaysBounceVertical = NO;
    
    sectionInfo = [NSMutableArray array];
    _photos = [NSMutableArray array];
    
    //Call API for Gallery List
    [self callAPIForStudentPhotoGallary];
}

#pragma mark - Back Button Action

-(void)leftBarButtonAction:(UIButton *)sender {
    
    //show left menu with animation
    ITRAirSideMenu *itrSideMenu = ((AppDelegate *)[UIApplication sharedApplication].delegate).itrAirSideMenu;
    [itrSideMenu presentLeftMenuViewController];
}

#pragma mark - UITableView DataSource & Delegate Methods.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sectionInfo count];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *viewHdr = [[UIView alloc] initWithFrame:CGRectMake(10, 10, WINWIDTH, 40)];
    [viewHdr setBackgroundColor:RGBCOLOR(147, 171, 254, 1)];
    
    UILabel *lblSection = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WINWIDTH, 40)];
    [lblSection setBackgroundColor:[UIColor clearColor]];
    lblSection.textColor = [UIColor whiteColor];
    
    PhotoGalleryModal *photoGallery = [sectionInfo objectAtIndex:section];
    lblSection.text = photoGallery.sectionDescription;
    lblSection.textAlignment = NSTextAlignmentNatural;
    
    [viewHdr addSubview:lblSection];
    
    return viewHdr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GalleryTVCell *cell = (GalleryTVCell *)[_galleryTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    [cell.galleryTVCellCollectionView registerNib:[UINib nibWithNibName:@"GalleryCVCell" bundle:nil]  forCellWithReuseIdentifier:@"GalleryCVCell"];
    cell.galleryTVCellCollectionView.tag = indexPath.section;
    cell.galleryTVCellCollectionView.alwaysBounceHorizontal = NO;
    cell.galleryTVCellCollectionView.delegate = self;
    cell.galleryTVCellCollectionView.dataSource = self;
    
    [cell.galleryTVCellCollectionView reloadData];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 126;
}

#pragma mark - UICollectionView Datasource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    PhotoGalleryModal *photoGallery = [sectionInfo objectAtIndex:collectionView.tag];
    return photoGallery.photoListArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GalleryCVCell *galleryCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GalleryCVCell" forIndexPath:indexPath];
    
    PhotoGalleryModal *photoGallery = [sectionInfo objectAtIndex:collectionView.tag];
    
    if (photoGallery.photoListArray.count >= indexPath.row) {
        
        PhotoModal *photo = [photoGallery.photoListArray objectAtIndex:indexPath.row];
        galleryCell.galleryCVImageView.image = [UIImage imageWithData:photo.photoData];
    }
    
    return galleryCell;
}

#pragma mark - UICollectionView Delegate Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
   return CGSizeMake((self.view.frame.size.width/3)-12,110);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

   PhotoGalleryModal *photoGallery = [sectionInfo objectAtIndex:collectionView.tag];
    
    [_photos removeAllObjects];
    
    for (PhotoModal *photo in photoGallery.photoListArray) {
        if ([photo.photoURL length])
          [_photos addObject:[MWPhoto photoWithImage:[UIImage imageWithData:photo.photoData]]];
        else
            [_photos addObject:[MWPhoto photoWithImage:[UIImage imageNamed:@"placeholder"]]];
    }
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = NO;
    [browser setCurrentPhotoIndex:0];
    
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - * * * * NETWORKING HELPER METHODS * * * *

-(void)callAPIForStudentPhotoGallary {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [[ServiceHelper sharedServiceHelper] PostAPICallWithParameter:params apiName:apiStudentPhotoGallery andController:self cache:NO withprogresHud:ISProgressShown WithComptionBlock:^(id result, NSError *error) {
        
        if ([[result valueForKey:cpResponseCode] integerValue] == 200) {
            NSArray *photoGalleryArray = [result valueForKey:pPhotoGalleryList];
            
            for (NSDictionary *photoGalleryDict in photoGalleryArray)
                [sectionInfo addObject:[PhotoGalleryModal parsePhotoGalleryInfo:photoGalleryDict]];
            
            if ([sectionInfo count] == 0) {
                UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.galleryTableView.bounds.size.width,  self.galleryTableView.bounds.size.height)];
                noDataLabel.text             = [result objectForKey:cpResponseMessage];
                noDataLabel.textColor        = [UIColor darkGrayColor];
                noDataLabel.textAlignment    = NSTextAlignmentCenter;
                self.galleryTableView.backgroundView = noDataLabel;
            }else
                self.galleryTableView.backgroundView = nil;
            
            [self.galleryTableView reloadData];
        }else {
            [OPRequestTimeOutView showWithMessage:[result objectForKeyNotNull:cpResponseMessage expectedObj:@""] forTime:3.0 andController:self];
        }
    }];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    //NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    //NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Memory Management Methods.

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
