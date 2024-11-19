import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Box, Input, NoticeBox, Section } from '../components';
import { NtosWindow } from '../layouts';

type Data = {
  valid_id: BooleanLike;
  redeemed_coupons: CouponData[];
  printed_coupons: CouponData[];
};

type CouponData = {
  goody: string;
  discount: number;
};

export const NtosCouponMaster = (props) => {
  const { act, data } = useBackend<Data>();
  const { valid_id, redeemed_coupons = [], printed_coupons = [] } = data;
  return (
    <NtosWindow width={400} height={400}>
      <NtosWindow.Content scrollable>
        {!valid_id ? (
          <NoticeBox danger>未检测到有效的银行账户. 请插入有效ID.</NoticeBox>
        ) : (
          <>
            <NoticeBox info>
              您可以通过右键点击复印机来打印已兑换的优惠券.
            </NoticeBox>
            <Input
              fontSize={1.2}
              placeholder="在此处输入您的优惠码."
              onEnter={(e, value) =>
                act('redeem', {
                  code: value,
                })
              }
            />
            <Section title="兑换优惠券">
              {redeemed_coupons.map((coupon, index) => (
                <Box key={index} className="candystripe">
                  {coupon.goody} ({coupon.discount}% OFF)
                </Box>
              ))}
            </Section>
            <Section title="打印优惠券">
              {printed_coupons.map((coupon, index) => (
                <Box key={index} className="candystripe">
                  {coupon.goody} ({coupon.discount}% OFF)
                </Box>
              ))}
            </Section>
          </>
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};
