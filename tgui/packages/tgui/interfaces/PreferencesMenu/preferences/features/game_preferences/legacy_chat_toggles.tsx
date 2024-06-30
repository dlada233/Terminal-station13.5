import { CheckboxInput, FeatureToggle } from '../base';

export const chat_bankcard: FeatureToggle = {
  name: '启用收入信息',
  category: 'CHAT',
  description: '接收关于银行账户的信息.'
  component: CheckboxInput,
};

export const chat_dead: FeatureToggle = {
  name: '启用幽灵频道',
  category: 'ADMIN',
  component: CheckboxInput,
};

export const chat_ghostears: FeatureToggle = {
  name: '接收所有信息',
  category: 'GHOST',
  description: `
    启用时将在作为幽灵听到全世界的声音.
    禁用时将只能听到你屏幕范围内的声音.
  `,
  component: CheckboxInput,
};

export const chat_ghostlaws: FeatureToggle = {
  name: '接收法令更变信息',
  category: 'GHOST',
  description: '启用时将接收硅基法令更变信息.',
  component: CheckboxInput,
};

export const chat_ghostpda: FeatureToggle = {
  name: '接收PDA信息',
  category: 'GHOST',
  description: '启用时将接收他人PDA信息.',
  component: CheckboxInput,
};

export const chat_ghostradio: FeatureToggle = {
  name: '接收无线电信息',
  category: 'GHOST',
  description: '启用时接收无线电信息.',
  component: CheckboxInput,
};

export const chat_ghostsight: FeatureToggle = {
  name: '接收表情信息',
  category: 'GHOST',
  description: '启用时将接收所有表情信息.',
  component: CheckboxInput,
};

export const chat_ghostwhisper: FeatureToggle = {
  name: '接收低语信息',
  category: 'GHOST',
  description: `
    启用时将接收全球范围的低语.
    禁用时将只接收屏幕范围内的低语.
  `,
  component: CheckboxInput,
};

export const chat_login_logout: FeatureToggle = {
  name: '接收玩家上下线信息',
  category: 'GHOST',
  description: 'When enabled, be notified when a player logs in or out.',
  component: CheckboxInput,
};

export const chat_ooc: FeatureToggle = {
  name: '启用OOC',
  category: 'CHAT',
  component: CheckboxInput,
};

export const chat_prayer: FeatureToggle = {
  name: '接收祈祷信息',
  category: 'ADMIN',
  component: CheckboxInput,
};

export const chat_pullr: FeatureToggle = {
  name: '启用PR提醒',
  category: 'CHAT',
  description: '启用时接收pull requests信息.',
  component: CheckboxInput,
};
