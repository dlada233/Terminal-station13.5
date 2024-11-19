import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Collapsible,
  Divider,
  Dropdown,
  NumberInput,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

type Data = {
  using_instrument: string;
  note_shift_min: number;
  note_shift_max: number;
  note_shift: number;
  octaves: number;
  sustain_modes: string[];
  sustain_mode: string;
  sustain_mode_button: string;
  sustain_mode_duration: number;
  instrument_ready: BooleanLike;
  volume: number;
  volume_dropoff_threshold: number;
  min_volume: number;
  max_volume: number;
  sustain_indefinitely: BooleanLike;
  sustain_mode_min: number;
  sustain_mode_max: number;
  playing: BooleanLike;
  max_repeats: number;
  repeat: number;
  bpm: number;
  lines: LineData[];
  can_switch_instrument: BooleanLike;
  possible_instruments: InstrumentData[];
  max_line_chars: number;
  max_lines: number;
};

type InstrumentData = {
  name: string;
  id: string;
};

type LineData = {
  line_count: number;
  line_text: string;
};

export const InstrumentEditor = (props) => {
  const { data } = useBackend<Data>();

  return (
    <Window width={750} height={500}>
      <Window.Content scrollable>
        <InstrumentSettings />
        <Collapsible open title="音乐编辑器" icon="pencil">
          <EditingSettings />
        </Collapsible>
        <Collapsible title="帮助部分" icon="question">
          <HelpSection />
        </Collapsible>
      </Window.Content>
    </Window>
  );
};

const InstrumentSettings = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    playing,
    repeat,
    max_repeats,
    can_switch_instrument,
    possible_instruments = [],
    instrument_ready,
    using_instrument,
    note_shift_min,
    note_shift_max,
    note_shift,
    octaves,
    sustain_modes,
    sustain_mode,
    sustain_mode_button,
    sustain_mode_duration,
    sustain_indefinitely,
    sustain_mode_min,
    sustain_mode_max,
    volume,
    min_volume,
    max_volume,
    volume_dropoff_threshold,
    lines,
  } = data;

  const instrument_id_by_name = (name) => {
    return possible_instruments.find((instrument) => instrument.name === name)
      ?.id;
  };

  return (
    <Section title="设置">
      {lines.length > 0 && (
        <Box fontSize="16px">
          <Button onClick={() => act('play_music')}>
            {playing ? '停止音乐' : '开始演奏'}
          </Button>
        </Box>
      )}
      <Box>
        重复剩余:
        <NumberInput
          step={1}
          minValue={0}
          disabled={playing}
          maxValue={max_repeats}
          value={repeat}
          onChange={(value) =>
            act('set_repeat_amount', {
              amount: value,
            })
          }
        />
      </Box>
      <Box>
        {!!can_switch_instrument && (
          <Stack fill>
            <Stack.Item mt={0.5}>使用乐器</Stack.Item>
            <Stack.Item grow>
              <Dropdown
                width="40%"
                selected={using_instrument}
                disabled={!can_switch_instrument}
                options={possible_instruments.map(
                  (instrument) => instrument.name,
                )}
                onSelected={(value) =>
                  act('change_instrument', {
                    new_instrument: instrument_id_by_name(value),
                  })
                }
              />
            </Stack.Item>
          </Stack>
        )}
      </Box>
      <Stack mt={1}>
        <Stack.Item>
          回放设置:
          <Box>
            <NumberInput
              minValue={note_shift_min}
              maxValue={note_shift_max}
              step={1}
              value={note_shift}
              onChange={(value) =>
                act('set_note_shift', {
                  amount: value,
                })
              }
            />
            键 / {octaves} 八度
          </Box>
          <Stack>
            <Stack.Item mt={0.5}>Mode:</Stack.Item>
            <Stack.Item grow>
              <Dropdown
                width="100%"
                selected={sustain_mode}
                options={sustain_modes}
                onSelected={(value) =>
                  act('set_sustain_mode', {
                    new_mode: value,
                  })
                }
              />
            </Stack.Item>
          </Stack>
          <Box>
            {sustain_mode_button}:
            <NumberInput
              step={1}
              minValue={sustain_mode_min}
              maxValue={sustain_mode_max}
              value={sustain_mode_duration}
              onChange={(value) =>
                act('edit_sustain_mode', {
                  amount: value,
                })
              }
            />
          </Box>
        </Stack.Item>
        <Divider vertical />
        <Stack.Item>
          <Box>
            状态:
            {instrument_ready ? (
              <span style={{ color: '#5EFB6E' }}> 准备就绪</span>
            ) : (
              <span style={{ color: '#FF0000' }}> 乐器定义错误!</span>
            )}
          </Box>
          <Box>
            音量:
            <NumberInput
              step={1}
              minValue={min_volume}
              maxValue={max_volume}
              value={volume}
              onChange={(value) =>
                act('set_volume', {
                  amount: value,
                })
              }
            />
          </Box>
          <Box>
            音量衰减阈值:
            <NumberInput
              step={1}
              minValue={1}
              maxValue={100}
              value={volume_dropoff_threshold}
              onChange={(value) =>
                act('set_dropoff_volume', {
                  amount: value,
                })
              }
            />
          </Box>
          <Box>
            <Button onClick={() => act('toggle_sustain_hold_indefinitely')}>
              {sustain_indefinitely
                ? '无限期地保持最后按下的音符'
                : '不会无限期地保持最后按下的音符'}
            </Button>
          </Box>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const EditingSettings = (props) => {
  const { act, data } = useBackend<Data>();
  const { bpm, lines } = data;

  return (
    <Section>
      <Box>
        <Button onClick={() => act('start_new_song')}>开始演奏新的歌曲</Button>
        <Button onClick={() => act('import_song')}>导入歌曲</Button>
      </Box>
      <Box>
        节拍:{' '}
        <Button
          onClick={() => act('tempo', { tempo_change: 'increase_speed' })}
        >
          -
        </Button>{' '}
        {bpm} BPM{' '}
        <Button
          onClick={() => act('tempo', { tempo_change: 'decrease_speed' })}
        >
          +
        </Button>
      </Box>
      <Box>
        {lines.map((line, index) => (
          <Box key={index} fontSize="11px">
            Line {index}:
            <Button
              onClick={() =>
                act('modify_line', { line_editing: line.line_count })
              }
            >
              编辑
            </Button>
            <Button
              onClick={() =>
                act('delete_line', { line_deleted: line.line_count })
              }
            >
              X
            </Button>
            {line.line_text}
          </Box>
        ))}
      </Box>
      <Box>
        <Button onClick={() => act('add_new_line')}>Add Line</Button>
      </Box>
    </Section>
  );
};

const HelpSection = (props) => {
  const { data } = useBackend<Data>();
  const { max_line_chars, max_lines } = data;

  return (
    <Section>
      <Box>
        Line是由一系列和弦组成的，和弦之间用逗号(,)分隔，每个和弦中的音符用连字符(-)分隔。.
        <br />
        每个和弦中的音符会同时播放，和弦的时长由节拍决定.
        <br />
        音符通过音符名称来播放，并且可以选择性地加上变音记号（如升号、降号等）以及八度编号.
        <br />
        默认情况下，每个音符都是自然音高且在第三八度.
        如果另有定义，每个音符都会记住其特定属性.
        <br />
        例如: <i>C,D,E,F,G,A,B</i> 将播放一个C大调音阶.
        <br />
        一旦给音符添加了变音记号，该记号就会被记住: <i>
          C,C4,C,C3
        </i> 将播放为 <i>C3,C4,C4,C3</i>
        <br />
        和弦可以通过用连字符分隔每个音符来播放: <i>A-C#,Cn-E,E-G#,Gn-B</i>
        <br />
        暂停可以用空和弦来表示: <i>C,E,,C,G</i>
        <br />
        要使和弦的时长不同，可以在和弦后加上/x，其中x表示和弦的长度是节拍定义长度的多少分之一:{' '}
        <i>C,G/2,E/4</i>
        <br />
        综合起来，例子是: <i>E-E4/4,F#/2,G#/8,B/8,E3-E4/4</i>
        <br />
        Line的长度最多可达{max_line_chars}字符.
        <br />
        一首歌最多只能包含{max_lines}line.
        <br />
      </Box>
    </Section>
  );
};

/*
Lines are a series of chords, separated by commas (,), each with notes separated by hyphens (-).
Every note in a chord will play together, with chord timed by the tempo.
Notes are played by the names of the note, and optionally, the accidental, and/or the octave number.
By default, every note is natural and in octave 3. Defining otherwise is remembered for each note.
Example: C,D,E,F,G,A,B will play a C major scale.
After a note has an accidental placed, it will be remembered: C,C4,C,C3 is C3,C4,C4,C3
Chords can be played simply by seperating each note with a hyphon: A-C#,Cn-E,E-G#,Gn-B
A pause may be denoted by an empty chord: C,E,,C,G
To make a chord be a different time, end it with /x, where the chord length will be length
defined by tempo / x: C,G/2,E/4
Combined, an example is: E-E4/4,F#/2,G#/8,B/8,E3-E4/4
Lines may be up to 300 characters.
A song may only contain up to 1000 lines.
*/
