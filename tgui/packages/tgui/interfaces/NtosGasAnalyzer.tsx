import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Button } from '../components';
import { NtosWindow } from '../layouts';
import { GasAnalyzerContent, GasAnalyzerData } from './GasAnalyzer';

type NtosGasAnalyzerData = GasAnalyzerData & {
  atmozphereMode: 'click' | 'env';
  clickAtmozphereCompatible: BooleanLike;
};

export const NtosGasAnalyzer = (props) => {
  const { act, data } = useBackend<NtosGasAnalyzerData>();
  const { atmozphereMode, clickAtmozphereCompatible } = data;
  return (
    <NtosWindow width={500} height={450}>
      <NtosWindow.Content scrollable>
        {!!clickAtmozphereCompatible && (
          <Button
            icon={'sync'}
            onClick={() => act('scantoggle')}
            fluid
            textAlign="center"
            tooltip={
              atmozphereMode === 'click'
                ? '手持设备时右键物体可进行扫描.右键设备可扫描当前位置.'
                : '应用程序会自动更新其气体混合物读数.'
            }
            tooltipPosition="bottom"
          >
            {atmozphereMode === 'click'
              ? '扫描接触物品. 点击以切换.'
              : '扫描当前位置. 点击以切换.'}
          </Button>
        )}
        <GasAnalyzerContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
