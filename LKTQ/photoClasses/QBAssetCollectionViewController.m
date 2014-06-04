#import "QBAssetCollectionViewController.h"
#import "QBImagePickerAssetCell.h"

@interface QBAssetCollectionViewController ()

@property (nonatomic, retain) NSMutableArray *assets;
@property (nonatomic, retain) NSMutableOrderedSet *selectedAssets;
@property (nonatomic, retain) NSMutableOrderedSet *selectedAssetsCustom;//add


@property (nonatomic, retain) UITableView *tableView;

- (void)reloadData;
- (void)updateRightBarButtonItem;
- (void)updateDoneButton;
- (void)done;
- (void)cancel;

@end
#define  gapBtn 85
#define widthBtn 80
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
@implementation QBAssetCollectionViewController
@synthesize  scrollView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        /* Initialization */
        self.assets = [NSMutableArray array];
        self.selectedAssets = [NSMutableOrderedSet orderedSet];
        //self.selectedAssetsCustom = [NSMutableOrderedSet orderedSet];//TQ
        
        self.imageSize = CGSizeMake(75, 75);
        
        // Table View
        //界面适应
        CGRect rect,rect1;
        
        if (IS_IPHONE_5)
        {
            rect=CGRectMake(0, 436, 320, widthBtn+52);
            rect1=CGRectMake(0, 484, 320, widthBtn+10);   //图片选择栏位置
            finishButton=[[UIButton alloc]initWithFrame:CGRectMake(267, 444, 41, 23)];

           
            selectedState=[[UILabel alloc]initWithFrame:CGRectMake(18, 448, 200, 23)];
            [selectedState setTextColor:[UIColor whiteColor]];
            [selectedState setText:@""];
            selectedState2=[[UILabel alloc]initWithFrame:CGRectMake(90, 494, 140, 23)];
            [selectedState2 setTextColor:[UIColor whiteColor]];
            [selectedState2 setText:@"从相册中添加图片"];
        }
        else
        {
            rect=CGRectMake(0,348, 320, widthBtn+52);
            rect1=CGRectMake(0, 396, 320, widthBtn+10);
            finishButton=[[UIButton alloc]initWithFrame:CGRectMake(267, 356, 41, 23)];
            selectedState=[[UILabel alloc]initWithFrame:CGRectMake(18, 340, 200, 23)];
            [selectedState setTextColor:[UIColor whiteColor]];
            [selectedState setText:@""];
            selectedState2=[[UILabel alloc]initWithFrame:CGRectMake(90, 406, 140, 23)];
            [selectedState2 setTextColor:[UIColor whiteColor]];
            [selectedState2 setText:@"从相册中添加图片"];
        }
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.allowsSelection = YES;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:tableView];
        self.tableView = tableView;
        [tableView release];
        
        
        //预览被选中的缩略图

        [finishButton setImage:[UIImage imageNamed:@"build-before.png"] forState:UIControlStateNormal];
        [finishButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        
        
        
        
        UIImageView *bgSc=[[UIImageView alloc] initWithFrame:rect];
        [bgSc setImage:[UIImage imageNamed:@"selectImageBg.png"]];
        //[bgSc addSubview:finishButton];
        [self.view addSubview:bgSc];
        [bgSc release];
        [self.view addSubview:finishButton];
        [self.view addSubview:selectedState];
        [self.view addSubview:selectedState2];
        [self.view bringSubviewToFront:selectedState2];
        [self.view bringSubviewToFront:selectedState];
        [self.view bringSubviewToFront:finishButton];
        finishButton.enabled=NO;
        
        
        scrollView=[[UIScrollView alloc] initWithFrame:rect1];
        [scrollView setContentSize:CGSizeMake(640, widthBtn+10)];
        [scrollView setBounces:YES];
        [scrollView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:scrollView];
        [scrollView release];
        
       
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Reload
    [self reloadData];
    
    if(self.fullScreenLayoutEnabled) {
        // Set bar styles
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage  imageNamed:@"1title.png"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:223/255.0 green:110/255.0 blue:118/255.0 alpha:1]];
        
        CGFloat top = 0;
        //if(![[UIApplication sharedApplication] isStatusBarHidden]) top = top + 20;
        //if(!self.navigationController.navigationBarHidden) top = top + 44;
        
        //界面适应
        self.tableView.contentInset = UIEdgeInsetsMake(top, 0, widthBtn+52, 0);
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(top, 0, 0, 0);
        
        [self setWantsFullScreenLayout:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Flash scroll indicators
    [self.tableView flashScrollIndicators];
}

- (void)setShowsCancelButton:(BOOL)showsCancelButton
{
    _showsCancelButton = showsCancelButton;
    
    [self updateRightBarButtonItem];
}

- (void)dealloc
{
    [_assetsGroup release];
    [selectedState release];
    [selectedState2 release];
    [_assets release];
    [_selectedAssets release];
    [finishButton release];
    [_tableView release];
    
    [super dealloc];
}


#pragma mark - Instance Methods

- (void)reloadData
{
    // Reload assets
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result) {
            [self.assets addObject:result];
        }
    }];
    
    //排序按时间倒序
    [self.assets sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *date1 = [obj1 valueForProperty:ALAssetPropertyDate];
        NSDate *date2 = [obj2 valueForProperty:ALAssetPropertyDate];
        return ([date1 compare:date2] == NSOrderedAscending ? NSOrderedDescending : NSOrderedAscending);
    }];
    //
    [self.tableView reloadData];
}

- (void)updateRightBarButtonItem
{
        // Set done button
    finishButton.enabled=NO;
//        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:nil target:self action:@selector(done)];
//        doneButton.enabled = NO;
//        
//        [self.navigationItem setRightBarButtonItem:doneButton animated:NO];
//        self.doneButton = doneButton;
//        [doneButton release];
}

-(void)updateDoneButton
{
    if(self.limitsMinimumNumberOfSelection) {
        if(self.selectedAssets.count >= self.minimumNumberOfSelection)
        {
            finishButton.enabled = YES;
            [finishButton setImage:[UIImage imageNamed:@"build-after.png"] forState:UIControlStateNormal];
        }
        else
        {
            finishButton.enabled = NO;
            [finishButton setImage:[UIImage imageNamed:@"build-before.png"] forState:UIControlStateNormal];
        }
    } else {
        if (self.selectedAssets.count > 0)
        {
            finishButton.enabled = YES;
            [finishButton setImage:[UIImage imageNamed:@"build-after.png"] forState:UIControlStateNormal];
        }
        else
        {
            finishButton.enabled = NO;
            [finishButton setImage:[UIImage imageNamed:@"build-before.png"] forState:UIControlStateNormal];
        }
            }
}

- (void)done
{
    [self.delegate assetCollectionViewController:self didFinishPickingAssets:self.selectedAssets.array];
}

- (void)cancel
{
    printf("取消");
    [self.delegate assetCollectionViewControllerDidCancel:self];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRowsInSection = 0;
            NSInteger numberOfAssetsInRow = self.view.bounds.size.width / self.imageSize.width;
            numberOfRowsInSection = self.assets.count / numberOfAssetsInRow;
            if((self.assets.count - numberOfRowsInSection * numberOfAssetsInRow) > 0) numberOfRowsInSection++;
    
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
            NSString *cellIdentifier = @"AssetCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if(cell == nil) {
                NSInteger numberOfAssetsInRow = self.view.bounds.size.width / self.imageSize.width;
                CGFloat margin = round((self.view.bounds.size.width - self.imageSize.width * numberOfAssetsInRow) / (numberOfAssetsInRow + 1));
                
                cell = [[[QBImagePickerAssetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier imageSize:self.imageSize numberOfAssets:numberOfAssetsInRow margin:margin] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [(QBImagePickerAssetCell *)cell setDelegate:self];
            }
            
            // Set assets
            NSInteger numberOfAssetsInRow = self.view.bounds.size.width / self.imageSize.width;
            NSInteger offset = numberOfAssetsInRow * indexPath.row;
            NSInteger numberOfAssetsToSet = (offset + numberOfAssetsInRow > self.assets.count) ? (self.assets.count - offset) : numberOfAssetsInRow;
            
            NSMutableArray *assets = [NSMutableArray array];
            for(NSUInteger i = 0; i < numberOfAssetsToSet; i++) {
                ALAsset *asset = [self.assets objectAtIndex:(offset + i)];
                
                [assets addObject:asset];
            }
            
            [(QBImagePickerAssetCell *)cell setAssets:assets];
            
            // Set selection states
            for(NSUInteger i = 0; i < numberOfAssetsToSet; i++) {
                ALAsset *asset = [self.assets objectAtIndex:(offset + i)];
                
                if([self.selectedAssets containsObject:asset]) {
                    [(QBImagePickerAssetCell *)cell selectAssetAtIndex:i];
                } else {
                    [(QBImagePickerAssetCell *)cell deselectAssetAtIndex:i];
                }
            }
//        }
//            break;
//    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightForRow = 0;

            NSInteger numberOfAssetsInRow = self.view.bounds.size.width / self.imageSize.width;
            CGFloat margin = round((self.view.bounds.size.width - self.imageSize.width * numberOfAssetsInRow) / (numberOfAssetsInRow + 1));
            heightForRow = margin + self.imageSize.height;
    
    return heightForRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - QBImagePickerAssetCellDelegate

- (BOOL)assetCell:(QBImagePickerAssetCell *)assetCell canSelectAssetAtIndex:(NSUInteger)index
{
    BOOL canSelect = YES;
    
    if(self.limitsMaximumNumberOfSelection) {
        canSelect = (self.selectedAssets.count < self.maximumNumberOfSelection);
    }
    
    return canSelect;
}

- (void)assetCell:(QBImagePickerAssetCell *)assetCell didChangeAssetSelectionState:(BOOL)selected atIndex:(NSUInteger)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:assetCell];
    
    printf("\n上面的行:%d,列:%d\n",indexPath.row,indexPath.section);
    
    NSInteger numberOfAssetsInRow = self.view.bounds.size.width / self.imageSize.width;
    NSInteger assetIndex = indexPath.row * numberOfAssetsInRow + index;
    ALAsset *asset = [self.assets objectAtIndex:assetIndex];
    
    int numSelected=0;
    for (int i=0; i<scrollView.subviews.count; ++i) {
        UIButton *imgv=[scrollView.subviews objectAtIndex:i];
        if ([imgv isKindOfClass:[UIButton class]]) {
            numSelected++;
        }
    }
    
    if(selected) {
        
        [self.selectedAssets addObject:asset];
           //添加选中预览
        //[self.selectedAssetsCustom addObject:indexPath];//添加去除
            printf("n=%d",numSelected);
            UIButton * imgView=[UIButton buttonWithType:UIButtonTypeCustom];
            [imgView setFrame:CGRectMake(numSelected*gapBtn, 0,widthBtn,widthBtn)];
            [imgView setImage:[UIImage imageWithCGImage:[asset thumbnail]] forState:UIControlStateNormal];
            [imgView.layer setBorderWidth:1];
            [imgView setTag:assetIndex];
            [imgView addTarget:self action:@selector(clickDelete:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView * imgV=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [imgV setImage:[UIImage imageNamed:@"close-circled.png"]];
        
        [imgView addSubview:imgV];
       
        [scrollView addSubview:imgView];//添加按钮
        
        
             printf("nn=%d",scrollView.subviews.count);
//            [self.selectedAssetsCustom addObject:asset];//add
      
    } else {
        
            [self.selectedAssets removeObject:asset];
            //[self.selectedAssetsCustom removeObject:indexPath];//添加去除
            printf("a=%d",self.selectedAssets.count);
            printf("s=%d",numSelected);
        
//            [self.selectedAssetsCustom removeObject:asset];//add
            for (int i=0;i<scrollView.subviews.count;++i) {
                UIButton *imgv=[scrollView.subviews objectAtIndex:i];
                if ([imgv isKindOfClass:[UIButton class]]){
                    NSInteger t=imgv.tag;
                    if (t==assetIndex) {
                        [imgv removeFromSuperview];
                        numSelected--;
                        printf("去除成功");
                        break;
                    }
                 
                }
              
                
               
            }
            
            int num=0;
            for (int j=0; j<scrollView.subviews.count; ++j) {
                UIButton *btn=[scrollView.subviews objectAtIndex:j];
                 if ([btn isKindOfClass:[UIButton class]]) {
                     [UIView animateWithDuration:1.5 animations:^(void){
                     [btn setFrame:CGRectMake(num*gapBtn, 0, widthBtn, widthBtn)];
                         
                     }];
                     num++;
                 }
            }
        
 
        }
        
        // Set done button state
        [self updateDoneButton];
    
    
    //界面适应
    if(self.selectedAssets.count!=0)
    {
        NSString *title =[[NSString alloc] initWithFormat:@"已经选择了 %d 张",self.selectedAssets.count];
    [selectedState setText:(title)];
        [selectedState2 setText:@""];
        [title release];
    }
    else
    {
        [selectedState setText: [NSString stringWithFormat:@"%@", [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName]]];
        [selectedState2 setText:@"从相册中添加图片"];
    };
        // Update header text修改标题
        if((selected && self.selectedAssets.count == self.assets.count) ||
           (!selected && self.selectedAssets.count == self.assets.count - 1)) {
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            
        }
  
}

-(void)clickDelete:(id)sender
{
    printf("delete");
    UIButton * btn=(UIButton *)sender;
 
    [btn removeFromSuperview];
    
    int num=0;
    for (int j=0; j<scrollView.subviews.count; ++j) {
        UIButton *btn=[scrollView.subviews objectAtIndex:j];
        if ([btn isKindOfClass:[UIButton class]]) {
            [UIView animateWithDuration:1.5 animations:^(void){
            [btn setFrame:CGRectMake(num*gapBtn, 0, btn.frame.size.width, btn.frame.size.height)];

             }];
            num++;
        }
    }
    printf("\n行:%d,列:%d\n",[sender tag]%4,[sender tag]/4);
    //获取得该图片的行和列即可取消选择
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag]%4 inSection:[sender tag]/4];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag]/4 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [(QBImagePickerAssetCell *)cell deselectAssetAtIndex:[sender tag]%4];
     [self.selectedAssets removeObject:[self.assets objectAtIndex:[sender tag]]];
    printf("\n%d gay.\n",[sender tag]);
    //[self.selectedAssetsCustom removeObjectAtIndex:[sender tag]];
    //[self.selectedAssetsCustom removeObject:[self.assets objectAtIndex:[sender tag]]];
    //printf("%d is the count",self.selectedAssetsCustom.count);
}

@end
