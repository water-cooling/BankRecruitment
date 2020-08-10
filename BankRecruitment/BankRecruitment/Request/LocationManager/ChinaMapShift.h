//
//  ChinaMapShift.h
//  ScenicSpot
//
//  Created by wkx on 14-11-5.
//  Copyright (c) 2014年 jdpay. All rights reserved.
//

#ifndef __ScenicSpot__ChinaMapShift__
#define __ScenicSpot__ChinaMapShift__

typedef struct {
    double lng;
    double lat;
} Location;



#if defined __cplusplus
extern "C" {
#endif
    
    Location transformFromWGSToGCJ(Location wgLoc);
    Location transformFromGCJToWGS(Location gcLoc);
    Location bd_encrypt(Location gcLoc);
    Location bd_decrypt(Location bdLoc);
    
#if defined __cplusplus
};
#endif

#endif /* defined(__ScenicSpot__ChinaMapShift__) */
