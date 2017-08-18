//
//  SearchVC.m
//  FSB
//
//  Created by 大家保 on 2017/8/1.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import "SearchVC.h"
#import "SearchCell.h"
#import "SearchHeadView.h"
#import "FindCell.h"
#import "SearchModel.h"
#import "SearchFooterView.h"

@interface SearchVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    UITextField *_inputField;
    UIButton    *_searchButton;
    BOOL beginSearch;
}

@property (nonatomic,strong) UITableView *myTableView;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *historyArray;

@property (nonatomic,strong) NSMutableArray *collectArray;

@end

static NSString * const tableCell=@"TableCell";

static NSString * const collecCell=@"collecCell";

static NSString * const collecCellHeadId=@"collecCellHeadId";

static NSString * const collecCellFooterId=@"collecCellFooterId";

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self addHeadView];
    self.myTableView.hidden=YES;
    [self.collectionView reloadData];
    [self getData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_inputField becomeFirstResponder];
}

//获取数据
- (void)getData{
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,getsearchFilter];
    [XWNetworking getJsonWithUrl:url params:nil responseCache:^(id responseCache) {
        
    }success:^(id response) {
        if (response) {
            NSInteger statusCode=[response integerForKey:@"statusCode"];
            if (statusCode==400) {
                
            }else{
                [self.collectionView reloadData];
            }
        }
    } fail:^(NSError *error) {
        
        SearchContentModel *content1=[[SearchContentModel alloc]init];
        content1.filterContentTitle=@"高富帅";
        content1.filterContentId=1;
        
        SearchContentModel *content2=[[SearchContentModel alloc]init];
        content2.filterContentTitle=@"白富美";
        content2.filterContentId=2;
        
        SearchContentModel *content3=[[SearchContentModel alloc]init];
        content3.filterContentTitle=@"程序猿";
        content3.filterContentId=3;
        
        SearchContentModel *content4=[[SearchContentModel alloc]init];
        content4.filterContentTitle=@"铲屎官";
        content4.filterContentId=4;
        
        SearchModel *model1=[[SearchModel alloc]init];
        model1.filterTilte=@"你是谁？";
        model1.filterId=100;
        model1.filterType=100;
        model1.filterContents=[NSMutableArray arrayWithObjects:content1,content2, content3,content4,nil];
        
        [self.collectArray addObject:model1];
        
        
        SearchModel *model2=[[SearchModel alloc]init];
        model2.filterTilte=@"历史记录";
        model2.filterId=200;
        model2.filterType=200;
        model2.filterContents=self.historyArray;
        
        [self.collectArray insertObject:model2 atIndex:0];
        
        [self.collectionView reloadData];
        
    } showHud:NO];
}

//添加头视图
- (void)addHeadView{
    UIView *headView=[[UIView alloc]init];
    headView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(64);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    
    UIImageView *_seachView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-3"]];
    _seachView.contentMode=UIViewContentModeScaleAspectFit;
    _seachView.frame = CGRectMake(0, 0, 34, 16);
    
    _inputField=[[UITextField alloc]initWithFrame:CGRectMake(15, 27, SCREEN_WIDTH-75, 30)];
    _inputField.placeholder=@"请输入搜索内容";
    _inputField.font=font14;
    _inputField.textColor=[UIColor colorWithHexString:@"#888888"];
    _inputField.backgroundColor=[UIColor colorWithHexString:@"#f2f4f7"];
    _inputField.leftView = _seachView;
    _inputField.leftViewMode=UITextFieldViewModeAlways;
    _inputField.layer.cornerRadius=5;
    _inputField.clipsToBounds=YES;
    _inputField.delegate=self;
    [_inputField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _inputField.returnKeyType=UIReturnKeySearch;
    [headView addSubview:_inputField];
    
    _searchButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 20, 60, 44)];
    [_searchButton setTitle:@"取消" forState:0];
    [_searchButton setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:0];
    [_searchButton.titleLabel setFont:font16];
    [_searchButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_searchButton];
}


//取消
- (void)back:(UIButton *)sender{
    [_inputField endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 输入框改变事件
/** 输入框内容发生改变 */
- (void)textFieldChanged:(UITextField *)textField {
    if ([[ToolsManager share] clearSpace:textField.text].length==0) {
        [self.dataArray      removeAllObjects];
        [self.myTableView    reloadData];
        [self.myTableView    setHidden:YES];
        [self.collectionView reloadData];
        [self.collectionView setHidden:NO];
        beginSearch=NO;
        if (0==self.collectArray.count) {
            [self getData];
        }
    }else{
        beginSearch=YES;
        [self.myTableView    setHidden:NO];
        [self.collectionView setHidden:YES];
        [self getData:[[ToolsManager share] clearSpace:_inputField.text] filterContentId:-1];
    }
}

#pragma mark -- UITextFieldDelegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.returnKeyType==UIReturnKeySearch){
        if ([[ToolsManager share] clearSpace:textField.text].length > 0){
            [self getData:[[ToolsManager share] clearSpace:_inputField.text] filterContentId:-1];
            [self addHisTory:[[ToolsManager share] clearSpace:textField.text]];
        }
    }
    return YES;
}

//添加历史记录
- (void)addHisTory:(NSString *)searchName{
    NSArray *searchArray=[[JQFMDB shareDatabase] jq_lookupTable:@"history" dicOrModel:[SearchContentModel class] whereFormat:[NSString stringWithFormat:@"where filterContentTitle = '%@'",searchName]];
    if (0==searchArray.count) {
        SearchContentModel *his=[[SearchContentModel alloc]init];
        his.filterContentTitle=searchName;
        his.filterContentId=-1;
        [[JQFMDB shareDatabase] jq_insertTable:@"history" dicOrModel:his];
        [self.historyArray insertObject:his atIndex:0];
    }
}

//删除历史记录
- (void)deleteHistory{
    [[JQFMDB shareDatabase] jq_deleteAllDataFromTable:@"history"];
    [self.historyArray removeAllObjects];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

//获取搜索结果
- (void)getData:(NSString *)searchContent filterContentId:(int)filterId{
    [self.dataArray removeAllObjects];
    [self.myTableView reloadData];
    NSString *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,getSearch];
    NSDictionary *dic=@{@"searchContent":searchContent,@"filterContentId":@(filterId)};
    [XWNetworking postJsonWithUrl:url params:dic success:^(id response) {
        if (response) {
            NSInteger statusCode=[response integerForKey:@"statusCode"];
            if (statusCode==400) {
                
            }else{
                [self.myTableView reloadData];
            }
        }
    } fail:^(NSError *error) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObject:@"1"];
        [self.dataArray addObject:@"2"];
        [self.dataArray addObject:@"3"];
        [self.dataArray addObject:@"4"];
        [self.myTableView reloadData];
        //if ([XWNetworking isHaveNetwork]) {
        //    [MBProgressHUD ToastInformation:@"服务器开小差了"];
        //}else{
        //    [MBProgressHUD ToastInformation:@"网络似乎已断开..."];
        //}
    } showHud:NO];
}

#pragma mark uitableViewDelegate和uitableviewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     FindCell *cell=[tableView dequeueReusableCellWithIdentifier:tableCell];
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
     cell.bgView.backgroundColor=[UIColor whiteColor];
     cell.bgView.layer.cornerRadius=5;
     cell.bgView.layer.shadowRadius=20;
     cell.bgView.layer.shadowColor=[UIColor blackColor].CGColor;
     cell.bgView.layer.shadowOpacity=0.08;
     cell.bgView.layer.shadowOffset=CGSizeMake(0, 0);
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[ToolsManager share] isLogin]) {
        
    }else{
        [self toLoginVC];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UILabel  *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    label.text=@"没有匹配结果";
    label.textAlignment=NSTextAlignmentCenter;
    label.font=font15;
    label.textColor=[UIColor colorWithHexString:@"#595959"];
    if (self.dataArray.count==0) {
        return label;
    }else{
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.dataArray.count==0) {
        return 100;
    }else{
        return 0.0001;
    }
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.collectArray.count;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    SearchModel *model=self.collectArray[section];
    return model.filterContents.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collecCell forIndexPath:indexPath];
    SearchModel *model=self.collectArray[indexPath.section];
    SearchContentModel *content=model.filterContents[indexPath.item];
    cell.searchTitleButtom.text=content.filterContentTitle;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        SearchHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:collecCellHeadId forIndexPath:indexPath];
        SearchModel *model=self.collectArray[indexPath.section];
        headerView.searchTitleLabel.text = model.filterTilte;
        if (indexPath.section==0&&0<self.historyArray.count) {
            headerView.deleteBtn.hidden=NO;
        }else{
            headerView.deleteBtn.hidden=YES;
        }
        [headerView setDeleteBlock:^{
            WeakSelf;
            [weakSelf deleteHistory];
        }];
        return headerView;
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        SearchFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:collecCellFooterId forIndexPath:indexPath];
        return footerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return (CGSize){SCREEN_WIDTH,14};
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return (CGSize){SCREEN_WIDTH,40};
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchModel *model=self.collectArray[indexPath.section];
    SearchContentModel *content=model.filterContents[indexPath.item];
    _inputField.text=content.filterContentTitle;
    beginSearch=YES;
    [self.myTableView    setHidden:NO];
    [self.collectionView setHidden:YES];
    [self getData:content.filterContentTitle filterContentId:(int)content.filterContentId];
}


#pragma mark 懒加载
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _myTableView.delegate=self;
        _myTableView.dataSource=self;
        _myTableView.backgroundColor = [UIColor clearColor];
        _myTableView.showsVerticalScrollIndicator=NO;
        _myTableView.showsHorizontalScrollIndicator=NO;
        _myTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _myTableView.tableFooterView=[UIView new];
        [_myTableView registerNib:[UINib nibWithNibName:@"FindCell" bundle:nil] forCellReuseIdentifier:tableCell];
        _myTableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection=UICollectionViewScrollDirectionVertical;
        layout.itemSize=CGSizeMake((SCREEN_WIDTH-75)/4.0, 25);
        layout.minimumLineSpacing=15;
        layout.minimumInteritemSpacing=15;
        layout.sectionInset=UIEdgeInsetsMake(20, 15, 0, 15);
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, SCREEN_HEIGHT-80) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellWithReuseIdentifier:collecCell];
        [_collectionView registerNib:[UINib nibWithNibName:@"SearchHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collecCellHeadId];
        [_collectionView registerNib:[UINib nibWithNibName:@"SearchFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:collecCellFooterId];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.backgroundColor=[UIColor clearColor];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

//搜索结果
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

//搜索建议
- (NSMutableArray *)collectArray{
    if (!_collectArray) {
        _collectArray=[NSMutableArray array];
    }
    return _collectArray;
}

//历史记录
- (NSMutableArray *)historyArray{
    if (!_historyArray) {
        _historyArray=[NSMutableArray array];
        NSArray *searchArray=[[JQFMDB shareDatabase] jq_lookupTable:@"history" dicOrModel:[SearchContentModel class] whereFormat:nil];
        for (SearchContentModel *his in searchArray) {
            [_historyArray insertObject:his atIndex:0];
        }
    }
    return _historyArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
