// THIS IS A SKYRAT UI FILE
import { multiline } from 'common/string';

import { CheckboxInput, FeatureToggle } from '../../base';

export const face_cursor_combat_mode: FeatureToggle = {
  name: '战斗状态面朝光标',
  category: 'GAMEPLAY',
  description: multiline`
    开启时, 在战斗模式的情况下始终面朝着你的光标.
  `,
  component: CheckboxInput,
};
