// THIS IS A SKYRAT UI FILE
import { toFixed } from 'common/math';

import { useBackend } from '../backend';
import {
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

export const MicrofusionGunControl = (props) => {
  const { act, data } = useBackend();
  const { cell_data } = data;
  const { phase_emitter_data } = data;
  const {
    gun_name,
    gun_desc,
    gun_heat_dissipation,
    has_cell,
    has_emitter,
    has_attachments,
    attachments = [],
  } = data;
  return (
    <Window title={'Micron控制系统注册: ' + gun_name} width={500} height={700}>
      <Window.Content>
        <Stack vertical grow>
          <Stack.Item>
            <Section title={'枪械信息'}>
              <LabeledList>
                <LabeledList.Item label="名称">{gun_name}</LabeledList.Item>
                <LabeledList.Item label="描述">{gun_desc}</LabeledList.Item>
                <LabeledList.Item label="主动散热">
                  {gun_heat_dissipation + ' C/s'}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section
              title="电池"
              buttons={
                <Button
                  icon="eject"
                  content="取出电池"
                  disabled={!has_cell}
                  onClick={() => act('eject_cell')}
                />
              }
            >
              {has_cell ? (
                <LabeledList>
                  <LabeledList.Item label="电池类型">
                    {cell_data.type}
                  </LabeledList.Item>
                  <LabeledList.Item label="电池状况">
                    {cell_data.status ? '故障' : '正常'}
                  </LabeledList.Item>
                  <LabeledList.Item label="电池充能">
                    <ProgressBar
                      value={cell_data.charge}
                      minValue={0}
                      maxValue={cell_data.max_charge}
                      ranges={{
                        good: [
                          cell_data.max_charge * 0.85,
                          cell_data.max_charge,
                        ],
                        average: [
                          cell_data.max_charge * 0.25,
                          cell_data.max_charge * 0.85,
                        ],
                        bad: [0, cell_data.max_charge * 0.25],
                      }}
                    >
                      {cell_data.charge + '/' + cell_data.max_charge + 'MF'}
                    </ProgressBar>
                  </LabeledList.Item>
                  {!!cell_data.charge <= 0 && (
                    <LabeledList.Item>
                      <Section>
                        <NoticeBox color="bad">电池耗尽!</NoticeBox>
                      </Section>
                    </LabeledList.Item>
                  )}
                </LabeledList>
              ) : (
                <NoticeBox color="bad">未安装电池!</NoticeBox>
              )}
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section
              title="相位发射器"
              buttons={
                <Button
                  icon="eject"
                  content="取出发射器"
                  disabled={!has_emitter}
                  onClick={() => act('eject_emitter')}
                />
              }
            >
              {has_emitter ? (
                phase_emitter_data.damaged ? (
                  <NoticeBox color="bad">相位发射器受损!</NoticeBox>
                ) : (
                  <LabeledList>
                    <LabeledList.Item label="发射器类型">
                      {phase_emitter_data.type}
                    </LabeledList.Item>
                    <LabeledList.Item label="温度">
                      <ProgressBar
                        value={phase_emitter_data.current_heat}
                        minValue={0}
                        maxValue={phase_emitter_data.max_heat}
                        ranges={{
                          bad: [
                            phase_emitter_data.max_heat * 0.85,
                            phase_emitter_data.max_heat * 2,
                          ],
                          average: [
                            phase_emitter_data.max_heat * 0.25,
                            phase_emitter_data.max_heat * 0.85,
                          ],
                          good: [0, phase_emitter_data.max_heat * 0.25],
                        }}
                      >
                        {toFixed(phase_emitter_data.current_heat) +
                          ' C' +
                          ' (' +
                          phase_emitter_data.heat_percent +
                          '%)'}
                      </ProgressBar>
                    </LabeledList.Item>
                    <LabeledList.Item label="最大温度">
                      {phase_emitter_data.max_heat + ' C'}
                    </LabeledList.Item>
                    <LabeledList.Item label="温度功率百分比">
                      {phase_emitter_data.throttle_percentage + '% '}
                      <Button
                        icon="wrench"
                        content="超频"
                        color="bad"
                        disabled={!phase_emitter_data.hacked}
                        onClick={() => act('overclock_emitter')}
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="被动散热">
                      {phase_emitter_data.heat_dissipation_per_tick + ' C/s'}
                    </LabeledList.Item>
                    <LabeledList.Item label="冷却系统">
                      <Button
                        icon="snowflake"
                        content={
                          phase_emitter_data.cooling_system ? '在线' : '离线'
                        }
                        color={
                          phase_emitter_data.cooling_system ? 'blue' : 'bad'
                        }
                        disabled={!has_cell}
                        onClick={() => act('toggle_cooling_system')}
                      />
                      {' 系统冷却率: ' +
                        phase_emitter_data.cooling_system_rate +
                        ' C/s'}
                    </LabeledList.Item>
                    <LabeledList.Item label="总散热量">
                      {phase_emitter_data.cooling_system
                        ? phase_emitter_data.heat_dissipation_per_tick +
                          gun_heat_dissipation +
                          phase_emitter_data.cooling_system_rate +
                          ' C/s'
                        : phase_emitter_data.heat_dissipation_per_tick +
                          gun_heat_dissipation +
                          ' C/s'}
                    </LabeledList.Item>
                    <LabeledList.Item label="完整性">
                      <ProgressBar
                        value={phase_emitter_data.integrity}
                        minValue={0}
                        maxValue={100}
                        ranges={{
                          good: [85, 100],
                          average: [25, 85],
                          bad: [0, 25],
                        }}
                      >
                        {phase_emitter_data.integrity + '%'}
                      </ProgressBar>
                    </LabeledList.Item>
                    <LabeledList.Item label="每次射击处理时间">
                      <ProgressBar
                        value={phase_emitter_data.process_time}
                        minValue={0}
                        maxValue={5}
                        ranges={{
                          good: [0, 1],
                          average: [1, 3],
                          bad: [3, 5],
                        }}
                      >
                        {phase_emitter_data.process_time / 10 + 's'}
                      </ProgressBar>
                    </LabeledList.Item>
                    {phase_emitter_data.heat_percent >=
                      phase_emitter_data.throttle_percentage && (
                      <LabeledList.Item>
                        <NoticeBox color="orange">热功率启动!</NoticeBox>
                      </LabeledList.Item>
                    )}
                    {phase_emitter_data.current_heat >=
                      phase_emitter_data.max_heat && (
                      <LabeledList.Item>
                        <NoticeBox color="bad">过热!</NoticeBox>
                      </LabeledList.Item>
                    )}
                  </LabeledList>
                )
              ) : (
                <NoticeBox color="bad">未安装相位发射器!</NoticeBox>
              )}
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section title={'配件'}>
              {has_attachments ? (
                attachments.map((attachment, index) => (
                  <Section
                    key={index}
                    title={attachment.name}
                    buttons={
                      <Button
                        icon="eject"
                        content="取出配件"
                        onClick={() =>
                          act('remove_attachment', {
                            attachment_ref: attachment.ref,
                          })
                        }
                      />
                    }
                  >
                    <LabeledList>
                      <LabeledList.Item label="描述">
                        {attachment.desc}
                      </LabeledList.Item>
                      <LabeledList.Item label="槽位">
                        {attachment.slot}
                      </LabeledList.Item>
                      {attachment.information && (
                        <LabeledList.Item label="信息">
                          {attachment.information}
                        </LabeledList.Item>
                      )}
                      {!!attachment.has_modifications &&
                        attachment.modify.map((mod, index) => (
                          <LabeledList.Item
                            key={index}
                            buttons={
                              <Button
                                key={index}
                                icon={mod.icon}
                                color={mod.color}
                                content={mod.title}
                                onClick={() =>
                                  act('modify_attachment', {
                                    attachment_ref: attachment.ref,
                                    modify_ref: mod.reference,
                                  })
                                }
                              />
                            }
                          />
                        ))}
                    </LabeledList>
                  </Section>
                ))
              ) : (
                <NoticeBox color="blue">未装载配件!</NoticeBox>
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
