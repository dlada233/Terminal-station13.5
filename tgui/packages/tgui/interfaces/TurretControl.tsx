import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

type Data = {
  enabled: BooleanLike;
  lethal: BooleanLike;
  locked: BooleanLike;
  shootCyborgs: BooleanLike;
  siliconUser: BooleanLike;
};

export const TurretControl = (props) => {
  const { act, data } = useBackend<Data>();
  const { enabled, lethal, locked, siliconUser, shootCyborgs } = data;
  const isLocked = locked && !siliconUser;

  return (
    <Window width={305} height={siliconUser ? 168 : 164}>
      <Window.Content>
        <InterfaceLockNoticeBox />
        <Section>
          <LabeledList>
            <LabeledList.Item label="炮塔状态">
              <Button
                icon={enabled ? 'power-off' : 'times'}
                content={enabled ? '开启' : '关闭'}
                selected={enabled}
                disabled={isLocked}
                onClick={() => act('power')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="炮塔模式">
              <Button
                icon={lethal ? 'exclamation-triangle' : 'minus-circle'}
                content={lethal ? '致命' : '击晕'}
                color={lethal ? 'bad' : 'average'}
                disabled={isLocked}
                onClick={() => act('mode')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="赛博目标">
              <Button
                icon={shootCyborgs ? 'check' : 'times'}
                content={shootCyborgs ? '是' : '否'}
                selected={shootCyborgs}
                disabled={isLocked}
                onClick={() => act('shoot_silicons')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
