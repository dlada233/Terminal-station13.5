import { useBackend, useSharedState } from '../backend';
import { Button, LabeledList, NoticeBox, Section, Tabs } from '../components';
import { Window } from '../layouts';
import { GenericUplink } from './Uplink/GenericUplink';

export const AbductorConsole = (props) => {
  const [tab, setTab] = useSharedState('tab', 1);

  return (
    <Window theme="abductor" width={600} height={532}>
      <Window.Content scrollable>
        <Tabs>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab === 1}
            onClick={() => setTab(1)}
          >
            劫持大师 3000
          </Tabs.Tab>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab === 2}
            onClick={() => setTab(2)}
          >
            任务设置
          </Tabs.Tab>
        </Tabs>
        {tab === 1 && <Abductsoft />}
        {tab === 2 && (
          <>
            <EmergencyTeleporter />
            <VestSettings />
          </>
        )}
      </Window.Content>
    </Window>
  );
};

const Abductsoft = (props) => {
  const { act, data } = useBackend();
  const { experiment, points, credits, categories } = data;

  if (!experiment) {
    return <NoticeBox danger>未检测到实验机器</NoticeBox>;
  }

  const categoriesList = [];
  const items = [];
  for (let i = 0; i < categories.length; i++) {
    const category = categories[i];
    categoriesList.push(category.name);
    for (let itemIndex = 0; itemIndex < category.items.length; itemIndex++) {
      const item = category.items[itemIndex];
      items.push({
        id: item.name,
        name: item.name,
        category: category.name,
        cost: `${item.cost}信用点`,
        desc: item.desc,
        disabled: credits < item.cost,
      });
    }
  }

  return (
    <>
      <Section>
        <LabeledList>
          <LabeledList.Item label="已收集样本">{points}</LabeledList.Item>
        </LabeledList>
      </Section>
      <GenericUplink
        currency={`${credits}信用点`}
        categories={categoriesList}
        items={items}
        handleBuy={(item) => act('buy', { name: item.name })}
      />
    </>
  );
};

const EmergencyTeleporter = (props) => {
  const { act, data } = useBackend();
  const { pad, gizmo } = data;

  if (!pad) {
    return <NoticeBox danger>未检测到传送台</NoticeBox>;
  }

  return (
    <Section
      title="应急传送"
      buttons={
        <Button
          icon="exclamation-circle"
          content="启动"
          color="bad"
          onClick={() => act('teleporter_send')}
        />
      }
    >
      <LabeledList>
        <LabeledList.Item label="标记检索">
          <Button
            icon={gizmo ? 'user-plus' : 'user-slash'}
            content={gizmo ? '收回' : '无标记'}
            disabled={!gizmo}
            onClick={() => act('teleporter_retrieve')}
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const VestSettings = (props) => {
  const { act, data } = useBackend();
  const { vest, vest_mode, vest_lock } = data;

  if (!vest) {
    return <NoticeBox danger>未检测到特工背心</NoticeBox>;
  }

  return (
    <Section
      title="特工背心设置"
      buttons={
        <Button
          icon={vest_lock ? 'lock' : 'unlock'}
          content={vest_lock ? '上锁' : '未锁'}
          onClick={() => act('toggle_vest')}
        />
      }
    >
      <LabeledList>
        <LabeledList.Item label="模式">
          <Button
            icon={vest_mode === 1 ? 'eye-slash' : 'fist-raised'}
            content={vest_mode === 1 ? '隐身' : '战斗'}
            onClick={() => act('flip_vest')}
          />
        </LabeledList.Item>
        <LabeledList.Item label="伪装">
          <Button
            icon="user-secret"
            content="选择"
            onClick={() => act('select_disguise')}
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
