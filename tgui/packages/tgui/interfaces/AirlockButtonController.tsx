import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Button, NoticeBox, Section, Stack } from '../components';
import { Window } from '../layouts';

type Data = {
  interior_door: string;
  exterior_door: string;
  interior_door_closed: BooleanLike;
  exterior_door_closed: BooleanLike;
  busy: BooleanLike;
};

export const AirlockButtonController = (props) => {
  const { data } = useBackend<Data>();
  const { interior_door, exterior_door } = data;
  return (
    <Window width={500} height={130}>
      <Window.Content>
        <Section title="气闸控制器" textAlign="center">
          {!interior_door && !exterior_door ? (
            <NoticeBox danger>未检测到门</NoticeBox>
          ) : (
            <Stack>
              {interior_door && (
                <Stack.Item grow textAlign="center">
                  <RetrieveButton airlockType={interior_door} />
                </Stack.Item>
              )}
              {exterior_door && (
                <Stack.Item grow textAlign="center">
                  <RetrieveButton airlockType={exterior_door} />
                </Stack.Item>
              )}
            </Stack>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

const RetrieveButton = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    interior_door,
    exterior_door,
    interior_door_closed,
    exterior_door_closed,
    busy,
  } = data;
  const { airlockType } = props;
  const our_door_closed =
    airlockType === interior_door ? interior_door_closed : exterior_door_closed;
  const opposite_door_closed =
    airlockType === interior_door ? exterior_door_closed : interior_door_closed;
  const opposite_door =
    airlockType === interior_door ? exterior_door : interior_door;

  return (
    <Button
      mt={2}
      icon={our_door_closed ? 'lock-open' : 'lock'}
      color="green"
      fontSize={1.5}
      textAlign="center"
      lineHeight="1.5"
      disabled={busy}
      onClick={() => {
        if (!our_door_closed) {
          act('close', {
            requested_door: airlockType,
          });
        } else {
          act('open', {
            requested_door: airlockType,
          });
        }
      }}
    >
      {!our_door_closed
        ? `关闭${airlockType === interior_door ? '内部门' : '外部门'}`
        : !opposite_door_closed && opposite_door
          ? `循环至${airlockType === interior_door ? '内部门' : '外部门'}`
          : `打开${airlockType === interior_door ? '内部门' : '外部'}`}
    </Button>
  );
};
