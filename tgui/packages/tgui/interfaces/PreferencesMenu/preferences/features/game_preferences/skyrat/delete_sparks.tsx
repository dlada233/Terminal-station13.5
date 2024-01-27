// THIS IS A SKYRAT UI FILE
import { CheckboxInput, FeatureToggle } from '../../base';

export const delete_sparks_pref: FeatureToggle = {
  name: '删除火花',
  category: 'ADMIN',
  description:
    '开关在进行指令删除时的火花动画效果.',
  component: CheckboxInput,
};
