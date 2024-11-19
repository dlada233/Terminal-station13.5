import { useBackend } from '../backend';
import {
  Box,
  Button,
  Input,
  LabeledControls,
  LabeledList,
  NoticeBox,
  NumberInput,
  Section,
  Table,
} from '../components';
import { RADIO_CHANNELS } from '../constants';
import { Window } from '../layouts';

export const Telecomms = (props) => {
  const { act, data } = useBackend();
  const {
    type,
    minfreq,
    maxfreq,
    frequency,
    multitool,
    multibuff,
    toggled,
    id,
    network,
    prefab,
    changefrequency,
    currfrequency,
    broadcasting,
    receiving,
  } = data;
  const linked = data.linked || [];
  const frequencies = data.frequencies || [];
  return (
    <Window title={id} width={400} height={600}>
      <Window.Content scrollable>
        {!multitool && <NoticeBox>使用多功能工具来进行更改.</NoticeBox>}
        <Section title="设置">
          <LabeledList>
            <LabeledList.Item
              label="电源"
              buttons={
                <Button
                  icon={toggled ? 'power-off' : 'times'}
                  content={toggled ? '开' : '关'}
                  color={toggled ? 'good' : 'bad'}
                  disabled={!multitool}
                  onClick={() => act('toggle')}
                />
              }
            />
            <LabeledList.Item
              label="识别字符"
              buttons={
                <Input
                  width={13}
                  value={id}
                  onChange={(e, value) => act('id', { value })}
                />
              }
            />
            <LabeledList.Item
              label="网络"
              buttons={
                <Input
                  width={10}
                  value={network}
                  defaultValue={'tcommsat'}
                  onChange={(e, value) => act('network', { value })}
                />
              }
            />
            <LabeledList.Item
              label="预制"
              buttons={
                <Button
                  icon={prefab ? 'check' : 'times'}
                  content={prefab ? 'True' : 'False'}
                  disabled={'True'}
                />
              }
            />
          </LabeledList>
        </Section>
        {!!(toggled && multitool) && (
          <Box>
            {type === 'bus' && (
              <Section title="Bus">
                <Table>
                  <Table.Row>
                    <Table.Cell>更改频率:</Table.Cell>
                    <Table.Cell>
                      {RADIO_CHANNELS.find(
                        (channel) => channel.freq === changefrequency,
                      ) && (
                        <Box
                          inline
                          color={
                            RADIO_CHANNELS.find(
                              (channel) => channel.freq === changefrequency,
                            ).color
                          }
                          ml={2}
                        >
                          [
                          {
                            RADIO_CHANNELS.find(
                              (channel) => channel.freq === changefrequency,
                            ).name
                          }
                          ]
                        </Box>
                      )}
                    </Table.Cell>
                    <NumberInput
                      animate
                      unit="kHz"
                      step={0.2}
                      stepPixelSize={10}
                      minValue={minfreq / 10}
                      maxValue={maxfreq / 10}
                      value={changefrequency / 10}
                      onChange={(value) => act('change_freq', { value })}
                    />
                    <Button
                      icon={'times'}
                      disabled={changefrequency === 0}
                      onClick={() => act('change_freq', { value: 10001 })}
                    />
                  </Table.Row>
                </Table>
              </Section>
            )}
            {type === 'relay' && (
              <Section title="转接">
                <Button
                  content={'接收'}
                  icon={receiving ? 'volume-up' : 'volume-mute'}
                  color={receiving ? '' : 'bad'}
                  onClick={() => act('receive')}
                />
                <Button
                  content={'播送'}
                  icon={broadcasting ? 'microphone' : 'microphone-slash'}
                  color={broadcasting ? '' : 'bad'}
                  onClick={() => act('broadcast')}
                />
              </Section>
            )}
            <Section title="已连接网络实体">
              <Table>
                {linked.map((entry) => (
                  <Table.Row key={entry.id} className="candystripe">
                    <Table.Cell bold>
                      {entry.index}. {entry.id} ({entry.name})
                    </Table.Cell>
                    {!!multitool && (
                      <Button
                        icon={'times'}
                        disabled={!multitool}
                        onClick={() => act('unlink', { value: entry.index })}
                      />
                    )}
                  </Table.Row>
                ))}
              </Table>
            </Section>
            <Section title="过滤频率">
              <Table>
                {frequencies.map((entry) => (
                  <Table.Row key={frequencies.i} className="candystripe">
                    <Table.Cell bold>{entry / 10} kHz</Table.Cell>
                    <Table.Cell>
                      {RADIO_CHANNELS.find(
                        (channel) => channel.freq === entry,
                      ) && (
                        <Box
                          inline
                          color={
                            RADIO_CHANNELS.find(
                              (channel) => channel.freq === entry,
                            ).color
                          }
                          ml={2}
                        >
                          [
                          {
                            RADIO_CHANNELS.find(
                              (channel) => channel.freq === entry,
                            ).name
                          }{' '}
                          ]
                        </Box>
                      )}
                    </Table.Cell>
                    <Table.Cell />
                    {!!multitool && (
                      <Button
                        icon={'times'}
                        disabled={!multitool}
                        onClick={() => act('delete', { value: entry })}
                      />
                    )}
                  </Table.Row>
                ))}
                {!!multitool && (
                  <Table.Row className="candystripe" collapsing>
                    <Table.Cell>添加频率</Table.Cell>
                    <Table.Cell>
                      {RADIO_CHANNELS.find(
                        (channel) => channel.freq === frequency,
                      ) && (
                        <Box
                          inline
                          color={
                            RADIO_CHANNELS.find(
                              (channel) => channel.freq === frequency,
                            ).color
                          }
                          ml={2}
                        >
                          [
                          {
                            RADIO_CHANNELS.find(
                              (channel) => channel.freq === frequency,
                            ).name
                          }
                          ]
                        </Box>
                      )}
                    </Table.Cell>
                    <Table.Cell>
                      <NumberInput
                        animate
                        unit="kHz"
                        step={0.2}
                        stepPixelSize={10}
                        minValue={minfreq / 10}
                        maxValue={maxfreq / 10}
                        value={frequency / 10}
                        onChange={(value) => act('tempfreq', { value })}
                      />
                    </Table.Cell>
                    <Button
                      icon={'plus'}
                      disabled={!multitool}
                      onClick={() => act('freq')}
                    />
                  </Table.Row>
                )}
              </Table>
            </Section>
            {!!multitool && (
              <Section title="多功能工具">
                {!!multibuff && (
                  <Box bold m={1}>
                    当前缓存: {multibuff}
                  </Box>
                )}
                <LabeledControls m={1}>
                  <Button
                    icon={'plus'}
                    content={'添加机器'}
                    disabled={!multitool}
                    onClick={() => act('buffer')}
                  />
                  <Button
                    icon={'link'}
                    content={'连接'}
                    disabled={!multibuff}
                    onClick={() => act('link')}
                  />
                  <Button
                    icon={'times'}
                    content={'刷新'}
                    disabled={!multibuff}
                    onClick={() => act('flush')}
                  />
                </LabeledControls>
              </Section>
            )}
          </Box>
        )}
      </Window.Content>
    </Window>
  );
};
