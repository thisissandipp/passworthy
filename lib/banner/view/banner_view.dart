import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passworthy/banner/banner.dart';
import 'package:passworthy/colors/colors.dart';
import 'package:passworthy/decorators/decorators.dart';
import 'package:passworthy/l10n/l10n.dart';
import 'package:passworthy/typography/typography.dart';

class BannerView extends StatelessWidget {
  const BannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BannerCubit>(
      create: (context) => BannerCubit(),
      child: const BannerWidget(),
    );
  }
}

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<BannerCubit, BannerState>(
      builder: (context, state) {
        if (!state.showBanner) {
          return const SizedBox.shrink();
        }
        return Row(
          spacing: 12,
          children: [
            Expanded(
              child: Text(
                l10n.bannerText,
                style: PassworthyTextStyle.disclaimerText.copyWith(
                  color: PassworthyColors.white,
                  fontWeight: PassworthyFontWeight.semiBold,
                ),
              ).padding(const EdgeInsets.only(left: 16, top: 12, bottom: 12)),
            ),
            GestureDetector(
              onTap: () => context.read<BannerCubit>().removeBanner(),
              child: SizedBox(
                height: 60,
                child: const Icon(Icons.close)
                    .padding(const EdgeInsets.only(right: 20))
                    .decoratedBox(decoration: const BoxDecoration()),
              ),
            ),
          ],
        )
            .decoratedBox(
              decoration: BoxDecoration(
                color: PassworthyColors.darkIndigo,
                borderRadius: BorderRadius.circular(8),
              ),
            )
            .padding(const EdgeInsets.symmetric(horizontal: 16, vertical: 12));
      },
    );
  }
}
