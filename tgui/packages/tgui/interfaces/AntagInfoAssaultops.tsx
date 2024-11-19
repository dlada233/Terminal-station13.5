// THIS IS A SKYRAT UI FILE
import { BooleanLike } from 'common/react';
import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Divider,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
  Tabs,
} from '../components';
import { Window } from '../layouts';
import { Rules } from './AntagInfoRules';

type Objectives = {
  count: number;
  name: string;
  explanation: string;
  complete: BooleanLike;
};

type AvailableTargets = {
  name: string;
  job: string;
};

type ExtractedTargets = {
  name: string;
  job: string;
};

type GoldeneyeKeys = {
  coord_x: number;
  coord_y: number;
  coord_z: number;
  name: string;
  ref: string;
  selected: BooleanLike;
};

type Info = {
  equipped: number;
  required_keys: number;
  uploaded_keys: number;
  objectives: Objectives[];
  available_targets: AvailableTargets[];
  extracted_targets: ExtractedTargets[];
  goldeneye_keys: GoldeneyeKeys[];
};

export const AntagInfoAssaultops = (props) => {
  const [tab, setTab] = useState(1);
  const { data } = useBackend<Info>();
  const { required_keys, uploaded_keys, objectives } = data;
  return (
    <Window theme="hackerman" width={650} height={650}>
      <Window.Content>
        <Stack vertical>
          <Stack.Item>
            <Section>
              <Stack.Item grow={1} align="center">
                <Box fontSize={0.8} textAlign="right">
                  GoldeneEye-黄金眼防御网络 &nbsp;
                  <Box color="green" as="span">
                    连接确认
                  </Box>
                </Box>
              </Stack.Item>
              <Section title="黄金眼颠覆进程" fontSize="15px">
                {uploaded_keys >= required_keys ? (
                  <Box fontSize="20px" color="green">
                    黄金眼已启动，干得好.
                  </Box>
                ) : (
                  <Stack>
                    <Stack.Item grow>
                      <ProgressBar
                        color="green"
                        value={uploaded_keys}
                        minValue={0}
                        maxValue={required_keys}
                      />
                    </Stack.Item>
                    <Stack.Item color="yellow">
                      需求密钥: {required_keys}
                    </Stack.Item>
                    <Stack.Item color="green">
                      已上传密钥: {uploaded_keys}
                    </Stack.Item>
                  </Stack>
                )}
              </Section>
            </Section>
            <Section title="目标">
              <LabeledList>
                {objectives.map((objective) => (
                  <LabeledList.Item
                    key={objective.count}
                    label={objective.name}
                    color={objective.complete ? 'good' : 'bad'}
                  >
                    {objective.explanation}
                  </LabeledList.Item>
                ))}
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Stack vertical mb={1}>
              <Stack.Item>
                <Tabs fill>
                  <Tabs.Tab
                    width="100%"
                    selected={tab === 1}
                    onClick={() => setTab(1)}
                  >
                    目标
                  </Tabs.Tab>
                  <Tabs.Tab
                    width="100%"
                    selected={tab === 2}
                    onClick={() => setTab(2)}
                  >
                    黄金眼密钥
                  </Tabs.Tab>
                </Tabs>
              </Stack.Item>
            </Stack>
            {tab === 1 && <TargetPrintout />}
            {tab === 2 && <KeyPrintout />}
          </Stack.Item>
          <Stack.Item>
            <Rules />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const TargetPrintout = (props) => {
  const { act, data } = useBackend<Info>();
  const { available_targets, extracted_targets } = data;
  return (
    <Section>
      <Box textColor="red" fontSize="20px" mb={1}>
        目标列表
      </Box>
      <Stack>
        <Stack.Item grow>
          <Section title="可用目标">
            <Box textColor="red" mb={2}>
              这些是你还没有提取密钥的目标，它们可以被in-TERROR-gator提取出来.
            </Box>
            <LabeledList>
              {available_targets.map((target) => (
                <LabeledList.Item
                  key={target.name}
                  label={target.name}
                  color="red"
                >
                  {target.job}
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        </Stack.Item>
        <Divider vertical />
        <Stack.Item grow>
          <Section title="已提取目标">
            <Box textColor="green" mb={2}>
              这些是你已经提取了密钥的目标，他们无法被再次提取.
            </Box>
            <LabeledList>
              {extracted_targets.map((target) => (
                <LabeledList.Item
                  key={target.name}
                  label={target.name}
                  color="good"
                >
                  {target.job}
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
// Utils have goldeneye key list, current heads of staff, extracted heads
// Common target button, track key button

const KeyPrintout = (props) => {
  const { act, data } = useBackend<Info>();
  const { goldeneye_keys } = data;
  return (
    <Section>
      <Box textColor="red" fontSize="20px">
        黄金眼密钥
      </Box>
      <Box mb={1}>当前存在的黄金眼密钥，选择它来追踪到使用HUD位置</Box>
      <Stack vertical fill>
        <Stack.Item>
          <Section>
            <Stack vertical>
              {goldeneye_keys.map((key) => (
                <Stack.Item key={key.name}>
                  <Button
                    width="100%"
                    textAlign="center"
                    color="yellow"
                    disabled={key.selected}
                    key={key.name}
                    icon="key"
                    content={
                      key.selected
                        ? key.name +
                          ' (' +
                          key.coord_x +
                          ', ' +
                          key.coord_y +
                          ', ' +
                          key.coord_z +
                          ')' +
                          ' (追踪中)'
                        : key.name +
                          ' (' +
                          key.coord_x +
                          ', ' +
                          key.coord_y +
                          ', ' +
                          key.coord_z +
                          ')'
                    }
                    onClick={() =>
                      act('track_key', {
                        key_ref: key.ref,
                      })
                    }
                  />
                </Stack.Item>
              ))}
            </Stack>
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
