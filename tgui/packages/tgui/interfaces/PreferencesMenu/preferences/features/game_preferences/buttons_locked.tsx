import { CheckboxInput, FeatureToggle } from '../base';

export const buttons_locked: FeatureToggle = {
  name: '锁定行动按钮',
  category: 'GAMEPLAY',
  description: '启用时将行动按钮锁定在默认位置.',
  component: CheckboxInput,
};
