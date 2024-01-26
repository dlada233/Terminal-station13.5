import { multiline } from 'common/string';

import { CheckboxInput, FeatureToggle } from '../base';

export const darkened_flash: FeatureToggle = {
  name: '替换闪光白屏',
  category: 'GAMEPLAY',
  description: multiline`
    启用时将被闪光时的白屏改为护眼的黑屏.
  `,
  component: CheckboxInput,
};
