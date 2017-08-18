//
//  ShaiXuanView.m
//  FSB
//
//  Created by 大家保 on 2017/8/7.
//  Copyright © 2017年 dajiabao. All rights reserved.
//

#import "ShaiXuanView.h"
#import "ShaixuanCollectCell.h"
#import "ShaixuanCollectHeadView.h"
#import "SearchModel.h"
#define paddingLeft   64
#define shaiXuanWidth (SCREEN_WIDTH-paddingLeft)

@interface ShaiXuanView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>


@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UIView *statusView;

@property (nonatomic,strong) UIView *zheZhaoView;

@property (nonatomic,strong) UICollectionView *myCollectionView;

@property (nonatomic,strong) NSMutableArray   *dataArray;

@property (nonatomic,strong) NSMutableArray   *backArray;

@end

static NSString * const shaiXuanCell=@"shaiXuanCell";

static NSString * const shaiXuanHead=@"shaiXuanHead";

@implementation ShaiXuanView

- (instancetype)init{
    if (self=[super init]) {
        self.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}


//加载数据
- (void)reloadDtaWithType:(int)careType{
    NSString     *url=[NSString stringWithFormat:@"%@%@",APPHOSTURL,filterProducts];
    NSDictionary *dic=@{@"careType":@(careType)};
    [XWNetworking postJsonWithUrl:url params:dic responseCache:^(id responseCache) {
        
    }success:^(id response) {
        if (response) {
            NSInteger statusCode=[response integerForKey:@"statusCode"];
            if (statusCode==400) {
                
            }else{
                [self.backArray removeAllObjects];
                [self.backArray addObjectsFromArray:self.selectedArray];
                [self.myCollectionView reloadData];
            }
        }
    } fail:^(NSError *error) {
        [self.backArray removeAllObjects];
        [self.backArray addObjectsFromArray:self.selectedArray];
        [self.myCollectionView reloadData];
    } showHud:NO];
};


//开始显示
- (void)show:(UIView *)view{
    if (view==nil) {
        view=KeyWindow;
    }
    [view addSubview:self];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.zheZhaoView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.bottomView.frame=CGRectMake(paddingLeft, SCREEN_HEIGHT-50, shaiXuanWidth, 50);
        self.statusView.frame=CGRectMake(paddingLeft, 0, shaiXuanWidth, SCREEN_HEIGHT-50);
    } completion:nil];
}

//开始隐藏
- (void)hide{
    [self hidden:NO];
}

//开始隐藏
- (void)hidden:(BOOL)backBlock{

    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.zheZhaoView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0];
        self.bottomView.frame=CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT-50, shaiXuanWidth, 50);
        self.statusView.frame=CGRectMake(SCREEN_WIDTH, 0, shaiXuanWidth, SCREEN_HEIGHT-50);
    } completion:^(BOOL finished) {
        [self.bottomView removeFromSuperview];
        [self.statusView removeFromSuperview];
        [self removeFromSuperview];
        
        if (backBlock) {
            self.okBlock?self.okBlock(self.backArray):nil;
        }
    }];
}


#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArray.count;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    SearchModel *model=self.dataArray[section];
    return model.filterContents.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShaixuanCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shaiXuanCell forIndexPath:indexPath];
    SearchModel *model=self.dataArray[indexPath.section];
    SearchContentModel *content=model.filterContents[indexPath.item];
    cell.shaiXuanBottom.text = content.filterContentTitle;
    
    if ([self.backArray indexOfObject:content]!= NSNotFound) {
        cell.shaiXuanBottom.backgroundColor=RGB(229, 244, 252);
        cell.shaiXuanBottom.textColor=[UIColor colorWithHexString:@"#1fa2ed"];
    }else{
        cell.shaiXuanBottom.backgroundColor=RGB(239, 242, 245);
        cell.shaiXuanBottom.textColor=[UIColor colorWithHexString:@"#444444"];
    }
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        ShaixuanCollectHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:shaiXuanHead forIndexPath:indexPath];
        SearchModel *model=self.dataArray[indexPath.section];
        headerView.shaiXuanHeadLabel.text = model.filterTilte;
        headerView.backgroundColor=[UIColor whiteColor];
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return (CGSize){shaiXuanWidth,15};
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchModel *model=self.dataArray[indexPath.section];
    SearchContentModel *content=model.filterContents[indexPath.item];
    if ([self.backArray indexOfObject:content]!= NSNotFound) {
        [self.backArray removeObject:content];
    }else{
        [self.backArray addObject:content];
    }
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
}


//确定、取消
- (void)click:(UIButton *)sender{
    switch (sender.tag) {
        case 500:
        {
            [self.backArray removeAllObjects];
            [self.myCollectionView reloadData];
        }
            break;
        case 501:
        {
            [self hidden:YES];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark 懒加载
- (UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection=UICollectionViewScrollDirectionVertical;
        layout.itemSize=CGSizeMake((shaiXuanWidth-70)/2.0, 35);
        layout.minimumLineSpacing=15;
        layout.minimumInteritemSpacing=20;
        layout.sectionInset=UIEdgeInsetsMake(20, 25, 20, 25);
        _myCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0,25, shaiXuanWidth, SCREEN_HEIGHT-75) collectionViewLayout:layout];
        [_myCollectionView registerNib:[UINib nibWithNibName:@"ShaixuanCollectCell" bundle:nil] forCellWithReuseIdentifier:shaiXuanCell];
        [_myCollectionView registerNib:[UINib nibWithNibName:@"ShaixuanCollectHeadView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:shaiXuanHead];
        _myCollectionView.delegate=self;
        _myCollectionView.dataSource=self;
        _myCollectionView.backgroundColor=[UIColor whiteColor];
        [self.statusView insertSubview:_myCollectionView aboveSubview:self.zheZhaoView];

    }
    return _myCollectionView;
}


- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT-50, shaiXuanWidth, 50)];
        _bottomView.backgroundColor=[UIColor whiteColor];
         [self insertSubview:_bottomView aboveSubview:self.zheZhaoView];
        
        UIView *topLine=[[UIView alloc]init];
        topLine.backgroundColor=RGB(239,242, 245);
        [_bottomView addSubview:topLine];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        UIButton *quxiao=[[UIButton alloc]init];
        [quxiao setTitle:@"重新选择" forState:0];
        [quxiao setTag:500];
        [quxiao addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [quxiao setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:0];
        [quxiao.titleLabel setFont:font17];
        [_bottomView addSubview:quxiao];
        [quxiao mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(0);
            make.width.mas_equalTo(_bottomView.width/2.0);
        }];
        
        UIButton *queding=[[UIButton alloc]init];
        [queding setTitle:@"确定" forState:0];
        [queding setTag:501];
        [queding setTitleColor:[UIColor whiteColor] forState:0];
        [queding setBackgroundColor:[UIColor colorWithHexString:@"#1fa2ed"]];
        [queding addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [queding.titleLabel setFont:font17];
        [_bottomView addSubview:queding];
        [queding mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(quxiao);
            make.left.mas_equalTo(quxiao.mas_right).offset(0);
        }];
        
    }
    return _bottomView;
}

- (UIView *)statusView{
    if (!_statusView) {
        _statusView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, shaiXuanWidth, SCREEN_HEIGHT-50)];
        _statusView.backgroundColor=[UIColor whiteColor];
        [self insertSubview:_statusView aboveSubview:self.zheZhaoView];
    }
    return _statusView;
}

- (UIView *)zheZhaoView{
    if (!_zheZhaoView) {
        _zheZhaoView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _zheZhaoView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0];
        [self addSubview:_zheZhaoView];
        
        UISwipeGestureRecognizer *swip=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        swip.delegate=self;
        swip.direction=UISwipeGestureRecognizerDirectionRight;
        [_zheZhaoView addGestureRecognizer:swip];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        tap.delegate=self;
        [tap requireGestureRecognizerToFail:swip];
        [_zheZhaoView addGestureRecognizer:tap];
    }
    return _zheZhaoView;
}




- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
        
        SearchContentModel *content1=[[SearchContentModel alloc]init];
        content1.filterContentTitle=@"重大疾病";
        content1.filterContentId=1;
        
        SearchContentModel *content2=[[SearchContentModel alloc]init];
        content2.filterContentTitle=@"日常门诊";
        content2.filterContentId=2;
        
        SearchContentModel *content3=[[SearchContentModel alloc]init];
        content3.filterContentTitle=@"防癌保障";
        content3.filterContentId=3;
        
        SearchModel *model1=[[SearchModel alloc]init];
        model1.filterTilte=@"保障类型";
        model1.filterId=100;
        model1.filterType=100;
        model1.filterContents=[NSMutableArray arrayWithObjects:content1,content2, content3,nil];
        
        [_dataArray addObject:model1];
        
        
        SearchContentModel *content4=[[SearchContentModel alloc]init];
        content4.filterContentTitle=@"0-17岁";
        content4.filterContentId=4;
        
        SearchContentModel *content5=[[SearchContentModel alloc]init];
        content5.filterContentTitle=@"18-40岁";
        content5.filterContentId=5;
        
        SearchContentModel *content6=[[SearchContentModel alloc]init];
        content6.filterContentTitle=@"41-50岁";
        content6.filterContentId=6;
        
        SearchModel *model2=[[SearchModel alloc]init];
        model2.filterTilte=@"保障年龄";
        model2.filterId=200;
        model2.filterType=200;
        model2.filterContents=[NSMutableArray arrayWithObjects:content4,content5, content6,nil];
        
        [_dataArray addObject:model2];
    }
    return _dataArray;
}

- (NSMutableArray *)backArray{
    if (!_backArray) {
        _backArray=[NSMutableArray array];
    }
    return _backArray;
}

@end
