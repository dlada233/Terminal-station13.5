// THIS IS A SKYRAT UI FILE
import { useBackend } from '../backend';
import {
  Box,
  Dimmer,
  Divider,
  Icon,
  Section,
  Stack,
  StyleableSection,
  Tooltip,
} from '../components';
import { Button } from '../components/Button';
import { Window } from '../layouts';

type Data = {
  food_types: Record<string, number>;
  obscure_food_types: string;
  selection: Record<string, number>;
  enabled: boolean;
  invalid: string;
  race_disabled: boolean;
};

const FOOD_TOXIC = 1;
const FOOD_DISLIKED = 2;
const FOOD_NEUTRAL = 3;
const FOOD_LIKED = 4;
const DEFAULT_FOOD_VALUE = 4;
const OBSCURE_FOOD = 5;

export const FoodPreferences = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Window width={1300} height={600}>
      <Window.Content scrollable>
        {
          <StyleableSection
            style={{
              'margin-bottom': '1em',
              'break-inside': 'avoid-column',
            }}
            titleStyle={{
              'justify-content': 'center',
            }}
            title={
              <Box>
                <Tooltip
                  position="bottom"
                  content={
                    '你必须选择至少一种有毒的食物和三种厌恶的食物. 最多只可以有三种喜欢的食物.'
                  }
                >
                  <Box inline>
                    <Button icon="circle-question" mr="0.5em" />
                    {data.invalid ? (
                      <Box as="span" color="#bd2020">
                        设置不可用!{' '}
                        {data.invalid.charAt(0).toUpperCase() +
                          data.invalid.slice(1)}{' '}
                        |&nbsp;
                      </Box>
                    ) : (
                      <Box as="span" color="green">
                        设置有效!
                      </Box>
                    )}
                  </Box>
                </Tooltip>

                <Button
                  style={{ position: 'absolute', right: '20em' }}
                  color={'red'}
                  onClick={() => act('reset')}
                  tooltip="重置为默认!"
                >
                  重置
                </Button>

                <Button
                  style={{ position: 'absolute', right: '0.5em' }}
                  icon={data.enabled ? 'check-square-o' : 'square-o'}
                  color={data.enabled ? 'green' : 'red'}
                  onClick={() => act('toggle')}
                  disabled={data.race_disabled}
                  tooltip={
                    <>
                      切换这些食品偏好设置是否会在角色刷出时应用.
                      <Divider />
                      记住，这些大多是建议，你可以去扮演自己的角色喜欢某食物，即使它是不喜欢的食物类型!
                    </>
                  }
                >
                  使用自定义食物偏好
                </Button>
              </Box>
            }
          >
            {(data.race_disabled && (
              <ErrorOverlay>你使用的是一个不受食物偏好影响的种族!</ErrorOverlay>
            )) ||
              (!data.enabled && (
                <ErrorOverlay>你的食物偏好设置被禁用了!</ErrorOverlay>
              ))}
            <Box style={{ columns: '30em' }}>
              {Object.entries(data.food_types).map((element) => {
                const { 0: foodName, 1: foodPointValues } = element;
                return (
                  <Box key={foodName}>
                    <Section
                      title={
                        <>
                          {foodName}
                          {data.obscure_food_types[foodName] && (
                            <Tooltip content="这种食物不会占用你的喜爱数额.">
                              <Box
                                as="span"
                                fontSize={0.75}
                                verticalAlign={'top'}
                              >
                                <Icon name="star" style={{ color: 'orange' }} />
                              </Box>
                            </Tooltip>
                          )}
                        </>
                      }
                    >
                      <FoodButton
                        foodName={foodName}
                        foodPreference={FOOD_TOXIC}
                        selected={
                          data.selection[foodName] === FOOD_TOXIC ||
                          (!data.selection[foodName] &&
                            foodPointValues === FOOD_TOXIC)
                        }
                        content={<>有毒</>}
                        color="olive"
                        tooltip="你的角色吃掉有毒食物后会立刻呕吐."
                      />
                      <FoodButton
                        foodName={foodName}
                        foodPreference={FOOD_DISLIKED}
                        selected={
                          data.selection[foodName] === FOOD_DISLIKED ||
                          (!data.selection[foodName] &&
                            foodPointValues === FOOD_DISLIKED)
                        }
                        content={<>厌恶</>}
                        color="red"
                        tooltip="你的角色在吃下不喜欢的食物后会感到恶心，最终可能会呕吐."
                      />
                      <FoodButton
                        foodName={foodName}
                        foodPreference={FOOD_NEUTRAL}
                        selected={
                          data.selection[foodName] === FOOD_NEUTRAL ||
                          (!data.selection[foodName] &&
                            foodPointValues === FOOD_NEUTRAL)
                        }
                        content={<>中性</>}
                        color="yellow"
                        tooltip="你的角色对中性的食物没什么看法."
                      />
                      <FoodButton
                        foodName={foodName}
                        foodPreference={FOOD_LIKED}
                        selected={
                          data.selection[foodName] === FOOD_LIKED ||
                          (!data.selection[foodName] &&
                            foodPointValues === FOOD_LIKED)
                        }
                        content={<>喜爱</>}
                        color="green"
                        tooltip="你的角色喜爱并享受这些食物."
                      />
                    </Section>
                  </Box>
                );
              })}
            </Box>
          </StyleableSection>
        }
      </Window.Content>
    </Window>
  );
};

const FoodButton = (props) => {
  const { act } = useBackend();
  const { foodName, foodPreference, color, selected, ...rest } = props;
  return (
    <Button
      icon={selected ? 'check-square-o' : 'square-o'}
      color={selected ? color : 'grey'}
      onClick={() =>
        act('change_food', {
          food_name: foodName,
          food_preference: foodPreference,
        })
      }
      {...rest}
    />
  );
};

const ErrorOverlay = (props) => {
  return (
    <Dimmer>
      <Stack vertical mt="5.2em">
        <Stack.Item color="#bd2020" textAlign="center">
          {props.children}
        </Stack.Item>
      </Stack>
    </Dimmer>
  );
};
