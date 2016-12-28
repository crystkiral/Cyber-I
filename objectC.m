//
//  objectC.m
//  Cyber-I Data Management System
//
//  Created by guoao on 15/5/28.
//  Copyright (c) 2015年 guoao. All rights reserved.
//

#import "objectC.h"
#import "notify.h"
#import <Foundation/Foundation.h>
#import "CyberI_Data_Management_System-swift.h"


@implementation objectC


-(void)registerAppforDetectLockState {
    int notify_token;
    DataCollection_Model  *note =  [DataCollection_Model new];
    notify_register_dispatch("com.apple.springboard.lockstate", &notify_token,dispatch_get_main_queue(), ^(int token) {
        uint64_t state = UINT64_MAX;
        notify_get_state(token, &state);
        [note lockStateChanged:state];
      // [note Upload_Controller];
           });

}





@end
