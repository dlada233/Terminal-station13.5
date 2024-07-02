import { CheckboxInput, FeatureToggle } from '../base';

export const broadcast_login_logout: FeatureToggle = {
  name: '提醒登录/退出',
  category: 'GAMEPLAY',
  description: `
    启用时将在登录或退出游戏时在幽灵频道提醒一条信息.
  `,
  component: CheckboxInput,
};
