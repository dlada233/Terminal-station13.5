import { CheckboxInput, FeatureToggle } from '../base';

export const ambientocclusion: FeatureToggle = {
  name: '环境光遮罩',
  category: 'GAMEPLAY',
  description: '启用在角色周围的环境光遮罩.',
  component: CheckboxInput,
};
