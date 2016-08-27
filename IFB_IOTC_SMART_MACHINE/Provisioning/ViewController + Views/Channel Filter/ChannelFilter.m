/*******************************************************************************
 *
 *               COPYRIGHT (c) 2009-2010 GainSpan Corporation
 *                         All Rights Reserved
 *
 * The source code contained or described herein and all documents
 * related to the source code ("Material") are owned by GainSpan
 * Corporation or its licensors.  Title to the Material remains
 * with GainSpan Corporation or its suppliers and licensors.
 *
 * The Material is protected by worldwide copyright and trade secret
 * laws and treaty provisions. No part of the Material may be used,
 * copied, reproduced, modified, published, uploaded, posted, transmitted,
 * distributed, or disclosed in any way except in accordance with the
 * applicable license agreement.
 *
 * No license under any patent, copyright, trade secret or other
 * intellectual property right is granted to or conferred upon you by
 * disclosure or delivery of the Materials, either expressly, by
 * implication, inducement, estoppel, except in accordance with the
 * applicable license agreement.
 *
 * Unless otherwise agreed by GainSpan in writing, you may not remove or
 * alter this notice or any other notice embedded in Materials by GainSpan
 * or GainSpan's suppliers or licensors in any way.
 *
 * $RCSfile: ServiceList.m,v $
 *
 * Description : Implementaion file for ChannelFilter public/private functions and data structures
 *******************************************************************************/

#import "ChannelFilter.h"

@implementation ChannelFilter

+(NSArray *)getChannelListForFrequency:(float)freq firmwareVersion:(NSString *)version regulatoryDomain:(NSString *)regDomain ClientMode:(BOOL)mode {
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    if  ([version rangeOfString:@"1550" options:NSCaseInsensitiveSearch].location != NSNotFound && (freq == 5.0)) {
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        
        NSString *finalPath = [path stringByAppendingPathComponent:@"ChannelData.plist"];
        
        NSDictionary *channelDataDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
        
        for (NSString *tempKey in channelDataDict) {
                        
            if(mode == NO) {
                                
                if ([[[channelDataDict objectForKey:tempKey] objectForKey:@"DFS"] boolValue] == NO && [[[channelDataDict objectForKey:tempKey] objectForKey:regDomain] boolValue] == YES) {
                                        
                        [tempArray addObject:tempKey];
                }
                
            }
            else {
                
                if ([[[channelDataDict objectForKey:tempKey] objectForKey:regDomain] boolValue] == YES) {
                    
                    [tempArray addObject:tempKey];
                }
                
            }
            
        }
        
    }
    else
    {
        if([regDomain isEqualToString:@"fcc"])
        {
            tempArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",nil];

        }
        else if ([regDomain isEqualToString:@"etsi"])
        {
            tempArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",nil];

        }
        else {
            
            tempArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",nil];

        }
        
    }
    
    
    NSArray * sortedArray = [tempArray sortedArrayUsingComparator:^(id str1, id str2)
    {
        return [(NSString *)str1 compare:(NSString *)str2 options:NSNumericSearch];
    }];
    
    NSMutableArray *lObjArray = [NSMutableArray array];
    
    if(mode == NO)
    {
        [lObjArray addObjectsFromArray:sortedArray];
    }
    else {
     
        [lObjArray addObject:@"Any"];
        [lObjArray addObjectsFromArray:sortedArray];
    }
        
    
    return lObjArray;
}

@end
