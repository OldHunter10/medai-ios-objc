//
//  SceneDelegate.m
//  medai-ios-objc
//
//  Created by JC on 2025/7/26.
//

#import "SceneDelegate.h"
#import "MKHomeViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene
willConnectToSession:(UISceneSession *)session
      options:(UISceneConnectionOptions *)connectionOptions {

    if ([scene isKindOfClass:[UIWindowScene class]]) {
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
        
        MKHomeViewController *vc = [[MKHomeViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    }
}

- (void)sceneDidDisconnect:(UIScene *)scene {}

- (void)sceneDidBecomeActive:(UIScene *)scene {}

- (void)sceneWillResignActive:(UIScene *)scene {}

- (void)sceneWillEnterForeground:(UIScene *)scene {}

- (void)sceneDidEnterBackground:(UIScene *)scene {}

@end
