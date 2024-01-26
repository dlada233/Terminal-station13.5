import { CheckboxInputInverse, FeatureToggle } from '../base';

export const hotkeys: FeatureToggle = {
  name: '经典热键',
  category: 'GAMEPLAY',
  description:
    '启用时转换为传统的输入栏热键模式.',
  component: CheckboxInputInverse,
};
