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
 * $RCSfile: CertificateBrowser.m,v $
 *
 * Description : Header file for CertificateBrowser functions and data structures
 *******************************************************************************/

#import "CertificateBrowser.h"
#import <QuartzCore/QuartzCore.h>
#import "UINavigationBar+TintColor.h"
#import "Identifiers.h"
#import "UITableView+SpecificFrame.h"

@interface CertificateBrowser(privateMethods)

-(void)copySampleFilesToMyDocumentsFolder;
-(void)selectionDone:(NSString *)selectedFile withPath:(NSString *)selectedFilePath;

@end

@implementation CertificateBrowser

@synthesize m_cObjDelegate;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (void)navigationItemTapped:(NavigationItem)item {
    
    switch (item) {
            
        case NavigationItemBack:
            
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
            
        case NavigationItemCancel:
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            break;
            
        case NavigationItemDone:
            
            [self settingsDone];
            
            break;
            
        case NavigationItemInfo:
            
           // [self showInfo];
            
            break;
            
        case  NavigationItemMode:
            
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark View lifecycle

-(void)setTag:(int)pObjTag
{
    m_cObjTag = pObjTag;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];

    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        
        _statusBarHeightForIOS_7 = 0;
        
    }
    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        _statusBarHeightForIOS_7 = STATUS_BAR_HEIGHT;
        
    }

    self.navigationBar.mode = @"Certificate Browser";
	

	
    m_cObjCertificates = [[NSMutableArray alloc] init];
    
    m_cObjCertificatePaths = [[NSMutableArray alloc] init];
	    
    m_cObjTable = [[UITableView alloc] initWithiOSVersionSpecificMargin:STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT withAdjustment:0 style:UITableViewStyleGrouped];
    
	[m_cObjTable setDataSource:self];
	[m_cObjTable setDelegate:self];
	[self.view addSubview:m_cObjTable];
    
    [self copySampleFilesToMyDocumentsFolder];
}

- (void) copySampleFilesToMyDocumentsFolder {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	NSString *documentsDir = [paths objectAtIndex: 0];
	
	NSArray *filePathsArray = [NSArray arrayWithArray:[[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDir  error:nil]];
		
	for (int i = 0; i < filePathsArray.count; i++) {
				
		NSString *docbinFilePath = [documentsDir stringByAppendingPathComponent:[filePathsArray objectAtIndex:i]];
		
        if ([docbinFilePath rangeOfString:@".text"].location != NSNotFound) {
        
            continue;
        }
				    
                NSArray *lObjArray = [docbinFilePath componentsSeparatedByString:@"/"];
                
                NSString *fileName = [lObjArray objectAtIndex:[lObjArray count]-1];
                
                [m_cObjCertificates addObject:fileName];
                
                [m_cObjCertificatePaths addObject:docbinFilePath];
                
              
            
            [m_cObjTable reloadData];
        
	}
	
}


-(void)settingsDone
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [m_cObjCertificates count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
   // if (cell == nil) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
   
    // }
    
    // Configure the cell...
    
    [cell.textLabel setText:[m_cObjCertificates objectAtIndex:indexPath.row]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[self selectionDone:[m_cObjCertificates objectAtIndex:indexPath.row] withPath:[m_cObjCertificatePaths objectAtIndex:indexPath.row]];
	
}

-(void)selectionDone:(NSString *)selectedFile withPath:(NSString *)selectedFilePath {
    
    [m_cObjDelegate selectCertificate:selectedFile path:selectedFilePath withTag:m_cObjTag];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
	
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}




@end

