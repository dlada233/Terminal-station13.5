import { useBackend } from '../backend';
import {
  Box,
  Button,
  Flex,
  LabeledList,
  NoticeBox,
  Section,
} from '../components';
import { Window } from '../layouts';

export const CivCargoHoldTerminal = (props) => {
  const { act, data } = useBackend();
  const { pad, sending, status_report, id_inserted, id_bounty_info, picking } =
    data;
  const in_text = '欢迎你，尊敬的员工.';
  const out_text = '首先，将您的ID卡插入到控制台中.';
  return (
    <Window width={580} height={375}>
      <Window.Content scrollable>
        <Flex>
          <Flex.Item>
            <NoticeBox color={!id_inserted ? 'default' : 'blue'}>
              {id_inserted ? in_text : out_text}
            </NoticeBox>
            <Section
              title="发射平台"
              buttons={
                <>
                  <Button
                    icon={'sync'}
                    tooltip={'检查内容'}
                    disabled={!pad || !id_inserted}
                    onClick={() => act('recalc')}
                  />
                  <Button
                    icon={sending ? 'times' : 'arrow-up'}
                    tooltip={sending ? '停止发送' : '发送货物'}
                    selected={sending}
                    disabled={!pad || !id_inserted}
                    onClick={() => act(sending ? 'stop' : 'send')}
                  />
                  <Button
                    icon={id_bounty_info ? 'recycle' : 'pen'}
                    color={id_bounty_info ? 'green' : 'default'}
                    tooltip={id_bounty_info ? '更换赏金目标' : '新赏金目标'}
                    disabled={!id_inserted}
                    onClick={() => act('bounty')}
                  />
                  <Button
                    icon={'download'}
                    content={'弹出ID卡'}
                    disabled={!id_inserted}
                    onClick={() => act('eject')}
                  />
                </>
              }
            >
              <LabeledList>
                <LabeledList.Item label="状态" color={pad ? 'good' : 'bad'}>
                  {pad ? '在线' : '未找到'}
                </LabeledList.Item>
                <LabeledList.Item label="货物报告">
                  {status_report}
                </LabeledList.Item>
              </LabeledList>
            </Section>
            {picking ? <BountyPickBox /> : <BountyTextBox />}
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};

const BountyTextBox = (props) => {
  const { data } = useBackend();
  const { id_bounty_info, id_bounty_value, id_bounty_num } = data;
  const na_text = 'N/A, 请添加一条新赏金目标.';
  return (
    <Section title="赏金信息">
      <LabeledList>
        <LabeledList.Item label="描述">
          {id_bounty_info ? id_bounty_info : na_text}
        </LabeledList.Item>
        <LabeledList.Item label="数量">
          {id_bounty_info ? id_bounty_num : 'N/A'}
        </LabeledList.Item>
        <LabeledList.Item label="价值">
          {id_bounty_info ? id_bounty_value : 'N/A'}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const BountyPickBox = (props) => {
  const { act, data } = useBackend();
  const { id_bounty_names, id_bounty_infos, id_bounty_values } = data;
  return (
    <Section title="请选择一个赏金目标:" textAlign="center">
      <Flex width="100%" wrap>
        <Flex.Item shrink={0} grow={0.5}>
          <BountyPickButton
            bounty_name={id_bounty_names[0]}
            bounty_info={id_bounty_infos[0]}
            bounty_value={id_bounty_values[0]}
            pick_value={1}
            act={act}
          />
        </Flex.Item>
        <Flex.Item shrink={0} grow={0.5} px={1}>
          <BountyPickButton
            bounty_name={id_bounty_names[1]}
            bounty_info={id_bounty_infos[1]}
            bounty_value={id_bounty_values[1]}
            pick_value={2}
            act={act}
          />
        </Flex.Item>
        <Flex.Item shrink={0} grow={0.5}>
          <BountyPickButton
            bounty_name={id_bounty_names[2]}
            bounty_info={id_bounty_infos[2]}
            bounty_value={id_bounty_values[2]}
            pick_value={3}
            act={act}
          />
        </Flex.Item>
      </Flex>
    </Section>
  );
};

const BountyPickButton = (props) => {
  return (
    <Button
      fluid
      color="green"
      onClick={() => props.act('pick', { value: props.pick_value })}
      style={{
        display: 'flex',
        textWrap: 'wrap',
        whiteSpace: 'normal',
        paddingLeft: '0',
        paddingRight: '0',
      }}
    >
      <Box>{props.bounty_name}</Box>
      <Box
        textAlign="left"
        color="black"
        backgroundColor="linen"
        lineHeight="1.2em"
      >
        {props.bounty_info}
      </Box>
      <Box>报酬: {props.bounty_value} cr</Box>
    </Button>
  );
};
