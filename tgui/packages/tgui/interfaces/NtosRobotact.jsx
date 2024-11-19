import { useState } from 'react';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  Flex,
  LabeledList,
  ProgressBar,
  Section,
  Slider,
  Tabs,
} from '../components';
import { formatEnergy } from '../format';
import { formatPower } from '../format';
import { NtosWindow } from '../layouts';

export const NtosRobotact = (props) => {
  return (
    <NtosWindow width={800} height={600}>
      <NtosWindow.Content>
        <NtosRobotactContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const NtosRobotactContent = (props) => {
  const { act, data } = useBackend();
  const [tab_main, setTab_main] = useState(1);
  const [tab_sub, setTab_sub] = useState(1);
  const {
    charge,
    maxcharge,
    integrity,
    lampIntensity,
    lampConsumption,
    cover,
    locomotion,
    wireModule,
    wireCamera,
    wireAI,
    wireLaw,
    sensors,
    printerPictures,
    printerToner,
    printerTonerMax,
    thrustersInstalled,
    thrustersStatus,
    selfDestructAble,
  } = data;
  const borgName = data.name || [];
  const borgType = data.designation || [];
  const masterAI = data.masterAI || [];
  const laws = data.Laws || [];
  const borgLog = data.borgLog || [];
  const borgUpgrades = data.borgUpgrades || [];

  return (
    <Flex direction={'column'}>
      <Flex.Item position="relative" mb={1}>
        <Tabs>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab_main === 1}
            onClick={() => setTab_main(1)}
          >
            状态
          </Tabs.Tab>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab_main === 2}
            onClick={() => setTab_main(2)}
          >
            日志
          </Tabs.Tab>
        </Tabs>
      </Flex.Item>
      {tab_main === 1 && (
        <>
          <Flex direction={'row'}>
            <Flex.Item width="30%">
              <Section title="配置" fill>
                <LabeledList>
                  <LabeledList.Item label="单位">
                    {borgName.slice(0, 17)}
                  </LabeledList.Item>
                  <LabeledList.Item label="类型">{borgType}</LabeledList.Item>
                  <LabeledList.Item label="AI">
                    {masterAI.slice(0, 17)}
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            </Flex.Item>
            <Flex.Item grow={1} basis="content" ml={1}>
              <Section title="状态">
                充能:
                <Button
                  content="能量警报"
                  disabled={charge}
                  onClick={() => act('alertPower')}
                />
                <ProgressBar
                  value={charge / maxcharge}
                  ranges={{
                    good: [0.5, Infinity],
                    average: [0.1, 0.5],
                    bad: [-Infinity, 0.1],
                  }}
                >
                  <AnimatedNumber
                    value={charge}
                    format={(charge) => formatEnergy(charge)}
                  />
                </ProgressBar>
                底盘完整性:
                <ProgressBar
                  value={integrity}
                  minValue={0}
                  maxValue={100}
                  ranges={{
                    bad: [-Infinity, 25],
                    average: [25, 75],
                    good: [75, Infinity],
                  }}
                />
              </Section>
              <Section title="光源功率">
                <Slider
                  value={lampIntensity}
                  step={1}
                  stepPixelSize={25}
                  maxValue={5}
                  minValue={1}
                  onChange={(e, value) =>
                    act('lampIntensity', {
                      ref: value,
                    })
                  }
                />
                光源用电量: {formatPower(lampIntensity * lampConsumption)}
              </Section>
            </Flex.Item>
            <Flex.Item width="50%" ml={1}>
              <Section fitted>
                <Tabs fluid={1} textAlign="center">
                  <Tabs.Tab
                    icon=""
                    lineHeight="23px"
                    selected={tab_sub === 1}
                    onClick={() => setTab_sub(1)}
                  >
                    行动
                  </Tabs.Tab>
                  <Tabs.Tab
                    icon=""
                    lineHeight="23px"
                    selected={tab_sub === 2}
                    onClick={() => setTab_sub(2)}
                  >
                    升级
                  </Tabs.Tab>
                  <Tabs.Tab
                    icon=""
                    lineHeight="23px"
                    selected={tab_sub === 3}
                    onClick={() => setTab_sub(3)}
                  >
                    诊断
                  </Tabs.Tab>
                </Tabs>
              </Section>
              {tab_sub === 1 && (
                <Section>
                  <LabeledList>
                    <LabeledList.Item label="检修盖板">
                      <Button.Confirm
                        content="解锁"
                        disabled={cover === '已解锁'}
                        onClick={() => act('coverunlock')}
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="传感器覆盖">
                      <Button
                        content={sensors}
                        onClick={() => act('toggleSensors')}
                      />
                    </LabeledList.Item>
                    <LabeledList.Item
                      label={'存储照片 (' + printerPictures + ')'}
                    >
                      <Button
                        content="浏览"
                        disabled={!printerPictures}
                        onClick={() => act('viewImage')}
                      />
                      <Button
                        content="打印"
                        disabled={!printerPictures}
                        onClick={() => act('printImage')}
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="打印机墨粉">
                      <ProgressBar value={printerToner / printerTonerMax} />
                    </LabeledList.Item>
                    {!!thrustersInstalled && (
                      <LabeledList.Item label="切换推进器">
                        <Button
                          content={thrustersStatus}
                          onClick={() => act('toggleThrusters')}
                        />
                      </LabeledList.Item>
                    )}
                    {!!selfDestructAble && (
                      <LabeledList.Item label="自毁">
                        <Button.Confirm
                          content="启动"
                          color="red"
                          onClick={() => act('selfDestruct')}
                        />
                      </LabeledList.Item>
                    )}
                  </LabeledList>
                </Section>
              )}
              {tab_sub === 2 && (
                <Section>
                  {borgUpgrades.map((upgrade) => (
                    <Box mb={1} key={upgrade}>
                      {upgrade}
                    </Box>
                  ))}
                </Section>
              )}
              {tab_sub === 3 && (
                <Section>
                  <LabeledList>
                    <LabeledList.Item
                      label="AI连接"
                      color={
                        wireAI === '故障'
                          ? 'red'
                          : wireAI === '就绪'
                            ? 'yellow'
                            : 'green'
                      }
                    >
                      {wireAI}
                    </LabeledList.Item>
                    <LabeledList.Item
                      label="法律同步"
                      color={wireLaw === '故障' ? 'red' : 'green'}
                    >
                      {wireLaw}
                    </LabeledList.Item>
                    <LabeledList.Item
                      label="摄像机"
                      color={
                        wireCamera === '故障'
                          ? 'red'
                          : wireCamera === '禁用'
                            ? 'yellow'
                            : 'green'
                      }
                    >
                      {wireCamera}
                    </LabeledList.Item>
                    <LabeledList.Item
                      label="模块控制器"
                      color={wireModule === '故障' ? 'red' : 'green'}
                    >
                      {wireModule}
                    </LabeledList.Item>
                    <LabeledList.Item
                      label="电机控制器"
                      color={
                        locomotion === '故障'
                          ? 'red'
                          : locomotion === '禁用'
                            ? 'yellow'
                            : 'green'
                      }
                    >
                      {locomotion}
                    </LabeledList.Item>
                    <LabeledList.Item
                      label="检修盖板"
                      color={cover === '已解锁' ? 'red' : 'green'}
                    >
                      {cover}
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              )}
            </Flex.Item>
          </Flex>
          <Flex.Item height={21} mt={1}>
            <Section
              title="法律"
              fill
              scrollable
              buttons={
                <>
                  <Button content="状态法律" onClick={() => act('lawstate')} />
                  <Button icon="volume-off" onClick={() => act('lawchannel')} />
                </>
              }
            >
              {laws.map((law) => (
                <Box mb={1} key={law}>
                  {law}
                </Box>
              ))}
            </Section>
          </Flex.Item>
        </>
      )}
      {tab_main === 2 && (
        <Flex.Item height={40}>
          <Section fill scrollable backgroundColor="black">
            {borgLog.map((log) => (
              <Box mb={1} key={log}>
                <font color="green">{log}</font>
              </Box>
            ))}
          </Section>
        </Flex.Item>
      )}
    </Flex>
  );
};
