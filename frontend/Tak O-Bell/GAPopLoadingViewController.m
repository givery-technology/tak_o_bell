//
//  GAPopLoadingViewController.m
//  Attache
//
//  Created by Brian Quach on 2015-01-26.
//  Copyright (c) 2015 Givery. All rights reserved.
//

#import "GAPopLoadingViewController.h"
#import <GKPopLoadingView.h>


@interface GKPopLoadingView ()
@property (nonatomic, strong) UIWindow *overlayWindow;
@end


@implementation GAPopLoadingViewController {
    GKPopLoadingView *loadingView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        loadingView = [[GKPopLoadingView alloc] init];
    }
    return self;
}

- (void)show:(BOOL)show withTitle:(NSString *)title {
    loadingView.overlayWindow.rootViewController = self;
    [loadingView show:show withTitle:title];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
