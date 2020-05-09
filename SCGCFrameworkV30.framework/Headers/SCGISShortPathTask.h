//
//  SCGISShortPathParams.h
//  SCGCFrameworkV20
//
//  Created by apple  on 14-3-20.
//  Copyright (c) 2014年 scgis. All rights reserved.
//

#import "SCGISUtility.h"

@interface SCGISShortPathParams : NSObject

@property (nonatomic,strong) NSString *urlStr;
@property (nonatomic,strong) AGSPoint *startPoint;
@property (nonatomic,strong) AGSPoint *stopPoint;
@property (nonatomic,strong) NSString *powerColumnName;
@property (nonatomic) BOOL returnDirection;
@property (nonatomic,strong) NSArray *VIAPoints;
@property (nonatomic,strong) NSArray *BarriesPoints;
@property (nonatomic,strong) NSString *token;
@property (nonatomic,assign) id content;

@end


@protocol SCGISShortPathTaskDelegate <NSObject>
@optional
-(void)SCGISShortPathTaskDidJsonCallback:(NSDictionary*) jsonDic Content:(id)content;
-(void)SCGISShortPathTaskDidFail:(NSError*) error responseData:(NSData*)data Content:(id)content;

@end

@interface SCGISShortPathTask : NSObject
@property (nonatomic,assign) id<SCGISShortPathTaskDelegate> delegate;
@property (nonatomic,strong) NSOperationQueue *taskQueue;

-(NSDictionary*) getMeta:(NSString*) urlStr Token:(NSString*)token;
-(void) getMeta:(NSString*) urlStr Token:(NSString*)token Content:(id)content;
-(void) shortPath:(SCGISShortPathParams*) params;
-(void) cancel;
@end