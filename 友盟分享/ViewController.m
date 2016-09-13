//
//  ViewController.m
//  友盟分享
//
//  Created by Mac on 16/9/12.
//  Copyright © 2016年 LoveSpending. All rights reserved.
//

#import "ViewController.h"
#import "UMSocial.h"

@interface ViewController ()<UMSocialUIDelegate>{

    UIButton *shareBt;
    UIButton *loginBt;

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    shareBt = [[UIButton alloc] initWithFrame:(CGRect){100,300,100,35}];
    shareBt.backgroundColor = [UIColor grayColor];
    [shareBt setTitle:@"分享" forState:UIControlStateNormal];
    [shareBt addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBt];
    
    loginBt = [[UIButton alloc] initWithFrame:(CGRect){100,400,100,35}];
    loginBt.backgroundColor = [UIColor grayColor];
    [loginBt setTitle:@"登录" forState:UIControlStateNormal];
    [loginBt addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBt];
    
    [UMSocialData openLog:YES];
    
}

//分享
- (void)shareAction:(UIButton *)sender{

    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"微信";// 微信title
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"微信朋友圈";// 微信朋友圈title
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    [UMSocialData defaultData].extConfig.qqData.title = @"QQ分享";// QQ分享title
    [UMSocialData defaultData].extConfig.qzoneData.title = @"Qzone分享";// Qzone分享title

    
    // 显示分享界面
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"57ce856be0f55ad655001da1" shareText:@"分享的文字内容" shareImage:[UIImage imageNamed:@"ico"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession, UMShareToWechatTimeline, UMShareToQQ, UMShareToQzone, nil] delegate:self];

    }

//登录
- (void)loginAction:(UIButton *)sender{

    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
        }});
}

//判断分享平台，定制分享内容
- (void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    if ([platformName isEqualToString:UMShareToWechatSession]) {
        socialData.shareImage = nil;
    } else if ([platformName isEqualToString:UMShareToTencent]) {
        //微博分享没有标题，url跳转事件
        socialData.shareText = @"新浪微博分享内容,url => www.baidu.com";
    }
    
}

//分享回调方法
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
