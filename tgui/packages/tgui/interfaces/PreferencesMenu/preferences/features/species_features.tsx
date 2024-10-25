import {
  Feature,
  FeatureChoiced,
  FeatureChoicedServerData,
  FeatureColorInput,
  FeatureValueProps,
} from './base';
import { FeatureDropdownInput } from './dropdowns';

export const eye_color: Feature<string> = {
  name: '瞳色',
  component: FeatureColorInput,
};

export const facial_hair_color: Feature<string> = {
  name: '胡须颜色',
  component: FeatureColorInput,
};

export const facial_hair_gradient: FeatureChoiced = {
  name: '胡须颜色渐变',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const facial_hair_gradient_color: Feature<string> = {
  name: '胡须渐变颜色',
  component: FeatureColorInput,
};

export const hair_color: Feature<string> = {
  name: '发色',
  component: FeatureColorInput,
};

export const hair_gradient: FeatureChoiced = {
  name: '渐变染发',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const hair_gradient_color: Feature<string> = {
  name: '渐变染发色',
  component: FeatureColorInput,
};

export const feature_human_ears: FeatureChoiced = {
  name: '耳朵',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const feature_human_tail: FeatureChoiced = {
  name: '尾巴',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const feature_monkey_tail: FeatureChoiced = {
  name: '尾巴',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const feature_lizard_legs: FeatureChoiced = {
  name: '腿',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const feature_lizard_spines: FeatureChoiced = {
  name: '脊柱',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const feature_lizard_tail: FeatureChoiced = {
  name: '尾巴',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};

export const feature_mcolor: Feature<string> = {
  name: '突变色',
  component: FeatureColorInput,
};

export const underwear_color: Feature<string> = {
  name: '内衣颜色',
  component: FeatureColorInput,
};

export const bra_color: Feature<string> = {
  name: '胸罩颜色',
  component: FeatureColorInput,
};

export const feature_vampire_status: Feature<string> = {
  name: '吸血鬼状态',
  component: FeatureDropdownInput,
};

export const heterochromatic: Feature<string> = {
  name: '异色瞳色(右瞳)',
  component: FeatureColorInput,
};
