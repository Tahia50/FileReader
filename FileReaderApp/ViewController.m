//
//  ViewController.m
//  FileReaderApp
//
//  Created by Tahia Ata on 5/11/16.
//  Copyright © 2016 Tahia Ata. All rights reserved.
//

#import <QuickLook/QuickLook.h>
#import "ViewController.h"
#import "DropDownListView.h"
#import "FileAlert.h"
#import "PublicStringDefine.h"

@interface ViewController ()<kDropDownListViewDelegate, QLPreviewControllerDelegate, QLPreviewControllerDataSource>

@property (strong, nonatomic) NSArray *filesArray;
@property (strong, nonatomic) DropDownListView *menu;
@property (strong, nonatomic) NSString *fileName;
@property (weak, nonatomic) IBOutlet UIButton *dropDownButton;
@property (assign, nonatomic) NSInteger menuIndex;
@property (assign, nonatomic) BOOL flag;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"FileReader";
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kFolderName];
    self.filesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
    self.fileName = self.filesArray.firstObject;
    [self.dropDownButton setTitle:self.fileName forState:UIControlStateNormal];
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [self.containerView addGestureRecognizer:singleFingerTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSingleTap {
    [self.menu fadeOut];
    self.flag = NO;
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

- (void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple {
    self.menu = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    self.menu.delegate = self;
    [self.menu showInView:self.containerView animated:YES];
    [self.menu SetBackGroundDropDown_R:0.f G:108.f B:194.f alpha:0.7f];
}

- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex {
    self.fileName = self.filesArray[anIndex];
    self.menuIndex = anIndex;
    [self.dropDownButton setTitle:[self.filesArray objectAtIndex:anIndex] forState:UIControlStateNormal];
    self.flag = NO;
}

- (IBAction)dropDownButtonClicked:(id)sender {
    if (self.flag) {
       self.flag = NO;
    } else {
       self.flag = YES;
    }
    [self setUpDropDown];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (self.flag) {
        [self setUpDropDown];
    }
}

- (void)setUpDropDown {
    [self.menu fadeOut];
    [self showPopUpWithTitle:kDropDownTitle
                  withOption:self.filesArray
                          xy:CGPointMake(self.dropDownButton.frame.origin.x, self.dropDownButton.frame.origin.y + self.dropDownButton.frame.size.height)
                        size:CGSizeMake(self.dropDownButton.frame.size.width, kDropDownHeight)
                  isMultiple:NO];
}

@end
