////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "NSObject+PropertyInjection.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonStringUtils.h"
#import <objc/message.h>

#import "NSInvocation+TCFUnwrapValues.h"
#import "TyphoonIntrospectionUtils.h"

@implementation NSObject (PropertyInjection)

- (void)typhoon_injectValue:(id)value forPropertyName:(NSString *)propertyName
{
    SEL setterSelector = [TyphoonIntrospectionUtils setterForPropertyWithName:propertyName inClass:[self class]];

    if (!setterSelector) {
        [NSException raise:@"PropertyInjectionException" format:@"Can't inject property '%@' for object '%@'. Setter selector not found. Make sure that property exists and writable",propertyName, self];
    }
    
    NSMethodSignature *signature = [self methodSignatureForSelector:setterSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:setterSelector];
    [invocation typhoon_setArgumentObject:value atIndex:2];
    [invocation invokeWithTarget:self];
}


@end
