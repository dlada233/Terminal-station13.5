import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

type Data = {
  enabled: BooleanLike;
  dos_capacity: number;
  dos_overload: number;
  dos_crashed: BooleanLike;
};

const OUTAGE_WARNING = `由于流量缓存溢出，系统暂时中断. 在处理缓存流量前，
所有的进一步请求都将被弃置. 频繁出现此错误可能表明你的网络硬件容量不足. 请与你
的网络规划部门联络，了解如何解决此问题.`;

export const NtnetRelay = (props) => {
  const { act, data } = useBackend<Data>();
  const { enabled, dos_capacity, dos_overload, dos_crashed } = data;

  return (
    <Window title="NtNet 量子中继" width={400} height={300}>
      <Window.Content>
        <Section
          title="网络缓存区"
          buttons={
            <Button
              icon="power-off"
              selected={enabled}
              content={enabled ? '开启' : '关闭'}
              onClick={() => act('toggle')}
            />
          }
        >
          {!dos_crashed ? (
            <ProgressBar
              value={dos_overload}
              minValue={0}
              maxValue={dos_capacity}
            >
              <AnimatedNumber value={dos_overload} /> GQ
              {' / '}
              {dos_capacity} GQ
            </ProgressBar>
          ) : (
            <Box fontFamily="monospace">
              <Box fontSize="20px">网络缓存溢出</Box>
              <Box fontSize="16px">过载恢复模式</Box>
              <Box>{OUTAGE_WARNING}</Box>
              <Box fontSize="20px" color="bad">
                管理员超驰
              </Box>
              <Box fontSize="16px" color="bad">
                注意 - 数据丢失可能发生
              </Box>
              <Button
                icon="signal"
                content="清除缓存区"
                mt={1}
                color="bad"
                onClick={() => act('restart')}
              />
            </Box>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
