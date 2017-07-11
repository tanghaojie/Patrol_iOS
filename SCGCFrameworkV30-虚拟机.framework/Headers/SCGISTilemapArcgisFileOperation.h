//
//  SCGISTilemapArcgisFileOperation.h
//  SCGCFramework
//
//  Created by apple  on 13-4-16.
//
//

#import "SCGISUtility.h"

@interface SCGISTilemapArcgisFileOperation : NSOperation


@property (nonatomic,strong) AGSTileKey* tile;
@property (nonatomic,strong) NSData *imageData;

@property (nonatomic,strong) id target;
@property (nonatomic,assign) SEL action;

@property (nonatomic,strong) NSString *tilemapName;
@property (nonatomic,strong) NSString *serverUrlStr;
@property (nonatomic,strong) NSString *tileFormat;
@property (nonatomic,strong) NSString *token;
@property (nonatomic,assign,readonly) BOOL isOnline;
@property (nonatomic,assign,readonly) BOOL isCache;
@property (nonatomic) int offsetLevel;//10.0+版本后arcgis将瓦片始终从0级别开始
@property (nonatomic) int quality;//请求图片的压缩质量(0-100)
//使用在线服务
- (id)initWithTile:(AGSTileKey *)atile tilemapUrlstr:(NSString*)aurlstr token:(NSString*)atoken offset:(int)aoffset target:(id)atarget action:(SEL)aaction;
//使用在线服务和缓存
- (id)initWithTile:(AGSTileKey *)atile tilemapName:(NSString*)atilemapName tilemapUrlstr:(NSString*)aurlstr tileFormat:(NSString*)atileFormat token:(NSString*)atoken offset:(int)aoffset target:(id)atarget action:(SEL)aaction;
//使用离线切片
- (id)initWithTile:(AGSTileKey *)atile tilemapName:(NSString*)atilemapName tileFormat:(NSString*)atileFormat offset:(int)aoffset target:(id)atarget action:(SEL)aaction;
@end
