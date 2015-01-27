//
//  FCSetting.m
//  Python-iOS-app
//
//  Created by user on 15-1-23.
//  Copyright (c) 2015年 Fancyzero. All rights reserved.
//

#import "FCSetting.h"
#import "FCCache.h"

@implementation FCSetting

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([[FCCache defaultCache] objectForKey:FCCache_Key_EditorFontSize]==nil){
            [[FCCache defaultCache] setObject:@(20) forKey:FCCache_Key_EditorFontSize];
        }
        self.editorFontSize = [[[FCCache defaultCache] objectForKey:FCCache_Key_EditorFontSize] unsignedIntegerValue];
    }
    return self;
}

-(NSArray *)fields{
    return @[
             @{FXFormFieldKey: @"editorFontSize",
               FXFormFieldTitle: NSLocalizedString(@"editorFontSize", nil),
               FXFormFieldCell: [FXFormStepperCell class],
               FXFormFieldAction: ^(id sender){
                   FXFormStepperCell *sep = sender;
                   self.editorFontSize=sep.stepper.stepValue;
                   [[FCCache defaultCache] setObject:@(sep.stepper.stepValue) forKey:FCCache_Key_EditorFontSize];
               },
               FXFormFieldDefaultValue:@(self.editorFontSize)
               }
            ];
}

@end
