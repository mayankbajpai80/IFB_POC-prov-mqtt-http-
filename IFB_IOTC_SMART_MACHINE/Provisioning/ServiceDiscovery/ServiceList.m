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
 * Description : Implementaion file for ServiceList public/private functions and data structures
 *******************************************************************************/

#import "ServiceList.h"
#import "Identifiers.h"
#import "GS_ADK_Data.h"


@interface ServiceList(privateMethods)

-(void)stopActivityIndicator;
-(void)requestURLString:(NSString *)pObjURLString;


@end

@implementation ServiceList

@synthesize m_cObjDict,m_cObjTimer,m_cObjActivity,lObjTableView;

- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate {
    
    self = [super initWithFrame:frame];
	
    if (self) {
		
        // Initialization code.
        
        _delegate = delegate;
		
		[self setBackgroundColor:[UIColor clearColor]];
		
        
        _sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];
		
		lObjTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
		[lObjTableView setDataSource:self];
		[lObjTableView setDelegate:self];
		[self addSubview:lObjTableView];
    }
	
    return self;
	
}

-(void)refreshTableWithData:(NSMutableDictionary *)data
{
    //NSLog(@">>> %@",data);
    /*
     Called each time a discovered service is resolved or removed.
     */
	
	if ([[data allKeys] count] == 0) {
		
		[lObjSuggestionLabel setText:@"No GainSpan Devices found"];
	}
	else {
		
		[lObjSuggestionLabel setText:@"GainSpan Devices discovered\nPlease select one"];
        
	}
    
	m_cObjDict = [[NSMutableDictionary alloc] initWithDictionary:data];
	
	[lObjTableView reloadData];
	
	[m_cObjActivity startAnimating];
        
    if ([[data allKeys] count] != 0) {
	
	m_cObjTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(stopActivityIndicator) userInfo:nil repeats:NO];
    
    }
    
}

-(void)stopActivityIndicator
{
    
    /*
     called eachtime a bonjour discovery update is received.
     */
    if(m_cObjActivity) {
       
        [m_cObjActivity stopAnimating];
    }
}

#pragma mark -
#pragma mark Table view data source


-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *lObjView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 200)];
    
    if (lObjView) {
        
        [lObjView setBackgroundColor:[UIColor clearColor]];

        UIImageView *lObjLogo = [[UIImageView alloc] initWithFrame:CGRectMake(160 - 264/4, STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT + MARGIN, 264/2, 72/2)];
        [lObjLogo setImage:[UIImage imageNamed:@"logo_gainspan.png"]];
        [lObjView addSubview:lObjLogo];
        
        m_cObjActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [m_cObjActivity setFrame:CGRectMake(320/2 - 20/2, lObjLogo.frame.origin.y+lObjLogo.frame.size.height+MARGIN, 20, 20)];
        [m_cObjActivity startAnimating];
        [lObjView addSubview:m_cObjActivity];
        
        lObjSuggestionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100+MARGIN, 300, 80)];
        [lObjSuggestionLabel setTextAlignment:NSTextAlignmentCenter];
        [lObjSuggestionLabel setNumberOfLines:2];
        [lObjSuggestionLabel setText:@"Looking for Devices to Provision"];
        
        //[lObjLabel setText:@"GSLink Devices discovered\nPlease select one"];
        lObjSuggestionLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:14];
        //[lObjSuggestionLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [lObjSuggestionLabel setTextColor:[UIColor darkGrayColor]];
        [lObjSuggestionLabel setBackgroundColor:[UIColor clearColor]];
        [lObjView addSubview:lObjSuggestionLabel];
    }
    
	return lObjView;
    
}


-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
	return 170;
}

//-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
//{	
//	return [self getSectionHeader:section];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
	return [[m_cObjDict allKeys] count];
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
	[cell.textLabel setText:[[m_cObjDict allKeys] objectAtIndex:indexPath.row]];
	[cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
	[cell.textLabel setTextColor:[UIColor colorWithRed:0.2 green:0.5 blue:0.7 alpha:1]];
	[cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    
    return cell;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	return 44;
}

-(void)extractOnlyIPAddress:(NSString *)lObjString {
    
    if (lObjString != nil) {
        
        NSArray *lObjArray = [lObjString componentsSeparatedByString:@":"];
        
        if (lObjArray.count > 0) {
            
            _sharedGsData.currentIPAddress = [[NSString alloc]initWithString:[lObjArray objectAtIndex:0]];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _sharedGsData = (GS_ADK_Data *)[[GS_ADK_Data class] sharedInstance];
    
   // sharedGsData.m_cObjDomainName = [[NSString alloc] initWithString:[[m_cObjDict valueForKey:[[m_cObjDict allKeys] objectAtIndex:indexPath.row]] objectForKey:@"hostName"]];
    _sharedGsData.m_cObjDomainName = [NSString stringWithString:[[m_cObjDict valueForKey:[[m_cObjDict allKeys] objectAtIndex:indexPath.row]] objectForKey:@"hostName"]];
    
    _sharedGsData.m_gObjNodeIP = [NSString stringWithString:[[m_cObjDict valueForKey:[[m_cObjDict allKeys] objectAtIndex:indexPath.row]] objectForKey:@"ipAddress"]];
    
    [self extractOnlyIPAddress:_sharedGsData.m_gObjNodeIP];
        
    if ([[m_cObjDict valueForKey:[[m_cObjDict allKeys] objectAtIndex:indexPath.row]] objectForKey:@"api"] == nil) {
        
        [_delegate requestURLString:[NSString stringWithFormat:@"http://%@/gainspan/system/prov",_sharedGsData.m_gObjNodeIP]];
        
    }
    else
    {
       // NSString *string = [NSString stringWithUTF8String:[[[m_cObjDict valueForKey:[[m_cObjDict allKeys] objectAtIndex:indexPath.row]] objectForKey:@"api"] bytes]];
        
        NSString *string = [[NSString alloc] initWithData:[[m_cObjDict valueForKey:[[m_cObjDict allKeys] objectAtIndex:indexPath.row]] objectForKey:@"api"] encoding:NSUTF8StringEncoding];
        
        NSArray *lObjArray = [NSArray arrayWithArray:[string componentsSeparatedByString:@":"]];
        
        if (lObjArray) {
            
            if (lObjArray.count == 3) {
                
                [_delegate requestURLString:[NSString stringWithFormat:@"http://%@%@",_sharedGsData.m_gObjNodeIP,[lObjArray objectAtIndex:2]]];
                
            }
            
        }
        
    }
}



@end
