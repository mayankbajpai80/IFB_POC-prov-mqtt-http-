/*******************************************************************************
 *
 *               COPYRIGHT (c) 2012-2014 GainSpan GainSpan Corporation
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
 * $RCSfile: GS_ADK_ServiceManager.m,v $
 *
 * Description : Header file for GS_ADK_ServiceManager functions and data structures
 *******************************************************************************/

#import "GS_ADK_ServiceManager.h"
#import "ServiceData.h"
#import "GS_ADK_Service.h"

@interface GS_ADK_ServiceManager (privateMehods) <GS_ADK_ServiceDelegate,NSNetServiceBrowserDelegate>

-(void)stopService;

@end

//static GS_ADK_Service *m_cObjService;

@implementation GS_ADK_ServiceManager

//@synthesize m_cObjDelegate;

-(id)initWithTimeOut:(float)pObjTimeOut namePattern:(NSArray *)pObjNamePatterns textRecordPattern:(NSArray *)pObjTextRecordPatterns serviceType:(NSString *)pObjServiceType domainName:(NSString *)pObjDomainName;
{
	
    if ((self = [super init])) {
		
        m_cObjTimeOut = pObjTimeOut;
        
        
        if (pObjNamePatterns == nil || pObjServiceType == nil || pObjDomainName == nil) {
            
            return nil;
        }
        
        if (![pObjNamePatterns isKindOfClass:[NSArray class]]) {
            
            return nil;
        }
        
        if (![pObjServiceType isKindOfClass:[NSString class]] || ![pObjDomainName isKindOfClass:[NSString class]]) {
            
            return nil;
            
        }
        
		_m_cObjService = [[GS_ADK_Service alloc] initWithNamePattern:pObjNamePatterns textRecordPattern:pObjTextRecordPatterns];
		
        [_m_cObjService setM_cObjDelegate:self];
        
        m_cObjServiceType = [[NSString alloc] initWithString:pObjServiceType];
        
        m_cObjDomainName = [[NSString alloc] initWithString:pObjDomainName];
        
        _serviceArray = [NSMutableArray new];
        
        _serviceCount = 0;
	}
    
    return self;
	
}

-(void)startDiscovery {
    
    if (_serviceArray) {
        
        [_serviceArray removeAllObjects];
    }
	
	bonjourBrowser = [[NSNetServiceBrowser alloc] init];
	[bonjourBrowser setDelegate: self];
    [bonjourBrowser searchForServicesOfType:m_cObjServiceType inDomain:m_cObjDomainName]; 
}

-(void)stopDiscovery {
    
	[bonjourBrowser stop];
	[bonjourBrowser setDelegate:nil];
	//[bonjourBrowser release];
	bonjourBrowser = nil;
	
	[self stopService];
    

}

-(void)stopService {
    
	_m_cObjService = nil;
    
}

-(void)isResolveService {
    
    _serviceCount++;
    
    [self resolveServiceAddresses];
}

-(void)resolveServiceAddresses {
    
    if (_serviceCount < _serviceArray.count) {
        
        NSNetService *lObjNetService = [_serviceArray objectAtIndex:_serviceCount];
        
        [_m_cObjService serviceWithDomain:[lObjNetService domain] type:[lObjNetService type] name:[lObjNetService name] timeOut:m_cObjTimeOut];

    }
}

// bonjour delegate methods

- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)netServiceBrowser {
	
    if(m_cObjTimeOut!=0.0)
    {
        m_cObjTimer = [NSTimer scheduledTimerWithTimeInterval:m_cObjTimeOut target:self selector:@selector(checkDiscoveryStatus) userInfo:nil repeats:NO];
    }
	
}

-(void)checkDiscoveryStatus {
	
	if ([_m_cObjService serviceCount] == 0) {
		
		[_m_cObjDelegate discoveryDidFail];
	}
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)netServiceBrowser {
	
    
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didNotSearch:(NSDictionary *)errorInfo {
    
	[_m_cObjDelegate discoveryDidFail];

	
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing {
	
    NSLog(@"didFindService = %@",netService.name);
    
    [_serviceArray addObject:netService];

    if (!moreServicesComing) {
        
        [self resolveServiceAddresses];
    }
    //[self ]
    
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing {
	
    
	[_m_cObjService removeService:netService];
    
    
    if ([_m_cObjService serviceCount] == 0 && m_cObjTimeOut!=0.0) {
		
        m_cObjTimer = [NSTimer scheduledTimerWithTimeInterval:m_cObjTimeOut target:self selector:@selector(checkDiscoveryStatus) userInfo:nil repeats:NO];
	}
}

-(void)didUpdateSeriveInfo:(NSDictionary *)pObjServiceInfo {

	[_m_cObjDelegate didUpdateSeriveInfo:pObjServiceInfo];
    
}

@end
