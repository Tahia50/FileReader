//
//  FileAlert.m
//  FileReaderApp
//
//  Created by Tahia Ata on 5/13/16.
//  Copyright © 2016 Tahia Ata. All rights reserved.
//

#import "FileAlert.h"
#define kDefaultError  @"Mismatch Error"

@implementation FileAlert

+ (void)showAlertWithController:(UIViewController *)controller
                        message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kDefaultError
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
    [alert addAction:defaultAction];
    [controller presentViewController:alert animated:YES completion:nil];
}

@end
