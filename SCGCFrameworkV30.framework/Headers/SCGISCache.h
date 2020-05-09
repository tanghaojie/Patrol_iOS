//
//  SCGISCache.h
//  SCGCFramework
//
//  Created by apple  on 13-7-25.
//
//

#import "SCGISUtility.h"

@interface SCGISCache : NSObject{
    NSMutableDictionary *dbDic;//存储地图数据库实例
    NSMutableDictionary *tilemapCacheDic;//存储地图缓存类型
    NSMutableDictionary *tilemapCacheTablenamesDic;//存储地图缓存所有表名称
    NSMutableDictionary *dbConfigDic;//存储地图元数据
    dispatch_semaphore_t semaphore;//标示线程同步
    dispatch_queue_t queue;//多线程运行队列
    
    BOOL isChecked;//标示是否正在检查数据库文件大小
}

+(SCGISCache*) defaultCache;
-(void) clearTileMapCache:(NSString*)tilemapName;
-(void) clearAllTilemapCache;
-(NSString*) bulidCachePath:(NSString*)tilemapName Level:(long)level Row:(long)row Col:(long)col Format:(NSString*)format;
@end
