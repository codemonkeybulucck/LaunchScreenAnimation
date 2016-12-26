//
//  ViewController.m
//  launchAnimationTest
//
//  Created by lemon on 2016/12/26.
//  Copyright © 2016年 lemon. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showLauchAnimation];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


/**
 创建启动图动画
 */
- (void)showLauchAnimation{
    //获取launchScreen的stotyboard的view
    UIViewController *launchVc = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    //创建UIImageView ,添加到launchVc的View上
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [launchVc.view addSubview:imageView];
    
    //添加到自身得view上面
    [self.view addSubview:launchVc.view];
    
    //设置图片，如果之前已经获取了图片那么就显示，否则显示原始启动图
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/second.png",path]];
    if (image == nil)
    {
        imageView.image  = [UIImage imageNamed:@"test"];
        //异步获取图片
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] init];
        NSURLRequest *ruquest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://s16.sinaimg.cn/large/005vePOgzy70Rd3a9pJdf&690"]];
        AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
        [serializer setAcceptableContentTypes:@[@"image/jpeg"]];
        [manager setResponseSerializer:serializer];
        [[manager dataTaskWithRequest:ruquest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error != nil || responseObject == nil)
            {
                NSLog(@"下载失败");
                return;
            }
            NSData *data = (NSData *)responseObject;
            BOOL iswrite = [data writeToFile:[NSString stringWithFormat:@"%@/second.png",path] options:0 error:nil];
            if (iswrite)
            {
                NSLog(@"写入文件成功");
            }
        }] resume];
    }
    else{
        imageView.image = image;
    }
    
    //加载动画
    [UIView animateWithDuration:6.0f animations:^{
        launchVc.view.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1.5);
    } completion:^(BOOL finished) {
        //可在这里更换delegate.keywindo.rootViewcontroller设置广告图或者进入主界面
        [launchVc.view removeFromSuperview];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
