import { sortBy } from 'common/collections';

import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import {
  Box,
  Button,
  Dropdown,
  Knob,
  LabeledControls,
  LabeledList,
  Section,
} from '../components';
import { Window } from '../layouts';

type Song = {
  name: string;
  length: number;
  beat: number;
};

type Data = {
  active: BooleanLike;
  looping: BooleanLike;
  volume: number;
  track_selected: string | null;
  songs: Song[];
};

export const Jukebox = () => {
  const { act, data } = useBackend<Data>();
  const { active, looping, track_selected, volume, songs } = data;

  const songs_sorted: Song[] = sortBy(songs, (song: Song) => song.name);
  const song_selected: Song | undefined = songs.find(
    (song) => song.name === track_selected,
  );

  return (
    <Window width={370} height={313}>
      <Window.Content>
        <Section
          title="歌曲播放器"
          buttons={
            <>
              <Button
                icon={active ? 'pause' : 'play'}
                content={active ? '停止' : '播放'}
                selected={active}
                onClick={() => act('toggle')}
              />
              <Button.Checkbox
                icon={'arrow-rotate-left'}
                content="重复"
                disabled={active}
                checked={looping}
                onClick={() => act('loop', { looping: !looping })}
              />
            </>
          }
        >
          <LabeledList>
            <LabeledList.Item label="歌曲选择">
              <Dropdown
                width="240px"
                options={songs_sorted.map((song) => song.name)}
                disabled={!!active}
                selected={song_selected?.name || '选择一首歌曲'}
                onSelected={(value) =>
                  act('select_track', {
                    track: value,
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="歌曲时长">
              {song_selected?.length || '未选择歌曲'}
            </LabeledList.Item>
            <LabeledList.Item label="歌曲节奏">
              {song_selected?.beat || '未选择歌曲节奏'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="机器设置">
          <LabeledControls justify="center">
            <LabeledControls.Item label="音量">
              <Box position="relative">
                <Knob
                  size={3.2}
                  color={volume >= 25 ? 'red' : 'green'}
                  value={volume}
                  unit="%"
                  minValue={0}
                  maxValue={100}
                  step={1}
                  stepPixelSize={1}
                  onDrag={(e, value) =>
                    act('set_volume', {
                      volume: value,
                    })
                  }
                />
                <Button
                  fluid
                  position="absolute"
                  top="-2px"
                  right="-22px"
                  color="transparent"
                  icon="fast-backward"
                  onClick={() =>
                    act('set_volume', {
                      volume: 'min',
                    })
                  }
                />
                <Button
                  fluid
                  position="absolute"
                  top="16px"
                  right="-22px"
                  color="transparent"
                  icon="fast-forward"
                  onClick={() =>
                    act('set_volume', {
                      volume: 'max',
                    })
                  }
                />
                <Button
                  fluid
                  position="absolute"
                  top="34px"
                  right="-22px"
                  color="transparent"
                  icon="undo"
                  onClick={() =>
                    act('set_volume', {
                      volume: 'reset',
                    })
                  }
                />
              </Box>
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
      </Window.Content>
    </Window>
  );
};
