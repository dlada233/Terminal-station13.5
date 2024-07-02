import {
  CheckboxInput,
  Feature,
  FeatureNumberInput,
  FeatureToggle,
} from '../base';

export const enable_tips: FeatureToggle = {
  name: '启用工具提示',
  category: 'TOOLTIPS',
  description: `
    你想不想在你拿着你不会用的工具时给你工具提示?
  `,
  component: CheckboxInput,
};

export const tip_delay: Feature<number> = {
  name: '工具提示延迟(毫秒)',
  category: 'TOOLTIPS',
  description: `
    拿着工具时要花多久才能看到提示?
  `,
  component: FeatureNumberInput,
};
