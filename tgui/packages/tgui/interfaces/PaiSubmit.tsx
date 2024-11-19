import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Input, Section, Stack } from '../components';
import { Window } from '../layouts';

type Data = {
  comments: string;
  description: string;
  name: string;
};

const PAI_DESCRIPTION = `个人人工智能是能够进行细微互动的高级模型，它们被设计用来协
助主人的生活日常以及工作. 它们不具备与设备和物品直接交互的能力. 它们可以以全息影像形
式出现，影像不会被杀死，但仍然能被消灭并瘫痪.`;

const PAI_RULES = `遵守基本的扮演原则，还有一点：空白信息可能导致你看起来没有吸引力
从而不被机主选择. 一切完成后按“提交”按钮注册成为pAI候选者.`;

export const PaiSubmit = (props) => {
  const { data } = useBackend<Data>();
  const { comments, description, name } = data;
  const [input, setInput] = useState({
    comments,
    description,
    name,
  });

  return (
    <Window width={400} height={460} title="pAI注册者名单">
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item grow>
            <DetailsDisplay />
          </Stack.Item>
          <Stack.Item>
            <InputDisplay input={input} setInput={setInput} />
          </Stack.Item>
          <Stack.Item>
            <ButtonsDisplay input={input} />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

/** Displays basic info about playing pAI */
const DetailsDisplay = (props) => {
  return (
    <Section fill scrollable title="详情">
      <Box color="label">
        {PAI_DESCRIPTION}
        <br />
        <br />
        {PAI_RULES}
      </Box>
    </Section>
  );
};

/** Input boxes for submission details */
const InputDisplay = (props) => {
  const { input, setInput } = props;
  const { name, description, comments } = input;

  return (
    <Section fill title="输入">
      <Stack fill vertical>
        <Stack.Item>
          <Box bold color="label">
            姓名
          </Box>
          <Input
            fluid
            maxLength={41}
            value={name}
            onChange={(e, value) => setInput({ ...input, name: value })}
          />
        </Stack.Item>
        <Stack.Item>
          <Box bold color="label">
            描述
          </Box>
          <Input
            fluid
            maxLength={500} /* SKYRAT EDIT: ORIGINAL 100 */
            value={description}
            onChange={(e, value) => setInput({ ...input, description: value })}
          />
        </Stack.Item>
        <Stack.Item>
          <Box bold color="label">
            OOC注释
          </Box>
          <Input
            fluid
            maxLength={500} /* SKYRAT EDIT: ORIGINAL 100 */
            value={comments}
            onChange={(e, value) => setInput({ ...input, comments: value })}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

/** Gives the user a submit button */
const ButtonsDisplay = (props) => {
  const { act } = useBackend<Data>();
  const { input } = props;
  const { comments, description, name } = input;

  return (
    <Section fill>
      <Stack>
        <Stack.Item>
          <Button
            onClick={() => act('save', { comments, description, name })}
            tooltip="将你的pAI注册信息保存到本地."
          >
            保存
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            onClick={() => act('load')}
            tooltip="加载已保存到本地的pAI注册信息."
          >
            加载
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            onClick={() =>
              act('submit', {
                comments,
                description,
                name,
              })
            }
          >
            提交
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
