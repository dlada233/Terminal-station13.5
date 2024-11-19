import { useBackend } from '../backend';
import { Box, Button, Icon, ProgressBar, Section } from '../components';
import { NtosWindow } from '../layouts';

export const NtosSpectreMeter = (props) => {
  const { act, data } = useBackend();
  const { auto_mode, spook_value, on_cooldown } = data;
  return (
    <NtosWindow width={400} height={180}>
      <NtosWindow.Content>
        <Section title="探灵">
          <Box>
            <Button
              inline
              icon="cog"
              content={auto_mode ? '自动' : '手动'}
              onClick={() => act('toggle_mode')}
              selected={auto_mode}
              tooltip="开关自动扫描，会有些噪音."
            />
            <Button
              inline
              icon="magnifying-glass"
              content="扫描"
              disabled={auto_mode || on_cooldown}
              tooltip="有大约2秒的冷却时间."
              onClick={() => act('manual_scan')}
            />
          </Box>
          <ProgressBar
            value={spook_value}
            maxValue={100}
            ranges={{
              good: [0, 33],
              average: [33, 66],
              bad: [66, 100],
              purple: [100, Infinity],
            }}
          >
            <Box
              lineHeight={1.6}
              fontSize={1.5}
              textAlign="center"
              fontFamily="Comic Sans MS"
              fluid
            >
              <Icon spin name="ghost" />
              {` 灵异能量: ${spook_value}% `}
              <Icon spin name="ghost" />
            </Box>
          </ProgressBar>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
