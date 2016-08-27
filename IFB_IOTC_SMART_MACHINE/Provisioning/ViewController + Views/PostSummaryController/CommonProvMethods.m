//
//  CommonMethods.m
//  Provisioning
//
//  Created by GainSpan India on 12/01/15.
//
//

#import "CommonProvMethods.h"
#import "GS_ADK_Data.h"


@implementation CommonProvMethods



+(NSString *)getStringForEAPType:(int)_eapType {
    
    GS_ADK_Data *sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];
   
    NSString *lObjString = nil;
    
    if(sharedGsData.isSupportsEAP_Option >= 1)
    {
        switch (_eapType) {
            case 0:
                
                lObjString = @"eap-fast-gtc";
                
                break;
            case 1:
                
                lObjString = @"eap-fast-mschap";
                
                break;
            case 2:
                
                lObjString = @"eap-ttls";
                
                break;
            case 3:
                
                lObjString = @"eap-peap0";
                
                break;
            case 4:
                
                lObjString = @"eap-peap1";
                
                break;
                
            case 5:
                
                lObjString = @"eap-tls";
                
                break;
                
            default:
                break;
        }
    }
    else {
        
        switch (_eapType) {
            case 0:
                
                lObjString = @"eap-fast";
                
                break;
            case 1:
                
                lObjString = @"eap-ttls";
                
                break;
            case 2:
                
                lObjString = @"eap-peap";
                
                break;
            case 3:
                
                lObjString = @"eap-tls";
                
                break;
            default:
                
                return @"";
                
                break;
        }
    }
    
    
    return lObjString;
}


+(NSString *)getBoldStringForEAPType:(int)_eapType {
    
    GS_ADK_Data *sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];
    
    NSString *lObjString = nil;

	if(sharedGsData.isSupportsEAP_Option >= 1)
    {
        switch (_eapType) {

            case 0:

                lObjString = @"EAP-FAST-GTC";

                break;
            case 1:

                lObjString = @"EAP-FAST-MSCHAP";

                break;
            case 2:

                lObjString = @"EAP-TTLS";

                break;
            case 3:

                lObjString = @"EAP-PEAP0";

                break;
            case 4:

                lObjString = @"EAP-PEAP1";

                break;
            case 5:

                lObjString = @"EAP-TLS";

                break;
            default:

                lObjString = @"";

                break;

        }

    }
    else {

        switch (_eapType) {

            case 0:

                lObjString = @"EAP-FAST";

                break;
            case 1:

                lObjString = @"EAP-TTLS";

                break;
            case 2:

                lObjString = @"EAP-PEAP";

                break;
            case 3:

                lObjString = @"EAP-TLS";

                break;
            default:

                lObjString = @"";

                break;

        }

    }

    return lObjString;

}



@end
