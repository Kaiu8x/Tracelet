#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "ProtoRPC/ProtoMethod.h"
#import "ProtoRPC/ProtoRPC.h"
#import "ProtoRPC/ProtoService.h"

FOUNDATION_EXPORT double ProtoRPCVersionNumber;
FOUNDATION_EXPORT const unsigned char ProtoRPCVersionString[];

