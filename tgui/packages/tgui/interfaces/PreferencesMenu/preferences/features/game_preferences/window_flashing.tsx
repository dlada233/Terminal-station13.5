import { CheckboxInput, FeatureToggle } from '../base';

export const windowflashing: FeatureToggle = {
  name: '启用窗口闪烁',
  category: 'UI',
  description: `
    启用时将在有重要事件时提醒你的窗口.
  `,
  component: CheckboxInput,
};
