import { Feature, FeatureColorInput } from '../base';

export const ooccolor: Feature<string> = {
  name: 'OOC颜色',
  category: 'CHAT',
  description: 'OOC的颜色.',
  component: FeatureColorInput,
};
