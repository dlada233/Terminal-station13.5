import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  on: BooleanLike;
  visible: BooleanLike;
};

export const InfraredEmitter = (props) => {
  const { act, data } = useBackend<Data>();
  const { on, visible } = data;

  return (
    <Window width={225} height={110}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="状态">
              <Button
                icon={on ? 'power-off' : 'times'}
                content={on ? '开' : '关'}
                selected={on}
                onClick={() => act('power')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="可见性">
              <Button
                icon={visible ? 'eye' : 'eye-slash'}
                content={visible ? '可见' : '不可见'}
                selected={visible}
                onClick={() => act('visibility')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
