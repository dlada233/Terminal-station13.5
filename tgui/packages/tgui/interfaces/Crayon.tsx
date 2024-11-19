import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';
import { ColorItem } from './RapidPipeDispenser';

type Data = {
  has_cap: BooleanLike;
  can_change_colour: BooleanLike;
  drawables: Drawable[];
  is_capped: BooleanLike;
  selected_stencil: string;
  text_buffer: string;
};

type Drawable = {
  items: { item: string }[];
  name: string;
};

export const Crayon = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    has_cap,
    can_change_colour,
    drawables = [],
    is_capped,
    selected_stencil,
    text_buffer,
  } = data;
  const capOrChanges = has_cap || can_change_colour;

  return (
    <Window width={600} height={600}>
      <Window.Content scrollable>
        {!!capOrChanges && (
          <Section title="基础">
            <LabeledList>
              <LabeledList.Item label="盖子">
                <Button
                  icon={is_capped ? 'power-off' : 'times'}
                  content={is_capped ? '开' : '关'}
                  selected={is_capped}
                  onClick={() => act('toggle_cap')}
                />
              </LabeledList.Item>
              <ColorItem />
              <LabeledList.Item>
                <Button
                  content="自定义颜色"
                  onClick={() => act('custom_color')}
                />
              </LabeledList.Item>
            </LabeledList>
          </Section>
        )}
        <Section title="模板">
          <LabeledList>
            {drawables.map((drawable) => {
              const items = drawable.items || [];
              return (
                <LabeledList.Item key={drawable.name} label={drawable.name}>
                  {items.map((item) => (
                    <Button
                      key={item.item}
                      content={item.item}
                      selected={item.item === selected_stencil}
                      onClick={() =>
                        act('select_stencil', {
                          item: item.item,
                        })
                      }
                    />
                  ))}
                </LabeledList.Item>
              );
            })}
          </LabeledList>
        </Section>
        <Section title="文本">
          <LabeledList>
            <LabeledList.Item label="当前缓存">{text_buffer}</LabeledList.Item>
          </LabeledList>
          <Button content="新文本" onClick={() => act('enter_text')} />
        </Section>
      </Window.Content>
    </Window>
  );
};
