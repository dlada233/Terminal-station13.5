import { useBackend } from '../backend';
import { Button, Input, LabeledList, Section } from '../components';
import { Window } from '../layouts';

const TOOLTIP_NAME = `
  输入该单位的新名字，保持空白将重置为默认值，这意味着单位能自己选择自己的名字.
`;

const TOOLTIP_LOCOMOTION = `
  如果受到限制，该单位将被锁定直到解锁.
`;

const TOOLTIP_PANEL = `
  如果解锁，即使没有授权，也可以打开单位的覆板.
`;

const TOOLTIP_AISYNC = `
  如果关闭，该单位将无法与任何AI配对
`;

const TOOLTIP_AI = `
  控制谁为该单位的上级AI.
`;

const TOOLTIP_LAWSYNC = `
  如果关闭，该单位将不会与上级AI同步法律.
`;

export const CyborgBootDebug = (props) => {
  const { act, data } = useBackend();
  const { designation, master, lawsync, aisync, locomotion, panel } = data;
  return (
    <Window width={master?.length > 26 ? 537 : 440} height={289}>
      <Window.Content>
        <Section title="基础设置">
          <LabeledList>
            <LabeledList.Item
              label="名称"
              buttons={
                <Button
                  icon="info"
                  tooltip={TOOLTIP_NAME}
                  tooltipPosition="left"
                />
              }
            >
              <Input
                fluid
                value={designation || '默认赛博'}
                onChange={(e, value) =>
                  act('rename', {
                    new_name: value,
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item
              label="伺服电机功能"
              buttons={
                <Button
                  icon="info"
                  tooltip={TOOLTIP_LOCOMOTION}
                  tooltipPosition="left"
                />
              }
            >
              <Button
                icon={locomotion ? 'unlock' : 'lock'}
                content={locomotion ? '自由' : '受限制'}
                color={locomotion ? 'good' : 'bad'}
                onClick={() => act('locomotion')}
              />
            </LabeledList.Item>
            <LabeledList.Item
              label="覆板"
              buttons={
                <Button
                  icon="info"
                  tooltip={TOOLTIP_PANEL}
                  tooltipPosition="left"
                />
              }
            >
              <Button
                icon={panel ? 'lock' : 'unlock'}
                content={panel ? '锁定' : '解锁'}
                onClick={() => act('panel')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="AI设置">
          <LabeledList>
            <LabeledList.Item
              label="AI连接端口"
              buttons={
                <Button
                  icon="info"
                  tooltip={TOOLTIP_AISYNC}
                  tooltipPosition="left"
                />
              }
            >
              <Button
                icon={aisync ? 'unlock' : 'lock'}
                content={aisync ? '开启' : '关闭'}
                onClick={() => act('aisync')}
              />
            </LabeledList.Item>
            <LabeledList.Item
              label="上级AI"
              buttons={
                <Button
                  icon="info"
                  tooltip={TOOLTIP_AI}
                  tooltipPosition="left"
                />
              }
            >
              <Button
                icon={!aisync ? 'times' : master ? 'edit' : 'sync'}
                content={!aisync ? '无' : master || '自动'}
                color={master ? 'default' : 'good'}
                disabled={!aisync}
                onClick={() => act('set_ai')}
              />
            </LabeledList.Item>
            <LabeledList.Item
              label="法律同步端口"
              buttons={
                <Button
                  icon="info"
                  tooltip={TOOLTIP_LAWSYNC}
                  tooltipPosition="top-start"
                />
              }
            >
              <Button
                icon={!aisync ? 'lock' : lawsync ? 'unlock' : 'lock'}
                content={!aisync ? '关闭' : lawsync ? '开启' : '关闭'}
                disabled={!aisync}
                onClick={() => act('lawsync')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
