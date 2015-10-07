//
//  PhotoPerson.h
//  运维通
//
//  Created by ritacc on 15/10/3.
//  Copyright (c) 2015年 ritacc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController (Extension)

-(void)SelectImg;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
#pragma mark camera utility

- (BOOL) isCameraAvailable;
- (BOOL) isRearCameraAvailable;
- (BOOL) isFrontCameraAvailable;
- (BOOL) doesCameraSupportTakingPhotos;
- (BOOL) isPhotoLibraryAvailable;
- (BOOL) canUserPickVideosFromPhotoLibrary;
- (BOOL) canUserPickPhotosFromPhotoLibrary;
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType;
- (UIImage *)fixOrientation:(UIImage *)aImage;

@end
