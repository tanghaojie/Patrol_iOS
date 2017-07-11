//
//  SCGISDynamicMapTask.h
//  SCGISFramework
//
//  Created by apple on 13-4-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SCGISUtility.h"

typedef enum {
    SCGISDynamicMapMeta,
    SCGISDynamicMapGetMap,
    SCGISDynamicMapIdentify,
    SCGISDynamicMapSearch,
    SCGISDynamicMapSearchCount,
    SCGISDynamicMapBufferSearch,
    SCGISDynamicMapBufferSearchCount,
    SCGISDynamicMapGetThemeMap,
    SCGISDynamicMapThemeIdentify
}SCGISDynamicMapTaskType;



//getmap
@interface SCGISDynamicMapGetMapParams : NSObject {
    
}
@property (nonatomic,strong) NSArray *layers;
@property (nonatomic,strong) AGSEnvelope *boundingBox;
@property (nonatomic) long imageWidth;
@property (nonatomic) long imageHeight;
@property (nonatomic) SCGISMapImageFormat imageFormat;
@property (nonatomic,strong) UIColor *imageBackgroundColor;
@property (nonatomic) BOOL isTransparent;

@property (nonatomic,strong) NSString *urlStr;
@property (nonatomic,strong) NSString *token;
@property (nonatomic,assign) id content;

@end


//Identify
@interface SCGISDynamicMapIdentifyParams : NSObject {
    
}
@property (nonatomic,strong) NSArray *layers;
@property (nonatomic,strong) AGSEnvelope *boundingBox;
@property (nonatomic) long imageWidth;
@property (nonatomic) long imageHeight;
@property (nonatomic) double x;
@property (nonatomic) double y;
@property (nonatomic) long radius;

@property (nonatomic,strong) NSString *urlStr;
@property (nonatomic,strong) NSString *token;
@property (nonatomic,assign) id content;

@end


//Search
@interface SCGISDynamicMapSearchParams : NSObject {
    
}
@property (nonatomic) long layerID;
@property (nonatomic,strong) AGSGeometry *geometry;
@property (nonatomic) SCGISMapSpatialRel spatialRel;
@property (nonatomic,strong) NSString *whereClause;
@property (nonatomic) BOOL isReturnGeometry;
@property (nonatomic,strong) NSArray *outFields;
@property (nonatomic) long startIndex;
@property (nonatomic) long stopIndex;


@property (nonatomic,strong) NSString *urlStr;
@property (nonatomic,strong) NSString *token;
@property (nonatomic,assign) id content;

@end


//BufferSearch
@interface SCGISDynamicMapBufferSearchParams : SCGISDynamicMapSearchParams {
    
}
@property (nonatomic) long radius;
@end



@protocol SCGISDynamicMapTaskDelegate <NSObject>
@optional
-(void)SCGISDynamicMapTaskDidImageCallback:(NSData*) data Content:(id)content;
-(void)SCGISDynamicMapTaskDidJsonCallback:(NSDictionary*) jsonDic Content:(id)content;
-(void)SCGISDynamicMapTaskDidFail:(NSError*) error responseData:(NSData*)data Content:(id)content;

@end

//Task
@interface SCGISDynamicMapTask : NSObject

@property (nonatomic,assign) id<SCGISDynamicMapTaskDelegate> delegate;
@property (nonatomic,strong) NSOperationQueue *taskQueue;

-(NSDictionary*) getMeta:(NSString*) urlStr Token:(NSString*)token;
-(void) getMeta:(NSString*) urlStr Token:(NSString*)token Content:(id)content;
-(void) getMap:(SCGISDynamicMapGetMapParams*) params;
-(void) identify:(SCGISDynamicMapIdentifyParams*) params;
-(void) search:(SCGISDynamicMapSearchParams*) params;
-(void) searchCount:(SCGISDynamicMapSearchParams*) params;
-(void) bufferSearch:(SCGISDynamicMapBufferSearchParams*) params;
-(void) bufferSearchCount:(SCGISDynamicMapBufferSearchParams *)params;
-(void) cancel;

-(void) getThemeMap:(SCGISDynamicMapGetMapParams*) params;
-(void) themeIdentify:(SCGISDynamicMapIdentifyParams*) params;
@end
