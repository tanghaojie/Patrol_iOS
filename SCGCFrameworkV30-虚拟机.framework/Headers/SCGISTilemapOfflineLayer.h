//
//  SCGISTilemapOfflineLayer.h
//  SCGCFramework
//
//  Created by apple on 13-4-26.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SCGISUtility.h"
#import "SCGISTilemapArcgisFileOperation.h"
#import "SCGISTilemapSqliteOperation.h"

@interface SCGISTilemapOfflineLayer : AGSTiledServiceLayer{
    NSString *_tilemapName;
    NSString *_tileFormat;
    SCGISTilemapCacheType _cacheType;
    int _startLevel;
}

//arcgis
@property (nonatomic,strong) AGSTileInfo *tileInfo;
@property (nonatomic,strong) AGSEnvelope *fullEnvelope;
@property (nonatomic,strong) AGSEnvelope *initialEnvelope;
@property (nonatomic) AGSUnits units;

@property (nonatomic,assign) SCGISTilemapCacheType cacheType;

//使用标准级别进行初始化,默认为arcgis本地缓存
-(id) initWithLevel:(int)startLevel stopLevel:(int)stopLevel tilemapName:(NSString*)atilemapName tileFormat:(NSString*)atileFormat initialEnvelope:(AGSEnvelope*)ainitialEnvelope;
//使用标准级别等参数进行初始化
-(id) initWithLevel:(int)startLevel stopLevel:(int)stopLevel tilemapName:(NSString*)atilemapName tileFormat:(NSString*)atileFormat initialEnvelope:(AGSEnvelope*)ainitialEnvelope CacheType:(SCGISTilemapCacheType) acacheType;

//使用瓦片元数据和范围初始化，默认为arcgis本地缓存
-(id) initWithTileInfo:(AGSTileInfo*) atileInfo tilemapName:(NSString*)atilemapName fullEnvelope:(AGSEnvelope*) afullEnvelope initialEnvelope:(AGSEnvelope*)ainitialEnvelope;
//使用瓦片元数据和范围、缓存类型初始化
-(id) initWithTileInfo:(AGSTileInfo*) atileInfo tilemapName:(NSString*)atilemapName fullEnvelope:(AGSEnvelope*) afullEnvelope initialEnvelope:(AGSEnvelope*)ainitialEnvelope CacheType:(SCGISTilemapCacheType) acacheType;

//使用数据库文件进行初始化
-(id) initWithDB:(NSString*)atilemapName;
@end
