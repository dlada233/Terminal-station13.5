// THIS IS A SKYRAT UI FILE
import { toTitleCase } from 'common/string';
import { useState } from 'react';

import { useBackend, useSharedState } from '../backend';
import {
  Box,
  Button,
  Flex,
  NoticeBox,
  NumberInput,
  ProgressBar,
  RoundGauge,
  Section,
  Stack,
  Table,
  Tabs,
  Tooltip,
} from '../components';
import { Window } from '../layouts';

export const AmmoWorkbench = (props) => {
  const [tab, setTab] = useSharedState('tab', 1);
  return (
    <Window width={600} height={600} theme="hackerman" title="弹药工作台">
      <Window.Content scrollable>
        <Tabs>
          <Tabs.Tab selected={tab === 1} onClick={() => setTab(1)}>
            弹药
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 2} onClick={() => setTab(2)}>
            材料
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 3} onClick={() => setTab(3)}>
            数据盘
          </Tabs.Tab>
        </Tabs>
        {tab === 1 && <AmmunitionsTab />}
        {tab === 2 && <MaterialsTab />}
        {tab === 3 && <DatadiskTab />}
      </Window.Content>
    </Window>
  );
};

export const AmmunitionsTab = (props) => {
  const { act, data } = useBackend();
  const {
    mag_loaded,
    system_busy,
    hacked,
    error,
    error_type,
    mag_name,
    turboBoost,
    current_rounds,
    max_rounds,
    efficiency,
    time,
    caliber,
    available_rounds = [],
  } = data;
  return (
    <>
      {!!error && (
        <NoticeBox textAlign="center" color={error_type}>
          {error}
        </NoticeBox>
      )}
      <Section title="机器设置">
        <Box inline mr={4}>
          当前效率:{' '}
          <RoundGauge
            value={efficiency}
            minValue={1.6}
            maxValue={1}
            format={() => null}
          />
        </Box>
        <Box>每发生产时间: {time} 秒</Box>
        <Button.Checkbox
          textAlign="right"
          checked={turboBoost}
          onClick={() => act('turboBoost')}
        >
          涡轮增压
        </Button.Checkbox>
      </Section>
      <Section
        title="已装载弹匣"
        buttons={
          <>
            {!!mag_loaded && (
              <Box inline mr={2}>
                <ProgressBar
                  value={current_rounds}
                  minValue={0}
                  maxValue={max_rounds}
                />
              </Box>
            )}
            <Button
              icon="eject"
              content="取出"
              disabled={!mag_loaded}
              onClick={() => act('EjectMag')}
            />
          </>
        }
      >
        {!!mag_loaded && <Box>{mag_name}</Box>}
        {!!mag_loaded && (
          <Box bold textAlign="right">
            {current_rounds} / {max_rounds}
          </Box>
        )}
      </Section>
      <Section title="可用弹药类型">
        {!!mag_loaded && (
          <Flex.Item grow={1} basis={0}>
            {available_rounds.map((available_round) => (
              <Box
                key={available_round.name}
                className="candystripe"
                p={1}
                pb={2}
              >
                <Stack.Item>
                  <Tooltip
                    content={available_round.mats_list}
                    position={'right'}
                  >
                    <Button
                      content={available_round.name}
                      disabled={system_busy}
                      onClick={() =>
                        act('FillMagazine', {
                          selected_type: available_round.typepath,
                        })
                      }
                    />
                  </Tooltip>
                </Stack.Item>
              </Box>
            ))}
          </Flex.Item>
        )}
      </Section>
      {!!hacked && (
        <NoticeBox textAlign="center" color="bad">
          !警告! - ARMADYNE安全协议未启用! 可能造成的误用后果将不在保修范围内.
          某些弹药类型可能在您所在区域构成战争罪.请立刻联系ARMADYNE管理人员.
        </NoticeBox>
      )}
    </>
  );
};

export const MaterialsTab = (props) => {
  const { act, data } = useBackend();
  const { materials = [] } = data;
  return (
    <Section title="材料">
      <Table>
        {materials.map((material) => (
          <MaterialRow
            key={material.id}
            material={material}
            onRelease={(amount) =>
              act('Release', {
                id: material.id,
                sheets: amount,
              })
            }
          />
        ))}
      </Table>
    </Section>
  );
};

export const DatadiskTab = (props) => {
  const { act, data } = useBackend();
  const {
    loaded_datadisks = [],
    datadisk_loaded,
    datadisk_name,
    datadisk_desc,
    disk_error,
    disk_error_type,
  } = data;
  return (
    <>
      {!!disk_error && (
        <NoticeBox textAlign="center" color={disk_error_type}>
          {disk_error}
        </NoticeBox>
      )}
      <Section
        title="数据盘"
        buttons={
          <>
            <Button
              icon="save"
              content="加载数据盘"
              disabled={!datadisk_loaded}
              onClick={() => act('ReadDisk')}
            />
            <Button
              icon="eject"
              content="取出"
              disabled={!datadisk_loaded}
              onClick={() => act('EjectDisk')}
            />
          </>
        }
      >
        {!!datadisk_loaded && (
          <Box>
            已插入数据盘: {datadisk_name}
            <Box>描述: {datadisk_desc}</Box>
          </Box>
        )}
      </Section>
      <Section title="已加载数据盘">
        <Table>
          {loaded_datadisks.map((loaded_datadisk) => (
            <Box key={loaded_datadisk.loaded_disk_name}>
              {loaded_datadisk.loaded_disk_name}
              <Box textAlign="right">
                描述: {loaded_datadisk.loaded_disk_desc}
              </Box>
            </Box>
          ))}
        </Table>
      </Section>
    </>
  );
};

const MaterialRow = (props) => {
  const { material, onRelease } = props;

  const [amount, setAmount] = useState(1);

  const amountAvailable = Math.floor(material.amount);
  return (
    <Table.Row>
      <Table.Cell>{toTitleCase(material.name)}</Table.Cell>
      <Table.Cell collapsing textAlign="right">
        <Box mr={2} color="label" inline>
          {amountAvailable} 板材
        </Box>
      </Table.Cell>
      <Table.Cell collapsing>
        <NumberInput
          width="32px"
          step={1}
          stepPixelSize={5}
          minValue={1}
          maxValue={50}
          value={amount}
          onChange={(e, value) => setAmount(value)}
        />
        <Button
          disabled={amountAvailable < 1}
          content="释放"
          onClick={() => onRelease(amount)}
        />
      </Table.Cell>
    </Table.Row>
  );
};
