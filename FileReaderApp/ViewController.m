//
//  ViewController.m
//  FileReaderApp
//
//  Created by Tahia Ata on 5/11/16.
//  Copyright © 2016 Tahia Ata. All rights reserved.
//

#import "ViewController.h"
#import "DOPDropDownMenu.h"

#define kDropDownWidth      250.f
#define kDropDownHeight     40.f
#define kDropDownYPosition  100.f
#define kFolderName         @"FilesFolder"

@interface ViewController ()<DOPDropDownMenuDataSource, DOPDropDownMenuDelegate>

@property (strong, nonatomic) NSArray *filesArray;
@property (strong, nonatomic) DOPDropDownMenu *menu;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"FileReader";
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kFolderName];
    self.filesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
    [self setUpDropDownMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 1;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    return self.filesArray.count;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    return self.filesArray[indexPath.row];
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch view] != self.menu) {
        [self.menu dismiss];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)setUpDropDownMenu {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake((screenSize.width - kDropDownWidth) / 2.f, kDropDownYPosition) andHeight:kDropDownHeight];
    self.menu.backgroundColor = [UIColor whiteColor];
    self.menu.dataSource = self;
    self.menu.delegate = self;
    [self.view addSubview:self.menu];
}

@end
