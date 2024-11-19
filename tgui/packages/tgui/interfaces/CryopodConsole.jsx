// THIS IS A SKYRAT UI FILE
import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section, Stack } from '../components';
import { Window } from '../layouts';

export const CryopodConsole = (props) => {
  const { data } = useBackend();
  const { account_name } = data;

  const welcomeTitle = `你好, ${account_name || '[数据删除]'}!`;

  return (
    <Window title="低温仓终端" width={400} height={480}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section title={welcomeTitle}>
              这台自动低温冷冻装置将安全地保存你的身体直到下一次任务.
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <CrewList />
          </Stack.Item>
          <Stack.Item grow>
            <ItemList />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const CrewList = (props) => {
  const { data } = useBackend();
  const { frozen_crew } = data;

  return (
    (frozen_crew.length && (
      <Section fill scrollable>
        <LabeledList>
          {frozen_crew.map((person) => (
            <LabeledList.Item key={person} label={person.name}>
              {person.job}
            </LabeledList.Item>
          ))}
        </LabeledList>
      </Section>
    )) || <NoticeBox>没有储藏人员!</NoticeBox>
  );
};

const ItemList = (props) => {
  const { act, data } = useBackend();
  const { item_ref_list, item_ref_name, item_retrieval_allowed } = data;
  if (!item_retrieval_allowed) {
    return <NoticeBox>你没有被授权进行管理.</NoticeBox>;
  }
  return (
    (item_ref_list.length && (
      <Section fill scrollable>
        <LabeledList>
          {item_ref_list.map((item) => (
            <LabeledList.Item key={item} label={item_ref_name[item]}>
              <Button
                icon="exclamation-circle"
                content="收回"
                color="bad"
                onClick={() => act('item_get', { item_get: item })}
              />
            </LabeledList.Item>
          ))}
        </LabeledList>
      </Section>
    )) || <NoticeBox>没有储藏人员!</NoticeBox>
  );
};
