// THIS IS A SKYRAT UI FILE
import { useBackend } from '../backend';
import { Button, Section, Stack } from '../components';
import { Window } from '../layouts';

export const AntagInfoOpfor = (props) => {
  const { act } = useBackend();
  return (
    <Window width={620} height={250}>
      <Window.Content>
        <Section scrollable fill>
          <Stack vertical>
            <Stack.Item fontSize="20px" color={'good'}>
              {'你是一名OPFOR申请者!'}
            </Stack.Item>
            {'OPFOR可以自主发起某种形式的反派行动.'}
            {'如果你没有任何点子，可以参考前人记录.'}
            {'如果不想作为OPFOR, 只需按下下面的按钮即可删除你的状态.'}
            <Stack.Item align="center">
              <Button
                color="red"
                content={'移除状态'}
                tooltip={'移除你OPFOR申请者的状态.'}
                onClick={() => act('pass_on')}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
