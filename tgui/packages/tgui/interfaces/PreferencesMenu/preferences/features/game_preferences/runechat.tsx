import {
  CheckboxInput,
  FeatureNumberInput,
  FeatureNumeric,
  FeatureToggle,
} from '../base';

export const chat_on_map: FeatureToggle = {
  name: '生动交流',
  category: 'RUNECHAT',
  description: '说的话将在头上显示.',
  component: CheckboxInput,
};

export const see_chat_non_mob: FeatureToggle = {
  name: '启用物品的生动交流',
  category: 'RUNECHAT',
  description: '物品说的话将在它头上显示.',
  component: CheckboxInput,
};

export const see_rc_emotes: FeatureToggle = {
  name: '生动表情',
  category: 'RUNECHAT',
  description: '表情将在头上显示.',
  component: CheckboxInput,
};

export const max_chat_length: FeatureNumeric = {
  name: '最大生动交流字体长度',
  category: 'RUNECHAT',
  description: '生动交流的最大字体长度限制.',
  component: FeatureNumberInput,
};
