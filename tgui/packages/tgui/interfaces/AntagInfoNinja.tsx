import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Icon, Section, Stack } from '../components';
import { Window } from '../layouts';
import { Rules } from './AntagInfoRules'; // SKYRAT EDIT ADDITION
import {
  Objective,
  ObjectivePrintout,
  ReplaceObjectivesButton,
} from './common/Objectives';

const ninja_emphasis = {
  color: 'red',
};

type NinjaInfo = {
  objectives: Objective[];
  can_change_objective: BooleanLike;
};

export const AntagInfoNinja = (props) => {
  const { data } = useBackend<NinjaInfo>();
  const { objectives, can_change_objective } = data;
  return (
    <Window width={550} height={450} theme="hackerman">
      <Window.Content>
        <Icon
          size={30}
          name="spider"
          color="#003300"
          position="absolute"
          top="10%"
          left="10%"
        />
        <Section scrollable fill>
          <Stack vertical textColor="green">
            <Stack.Item textAlign="center" fontSize="20px">
              你是蜘蛛众的精英佣兵.
              <br />
              一名<span style={ninja_emphasis}>太空忍者</span>!
            </Stack.Item>
            <Stack.Item textAlign="center" italic>
              善战者，攻其所不守，守其所不攻.
            </Stack.Item>
            <Stack.Item>
              <Section fill>
                你身上的先进忍者模块服包含了多种强大的模块.
                <br /> 右键空间站APC即可吸干其中的电力为自己所用.
                <br />
                右键其他机器或物品也可以进行骇入，产生不同的效果，穿着你的忍者服多多尝试!
              </Section>
            </Stack.Item>
            {/* SKYRAT EDIT ADDITION START */}
            <Stack.Item>
              <Rules />
            </Stack.Item>
            {/* SKYRAT EDIT ADDITION END */}
            <Stack.Item>
              <ObjectivePrintout
                objectives={objectives}
                objectiveFollowup={
                  <ReplaceObjectivesButton
                    can_change_objective={can_change_objective}
                    button_title={'调整任务参数'}
                    button_colour={'green'}
                  />
                }
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
