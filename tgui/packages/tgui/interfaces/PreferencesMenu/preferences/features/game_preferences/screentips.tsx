import { multiline } from 'common/string';

import {
  CheckboxInput,
  Feature,
  FeatureChoiced,
  FeatureColorInput,
  FeatureDropdownInput,
  FeatureToggle,
} from '../base';

export const screentip_color: Feature<string> = {
  name: '小提示: 小提示颜色',
  category: 'UI',
  description: multiline`
    The color of screen tips, the text you see when hovering over something.
  `,
  component: FeatureColorInput,
};

export const screentip_images: FeatureToggle = {
  name: '小提示: 允许图像',
  category: 'UI',
  description: multiline`When enabled, screentip hints use images for
    the mouse button rather than LMB/RMB.`,
  component: CheckboxInput,
};

export const screentip_pref: FeatureChoiced = {
  name: '小提示: 启用小提示',
  category: 'UI',
  description: multiline`
    启用那些需要你将光标放置于上才能显示的额外信息文本.
  `,
  component: FeatureDropdownInput,
};
