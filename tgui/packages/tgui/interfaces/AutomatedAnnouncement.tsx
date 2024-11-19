import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Button, Input, LabeledList, Section } from '../components';
import { Window } from '../layouts';

const TOOLTIP_TEXT = `
  %PERSON will be replaced with their name.
  %RANK with their job.
`;

type Data = {
  arrivalToggle: BooleanLike;
  arrival: string;
  newheadToggle: BooleanLike;
  newhead: string;
};

export const AutomatedAnnouncement = (props) => {
  const { act, data } = useBackend<Data>();
  const { arrivalToggle, arrival, newheadToggle, newhead } = data;
  return (
    <Window title="自动公告系统" width={500} height={225}>
      <Window.Content>
        <Section
          title="登站公告"
          buttons={
            <Button
              icon={arrivalToggle ? 'power-off' : 'times'}
              selected={arrivalToggle}
              content={arrivalToggle ? '开' : '关'}
              onClick={() => act('ArrivalToggle')}
            />
          }
        >
          <LabeledList>
            <LabeledList.Item
              label="消息"
              buttons={
                <Button
                  icon="info"
                  tooltip={TOOLTIP_TEXT}
                  tooltipPosition="left"
                />
              }
            >
              <Input
                fluid
                value={arrival}
                onChange={(e, value) =>
                  act('ArrivalText', {
                    newText: value,
                  })
                }
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="部门主管公告"
          buttons={
            <Button
              icon={newheadToggle ? 'power-off' : 'times'}
              selected={newheadToggle}
              content={newheadToggle ? '开' : '关'}
              onClick={() => act('NewheadToggle')}
            />
          }
        >
          <LabeledList>
            <LabeledList.Item
              label="消息"
              buttons={
                <Button
                  icon="info"
                  tooltip={TOOLTIP_TEXT}
                  tooltipPosition="left"
                />
              }
            >
              <Input
                fluid
                value={newhead}
                onChange={(e, value) =>
                  act('NewheadText', {
                    newText: value,
                  })
                }
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
