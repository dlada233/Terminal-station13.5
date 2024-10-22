// THIS IS A SKYRAT UI FILE
import { Feature, FeatureChoiced, FeatureShortTextInput } from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const pet_owner: FeatureChoiced = {
  name: '宠物主人',
  component: FeatureDropdownInput,
};

export const pet_name: Feature<string> = {
  name: '宠物名称',
  description: "如果为空，将使用生物默认名称，如 'axolotl' 或 'chinchilla'.",
  component: FeatureShortTextInput,
};

export const pet_desc: Feature<string> = {
  name: '宠物描述',
  description: '如果为空，将使用生物默认描述.',
  component: FeatureShortTextInput,
};
