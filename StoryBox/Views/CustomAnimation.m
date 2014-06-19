//
//  Animation.m
//  故事盒子
//
//  Created by mac on 14-3-4.
//  Copyright (c) 2014年 sony. All rights reserved.
//

#import "CustomAnimation.h"

@implementation ExtraLayerView(CustomAnimation)


/**
 *  缩小scrollView
 */
-(void)scaleToSmall:(float)dis
{
    [UIView animateWithDuration:0.6 animations:^(void)
     {
         scrollView.transform=CGAffineTransformMakeScale(_scale, _scale);
         
         [scrollView setFrame:CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y-dis, scrollView.frame.size.width, scrollView.frame.size.height+dis)];
     }];
   
    UIImageView * imgv=[imageViewArray objectAtIndex:current_index];
    UIView * tV=[textEditViewArray objectAtIndex:current_index];
    
    imgv.alpha=0.8;
    tV.alpha=0.8;
    [self changePaView:imgv withT:tV];//改变父视图
   
    [scrollView bringSubviewToFront:imgv];
    [scrollView bringSubviewToFront:tV];
    [self bringSubviewToFront:gemomtryView];
}

/**
 *  放大scrollView
 *
 *  @param dis
 */
-(void)scaleToOrdinal:(float)dis;
{
    [UIView animateWithDuration:0.6 animations:^(void)
    
     {
         printf("=====%f",dis);
         [scrollView setFrame:CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y+dis, scrollView.frame.size.width, scrollView.frame.size.height-dis)];
         scrollView.transform = CGAffineTransformIdentity;
         
         UIImageView * imgv = [imageViewArray objectAtIndex:current_index];
         UIView * tV=[textEditViewArray objectAtIndex:current_index];
         [self changePaViewToOrdinal:imgv withT:tV];
         
         imgv.alpha = 1;
         tV.alpha = 1;

     }];
    
}

-(void)adjustALLwith_x:(float)d_x with_y:(float)d_y;
{
    if (current_index>=imageViewArray.count)
    {
        printf("error");
        return;
    }
     
    UIImageView * imgv=[imageViewArray objectAtIndex:current_index];
    UIView * tV=[textEditViewArray objectAtIndex:current_index];
    
    float _x=imgv.center.x;
    float _y=imgv.center.y;
 
    [imgv setCenter:CGPointMake(_x+d_x, _y+d_y)];//+d_x
    [tV  setCenter:imgv.center];

    [self detectBoundWithImagev:imgv withTexv:tV withY:d_y];//边界检测

    float ff=scrollView.contentOffset.y;
    float offset_max=scrollView.contentSize.height-scrollView.frame.size.height;
    if((ff>0&&overBound) || (ff<offset_max &&overBound)) {
        [NSTimer scheduledTimerWithTimeInterval: 0.06  target:self selector:@selector(handleTimer1:) userInfo:nil repeats:YES];
        
    }

}

/**
 *  边界检测
 *
 *  @param _view <#_view description#>
 *  @param _t    <#_t description#>
 *  @param _d_y  <#_d_y description#>
 */
-(void)detectBoundWithImagev:(UIImageView *) _view withTexv:(UIView*)_t withY:(float)_d_y
{
    //定义点的范围用四个点构成一个闭合的区域（可见区  x<320 Y<420）
    //左上开始顺时针
    //标签运动感区域默认 宽 高区域320 420//当图片高度小于420时，已实际高度作为运动区域
    //    float _h=420;

    float margin = 15;
    float _h = gemomtryView.frame.origin.y-margin;//区域高度
    
    float v1 = _view.frame.size.width;
    float h1 = _view.frame.size.height;
    float x1 = scrollView.frame.origin.x;
    float y1 = scrollView.frame.origin.y;
    CGPoint point1 = CGPointMake(x1+v1/2,y1+h1/2+margin);//10 不想拖动顶部栏的下面
//    CGPoint point2=CGPointMake(320-v1/2,y1+h1/2+margin);
    //    CGPoint point3=CGPointMake(self.frame.size.width/2, 410-self.frame.size.height/2);
    CGPoint point4 = CGPointMake(x1+v1/2,_h-h1/2);//左下
    
    float _y1=0;//上界限
    float _y2=0;//下界限
    
    if (_view.center.y<point1.y)
    {
        _y1=1;
    }
    if (_view.center.y>point4.y)
    {
        _y2=1;
    }
    
    if (_y1||_y2)
    {
        printf("越界");
        if (_y1==1&&_y2==1)
        {//有越界
            if (_d_y)
            {
                dire_up=NO;
            }
            else
                dire_up=YES;
            overBound=YES;
        }
        else if (_y1==1){//上部分 ，向下运动
            dire_up=YES;
            if (_d_y>0) {
                dire_up=NO;
                overBound=NO;
            }
            else
                overBound=YES;
        }
        else
        {
            dire_up=NO;
            if (_d_y<0)
            {
                dire_up=YES;
                overBound=NO;
            }
            else
                overBound=YES;
        
        }
       
        
    }
    else
    {
//        printf("没越界=%f",_d_y);
        float dis_y=0;
        float t1=_view.center.y-point1.y;//上
        float t2=point4.y-_view.center.y;
//        printf("t1=%f,t2=%f",t1,t2);
 
        if (_d_y <0) {//负为上
            dire_up=YES;
            dis_y=t1;//上界
        }
        else
        {
            dire_up=NO;
            dis_y=t2;
        }
        
        if (dis_y<10&&dis_y>-10)
        {//开始移动标志
            overBound=YES;
//            printf("移动");
        }
        else
        {
            overBound=NO;
//            printf("不移动");
            [self detectCenter];
        }
        
    }

}

/**
 *  检测中点
 */
-(void)detectCenter
{
    //a  b 代表滑动方向的上下相邻序号
    int a =-1;//相邻的待视图序号
    int b =-1;
    if (dire_up) {//up
//        printf("uuu");
        a=empyt_index-1;//上
        b=empyt_index+1;
        
    }
    else//down
    {
//         printf("dddd");
        a=empyt_index+1;
        b=empyt_index-1;
    }
    
    if (a>=imageViewArray.count||a<0)
    {
        overBound=NO;
//        printf("rrrr=%d",a);
        return;
    }
    if (b>=imageViewArray.count||b<0)
    {
        b=-1;
    }
    
//    printf("curent=%d",current_index);
    UIImageView * imgv1=[imageViewArray objectAtIndex:current_index];
    UIImageView * imgv2=[imageViewArray objectAtIndex:a];
    UIView * tV2=[textEditViewArray objectAtIndex:a];
   
    float y_cu=imgv1.center.y;
    float y_compare=(imgv2.center.y-scrollView.contentOffset.y)*_scale+scrollView.frame.origin.y;
 
    if (y_compare-y_cu<5&&y_compare-y_cu>-5)
    {//5
        CGPoint _p;
        if (b!=-1)
        {//存在
            UIImageView * imgv3=[imageViewArray objectAtIndex:b];
            if (dire_up)
            {
                printf("上~~~上");
                _p=CGPointMake(scrollView.center.x, imgv3.frame.origin.y-8-imgv2.frame.size.height/2);
            }
            else
            {
                printf("下~~~下");
                _p=CGPointMake(scrollView.center.x, imgv3.frame.origin.y+imgv3.frame.size.height+8+imgv2.frame.size.height/2);
            }
           
        }
        else
        {
            if (dire_up)
            {//上
                 printf("上~上");
                 _p=CGPointMake(scrollView.center.x, scrollView.contentSize.height-imgv2.frame.size.height/2);
            }
            else
            {
                 printf("下~下");
                _p=CGPointMake(scrollView.center.x,imgv2.frame.size.height/2);
            }
           
        
        }
        [UIView animateWithDuration:0.04 animations:^(void){
            [imgv2 setCenter:_p];
            [tV2 setCenter:imgv2.center];
        }];
        
       
        empyt_index=a;
        [imageViewArray exchangeObjectAtIndex:current_index withObjectAtIndex:a];
        [textEditViewArray exchangeObjectAtIndex:current_index withObjectAtIndex:a];
        
        current_index=a;
    
    }

}

-(void)handleTimer1:(NSTimer*)tm
{
//    printf("开始计时");
    float _d_move=0;
    if (dire_up==YES)
    {
        _d_move=-0.5;
//        printf("上");
    }
    else
    {
        _d_move=0.5;
//        printf("下");
    }
    [UIView animateWithDuration:0.05 animations:^(void)
    {
        CGPoint _p=CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y+_d_move);//
        [scrollView setContentOffset:_p ];
    
    }];
    [self detectCenter ];
    
    UIView *_v=[imageViewArray objectAtIndex: current_index];
    float _added=_v.frame.size.height;
    float  max_offset=scrollView.contentSize.height-scrollView.frame.size.height+_v.frame.size.height;
    if (scrollView.contentOffset.y<-_added||overBound==NO||scrollView.contentOffset.y>max_offset) {
//        printf("停止");
        [tm invalidate];
    }
}

//改变视图的父视图  从scrollview  到 extralayerview
-(void)changePaView:(UIView*)v withT:(UIView*)t
{
 
     float _y=v.center.y*_scale -scrollView.contentOffset.y*_scale +scrollView.frame.origin.y;

    [UIView animateWithDuration:0.6 animations:^(void)
     {
         [v setCenter:CGPointMake( v.center.x, _y)];
         [t setCenter:v.center];

         v.transform=CGAffineTransformMakeScale(_scale,_scale);
         t.transform=CGAffineTransformMakeScale(_scale,_scale);
    
     }];
    
    [v removeFromSuperview];
    [t removeFromSuperview];
    
    [self addSubview:v];
    [self addSubview:t];
    
     empyt_index=current_index;
}

//改变视图的父视图  从extralayerview  到  scrollview
-(void)changePaViewToOrdinal:(UIView*)v withT:(UIView*)t
{
    v.transform=CGAffineTransformIdentity;
    t.transform=CGAffineTransformIdentity;
    CGPoint cen_new;
   
    if (empyt_index-1!=-1)
    {
        UIView *_v=[imageViewArray objectAtIndex:empyt_index-1];
        float _y= _v.center.y+_v.frame.size.height/2+8+v.frame.size.height/2;
        cen_new=CGPointMake(_v.center.x,_y);
    }
    else
    {
        float _y=v.frame.size.height/2;
        float _x=v.frame.size.width/2;
        cen_new=CGPointMake(_x,_y);
    }
    
    [v setCenter:cen_new];
    [t setCenter:v.center];
    
    [scrollView addSubview:v];
    [scrollView addSubview:t];
    
    
    //刷新
    [self reloadScrollview];

}

-(void)reLoadTitleView
{
    for (int i=0; i<scrollView.subviews.count; ++i)
    {
        UIView * titleV=[scrollView.subviews objectAtIndex:i];
        if ([titleV isKindOfClass:[UITitleLabel class]])
        {
            [scrollView bringSubviewToFront:titleV];
        }
    }
}

/**
 *  刷新scrollview
 */
-(void)reloadScrollview
{
    int height=0;
    int  _y=0;//two图片Y坐标
    for (int i=0; i<imageViewArray.count; ++i)
    {
        UIImageView * imgv;
        UIView *textv;
        imgv=[imageViewArray objectAtIndex:i];
        textv=[textEditViewArray objectAtIndex:i];
        [imgv setFrame:CGRectMake(0,_y,imgv.frame.size.width, imgv.frame.size.height)];
       
        [textv setFrame:imgv.frame];
        
        [scrollView addSubview:imgv];
        [scrollView addSubview:textv];
        height=height+imgv.frame.size.height+8;
        
        _y=_y+imgv.frame.size.height+8;
        
    }
    [scrollView setContentSize:CGSizeMake(320,height)];//更新滚动视图的内容大小

    [self reLoadTitleView];
}

@end
