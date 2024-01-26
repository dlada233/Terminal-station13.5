// THIS IS A SKYRAT UI FILE
import { CheckboxInput, FeatureToggle } from '../../base';

export const emote_panel: FeatureToggle = {
  name: '表情面板',
  category: 'CHAT',
  description: '启用表情面板 (若在游戏内启用则需要重连游戏)',
  component: CheckboxInput,
};
