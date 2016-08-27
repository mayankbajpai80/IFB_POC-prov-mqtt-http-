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
 * $RCSfile: UniversalParser.m,v $
 *
 * Description : Implementaion file for UniversalParser public/private functions and data structures
 *******************************************************************************/

#import "UniversalParser.h"

NSString *const kXMLReaderTextNodeKey = @"text";


@interface UniversalParser (privateMethods)

- (NSMutableDictionary *)objectWithData:(NSData *)data;

@end

@implementation UniversalParser

- (NSMutableDictionary *)dictionaryForXMLData:(NSData *)data
{
    NSMutableDictionary *rootDictionary = [self objectWithData:data];

    return rootDictionary;
}

- (NSMutableDictionary *)objectWithData:(NSData *)data
{
    // Clear out any old data
	
    
    dictionaryStack = [[NSMutableArray alloc] init];
    textInProgress = [[NSMutableString alloc] init];
    
	
    // Initialize the stack with a fresh dictionary
	
    [dictionaryStack addObject:[NSMutableDictionary dictionary]];
    
	
    // Parse the XML
	
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    BOOL success = [parser parse];
    
	
    // Return the stack’s root dictionary on success
    if (success)
    {
        NSMutableDictionary *resultDict = [dictionaryStack objectAtIndex:0];
        return resultDict;
    }
    
    return nil;
}

#pragma mark -
#pragma mark NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSMutableDictionary *)attributeDict
{
    // Get the dictionary for the current level in the stack
    
	NSMutableDictionary *parentDict = [dictionaryStack lastObject];
    
	
    // Create the child dictionary for the new element, and initilaize it with the attributes
    
	NSMutableDictionary *childDict = [NSMutableDictionary dictionary];
    [childDict addEntriesFromDictionary:attributeDict];
    
	
    // If there’s already an item for this key, it means we need to create an array
    
	id existingValue = [parentDict objectForKey:elementName];
    
	if (existingValue)
    {
    
		NSMutableArray *array = nil;
        
		if ([existingValue isKindOfClass:[NSMutableArray class]])
        {
            
			// The array exists, so use it
            array = (NSMutableArray *) existingValue;
        
		}
        else
        {
        
			// Create an array if it doesn’t exist
            array = [NSMutableArray array];
            [array addObject:existingValue];
            
            // Replace the child dictionary with an array of children dictionaries
            [parentDict setObject:array forKey:elementName];
        
		}
        
        // Add the new child dictionary to the array
        [array addObject:childDict];
    
	}
    else
    {
    
		// No existing value, so update the dictionary
        [parentDict setObject:childDict forKey:elementName];

    }
    
    // Update the stack
    [dictionaryStack addObject:childDict];

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
	// Update the parent dict with text info
    
	NSMutableDictionary *dictInProgress = [dictionaryStack lastObject];
    
	
    // Set the text property
    
	if ([textInProgress length] > 0)
    {
    
		// Get rid of leading + trailing whitespace
        
        [textInProgress stringByReplacingOccurrencesOfString:@" " withString:@""];
        [textInProgress stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        [textInProgress stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        [textInProgress stringByReplacingOccurrencesOfString:@"\n" withString:@""];

        
		[dictInProgress setObject:textInProgress forKey:kXMLReaderTextNodeKey];
        
        // Reset the text
        
        
		textInProgress = [[NSMutableString alloc] init];
    }
    
	
    // Pop the current dict
    
	[dictionaryStack removeLastObject];

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{

    // Build the text value
    
	[textInProgress appendString:string];

}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{

    // Set the error pointer to the parser’s error object
  
	//  *errorPointer = parseError;

}

@end
