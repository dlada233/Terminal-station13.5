import {
  CheckboxInput,
  Feature,
  FeatureChoiced,
  FeatureColorInput,
  FeatureToggle,
} from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const screentip_color: Feature<string> = {
  name: '小提示: 小提示颜色',
  category: 'UI',
  description: `
    The color of screen tips, the text you see when hovering over something.
  `,
  component: FeatureColorInput,
};

export const screentip_images: FeatureToggle = {
  name: '小提示: 允许图像',
  category: 'UI',
  description: `When enabled, screentip hints use images for
    the mouse button rather than LMB/RMB.`,
  component: CheckboxInput,
};

export const screentip_pref: FeatureChoiced = {
  name: '小提示: 启用小提示',
  category: 'UI',
  description: `
    启用那些需要你将光标放置于上才能显示的额外信息文本.
  `,
  component: FeatureDropdownInput,
};
