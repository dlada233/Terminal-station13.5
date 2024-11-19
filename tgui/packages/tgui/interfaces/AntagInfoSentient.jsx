import { useBackend } from '../backend';
import { BlockQuote, Section, Stack } from '../components';
import { Window } from '../layouts';

export const AntagInfoSentient = (props) => {
  const { act, data } = useBackend();
  const { enslaved_to, holographic, p_them, p_their } = data;
  return (
    <Window width={400} height={400} theme="neutral">
      <Window.Content>
        <Section fill>
          <Stack vertical fill textAlign="center">
            <Stack.Item fontSize="20px">你是只感知动物!</Stack.Item>
            <Stack.Item>
              <BlockQuote>
                突然间，天地豁然开朗: 你知道了自己是谁，自我的意识已然觉醒!
                {!!enslaved_to &&
                  ' 你对自己得到了自我意识感到感激，你欠了' +
                    enslaved_to +
                    '一份恩情. 不惜代价地服务协助' +
                    enslaved_to +
                    '达成其目标.'}
                {!!holographic &&
                  '你沮丧地意识到你并不是真实存在的生物，只是全息的影像体，你的存在仅仅限制于全息投影平台的参数内.'}
              </BlockQuote>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
