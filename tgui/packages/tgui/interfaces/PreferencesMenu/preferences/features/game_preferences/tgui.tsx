import { CheckboxInput, FeatureToggle } from '../base';

export const tgui_fancy: FeatureToggle = {
  name: '启用精致TGUI',
  category: 'UI',
  description: '让TGUI更好看, 降低兼容性.',
  component: CheckboxInput,
};

export const tgui_input: FeatureToggle = {
  name: '输入框: 启用TGUI',
  category: 'UI',
  description: '将输入框替换为TGUI.',
  component: CheckboxInput,
};

export const tgui_input_large: FeatureToggle = {
  name: '输入框: 大按钮',
  category: 'UI',
  description: '让TGUI按钮更具功能性.',
  component: CheckboxInput,
};

export const tgui_input_swapped: FeatureToggle = {
  name: '输入框: 交换 提交/取消 按钮',
  category: 'UI',
  description: '让TGUI按钮更具功能性.',
  component: CheckboxInput,
};

export const tgui_lock: FeatureToggle = {
  name: '锁定TGUI到你的主显示器',
  category: 'UI',
  description: '锁定TGUI到你的主显示器.',
  component: CheckboxInput,
};

export const tgui_say_light_mode: FeatureToggle = {
  name: '交流: 亮色模式',
  category: 'UI',
  description: '将交流TGUI切换为亮色模式.',
  component: CheckboxInput,
};
