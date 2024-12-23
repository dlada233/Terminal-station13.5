import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { NtosWindow } from '../layouts';

type Data = {
  armed: BooleanLike;
};

export const NtosRevelation = (props) => {
  const { act, data } = useBackend<Data>();
  const { armed } = data;

  return (
    <NtosWindow width={400} height={250}>
      <NtosWindow.Content>
        <Section>
          <Button.Input
            fluid
            content="混淆名称..."
            onCommit={(_, value) =>
              act('PRG_obfuscate', {
                new_name: value,
              })
            }
            mb={1}
          />
          <LabeledList>
            <LabeledList.Item
              label="电子炸药状态"
              buttons={
                <Button
                  content={armed ? '上膛' : '未上膛'}
                  color={armed ? 'bad' : 'average'}
                  onClick={() => act('PRG_arm')}
                />
              }
            />
          </LabeledList>
          <Button
            fluid
            bold
            content="激活"
            textAlign="center"
            color="bad"
            disabled={!armed}
            onClick={() => act('PRG_activate')}
          />
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
