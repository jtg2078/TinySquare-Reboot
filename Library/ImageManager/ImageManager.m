//
//  ImageManager.m
//  IOSBoilerplate
//
//  Copyright (c) 2011 Alberto Gimeno Brieba
//  
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//  

#import "ImageManager.h"
#import "ASIHTTPRequest.h"
#import "AppDelegate.h"
#import "TATabBarController.h"
#import "ASIS3ObjectRequest.h"

@implementation ImageManager

#pragma mark -
#pragma mark define

#define S3_ACCESS_KEY			@"AKIAJJKLYY5AQ3TIZYZQ"
#define S3_SECRET_ACCESS_KEY	@"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"
#define S3_BUCKET				@"ideaegg"
#define S3_IMAGE_FOLDER			@"photos-pro"


#pragma mark -
#pragma mark macro


#pragma mark -
#pragma mark initialization

- (id)init
{
    self = [super init];
    if (self) {
        pendingImages = [[NSMutableArray alloc] initWithCapacity:10];
        loadedImages = [[NSMutableDictionary alloc] initWithCapacity:50];
        downloadQueue = [[NSOperationQueue alloc] init];
        [downloadQueue setMaxConcurrentOperationCount:3];
        hostType = ImageHostTypeHttpGet;
    }
    
    return self;
}

- (void)dealloc {
    [pendingImages release];
    [loadedImages release];
    [downloadQueue release];
    [cache release];
    
    [super dealloc];
}

static ImageManager *sharedSingleton;

+ (void)initialize {
    static BOOL initialized = NO;
    if(!initialized) {
        initialized = YES;
        sharedSingleton = [[ImageManager alloc] init];
    }
}

- (NSString*) cacheDirectory {
	return [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/images/"];
}

+ (UIImage*)loadImage:(NSURL *)url {
    return [sharedSingleton loadImage:url];
}

- (UIImage*)loadImage:(NSURL *)url 
{
    id imagePath = url;
    
    if(hostType == ImageHostTypeHttpAmazonS3)
        imagePath = [url lastPathComponent];
    
	UIImage* img = [loadedImages objectForKey:imagePath];
	
    if (img) {
        return img;
    }
    
    if ([pendingImages containsObject:imagePath]) {
        // already being downloaded
        return nil;
    }
    
    [pendingImages addObject:imagePath];
    
	/*
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    
	
     //Here you can configure a cache system
     
     if (!cache) {
     ASIDownloadCache* _cache = [[ASIDownloadCache alloc] init];
     self.cache = _cache;
     [_cache release];
     [cache setStoragePath:[self cacheDirectory]];
     }
     // [request setDownloadCache:cache];
     // [request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
     // [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
     
     
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(imageDone:)];
    [request setDidFailSelector:@selector(imageWentWrong:)];
    [downloadQueue addOperation:request];
    [request release];
    return nil;
	 */
    
    if(hostType == ImageHostTypeHttpGet)
    {
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(imageDone:)];
        [request setDidFailSelector:@selector(imageWentWrong:)];
        [downloadQueue addOperation:request];
        [request release];
    }
    
    if(hostType == ImageHostTypeHttpAmazonS3)
    {
        NSString *path = [NSString stringWithFormat:@"%@/%@", S3_IMAGE_FOLDER, [url path]];
        ASIS3ObjectRequest *request = [ASIS3ObjectRequest requestWithBucket:S3_BUCKET key:path];
        
        [request setDelegate:self];
        [request setSecretAccessKey:S3_SECRET_ACCESS_KEY];
        [request setAccessKey:S3_ACCESS_KEY];
        [request setDidFinishSelector:@selector(imageDone:)];
        [request setDidFailSelector:@selector(imageWentWrong:)];
        [downloadQueue addOperation:request];
    }
    return nil;
}

- (void)imageDone:(ASIHTTPRequest*)request {
	UIImage* image = [UIImage imageWithData:[request responseData]];
	if (!image) {
		return;
	}
	
	//NSLog(@"image done. %@ cached = %d", [request.originalURL lastPathComponent], [request didUseCachedResponse]);
	if(hostType == ImageHostTypeHttpAmazonS3)
    {
        [pendingImages removeObject:[request.originalURL lastPathComponent]];
        [loadedImages setObject:image forKey:[request.originalURL lastPathComponent]];
    }
    
    if(hostType == ImageHostTypeHttpGet)
    {
        [pendingImages removeObject:request.originalURL];
        [loadedImages setObject:image forKey:request.originalURL];
    }
    
	SEL selector = @selector(imageLoaded:withURL:);
	NSArray* viewControllers = nil;
	
    AppDelegate* delegate = [AppDelegate sharedAppDelegate];
	viewControllers = delegate.tabBarController.viewControllers;
	
	for (UIViewController* vc in viewControllers) {
		if([vc isKindOfClass:[UINavigationController class]]) {
			UINavigationController *uvc = (UINavigationController *)vc;
			for(UIViewController* innerVc in uvc.viewControllers) {
				if ([innerVc respondsToSelector:selector]) {
                    
                    if(hostType == ImageHostTypeHttpAmazonS3)
                    {
                        [innerVc performSelector:selector withObject:image withObject:[request.originalURL lastPathComponent]];
                    }
                    
                    if(hostType == ImageHostTypeHttpGet)
                    {
                        [innerVc performSelector:selector withObject:image withObject:request.originalURL.absoluteString];
                    }
					
				}
			}
		} else {
			if ([vc respondsToSelector:selector]) {
                
                if(hostType == ImageHostTypeHttpAmazonS3)
                {
                    [vc performSelector:selector withObject:image withObject:[request.originalURL lastPathComponent]];
                }
                
                if(hostType == ImageHostTypeHttpGet)
                {
                    [vc performSelector:selector withObject:image withObject:request.originalURL.absoluteString];
                }
			}
		}
	}
}

- (void)imageWentWrong:(ASIHTTPRequest*)request {
	NSLog(@"image went wrong %@", [[request error] localizedDescription]);
    
    if(hostType == ImageHostTypeHttpAmazonS3)
        [pendingImages removeObject:[request.originalURL lastPathComponent]]; // TODO should not try to load the image again for a while
    
    if(hostType == ImageHostTypeHttpGet)
        [pendingImages removeObject:request.originalURL];
}

+ (void) clearMemoryCache {
    [sharedSingleton clearMemoryCache];
}

- (void) clearMemoryCache {
	[loadedImages removeAllObjects];
	[pendingImages removeAllObjects];
}

+ (void) clearCache {
    [sharedSingleton clearCache];
}

- (void) clearCache {
    NSFileManager* fs = [NSFileManager defaultManager];
	// BOOL b = 
	[fs removeItemAtPath:[self cacheDirectory] error:NULL];
    
}

+ (void) clearImage:(NSString *)imageName
{
    [sharedSingleton clearImage:imageName];
}

- (void) clearImage:(NSString *)imageName
{
    if([loadedImages objectForKey:imageName])
    {
        //NSLog(@"image needs to be changed. %@", imageName);
        NSURL *imageUrl = [NSURL URLWithString:imageName];
        
        if(hostType == ImageHostTypeHttpAmazonS3)
            [loadedImages removeObjectForKey:[imageUrl lastPathComponent]];
        
        if(hostType == ImageHostTypeHttpGet)
            [loadedImages removeObjectForKey:imageUrl];
        
        [self loadImage:imageUrl];
    }
}

+ (void) releaseSingleton {
    [sharedSingleton release];
}


@end
