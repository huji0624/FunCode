//
//  PythonRun.m
//  Python-iOS-app
//
//  Created by user on 15-1-23.
//  Copyright (c) 2015年 Fancyzero. All rights reserved.
//

#import "PythonRun.h"
#include "Python.h"

static int
_check_and_flush (FILE *stream)
{
    int prev_fail = ferror (stream);
    return fflush (stream) || prev_fail ? EOF : 0;
}

@implementation PythonRun{
    NSString *_code;
    NSString *_err;
}
-(instancetype)initWithCode:(NSString *)code{
    self = [super init];
    if (self) {
        _code = [code copy];
        _err = nil;
    }
    return self;
}

-(NSString*)fullPath:(NSString*)name{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return [docDir stringByAppendingPathComponent:name];
}

-(NSString *)err{
    return _err;
}

-(NSString *)run{
    
    NSString *fopath = [self fullPath:@"fakestdout"];
    NSString *fepath = [self fullPath:@"fakestderr"];
    
    FILE *fakestdout = fopen([fopath cStringUsingEncoding:NSASCIIStringEncoding], "w");
    FILE *fakestderr = fopen([fepath cStringUsingEncoding:NSASCIIStringEncoding], "w");
    
    PyObject *fakesysout = PyFile_FromFile(fakestdout, "<stdout>", "w", _check_and_flush);
    PyObject *fakesyserr = PyFile_FromFile(fakestderr, "<stderr>", "w", _check_and_flush);
    
    PySys_SetObject("stdout", fakesysout);
    PySys_SetObject("stderr", fakesyserr);
    
    PyRun_SimpleString([_code cStringUsingEncoding:NSASCIIStringEncoding]);
    
    long size=ftell(fakestderr);
    
    fclose(fakestdout);
    fclose(fakestderr);
    
    if (size>0) {
        NSString *es = [NSString stringWithContentsOfFile:fepath encoding:NSASCIIStringEncoding error:nil];
        _err = es;
    }
    
    NSMutableString *output = [NSMutableString string];
    NSString *stdoutput = [NSString stringWithContentsOfFile:fopath encoding:NSASCIIStringEncoding error:nil];
    [output appendString:stdoutput];
    if (_err) {
        [output appendString:@"\n"];
        [output appendString:_err];
    }
    
    [[NSFileManager defaultManager] removeItemAtPath:fopath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:fepath error:nil];
    
    return output;
}
@end
