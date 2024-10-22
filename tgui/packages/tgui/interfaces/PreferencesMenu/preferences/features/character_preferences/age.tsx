import { Feature, FeatureNumberInput } from '../base';

export const age: Feature<number> = {
  // name: 'Age', // ORIGINAL
  name: '年龄 (生理年龄)', // SKYRAT EDIT CHANGE - Chronological age
  // SKYRAT EDIT ADDITION BEGIN - Chronological age
  description:
    '生理年龄代表了你的角色在身体和精神上的成长程度，包括正常衰老导致的，也包括通过抗衰老治疗导致逆生长年龄，不包括冷冻休眠度过的时间.',
  // SKYRAT EDIT ADDITION END
  component: FeatureNumberInput,
};
