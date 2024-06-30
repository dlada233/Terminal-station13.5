import { Feature } from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const mod_select: Feature<string> = {
  name: '模块启用按键',
  category: 'GAMEPLAY',
  description: '启用模块服模块时的按键.',
  component: FeatureDropdownInput,
};
