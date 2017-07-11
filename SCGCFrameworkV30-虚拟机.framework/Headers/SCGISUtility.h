//
//  SCGCUtility.h
//  SCGCFramework
//
//  Created by apple on 13-4-10.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//
#import <sys/stat.h>
#import <dirent.h>
#import <UIKit/UIKit.h>

#import "LoggerClient.h"
#import "LoggerCommon.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
//#import "ASIHTTPRequest.h"
#import "Reachability.h"

#import <ArcGIS/ArcGIS.h>
#import "SCGISEnum.h"

#define kDefaultTileSize 256



@interface SCGISUtility : NSObject{
    
}
@property (nonatomic,assign) NetworkStatus networkStauts;

+(SCGISUtility*) defaultUtility;

+(void) registerESRI;
+(long long)fileSize:(NSString *)filePath;
+(long long)folderSize:(NSString *)folderPath;

+(void) alertMessage:(NSString*) message controller:(UIViewController*) vc;
+(BOOL) saveDataToFile:(NSData*) data filePath:(NSString*) filePath;
+(BOOL) saveJsonObjectToFile:(NSDictionary*) jsonDic filePath:(NSString*) filePath;
+(BOOL) copyFileAtPath:(NSString*) fromFile ToFile:(NSString*) toFile repeat:(BOOL) isrepeat;
+(NSDictionary*) loadJsonObjectFromFile:(NSString*) filePath;
+(NSDictionary*) loadJsonObjectFromUrl:(NSString *) requestStr;
+(NSData*) nullImage;

@end


@interface SCGISConfig : NSObject

@property (nonatomic,strong) NSString *cacheRootPath;//所有本地缓存的根地址
@property (nonatomic,strong) NSString *tilemapCachePath;//瓦片地图本地缓存路径
@property (nonatomic,strong) NSString *logPath;//日志文件路径
@property (nonatomic,strong) NSString *sqliteTilemapDBName;//sqlite中存储的瓦片名称，所有sqlite应该统一固定该名称
@property (nonatomic,assign) long long maxSingleSqliteSize;//单个sqlite文件的最大大小，单位B,默认1GB
@property (nonatomic,assign) Boolean  isAutoCheckSqliteSize;//自动检查sqlite文件大小，超过最大值后会根据访问频率删除，默认YES

/************瓦片更新机制**************/
/*
 自动更新目前只对在线服务且用sqlite缓存方式生效
 更新原理：
 1.获取本地瓦片信息，若没有信息则请求最新瓦片并缓存到本地，有进行2
 2.获取在线瓦片信息，若没有则直接使用本地瓦片，结束，有进行3
 3.判断在线瓦片时间是否大于本地瓦片时间，大于进行4，否则使用本地瓦片，结束
 4.请求在线瓦片，并缓存到本地(更新数据和时间、频率等字段)
 
 */

@property (nonatomic,assign) Boolean  isAutoUpdateTiles;//是否自动更新瓦片，将会根据时间请求最新图片，默认YES
@property (nonatomic,assign) int requestCaceheExpireDay;//需要缓存的网络数据有效天数


+(SCGISConfig *) defaultConfig;
@end






