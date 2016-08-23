//
//  NameCardViewController.m
//  LifeHelper
//
//  Created by shadandan on 16/8/23.
//  Copyright © 2016年 SDD. All rights reserved.
//

#import "NameCardViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AddressBookHelper.h"

@interface NameCardViewController()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *_imagePickerController;
    
}

@property(nonatomic,weak)UIImageView *imageView;
@end
@implementation NameCardViewController
-(void)viewDidLoad{
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self createView];
   
}

#pragma mark-创建imageView 和两个button
-(void)createView{

    CGFloat w=kScreenWidth*0.8;
    CGFloat h=w;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth*0.1, 84, w, h)];
    imageView.image=[UIImage imageNamed:@"nameCard"];
    [self.view addSubview:imageView];
    self.imageView=imageView;
    
    CGFloat margin=10;
    CGFloat btnW=50;
    CGFloat btnX1=(kScreenWidth*0.5-btnW)*0.5;
    CGFloat btnX2=kScreenWidth*0.5+btnX1;
    CGFloat btnY=CGRectGetMaxY(imageView.frame)+margin;
    CGFloat btnH=30;
    UIButton *cameraBtn=[[UIButton alloc]initWithFrame:CGRectMake(btnX1, btnY, btnW, btnH)];
    [cameraBtn setImage:[UIImage imageNamed:@"bg_uploadimage_addimage_takephoto"] forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(createCameraModel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraBtn];
    UIButton *albumBtn=[[UIButton alloc]initWithFrame:CGRectMake(btnX2, btnY, btnW, btnH)];
    [albumBtn setImage:[UIImage imageNamed:@"bg_uploadimage_addimage"] forState:UIControlStateNormal];
    [albumBtn addTarget:self action:@selector(selectImageFromAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:albumBtn];
}
#pragma mark-创建照相机视图
-(void)createCameraModel{
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;//模态翻转效果
    _imagePickerController.allowsEditing = YES;
    _imagePickerController.allowsImageEditing=YES;
    [self selectImageFromCamera];
}


#pragma mark -从摄像头获取图片或视频
- (void)selectImageFromCamera
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //录制视频时长，默认10s
    _imagePickerController.videoMaximumDuration = 15;
    
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    
    //视频上传质量
    //UIImagePickerControllerQualityTypeHigh高清
    //UIImagePickerControllerQualityTypeMedium中等质量
    //UIImagePickerControllerQualityTypeLow低质量
    //UIImagePickerControllerQualityType640x480
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    //设置摄像头模式（拍照，录制视频）为拍照模式
    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}
#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum
{
    //NSLog(@"相册");
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}
#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
}
//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //如果是图片
        self.imageView.image = info[UIImagePickerControllerEditedImage];
                //压缩图片
                NSData *fileData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
                //保存图片至相册
                UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                //上传图片
                [self uploadImageWithData:fileData];
        
            }else{
        //        //如果是视频
        //        NSURL *url = info[UIImagePickerControllerMediaURL];
        //        //播放视频
        //        _moviePlayer.contentURL = url;
        //        [_moviePlayer play];
        //        //保存视频至相册（异步线程）
        //        NSString *urlStr = [url path];
        //
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
        //
        //                UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        //            }
        //        });
        //        NSData *videoData = [NSData dataWithContentsOfURL:url];
        //        //视频上传
        //        [self uploadVideoWithData:videoData];
           }
            [self dismissViewControllerAnimated:YES completion:nil];
    }
-(void)uploadImageWithData:fileData{
    
}
#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
        NSLog(@"保存完毕");
}

#pragma mark 视频保存完毕的回调
    //- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInf{
    //    if (error) {
    //        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    //    }else{
    //        NSLog(@"视频保存成功.");
    //    }
    //}
#pragma mark-保存到通讯录相关
-(void)savePerson{
    NSString *phone = @"222222341";
    
    if ([AddressBookHelper existPhone:phone] == ABHelperExistSpecificContact)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息提示" message:[NSString stringWithFormat:@"手机号码：%@已存在通讯录",phone] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        if ([AddressBookHelper addContactName:@"刘德华" phoneNum:phone withLabel:@"测试"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"消息提示" message:@"添加到通讯录成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        };
    }
}
@end
