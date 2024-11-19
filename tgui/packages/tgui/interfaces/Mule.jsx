import { useBackend } from '../backend';
import {
  Button,
  Dropdown,
  Flex,
  LabeledList,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

export const Mule = (props) => {
  const { act, data } = useBackend();
  const {
    on,
    cell,
    cellPercent,
    load,
    mode,
    modeStatus,
    autoReturn,
    autoPickup,
    reportDelivery,
    destination,
    home,
    id,
    allow_possession,
    possession_enabled,
    pai_inserted,
    destinations = [],
  } = data;
  const locked = data.locked && !data.siliconUser;
  return (
    <Window width={350} height={445}>
      <Window.Content>
        <InterfaceLockNoticeBox />
        <Section
          title="状态"
          minHeight="110px"
          buttons={
            <>
              <Button
                icon="fa-poll-h"
                content="重命名"
                onClick={() => act('rename')}
              />
              {!locked && (
                <Button
                  icon={on ? 'power-off' : 'times'}
                  content={on ? '开' : '关'}
                  selected={on}
                  onClick={() => act('on')}
                />
              )}
            </>
          }
        >
          <ProgressBar
            value={cell ? cellPercent / 100 : 0}
            color={cell ? 'good' : 'bad'}
          />
          <Flex mt={1}>
            <Flex.Item grow={1} basis={0}>
              <LabeledList>
                <LabeledList.Item label="模式" color={modeStatus}>
                  {mode}
                </LabeledList.Item>
              </LabeledList>
            </Flex.Item>
            <Flex.Item grow={1} basis={0}>
              <LabeledList>
                <LabeledList.Item
                  label="装载"
                  color={load ? 'good' : 'average'}
                >
                  {load || '无'}
                </LabeledList.Item>
              </LabeledList>
            </Flex.Item>
          </Flex>
        </Section>
        {!locked && (
          <Section
            title="控制面板"
            buttons={
              <>
                {!!load && (
                  <Button
                    icon="eject"
                    content="卸载"
                    onClick={() => act('unload')}
                  />
                )}
                {!!pai_inserted && (
                  <Button
                    icon="eject"
                    content="取出PAI"
                    onClick={() => act('eject_pai')}
                  />
                )}
              </>
            }
          >
            <LabeledList>
              <LabeledList.Item label="ID">
                <Button content={id} onClick={() => act('setid')} />
              </LabeledList.Item>
              <LabeledList.Item label="归位点">
                <Button content={home} onClick={() => act('sethome')} />
              </LabeledList.Item>
              <LabeledList.Item label="目的地">
                <Dropdown
                  over
                  selected={destination || '无'}
                  options={destinations}
                  width="188px"
                  onSelected={(value) => act('destination', { value })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="行动">
                <Button
                  icon="stop"
                  color="bad"
                  content="停止"
                  onClick={() => act('stop')}
                />
                <Button
                  icon="play"
                  color="average"
                  content="出发"
                  onClick={() => act('go')}
                />
                <Button
                  icon="home"
                  content="归位"
                  onClick={() => act('home')}
                />
              </LabeledList.Item>
              <LabeledList.Item label="设置">
                <Button.Checkbox
                  checked={autoReturn}
                  content="自动归位"
                  onClick={() => act('autored')}
                />
                <br />
                <Button.Checkbox
                  checked={autoPickup}
                  content="自动接取"
                  onClick={() => act('autopick')}
                />
                <br />
                <Button.Checkbox
                  checked={reportDelivery}
                  content="报告交付"
                  onClick={() => act('report')}
                />
                <br />
                {allow_possession && (
                  <Button.Checkbox
                    checked={possession_enabled}
                    content="下载人格"
                    onClick={() => act('toggle_personality')}
                  />
                )}
              </LabeledList.Item>
            </LabeledList>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
