@class QBImagePickerAssetView;

@protocol QBImagePickerAssetViewDelegate <NSObject>

@required
- (BOOL)assetViewCanBeSelected:(QBImagePickerAssetView *)assetView;
- (void)assetView:(QBImagePickerAssetView *)assetView didChangeSelectionState:(BOOL)selected;

@end
