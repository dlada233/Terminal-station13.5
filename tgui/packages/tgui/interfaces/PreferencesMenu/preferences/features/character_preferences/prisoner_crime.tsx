import { FeatureChoiced } from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const prisoner_crime: FeatureChoiced = {
  name: '罪行',
  description:
    '作为囚犯时, 这里会是你犯下的罪.',
  component: FeatureDropdownInput,
};
