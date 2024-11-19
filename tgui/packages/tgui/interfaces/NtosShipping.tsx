import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { NtosWindow } from '../layouts';

type Data = {
  current_user: string;
  card_owner: string;
  paperamt: number;
  barcode_split: number;
  has_id_slot: BooleanLike;
};

export const NtosShipping = (props) => {
  return (
    <NtosWindow width={450} height={350}>
      <NtosWindow.Content scrollable>
        <ShippingHub />
        <ShippingOptions />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

/** Returns information about the current user, available paper, etc */
const ShippingHub = (props) => {
  const { act, data } = useBackend<Data>();
  const { current_user, card_owner, paperamt, barcode_split } = data;

  return (
    <Section
      title="NTOS船运中心."
      buttons={
        <Button icon="eject" content="取出Id" onClick={() => act('ejectid')} />
      }
    >
      <LabeledList>
        <LabeledList.Item label="当前用户">
          {current_user || 'N/A'}
        </LabeledList.Item>
        <LabeledList.Item label="插入ID卡">
          {card_owner || 'N/A'}
        </LabeledList.Item>
        <LabeledList.Item label="可用纸张">{paperamt}</LabeledList.Item>
        <LabeledList.Item label="销售利润">{barcode_split}%</LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

/** Returns shipping options */
const ShippingOptions = (props) => {
  const { act, data } = useBackend<Data>();
  const { has_id_slot, current_user } = data;

  return (
    <Section title="船运选项">
      <Box>
        <Button
          icon="id-card"
          tooltip="根据当前插入的ID卡更新当前用户."
          tooltipPosition="right"
          disabled={!has_id_slot}
          onClick={() => act('selectid')}
          content="设置当前ID"
        />
      </Box>
      <Box>
        <Button
          icon="print"
          tooltip="为包装好的物品打印条形码."
          tooltipPosition="right"
          disabled={!current_user}
          onClick={() => act('print')}
          content="打印条形码"
        />
      </Box>
      <Box>
        <Button
          icon="tags"
          tooltip="设定你想要在包裹上获得多少利润."
          tooltipPosition="right"
          onClick={() => act('setsplit')}
          content="设定利润率"
        />
      </Box>
      <Box>
        <Button
          icon="sync-alt"
          content="重置ID"
          onClick={() => act('resetid')}
        />
      </Box>
    </Section>
  );
};
