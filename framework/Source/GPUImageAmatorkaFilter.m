#import "GPUImageAmatorkaFilter.h"
#import "GPUImagePicture.h"
#import "GPUImageLookupFilter.h"

@implementation GPUImageAmatorkaFilter

- (id)init;
{
    if (!(self = [super init]))
    {
		return nil;
    }

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    NSData *imageFileData = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"lookup_amatorka" ofType:@"png"]];
    UIImage *image = [[UIImage alloc] initWithData:imageFileData];
//    UIImage *image = [UIImage imageNamed:@"lookup_amatorka.png"];
#else
    NSImage *image = [NSImage imageNamed:@"lookup_amatorka.png"];
#endif
    
    NSAssert(image, @"To use GPUImageAmatorkaFilter you need to add lookup_amatorka.png from GPUImage/framework/Resources to your application bundle.");
    
    lookupImageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageLookupFilter *lookupFilter = [[GPUImageLookupFilter alloc] init];
    [self addFilter:lookupFilter];
    
    [lookupImageSource addTarget:lookupFilter atTextureLocation:1];
    [lookupImageSource processImage];

    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}

-(void)prepareForImageCapture {
    [lookupImageSource processImage];
    [super prepareForImageCapture];
}

-(void)processLookupImage
{
    [lookupImageSource processImage];
}

#pragma mark -
#pragma mark Accessors

@end
