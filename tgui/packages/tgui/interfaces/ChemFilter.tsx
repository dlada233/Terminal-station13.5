import { Fragment } from 'react';

import { useBackend } from '../backend';
import { Button, Section, Stack } from '../components';
import { CssColor } from '../constants';
import { Window } from '../layouts';

type Data = {
  left: string[];
  right: string[];
};

type Props = {
  title: string;
  list: string[];
  buttonColor: CssColor;
};

export const ChemFilterPane = (props: Props) => {
  const { act } = useBackend();
  const { title, list, buttonColor } = props;
  const titleKey = title.toLowerCase();

  return (
    <Section
      title={title}
      minHeight="240px"
      buttons={
        <Button
          content="添加试剂"
          icon="plus"
          color={buttonColor}
          onClick={() =>
            act('add', {
              which: titleKey,
            })
          }
        />
      }
    >
      {list.map((filter) => (
        <Fragment key={filter}>
          <Button
            fluid
            icon="minus"
            content={filter}
            onClick={() =>
              act('remove', {
                which: titleKey,
                reagent: filter,
              })
            }
          />
        </Fragment>
      ))}
    </Section>
  );
};

export const ChemFilter = (props) => {
  const { data } = useBackend<Data>();
  const { left = [], right = [] } = data;

  return (
    <Window width={500} height={300}>
      <Window.Content scrollable>
        <Stack>
          <Stack.Item grow>
            <ChemFilterPane title="左" list={left} buttonColor="yellow" />
          </Stack.Item>
          <Stack.Item grow>
            <ChemFilterPane title="右" list={right} buttonColor="red" />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
