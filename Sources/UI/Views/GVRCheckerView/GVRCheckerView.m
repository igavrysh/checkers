//
//  GVRCheckerView.m
//  Checkers
//
//  Created by Ievgen on 1/15/17.
//  Copyright © 2017 Gavrysh. All rights reserved.
//

#import "GVRCheckerView.h"

#import "GVRObjectsCache.h"

#import "UIImage+GVRNegativeImage.h"

#import "GVRMacros.h"

kGVRStringVariableDefinition(GVRBlackKingImageKey, @"GVRBlackKingImageKey");
kGVRStringVariableDefinition(GVRWhiteKingImageKey, @"GVRWhiteKingImageKey");
kGVRStringVariableDefinition(GVRBlackKingFileName, @"king_black_icon.png");
kGVRStringVariableDefinition(GVRWhiteKingFileName, @"king_white_icon.png");

const float checkerToCellRatio = 0.8;
const float rectToImageRatio = 0.6;

@interface GVRCheckerView ()
@property (nonatomic, assign)   NSUInteger          row;
@property (nonatomic, assign)   NSUInteger          column;
@property (nonatomic, readonly) GVRBoardPosition    *position;
@property (nonatomic, weak)     GVRBoard            *board;
@property (nonatomic, weak)     GVRBoardView        *boardView;
@property (nonatomic, assign)   float               cellSize;
@property (nonatomic, strong)   UIImage             *kingImage;

- (void)addKingSign;

- (UIImage *)checkerKingImage;

@end

@implementation GVRCheckerView

@dynamic position;

#pragma mark -
#pragma mark Public Methods

+ (instancetype)checkerOnCell:(GVRBoardCell)cell
                     cellSize:(float)cellSize
                        board:(GVRBoard *)board
                    boardView:(GVRBoardView *)boardView
{
    return [[self alloc] initWithCell:cell
                             cellSize:cellSize
                                board:board
                            boardView:boardView];
}

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithCell:(GVRBoardCell)cell
                    cellSize:(float)cellSize
                       board:(GVRBoard *)board
                   boardView:(GVRBoardView *)boardView
{
    self = [super init];
    if (self) {
        self.row = cell.row;
        self.column = cell.column;
        self.board = board;
        self.boardView = boardView;
        self.cellSize = cellSize;
        
        self.kingImage = [self checkerKingImage];
        
        [self initChecker];
    }
    
    return self;
}

- (void)initChecker {
    float cellSize = self.cellSize;
    
    float size = cellSize * checkerToCellRatio;
    float origin = (cellSize * (1 - checkerToCellRatio)) / 2.f;
    float originX = self.row * cellSize + origin;
    float originY = self.column * cellSize + origin;
    
    CGRect checkerRect = CGRectMake(originX, originY, size, size);
    
    [self setFrame:checkerRect];
    
    self.backgroundColor = self.color;
    self.tag = GVRSubViewTagChecker;
    
    self.layer.cornerRadius = size / 2.f;
    
    GVRChecker *checker = self.position.checker;
    
    if (GVRCheckerTypeMan == checker.type) {
        
    } else if (GVRCheckerTypeKing == checker.type) {
        [self addKingSign];
    }
}

#pragma mark -
#pragma mark Accessors

- (UIColor *)color {
    GVRCheckerColor color = self.position.checker.color;
    
    return color == GVRCheckerColorWhite
        ? [UIColor whiteColor]
        : color == GVRCheckerColorBlack
            ? [UIColor blackColor]
            : [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
}

- (GVRBoardPosition *)position {
    return [self.board positionForCell:GVRBoardCellMake(self.row, self.column)];
}

#pragma mark -
#pragma mark Private Methods

- (void)addKingSign {
    float width = self.bounds.size.width;
    float size = width * rectToImageRatio;
    CGRect imageRect = CGRectMake(width * (1 - rectToImageRatio) / 2.f,
                                  width * (1 - rectToImageRatio) / 2.f,
                                  size,
                                  size);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageRect];
    imageView.image = self.kingImage;
    
    [self addSubview:imageView];
}

- (UIImage *)checkerKingImage {
    GVRObjectsCache *cache = [GVRObjectsCache cache];
    
    UIImage *image = nil;
    
    GVRChecker *checker = self.position.checker;
    NSString *imageKey;
    NSString *fileName;
    
    if (GVRCheckerColorWhite == checker.color) {
        imageKey = GVRWhiteKingImageKey;
        fileName = GVRWhiteKingFileName;
        
    } else if (GVRCheckerColorBlack == checker.color) {
        imageKey = GVRBlackKingImageKey;
        fileName = GVRBlackKingFileName;
    }
    
    image = [cache objectForKey:imageKey];
    
    if (image) {
        return image;
    }
    
    image = [UIImage imageNamed:fileName];
    
    if (GVRCheckerColorBlack == checker.color) {
        image = [image negativeImage];
    }
    
    image = [[UIImage alloc] initWithCGImage:image.CGImage
                                       scale:0.8
                                 orientation:UIImageOrientationRight];
    
    [cache setObject:image forKey:imageKey];
    
    return image;
}

@end
