
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../model/shop_model.dart';
import '../state_management/choose_shop_state.dart';
import '../style/general_style.dart';
import '../utils/enums.dart';
import 'my_inkwell.dart';
import 'my_label.dart';

class MyChooseShopTile extends ConsumerWidget {

  final MyChooseShopTileType type;
  final int? index;
  final ShopModel? shop;
  final Function()? onTap;

  const MyChooseShopTile({super.key, required this.type, this.index, this.shop, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (type) {
      case MyChooseShopTileType.GENERAL:
        return generalChooseShopTile(index!,shop!,ref,onTap);
      case MyChooseShopTileType.SHIMMER:
        return shimmerChooseShopTile();
      default:
        return Container();
    }
  }

  Widget generalChooseShopTile(int index,ShopModel shop,WidgetRef ref,Function()? onTap){
    int currentIndex = ref.watch(currentShopIndexProvider);
    return MyInkwell(
      type: MyInkwellType.GENERAL,
      widget: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: index == currentIndex ? blue : light1,
          border: Border.all(
              width: 1.w,
              color: light1,
              strokeAlign: BorderSide.strokeAlignCenter),
          borderRadius: BorderRadius.circular(16.0).r,
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16).r,
                    child: Image.memory(
                      frameBuilder: (BuildContext context, Widget child, int? frame, bool? wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded!) {
                          return child;
                        }
                        return AnimatedOpacity(
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(seconds: 1),
                          curve: Curves.linear,
                          child: child,
                        );
                      },
                      shop.imageUnit8list!,
                      width: 110.h,
                      height: 110.h,
                      fit: BoxFit.cover
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on,size: 10.sp,color: index == currentIndex ? light1 : blue),
                      SizedBox(width: 6.w),
                      MyLabel(
                        type: MyLabelType.BODY_XSMALL,
                        label: '${shop.city}, ${shop.state}',
                        fontWeight: MyLabel.MEDIUM,
                        color: index == currentIndex ? grey300 : grey800,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  MyLabel(
                    type: MyLabelType.H6,
                    label: shop.name,
                    fontWeight: MyLabel.BOLD,
                    color: index == currentIndex ? light1 : grey800,
                  ),
                  SizedBox(height: 8.h),
                  MyLabel(
                    type: MyLabelType.BODY_SMALL,
                    label: 'Obter direções',
                    fontWeight: MyLabel.MEDIUM,
                    color: index == currentIndex ? grey300 : blue,
                  )
                ]
              )
            ]
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget shimmerChooseShopTile(){
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: light1,
        border: Border.all(
            width: 1.w,
            color: light1,
            strokeAlign: BorderSide.strokeAlignCenter),
        borderRadius: BorderRadius.circular(16.0).r,
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Shimmer.fromColors(
              baseColor: grey300,
              highlightColor: grey100,
              child: Container(
                width: 110.h,
                height: 110.h,
                decoration: BoxDecoration(
                    color: light1,
                    borderRadius: BorderRadius.all(const Radius.circular(16).r)
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: grey300,
                  highlightColor: grey100,
                  child: Container(
                    width: 150.w,
                    decoration: BoxDecoration(
                        color: light1,
                        borderRadius: BorderRadius.all(const Radius.circular(16).r)
                    ),
                    child: const MyLabel(
                      type: MyLabelType.BODY_XSMALL,
                      label: 'Porto, Paços de Ferreira',
                      fontWeight: MyLabel.MEDIUM,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Shimmer.fromColors(
                  baseColor: grey300,
                  highlightColor: grey100,
                  child: Container(
                    width: 100.w,
                    decoration: BoxDecoration(
                        color: light1,
                        borderRadius: BorderRadius.all(const Radius.circular(16).r)
                    ),
                    child: const MyLabel(
                      type: MyLabelType.BODY_XSMALL,
                      label: 'Porta 54',
                      fontWeight: MyLabel.MEDIUM,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Shimmer.fromColors(
                  baseColor: grey300,
                  highlightColor: grey100,
                  child: MyLabel(
                    type: MyLabelType.BODY_SMALL,
                    label: 'Obter direções',
                    fontWeight: MyLabel.MEDIUM,
                    color: blue,
                  ),
                ),
              ],
            )
          ]
        ),
      ),
    );
  }
}