import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Dropdown,
  LabeledList,
  NumberInput,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';
import {
  AtmosHandbookContent,
  atmosHandbookHooks,
} from './common/AtmosHandbook';
import { Gasmix, GasmixParser } from './common/GasmixParser';

type Chamber = {
  id: string;
  name: string;
  gasmix?: Gasmix;
  input_info?: { active: boolean; amount: number };
  output_info?: { active: boolean; amount: number };
};

export const AtmosControlConsole = (props) => {
  const { act, data } = useBackend<{
    chambers: Chamber[];
    maxInput: number;
    maxOutput: number;
    reconnecting: boolean;
    control: boolean;
  }>();
  const chambers = data.chambers || [];
  const [chamberId, setChamberId] = useState(chambers[0]?.id);
  const selectedChamber =
    chambers.length === 1
      ? chambers[0]
      : chambers.find((chamber) => chamber.id === chamberId);
  const [setActiveGasId, setActiveReactionId] = atmosHandbookHooks();
  return (
    <Window width={550} height={350}>
      <Window.Content scrollable>
        {chambers.length > 1 && (
          <Section title="仓室选择">
            <Dropdown
              width="100%"
              options={chambers.map((chamber) => chamber.name)}
              selected={selectedChamber?.name}
              onSelected={(value) =>
                setChamberId(
                  chambers.find((chamber) => chamber.name === value)?.id ||
                    chambers[0].id,
                )
              }
            />
          </Section>
        )}
        <Section
          title={selectedChamber ? selectedChamber.name : '仓室读数'}
          buttons={
            !!data.reconnecting && (
              <Button
                icon="undo"
                content="重连"
                onClick={() => act('reconnect')}
              />
            )
          }
        >
          {!!selectedChamber && !!selectedChamber.gasmix ? (
            <GasmixParser
              gasmix={selectedChamber.gasmix}
              gasesOnClick={setActiveGasId}
              reactionOnClick={setActiveReactionId}
            />
          ) : (
            <Box italic> {'检测不到传感器!'}</Box>
          )}
        </Section>
        {!!selectedChamber && !!data.control && (
          <Section title="仓室控制">
            <Stack>
              <Stack.Item grow>
                {selectedChamber.input_info ? (
                  <LabeledList>
                    <LabeledList.Item label="输入注入器">
                      <Button
                        icon={
                          selectedChamber.input_info.active
                            ? 'power-off'
                            : 'times'
                        }
                        content={
                          selectedChamber.input_info.active ? '注入' : '关闭'
                        }
                        selected={selectedChamber.input_info.active}
                        onClick={() =>
                          act('toggle_input', {
                            chamber: selectedChamber.id,
                          })
                        }
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="输入率">
                      <NumberInput
                        step={1}
                        value={Number(selectedChamber.input_info.amount)}
                        unit="L/s"
                        width="63px"
                        minValue={0}
                        maxValue={data.maxInput}
                        onChange={(value) =>
                          act('adjust_input', {
                            chamber: selectedChamber.id,
                            rate: value,
                          })
                        }
                      />
                    </LabeledList.Item>
                  </LabeledList>
                ) : (
                  <Box italic> {'未检测到输入设备!'}</Box>
                )}
              </Stack.Item>
              <Stack.Item grow>
                {selectedChamber.output_info ? (
                  <LabeledList>
                    <LabeledList.Item label="输出调节器">
                      <Button
                        icon={
                          selectedChamber.output_info.active
                            ? 'power-off'
                            : 'times'
                        }
                        content={
                          selectedChamber.output_info.active ? '开启' : '关闭'
                        }
                        selected={selectedChamber.output_info.active}
                        onClick={() =>
                          act('toggle_output', {
                            chamber: selectedChamber.id,
                          })
                        }
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="输出压力">
                      <NumberInput
                        value={Number(selectedChamber.output_info.amount)}
                        unit="kPa"
                        width="75px"
                        minValue={0}
                        maxValue={data.maxOutput}
                        step={10}
                        onChange={(value) =>
                          act('adjust_output', {
                            chamber: selectedChamber.id,
                            rate: value,
                          })
                        }
                      />
                    </LabeledList.Item>
                  </LabeledList>
                ) : (
                  <Box italic> {'未检测到输出设备!'} </Box>
                )}
              </Stack.Item>
            </Stack>
          </Section>
        )}
        <AtmosHandbookContent />
      </Window.Content>
    </Window>
  );
};
