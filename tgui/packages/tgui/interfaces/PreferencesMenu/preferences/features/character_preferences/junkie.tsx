import { FeatureChoiced } from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const junkie: FeatureChoiced = {
  name: '成瘾',
  component: FeatureDropdownInput,
};

export const smoker: FeatureChoiced = {
  name: '最爱品牌',
  component: FeatureDropdownInput,
};

export const alcoholic: FeatureChoiced = {
  name: '最爱饮料',
  component: FeatureDropdownInput,
};
