import { useBackend } from '../../backend';
import { Box, Button, Dimmer, Section, Stack } from '../../components';
import { ObjectiveElement } from './ObjectiveMenu';

type PrimaryObjectiveMenuProps = {
  primary_objectives;
  final_objective;
  can_renegotiate;
};

export const PrimaryObjectiveMenu = (props: PrimaryObjectiveMenuProps) => {
  const { act } = useBackend();
  const { primary_objectives, final_objective, can_renegotiate } = props;
  return (
    <Section fill>
      <Section>
        <Box mt={3} mb={3} bold fontSize={1.2} align="center" color="white">
          {'特工，你的主要目标如下，不惜一切代价完成它们.'}
        </Box>
        <Box mt={3} mb={5} bold fontSize={1.2} align="center" color="white">
          {'完成次要目标可以让你赚取额外的TC，购买更好的装备.'}
        </Box>
      </Section>
      {final_objective && (
        <Dimmer>
          <Box
            color="red"
            fontFamily={'Bahnschrift'}
            fontSize={3}
            align={'top'}
            as="span"
          >
            优先信息
            <br />
            来源: xxx.xxx.xxx.224:41394
            <br />
            <br />
            \\正在进行汇报.
            <br />
            \\最终目标确认完成. <br />
            \\你的工作结束了，特工.
            <br />
            <br />
            连接已关闭_
          </Box>
        </Dimmer>
      )}
      <Section>
        <Stack vertical fill scrollable>
          {primary_objectives.map((prim_obj, index) => (
            <Stack.Item key={index}>
              <ObjectiveElement
                key={prim_obj.id}
                name={prim_obj['task_name']}
                description={prim_obj['task_text']}
                dangerLevel={{
                  minutesLessThan: 0,
                  title: 'none',
                  gradient:
                    index === primary_objectives.length - 1
                      ? 'reputation-good'
                      : 'reputation-very-good',
                }}
                telecrystalReward={0}
                telecrystalPenalty={0}
                progressionReward={0}
                originalProgression={0}
                hideTcRep
                canAbort={false}
                grow={false}
                finalObjective={false}
              />
            </Stack.Item>
          ))}
        </Stack>
      </Section>
      {!!can_renegotiate && (
        <Box mt={3} mb={5} bold fontSize={1.2} align="center" color="white">
          <Button
            content={'重新拟定合约'}
            tooltip={
              '用一个自定义目标取代你现有的主要目标，该操作只能执行一次.'
            }
            onClick={() => act('renegotiate_objectives')}
          />
        </Box>
      )}
    </Section>
  );
};
