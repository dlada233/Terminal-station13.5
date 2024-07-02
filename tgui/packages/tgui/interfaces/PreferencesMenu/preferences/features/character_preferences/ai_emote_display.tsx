import { FeatureIconnedDropdownInput, FeatureWithIcons } from '../dropdowns';

export const preferred_ai_emote_display: FeatureWithIcons<string> = {
  name: 'AI表情显示',
  description:
    '作为AI时将播放到空间站显示屏的表情.',
  component: FeatureIconnedDropdownInput,
};
