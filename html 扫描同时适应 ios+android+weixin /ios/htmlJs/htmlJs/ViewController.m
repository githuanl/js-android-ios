//
//  ViewController.m
//  htmlJs
//
//  Created by liudong on 16/7/5.
//  Copyright © 2016年 CenterSoft. All rights reserved.
//

#import "ViewController.h"
#import "LBXScanViewStyle.h"
#import "SubLBXScanViewController.h"
#import "Const.h"

@interface ViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([Const sharedInstance].result) {
        NSString *showViewTbData =[NSString stringWithFormat:@"javaCallJsWithArgs('%@')",[Const sharedInstance].result];
        [_webView stringByEvaluatingJavaScriptFromString:showViewTbData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    // 1.webView
    self.webView = [[UIWebView alloc] init];
    self.webView.frame = self.view.bounds;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    // 2.加载网页
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"wst" withExtension:@"html"];
    NSURL *url = [NSURL URLWithString:@"http://192.168.0.118:8080/test/wst.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self qqStyle];
}


#pragma mark -模仿qq界面
- (void)qqStyle
{
    //设置扫码区域参数设置
    
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 44;
    
    //扫码框周围4个角的类型,设置为外挂式
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 6;
    
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //线条上下移动图片
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    
    //SubLBXScanViewController继承自LBXScanViewController
    //添加一些扫码或相册结果处理
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;
    vc.isQQSimulator = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



/**
 *  webView每当发送一个请求之前，都会先调用这个方法（能拦截所有请求）
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([@"ios" isEqualToString:request.URL.scheme]) {
        
        NSString *url = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSRange range = [url rangeOfString:@":"];
        NSRange methodStart = [url rangeOfString:@"("];
        NSString *method = [url substringWithRange:NSMakeRange(range.location + 1,methodStart.location-range.location-1)];
        
        NSString *paramStr = [url substringWithRange:NSMakeRange(methodStart.location + 1,[url rangeOfString:@")"].location-methodStart.location - 1)];
        NSArray *paramArray  = [paramStr componentsSeparatedByString:@"#"];
        
        SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:",method]);
        
        if ([self respondsToSelector:selector]) {
            [self performSelector:selector withObject:paramArray afterDelay:0.0f];
        }
        return YES;
    }
    
    return YES;
    
}




#pragma mark - 获取日期及取数据相关




-(void)openScan:(NSArray*)array{
     self.navigationItem.title = [array objectAtIndex:0];
    
    [self qqStyle];
}



//返回
- (void)back
{
    if([_webView canGoBack]){
        [_webView goBack];
    }else{

        [self.navigationController popViewControllerAnimated:YES];
    }
}

//搜索
-(void)search{
    [_webView stringByEvaluatingJavaScriptFromString:@"opFindPop();"];
}

-(void)dealloc{
    [_webView removeFromSuperview];
    _webView.delegate = nil;
    _webView = nil;
}


@end
