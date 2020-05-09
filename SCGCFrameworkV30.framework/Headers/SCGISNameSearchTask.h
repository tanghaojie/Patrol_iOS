//
//  SCGISNameSearchTask.h
//  SCGISFramework
//
//  Created by apple on 13-4-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SCGISUtility.h"

typedef enum {
    SCGISNameSearchMETA = 0,    
    SCGISNameSearchDATA,
    SCGISNameSearchCOUNT
} SCGISNameSearchTaskType;

//地名搜索
@interface SCGISNameSearchParams : NSObject {
    
}
@property (nonatomic,strong) NSString *urlStr;
@property (nonatomic,strong) NSString *keyword;
@property (nonatomic,strong) NSString *typeCode;
@property (nonatomic,strong) NSString *statePac;//市代码，4位
@property (nonatomic,strong) NSString *countyPac;//区县代码,6位
@property (nonatomic) BOOL isOnlyName;
@property (nonatomic,strong) AGSEnvelope *boundingBox;
@property (nonatomic) long startIndex;
@property (nonatomic) long stopIndex;
@property (nonatomic,strong) NSString *token;
@property (nonatomic,assign) id content;

@end

//地名缓冲区搜索
@interface SCGISNameBufferSearchParams : NSObject {
    
}
@property (nonatomic,strong) NSString *urlStr;
@property (nonatomic,strong) NSString *keyword;
@property (nonatomic,strong) NSString *typeCode;
@property (nonatomic,strong) AGSPoint *center;
@property (nonatomic) long radius;
@property (nonatomic) long startIndex;
@property (nonatomic) long stopIndex;
@property (nonatomic,strong) NSString *token;
@property (nonatomic,assign) id content;

@end

@protocol SCGISNameSearchTaskDelegate <NSObject>
@optional
-(void)SCGISNameSearchTaskDidJsonCallback:(NSDictionary*) jsonDic Content:(id)content;
-(void)SCGISNameSearchTaskDidFail:(NSError*) error responseData:(NSData*)data Content:(id)content;

@end

@interface SCGISNameSearchTask : NSObject
@property (nonatomic,assign) id<SCGISNameSearchTaskDelegate> delegate;
@property (nonatomic,strong) NSOperationQueue *taskQueue;

-(NSDictionary*) getMeta:(NSString*) urlStr Token:(NSString*)token;
-(void) getMeta:(NSString*) urlStr Token:(NSString*)token Content:(id)content;
-(void) search:(SCGISNameSearchParams*) params;
-(void) searchCount:(SCGISNameSearchParams*) params;
-(void) bufferSearch:(SCGISNameBufferSearchParams*) params;
-(void) bufferSearchCount:(SCGISNameBufferSearchParams*) params;
-(void) cancel;
@end

