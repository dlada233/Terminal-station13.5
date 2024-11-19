import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { BlockQuote, Box, Button, Icon, Section, Stack } from '../components';
import { Window } from '../layouts';

export const ApprenticeContract = (props) => {
  return (
    <Window width={620} height={600} theme="wizard">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section textColor="lightgreen" fontSize="15px">
              如果你找不到任何学徒，可以直接把合同放回到魔法书里来退款.
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <ApprenticeSelection
              iconName="fire"
              fluffName="毁灭学徒"
              schoolTitle="destruction"
              assetName="destruction.png"
              blurb={`
              你的学徒精通进攻魔法，他们会魔法飞弹和火球术.
              `}
            />
            <ApprenticeSelection
              iconName="route"
              fluffName="易位门徒"
              schoolTitle="bluespace"
              assetName="bluespace.png"
              blurb={`
              你的学徒能够无视物理法则，穿透致密固体，并在眨眼之间就能跨越遥远的距离.
              他们会传送术和虚体化形.
              `}
            />
            <ApprenticeSelection
              iconName="medkit"
              fluffName="苏生新人"
              schoolTitle="healing"
              assetName="healing.png"
              blurb={`
              你的学徒能用法术助你生存，他们会斥力墙和充能术，还随身携带着治愈法杖.
              `}
            />
            <ApprenticeSelection
              iconName="user-secret"
              fluffName="无袍小生"
              schoolTitle="robeless"
              assetName="robeless.png"
              blurb={`
              你的学徒专注于无袍法术，他们会敲门术和心灵交换.
              `}
            />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const ApprenticeSelection = (props) => {
  const { act } = useBackend();
  const { iconName, fluffName, schoolTitle, assetName, blurb } = props;
  return (
    <Section>
      <Stack align="middle" fill>
        <Stack.Item>
          <Stack vertical>
            <Stack.Item>
              <img
                src={resolveAsset(assetName)}
                style={{
                  borderStyle: 'solid',
                  borderColor: '#7e90a7',
                }}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                textAlign="center"
                fluid
                onClick={() =>
                  act('buy', {
                    school: schoolTitle,
                  })
                }
              >
                选择
              </Button>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item grow>
          <Box fontSize="20px" height="30%">
            <Icon name={iconName} /> {fluffName}
          </Box>
          <BlockQuote height="70%" fontSize="16px">
            {blurb}
          </BlockQuote>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
