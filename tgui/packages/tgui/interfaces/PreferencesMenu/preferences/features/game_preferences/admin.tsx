import {
  CheckboxInput,
  Feature,
  FeatureColorInput,
  FeatureToggle,
} from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const asaycolor: Feature<string> = {
  name: '管理员聊天颜色',
  category: 'ADMIN',
  description: '在管理员频道的字体颜色.',
  component: FeatureColorInput,
};

export const brief_outfit: Feature<string> = {
  name: '临时装配',
  category: 'ADMIN',
  description: '在重生为临时用人员的时候的装配.',
  component: FeatureDropdownInput,
};

export const bypass_deadmin_in_centcom: FeatureToggle = {
  name: '作为Centcom时保留管理员',
  category: 'ADMIN',
  description: '作为Centcom人员时是否保留管理员身份.',
  component: CheckboxInput,
};

export const fast_mc_refresh: FeatureToggle = {
  name: '启用MC选项卡快速刷新',
  category: 'ADMIN',
  description: '启用MC面板的快速刷新, 这可能会导致延迟所以确保你需要再启用.',
  component: CheckboxInput,
};

export const ghost_roles_as_admin: FeatureToggle = {
  name: '在启用管理员时允许参加幽灵轮',
  category: 'ADMIN',
  description: `
    禁用时无论是否是管理员都将在有幽灵轮时提醒.
    启用时将在你作为管理员时不提醒幽灵轮.
`,
  component: CheckboxInput,
};

export const comms_notification: FeatureToggle = {
  name: '启用comms面板音效',
  category: 'ADMIN',
  component: CheckboxInput,
};
