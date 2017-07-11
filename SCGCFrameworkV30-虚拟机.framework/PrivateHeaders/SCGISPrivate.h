//
//  NSObject+SCGIS.h
//  SCGCFramework
//
//  Created by apple  on 13-7-25.
//
//

#define kTileFieldData @"TILES"//瓦片数据字段
#define kTileFieldTime @"rtime"//瓦片更新时间字段
#define kTileFieldFreq @"freq"//瓦片访问频率字段

#define kDBTableName @"tablename"//表名称字段
#define kDBConfig   @"config"//元数据字段
#define kDBFullextent @"fullextent"//范围字段
#define kDBMaxRows @"maxroworcol"//每张表最大存储记录数字段

#define kCacheFromDate @"FromDate"//缓存更新时间
#define kCacheExpiredDate @"ExpiredDate"//缓存过期时间

#define kMaxDeleteFreq 10//最大删除瓦片访问频率的次数


#import <UIKit/UIKit.h>
#import <ArcGis/ArcGis.h>
#import "SCGISEnum.h"
#import "SCGISCache.h"
#import "SCGISTilemapSqliteOperation.h"

@interface SCGISCache (Private)

-(void) setTilemapCache:(NSString*)tilemapName CacheType:(SCGISTilemapCacheType) acacheType;

-(FMDatabase*) openDatabase:(NSString*)tilemapName;
-(void) closeDatabase:(NSString*)tilemapName;
-(NSMutableArray*) getDBTablenames:(NSString*)tilemapName;
-(NSString *) getTileTableName:(SCGISTilemapSqliteOperation*)op;
-(NSData*)getTileData:(SCGISTilemapSqliteOperation*)op Tablename:(NSString *)tableName;
-(NSMutableDictionary*) getTileInfo:(SCGISTilemapSqliteOperation*)op Tablename:(NSString *)tableName;
-(void) writeTileData:(SCGISTilemapSqliteOperation*)op Tablename:(NSString*)tableName Data:(NSData*)data Time:(NSDate*)time;
-(NSMutableDictionary*) getDBConfig:(NSString*)tilemapName;
-(NSString*) getDbpath:(NSString*)tilemapName;
@end


@interface SCGISConvert : NSObject
+(NSString*) imageFormat2String:(SCGISMapImageFormat) format;
+(NSString*) spatialRel2String:(SCGISMapSpatialRel) spatialRel;
+(NSString*) boundingBox2JsonString:(AGSEnvelope*)boundingBox;
+(NSString*) geometry2TypeString:(AGSGeometry*)geometry;
+(NSString*) uiColor2HexString:(UIColor*)uicolor;//将uicolor转换成网络十六进制字符串
@end