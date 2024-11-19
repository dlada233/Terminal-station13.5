import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Button, Dropdown, Input, LabeledList, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  loud: BooleanLike;
  name: string;
  on: BooleanLike;
  say_verb: string;
  selected: string;
  voices: string[];
};

export function AiVoiceChanger(props) {
  const { act, data } = useBackend<Data>();
  const { loud, name, on, say_verb, voices, selected } = data;

  return (
    <Window title="声音改变器" width={400} height={200}>
      <Section fill>
        <LabeledList>
          <LabeledList.Item label="电源">
            <Button
              icon={on ? 'power-off' : 'times'}
              selected={!!on}
              onClick={() => act('power')}
            >
              {on ? '开' : '关'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="口音">
            <Dropdown
              options={voices}
              onSelected={(value) => {
                act('look', {
                  look: value,
                });
              }}
              selected={selected}
            />
          </LabeledList.Item>
          <LabeledList.Item label="动词">
            <Input
              value={say_verb}
              onChange={(e, value) =>
                act('verb', {
                  verb: value,
                })
              }
            />
          </LabeledList.Item>
          <LabeledList.Item label="音量">
            <Button
              icon={loud ? 'power-off' : 'times'}
              selected={!!loud}
              onClick={() => act('loud')}
            >
              {loud ? '高音量模式开' : '高音量模式关'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="假名">
            <Input
              value={name}
              onChange={(e, value) =>
                act('name', {
                  name: value,
                })
              }
            />
          </LabeledList.Item>
        </LabeledList>
      </Section>
    </Window>
  );
}
