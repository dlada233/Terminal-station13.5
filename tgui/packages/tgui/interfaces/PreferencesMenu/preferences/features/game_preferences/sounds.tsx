import {
  CheckboxInput,
  Feature,
  FeatureChoiced,
  FeatureSliderInput,
  FeatureToggle,
} from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const sound_ambience: FeatureToggle = {
  name: '启用环境音效',
  category: 'SOUND',
  description: `Ambience refers to the more noticeable ambient sounds that play on occasion.`,
  component: CheckboxInput,
};

export const sound_announcements: FeatureToggle = {
  name: '启用通知音效',
  category: 'SOUND',
  description: '启用时将听到通知, 警报等等的音效.',
  component: CheckboxInput,
};

export const sound_combatmode: FeatureToggle = {
  name: '启用战斗模式音效',
  category: 'SOUND',
  description: '启用时将在战斗模式启用时触发音效.',
  component: CheckboxInput,
};

export const sound_endofround: FeatureToggle = {
  name: '启用游戏结束音效',
  category: 'SOUND',
  description: '启用时将在服务器开始重启时播放结束音效.',
  component: CheckboxInput,
};

export const sound_instruments: FeatureToggle = {
  name: '启用乐器声音',
  category: 'SOUND',
  description: '启用时将能在游戏内听到乐器演奏.',
  component: CheckboxInput,
};

export const sound_tts: FeatureChoiced = {
  name: '启用TTS',
  category: 'SOUND',
  description: `
    When enabled, be able to hear text-to-speech sounds in game.
    When set to "Blips", text to speech will be replaced with blip sounds based on the voice.
  `,
  component: FeatureDropdownInput,
};

export const sound_tts_volume: Feature<number> = {
  name: 'TTS音量',
  category: 'SOUND',
  description: 'The volume that the text-to-speech sounds will play at.',
  component: FeatureSliderInput,
};

export const sound_jukebox: FeatureToggle = {
  name: '启用点唱机音乐',
  category: 'SOUND',
  description: '启用时将能够听到点唱机播放的音乐.',
  component: CheckboxInput,
};

export const sound_lobby: FeatureToggle = {
  name: '启用大厅音乐',
  category: 'SOUND',
  component: CheckboxInput,
};

export const sound_midi: FeatureToggle = {
  name: '启用管理员音乐',
  category: 'SOUND',
  description: '启用时管理员能够播放音乐给你.',
  component: CheckboxInput,
};

export const sound_ship_ambience: FeatureToggle = {
  name: '启用飞船氛围音',
  category: 'SOUND',
  component: CheckboxInput,
  description: `Ship ambience refers to the low ambient buzz that plays on loop.`,
};

export const sound_elevator: FeatureToggle = {
  name: '启用电梯音效',
  category: 'SOUND',
  component: CheckboxInput,
};

export const sound_achievement: FeatureChoiced = {
  name: '启用成就解锁音效',
  category: 'SOUND',
  description: `
    The sound that's played when unlocking an achievement.
    If disabled, no sound will be played.
  `,
  component: FeatureDropdownInput,
};
