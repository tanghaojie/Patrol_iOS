//
//  SCGISEnum.h
//  SCGCFramework
//
//  Created by apple on 13-4-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//



//缓存地图类型
typedef enum {
    SCGISTilemapCacheTypeNone = 0,//不使用缓存
    SCGISTilemapCacheTypeArcGISFile,//使用arcgis的切片规则保存
    SCGISTilemapCacheTypeSqliteDB//使用sqlite数据库进行保存
} SCGISTilemapCacheType;


//请求图片的类型
typedef enum {
    SCGISMapImageBMP=0,
    SCGISMapImageJPEG,    
    SCGISMapImageGIF,
    SCGISMapImageTIFF,
    SCGISMapImagePNG
} SCGISMapImageFormat;

//使用空间查询的关系
typedef enum {
    SCGISMapSpatialIntersects,
    SCGISMapSpatialContains,
    SCGISMapSpatialOverlaps,
    SCGISMapSpatialWithin
}SCGISMapSpatialRel;


