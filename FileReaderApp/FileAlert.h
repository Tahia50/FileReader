//
//  FileAlert.h
//  FileReaderApp
//
//  Created by Tahia Ata on 5/13/16.
//  Copyright © 2016 Tahia Ata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FileAlert : NSObject

+ (void)showAlertWithController:(UIViewController *)controller
                        message:(NSString *)message;

@end
