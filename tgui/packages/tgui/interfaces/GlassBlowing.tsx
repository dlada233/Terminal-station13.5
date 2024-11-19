// THIS IS A SKYRAT UI FILE
import { toFixed } from 'common/math';
import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  Flex,
  ProgressBar,
  Section,
  Stack,
  Table,
} from '../components';
import { Window } from '../layouts';

type GlassData = {
  hasGlass: BooleanLike;
  inUse: BooleanLike;
  glass: Glass;
};

type Glass = {
  chosenItem: CraftItem;
  stepsRemaining: RemainingSteps;
  timeLeft: number;
  totalTime: number;
  isFinished: BooleanLike;
};

type CraftItem = {
  name: string;
  type: string;
};

type RemainingSteps = {
  blow: number;
  spin: number;
  paddle: number;
  shear: number;
  jacks: number;
};

export const GlassBlowing = (props) => {
  const { act, data } = useBackend<GlassData>();
  const { glass, inUse } = data;

  return (
    <Window width={335} height={325}>
      <Window.Content scrollable>
        <Section
          title={glass && glass.timeLeft ? '熔融玻璃' : '冷却玻璃'}
          buttons={
            <Button
              icon={
                glass && glass.isFinished
                  ? 'check'
                  : glass && glass.timeLeft
                    ? 'triangle-exclamation'
                    : 'arrow-right'
              }
              color={
                glass && glass.isFinished
                  ? 'good'
                  : glass && glass.timeLeft
                    ? 'red'
                    : 'default'
              }
              tooltipPosition="bottom"
              tooltip={
                glass && glass.timeLeft
                  ? '现在碰这个东西之前你可能需要三思了...'
                  : '它已经冷却了，可以随意操作.'
              }
              content={glass && glass.isFinished ? '完成制作' : '移除'}
              disabled={!glass || inUse}
              onClick={() => act('Remove')}
            />
          }
        />
        {glass && !glass.chosenItem && (
          <Section title="选择制作类型">
            <Stack fill vertical>
              <Stack.Item>
                <Box>你要制作什么?</Box>
              </Stack.Item>

              <Stack.Item>
                <Button
                  content="盘子"
                  disabled={inUse}
                  onClick={() => act('Plate')}
                />
                <Button
                  content="碗"
                  tooltipPosition="bottom"
                  disabled={inUse}
                  onClick={() => act('Bowl')}
                />
                <Button
                  content="球体"
                  disabled={inUse}
                  onClick={() => act('Globe')}
                />
                <Button
                  content="杯子"
                  disabled={inUse}
                  onClick={() => act('Cup')}
                />
                <Button
                  content="透镜"
                  tooltipPosition="bottom"
                  disabled={inUse}
                  onClick={() => act('Lens')}
                />
                <Button
                  content="瓶子"
                  disabled={inUse}
                  onClick={() => act('Bottle')}
                />
              </Stack.Item>
            </Stack>
          </Section>
        )}
        {glass && glass.chosenItem && (
          <>
            <Section title="剩余步骤:">
              <Stack fill vertical>
                <Stack.Item>
                  <Box>
                    你正在制作{glass.chosenItem.name}.
                    <br />
                    <br />
                  </Box>
                </Stack.Item>
                <Table>
                  <Stack.Item>
                    {glass.stepsRemaining.blow !== 0 && (
                      <Table.Cell>
                        <Button
                          content="吹气"
                          icon="fire"
                          color="orange"
                          disabled={inUse || !glass.timeLeft}
                          tooltipPosition="bottom"
                          tooltip={
                            glass.timeLeft === 0 ? '需要加热到熔化.' : ''
                          }
                          onClick={() => act('Blow')}
                        />
                        &nbsp;x{glass.stepsRemaining.blow}
                      </Table.Cell>
                    )}
                    {glass.stepsRemaining.spin !== 0 && (
                      <Table.Cell>
                        <Button
                          content="旋转"
                          icon="fire"
                          color="orange"
                          disabled={inUse || !glass.timeLeft}
                          tooltipPosition="bottom"
                          tooltip={
                            glass.timeLeft === 0 ? '需要加热到熔化.' : ''
                          }
                          onClick={() => act('Spin')}
                        />
                        &nbsp;x{glass.stepsRemaining.spin}
                      </Table.Cell>
                    )}
                    {glass.stepsRemaining.paddle !== 0 && (
                      <Table.Cell>
                        <Button
                          content="塑形"
                          disabled={inUse}
                          tooltipPosition="bottom"
                          tooltip={'你需要一根塑形棒.'}
                          onClick={() => act('Paddle')}
                        />
                        &nbsp;x{glass.stepsRemaining.paddle}
                      </Table.Cell>
                    )}
                    {glass.stepsRemaining.shear !== 0 && (
                      <Table.Cell>
                        <Button
                          content="剪刀"
                          disabled={inUse}
                          tooltipPosition="bottom"
                          tooltip={'你需要使用剪刀.'}
                          onClick={() => act('Shear')}
                        />
                        &nbsp;x{glass.stepsRemaining.shear}
                      </Table.Cell>
                    )}
                    {glass.stepsRemaining.jacks !== 0 && (
                      <Table.Cell>
                        <Button
                          content="镊子"
                          disabled={inUse}
                          tooltipPosition="bottom"
                          tooltip={'你需要使用镊子.'}
                          onClick={() => act('Jacks')}
                        />
                        &nbsp;x{glass.stepsRemaining.jacks}
                      </Table.Cell>
                    )}
                  </Stack.Item>
                </Table>
              </Stack>
            </Section>
            <Section title>
              <Flex direction="row-reverse">
                <Flex.Item>
                  <Button
                    icon="times"
                    color={glass.timeLeft ? 'orange' : 'default'}
                    content="取消制作"
                    disabled={inUse}
                    onClick={() => act('Cancel')}
                  />
                </Flex.Item>
              </Flex>
            </Section>
          </>
        )}
        {glass && glass.timeLeft !== 0 && (
          <Section title="热度">
            <ProgressBar
              value={glass.timeLeft / glass.totalTime}
              ranges={{
                red: [0.8, Infinity],
                orange: [0.65, 0.8],
                yellow: [0.3, 0.65],
                blue: [0.05, 0.3],
                black: [-Infinity, 0.05],
              }}
              style={{
                backgroundImage: 'linear-gradient(to right, blue, yellow, red)',
              }}
            >
              <AnimatedNumber
                value={glass.timeLeft}
                format={(value) => toFixed(value, 1)}
              />
              {'/' + glass.totalTime.toFixed(1)}
            </ProgressBar>
          </Section>
        )}
        {glass && glass.timeLeft === 0 && (
          <Section title="热度">
            <ProgressBar
              value={0 / 0}
              ranges={{}}
              style={{
                backgroundImage: 'grey',
              }}
            >
              <AnimatedNumber value={0} />
            </ProgressBar>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
