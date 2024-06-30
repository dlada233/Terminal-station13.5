import { CheckboxInput, FeatureToggle } from '../base';

export const persistent_scars: FeatureToggle = {
  name: '保留伤疤',
  description: '如果在一轮中存活, 伤疤将在几回合内持续存在.',
  component: CheckboxInput,
};
