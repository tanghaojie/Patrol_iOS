//
//  SCGISTilemapServerLayer.h
//  SCGCFramework
//
//  Created by apple on 13-4-10.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SCGISUtility.h"
#import "SCGISTilemapArcgisFileOperation.h"
#import "SCGISTilemapSqliteOperation.h"

@interface SCGISTilemapServerLayer : AGSTiledServiceLayer{
    NSString *_serverUrlStr;
    NSString *_tilemapName;
    NSString *_tileFormat;
    AGSEnvelope *_initEnvelope;
    SCGISTilemapCacheType _cacheType;
    int _startLevel;
}

//arcgis
@property (nonatomic,strong) AGSTileInfo *tileInfo;
@property (nonatomic,strong) AGSEnvelope *fullEnvelope;
@property (nonatomic) AGSUnits units;

@property (nonatomic,strong) NSString *token;
@property (nonatomic,assign) SCGISTilemapCacheType cacheType;
@property (nonatomic,assign) int quality;//请求图片的压缩质量(0-100)
//使用服务地址初始化,默认使用arcgis本地格式缓存
-(id) initWithServiceUrlStr:(NSString*) aurlStr Token:(NSString*) atoken;
//使用服务地址和缓存类型初始化
-(id) initWithServiceUrlStr:(NSString*) aurlStr Token:(NSString*) atoken CacheType:(SCGISTilemapCacheType) acacheType;
-(id) initWithServiceUrlStr:(NSString*) aurlStr StartLevel:(int)startLevel StopLevel:(int)stopLevel Token:(NSString*) atoken CacheType:(SCGISTilemapCacheType) acacheType;
@end
