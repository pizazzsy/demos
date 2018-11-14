//
//  WKWebViewCtr.m
//  demos
//
//  Created by jack on 2018/9/6.
//  Copyright © 2018年 tianyixin. All rights reserved.
//

#import "WKWebViewCtr.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface WKWebViewCtr ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation WKWebViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    
    //清除缓存
    //// Date from
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    //// Execute
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        // Done
    }];
   [self.view addSubview:self.webView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    
//      self.navigationController.navigationBarHidden=YES;
}

#pragma WKUIDelegate代理事件


// 页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
     NSLog(@"页面开始加载时调用");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
      NSLog(@"当内容开始返回时调用");
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
      NSLog(@"页面加载完成之后调用");
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
      NSLog(@"页面加载失败时调用");
}
// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"接收到服务器跳转请求之后再执行");
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    
       NSLog(@"在收到响应后，决定是否跳转");
    WKNavigationResponsePolicy actionPolicy = WKNavigationResponsePolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
    
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
       NSLog(@"在发送请求之前，决定是否跳转");
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    
    if (navigationAction.navigationType==WKNavigationTypeBackForward) {
        
    }
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}
#pragma WKUIDelegate代理事件,主要实现与js的交互
//显示一个JS的Alert（与JS交互）
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
      NSLog(@"显示一个JS的Alert（与JS交互）");
    completionHandler();
}

//弹出一个输入框（与JS交互的）
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    
     NSLog(@"弹出一个输入框（与JS交互的）");
}

//显示一个确认框（JS的）
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
     NSLog(@"显示一个确认框（JS的）");
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController

      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:message.name
                          
                                                   message: message.body
                          
                                                  delegate:self
                          
                                         cancelButtonTitle:@"取消"
                          
                                         otherButtonTitles:@"确定", nil];
    
    [alert show];
    
    //找到对应js端的方法名,获取messge.body
    NSLog(@"%@", message.name);
    if ([message.name isEqualToString:@"appPayment"]) {
        
        NSLog(@"%@", message.body);
    }
    
}


/// 加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    if (error.code == NSURLErrorNotConnectedToInternet) {
        NSLog(@"无网络(APP第一次启动并且没有得到网络授权时可能也会报错)");
        //        [self showErrorView];
        /// 无网络(APP第一次启动并且没有得到网络授权时可能也会报错)
        
    } else if (error.code == NSURLErrorCancelled){
        NSLog(@"上一页面还没加载完，就加载当下一页面，就会报这个错。");
        /// -999 上一页面还没加载完，就加载当下一页面，就会报这个错。
        return;
    }
    NSLog(@"webView加载失败:error %@",error);
}


- (WKWebView *)webView
{
    
    if(!_webView)
    {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc] init];
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        config.processPool = [[WKProcessPool alloc] init];
        
        
        config.allowsInlineMediaPlayback = YES;//默认使NO。这个值决定了用内嵌HTML5播放视频还是用本地的全屏控制。
        config.userContentController = [[WKUserContentController alloc] init];
        
        [config.userContentController addScriptMessageHandler:self name:@"appPayment"];
        
        self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds
                        
                                          configuration:config];
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mallapi.tyxin.cn/dist/index.html#/home"]]];
        //    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"www.baidu.com"]]];
        self.webView.navigationDelegate = self;
        self.webView.navigationDelegate=self;
        self.webView.UIDelegate = self;
        //开了支持滑动返回
        self.webView.allowsBackForwardNavigationGestures = YES;
        
        //开了支持滑动返回
        self.webView.allowsBackForwardNavigationGestures = YES;
        //        self.webView.scrollView.bounces=NO;
        
    }
    return _webView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
