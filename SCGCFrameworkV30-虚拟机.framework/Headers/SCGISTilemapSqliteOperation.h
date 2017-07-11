//
//  SCGISTilemapSqliteOperation.h
//  SCGCFramework
//
//  Created by apple on 13-4-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//


#import "SCGISUtility.h"
#import "FMDatabaseQueue.h"

@interface SCGISTilemapSqliteOperation : NSOperation

@property (nonatomic,strong) AGSTileKey* tile;
@property (nonatomic,strong) NSData *imageData;

@property (nonatomic,strong) id target;
@property (nonatomic,assign) SEL action;

@property (nonatomic,strong) NSString *tilemapName;
@property (nonatomic,strong) NSString *serverUrlStr;
@property (nonatomic,strong) NSString *token;
@property (nonatomic,assign,readonly) BOOL isOnline;
@property (nonatomic) int offsetLevel;//10.0+版本后arcgis将瓦片始终从0级别开始
@property (nonatomic) int quality;//请求图片的压缩质量(0-100)
//使用在线服务
- (id)initWithTile:(AGSTileKey *)atile tilemapName:(NSString*)atilemapName tilemapUrlstr:(NSString*)aurlstr token:(NSString*)atoken offset:(int)aoffset target:(id)atarget action:(SEL)aaction;
//使用离线切片
- (id)initWithTile:(AGSTileKey *)atile tilemapName:(NSString*)atilemapName offset:(int)aoffset target:(id)atarget action:(SEL)aaction;
@end





