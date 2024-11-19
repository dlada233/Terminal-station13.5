// THIS IS A SKYRAT UI FILE
import { useState } from 'react';

import { useBackend } from '../backend';
import {
  BlockQuote,
  Box,
  Button,
  Collapsible,
  Dropdown,
  Flex,
  Icon,
  Input,
  LabeledList,
  ProgressBar,
  Section,
  Table,
} from '../components';
import { TableCell, TableRow } from '../components/Table';
import { Window } from '../layouts';

export const NifPanel = (props) => {
  const { act, data } = useBackend();
  const {
    linked_mob_name,
    loaded_nifsofts,
    max_nifsofts,
    max_power,
    current_theme,
  } = data;
  const [settingsOpen, setSettingsOpen] = useState(0);

  return (
    <Window
      title={'纳米植入物框架-Nanite Implant Framework'}
      width={500}
      height={400}
      resizable
      theme={current_theme}
    >
      <Window.Content>
        <Section
          title={`欢迎来到你的NIF, ${linked_mob_name}`}
          buttons={
            <Button
              icon="cogs"
              tooltip="NIF设置"
              tooltiptooltipPosition="bottom-end"
              selected={settingsOpen}
              onClick={() => setSettingsOpen(!settingsOpen)}
            />
          }
        >
          {(settingsOpen && <NifSettings />) || <NifStats />}
          {(!settingsOpen && (
            <Section
              title={`NIF软件程序 (${
                max_nifsofts - loaded_nifsofts.length
              } 剩余槽位)`}
              right
            >
              {(loaded_nifsofts.length && (
                <Flex direction="column">
                  {loaded_nifsofts.map((nifsoft) => (
                    <Flex.Item key={nifsoft.name}>
                      <Collapsible
                        title={
                          <>
                            {<Icon name={nifsoft.ui_icon} />}
                            {nifsoft.name + '  '}
                          </>
                        }
                        buttons={
                          <Button
                            icon="play"
                            color="green"
                            onClick={() =>
                              act('activate_nifsoft', {
                                activated_nifsoft: nifsoft.reference,
                              })
                            }
                          />
                        }
                      >
                        <Table>
                          <TableRow>
                            <TableCell>
                              <Button
                                icon="bolt"
                                color="yellow"
                                tooltip="当激活NIF软件时，会使用多少百分比的能量."
                              />
                              {nifsoft.activation_cost === 0
                                ? ' 无激活耗费'
                                : ' ' +
                                  (nifsoft.activation_cost / max_power) * 100 +
                                  '% 每次激活'}
                            </TableCell>
                            <TableCell>
                              <Button
                                icon="battery-half"
                                color="orange"
                                tooltip="NIF软件在激活时使用的能量."
                                disabled={nifsoft.active_cost === 0}
                              />
                              {nifsoft.active_cost === 0
                                ? ' 无激活的耗费'
                                : ' ' +
                                  (nifsoft.active_cost / max_power) * 100 +
                                  '% 每次激活耗费'}
                            </TableCell>
                            <TableCell>
                              <Button
                                icon="exclamation"
                                color={nifsoft.active ? 'green' : 'red'}
                                disabled={!nifsoft.active_mode}
                                tooltip="显示程序当前是否处于激活状态."
                              />
                              {nifsoft.active
                                ? ' 这个NIF软件已激活!'
                                : ' 这个NIF软件未激活!'}
                            </TableCell>
                          </TableRow>
                        </Table>
                        <br />
                        <BlockQuote preserveWhitespace>
                          {nifsoft.desc}
                        </BlockQuote>
                        {nifsoft.able_to_keep ? (
                          <box>
                            <br />
                            <Button
                              icon="floppy-disk"
                              content={
                                nifsoft.keep_installed
                                  ? 'NIF软件将会被保存'
                                  : 'NIF软件不会被保存'
                              }
                              color={nifsoft.keep_installed ? 'green' : 'red'}
                              fluid
                              tooltip="切换NIF软件是否会保存到不同轮班回合."
                              onClick={() =>
                                act('toggle_keeping_nifsoft', {
                                  nifsoft_to_keep: nifsoft.reference,
                                })
                              }
                            />
                          </box>
                        ) : (
                          <> </>
                        )}
                        <box>
                          <br />
                          <Button.Confirm
                            icon="trash"
                            content="卸载"
                            color="red"
                            fluid
                            tooltip="卸载所选NIF软件"
                            confirmContent="你确定?"
                            confirmIcon="question"
                            onClick={() =>
                              act('uninstall_nifsoft', {
                                nifsoft_to_remove: nifsoft.reference,
                              })
                            }
                          />
                        </box>
                      </Collapsible>
                    </Flex.Item>
                  ))}
                </Flex>
              )) || (
                <Box>
                  {' '}
                  <center>
                    <b>目前没有安装NIF软件</b>
                  </center>{' '}
                </Box>
              )}
            </Section>
          )) || (
            <Section title={'产品信息'}>
              <NifProductNotes />
            </Section>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

const NifSettings = (props) => {
  const { act, data } = useBackend();
  const {
    nutrition_drain,
    ui_themes,
    current_theme,
    nutrition_level,
    blood_drain,
    minimum_blood_level,
    blood_level,
    stored_points,
  } = data;
  return (
    <LabeledList>
      <LabeledList.Item label="NIF主题">
        <Dropdown
          width="100%"
          selected={current_theme}
          options={ui_themes}
          onSelected={(value) => act('change_theme', { target_theme: value })}
        />
      </LabeledList.Item>
      <LabeledList.Item label="NIF自定义文本">
        <Input
          onChange={(e, value) =>
            act('change_examine_text', { new_text: value })
          }
          width="100%"
        />
      </LabeledList.Item>
      <LabeledList.Item label="营养供能">
        <Button
          fluid
          content={nutrition_drain === 0 ? '营养供能关闭' : '营养供能开启'}
          tooltip="切换NIF是否使用食物作为能量来源，开启后可能导致身体饥饿."
          onClick={() => act('toggle_nutrition_drain')}
          disabled={nutrition_level < 26}
        />
      </LabeledList.Item>
      <LabeledList.Item label="血液供能">
        <Button
          fluid
          content={blood_drain === 0 ? '血液供能关闭' : '血液供能开启'}
          tooltip="切换NIF是否吸取身体血液作为能量来源，一旦血液水平接近危险值将会自动关闭."
          onClick={() => act('toggle_blood_drain')}
          disabled={blood_level < minimum_blood_level}
        />
      </LabeledList.Item>
      <LabeledList.Item
        label="奖励积分"
        buttons={
          <Button
            icon="info"
            tooltip="奖励积分是通过购买NIF软件获得的替代货币，奖励积分可在不同轮班回合间携带."
          />
        }
      >
        {stored_points}
      </LabeledList.Item>
    </LabeledList>
  );
};

const NifProductNotes = (props) => {
  const { act, data } = useBackend();
  const { product_notes } = data;
  return <BlockQuote>{product_notes}</BlockQuote>;
};

const NifStats = (props) => {
  const { act, data } = useBackend();
  const {
    max_power,
    power_level,
    durability,
    power_usage,
    nutrition_drain,
    blood_drain,
    max_durability,
  } = data;

  return (
    <Box>
      <LabeledList>
        <LabeledList.Item label="NIF情况">
          <ProgressBar
            value={durability}
            minValue={0}
            maxValue={max_durability}
            ranges={{
              good: [max_durability * 0.66, max_durability],
              average: [max_durability * 0.33, max_durability * 0.66],
              bad: [0, max_durability * 0.33],
            }}
            alertAfter={max_durability * 0.25}
          />
        </LabeledList.Item>
        <LabeledList.Item label="NIF能源">
          <ProgressBar
            value={power_level}
            minValue={0}
            maxValue={max_power}
            ranges={{
              good: [max_power * 0.66, max_power],
              average: [max_power * 0.33, max_power * 0.66],
              bad: [0, max_power * 0.33],
            }}
            alertAfter={max_power * 0.1}
          >
            {(power_level / max_power) * 100 +
              '%' +
              ' (' +
              (power_usage / max_power) * 100 +
              '% 用量)'}
          </ProgressBar>
        </LabeledList.Item>
        {nutrition_drain === 1 && (
          <LabeledList.Item label="用户营养">
            <NifNutritionBar />
          </LabeledList.Item>
        )}
        {blood_drain === 1 && (
          <LabeledList.Item label="用户血含量">
            <NifBloodBar />
          </LabeledList.Item>
        )}
      </LabeledList>
    </Box>
  );
};

const NifNutritionBar = (props) => {
  const { act, data } = useBackend();
  const { nutrition_level } = data;
  return (
    <ProgressBar
      value={nutrition_level}
      minValue={0}
      maxValue={550}
      ranges={{
        good: [250, Infinity],
        average: [150, 250],
        bad: [0, 150],
      }}
    />
  );
};

const NifBloodBar = (props) => {
  const { act, data } = useBackend();
  const { blood_level, minimum_blood_level, max_blood_level } = data;
  return (
    <ProgressBar
      value={blood_level}
      minValue={0}
      maxValue={max_blood_level}
      ranges={{
        good: [minimum_blood_level, Infinity],
        average: [336, minimum_blood_level],
        bad: [0, 336],
      }}
    />
  );
};
