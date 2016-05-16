//
//  ViewController.m
//  FileReaderApp
//
//  Created by Tahia Ata on 5/11/16.
//  Copyright © 2016 Tahia Ata. All rights reserved.
//

#import <QuickLook/QuickLook.h>
#import "ViewController.h"
#import "DOPDropDownMenu.h"
#import "FileAlert.h"
#import "PublicStringDefine.h"

@interface ViewController ()<DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, QLPreviewControllerDelegate, QLPreviewControllerDataSource>

@property (strong, nonatomic) NSArray *filesArray;
@property (strong, nonatomic) DOPDropDownMenu *menu;
@property (strong, nonatomic) NSString *fileName;
@property (assign, nonatomic) NSInteger menuIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"FileReader";
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kFolderName];
    self.filesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
    [self setUpDropDownMenu];
    self.menuIndex = kStartIndex;
    self.fileName = self.filesArray.firstObject;
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
    self.fileName = self.filesArray[indexPath.row];
    self.menuIndex = indexPath.row;
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

- (IBAction)showPDF:(id)sender {
    [self matchExtension:kPDF];
}

- (IBAction)showPPT:(id)sender {
    [self matchExtension:kPPT];
}

- (void)matchExtension:(NSString *)clickedFileType {
    NSString *extensionName = [self.fileName pathExtension];
    if (![clickedFileType isEqualToString:extensionName]) {
        [FileAlert showAlertWithController:self message:kErrorMessage];
        return;
    }
    QLPreviewController *preview = [[QLPreviewController alloc] init];
    preview.dataSource = self;
    preview.delegate = self;
    preview.currentPreviewItemIndex = self.menuIndex;
    [self.navigationController pushViewController:preview animated:YES];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return self.filesArray.count;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    NSArray *fileComponents = [self.filesArray[index] componentsSeparatedByString:@"."];
    return [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileComponents.firstObject ofType:fileComponents.lastObject inDirectory:kFolderName]];
}

@end
