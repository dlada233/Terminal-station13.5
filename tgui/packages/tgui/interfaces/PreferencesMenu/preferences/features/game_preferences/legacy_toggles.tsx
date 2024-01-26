import { multiline } from 'common/string';

import { CheckboxInput, CheckboxInputInverse, FeatureToggle } from '../base';

export const admin_ignore_cult_ghost: FeatureToggle = {
  name: '阻止被血教徒召唤',
  category: 'ADMIN',
  description: multiline`
    启用时将禁止被血教的幽灵召唤仪式召唤.
  `,
  component: CheckboxInput,
};

export const announce_login: FeatureToggle = {
  name: '上线提醒',
  category: 'ADMIN',
  description: '启用时通知其他管理员你的上线.',
  component: CheckboxInput,
};

export const combohud_lighting: FeatureToggle = {
  name: '开启全HUD',
  category: 'ADMIN',
  component: CheckboxInput,
};

export const deadmin_always: FeatureToggle = {
  name: '自我取消管理 - 一直',
  category: 'ADMIN',
  description: '启用时将自动取消管理员身份.',
  component: CheckboxInput,
};

export const deadmin_antagonist: FeatureToggle = {
  name: '自我取消管理 - 反派',
  category: 'ADMIN',
  description: '启用时将在作为反派时取消管理员身份.',
  component: CheckboxInput,
};

export const deadmin_position_head: FeatureToggle = {
  name: '自我取消管理 - 部长',
  category: 'ADMIN',
  description:
    '启用时将在作为部长时取消管理员身份.',
  component: CheckboxInput,
};

export const deadmin_position_security: FeatureToggle = {
  name: '自我取消管理 - 安保',
  category: 'ADMIN',
  description:
    '启用时将在作为安保时取消管理员身份.',
  component: CheckboxInput,
};

export const deadmin_position_silicon: FeatureToggle = {
  name: '自我取消管理 - 硅基',
  category: 'ADMIN',
  description: '启用时将在作为硅基时取消管理员身份.',
  component: CheckboxInput,
};

export const disable_arrivalrattle: FeatureToggle = {
  name: '接收新船员信息',
  category: 'GHOST',
  description: '启用时将接收新船员入站时的信息.',
  component: CheckboxInputInverse,
};

export const disable_deathrattle: FeatureToggle = {
  name: '接收死亡信息',
  category: 'GHOST',
  description:
    '启用时将接收某人死亡时的信息.',
  component: CheckboxInputInverse,
};

export const member_public: FeatureToggle = {
  name: '公开BYOND会员身份',
  category: 'CHAT',
  description:
    '启用时将在OOC中表面你是个BYOND会员(如果你是).',
  component: CheckboxInput,
};

export const sound_adminhelp: FeatureToggle = {
  name: '启用管理员帮助音效',
  category: 'ADMIN',
  component: CheckboxInput,
};

export const sound_prayers: FeatureToggle = {
  name: '启用祈祷音效',
  category: 'ADMIN',
  component: CheckboxInput,
};

export const split_admin_tabs: FeatureToggle = {
  name: '分离管理员选项卡',
  category: 'ADMIN',
  description: "启用时将拆分管理员选项卡分类.",
  component: CheckboxInput,
};
