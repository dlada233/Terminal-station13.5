import { toFixed } from 'common/math';
import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  doorstatus: BooleanLike;
  stored: number;
  max: number;
};

export const VaultController = (props) => {
  const { act, data } = useBackend<Data>();
  const { doorstatus, stored, max } = data;

  return (
    <Window width={300} height={120}>
      <Window.Content>
        <Section
          title="锁状态: "
          buttons={
            <Button
              content={doorstatus ? '锁定' : '未锁定'}
              icon={doorstatus ? 'lock' : 'unlock'}
              disabled={stored < max}
              onClick={() => act('togglelock')}
            />
          }
        >
          <VaultList />
        </Section>
      </Window.Content>
    </Window>
  );
};

/** Displays info about the vault in a labeledlist */
const VaultList = (props) => {
  const { data } = useBackend<Data>();
  const { stored, max } = data;

  return (
    <LabeledList>
      <LabeledList.Item label="充能">
        <ProgressBar
          value={stored / max}
          ranges={{
            good: [1, Infinity],
            average: [0.3, 1],
            bad: [-Infinity, 0.3],
          }}
        >
          {toFixed(stored / 1000) + ' / ' + toFixed(max / 1000) + ' kW'}
        </ProgressBar>
      </LabeledList.Item>
    </LabeledList>
  );
};
